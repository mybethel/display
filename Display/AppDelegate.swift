//
//  AppDelegate.swift
//  Display
//
//  Created by Albert Martin on 9/4/16.
//  Copyright © 2016 Bethel Technologies, LLC. All rights reserved.
//
import Cocoa
import Swifter

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var statusMenu: NSMenu!
  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)

  @IBOutlet weak var display: DisplayView!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let icon = NSImage(named: "StatusIcon")
    icon?.template = true

    let server = DisplayAPI()
    do {
      try server.start(1776, forceIPv4: false, priority: DISPATCH_QUEUE_PRIORITY_BACKGROUND)
    } catch {
      NSLog("unable to start display server")
    }

    statusItem.image = icon
    statusItem.menu = statusMenu

    window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.ScreenSaverWindowLevelKey))
    window.contentView!.layer?.backgroundColor = NSColor.blackColor().CGColor

    display.helloWorld()
  }

  @IBAction func quit(sender: AnyObject) {
    NSApplication.sharedApplication().terminate(self)
  }

}

