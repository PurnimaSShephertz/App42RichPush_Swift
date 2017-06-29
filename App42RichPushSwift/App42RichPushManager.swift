//
//  App42RichPushManager.swift
//  App42RichPushSample_Swift
//
//  Created by Purnima on 10/04/17.
//  Copyright © 2017 Shephertz. All rights reserved.
//

import UIKit
import MediaPlayer


class App42RichPushManager: NSObject {

    var richPushType : String? = ""
    var htmlString : String? = ""
    var imageUrl : String? = ""
    var videoUrl : String? = ""
    var webUrl : String? = ""
    var youTubeVideoCode : String? = ""
    var richPushInfo : Dictionary = [ String : String ]()
    
    var moviePlayer : MPMoviePlayerViewController!
    
    override init() {
        super.init()
    }
    
    func handleRichPush(pushInfo : Dictionary<String, String>) {
        richPushInfo = pushInfo
        showRichPush(pushInfo: richPushInfo)
    }
    
    func showRichPush(pushInfo : Dictionary<String, String>) {
        richPushType = pushInfo[APP42_RICHPUSH_TYPE]
        
        if app42RichPushTypeImage == richPushType {
            imageUrl = pushInfo[APP42_RICHPUSH_CONTENT]
            displayImage()
        }
        else if app42RichPushTypeOpenUrl == richPushType{
            webUrl = pushInfo[APP42_RICHPUSH_CONTENT]
            openWebUrl()
        }
        else if app42RichPushTypeHTML == richPushType{
            htmlString = pushInfo[APP42_RICHPUSH_CONTENT]
            loadHTMLString()
        }
        else if app42RichPushTypeVideo == richPushType{
            videoUrl = pushInfo[APP42_RICHPUSH_CONTENT]
            
        }
        else if app42RichPushTypeYouTubeVideo == richPushType{
            youTubeVideoCode = pushInfo[APP42_RICHPUSH_CONTENT]
        }
    }
    
    //Mark: -- Display Image --
    func displayImage() {
        
        let pushManagerView : App42PushViewController = App42PushViewController(nibName: "App42PushViewController", bundle: nil)
        pushManagerView.richPushManager = self
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(pushManagerView, animated: true, completion: { 
            pushManagerView.showImage()
        })
        
    }
    
    //Mark: -- Open Web Url--
    func openWebUrl() {
        let webLink = URL(string: webUrl!)
        UIApplication.shared.openURL(webLink!)
    }
    
    //Mark: -- Load HTML String
    func loadHTMLString() {
        let pushManagerView : App42PushViewController = App42PushViewController(nibName: "App42PushViewController", bundle: nil)
        pushManagerView.richPushManager = self
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(pushManagerView, animated: true, completion: {
            pushManagerView.loadHtmlString()
        })
    }
    
    //Mark: -- Play Video
    func playVideo() {
        let videoStrUrl = URL(string: videoUrl!)
//        let moviePlayer : MPMoviePlayerController = MPMoviePlayerController()
        
        moviePlayer = MPMoviePlayerViewController(contentURL: videoStrUrl)
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.presentMoviePlayerViewControllerAnimated(moviePlayer)
        
        
    }
    
    //Mark: Play Youtube Video
    func playYouTubeVideo() {
        let pushManagerView : App42PushViewController = App42PushViewController(nibName: "App42PushViewController", bundle: nil)
        pushManagerView.richPushManager = self
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(pushManagerView, animated: true, completion: {
            pushManagerView.playYoutubeVideo()
        })
    }
}
