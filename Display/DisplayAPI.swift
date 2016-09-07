//
//  DisplayAPI.swift
//  Display
//
//  Created by Albert Martin on 9/4/16.
//  Copyright © 2016 Bethel Technologies, LLC. All rights reserved.
//
import Cocoa
import Swifter

public func DisplayAPI() -> HttpServer {

  let display = (NSApplication.sharedApplication().delegate as! AppDelegate).display;
  let server = HttpServer()

  server.POST["/render/graphic"] = { request in
    let payload = String(bytes: request.body, encoding: NSUTF8StringEncoding);
    dispatch_async(dispatch_get_main_queue()) {
      display.renderGraphic(payload!)
    }
    return HttpResponse.OK(.Text("success"))
  }

  server.POST["/render/html"] = { request in
    let payload = String(bytes: request.body, encoding: NSUTF8StringEncoding);
    dispatch_async(dispatch_get_main_queue()) {
      display.renderHtml(payload!)
    }
    return HttpResponse.OK(.Html(payload!))
  }

  server.POST["/render/toggle"] = { request in
    dispatch_async(dispatch_get_main_queue()) {
      display.toggleVisibility()
    }
    return HttpResponse.OK(.Text(String(!display.currentVisibility)))
  }

  return server

}
