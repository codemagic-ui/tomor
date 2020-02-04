import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "htmlView",binaryMessenger: controller)
    
    channel.setMethodCallHandler({(call: FlutterMethodCall, result: FlutterResult) -> Void in
        if(call.method == "HtmlToString"){
            var values = call.arguments as! Dictionary<String,AnyObject>;
            var data = values["t"] as! String;
            let d = Data(data.utf8)
            print(d)
            if let attributedString = try? NSAttributedString(data: d, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                let a = attributedString;
                if let attributedString = try? NSAttributedString(data: Data(a.string.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    let a = attributedString.string;
                    print(a);
                    return result(a);
                }else{
                    return result(d);
                }
            }else{
                return result(data);
            }
        }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
