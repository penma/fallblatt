#ifndef TWI_SMASTER_H
#define TWI_SMASTER_H

#define TWI_READ_BIT  0 /* r/w bit */

void twim_init();
uint8_t twim_xfer(uint8_t *, uint8_t);

#endif
