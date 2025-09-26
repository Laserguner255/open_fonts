#!/system/bin/sh
MANUFACTER=$(getprop ro.product.manufacturer)
STANDARD_FOLDER="$MODPATH"/system/fonts
STATUS=0
SKIP_INSTALLATION=0
NEXT_SELECTION=1

system_font() {
	FONT_NAME="MapleMono"
	FONT_URL=https://github.com/subframe7536/maple-font/raw/refs/heads/variable/source/MapleMono%5Bwght%5D-VF.ttf
	FONT_NAME_ITALIC="MapleMono-Italic"
	FONT_URL_ITALIC=https://github.com/subframe7536/maple-font/raw/refs/heads/variable/source/MapleMono-Italic%5Bwght%5D-VF.ttf
}

monospace_font() {
	FONT_NAME="MapleMono-Mono"
	FONT_URL=https://github.com/subframe7536/maple-font/raw/refs/heads/variable/source/MapleMono%5Bwght%5D-VF.ttf
}
download_file() {
	STATUS = 0
	ui_print "    Downloading ${1}..."

	curl -kLo "$TMPDIR"/"${1}.ttf" $2

	if [[ ! -f "$TMPDIR"/"${1}.ttf" ]]; then
		STATUS=0
	else
		STATUS=1
	fi
}
install_font() {
	STANDARD_FONT_NAME="Roboto-Regular.ttf"
	ui_print "    Replacing..."
	cp_ch "$TMPDIR"/"${FONT_NAME}.ttf" $STANDARD_FOLDER/"$STANDARD_FONT_NAME"

	if [ $API -ge 31 ]; then
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoStatic-Regular.ttf
	else
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-Thin.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-Light.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-Medium.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-Bold.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-Black.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-Thin.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-Light.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-Medium.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-Bold.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-Black.ttf
		STANDARD_FONT_NAME="Roboto-Italic.ttf"
		cp_ch "$TMPDIR"/"${FONT_NAME_ITALIC}.ttf" $STANDARD_FOLDER/"$STANDARD_FONT_NAME"
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-ThinItalic.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-LightItalic.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-MediumItalic.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-BoldItalic.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Roboto-BlackItalic.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-ThinItalic.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-LightItalic.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-MediumItalic.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-BoldItalic.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoCondensed-BlackItalic.ttf
	fi
}
install_clock_font() {
	ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/AndroidClock.ttf

	if [ $MANUFACTER = "Samsung" ]; then
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/SECNum-3L.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/SECNum-3R.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Clock2019L-RM.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Clock2021.ttf
		ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Clock2021_Fixed.ttf
		if [ $API -lt 31 ]; then
			ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Clock2016.ttf
			ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Clock2017L.ttf
			ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Clock2017R.ttf
			ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/Clock2019L.ttf
			ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoNum-3L.ttf
			ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/RobotoNum-3R.ttf
		fi
	fi
	ui_print "    Android clock font replaced!"
}
install_mono_font() {
	STANDARD_FONT_NAME="DroidSansMono.ttf"
	ui_print "    Replacing..."
	cp_ch "$TMPDIR"/"${FONT_NAME}.ttf" $STANDARD_FOLDER/"$STANDARD_FONT_NAME"

	ln -s ./"$STANDARD_FONT_NAME" $STANDARD_FOLDER/CutiveMono.ttf
	ui_print "  Fonts replaced!"
}
check_status() {
	if [ "${STATUS}" -eq 0 ]; then
		ui_print ""
		ui_print "  !!! Download failed !!!"
		ui_print ""
		exit 1
	fi
}
reset_variable() {
	SKIP_INSTALLATION=0
	NEXT_SELECTION=1
}
clean_up() {
	rm -rf $STANDARD_FOLDER/placeholder
}

# replace system font
ui_print "- Do you want to replace the system font?"
ui_print "  [Vol+ = yes, Vol- = no]"
if chooseport 30; then
	system_font
	download_file $FONT_NAME $FONT_URL
	download_file $FONT_NAME_ITALIC $FONT_URL_ITALIC
	check_status
	install_font
	install_clock_font
	ui_print "  System font replaced!"
else
	ui_print "  System font not replaced"
fi

# replace monospaced font
reset_variable
ui_print "- Do you want to replace the monospace font?"
ui_print "  [Vol+ = yes, Vol- = no]"
if chooseport 30; then
	monospace_font
	download_file $FONT_NAME $FONT_URL
	check_status
	install_mono_font
	ui_print "  Monospace font Replaced"
else
	ui_print "  Monospace font not replaced"
fi
clean_up
