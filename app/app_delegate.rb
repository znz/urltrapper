class AppDelegate
  def initialize
    super
    setEventHandler
    @urlStr = nil
    @mainWindowController = nil
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

  def setURL(urlStr)
    if @mainWindowController
      # when running
      @mainWindowController.setURL(urlStr)
    else
      # launch with URL
      @urlStr = urlStr
    end
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
    setURL(urlStr)

    app = NSRunningApplication.currentApplication
    app.activateWithOptions(NSApplicationActivateIgnoringOtherApps)
  end
end
