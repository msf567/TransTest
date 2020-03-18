
import Foundation
import Cocoa

@objc public class MacHook: NSObject {
    @objc static let shared = MacHook()
    
    @objc func SayHiToUnity() -> String{
        return "Hi, I'm MARK, whats up bitch????"
    }
    
    // from: http://tatsudoya.blog.fc2.com/blog-entry-244.html
    // see: https://qiita.com/mybdesign/items/fe3e390741799c1814ad
  private static let styleMask: NSWindow.StyleMask = [.closable, .titled, .resizable]
    
    //private let styleMask: NSWindow.StyleMask = [.fullSizeContentView,.borderless]
    private let windowStyleMask: NSWindow.StyleMask = [.fullSizeContentView,.borderless]
    
    @objc static func initializeTransparent() -> String {
        let unityWindow: NSWindow = NSApp.orderedWindows[0]
        var retString: String = ""
        
        retString += unityWindow.title + " mark says hi "
        
        // step 1: set the Unity window transparent
        transparentizeWindow(window: unityWindow)
        
        // step 2: set the Unity view transparent
        transparentizeContentView(window: unityWindow)
        
        // step 3: make the window permanently front
        frontizeWindow(window: unityWindow)
        
        // step 4: observe notification
        // see: https://qiita.com/mono0926/items/754c5d2dbe431542c75e
        let center = NotificationCenter.default
        center.addObserver(forName: NSWindow.didBecomeMainNotification, object: nil, queue: nil, using: becomeMainListener(notification:))
        center.addObserver(forName: NSWindow.didBecomeMainNotification, object: nil, queue: nil, using: resignMainListener(notification:))
        
        return retString
    }
    
    private static func transparentizeWindow(window: NSWindow) -> Void {
        // set its style mask
        window.styleMask = styleMask
        // make it transparent
        window.backgroundColor = NSColor.clear
        window.isOpaque = false
        // remove its shadow
        window.hasShadow = false
    }
    
    /// Set the view transparent.
    ///
    /// - Parameter window: its content view is transparentized.
    private static func transparentizeContentView(window: NSWindow) -> Void {
        // if content view is nil, then do nothing
        if let view: NSView = window.contentView {
            // make it layer-backed
            // see: https://blog.fenrir-inc.com/jp/2011/07/nsview_uiview.html
            view.wantsLayer = true
            // make its layer transparent
            view.layer?.backgroundColor = CGColor.clear
            view.layer?.isOpaque = false
            
        }
        
        let alert: NSAlert = NSAlert()
        alert.messageText = "question"
        alert.informativeText = "text"
        alert.alertStyle = NSAlert.Style.informational
        alert.addButton(withTitle: "OKOKOK")
        alert.addButton(withTitle: "fuck outta here")
        let res = alert.runModal()
    }
    
    
    private static func frontizeWindow(window: NSWindow) -> Void {
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.level = NSWindow.Level.floating
    }
    
    /// A listener for become main notification.
    ///
    /// - Parameter notification: Notification
    @objc private static func becomeMainListener(notification: Notification) -> Void {
        if let window = getWindowFromNotification(notification: notification) {
            toggleBorderAppearance(window: window, isShow: true)
        }
    }
    
    /// A listener for resign main notification.
    ///
    /// - Parameter notification: Notification
    @objc private static func resignMainListener(notification: Notification) -> Void {
        if let window = getWindowFromNotification(notification: notification) {
            toggleBorderAppearance(window: window, isShow: false)
        }
    }
    
    /// Safely get a window object from a notification object.
    ///
    /// - Parameter notification: Notification
    private static func getWindowFromNotification(notification: Notification) -> NSWindow? {
        if let window = (notification.object as? NSWindow) {
            return window
        } else {
            return nil
        }
    }
    
    /// Hide or show the border of the given window.
    ///
    /// - Parameters:
    ///   - window: a window to show/hide
    ///   - isShow: boolean value to indicate show or hide
    private static func toggleBorderAppearance(window: NSWindow, isShow: Bool) {
        window.styleMask = isShow ? styleMask : [.borderless]
        window.titlebarAppearsTransparent = !isShow
        window.titleVisibility = isShow ? .visible : .hidden
    }
 
    private func transparentizeWindowWithChild(window: NSWindow) -> String {
        var retString: String = " trans func start "
        //window.hasShadow = false
        
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
   //     window.styleMask = styleMask
        window.backgroundColor = NSColor.clear
        window.isOpaque = false
        
        retString += window.isOpaque ? "opaque true" : "opqaue false"
        
        let view = window.contentView
        view?.wantsLayer = true
        view?.layer?.backgroundColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        view?.layer?.isOpaque = false
        
        retString += view == nil ? "no layer...?" : "layer found!"
        
        let rect = window.contentLayoutRect
        retString += rect.height.description
        
        let newWindow = NSWindow.init(contentRect: rect, styleMask: windowStyleMask, backing: NSWindow.BackingStoreType.buffered, defer: false)
        newWindow.center()
        newWindow.isReleasedWhenClosed = true
        newWindow.backgroundColor = NSColor.red
        newWindow.isOpaque = false
        newWindow.orderFrontRegardless()
        newWindow.contentView = view
        window.addChildWindow(newWindow, ordered: NSWindow.OrderingMode.above)
        
        return retString
    }
}

