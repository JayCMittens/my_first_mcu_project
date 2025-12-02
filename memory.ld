ENTRY(reset_handler) /* Define the entry point of the program */


/* Define memory regions */
MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K /* Flash memory */
  RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 64K /* SRAM */
  /* EEPROM (rwx) : ORIGIN = 0x08080000, LENGTH = 4K EEPROM */
  CCMRAM (rwx) : ORIGIN = 0x10000000, LENGTH = 16K /* Core Coupled Memory */
  /* BATTRAM (rw) : ORIGIN = 0x40024000, LENGTH = 4K  Backup SRAM */
}

_start_of_stack = ORIGIN(RAM) + LENGTH(RAM); /* Define the start of the stack at the end of RAM */
_min_stack_size = 0x400; /* Define minimum stack size (1KB) */
_min_heap_size = 0x400;  /* Define minimum heap size (1KB) */

/* Define sections and their placement in memory 
* Sections define how different parts of the program are organized in memory.
* The linker assigns sections to specific memory regions defined above.
* For example, the .text section (which contains code) is placed in FLASH,
* while the .data and .bss sections (which contain initialized and uninitialized data, respectively) are placed in RAM.
* The ELF file format uses these sections to organize the program's code and data.
*/
SECTIONS {
    /* collect all executable code */
  .text :
  {
    /* . = 0x08000000;  Set starting address of .text section */
    . = ALIGN(4); /* align to 4-byte boundary */
    *(.text)
    *(.text.*) /* . --> 0x0800_0021 */
    . = ALIGN(4); /* --> 0x0800_0024 */
  } > FLASH

  /* Constant data will go into FLASH */
  .rodata : {
    . = ALIGN(4); /* align to 4-byte boundary */
    *(.rodata)
    *(.rodata.*)
    . = ALIGN(4);
  } > FLASH

  /* collect all initialized data */
  .data : {
    _sidata = LOADADDR(.data); /* load address of .data section */
    . = ALIGN(4); /* align to 4-byte boundary */
    _sdata = .; /* start address of .data section */
    *(.data)
    *(.data.*)
    . = ALIGN(4);
    _edata = .; /* end address of .data section */

  } > RAM AT> FLASH /* Initialized data section, loaded from FLASH to RAM */

  /* uninitialized data */
  .bss : {
    . = ALIGN(4); /* align to 4-byte boundary */
    _sbss = .; /* start address of .bss section */
    *(.bss)
    *(.bss.*)
    . = ALIGN(4);
    _ebss = .; /* end address of .bss section */
  } > RAM

  /* Stack and Heap size check */
  .ram_usage_check : {
    . = ALIGN(8);
    . = . + _min_stack_size; /* ensure enough space for stack */
    . = . + _min_heap_size;  /* ensure enough space for heap */
    . = ALIGN(8);
  } > RAM


}
