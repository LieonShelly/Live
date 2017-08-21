[![Travis CI](https://travis-ci.org/ReactiveX/RxSwift.svg?branch=master)](https://travis-ci.org/ReactiveX/RxSwift) ![platform](https://img.shields.io/badge/platform-iOS9.0-brightgreen.svg)

![GitHub set up-w50-h80](https://github.com/lieonCX/Live/blob/master/Live/Assets.xcassets/LaunchImage.launchimage/%EF%BC%94%EF%BD%93.png)

# Live
A swift project liv app, we integrated Tencent Live Video Broadcasting SDK in the app.

## The Living Stream SDK 
* Tencent Mobile Living Cloud
* Tencent Mobile Communication Cloud

## Main Logic ：
The project can be divided into three parts, they are home list, broadcast and user center etc.

* The data of home list was come from our back server, when user tap the specific data record the app will enter RoomViewController. 
* The RoomViewController has play the role of pulling living stream for Tencent Server. and setup the IM chat related operations.
* The anchor broadcast part included build IM Chat room and group, pushing video stream into Tencent Server.
* The most simple part is User center, which contains some related user's message and the setting of app. 

## What's the trouble in this project?
It's become a very easy way to pull and push video stream because of third part living stream SDK. Our video stream has been saved in Tencent Cloud, so we just make a management to store the user data and distribute the stream address to client from Tencent Server.
In other words, the trouble comes from  RoomViewController's logic, BroadcastViewController's logic, and the whole app performance.

### RoomViewController's logic
* A easy way to pull video stream
  we just need setup the position of player in the RoomViewController. then we send the play stream address to player. OK, here we go.
	By the way there are three type of stream address, such as .rtmp, .flv, .mp4. I strongly suggest to use .flv type.
	
* About IM
	What IM work is IM login joinning chat group, sending text message, danmaku message, continue tapping gift message, BigGift message, and leave chat room etc. 

1. The format of message 

```
class IMMessage: Model {
	 /// message type
    var userAction: AVIMCommand = .none
    /// user ID
    var userId: Int = 0
    var nickName: String?
    var msg: String?
    var headPic: String?
    var level: Int = 0
    
    /// object <-> json
    override func mapping(map: Map) {
        userAction <- map["userAction"]
        userId <- map["userId"]
        nickName <- map["nickName"]
        msg <- map["msg"]
        headPic <- map["headPic"]
        level <- map["level"]
    }
}
```

2. Text Message
		The text message contains common text message which will show in message tableView, and danmaku message which will show in danmaku view. The common text message has been handled into rich attribute string with using[YYText](https://github.com/ibireme/YYText). The merit is reducing the UI controls of message table view）
    
3. Danmaku
	It's comes from github's [FXDanmaku](https://github.com/ShawnFoo/FXDanmaku)
	
4. About big gift message
  I most deeply think the gift animation is most  big trouble, which contains the cpu comsume and memory cosume. Obviously, I still use the third party vendor which name [FXAnimationEngine](https://github.com/ShawnFoo/FXAnimationEngine)
	```
	  fileprivate func playAnimation(with gift: IMMessage) {
         displayingGift = gift
        guard let msgStr = gift.msg, let gift = Mapper<Gitft>().map(JSONString: msgStr), let name = gift.shortName else {  return  }
        
        displayinID = name
        /// create a FXKeyframeAnimation
        let animation = FXKeyframeAnimation(identifier: name)
       /// create a OperationQueue op1 read the image resources from file system ， op2 play synchronously animation
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let op1 = BlockOperation {[weak self] in
            animation.delegate = self
            animation.repeats = 1
        }
        op1.addExecutionBlock {
            /// read the image resources from file system 
            let images = self.loadAnimateImage(with: name)
            animation.duration = TimeInterval(images.count / 25)
            animation.frames = images
        }
        let op2 = BlockOperation {[weak self] in
            /// synchronously play animation， must be
           self?.layer.fx_play(animation, asyncDecodeImage: false)
        }
        queue.addOperation(op1)
        queue.addOperation(op2)
    }
```

## Anchor version（definitely open hardware acceleration）
There are no further ado beacause the logic of Anchor version(BroadcastViewController) is most likely RoomViewController, It can be simply summarized pushing video stream, login IM, create Room, create chat group, send text message, receive IMMessage, play gift animation etc.

## About Recharge
I use apple In-Purchase in the live app because of the Virtual Goods' limmit. About the tutorial of In-Purchase, you should  google or refer to [this](http://www.jianshu.com/p/4131640791ae)

## The following SDK has been deleted because of the limit with packege size
* TXRTMPSDK.framework
* IMFriendshipExt.framework
* IMGroupExt.framework
* IMMessageExt.framework
* ImSDK.framework
* IMSDKBugly.framework
* IMUGCExt.framework
* QALSDK.framework
* TLSSDK.framework

## license
Live is released under an MIT license. See [License.md](https://github.com/lieonCX/Live/blob/master/LICENSE) for more information.


