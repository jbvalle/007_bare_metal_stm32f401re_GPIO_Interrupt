#include <stdint.h>
#include "peripherals.h"

RCC_t       * const RCC     = (RCC_t    *)  0x40023800;
GPIOx_t     * const GPIOA   = (GPIOx_t  *)  0x40020000;
GPIOx_t     * const GPIOC   = (GPIOx_t  *)  0x40020800;
SYSCFG_t    * const SYSCFG  = (SYSCFG_t *)  0x40013800;
EXTI_t      * const EXTI    = (EXTI_t   *) 0x40013C00;


int main(void){

    for(;;);
}
