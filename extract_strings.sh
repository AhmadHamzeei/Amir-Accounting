#!/bin/sh
xgettext -k_ -kN_ -o po/amir.pot amir/*.py amir/database/*.py bin/amir.py data/ui/*.glade
msgmerge po/fa.po po/amir.pot -o po/fa.po

