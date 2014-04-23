class AppDelegate
  def initialize
    super
    setEventHandler
  end

  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def applicationShouldTerminateAfterLastWindowClosed(application)
    true
  end

  def buildWindow
    width  = 480
    height = 360
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [width, height]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless

    margin = 10
    text_height = height/2
    @text = NSTextField.alloc.initWithFrame([[margin, height-text_height], [width-margin*2, text_height-margin]])
    @text.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable|NSViewHeightSizable
    @text.stringValue = @url || "http://www.apple.com/" # default URL
    @mainWindow.contentView.addSubview(@text)

    buildButtons(width, height, margin)
  end

  MY_DEBUG = false

  BUTTONS = [
    [
      'Set Default Browser',
      :setDefaultBrowser,
    ],
    [
      'Open Firefox',
      :openFirefox,
    ],
    [
      'Open Google Chrome',
      :openChrome,
    ],
    [
      'Open Safari',
      :openSafari,
    ],
  ]

  def buildButtons(width, height, margin)
    BUTTONS.reverse_each.with_index do |(title, action), idx|
      button = NSButton.alloc.initWithFrame([[margin, margin+30*idx], [width-margin*2, 32]])
      button.title = title
      button.action = action
      button.target = self
      button.bezelStyle = NSRoundedBezelStyle
      button.autoresizingMask = NSViewMinXMargin|NSViewMaxYMargin|NSViewWidthSizable
      @mainWindow.contentView.addSubview(button)
    end
  end

  def setEventHandler
    NSAppleEventManager.sharedAppleEventManager.setEventHandler(
      self,
      andSelector: :'handleGetURLEvent:withReplyEvent:',
      forEventClass: KInternetEventClass,
      andEventID: KAEGetURL)
  end

  def setDefaultBrowser
    bundle_id = NSBundle.mainBundle.bundleIdentifier
    LSSetDefaultHandlerForURLScheme('http', bundle_id)
    LSSetDefaultHandlerForURLScheme('https', bundle_id)
    LSSetDefaultHandlerForURLScheme('ftp', bundle_id)
    #LSSetDefaultRoleHandlerForContentType('public.html', KLSRolesAll, bundle_id)
  end

  def handleGetURLEvent(event, withReplyEvent: replyEvent)
    alert([:handleGetURLEvent, event].inspect) if MY_DEBUG
    urlStr = event.paramDescriptorForKeyword(KeyDirectObject).stringValue
    setURL(urlStr)

    app = NSRunningApplication.currentApplication
    app.activateWithOptions(NSApplicationActivateIgnoringOtherApps)
  end

  def setURL(urlStr)
    @url = urlStr
    alert([:setURL, @url].inspect) if MY_DEBUG
    @text.stringValue = @url if @text
  end

  def openBrowser(app_bundle_id)
    url = NSURL.URLWithString @text.stringValue
    ret = NSWorkspace.sharedWorkspace.openURLs([url], withAppBundleIdentifier: app_bundle_id, options: NSWorkspaceLaunchDefault, additionalEventParamDescriptor: nil, launchIdentifiers: nil)
    unless ret
      alert "Failed to open #{app}"
    end
  end

  def alert(message)
    alert = NSAlert.new
    alert.messageText = message
    alert.runModal
  end

  def openFirefox
    openBrowser('org.mozilla.Firefox')
  end

  def openChrome
    openBrowser('com.google.Chrome')
  end

  def openSafari
    openBrowser('com.apple.Safari')
  end
end
