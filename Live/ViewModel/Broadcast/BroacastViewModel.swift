//
//  BroacastViewModel.swift
//  Live
//
//  Created by lieon on 2017/7/5.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//  swiftlint:disable variable_name

import Foundation
import PromiseKit
import RxSwift
import RxCocoa
import Device
import AVKit
import AVFoundation
import SnapKit
import RxSwift
import RxCocoa
import PromiseKit

class BroacastViewModel: NSObject {
    var videoParentView: UIView?
    var txLivePublisher: TXLivePush?
    lazy var messageHandler: MsgHandler = {
    let messageHandler = MsgHandler()
        return messageHandler
    }()
    var isPreviewing: Bool = false
    var rtmpUrl: String?
    var isCameraSwitch: Bool = false
    var beautyLevel: Float = 0.0
    var whiteningLevel: Float = 0.0
    var eyeLevel: Float = 0.0
    var faceLevel: Float = 0.0
    lazy var liveInfo: Live = Live()
    
    override init() {
        super.init()
        setupPush()
    }
    //// 上传封面
    func uploadCoverImage(with imageData: Data) -> Promise<String> {
        return Promise { fullfil, reject in
            UploadUtils.upLoadMultimedia(with: imageData, success: { (imageStr) in
                if let str = imageStr {
                    fullfil(str)
                } else {
                    var appError = AppError()
                    appError.message = "upload error"
                    reject(appError)
                }
            }, fail: { errStr in
                var appError = AppError()
                appError.message = errStr ?? ""
                reject(appError)
            }, progress: {_ in })
        }
      
    }
    
    /// 开始直播
    func startLive(with param: BroadcastParam) -> Promise<Bool> {
        let req: Promise<BroadcastResponse> = RequestManager.request(.endpoint(BroadcatPath.startLive, param: param), needToken: .true)
     return   req.then { (value) -> Bool in
            if let response = value.object, let info = response.liveinfo {
                self.liveInfo = info
                print(self.liveInfo)
                return true
            } else {
                return false
            }
        }
    }
    
    /// 结束直播
    func endLive() -> Promise<EndLiveModel> {
        let req: Promise<EndLiveGroupResponse> = RequestManager.request(.endpoint(BroadcatPath.endLive, param: nil))
        return req.then(execute: { (response) -> EndLiveModel in
            if let object = response.object?.live {
                print(object)
                return object
            }
            return EndLiveModel()
        })
    }
    
    /// 检测是否有未结束的直播
    func checkAvailableBroadcast() -> Promise<Live> {
        let req: Promise<BroadcastResponse> = RequestManager.request(.endpoint(BroadcatPath.comebackLive, param: nil))
        return   req.then { (value) -> Live in
            if let response = value.object, let info = response.liveinfo {
                return info
            } else {
                return Live()
            }
        }

    }
}

/// RTMP
extension BroacastViewModel {
    fileprivate func setupPush() {
        let txLivePushonfig = TXLivePushConfig()
        txLivePushonfig.frontCamera = true
        txLivePushonfig.enableAutoBitrate = false
        txLivePushonfig.videoResolution =  Int32(TX_Enum_Type_VideoResolution.VIDEO_RESOLUTION_TYPE_540_960.rawValue)
        txLivePushonfig.videoBitratePIN = 700
        txLivePushonfig.enableHWAcceleration = true
        txLivePushonfig.pauseFps = 10
        txLivePushonfig.pauseTime = 300
        txLivePushonfig.watermark = UIImage(named: "gou")
        txLivePushonfig.enableAudioPreview = true
        self.txLivePublisher = TXLivePush(config: txLivePushonfig)
    }
    
    func startRtmp() -> Bool {
        self.isCameraSwitch = false
        self.rtmpUrl = self.liveInfo.pushUrl
         if let rtmpUrl = self.rtmpUrl, let publisher = self.txLivePublisher, let config = publisher.config {
            config.enableHWAcceleration = true
            config.enableAudioAcceleration = true
            config.pauseFps = 10
            config.pauseTime = 300
            config.enableNearestIP = false
            publisher.config = config
            publisher.delegate = self
            publisher.setVideoQuality(.VIDEO_QUALITY_QOS_DEFINITION)
//            if self.isPreviewing == false {
//                publisher.startPreview(videoParentView)
//                self.isPreviewing = false
//            }
            if publisher.start(rtmpUrl) != 0 {
                print("push failed")
                return false
            }
            self.txLivePublisher? .setEyeScaleLevel(self.eyeLevel)
            self.txLivePublisher?.setFaceScaleLevel(self.faceLevel)
            self.txLivePublisher?.setMirror(false)
            UIApplication.shared.isIdleTimerDisabled = true
            return true
        }
           return false
    }
    
     func  openCamera() -> Bool {
            let videoStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if videoStatus == .denied {
                print("camera falied")
                return false
            }
            let statusAudio = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
            if statusAudio == .denied {
                print("audio failed")
                return false
            }
        
        if self.isPreviewing == false, let publisher = self.txLivePublisher {
            self.beautyLevel = 9
            self.whiteningLevel = 3
            self.txLivePublisher?.setBeautyFilterDepth(self.beautyLevel, setWhiteningFilterDepth: self.whiteningLevel)
            publisher.startPreview(videoParentView)
            self.isPreviewing = true
        }
        return true
    }
    
    func stopRtmp() {
        self.txLivePublisher?.delegate = nil
        self.txLivePublisher?.stopPreview()
        self.isPreviewing = false
        self.txLivePublisher?.stop()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func switchCamera() {
        txLivePublisher?.switchCamera()
    }
    
    func beautify(_ level: Float) {
        beautyLevel = level * 10
        txLivePublisher?.setBeautyFilterDepth(beautyLevel, setWhiteningFilterDepth: whiteningLevel)
    }
    
    func whitenfy(_ level: Float) {
        whiteningLevel = level * 10
        txLivePublisher?.setBeautyFilterDepth(beautyLevel, setWhiteningFilterDepth: whiteningLevel)
    }
}

extension BroacastViewModel: TXLivePushListener {
    
    func onPushEvent(_ EvtID: Int32, withParam param: [AnyHashable : Any]!) {
        
    }
    
    func onNetStatus(_ param: [AnyHashable : Any]!) {
        
    }
}
