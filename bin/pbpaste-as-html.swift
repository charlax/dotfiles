#!/usr/bin/env swift

// taken from https://stackoverflow.com/questions/17217450/how-to-get-html-data-out-of-of-the-os-x-pasteboard-clipboard

import Cocoa

let type = NSPasteboard.PasteboardType.html

if let string = NSPasteboard.general.string(forType:type) {
  print(string)
}
else {
  print("Could not find string data of type '\(type)' on the system pasteboard")
  exit(1)
}
