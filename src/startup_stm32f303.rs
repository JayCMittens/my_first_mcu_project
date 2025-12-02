// define the vector table tfor the mcu

// define the reset handler
fn reset_handler() {
  // copy the .data section from FLASH to RAM
  // zero out the .bss section in the RAM
  // call main()
}

// define the exception handlers