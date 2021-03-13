install:
	swift build -c release
	install .build/release/appstoreconnect /usr/local/bin/appstoreconnect