#!/bin/sh
srcdir=`dirname $0`
[ -z "$srcdir" ] && srcdir=.

if [ ! -f "$srcdir/configure.ac" ]; then
	echo "$srcdir doesn't look like source directory for GNOME Chess" >&2
	exit 1
fi

which gnome-autogen.sh || {
	echo "You need to install gnome-common from GNOME Git"
	exit 1
}

if [ -d .git ] && [ ! -e .git/hooks/pre-commit ]; then
	ln -s ../libgames-support/style-checker .git/hooks/pre-commit && echo "Enabled pre-commit style checker." || :
fi

. gnome-autogen.sh "$@"
