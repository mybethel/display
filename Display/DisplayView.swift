//
//  DisplayView.swift
//  Display
//
//  Created by Albert Martin on 9/4/16.
//  Copyright © 2016 Bethel Technologies, LLC. All rights reserved.
//
import Cocoa
import WebKit

public class DisplayView: NSView {

  public var webLayer = DisplayLayerWeb()
  public var graphicLayer = DisplayLayerGraphic()
  public var transitionSpeed: Double = 0;

  public var currentVisibility: Bool {
    get {
      return self.layer?.opacity > 0
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    didLoad()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    didLoad()
  }

  convenience init() {
    self.init(frame: CGRectZero)
  }

  func didLoad() {
    wantsLayer = true

    webLayer.frame = bounds
    graphicLayer.frame = bounds

    addSubview(webLayer)
    addSubview(graphicLayer, positioned: .Below, relativeTo: webLayer)
  }

  func helloWorld() {
    self.renderHtml("<html><style type='text/css'>html,body{pointer-events:none;color:#FFF;font-family:sans-serif;width:100%;height:100%%;display:flex;align-items:center;justify-content:center;}</style><body>Hello World</body></html>")
  }

  func renderGraphic(path: String) {
    let graphicLayerNew = duplicateLayer(graphicLayer) as! DisplayLayerGraphic
    addSubview(graphicLayerNew, positioned: .Below, relativeTo: webLayer)
    graphicLayerNew.layer?.opacity = 0.0

    let graphic: NSImage
    if (path == "") {
      graphic = NSImage()
    } else {
      graphic = NSImage.init(contentsOfFile: NSString(string: path).stringByExpandingTildeInPath)!
    }

    graphicLayerNew.image = graphic

    crossFade(graphicLayerNew.layer!, old: graphicLayer.layer!, completion: { () -> Void in
      self.graphicLayer.removeFromSuperview()
      self.graphicLayer = graphicLayerNew
    })
  }

  func renderHtml(string: String) {
    let webLayerNew = duplicateLayer(webLayer) as! DisplayLayerWeb
    webLayerNew.mainFrame.loadHTMLString(string, baseURL: nil)
    addSubview(webLayerNew)
    webLayerNew.layer?.opacity = 0.0

    crossFade(webLayerNew.layer!, old: webLayer.layer!, completion: { () -> Void in
      self.webLayer.removeFromSuperview()
      self.webLayer = webLayerNew
    })
  }

  func toggleVisibility() {
    if (transitionSpeed == 0) {
      layer?.opacity = layer!.opacity > 0 ? 0 : 1
      return
    }

    let animation: CABasicAnimation = fadeAnimation(layer!)
    layer?.addAnimation(animation, forKey: "opacity")
  }

  func duplicateLayer(old: NSView) -> AnyObject? {
    let archivedView = NSKeyedArchiver.archivedDataWithRootObject(old)
    return NSKeyedUnarchiver.unarchiveObjectWithData(archivedView)
  }

  func crossFade(new: CALayer, old: CALayer, completion: () -> Void) {
    if (transitionSpeed == 0) {
      new.opacity = 1
      old.opacity = 0
      return completion()
    }

    CATransaction.begin()

    let animateNew = fadeAnimation(new)
    let animateOld = fadeAnimation(old)

    CATransaction.setCompletionBlock(completion)

    new.addAnimation(animateNew, forKey: "opacity")
    old.addAnimation(animateOld, forKey: "opacity")

    CATransaction.commit()
  }

  func fadeAnimation(animateLayer: CALayer) -> CABasicAnimation {
    let animation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = animateLayer.opacity
    animation.toValue = animateLayer.opacity > 0 ? 0 : 1
    animation.duration = transitionSpeed
    animation.fillMode = kCAFillModeForwards
    animation.removedOnCompletion = false
    animation.autoreverses = false

    animation.setValue(animateLayer, forKey: "parentLayer")
    return animation
  }

}

public class DisplayLayerWeb: WebView, WebUIDelegate {

  override init(frame: CGRect) {
    super.init(frame: frame)
    didLoad()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    didLoad()
  }

  override init!(frame: NSRect, frameName: String!, groupName: String!) {
    super.init(frame: frame, frameName: frameName, groupName: groupName)
    didLoad()
  }

  convenience init() {
    self.init(frame: CGRectZero)
  }

  func didLoad() {
    drawsBackground = false
    UIDelegate = self
    editingDelegate = self
  }

  public func webView(sender: WebView!, contextMenuItemsForElement element: [NSObject : AnyObject]!, defaultMenuItems: [AnyObject]!) -> [AnyObject]! {
    return nil
  }

  override public func webView(webView: WebView!, shouldChangeSelectedDOMRange currentRange: DOMRange!, toDOMRange proposedRange: DOMRange!, affinity selectionAffinity: NSSelectionAffinity, stillSelecting flag: Bool) -> Bool {
    return false
  }

}

public class DisplayLayerGraphic: NSView {

  override init(frame: CGRect) {
    self.image = NSImage()
    super.init(frame: frame)
  }

  required public init?(coder aDecoder: NSCoder) {
    self.image = NSImage()
    super.init(coder: aDecoder)
  }

  convenience init() {
    self.init(frame: CGRectZero)
  }

  convenience init(image: NSImage) {
    self.init(frame: CGRectZero)
    self.image = image
  }

  public var image: NSImage {
    didSet {
      self.layer?.contentsGravity = kCAGravityResizeAspectFill
      self.layer?.contents = image
    }
  }

}
