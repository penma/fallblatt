#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdlib.h>

#include "twi_smaster.h"
#include "si2c_master.h"
#include "debug.h"
#include "taster.h"

#define DS1307_ADDR 0b11010000

#define DS1307_REG_CONTROL 7

#define CLOCKMOD_TEST_ADDR 0b10001100

#define HIGH(x) ( (x) >> 4 )
#define LOW(x) ( (x) & 0b1111 )

static void ds1307_write_reg(uint8_t reg, uint8_t v) {
	uint8_t buf[3] = { DS1307_ADDR, reg, v };
	twim_xfer(buf, 3);
}

static uint8_t ds1307_read_reg(uint8_t reg) {
	uint8_t buf[2] = { DS1307_ADDR, reg };
	twim_xfer(buf, 2);
	buf[0] |= (1 << TWI_READ_BIT);
	twim_xfer(buf, 2);
	return buf[1];
}

static void ds1307_read_time(uint8_t *time) {
	uint8_t buf[10];
	buf[0] = DS1307_ADDR;
	buf[1] = 0x3f;
	twim_xfer(buf, 2);
	buf[0] |= (1 << TWI_READ_BIT);
	twim_xfer(buf, 10);

	time[0] = HIGH(buf[1]);
	time[1] = LOW(buf[1]);
	time[2] = HIGH(buf[8]);
	time[3] = LOW(buf[8]);

	time[4] = HIGH(buf[7]);
	time[5] = LOW(buf[7]);

	time[6] = HIGH(buf[6]);
	time[7] = LOW(buf[6]);

	time[8] = HIGH(buf[4]);
	time[9] = LOW(buf[4]);

	time[10] = HIGH(buf[3]);
	time[11] = LOW(buf[3]);

	time[12] = HIGH(buf[2]) & 0b111;
	time[13] = LOW(buf[2]);
}

static void ds1307_write_time(uint8_t *time) {
	uint8_t buf[10];
	buf[0] = DS1307_ADDR;
	buf[1] = 0x3f;

	buf[2] = (time[0] << 4) | time[1]; /* upper 2 digits of year */

	buf[3] = (time[12]        << 4) | time[13]; /* seconds */
	buf[4] = (time[10]        << 4) | time[11]; /* minutes */
	buf[5] = ((time[8] & 0b11)<< 4) | time[ 9]; /* hours */

	buf[6] = 0; /* day of week - we don't use it */
	buf[7] = (time[6] << 4) | time[7]; /* date */
	buf[8] = (time[4] << 4) | time[5]; /* month */
	buf[9] = (time[2] << 4) | time[3]; /* lower 2 digits of year */

	twim_xfer(buf, 10);
}

static void dump_time(uint8_t *time) {
	for (int i = 0; i < 4; i++) {
		debug_char('0' + time[i]);
	}
	for (int i = 0; i < 2; i++) {
		debug_char('-');
		debug_char('0' + time[4 + 2*i]);
		debug_char('0' + time[5 + 2*i]);
	}
	debug_char(' ');

	for (int i = 0; i < 3; i++) {
		if (i) debug_char(':');
		debug_char('0' + time[8 + 2*i]);
		debug_char('0' + time[9 + 2*i]);
	}
}

static void set_module(uint8_t pos, uint8_t val) {
	uint8_t testpack[3];
	testpack[0] = 0xba;
	testpack[1] = pos + 1;
	testpack[2] = val;
	si2cm_xfer(testpack, 3);
}

static void settime() {
	uint8_t time[14];
	ds1307_read_time(time);

	lcd_clear();
//	debug_fstr("Set time:");

	int cursor = 0;

	while (1) {
		lcd_setcursor(0, 1);
		dump_time(time);

		/* yyyy-mm-dd hh:mm:ss
		 * 0123 45 67 89 ab cd
		 */
		int render_cursor = cursor;
		if (cursor >= 4) render_cursor += (cursor - 2) / 2;
		lcd_setcursor(render_cursor, 2);
		debug_char('^');


		for (int i = 0; i < 14; i++) {
			set_module(i, time[i]);
		}

		uint8_t buttons;
		do {
		} while (0 == (buttons = taster_gedrueckt(
			(1 << BIT_SETTIME_UP) |
			(1 << BIT_SETTIME_NEXTPOS) |
			(1 << BIT_SETTIME_MODE)
		)));

		lcd_setcursor(render_cursor, 2);
		debug_char(' ');

		if (buttons & (1 << BIT_SETTIME_UP)) {
			time[cursor]++;
			if (time[cursor] >= 10) {
				time[cursor] = 0;
			}
		}

		if (buttons & (1 << BIT_SETTIME_NEXTPOS)) {
			cursor++;
			if (cursor >= 14) {
				cursor = 0;
			}
			set_module(cursor, 0);
			set_module(cursor, 9);
		}

		if (buttons & (1 << BIT_SETTIME_MODE)) {
			break;
		}
	}

	ds1307_write_time(time);

	debug_fstr("I'm done");
}

static void datepart_conv(int8_t part, uint8_t *segs) {
	if (part >= 30) {
		segs[0] = 3;
		segs[1] = part - 30;
	} else if (part >= 20) {
		segs[0] = 2;
		segs[1] = part - 20;
	} else if (part >= 10) {
		segs[0] = 1;
		segs[1] = part - 10;
	} else {
		segs[0] = 0;
		segs[1] = part;
	}
}

static void diff_time_weltuntergang(uint8_t *time_in, uint8_t *time_out) {
	int8_t days_now     = time_in[6] * 10 + time_in[7];
	int8_t month_now    = time_in[4] * 10 + time_in[5];
	int8_t year_now_low = time_in[2] * 10 + time_in[3];

	int8_t  t = days_now - 21;
	int8_t  n = month_now - 12;
	int8_t r = year_now_low - 2012 + 2000;

	uint8_t monthlength[12] = {
		31,
		year_now_low % 4 ? 28 : 29 /* lolbadleapyear */,
		31, 30, 31, 30, 31,
		31, 30, 31, 30, 31
	};

	if (t < 0) {
		n--;
		t += monthlength[month_now < 2 ? 11 : month_now - 2];
	}

	while (n < 0) {
		r--;
		n += 12;
	}

	time_out[3] = r % 10; r /= 10;
	time_out[2] = r % 10; /* r /= 10;
	time_out[1] = r % 10; r /= 10;
	time_out[0] = r; */
	time_out[1] = 0;
	time_out[0] = 0;

	datepart_conv(n, time_out + 4);
	datepart_conv(t, time_out + 6);

	for (int x = 8; x < 14; x++) {
		time_out[x] = time_in[x];
	}
}

int main (void) {
	debug_init();
	taster_init();
	twim_init();
	si2cm_init();

	sei();

	uint8_t wat = ds1307_read_reg(DS1307_REG_CONTROL);
	//debug_fstr("Control reg: ");
	//debug_hex8(wat);

	while (1) {
		lcd_home();
		uint8_t time[14];
		ds1307_read_time(time);
		dump_time(time);
		
		
		uint8_t time_diff[14];
		diff_time_weltuntergang(time, time_diff);
		lcd_setcursor(0,2);
		dump_time(time_diff);

		for (int i = 0; i < 14; i++) {
			set_module(i, time_diff[i]);
		}

		_delay_ms(40);

		/* Zeit einstellen? */
		if (taster_gedrueckt(1 << BIT_SETTIME_MODE)) {
			settime();
		}
	}
}

