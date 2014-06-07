#ifndef TASTER_H
#define TASTER_H

#define BIT_SETTIME_UP PD0
#define BIT_SETTIME_NEXTPOS PD1
#define BIT_SETTIME_MODE PD5

void taster_init();
uint8_t taster_gedrueckt(uint8_t mask);
uint8_t taster_gehalten(uint8_t mask);


#endif
