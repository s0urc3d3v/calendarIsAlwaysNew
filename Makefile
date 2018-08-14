THEOS_PACKAGE_DIR_NAME = debs
TARGET = simulator:clang::7.0
ARCHS = x86_64 i386
DEBUG = 0
PACKAGE_VERSION = $(THEOS_PACKAGE_VERSION)

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = calendarIsAlwaysNew
calendarIsAlwaysNew_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

ifneq (,$(filter x86_64 i386,$(ARCHS)))
setup:: clean all
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
	$(shell $(HOME)/simject/bin/respring_simulator) #Modify this to point to respring_simulator in your simject folder.  Or just delete this and do it manually, this is really weird and causes problems
endif

after-install::
	install.exec "killall -9 SpringBoard"
