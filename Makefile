all:
	cd doc && $(MAKE)
	cd po && $(MAKE)

deb:
	./make_deb.sh

po/amir.pot:amir/*.py amir/database/*.py bin/amir.py data/ui/*.glade

translate:po/fa.po
	xgettext -k_ -kN_ -o po/amir.pot amir/*.py amir/database/*.py bin/amir.py data/ui/*.glade
	msgmerge po/fa.po po/amir.pot -o po/fa.po

clean:
	rm -rf amir*.deb
	cd doc && $(MAKE) $@
	cd po && $(MAKE) $@

.PHONY:all deb translate clean

