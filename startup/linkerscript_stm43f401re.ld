/** Entry Point **/
ENTRY(Reset_handler)

/** Define top of Stack **/
__estack = 0x20000000 + 96K;

/** Define Memory **/
MEMORY
{
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
}

/** Define Output Memory Sections **/
SECTIONS
{
    .isr_vector :
    {
        . = ALIGN(4);
        *(.isr_vector)
        . = ALIGN(4);
    }> SRAM

    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
        __etext = .;
    }> FLASH

    .data :
    {
        . = ALIGN(4);
        __sdata = .;
        *(.data)
        *(.data.*)
        . = ALIGN(4);
        __edata = .;
    }> SRAM AT> FLASH

    .bss :
    {
        . = ALIGN(4);
        __sbss = .;
        *(.bss)
        *(COMMON)
        . = ALIGN(4);
        __ebss = .;
    }> SRAM
}


