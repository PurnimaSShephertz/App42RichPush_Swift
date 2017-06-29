//
//  App42PushViewController.swift
//  App42RichPushSample_Swift
//
//  Created by Purnima on 10/04/17.
//  Copyright © 2017 Shephertz. All rights reserved.
//

import UIKit

class App42PushViewController: UIViewController, UIWebViewDelegate {

    let apiKey = "b400539bfa288129821def96a087c1c913e9eeae3481afda786c5abb3895bf90"
    let secretKey = "31f2afbf5110e7bde7f0436765805877573c16851562dfedb95b47417b8479b9"
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIButton!

    var richPushManager = App42RichPushManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivityIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeBtnClick(_ sender: Any) {
        self.dismiss(animated: true) { 
            print("push dismissed")
        }
    }
    
    //Mark: -- Show Activity Indicator --
    func showActivityIndicator() {
        self.view.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //Mark: -- Hide ACtivity Indicator --
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    //Mark: -- Show Image Coming From Rich Push --
    func showImage() {
        webView.isHidden = true
        
        print("image url: \(richPushManager.imageUrl)")
        
        let imageUrl = URL(string: richPushManager.imageUrl!)
        let imageData = NSData(contentsOf: imageUrl!)
        let img = UIImage(data: imageData as! Data, scale: 1.0)
        imageView.image = img
        self.perform(#selector(App42PushViewController.hideActivityIndicator), with: nil, afterDelay: 0.2)
        
        self.view.bringSubview(toFront: activityIndicator)
    }
    
    //Mark: -- Show Web View Link --
    func loadHtmlString() {
        imageView.isHidden = true
        
        print("webView url: \(richPushManager.htmlString)")
        
        webView.delegate = self
        webView.isOpaque = true
        
        let webUrl = URL(string: richPushManager.htmlString!)
        let urlRequest = URLRequest(url: webUrl!)
        webView.loadRequest(urlRequest)
    }
    
    //Mark: -- Play youtube Videos from link --
    func playYoutubeVideo() {
        imageView.isHidden = true
        print("youtube html; str: \(richPushManager.youTubeVideoCode)")
        webView.delegate = self
        webView.isOpaque = true
        
        let youtubeStr = richPushManager.youTubeVideoCode
        webView.mediaPlaybackRequiresUserAction = false
        webView.loadHTMLString(youtubeStr!, baseURL: nil)
    }
    
    //Mark: -- Web View Delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideActivityIndicator()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
    }
}


