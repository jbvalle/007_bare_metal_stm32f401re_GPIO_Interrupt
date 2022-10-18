/**
 * @brief Entry Point Initialization
 * @file main.c
 *
 */
#include <stdint.h>
#include "peripherals.h"
#define IRQn_EXTI13 40

RCC_t       * const RCC     = (RCC_t    *)  0x40023800;
GPIOx_t     * const GPIOA   = (GPIOx_t  *)  0x40020000;
GPIOx_t     * const GPIOC   = (GPIOx_t  *)  0x40020800;
SYSCFG_t    * const SYSCFG  = (SYSCFG_t *)  0x40013800;
EXTI_t      * const EXTI    = (EXTI_t   *)  0x40013C00;
NVIC_t      * const NVIC    = (NVIC_t   *)  0xE000E100;

void wait_ms(int time){

    for(int i = 0;i < time; i++){

        for(int j = 0; j < 1600; j++);
    }
}

void blink(void){

    GPIOA->GPIOx_ODR ^= ( 1 << 5 ) ;
    wait_ms(100);
}
void EXTI15_10_handler(){

    for(int i = 0; i < 10; i++)blink();

    /** Reset Pending Bit of EXTI Controller for Line 13 **/
    EXTI->EXTI_PR |= (1 << 13);
}

int main(void){

    /** 1. Enable GPIOA and C **/
    RCC->RCC_AHB1ENR |= 1;
    RCC->RCC_AHB1ENR |= (1 << 2);
    /** 2. Set GPIOA as OUTPUT **/
    GPIOA->GPIOx_MODER &= ~(3 << (5 * 2));
    GPIOA->GPIOx_MODER |=  (1 << (5 * 2));
    /** 3. Set GPIOC as INPUT for IRQ **/
    GPIOC->GPIOx_MODER &= ~(3 << (13 * 2));
    /** 1. Enable SYSCFG Controller **/
    RCC->RCC_APB2ENR |= (1 << 14);
    /** 2. Unmask Interrupt Line 13**/
    EXTI->EXTI_IMR |= (1 << 13);
    /** 3. Configure Trigger Selection , disable rising edge, enable falling edge**/
    EXTI->EXTI_RTSR &=~(1 << 13);
    EXTI->EXTI_FTSR |= (1 << 13);
    /** 4. Configure EXTI Multiplexer PC13**/
    SYSCFG->SYSCFG_EXTICR4 &= ~(0xF << 4);
    SYSCFG->SYSCFG_EXTICR4 |=  (2 << 4);
    /** 5. Enable IRQ40 over NVIC **/
    NVIC->NVIC_ISER[1] |= (1 << (IRQn_EXTI13 % 32));

    for(;;);
}
