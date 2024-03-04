import UIKit
import Flutter
// SkyWay SDKをインポートする
import SkyWayRoom

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let skywayChannel = FlutterMethodChannel(name: "com.example.skyway_flutter/skywayChannel",
                                             binaryMessenger: controller.binaryMessenger)

    skywayChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // Skywayのセッションを開始する処理
      if call.method == "startSkywaySession" {
        self?.startSkywaySession(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func startSkywaySession(result: @escaping FlutterResult) {
    Task {
        do {
            let token: String = "JWTを入力します"
            let contextOpt: ContextOptions = .init()
            contextOpt.logLevel = .trace
            try await Context.setup(withToken: token, options: contextOpt)

            let roomInit: Room.InitOptions = .init()
            let room: SFURoom = try await .create(with: roomInit)

            let memberInit: Room.MemberInitOptions = .init()
            memberInit.name = "Alice"
            let member = try await room.join(with: memberInit)

            // 以下、ビデオとオーディオのパブリッシュ処理
            // この部分は省略されていますが、ビデオとオーディオのストリームを作成し、SFURoomにパブリッシュする処理が必要です
            // ...

            // AudioStreamの作成
            let audioSource: MicrophoneAudioSource = .init()
            let audioStream = audioSource.createStream()
            guard let audioPublication = try? await member.publish(audioStream, options: nil) else {
                 print("[Tutorial] Publishing failed.")
                 return
            }
            // Audioの場合、subscribeした時から音声が流れます
            guard let _ = try? await member.subscribe(publicationId: audioPublication.id, options: nil) else {
                 print("[Tutorial] Subscribing failed.")
                 return
            }
            print("🎉Subscribing audio stream successfully.")

            print("🎉 Skyway session started successfully.")
            result("Skyway session started successfully.")
        } catch {
            print("Failed to start Skyway session: \(error)")
            result(FlutterError(code: "SKYWAY_SESSION_FAILED", message: "Failed to start Skyway session.", details: nil))
        }
    }
  }
}
