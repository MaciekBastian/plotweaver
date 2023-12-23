import Cocoa
import FlutterMacOS
import IOKit.ps

class MainFlutterWindow: NSWindow {
    private let fileService = FileService()
    
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
      
    let fileChannel = FlutterMethodChannel(
        name: "com.maciejbastian.plotweaver/file",
        binaryMessenger: flutterViewController.engine.binaryMessenger)
      
      fileChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "pick_file" {
             self?.fileService.pickFile(result: result)
          } else if call.method == "pick_directory" {
              self?.fileService.pickDirectory(result: result)
          } else if call.method == "create_new_project_file" {
              self?.fileService.createNewProjectFile(result: result)
          } else {
              result(FlutterMethodNotImplemented)
          }
      })

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
