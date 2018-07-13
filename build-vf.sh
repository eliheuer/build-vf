echo "\n*** STARTING BUILD VF ***********************"

# Set variables
GITROOTDIR=~/Type/Dosis
FONTSOURCE=Dosis.glyphs
FONTFILE=Dosis-vf.ttf

echo " "
cd $GITROOTDIR
echo Moving into:
pwd

# Checks
echo "\n*** Checking if gftools is installed ********"
if command -v gftools >/dev/null; then
    echo '    gftools is installed! :-)'
else
    echo '    gftools absent :-('
fi

echo "\n*** Checking if fontmake is installed *******"
if command -v fontmake >/dev/null; then
    echo '    fontmake is installed! :-)'
else
    echo '    fontmake absent :-('
fi

echo "\n*** Checking if fontbakery is installed *******"
if command -v fontbakery >/dev/null; then
    echo '    fontbakery is installed! :-)'
else
    echo '    fontbakery absent :-('
    echo '    Get it here: '
    echo '    or run: pip install fontbakery'
fi

# Build with fontmake
echo "\n*** building with fontmake ******************"
fontmake -g source/$FONTSOURCE -o variable &&
echo "\n*** Done :-) ********************************"

# Fix no Hinting
echo "\n*** start gftools-fix-nonhinting.py *********"
gftools fix-nonhinting \
    variable_ttf/$FONTFILE \
    variable_ttf/$FONTFILE.fix &&
rm -rf variable_ttf/$FONTFILE
mv variable_ttf/$FONTFILE.fix variable_ttf/$FONTFILE
echo "\n*** Done :-) ********************************"

# Run autohint
echo "\n*** start ttfautohint ***********************"
ttfautohint \
    variable_ttf/$FONTFILE \
    variable_ttf/$FONTFILE.fix &&
rm -rf variable_ttf/$FONTFILE
mv variable_ttf/$FONTFILE.fix variable_ttf/$FONTFILE
echo "\n*** Done :-) ********************************"

# Fix no dsgi
echo "\n*** start gftools-fix-dsig.py ***************"
gftools fix-dsig \
    variable_ttf/$FONTFILE --autofix
echo "\n*** Done :-) ********************************"

echo "\n*** Moving Font file to fonts/ **************"
rm -rf fonts/$FONTFILE
cp variable_ttf/$FONTFILE fonts/$FONTFILE

echo "\n*** delete temp dirs **************"
rm -rf master_ufo/ variable_ttf/

# Run fontbakery
echo "\n*** start fontbakery *********"
fontbakery check-googlefonts fonts/$FONTFILE
echo "\n*** Done :-) ********************************"



