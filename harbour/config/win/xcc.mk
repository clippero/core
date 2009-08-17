#
# $Id$
#

# GNU MAKE file for xHarbour.com POCC compiler

OBJ_EXT := .obj
LIB_PREF :=
LIB_EXT := .lib

HB_DYN_COMPILE := yes

CC := xcc.exe
CC_IN := -c
CC_OUT := -Fo

CPPFLAGS :=
CFLAGS := -I. -I$(HB_INC_COMPILE)
LDFLAGS :=

ifneq ($(HB_BUILD_OPTIM),no)
   # disabled - it produces bad code
   #CFLAGS += -Ot
endif

# For Pocket PC and ARM processors (including XScale)
#CFLAGS += /Tarm-coff

ifeq ($(HB_BUILD_DEBUG),yes)
   CFLAGS += -Zi
endif

LD := xlink.exe
LD_OUT := /out:

LIBPATHS := /libpath:$(LIB_DIR)
LDLIBS := $(foreach lib,$(LIBS) $(SYSLIBS),$(lib)$(LIB_EXT))

LDFLAGS += $(LIBPATHS)

AR := xlib.exe
ARFLAGS :=
AR_RULE = $(AR) $(ARFLAGS) $(HB_USER_AFLAGS) /out:$(LIB_DIR)/$@ $(^F)

include $(TOP)$(ROOT)config/rules.mk
