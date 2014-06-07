#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/atomic.h>
#include <stdlib.h>

#include "taster.h"

void taster_init() {
	/* Eingänge und Pull-ups aktivieren */
	DDRD &= ~((1 << BIT_SETTIME_UP) | (1 << BIT_SETTIME_NEXTPOS) | (1 << BIT_SETTIME_MODE));
	PORTD |= (1 << BIT_SETTIME_UP) | (1 << BIT_SETTIME_NEXTPOS) | (1 << BIT_SETTIME_MODE);

	/* timer fuer tasterfoo */
	TCCR0A = (1 << WGM01); /* CTC */
	TCCR0B = (1 << CS02); /* prescaler 1/256 */
	OCR0A = 38; /* (F_CPU/256 * 10ms) - 1 */
	TIMSK |= 1 << OCIE0A;

	/* Interrupts aktivieren muss der Aufrufer selbst */
}

/* http://www.mikrocontroller.net/articles/Entprellung */

static volatile uint8_t state;  /* entprellter Taster-Zustand */
static volatile uint8_t detect; /* noch nicht abgefragte 0->1 Übergänge */

ISR (TIMER0_COMPA_vect) {
	static uint8_t ct0, ct1;
	uint8_t i;

	i = state ^ ~PIND;
	ct0 = ~(ct0 & i);
	ct1 = ct0 ^ (ct1 & i);
	i &= ct0 & ct1;
	state ^= i;
	detect |= state & i;
}

/* ob und welche Taster gedrückt wurden.
 * Für jedes gesetzte Bit in mask wird der entsprechende Taster abgefragt
 *
 * Wenn ein Taster gedrückt gehalten wird, gibt diese Funktion für ihn nur beim
 * ersten Aufruf 1 zurück, danach nur noch, wenn der Taster zwischenzeitlich
 * losgelassen wurde.
 */
uint8_t taster_gedrueckt(uint8_t mask) {
	/* FORCEON ist ok, da der gesamte Tastercode ohne Interrupts ohnehin
	 * nicht funktioniert
	 */
	ATOMIC_BLOCK(ATOMIC_FORCEON) {
		mask &= detect; /* abfragen */
		detect ^= mask; /* als abgefragt markieren */
	}
	return mask;
}

/* ob und welche Taster gedrückt sind.
 * Im Gegensatz zu taster_gedrueckt gibt diese Funktion eine 1 zurück, solange
 * der Taster gedrückt bleibt.
 */
uint8_t taster_gehalten(uint8_t mask) {
	return mask & state;
}

