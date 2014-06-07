#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>
#include <util/delay.h>
#include <stdlib.h>
#include "si2c_slave.h"
#include "debug.h"

#define RECALIB PD1

volatile uint16_t current_pos;
volatile uint16_t target_pos;
volatile uint16_t steps_until_done;

/* configuration */

uint8_t conf_steps_per_num;
uint8_t conf_numbers;
uint16_t conf_steps_total;
uint8_t conf_offset;
uint8_t conf_address;

extern uint8_t __eerd_byte_tn2313(uint8_t *);
static uint8_t eerd(uint8_t addr) {
	/* avr-libc in the version I used did not properly declare eeprom read
	 * functions for the tiny2313A. therefore, this hack
	 */
	return __eerd_byte_tn2313((uint8_t*) addr);
}

static void config_read() {
	conf_steps_per_num = eerd(1);
	conf_numbers = eerd(2);
	conf_offset = eerd(3);
	conf_address = eerd(4);

	conf_steps_total = conf_steps_per_num * conf_numbers;
}





/* light sensor for finding start position */

#define LZERO PB1

static void lightsensor_init() {
	DDRB &= ~(1 << LZERO); /* configure pin as input */
	PORTB |= (1 << LZERO); /* with pull-up enabled */

	GIMSK |= (1 << 5 /* PCIE0 */);
	PCMSK /* 0 */ |= (1 << PCINT1);
}

static int lightsensor_is_blocked() {
	return PINB & (1 << LZERO);
}

ISR (PCINT_B_vect) {
	/* PB1! */
	if (!lightsensor_is_blocked() && current_pos > conf_steps_per_num) {
		current_pos = 0;
	}
}


/* stepper motor control */

#define VREF1_0 PA1
#define VREF1_5 PA0
#define VREF2_0 PD3
#define VREF2_5 PD2
#define STEP PB2

static void motor_current_active() {
	/* disable vref2 */
	DDRD &= ~( (1 << VREF2_0) | (1 << VREF2_5) );
	PORTD &= ~(1 << VREF2_5);

	/* enable vref1 */
	DDRA |= (1 << VREF1_0) | (1 << VREF1_5);
	PORTA |= (1 << VREF1_5);
}

static void motor_current_idle() {
	/* disable vref1 */
	DDRA &= ~( (1 << VREF1_0) | (1 << VREF1_5) );
	PORTA &= ~(1 << VREF1_5);

	/* enable vref2 */
	DDRD |= (1 << VREF2_0) | (1 << VREF2_5);
	PORTD |= (1 << VREF2_5);
}

static void motor_step() {
	PORTB |= (1 << STEP);
	_delay_us(10);
	PORTB &= ~(1 << STEP);
	_delay_us(10);
}

#define DIR PB0
#define FCHOP PB4
#define H_F PB3

static void motor_init() {
	DDRB |= (1 << STEP) | (1 << H_F) | (1 << FCHOP) | (1 << DIR);
	PORTB |= (1 << DIR);

	/* Configure Timer1 to output about 30 kHz on OC1B / PB4 / pin 16.
	 * L297 uses this signal to limit motor current
	 */
	TCCR1A = (1 << COM1B0);
	TCCR1B = (1 << WGM12) | (1 << CS11);
	TCCR1C = (1 << FOC1B);
	OCR1A = 0x10;
	#if F_CPU != 8000000
	#warning Hardcoded value for OCR1A is only correct for 8 MHz clock, please check
	#endif
}

static void find_start_position() {
	motor_current_active();

	/* Move until we find the hole in the wheel.
	 * The hole identifies a position between digits 9 and 0.
	 */
	while (lightsensor_is_blocked()) {
		motor_step();
		_delay_ms(9);
		/* FIXME: will position incorrectly if stopped over marking at powerup.
		 * maybe force it to get blocked first, then unblocked?
		 */
	}

	/* Move by configured offset, so we display number zero
	 * (the mark on the wheel is between 9 and 0)
	 */
	for (int i = 0; i < conf_offset; i++) {
		motor_step();
		_delay_ms(13);
	}

	/* Record our current position */
	current_pos = conf_offset;
	target_pos = conf_offset;
	steps_until_done = 0;

	motor_current_idle();

	_delay_ms(100);
}


void update_target(uint16_t new_target) {
	target_pos = new_target;

	steps_until_done = conf_steps_total + target_pos - current_pos;
	if (steps_until_done >= conf_steps_total) {
		steps_until_done -= conf_steps_total;
	}
}

void si2cs_received(uint8_t *buf, uint8_t len) {
	if (len != 3) return;

	if (buf[0] == 0xba) {
		if (buf[1] == conf_address) {
			uint16_t new_target = (buf[2] * conf_steps_per_num + conf_offset);
			if (new_target > conf_steps_total) {
				new_target -= conf_steps_total;
			}
			update_target(new_target);
		}
	}
}


void init_disable_watchdog() __attribute__((naked)) __attribute__((section(".init3")));
void init_disable_watchdog() {
	MCUSR = 0;
	wdt_disable();
}

int main (void) {
	debug_init();

	config_read();

	motor_init();
	lightsensor_init();

	find_start_position();

	debug_fstr("done");
	lcd_setcursor(2,2);
	debug_fstr("durr ");
	debug_hex8(conf_address);

	/* now listen on the bus and wait for data */
	si2cs_init();
	sei();

	/* we're done with setup. activate watchdog */
	wdt_enable(WDTO_4S);

	while (1) {
		/* moving to a new position */

		motor_current_active();

		uint16_t steps_since_start = 0;

		while (current_pos != target_pos) {
			/* do one step */
			motor_step();

			/* update current position.
			 * overflow of the current position is handled by the
			 * light sensor interrupt
			 */
			current_pos++;

			/* acceleration */
			if (steps_since_start > 20 && steps_until_done > 20) {
				_delay_ms(3);
			} else if (steps_since_start > 10 && steps_until_done > 10) {
				_delay_ms(6);
			} else if (steps_since_start > 5 && steps_until_done > 5) {
				_delay_ms(9);
			} else {
				_delay_ms(10);
			}
			steps_since_start++;
			steps_until_done--;

			wdt_reset();
		}

		/* holding the current position */

		motor_current_idle();

		while (current_pos == target_pos) {
			_delay_ms(20);

			wdt_reset();
		}
	}
}
