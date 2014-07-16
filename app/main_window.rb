class MainWindow < NSWindowController
  extend IB

  ib_outlet :text, NSTextView

  def setURL(url)
    @text.stringValue = url if @text
  end

  def openBrowser(app_bundle_id)
    unless @text
      alert("@text not found")
      return
    end
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

  def openFirefox(sender)
    openBrowser('org.mozilla.Firefox')
  end

  def openGoogleChrome(sender)
    openBrowser('com.google.Chrome')
  end

  def openSafari(sender)
    openBrowser('com.apple.Safari')
  end

  def setDefaultBrowser(sender)
    bundle_id = NSBundle.mainBundle.bundleIdentifier
    LSSetDefaultHandlerForURLScheme('http', bundle_id)
    LSSetDefaultHandlerForURLScheme('https', bundle_id)
    LSSetDefaultHandlerForURLScheme('ftp', bundle_id)
    #LSSetDefaultRoleHandlerForContentType('public.html', KLSRolesAll, bundle_id)
    #LSSetDefaultRoleHandlerForContentType(KUTTypeHTML, KLSRolesViewer, bundle_id)
    #LSSetDefaultRoleHandlerForContentType(KUTTypeURL, KLSRolesViewer, bundle_id)
  end
end
