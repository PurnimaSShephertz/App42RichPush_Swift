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
    var richPushInfo : Dictionary = [ AnyHashable : Any ]()
    
    var moviePlayer : MPMoviePlayerViewController!
    
    override init() {
        super.init()
    }
    
    func handleRichPush(pushInfo : Dictionary<AnyHashable, Any>) {
        richPushInfo = pushInfo
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.showRichPush(pushInfo: self.richPushInfo)
        })
    }
    
    func showRichPush(pushInfo : Dictionary<AnyHashable, Any>) {
        richPushType = pushInfo[APP42_RICHPUSH_TYPE] as! String?
        
        if app42RichPushTypeImage == richPushType {
            imageUrl = pushInfo[APP42_RICHPUSH_CONTENT] as! String?
            displayImage()
        }
        else if app42RichPushTypeOpenUrl == richPushType{
            webUrl = pushInfo[APP42_RICHPUSH_CONTENT] as! String?
            openWebUrl()
        }
        else if app42RichPushTypeHTML == richPushType{
            htmlString = pushInfo[APP42_RICHPUSH_CONTENT] as! String?
            loadHTMLString()
        }
        else if app42RichPushTypeVideo == richPushType{
            videoUrl = pushInfo[APP42_RICHPUSH_CONTENT] as! String?
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.playVideo()
            })
            
        }
        else if app42RichPushTypeYouTubeVideo == richPushType{
            youTubeVideoCode = pushInfo[APP42_RICHPUSH_CONTENT] as! String?
            playYouTubeVideo()
        }
    }
    
    //Mark: -- Display Image --
    func displayImage() {
        print("image : \(imageUrl!)")
        let pushManagerView : App42PushViewController = App42PushViewController(nibName: "App42PushViewController", bundle: nil)
        pushManagerView.richPushManager = self
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(pushManagerView, animated: true, completion: { 
            pushManagerView.showImage()
        })
        
    }
    
    //Mark: -- Open Web Url--
    func openWebUrl() {
        print("link : \(webUrl)")
        let webLink = URL(string: webUrl!)
        UIApplication.shared.openURL(webLink!)
    }
    
    //Mark: -- Load HTML String
    func loadHTMLString() {
        print("html string : \(htmlString)")
        let pushManagerView : App42PushViewController = App42PushViewController(nibName: "App42PushViewController", bundle: nil)
        pushManagerView.richPushManager = self
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(pushManagerView, animated: true, completion: {
            pushManagerView.loadHtmlString()
        })
    }
    
    //Mark: -- Play Video
    func playVideo() {
        print("video url : \(videoUrl)")
        let videoStrUrl = URL(string: videoUrl!)
//        let moviePlayer : MPMoviePlayerController = MPMoviePlayerController()
        
        moviePlayer = MPMoviePlayerViewController(contentURL: videoStrUrl)
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.presentMoviePlayerViewControllerAnimated(moviePlayer)
        
        
    }
    
    //Mark: Play Youtube Video
    func playYouTubeVideo() {
        print("youtube : \(youTubeVideoCode)")
        let pushManagerView : App42PushViewController = App42PushViewController(nibName: "App42PushViewController", bundle: nil)
        pushManagerView.richPushManager = self
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(pushManagerView, animated: true, completion: {
            pushManagerView.playYoutubeVideo()
        })
    }
}
