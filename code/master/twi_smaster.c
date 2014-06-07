
#include <avr/io.h>
#include <util/delay.h>

#include "twi_smaster.h"

#define DDR_USI DDRB
#define PORT_USI PORTB
#define PIN_USI PINB
#define SDA_BIT PB5
//#define SCL_BIT PB7

#define TWI_ADR_BIT   1 /* address bits */
#define TWI_N_ACK_BIT 0 /* ack/nack bit */

#define TWI_XFER_STD ( (1 << USISIF) | (1 << USIOIF) | (1 << USIPF) | (1 << USIDC) )
#define TWI_XFER_8BIT ( TWI_XFER_STD | (0x0 << USICNT0) )
#define TWI_XFER_1BIT ( TWI_XFER_STD | (0xe << USICNT0) )

void twim_init() {
	PORT_USI |= (1 << SDA_BIT);
	PORT_USI |= (1 << SCL_BIT);
	DDR_USI  |= (1 << SCL_BIT);
	DDR_USI  |= (1 << SDA_BIT);

	USIDR = 0xff;
	/* two-wire mode, software clock, no interrupts */
	USICR = (1 << USIWM1) | (1 << USICS1) | (1 << USICLK);
	/* reset flags + counter */
	USISR = TWI_XFER_STD;
}

static uint8_t _xfer(uint8_t t) {
	USISR = t;
	t = (1 << USIWM1) | (1 << USICS1) | (1 << USICLK) | (1 << USITC);

	do {
		_delay_us(4); /* T2/4 */
		USICR = t;
		while (!(PIN_USI & (1 << SCL_BIT))) { }
		_delay_us(4); /* T4/4 */
		USICR = t;
	} while (!(USISR & (1 << USIOIF)));

	_delay_us(4); /* T2/4 */
	t = USIDR;
	USIDR = 0xff;
	DDR_USI |= (1 << SDA_BIT);
	return t;
}

static void _stop() {
	PORT_USI &= ~(1 << SDA_BIT);
	PORT_USI |= (1 << SCL_BIT);
	while (!(PIN_USI & (1 << SCL_BIT))) { }
	_delay_us(4); /* T4/4 */
	PORT_USI |= (1 << SDA_BIT);
	_delay_us(4); /* T2/4 */
}

uint8_t twim_xfer(uint8_t *buf, uint8_t bufsize) {
	uint8_t xferred_address = 0;
	uint8_t do_write = 0;

	if (!(buf[0] & (1 << TWI_READ_BIT))) {
		do_write = 1;
	}

	/* release SCL */
	PORT_USI |= (1 << SCL_BIT);
	while (!(PIN_USI & (1 << SCL_BIT))) { }
	_delay_us(4); /* T2/4 */

	/* start condition */
	PORT_USI &= ~(1 << SDA_BIT);
	_delay_us(4); /* T4/4 */
	PORT_USI &= ~(1 << SCL_BIT);
	PORT_USI |= (1 << SDA_BIT);

	do {
		if (!xferred_address || do_write) {
			/* write one byte */
			PORT_USI &= ~(1 << SCL_BIT);
			USIDR = *(buf++);
			_xfer(TWI_XFER_8BIT);

			DDR_USI &= ~(1 << SDA_BIT);
			if (_xfer(TWI_XFER_1BIT) & (1 << TWI_N_ACK_BIT)) {
				/* err */
				return 0;
			}

			xferred_address = 1;
		} else {
			/* read */
			DDR_USI &= ~(1 << SDA_BIT);
			*(buf++) = _xfer(TWI_XFER_8BIT);

			if (bufsize == 1) {
				USIDR = 0xff;
			} else {
				USIDR = 0;
			}
			_xfer(TWI_XFER_1BIT);
		}
	} while (--bufsize);

	_stop();

	return 1;
}
