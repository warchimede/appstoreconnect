#!/bin/bash -e

swift build -c release
cp .build/release/appstoreconnect /usr/local/bin