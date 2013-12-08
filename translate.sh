#!/bin/bash
#Перевод выделенного мышкой текста, вывод перевода на экран с помощью zenity, копирование результата в буфер обмена
#Translate selected text with the mouse

HELP="\
Usage:	`basename $0` [-e]
Translate selected text with the mouse and copy the result to the clipboard

Options:
  -e    Open edit-text-dialog box for edit text, select language and transfer output to the screen using zenity"
#import text from selection
INTEXT="$(xclip -o)"	
#default translate language
TOLANG="ru"		

if	[[ $1 = "-e" ]]; 
then
	#edit text before translate
	INTEXT=$(echo -n $INTEXT | zenity --text-info --editable --width=600 --height=400)
	#select language
	TOLANG=$(zenity --height=280 --width=80 --list --radiolist --title="Translate"\
	--text="Translate to:" --column=" " --column="Language" FALSE ru TRUE en FALSE de FALSE es FALSE it FALSE ja)
	#translate
	OUTTEXT=`gtranslate.sh "$INTEXT" "$TOLANG"`
	zenity --info --title="Translate" --text="$OUTTEXT"
	echo "$OUTTEXT" | xclip -selection clipboard 

elif	[[ $1 = "-h" || $1 = "--help" ]];
then
	echo "$HELP"; exit 1;
fi

OUTTEXT=`gtranslate.sh "$INTEXT" "$TOLANG"`
notify-send "$OUTTEXT"
echo "$OUTTEXT" | xclip -selection clipboard 

