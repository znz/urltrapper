class MainWindow < NSWindowController
  extend IB

  ib_outlet :window, NSWindow
  ib_outlet :text, NSTextField
end
