TARGET := iphone:clang:latest:14.1
INSTALL_TARGET_PROCESSES = Spotify
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Omneon

Omneon_FILES = $(shell find Sources/Omneon -name '*.swift') $(shell find Sources/OmneonC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Omneon_SWIFTFLAGS = -ISources/OmneonC/include -Osize
Omneon_EXTRA_FRAMEWORKS = SwiftProtobuf
Omneon_CFLAGS = -fobjc-arc -ISources/OmneonC/include -Os

include $(THEOS_MAKE_PATH)/tweak.mk

copy-swiftprotobuf:
	mkdir -p swiftprotobuf && cd swiftprotobuf ;\
	curl -OL https://github.com/whoeevee/EeveeSpotify/releases/download/swift2.0/org.swift.protobuf.swiftprotobuf_1.26.0_iphoneos-arm.deb ;\
	ar -x org.swift.protobuf.swiftprotobuf_1.26.0_iphoneos-arm.deb ;\
	tar -xvf data.tar.lzma ;\
	cp -r Library/Frameworks/SwiftProtobuf.framework "${THEOS}/lib" ;\
