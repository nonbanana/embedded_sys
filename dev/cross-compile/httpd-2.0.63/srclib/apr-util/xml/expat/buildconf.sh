#! /bin/sh

#
# Build aclocal.m4 from libtool's libtool.m4
#
libtoolize=`conftools/PrintPath glibtoolize libtoolize`
if [ "x$libtoolize" = "x" ]; then
    echo "libtoolize not found in path"
    exit 1
fi

# Remove any m4 cache and libtool files so one can switch between
# autoconf and libtool versions by simply rerunning the buildconf script.
#
(cd conftools ; rm -f ltconfig ltmain.sh)
rm -rf aclocal.m4 libtool.m4 ltsugar.m4 autom4te*.cache

ltpath=`dirname $libtoolize`
ltfile=${LIBTOOL_M4-`cd $ltpath/../share/aclocal ; pwd`/libtool.m4}
echo "Incorporating $ltfile into aclocal.m4 ..."
echo "dnl THIS FILE IS AUTOMATICALLY GENERATED BY buildconf.sh" > aclocal.m4
echo "dnl edits here will be lost" >> aclocal.m4
cat $ltfile >> aclocal.m4

cross_compile_warning="warning: AC_TRY_RUN called without default to allow cross compiling"

#
# Create the libtool helper files
#
# Note: we copy (rather than link) the files.
#
# Note: This bundled version of expat will not always replace the
# files since we have a special config.guess/config.sub that we
# want to ensure is used.
echo "Copying libtool helper files ..."

$libtoolize --copy --automake

#
# Generate the autoconf header template (config.h.in) and ./configure
#
echo "Creating config.h.in ..."
${AUTOHEADER:-autoheader} 2>&1 | grep -v "$cross_compile_warning"

echo "Creating configure ..."
### do some work to toss config.cache?
${AUTOCONF:-autoconf} 2>&1 | grep -v "$cross_compile_warning"

# Remove autoconf caches
rm -rf autom4te*.cache

exit 0