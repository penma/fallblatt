#include <avr/io.h>
#include <util/delay.h>
#include "si2c_master.h"

#define CLOCK_BIT PB3
#define DATA_BIT PB2

void si2cm_init() {
	DDRB |= (1 << CLOCK_BIT) | (1 << DATA_BIT);
	PORTB &= ~( (1 << CLOCK_BIT) | (1 << DATA_BIT) );
}

void si2cm_xfer(uint8_t *buf, uint8_t bufsize) {
	for (int i = 0; i < bufsize; i++) {
		uint8_t cb = buf[i];
		for (int b = 0; b < 8; b++) {
			if (cb & 0x80) {
				PORTB |= (1 << DATA_BIT);
			} else {
				PORTB &= ~(1 << DATA_BIT);
			}
			cb <<= 1;

			PORTB |= (1 << CLOCK_BIT);
			_delay_us(40);
			if ((i+1) < bufsize || b < 7) {
				PORTB &= ~(1 << DATA_BIT);
				_delay_us(10);
			} else {
				PORTB |= 1 << DATA_BIT;
			}
			PORTB &= ~(1 << CLOCK_BIT);
			_delay_us(20);
		}
	}
	PORTB &= ~(1 << DATA_BIT);
}
