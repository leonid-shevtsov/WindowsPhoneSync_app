# Windows Phone Sync app

This is an OS X script that makes living with a Windows Phone 7 easier.

## Problem

It is notoriosly hard to download photos and videos shot with a Windows Phone: it's not mountable as a USB drive, and the only way to access the phone is through the [Windows Phone  7 Connector](http://www.microsoft.com/windowsphone/en-us/apps/mac-connector.aspx); and even the connector only allows you to import the photos into iPhoto or Aperture.

It can also copy the files into a folder by drag-and-dropping them from the Connector to a Finder window. Not only the operation is manual and mouse-operated, but the copy operation does not handle
duplicates *at all*, and if the files are present in the target location, it creates more copies of them. So you're going to have to manually select all new, non-downloaded photos.

I tried this once and did not like it at all.

## Solution

So I wrote an AppleScript which

1. opens up Windows Phone 7 Connector;
2. selects all the files on the phone
3. copies them to a temporary folder
4. syncs the temporary folder with a folder called "Windows Phone" in your home directory

Result: the "Windows Phone" folder contains all files from your phone, with no duplicates.

The procedure is entirely automated, but unfortunately you can't use your Mac while it's running (because it requires keyboard and mouse control).

## Installation

* Install the [Windows Phone 7 Connector](http://www.microsoft.com/windowsphone/en-us/apps/mac-connector.aspx).
* Download [the WindowsPhoneSync package](https://github.com/leonid-shevtsov/WindowsPhoneSync_app/downloads).
* Proceed as usual.


## Compilation

You can use the supplied `Makefile` to build the application from source.

* * *

(c) 2012 [Leonid Shevtsov](http://leonid.shevtsov.me)

