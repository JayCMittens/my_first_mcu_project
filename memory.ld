/* Define memory regions */
MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K /* Flash memory */
  RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 64K /* SRAM */
  /* EEPROM (rwx) : ORIGIN = 0x08080000, LENGTH = 4K EEPROM */
  CCMRAM (rwx) : ORIGIN = 0x10000000, LENGTH = 16K /* Core Coupled Memory */
  /* BATTRAM (rw) : ORIGIN = 0x40024000, LENGTH = 4K  Backup SRAM */
}


/* Define sections and their placement in memory 
* Sections define how different parts of the program are organized in memory.
* The linker assigns sections to specific memory regions defined above.
* For example, the .text section (which contains code) is placed in FLASH,
* while the .data and .bss sections (which contain initialized and uninitialized data, respectively) are placed in RAM.
* The ELF file format uses these sections to organize the program's code and data.
*/
SECTIONS {
  .text :
  {
    /* collect all executable code */
    *(.text)
    *(.text.*)
  } > FLASH

  .rodata : {
    /* Constant data will go into FLASH */
    *(.rodata)
    *(.rodata.*)
  } > FLASH

  /* collect all initialized data */
  .data : {
    _sidata = LOADDADDR(.data); /* load address of .data section */
    _sdata = .; /* start address of .data section */
    *(.data)
    *(.data.*)
    _edata = .; /* end address of .data section */

  } > RAM AT> FLASH /* Initialized data section, loaded from FLASH to RAM */

  /* uninitialized data */
  .bss : {
    _sbss = .; /* start address of .bss section */
    *(.bss)
    *(.bss.*)
    _ebss = .; /* end address of .bss section */
  } > RAM
}


/* TODO: Video 54. */