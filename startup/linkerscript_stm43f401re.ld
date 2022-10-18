/** Entry Point **/
ENTRY(Reset_handler)

/** Define top of Stack **/
__estack = 0x20000000 + 96K;

/** Define Memory **/
MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
    SRAM (xrw) : ORIGIN = 0x20000000, LENGTH = 96K
}

/** Define Output Memory Sections **/
SECTIONS
{

    .text :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        *(.text)
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    }> FLASH


    __etext = LOADADDR(.data);
    .data :
    {
        . = ALIGN(4);
        __sdata = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        __edata = .;
    }> SRAM AT> FLASH

    .bss :
    {
        . = ALIGN(4);
        __sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __ebss = .;
    }> SRAM
}


