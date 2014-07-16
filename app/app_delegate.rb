class AppDelegate
  def initialize
    super
    setEventHandler
    @urlStr = nil
  end

  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def applicationShouldTerminateAfterLastWindowClosed(application)
    true
  end

  def buildWindow
    @mainWindowController = MainWindow.alloc.initWithWindowNibName('MainWindow')
    @mainWindowController.window.makeKeyAndOrderFront(self)
    @mainWindowController.setURL(@urlStr)
  end

  def setEventHandler
    NSAppleEventManager.sharedAppleEventManager.setEventHandler(
      self,
      andSelector: :'handleGetURLEvent:withReplyEvent:',
      forEventClass: KInternetEventClass,
      andEventID: KAEGetURL)
  end

  def handleGetURLEvent(event, withReplyEvent: replyEvent)
    urlStr = event.paramDescriptorForKeyword(KeyDirectObject).stringValue
    @urlStr = urlStr

    app = NSRunningApplication.currentApplication
    app.activateWithOptions(NSApplicationActivateIgnoringOtherApps)
  end
end
