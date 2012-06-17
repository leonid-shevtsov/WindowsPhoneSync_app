WindowsPhoneSync.app: WindowsPhoneSync.applescript WindowsPhoneSync.icns clickdrag.py
	osacompile -o "WindowsPhoneSync.app" WindowsPhoneSync.applescript
	cp WindowsPhoneSync.icns WindowsPhoneSync.app/Contents/Resources/applet.icns
	cp clickdrag.py WindowsPhoneSync.app/Contents/Resources/clickdrag.py

clean:
	rm -rf WindowsPhoneSync.app
