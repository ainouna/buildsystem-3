#
# titan
#
TITAN_DEPS  = $(D)/bootstrap
TITAN_DEPS += $(KERNEL)
TITAN_DEPS += $(D)/libopenthreads
TITAN_DEPS += $(LIRC)
TITAN_DEPS += $(D)/libpng
TITAN_DEPS += $(D)/freetype
TITAN_DEPS += $(D)/libdreamdvd
TITAN_DEPS += $(D)/libjpeg
TITAN_DEPS += $(D)/zlib
TITAN_DEPS += $(D)/tools-libmme_image
TITAN_DEPS += $(D)/tools-libmme_host
TITAN_DEPS += $(D)/openssl
TITAN_DEPS += $(D)/timezone
TITAN_DEPS += python-all
ifeq ($(MEDIAFW), eplayer3)
#T_CONFIG_OPTS += --enable-eplayer3
TITAN_DEPS += $(D)/libcurl
TITAN_DEPS += $(D)/ffmpeg
TITAN_DEPS += $(D)/tools-exteplayer3
endif
ifeq ($(MEDIAFW), gstreamer)
#T_CONFIG_OPTS += --with-gstversion=1.0 --enable-mediafwgstreamer
TITAN_DEPS += $(D)/gstreamer $(D)/gst_plugins_base $(D)/gst_plugins_multibox_dvbmediasink
TITAN_DEPS += $(D)/gst_plugins_good $(D)/gst_plugins_bad $(D)/gst_plugins_ugly
endif
ifeq ($(MEDIAFW), gst-eplayer3)
#T_CONFIG_OPTS += --with-gstversion=1.0 --enable-mediafwgstreamer --enable-eplayer3
TITAN_DEPS += $(D)/libcurl
TITAN_DEPS += $(D)/ffmpeg
TITAN_DEPS += $(D)/tools-libeplayer3
TITAN_DEPS += $(D)/gstreamer $(D)/gst_plugins_base $(D)/gst_plugins_multibox_dvbmediasink
TITAN_DEPS += $(D)/gst_plugins_good $(D)/gst_plugins_bad $(D)/gst_plugins_ugly
endif
TITAN_DEPS += $(LOCAL_TITAN_DEPS)

ifeq ($(IMAGE), titan-wlandriver)
TITAN_DEPS += $(D)/wpa_supplicant $(D)/wireless_tools
endif

ifeq ($(EXTERNAL_LCD), graphlcd)
T_CONFIG_OPTS += --with-graphlcd
TITAN_DEPS_ += $(D)/graphlcd
endif

ifeq ($(EXTERNAL_LCD), lcd4linux)
T_CONFIG_OPTS += --with-lcd4linux
TITAN_DEPS += $(D)/lcd4linux
endif

ifeq ($(EXTERNAL_LCD), both)
T_CONFIG_OPTS += --with-graphlcd
TITAN_DEPS += $(D)/graphlcd
T_CONFIG_OPTS += --with-lcd4linux
TITAN_DEPS += $(D)/lcd4linux
endif

T_CONFIG_OPTS +=$(LOCAL_TITAN_BUILD_OPTIONS)

T_CPPFLAGS   += -DSH4
T_CPPFLAGS   += -DDVDPLAYER 
T_CPPFLAGS   += -Wno-unused-but-set-variable
T_CPPFLAGS   += -I$(DRIVER_DIR)/include
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/freetype2
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/openssl
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/dreamdvd
T_CPPFLAGS   += -I$(KERNEL_DIR)/include
T_CPPFLAGS   += -I$(DRIVER_DIR)/bpamem
T_CPPFLAGS   += -I$(TOOLS_DIR)
T_CPPFLAGS   += -I$(TOOLS_DIR)/libmme_image
T_CPPFLAGS   += -L$(TARGET_DIR)/usr/lib
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/python
T_CPPFLAGS   += -L$(SOURCE_DIR)/titan/libipkg
#T_LINKFLAGS   += -lm -lpthread -ldl -lpng -lfreetype -ldreamdvd -ljpeg -lmmeimage -lmme_host -lz
ifeq ($(MEDIAFW), eplayer3)
T_CPPFLAGS   += -DEPLAYER3
T_CPPFLAGS   += -I$(TOOLS_DIR)/exteplayer3/include
#T_CPPFLAGS   += -I$(SOURCE_DIR)/titan/libeplayer3/include
#T_CPPFLAGS   += -I$(SOURCE_DIR)/titan/libeplayer3/include/external
#T_LINKFLAGS   += -lssl -leplayer -lcrypto -lcurl
endif
ifeq ($(MEDIAFW), gstreamer)
T_CPPFLAGS   += -DEPLAYER4
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/gstreamer-1.0
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/glib-2.0
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/libxml2
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/lib/gstreamer-1.0/include
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/lib/gstreamer-1.0/include
#T_LINKFLAGS   += -lglib-2.0 -lgobject-2.0 -lgio-2.0 -lgstreamer-1.0
endif
ifeq ($(MEDIAFW), gst-explayer3)
T_CPPFLAGS   += -DEPLAYER3 -DEPLAYER4
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/gstreamer-1.0
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/glib-2.0
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/include/libxml2
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/lib/gstreamer-1.0/include
T_CPPFLAGS   += -I$(TARGET_DIR)/usr/lib/gstreamer-1.0/include
T_CPPFLAGS   += -I$(TOOLS_DIR)/exteplayer3/include
#T_CPPFLAGS   += -lssl -leplayer -lcrypto -lcurl -lglib-2.0 -lgobject-2.0 -lgio-2.0 -lgstreamer-1.0
endif

T_CPPFLAGS   += $(LOCAL_TITAN_CPPFLAGS)
T_CPPFLAGS   += $(PLATFORM_CPPFLAGS)

#
# yaud-titan
#
yaud-titan: yaud-none $(D)/titan $(D)/titan_release
	$(TUXBOX_YAUD_CUSTOMIZE)
	@echo "***************************************************************"
	@echo -e "\033[01;32m"
	@echo " Build of Titan for $(BOXTYPE) successfully completed."
	@echo -e "\033[00m"
	@echo "***************************************************************"
	@touch $(D)/build_complete

#
# titan
#
REPO_TITAN=$(GITHUB)"/OpenVisionE2/Titan.git"
TITAN_PATCH  = build-titan/titan.patch
#ifeq ($(MEDIAFW), $(filter $(MEDIAFW), eplayer3 gst-explayer3))
#TITAN_PATCH += build-titan/titan_exteplayer3.patch
#endif

$(D)/titan.do_prepare: | $(TITAN_DEPS)
	REPO=$(REPO_TITAN); \
	HEAD="master"; \
	rm -rf $(SOURCE_DIR)/titan; \
	rm -rf $(SOURCE_DIR)/titan.org; \
	clear; \
	echo "Starting Titan build"; \
	echo "===================="; \
	echo; \
	echo "Repository : "$$REPO; \
	[ -d "$(ARCHIVE)/titan.git" ] && \
	(cd $(ARCHIVE)/titan.git; echo -n "Updating archived Titan git..."; git pull -q; echo -e -n " done.\nChecking out HEAD..."; git checkout -q HEAD; echo " done."; cd "$(BUILD_TMP)";); \
	[ -d "$(ARCHIVE)/titan.git" ] || \
	(echo -n "Cloning remote Titan git..."; git clone -q -b $$HEAD $$REPO $(ARCHIVE)/titan.git; echo " done."); \
	echo -n "Copying local git content to build environment..."; cp -ra $(ARCHIVE)/titan.git $(SOURCE_DIR)/titan; echo " done."; \
	cp -ra $(SOURCE_DIR)/titan $(SOURCE_DIR)/titan.org; \
	set -e; cd $(SOURCE_DIR)/titan; \
	pwd; \
	echo "Applying Titan patch..."; \
	$(call apply_patches, $(TITAN_PATCH)); \
	echo "Patching Titan completed."; \
	cd $(SOURCE_DIR)/titan; \
	cp ./libeplayer3/Makefile.am.sh4 ./libeplayer3/Makefile.am; \
	cp ./titan/Makefile.am.sh4 ./titan/Makefile.am; \
	echo; \
	touch $@

$(SOURCE_DIR)/titan/config.status:
	$(SILENT)cd $(SOURCE_DIR)/titan; \
		echo "Configuring titan..."; \
		./autogen.sh $(SILENT_OPT); \
		$(BUILDENV) \
		./configure $(SILENT_CONFIGURE) \
			--build=$(BUILD) \
			--host=$(TARGET) \
			$(T_CONFIG_OPTS) \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--bindir=/usr/local/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			--with-boxtype=duckbox \
			--with-boxmodel=$(BOXTYPE) \
			--enable-multicom324 \
			$(TITAN_OPT_OPTION) \
			PKG_CONFIG=$(PKG_CONFIG) \
			CPPFLAGS="$(T_CPPFLAGS)"
	cd $(SOURCE_DIR)/titan/plugins; \
		./autogen.sh $(SILENT_OPT); \
		./configure $(SILENT_CONFIGURE) \
			--build=$(BUILD) \
			--host=$(TARGET) \
			$(T_CONFIG_OPTS) \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--bindir=/usr/local/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			--enable-multicom324 \
			$(TITAN_OPT_OPTION) \
			PKG_CONFIG=$(PKG_CONFIG) \
			CPPFLAGS="$(T_CPPFLAGS)"

$(D)/titan.do_compile: $(SOURCE_DIR)/titan/config.status $(D)/titan_libipkg
	$(SILENT)cd $(SOURCE_DIR)/titan; \
		$(MAKE) all
	@touch $@

$(D)/titan: $(D)/titan.do_prepare $(D)/titan.do_compile
	$(MAKE) -C $(SOURCE_DIR)/titan install DESTDIR=$(TARGET_DIR)
	@echo -n "Stripping..."
	$(SILENT)if [ -e $(TARGET_DIR)/usr/bin/titan ]; then \
		$(TARGET)-strip $(TARGET_DIR)/usr/bin/titan; \
	fi
	$(SILENT)if [ -e $(TARGET_DIR)/usr/local/bin/titan ]; then \
		$(TARGET)-strip $(TARGET_DIR)/usr/local/bin/titan; \
	fi
	$(SILENT)echo " done."
	$(SILENT)echo
	$(TOUCH)

TITAN_LIBIPKG_PATCH =
$(D)/titan_libipkg: $(D)/titan.do_prepare
		$(START_BUILD)
		$(SILENT)cd $(SOURCE_DIR)/titan/libipkg; \
		aclocal $(ACLOCAL_FLAGS); \
		libtoolize --automake -f -c; \
		autoconf; \
		autoheader; \
		automake --add-missing; \
		$(call apply_patches, $(TITAN_LIBIPKG_PATCH)); \
		./configure $(SILENT_CONFIGURE) \
			--build=$(BUILD) \
			--host=$(TARGET) \
			$(T_CONFIG_OPTS) \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--bindir=/usr/local/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			$(TITAN_OPT_OPTION) \
			PKG_CONFIG=$(PKG_CONFIG) \
			CPPFLAGS="$(T_CPPFLAGS)" \
		; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
		cp $(SOURCE_DIR)/titan/libipkg/libipkg.pc $(TARGET_LIB_DIR)/pkgconfig
		$(REWRITE_PKGCONF) $(PKG_CONFIG_PATH)/libipkg.pc
	$(TOUCH)

TITAN_LIBDREAMDVD_PATCH =
$(D)/titan_libdreamdvd.do_prepare: $(D)/titan.do_prepare
	$(SILENT)cd $(SOURCE_DIR)/titan/libdreamdvd; \
		if [ ! -d m4 ]; then mkdir m4; fi; \
		./autogen.sh $(SILENT_OPT); \
		$(BUILDENV); \
		$(call apply_patches, $(TITAN_LIBDREAMDVD_PATCH)); \
		./configure $(SILENT_CONFIGURE) \
			--build=$(BUILD) \
			--host=$(TARGET) \
			$(T_CONFIG_OPTS) \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--bindir=/usr/local/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			$(TITAN_OPT_OPTION) \
			PKG_CONFIG=$(PKG_CONFIG) \
			CPPFLAGS="$(T_CPPFLAGS)"
	@touch $@

$(D)/titan_libdreamdvd.do_compile: $(D)/titan_libdreamdvd.do_prepare
	$(SILENT)cd $(SOURCE_DIR)/titan/libdreamdvd; \
		$(MAKE) all
		cp $(SOURCE_DIR)/titan/libdreamdvd/.libs/libdreamdvd.* $(TARGET_LIB_DIR)
	$(TOUCH)

$(D)/titan_libdreamdvd: $(D)/titan_libdreamdvd.do_prepare $(D)/titan_libdreamdvd.do_compile
	$(START_BUILD)

TITAN_LIBEPLAYER3_PATCH =
$(D)/titan_libeplayer3.do_prepare: $(D)/titan.do_prepare
		$(SILENT)cd $(SOURCE_DIR)/titan/libeplayer3; \
		if [ ! -d m4 ]; then mkdir m4; fi; \
		./autogen.sh $(SILENT_OPT); \
		$(BUILDENV); \
		$(call apply_patches, $(TITAN_LIBEPLAYER3_PATCH)); \
		./configure $(SILENT_CONFIGURE) \
			--build=$(BUILD) \
			--host=$(TARGET) \
			$(T_CONFIG_OPTS) \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--bindir=/usr/local/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			$(TITAN_OPT_OPTION) \
			PKG_CONFIG=$(PKG_CONFIG) \
			CPPFLAGS="$(T_CPPFLAGS)"
	@touch $@

$(D)/titan_libeplayer3.do_compile: $(D)/titan_libeplayer3.do_prepare
	$(SILENT)cd $(SOURCE_DIR)/titan/libeplayer3; \
		$(MAKE) all
	$(TOUCH)

$(D)/titan_libeplayer3: $(D)/titan_libeplayer3.do_prepare $(D)/titan_libeplayer3.do_compile
		$(START_BUILD)

titan-clean:
	rm -f $(D)/titan
	rm -f $(D)/titan.do_compile
	cd $(SOURCE_DIR)/titan; \
		$(MAKE) distclean

titan-distclean:
	rm -f $(D)/titan
	rm -f $(D)/titan.do_compile
	rm -f $(D)/titan.do_prepare
	rm -rf $(SOURCE_DIR)/titan
	rm -rf $(SOURCE_DIR)/titan.org

