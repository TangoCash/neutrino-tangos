AC_DEFUN([TUXBOX_APPS], [
AM_CONFIG_HEADER(config.h)
AM_MAINTAINER_MODE

AC_GNU_SOURCE

AC_ARG_WITH(target,
	AS_HELP_STRING([--with-target=TARGET], [target for compilation [[native,cdk]]]),
	[TARGET="$withval"],
	[TARGET="native"])

AC_ARG_WITH(targetprefix,
	AS_HELP_STRING([--with-targetprefix=PATH], [prefix relative to target root (only applicable in cdk mode)]),
	[TARGET_PREFIX="$withval"],
	[TARGET_PREFIX=""])

AC_ARG_WITH(debug,
	AS_HELP_STRING([--without-debug], [disable debugging code @<:@default=no@:>@]),
	[DEBUG="$withval"],
	[DEBUG="yes"])

if test "$DEBUG" = "yes"; then
	DEBUG_CFLAGS="-g3 -ggdb"
	AC_DEFINE(DEBUG, 1, [enable debugging code])
fi

# weather
AC_ARG_WITH(weather-dev-key,
	AS_HELP_STRING([--with-weather-dev-key=KEY], [API dev key to get data from weather data base, required for additional weather informations]),
	[WEATHER_DEV_KEY="$withval"],
	[WEATHER_DEV_KEY=""])
AC_DEFINE_UNQUOTED([WEATHER_DEV_KEY], ["$WEATHER_DEV_KEY"], [API dev key to get data from weather data base, required for additional weather informations])

AC_ARG_ENABLE([weather-key-manage],
	AS_HELP_STRING([--enable-weather-key-manage], [Enable manage weather api dev key via gui for additional weather informations @<:@default=yes@:>@]),
	[enable_weather_key_manage="$enableval"],
	[enable_weather_key_manage="yes"])

if test "$enable_weather_key_manage" = "yes" ; then
	AC_DEFINE([ENABLE_WEATHER_KEY_MANAGE], 1, [Enable manage weather api dev key via gui for additional weather informations])
fi
# weather end

# tmdb
AC_ARG_WITH(tmdb-dev-key,
	AS_HELP_STRING([--with-tmdb-dev-key=KEY], [API dev key to get data from tmdb data base, required for additional movie informations]),
	[TMDB_DEV_KEY="$withval"],
	[TMDB_DEV_KEY=""])
AC_DEFINE_UNQUOTED([TMDB_DEV_KEY], ["$TMDB_DEV_KEY"], [API dev key to get data from tmdb data base, required for additional movie informations])

AC_ARG_ENABLE([tmdb-key-manage],
	AS_HELP_STRING([--enable-tmdb-key-manage], [Enable manage tmdb api dev key via gui for additional movie informations @<:@default=yes@:>@]),
	[enable_tmdb_key_manage="$enableval"],
	[enable_tmdb_key_manage="yes"])

if test "$enable_tmdb_key_manage" = "yes" ; then
	AC_DEFINE([ENABLE_TMDB_KEY_MANAGE], 1, [Enable manage tmdb api dev key via gui for additional movie informations])
fi
# tmdb end

# omdb
AC_ARG_WITH(omdb-api-key,
	AS_HELP_STRING([--with-omdb-api-key=KEY], [API key to get additional epg data from omdb database at http://www.omdbapi.com, this database gets data from imdb service]),
	[OMDB_API_KEY="$withval"],
	[OMDB_API_KEY=""])
AC_DEFINE_UNQUOTED([OMDB_API_KEY], ["$OMDB_API_KEY"], [API key to get additional epg data from omdb database at http://www.omdbapi.com, this database gets data from imdb service])

AC_ARG_ENABLE([omdb-key-manage],
	AS_HELP_STRING([--enable-omdb-key-manage], [Enable manage omdb (imdb) api dev key via gui for additional movie informations @<:@default=yes@:>@]),
	[enable_omdb_key_manage="$enableval"],
	[enable_omdb_key_manage="yes"])

if test "$enable_omdb_key_manage" = "yes" ; then
	AC_DEFINE([ENABLE_OMDB_KEY_MANAGE], 1, [Enable manage omdb (imdb) api dev key via gui for additional movie informations])
fi
# omdb end

# shoutcast
AC_ARG_WITH(shoutcast-dev-key,
	AS_HELP_STRING([--with-shoutcast-dev-key=KEY], [API dev key to get stream data lists from ShoutCast service]),
	[SHOUTCAST_DEV_KEY="$withval"],
	[SHOUTCAST_DEV_KEY=""])
AC_DEFINE_UNQUOTED([SHOUTCAST_DEV_KEY], ["$SHOUTCAST_DEV_KEY"], [API dev key to get stream data lists from ShoutCast service])

AC_ARG_ENABLE([shoutcast-key-manage],
	AS_HELP_STRING([--enable-shoutcast-key-manage], [Enable manage of api dev key to get stream data lists from ShoutCast service via gui @<:@default=yes@:>@]),
	[enable_shoutcast_key_manage="$enableval"],
	[enable_shoutcast_key_manage="yes"])

if test "$enable_shoutcast_key_manage" = "yes" ; then
	AC_DEFINE([ENABLE_SHOUTCAST_KEY_MANAGE], 1, [Enable manage of api dev key to get stream data lists from ShoutCast service via gui])
fi
# shoutcast end

AC_ARG_ENABLE(reschange,
	AS_HELP_STRING([--enable-reschange], [enable change the osd resolution @<:@default for hd2 and hd51@:>@]),
	AC_DEFINE(ENABLE_CHANGE_OSD_RESOLUTION, 1, [enable change the osd resolution]))
AM_CONDITIONAL(ENABLE_RESCHANGE, test "$enable_reschange" = "yes")

# default theme
AC_ARG_WITH(default-theme,
	AS_HELP_STRING([--with-default-theme=THEMENAME], [Default theme for gui @<:@default is empty@:>@]),
	[default_theme="$withval"],
	[default_theme=""])
AC_DEFINE_UNQUOTED([DEFAULT_THEME], ["$default_theme"], [Default theme for gui])

# default oled theme
AC_ARG_WITH(default-oled-theme,
	AS_HELP_STRING([--with-default-oled-theme=THEMENAME], [Default theme for oled. @<:@default is empty@:>@]),
	[default_oled_theme="$withval"],
	[default_oled_theme=""])
AC_DEFINE_UNQUOTED([DEFAULT_OLED_THEME], ["$default_oled_theme"], [Default theme for oled.])

AC_MSG_CHECKING(target)

if test "$TARGET" = "native"; then
	AC_MSG_RESULT(native)

	if test "$CFLAGS" = "" -a "$CXXFLAGS" = ""; then
		CFLAGS="-Wall -O2 -pipe $DEBUG_CFLAGS"
		CXXFLAGS="-Wall -O2 -pipe $DEBUG_CFLAGS"
	fi
	if test "$prefix" = "NONE"; then
		prefix=/usr/local
	fi
	targetprefix=$prefix
	TARGET_PREFIX=$prefix
	AC_DEFINE_UNQUOTED(TARGET_PREFIX, "$TARGET_PREFIX", [The targets prefix])
elif test "$TARGET" = "cdk"; then
	AC_MSG_RESULT(cdk)

	if test "$CC" = "" -a "$CXX" = ""; then
		AC_MSG_ERROR([you need to specify variables CC or CXX in cdk])
	fi
	if test "$CFLAGS" = "" -o "$CXXFLAGS" = ""; then
		AC_MSG_ERROR([you need to specify variables CFLAGS and CXXFLAGS in cdk])
	fi
	if test "$prefix" = "NONE"; then
		AC_MSG_ERROR([invalid prefix, you need to specify one in cdk mode])
	fi
	if test "$TARGET_PREFIX" != "NONE"; then
		AC_DEFINE_UNQUOTED(TARGET_PREFIX, "$TARGET_PREFIX", [The targets prefix])
	fi
	if test "$TARGET_PREFIX" = "NONE"; then
		AC_MSG_ERROR([invalid targetprefix, you need to specify one in cdk mode])
		TARGET_PREFIX=""
	fi
else
	AC_MSG_RESULT(none)
	AC_MSG_ERROR([invalid target $TARGET, choose on from native,cdk]);
fi

if test "$exec_prefix" = "NONE"; then
	exec_prefix=$prefix
fi

AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_SYS_LARGEFILE

check_path() {
	return $(perl -e "if(\"$1\"=~m#^/usr/(local/)?bin#){print \"0\"}else{print \"1\";}")
}

])

dnl expand nested ${foo}/bar
AC_DEFUN([TUXBOX_EXPAND_VARIABLE], [
	__$1="$2"
	for __CNT in false false false false true; do dnl max 5 levels of indirection
		$1=`eval echo "$__$1"`
		echo ${$1} | grep -q '\$' || break # 'grep -q' is POSIX, exit if no $ in variable
		__$1="${$1}"
	done
	$__CNT && AC_MSG_ERROR([can't expand variable $1=$2]) dnl bail out if we did not expand
])

AC_DEFUN([TUXBOX_APPS_DIRECTORY_ONE], [
AC_ARG_WITH($1, AS_HELP_STRING([$6], [$7 [[PREFIX$4$5]]], [32], [79]), [
	_$2=$withval
	if test "$TARGET" = "cdk"; then
		$2=`eval echo "$TARGET_PREFIX$withval"` # no indirection possible IMNSHO
	else
		$2=$withval
	fi
	TARGET_$2=${$2}
], [
	# RFC 1925: "you can always add another level of indirection..."
	TUXBOX_EXPAND_VARIABLE($2,"${$3}$5")
	if test "$TARGET" = "cdk"; then
		TUXBOX_EXPAND_VARIABLE(_$2,"${target$3}$5")
	else
		_$2=${$2}
	fi
	TARGET_$2=$_$2
])
dnl AC_SUBST($2)
AC_DEFINE_UNQUOTED($2,"$_$2",$7)
AC_SUBST(TARGET_$2)
])

AC_DEFUN([TUXBOX_APPS_DIRECTORY], [
AC_REQUIRE([TUXBOX_APPS])

if test "$TARGET" = "cdk"; then
	datadir="\${prefix}/share"
	sysconfdir="\/etc"
	localstatedir="\/var"
	libdir="\${prefix}/lib"
	mntdir="\/mnt"
	targetdatadir="\${TARGET_PREFIX}/share"
	targetsysconfdir="\/etc"
	targetlocalstatedir="\/var"
	targetlibdir="\${TARGET_PREFIX}/lib"
	targetmntdir="\/mnt"
else
	mntdir="/mnt" # hack
fi

TUXBOX_APPS_DIRECTORY_ONE(configdir, CONFIGDIR, localstatedir, /var, /tuxbox/config,
	[--with-configdir=PATH], [where to find config files])

TUXBOX_APPS_DIRECTORY_ONE(zapitdir, ZAPITDIR, localstatedir, /var, /tuxbox/config/zapit,
	[--with-zapitdir=PATH], [where to find zapit files])

TUXBOX_APPS_DIRECTORY_ONE(datadir, DATADIR, datadir, /share, /tuxbox,
	[--with-datadir=PATH], [where to find data files])

TUXBOX_APPS_DIRECTORY_ONE(controldir, CONTROLDIR, datadir, /share, /tuxbox/neutrino/control,
	[--with-controldir=PATH], [where to find control scripts])

TUXBOX_APPS_DIRECTORY_ONE(controldir_var, CONTROLDIR_VAR, localstatedir, /var, /tuxbox/control,
	[--with-controldir_var=PATH], [where to find control scripts in /var])

TUXBOX_APPS_DIRECTORY_ONE(fontdir, FONTDIR, datadir, /share, /fonts,
	[--with-fontdir=PATH], [where to find fonts])

TUXBOX_APPS_DIRECTORY_ONE(fontdir_var, FONTDIR_VAR, localstatedir, /var, /tuxbox/fonts,
	[--with-fontdir_var=PATH], [where to find fonts in /var])

TUXBOX_APPS_DIRECTORY_ONE(gamesdir, GAMESDIR, localstatedir, /var, /tuxbox/games,
	[--with-gamesdir=PATH], [where to find games])

TUXBOX_APPS_DIRECTORY_ONE(libdir, LIBDIR, libdir, /lib, /tuxbox,
	[--with-libdir=PATH], [where to find internal libs])

TUXBOX_APPS_DIRECTORY_ONE(plugindir, PLUGINDIR, libdir, /lib, /tuxbox/plugins,
	[--with-plugindir=PATH], [where to find plugins])

TUXBOX_APPS_DIRECTORY_ONE(plugindir_var, PLUGINDIR_VAR, localstatedir, /var, /tuxbox/plugins,
	[--with-plugindir_var=PATH], [where to find plugins in /var])

TUXBOX_APPS_DIRECTORY_ONE(plugindir_mnt, PLUGINDIR_MNT, mntdir, /mnt, /plugins,
	[--with-plugindir_mnt=PATH], [where to find external plugins])

TUXBOX_APPS_DIRECTORY_ONE(luaplugindir, LUAPLUGINDIR, libdir, /lib, /tuxbox/luaplugins,
	[--with-luaplugindir=PATH], [where to find Lua plugins])

TUXBOX_APPS_DIRECTORY_ONE(webradiodir, WEBRADIODIR, datadir, /share, /tuxbox/neutrino/webradio,
	[--with-webradiodir=PATH], [where to find webradio content])

TUXBOX_APPS_DIRECTORY_ONE(webradiodir_var, WEBRADIODIR_VAR, localstatedir, /var, /tuxbox/webradio,
	[--with-webradiodir_var=PATH], [where to find webradio content in /var])

TUXBOX_APPS_DIRECTORY_ONE(webtvdir, WEBTVDIR, datadir, /share, /tuxbox/neutrino/webtv,
	[--with-webtvdir=PATH], [where to find webtv content])

TUXBOX_APPS_DIRECTORY_ONE(webtvdir_var, WEBTVDIR_VAR, localstatedir, /var, /tuxbox/webtv,
	[--with-webtvdir_var=PATH], [where to find webtv content in /var])

TUXBOX_APPS_DIRECTORY_ONE(localedir, LOCALEDIR,datadir, /share, /tuxbox/neutrino/locale,
	[--with-localedir=PATH], [where to find locale])

TUXBOX_APPS_DIRECTORY_ONE(localedir_var, LOCALEDIR_VAR, localstatedir, /var, /tuxbox/locale,
	[--with-localedir_var=PATH], [where to find locale in /var])

TUXBOX_APPS_DIRECTORY_ONE(themesdir, THEMESDIR, datadir, /share, /tuxbox/neutrino/themes,
	[--with-themesdir=PATH], [where to find themes])

TUXBOX_APPS_DIRECTORY_ONE(themesdir_var, THEMESDIR_VAR, localstatedir, /var, /tuxbox/themes,
	[--with-themesdir_var=PATH], [where to find themes in /var])

TUXBOX_APPS_DIRECTORY_ONE(iconsdir, ICONSDIR, datadir, /share, /tuxbox/neutrino/icons,
	[--with-iconsdir=PATH], [where to find icons])

TUXBOX_APPS_DIRECTORY_ONE(iconsdir_var, ICONSDIR_VAR, localstatedir, /var, /tuxbox/icons,
	[--with-iconsdir_var=PATH], [where to find icons in /var])

TUXBOX_APPS_DIRECTORY_ONE(lcd4liconsdir, LCD4L_ICONSDIR, datadir, /share, /tuxbox/neutrino/lcd/icons,
	[--with-lcd4liconsdir=PATH], [where to find lcd4linux icons])

TUXBOX_APPS_DIRECTORY_ONE(lcd4liconsdir_var, LCD4L_ICONSDIR_VAR, localstatedir, /var, /tuxbox/lcd/icons,
	[--with-lcd4liconsdir_var=PATH], [where to find lcd4linux icons in /var])

TUXBOX_APPS_DIRECTORY_ONE(private_httpddir, PRIVATE_HTTPDDIR, datadir, /share, /tuxbox/neutrino/httpd,
	[--with-private_httpddir=PATH], [where to find private httpd files])

TUXBOX_APPS_DIRECTORY_ONE(public_httpddir, PUBLIC_HTTPDDIR, localstatedir, /var, /tuxbox/httpd,
	[--with-public_httpddir=PATH], [where to find public httpd files])

TUXBOX_APPS_DIRECTORY_ONE(hosted_httpddir, HOSTED_HTTPDDIR, mntdir, /mnt, /hosted,
	[--with-hosted_httpddir=PATH], [where to find hosted files])
])

dnl automake <= 1.6 needs this specifications
AC_SUBST(CONFIGDIR)
AC_SUBST(ZAPITDIR)
AC_SUBST(DATADIR)
AC_SUBST(CONTROLDIR)
AC_SUBST(CONTROLDIR_VAR)
AC_SUBST(FONTDIR)
AC_SUBST(FONTDIR_VAR)
AC_SUBST(GAMESDIR)
AC_SUBST(LIBDIR)
AC_SUBST(MNTDIR)
AC_SUBST(PLUGINDIR)
AC_SUBST(PLUGINDIR_VAR)
AC_SUBST(PLUGINDIR_MNT)
AC_SUBST(LUAPLUGINDIR)
AC_SUBST(WEBRADIODIR)
AC_SUBST(WEBRADIODIR_VAR)
AC_SUBST(WEBTVDIR)
AC_SUBST(WEBTVDIR_VAR)
AC_SUBST(LOCALEDIR)
AC_SUBST(LOCALEDIR_VAR)
AC_SUBST(THEMESDIR)
AC_SUBST(THEMESDIR_VAR)
AC_SUBST(ICONSDIR)
AC_SUBST(ICONSDIR_VAR)
AC_SUBST(LCD4L_ICONSDIR)
AC_SUBST(LCD4L_ICONSDIR_VAR)
AC_SUBST(PRIVATE_HTTPDDIR)
AC_SUBST(PUBLIC_HTTPDDIR)
AC_SUBST(HOSTED_HTTPDDIR)
dnl end workaround

AC_DEFUN([_TUXBOX_APPS_LIB_CONFIG], [
AC_PATH_PROG($1_CONFIG,$2,no)
if test "$$1_CONFIG" != "no"; then
	if test "$TARGET" = "cdk" && check_path "$$1_CONFIG"; then
		AC_MSG_$3([could not find a suitable version of $2]);
	else
		if test "$1" = "CURL"; then
			$1_CFLAGS=$($$1_CONFIG --cflags)
			$1_LIBS=$($$1_CONFIG --libs)
		else
			if test "$1" = "FREETYPE"; then
			$1_CFLAGS=$($$1_CONFIG --cflags)
				$1_LIBS=$($$1_CONFIG --libs)
			else
				$1_CFLAGS=$($$1_CONFIG --prefix=$TARGET_PREFIX --cflags)
				$1_LIBS=$($$1_CONFIG --prefix=$TARGET_PREFIX --libs)
			fi
		fi
	fi
fi
AC_SUBST($1_CFLAGS)
AC_SUBST($1_LIBS)
])

AC_DEFUN([TUXBOX_APPS_LIB_CONFIG], [
_TUXBOX_APPS_LIB_CONFIG($1,$2,ERROR)
if test "$$1_CONFIG" = "no"; then
	AC_MSG_ERROR([could not find $2]);
fi
])

AC_DEFUN([TUXBOX_APPS_LIB_CONFIG_CHECK], [
_TUXBOX_APPS_LIB_CONFIG($1,$2,WARN)
])

AC_DEFUN([TUXBOX_APPS_PKGCONFIG], [
m4_pattern_forbid([^_?PKG_[A-Z_]+$])
m4_pattern_allow([^PKG_CONFIG(_PATH)?$])
AC_ARG_VAR([PKG_CONFIG], [path to pkg-config utility])dnl
if test "x$ac_cv_env_PKG_CONFIG_set" != "xset"; then
	AC_PATH_TOOL([PKG_CONFIG], [pkg-config])
fi
if test x"$PKG_CONFIG" = x"" ; then
	AC_MSG_ERROR([could not find pkg-config]);
fi
])

AC_DEFUN([_TUXBOX_APPS_LIB_PKGCONFIG], [
AC_REQUIRE([TUXBOX_APPS_PKGCONFIG])
AC_MSG_CHECKING(for package $2)
if $PKG_CONFIG --exists "$2" ; then
	AC_MSG_RESULT(yes)
	$1_CFLAGS=$($PKG_CONFIG --cflags "$2")
	$1_LIBS=$($PKG_CONFIG --libs "$2")
	$1_EXISTS=yes
else
	AC_MSG_RESULT(no)
fi
AC_SUBST($1_CFLAGS)
AC_SUBST($1_LIBS)
])

AC_DEFUN([TUXBOX_APPS_LIB_PKGCONFIG], [
_TUXBOX_APPS_LIB_PKGCONFIG($1,$2)
if test x"$$1_EXISTS" != xyes; then
	AC_MSG_ERROR([could not find package $2]);
fi
])

AC_DEFUN([TUXBOX_APPS_LIB_PKGCONFIG_CHECK], [
_TUXBOX_APPS_LIB_PKGCONFIG($1,$2)
])

AC_DEFUN([TUXBOX_BOXTYPE], [
AC_ARG_WITH(boxtype,
	AS_HELP_STRING([--with-boxtype], [valid values: coolstream, generic, armbox, mipsbox]),
	[case "${withval}" in
		generic|armbox)
			BOXTYPE="$withval"
		;;
		hd51|multibox|multiboxse|e4hdultra|protek4k|hd60|hd61|bre2ze4k|osmini4k|osmio4k|osmio4kplus|h7|vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuzero4k|vuuno4kse|vuuno4k|sf8008|sf8008m|ustym4kpro|ustym4ks2ottx|h9combo|h9|gbue4k)
			BOXTYPE="armbox"
			BOXMODEL="$withval"
		;;
		*)
			AC_MSG_ERROR([bad value $withval for --with-boxtype])
		;;
	esac],
	[BOXTYPE="generic"])

AC_ARG_WITH(boxmodel,
	AS_HELP_STRING([--with-boxmodel], [valid for armbox: hd51, multibox, multiboxse, e4hdultra, protek4k, hd60, hd61, bre2ze4k, osmini4k, osmio4k, osmio4kplus, h7, vusolo4k, vuduo4k, vuduo4kse, vuultimo4k, vuzero4k, vuuno4kse, vuuno4k, sf8008, sf8008m, ustym4kpro, ustym4ks2ottx, h9combo, h9, gbue4k])
	[case "${withval}" in
		hd51|multibox|multiboxse|e4hdultra|protek4k|hd60|hd61|bre2ze4k|osmini4k|osmio4k|osmio4kplus|h7|vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuzero4k|vuuno4kse|vuuno4k|sf8008|sf8008m|ustym4kpro|ustym4ks2ottx|h9combo|h9|gbue4k)
			if test "$BOXTYPE" = "armbox"; then
				BOXMODEL="$withval"
			else
				AC_MSG_ERROR([unknown model $withval for boxtype $BOXTYPE])
			fi
		;;
		*)
			AC_MSG_ERROR([unsupported value $withval for --with-boxmodel])
		;;
	esac])

AC_SUBST(BOXTYPE)
AC_SUBST(BOXMODEL)

AM_CONDITIONAL(BOXTYPE_GENERIC, test "$BOXTYPE" = "generic")
AM_CONDITIONAL(BOXTYPE_ARMBOX, test "$BOXTYPE" = "armbox")

AM_CONDITIONAL(BOXMODEL_MULTIBOX, test "$BOXMODEL" = "multibox")
AM_CONDITIONAL(BOXMODEL_MULTIBOXSE, test "$BOXMODEL" = "multiboxse")
AM_CONDITIONAL(BOXMODEL_HD60, test "$BOXMODEL" = "hd60")
AM_CONDITIONAL(BOXMODEL_HD61, test "$BOXMODEL" = "hd61")

AM_CONDITIONAL(BOXMODEL_HD51, test "$BOXMODEL" = "hd51")
AM_CONDITIONAL(BOXMODEL_BRE2ZE4K, test "$BOXMODEL" = "bre2ze4k")
AM_CONDITIONAL(BOXMODEL_H7, test "$BOXMODEL" = "h7")

AM_CONDITIONAL(BOXMODEL_E4HDULTRA, test "$BOXMODEL" = "e4hdultra")
AM_CONDITIONAL(BOXMODEL_PROTEK4K, test "$BOXMODEL" = "protek4k")

AM_CONDITIONAL(BOXMODEL_OSMINI4K, test "$BOXMODEL" = "osmini4k")
AM_CONDITIONAL(BOXMODEL_OSMIO4K, test "$BOXMODEL" = "osmio4k")
AM_CONDITIONAL(BOXMODEL_OSMIO4KPLUS, test "$BOXMODEL" = "osmio4kplus")

AM_CONDITIONAL(BOXMODEL_VUSOLO4K, test "$BOXMODEL" = "vusolo4k")
AM_CONDITIONAL(BOXMODEL_VUDUO4K, test "$BOXMODEL" = "vuduo4k")
AM_CONDITIONAL(BOXMODEL_VUDUO4KSE, test "$BOXMODEL" = "vuduo4kse")
AM_CONDITIONAL(BOXMODEL_VUULTIMO4K, test "$BOXMODEL" = "vuultimo4k")
AM_CONDITIONAL(BOXMODEL_VUUNO4KSE, test "$BOXMODEL" = "vuuno4kse")
AM_CONDITIONAL(BOXMODEL_VUUNO4K, test "$BOXMODEL" = "vuuno4k")
AM_CONDITIONAL(BOXMODEL_VUZERO4K, test "$BOXMODEL" = "vuzero4k")

AM_CONDITIONAL(BOXMODEL_SF8008, test "$BOXMODEL" = "sf8008")
AM_CONDITIONAL(BOXMODEL_SF8008M, test "$BOXMODEL" = "sf8008m")
AM_CONDITIONAL(BOXMODEL_USTYM4KPRO, test "$BOXMODEL" = "ustym4kpro")
AM_CONDITIONAL(BOXMODEL_USTYM4KS2OTTX, test "$BOXMODEL" = "ustym4ks2ottx")
AM_CONDITIONAL(BOXMODEL_H9COMBO, test "$BOXMODEL" = "h9combo")
AM_CONDITIONAL(BOXMODEL_H9, test "$BOXMODEL" = "h9")
AM_CONDITIONAL(BOXMODEL_GBUE4K, test "$BOXMODEL" = "gbue4k")

AM_CONDITIONAL(BOXMODEL_VUPLUS_ALL, test "$BOXMODEL" = "vusolo4k" -o "$BOXMODEL" = "vuduo4k" -o "$BOXMODEL" = "vuduo4kse" -o "$BOXMODEL" = "vuultimo4k" -o "$BOXMODEL" = "vuzero4k" -o "$BOXMODEL" = "vuuno4kse" -o "$BOXMODEL" = "vuuno4k")
AM_CONDITIONAL(BOXMODEL_VUPLUS_ARM, test "$BOXMODEL" = "vusolo4k" -o "$BOXMODEL" = "vuduo4k" -o "$BOXMODEL" = "vuduo4kse" -o "$BOXMODEL" = "vuultimo4k" -o "$BOXMODEL" = "vuzero4k" -o "$BOXMODEL" = "vuuno4kse" -o "$BOXMODEL" = "vuuno4k")

AM_CONDITIONAL(BOXMODEL_HISILICON, test "$BOXMODEL" = "hd60" -o "$BOXMODEL" = "hd61" -o "$BOXMODEL" = "multibox" -o "$BOXMODEL" = "multiboxse" -o "$BOXMODEL" = "sf8008" -o "$BOXMODEL" = "sf8008m" -o "$BOXMODEL" = "ustym4kpro" -o "$BOXMODEL" = "ustym4ks2ottx" -o "$BOXMODEL" = "h9combo")

if test "$BOXTYPE" = "generic"; then
	AC_DEFINE(HAVE_GENERIC_HARDWARE, 1, [building for a generic device like a standard PC])
	AC_DEFINE(ENABLE_CHANGE_OSD_RESOLUTION, 1, [enable to change osd resolution])
elif test "$BOXTYPE" = "armbox"; then
	AC_DEFINE(HAVE_ARM_HARDWARE, 1, [building for an armbox])
fi

# TODO: do we need more defines?
if test "$BOXMODEL" = "multibox"; then
	AC_DEFINE(BOXMODEL_MULTIBOX, 1, [multibox])
elif test "$BOXMODEL" = "multiboxse"; then
	AC_DEFINE(BOXMODEL_MULTIBOXSE, 1, [multiboxse])
elif test "$BOXMODEL" = "hd60"; then
	AC_DEFINE(BOXMODEL_HD60, 1, [hd60])
elif test "$BOXMODEL" = "hd61"; then
	AC_DEFINE(BOXMODEL_HD61, 1, [hd61])
elif test "$BOXMODEL" = "hd51"; then
	AC_DEFINE(BOXMODEL_HD51, 1, [hd51])
elif test "$BOXMODEL" = "bre2ze4k"; then
	AC_DEFINE(BOXMODEL_BRE2ZE4K, 1, [bre2ze4k])
elif test "$BOXMODEL" = "h7"; then
	AC_DEFINE(BOXMODEL_H7, 1, [h7])
elif test "$BOXMODEL" = "e4hdultra"; then
	AC_DEFINE(BOXMODEL_E4HDULTRA, 1, [e4hdultra])
elif test "$BOXMODEL" = "protek4k"; then
	AC_DEFINE(BOXMODEL_PROTEK4K, 1, [protek4k])
elif test "$BOXMODEL" = "vusolo4k"; then
	AC_DEFINE(BOXMODEL_VUSOLO4K, 1, [vusolo4k])
elif test "$BOXMODEL" = "vuduo4k"; then
	AC_DEFINE(BOXMODEL_VUDUO4K, 1, [vuduo4k])
elif test "$BOXMODEL" = "vuduo4kse"; then
	AC_DEFINE(BOXMODEL_VUDUO4KSE, 1, [vuduo4kse])
elif test "$BOXMODEL" = "vuultimo4k"; then
	AC_DEFINE(BOXMODEL_VUULTIMO4K, 1, [vuultimo4k])
elif test "$BOXMODEL" = "vuzero4k"; then
	AC_DEFINE(BOXMODEL_VUZERO4K, 1, [vuzero4k])
elif test "$BOXMODEL" = "vuuno4kse"; then
	AC_DEFINE(BOXMODEL_VUUNO4KSE, 1, [vuuno4kse])
elif test "$BOXMODEL" = "vuuno4k"; then
	AC_DEFINE(BOXMODEL_VUUNO4K, 1, [vuuno4k])
elif test "$BOXMODEL" = "osmini4k"; then
	AC_DEFINE(BOXMODEL_OSMINI4K, 1, [osmini4k])
elif test "$BOXMODEL" = "osmio4k"; then
	AC_DEFINE(BOXMODEL_OSMIO4K, 1, [osmio4k])
elif test "$BOXMODEL" = "osmio4kplus"; then
	AC_DEFINE(BOXMODEL_OSMIO4KPLUS, 1, [osmio4kplus])
elif test "$BOXMODEL" = "sf8008"; then
	AC_DEFINE(BOXMODEL_SF8008, 1, [sf8008])
elif test "$BOXMODEL" = "sf8008m"; then
	AC_DEFINE(BOXMODEL_SF8008M, 1, [sf8008m])
elif test "$BOXMODEL" = "ustym4kpro"; then
	AC_DEFINE(BOXMODEL_USTYM4KPRO, 1, [ustym4kpro])
elif test "$BOXMODEL" = "ustym4ks2ottx"; then
	AC_DEFINE(BOXMODEL_USTYM4KS2OTTX, 1, [ustym4ks2ottx])
elif test "$BOXMODEL" = "h9combo"; then
	AC_DEFINE(BOXMODEL_H9COMBO, 1, [h9combo])
elif test "$BOXMODEL" = "h9"; then
	AC_DEFINE(BOXMODEL_H9, 1, [h9])
elif test "$BOXMODEL" = "gbue4k"; then
	AC_DEFINE(BOXMODEL_GBUE4K, 1, [gbue4k])
fi

# Support Boxmodel with OSD-Resolution
case "$BOXMODEL" in
	bre2ze4k|hd51|multibox|multiboxse|e4hdultra|protek4k|hd60|hd61|vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuzero4k|vuuno4kse|vuuno4k|h7|osmini4k|osmio4k|osmio4kplus|sf8008|sf8008m|ustym4kpro|ustym4ks2ottx|h9combo|h9|gbue4k)
		AC_DEFINE(ENABLE_CHANGE_OSD_RESOLUTION, 1, [enable to change osd resolution])
	;;
esac

# vuplus & gigablue uhd ue 4k enable quadpip
AM_CONDITIONAL(ENABLE_QUADPIP, test "$BOXMODEL" = "vusolo4k" -o "$BOXMODEL" = "vuduo4k" -o "$BOXMODEL" = "vuduo4kse" -o "$BOXMODEL" = "vuuno4kse"  -o "$BOXMODEL" = "vuultimo4k" -o "$BOXMODEL" = "vuuno4k" -o "$BOXMODEL" = "vuuno4kse" -o "$BOXMODEL" = "gbue4k")
case "$BOXMODEL" in
	vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuuno4k|vuuno4kse|gbue4k)
		AC_DEFINE(ENABLE_QUADPIP, 1, [enable quad picture in picture support])
	;;
esac

# all vuplus BOXMODELs
case "$BOXMODEL" in
	vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuuno4k|vuuno4kse|vuzero4k)
		AC_DEFINE(BOXMODEL_VUPLUS_ALL, 1, [vuplus_all])
	;;
esac

# all vuplus arm BOXMODELs
case "$BOXMODEL" in
	vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuuno4k|vuuno4kse|vuzero4k)
		AC_DEFINE(BOXMODEL_VUPLUS_ARM, 1, [vuplus_arm])
	;;
esac

# all hisilicon BOXMODELs
case "$BOXMODEL" in
	hd60|hd61|multibox|multiboxse|sf8008|sf8008m|ustym4kpro|ustym4ks2ottx|h9combo|h9)
		AC_DEFINE(BOXMODEL_HISILICON, 1, [hisilicon])
	;;
esac
])

dnl backward compatiblity
AC_DEFUN([AC_GNU_SOURCE], [
AH_VERBATIM([_GNU_SOURCE], [
/* Enable GNU extensions on systems that have them. */
#ifndef _GNU_SOURCE
# undef _GNU_SOURCE
#endif
])dnl
AC_BEFORE([$0], [AC_COMPILE_IFELSE])dnl
AC_BEFORE([$0], [AC_RUN_IFELSE])dnl
AC_DEFINE([_GNU_SOURCE])
])

AC_DEFUN([AC_PROG_EGREP], [
AC_CACHE_CHECK([for egrep], [ac_cv_prog_egrep], [
if echo a | (grep -E '(a|b)') >/dev/null 2>&1; then
	ac_cv_prog_egrep='grep -E'
else
	ac_cv_prog_egrep='egrep'
fi
])
EGREP=$ac_cv_prog_egrep
AC_SUBST([EGREP])
])
