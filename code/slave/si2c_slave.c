#include <avr/io.h>
#include <avr/interrupt.h>

#define CLOCK_BIT PD4
#define DATA_BIT PD5

#define BUFSIZE 3
static uint8_t rxbuf[BUFSIZE];

extern void si2cs_received(uint8_t *buf, uint8_t len);

void si2cs_init() {
	DDRD  &= ~( (1 << CLOCK_BIT) | (1 << DATA_BIT) );
	PORTD &= ~( (1 << CLOCK_BIT) | (1 << DATA_BIT) );

	GIMSK |= (1 << 4 /* PCIE2 */);
	PCMSK2 |= (1 << PCINT15);
}

ISR (PCINT_D_vect) {
	/* this one only works right as long as no other PCINT on port D is
	 * enabled.
	 * Otherwise we don't know which one actually changed
	 */

	if (PIND & (1 << CLOCK_BIT)) {
		/* clock rising: read data. */
		uint8_t data_bit = !!(PIND & (1 << DATA_BIT));

		/* shift */
#if BUFSIZE != 3
#error "This code only works on bufsize 3"
#endif
		rxbuf[0] = (rxbuf[0] << 1) | (rxbuf[1] >> 7);
		rxbuf[1] = (rxbuf[1] << 1) | (rxbuf[2] >> 7);
		rxbuf[2] = (rxbuf[2] << 1) | data_bit;
	} else {
		/* clock falling */
		if (PIND & (1 << DATA_BIT)) {
			/* end of transmission */
			si2cs_received(rxbuf, BUFSIZE);
		}
	}
}

