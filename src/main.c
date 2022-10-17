#include <stdint.h>
#include "peripherals.h"

RCC_t       * const RCC     = (RCC_t    *)  0x40023800;
GPIOx_t     * const GPIOA   = (GPIOx_t  *)  0x40020000;
GPIOx_t     * const GPIOC   = (GPIOx_t  *)  0x40020800;
SYSCFG_t    * const SYSCFG  = (SYSCFG_t *)  0x40013800;
EXTI_t      * const EXTI    = (EXTI_t   *) 0x40013C00;

void GPIOx_INIT(void){
    /** Enable GPIOA and C **/
    RCC->RCC_AHB1ENR |= ((1 << 2) | (1 << 0));
    /** Set GPIOA as OUTPUT **/
    GPIOA->GPIOx_MODER &= ~(3 << (5 * 2));
    GPIOA->GPIOx_MODER |=  (1 << (5 * 2));
    /** Set GPIOC as INPUT for IRQ **/
    GPIOC->GPIOx_MODER &= ~(3 << (13 * 2));
}

int main(void){

    GPIOx_INIT();
    for(;;);
}
