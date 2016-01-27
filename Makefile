#=============================================================================#
# toolchain configuration
#=============================================================================#

CUBE_ROOT=$(HOME)/STM32/STM32Cube_FW_F4_V1.10.0

CXX = arm-none-eabi-g++
CC = arm-none-eabi-gcc
AS = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size
RM = rm -f
RMDIR = rm -rf
NUCLEO = /media/neirons/NUCLEO

#=============================================================================#
# project configuration
#=============================================================================#

# project name
PROJECT = firmware

# core type
CORE = cortex-m4

# linker script
LD_SCRIPT = $(CUBE_ROOT)/Projects/STM32F401RE-Nucleo/Templates/TrueSTUDIO/STM32F4xx-Nucleo/STM32F401CE_FLASH.ld
# output folder (absolute or relative path, leave empty for in-tree compilation)
OUT_DIR = release

# temporary directory for object files and another garbage
TMP_DIR =tmp

# global definitions for C++, C and ASM (e.g. "symbol_with_value=0xDEAD symbol_without_value")
#GLOBAL_DEFS = STM32F429_439xx
#GLOBAL_DEFS += USE_STDPERIPH_DRIVER
#GLOBAL_DEFS += STM32F4XX
#GLOBAL_DEFS += TM_DISCO_STM32F429_DISCOVERY
#GLOBAL_DEFS += HSE_VALUE=8000000
#GLOBAL_DEFS += PLL_M=8
#GLOBAL_DEFS += PLL_N=360
#GLOBAL_DEFS += PLL_P=2
#GLOBAL_DEFS += PLL_Q=7
GLOBAL_DEFS += STM32F401xE
GLOBAL_DEFS += USE_STDPERIPH_DRIVER

# C++ definitions
CXX_DEFS =

# C definitions
C_DEFS = 

# ASM definitions
AS_DEFS =

# include directories (absolute or relative paths to additional folders with
# headers, current folder is always included)
INC_DIRS = $(CUBE_ROOT)/Drivers/CMSIS/Include
INC_DIRS += $(CUBE_ROOT)/Drivers/STM32F4xx_HAL_Driver/Inc
INC_DIRS += $(CUBE_ROOT)/Drivers/CMSIS/Device/ST/STM32F4xx/Include

# library directories (absolute or relative paths to additional folders with
# libraries)
LIB_DIRS =

# libraries (additional libraries for linking, e.g. "-lm -lsome_name" to link
# math library libm.a and libsome_name.a)
LIBS =

# additional directories with source files (absolute or relative paths to
# folders with source files, current folder is always included)
SRCS_DIRS = src

# extension of C++ files
CXX_EXT = cpp

# wildcard for C++ source files (all files with CXX_EXT extension found in
# current folder and SRCS_DIRS folders will be compiled and linked)
CXX_SRCS = $(wildcard $(patsubst %, %/*.$(CXX_EXT), . $(SRCS_DIRS)))

# extension of C files
C_EXT = c

# wildcard for C source files (all files with C_EXT extension found in current
# folder and SRCS_DIRS folders will be compiled and linked)
C_SRCS = $(wildcard $(patsubst %, %/*.$(C_EXT), . $(SRCS_DIRS)))

# extension of ASM files
AS_EXT = s

# wildcard for ASM source files (all files with AS_EXT extension found in
# current folder and SRCS_DIRS folders will be compiled and linked)
AS_SRCS = $(wildcard $(patsubst %, %/*.$(AS_EXT), . $(SRCS_DIRS)))

# optimization flags ("-O0" - no optimization, "-O1" - optimize, "-O2" -
# optimize even more, "-Os" - optimize for size or "-O3" - optimize yet more) 
OPTIMIZATION = -Os

# set to 1 to optimize size by removing unused code and data during link phase
REMOVE_UNUSED = 1

# set to 1 to compile and link additional code required for C++
USES_CXX = 0

# define warning options here
CXX_WARNINGS = -Wall -Wextra
#C_WARNINGS = -Wall -Wstrict-prototypes -Wextra -Wunused-parameter
C_WARNINGS = -Wall

# C++ language standard ("c++98", "gnu++98" - default, "c++0x", "gnu++0x")
CXX_STD = gnu++98

# C language standard ("c89" / "iso9899:1990", "iso9899:199409",
# "c99" / "iso9899:1999", "gnu89" - default, "gnu99")
C_STD = c99

#=============================================================================#
# set the VPATH according to SRCS_DIRS
#=============================================================================#

VPATH = $(SRCS_DIRS)

#=============================================================================#
# when using output folder, append trailing slash to its name
#=============================================================================#

ifeq ($(strip $(OUT_DIR)), )
	OUT_DIR_F =
else
	OUT_DIR_F = $(strip $(OUT_DIR))/
endif


#=============================================================================#
# same thing with temporary directory
#=============================================================================#

ifeq ($(strip $(TMP_DIR)), )
	TMP_DIR_F =
else
	TMP_DIR_F = $(strip $(TMP_DIR))/
endif

#=============================================================================#
# various compilation flags
#=============================================================================#

# core flags
CORE_FLAGS = -Wall -mcpu=$(CORE) -mthumb -mlittle-endian -mthumb-interwork

# flags for C++ compiler
CXX_FLAGS = -std=$(CXX_STD) -g -ggdb3 -fno-rtti -fno-exceptions -fverbose-asm -Wa,-ahlms=$(TMP_DIR_F)$(notdir $(<:.$(CXX_EXT)=.lst))

# flags for C compiler
C_FLAGS = -std=$(C_STD) -g -ggdb3 -fverbose-asm -Wa,-ahlms=$(TMP_DIR_F)$(notdir $(<:.$(C_EXT)=.lst))

# flags for assembler
AS_FLAGS = -g -ggdb3 -Wa,-amhls=$(TMP_DIR_F)$(notdir $(<:.$(AS_EXT)=.lst))

# flags for linker
LD_FLAGS = -T$(LD_SCRIPT) -g -Wl,-Map=$(TMP_DIR_F)$(PROJECT).map,--cref,--no-warn-mismatch

# process option for removing unused code
ifeq ($(REMOVE_UNUSED), 1)
	LD_FLAGS += -Wl,--gc-sections
	OPTIMIZATION += -ffunction-sections -fdata-sections
endif

# if __USES_CXX is defined for ASM then code for global/static constructors /
# destructors is compiled; if -nostartfiles option for linker is added then C++
# initialization / finalization code is not linked
ifeq ($(USES_CXX), 1)
	AS_DEFS += __USES_CXX
else
#LD_FLAGS += -nostartfiles
endif

#=============================================================================#
# do some formatting
#=============================================================================#

CXX_OBJS = $(addprefix $(TMP_DIR_F), $(notdir $(CXX_SRCS:.$(CXX_EXT)=.o)))
C_OBJS = $(addprefix $(TMP_DIR_F), $(notdir $(C_SRCS:.$(C_EXT)=.o)))
AS_OBJS = $(addprefix $(TMP_DIR_F), $(notdir $(AS_SRCS:.$(AS_EXT)=.o)))
OBJS = $(AS_OBJS) $(C_OBJS) $(CXX_OBJS) $(USER_OBJS)
DEPS = $(OBJS:.o=.d)
INC_DIRS_F = -I. $(patsubst %, -I%, $(INC_DIRS))
LIB_DIRS_F = $(patsubst %, -L%, $(LIB_DIRS))
GLOBAL_DEFS_F = $(patsubst %, -D%, $(GLOBAL_DEFS))
CXX_DEFS_F = $(patsubst %, -D%, $(CXX_DEFS))
C_DEFS_F = $(patsubst %, -D%, $(C_DEFS))
AS_DEFS_F = $(patsubst %, -D%, $(AS_DEFS))

ELF = $(OUT_DIR_F)$(PROJECT).elf
HEX = $(OUT_DIR_F)$(PROJECT).hex
BIN = $(OUT_DIR_F)$(PROJECT).bin

LSS = $(TMP_DIR_F)$(PROJECT).lss
DMP = $(TMP_DIR_F)$(PROJECT).dmp

# format final flags for tools, request dependancies for C++, C and asm
CXX_FLAGS_F = $(CORE_FLAGS) $(OPTIMIZATION) $(CXX_WARNINGS) $(CXX_FLAGS) $(GLOBAL_DEFS_F) $(CXX_DEFS_F) -MD -MP -MF $(TMP_DIR_F)$(@F:.o=.d) $(INC_DIRS_F)
C_FLAGS_F = $(CORE_FLAGS) $(OPTIMIZATION) $(C_WARNINGS) $(C_FLAGS) $(GLOBAL_DEFS_F) $(C_DEFS_F) -MD -MP -MF $(TMP_DIR_F)$(@F:.o=.d) $(INC_DIRS_F)
AS_FLAGS_F = $(CORE_FLAGS) $(AS_FLAGS) $(GLOBAL_DEFS_F) $(AS_DEFS_F) -MD -MP -MF $(TMP_DIR_F)$(@F:.o=.d) $(INC_DIRS_F)
LD_FLAGS_F = $(CORE_FLAGS) $(LD_FLAGS) $(LIB_DIRS_F)

#contents of output directory
GENERATED = $(wildcard $(patsubst %, $(OUT_DIR_F)*.%, elf hex bin))

#contents of temporary directory
TEMPORARY = $(wildcard $(patsubst %, $(TMP_DIR_F)*.%, d dmp lss lst map o))

#=============================================================================#
# make all
#=============================================================================#

all : make_output_dir make_tmp_dir $(ELF) $(LSS) $(DMP) $(BIN) print_size

# make .elf file dependent on linker script
$(ELF) : $(LD_SCRIPT) 

#-----------------------------------------------------------------------------#
# linking - objects -> elf
#-----------------------------------------------------------------------------#

$(ELF) : $(OBJS)
	@echo 'Linking target: $(ELF)'
	$(CXX) $(LD_FLAGS_F) $(OBJS) $(LIBS) -o $@
	@echo ' '

#-----------------------------------------------------------------------------#
# compiling - C++ source -> objects
#-----------------------------------------------------------------------------#

$(TMP_DIR_F)%.o : %.$(CXX_EXT)
	@echo 'Compiling file: $<'
	$(CXX) -c $(CXX_FLAGS_F) $< -o $@
	@echo ' '

#-----------------------------------------------------------------------------#
# compiling - C source -> objects
#-----------------------------------------------------------------------------#

$(TMP_DIR_F)%.o : %.$(C_EXT)
	@echo 'Compiling file: $<'
	$(CC) -c $(C_FLAGS_F) $< -o $@
	@echo ' '

#-----------------------------------------------------------------------------#
# assembling - ASM source -> objects
#-----------------------------------------------------------------------------#

$(TMP_DIR_F)%.o : %.$(AS_EXT)
	@echo 'Assembling file: $<'
	$(AS) -c $(AS_FLAGS_F) $< -o $@
	@echo ' '

#-----------------------------------------------------------------------------#
# memory images - elf -> hex, elf -> bin
#-----------------------------------------------------------------------------#

$(HEX) : $(ELF)
	@echo 'Creating IHEX image: $(HEX)'
	$(OBJCOPY) -O ihex $< $@
	@echo ' '

$(BIN) : $(ELF)
	@echo 'Creating binary image: $(BIN)'
	$(OBJCOPY) -O binary $< $@
	@echo ' '

#-----------------------------------------------------------------------------#
# memory dump - elf -> dmp
#-----------------------------------------------------------------------------#

$(DMP) : $(ELF)
	@echo 'Creating memory dump: $(DMP)'
	$(OBJDUMP) -x --syms $< > $@
	@echo ' '

#-----------------------------------------------------------------------------#
# extended listing - elf -> lss
#-----------------------------------------------------------------------------#

$(LSS) : $(ELF)
	@echo 'Creating extended listing: $(LSS)'
	$(OBJDUMP) -S $< > $@
	@echo ' '

#-----------------------------------------------------------------------------#
# print the size of the objects and the .elf file
#-----------------------------------------------------------------------------#

print_size : $(ELF)
	@echo 'Size of modules:' 
	$(SIZE) -B -t --common $(OBJS) $(USER_OBJS)
	@echo ' '
	@echo 'Size of target .elf file:'
	$(SIZE) -B $(ELF)
	@echo ' '

#-----------------------------------------------------------------------------#
# create the desired output directory
#-----------------------------------------------------------------------------#
 
make_output_dir :
	$(shell mkdir $(OUT_DIR_F) 2>/dev/null)


#-----------------------------------------------------------------------------#
# create the desired temporary directory
#-----------------------------------------------------------------------------#
 
make_tmp_dir :
	$(shell mkdir $(TMP_DIR_F) 2>/dev/null)

#-----------------------------------------------------------------------------#
# Upload files to github
#-----------------------------------------------------------------------------#
gitcom :
	git add *
	git commit -m "Add some disapeared files"
	git push origin master

#=============================================================================#
# make clean
#=============================================================================#

clean:
ifeq ($(strip $(OUT_DIR_F)), )
	@echo 'Removing all generated output files'
else
	@echo 'Removing all generated output files from output directory: $(OUT_DIR_F)'
endif
ifneq ($(strip $(GENERATED)), )
	$(RM) $(GENERATED)
	$(RMDIR) $(OUT_DIR_F)
else
	@echo 'Nothing to remove...'
endif
ifeq ($(strip $(TMP_DIR_F)), )
	@echo 'Removing all generated output files'
else
	@echo 'Removing all generated output files from temporary directory: $(TMP_DIR_F)'
endif
ifneq ($(strip $(TEMPORARY)), )
	$(RM) $(TEMPORARY)
	$(RMDIR) $(TMP_DIR_F)
else
	@echo 'Nothing to remove...'
endif


send: $(BIN)
	cp $< $(NUCLEO)


#=============================================================================#
# global exports
#=============================================================================#

.PHONY: all clean dependents

.SECONDARY:

# include dependancy files
-include $(DEPS)
