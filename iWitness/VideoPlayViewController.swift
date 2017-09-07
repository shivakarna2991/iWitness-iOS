//
//  VideoPlayViewController.swift
//  iWitness
//
//  Created by Sravani on 06/01/16.
//  Copyright © 2016 PTG. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation


class VideoPlayViewController: BaseViewController {

    var videoUrlString:String!
    var moviePlayer:MPMoviePlayerController!
    var timer:Timer!
    var counter = 0
    @IBOutlet var processlbl :UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        _visualize()
       processlbl.textColor = UIColor.white
        self.showloader()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(VideoPlayViewController._showloader), userInfo: nil, repeats: true)
       
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MPMoviePlayerPlaybackStateDidChange(_:)), name:MPMoviePlayerPlaybackStateDidChangeNotification , object: nil)
//        
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//            selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
//        name:MPMoviePlayerPlaybackStateDidChangeNotification
//        object:nil];

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.black

    }
    
    func playVideo()
    {
    moviePlayer =  MPMoviePlayerController(contentURL:URL(string:videoUrlString))
    moviePlayer.view.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64)
    self.view.addSubview(moviePlayer.view)
    moviePlayer.isFullscreen = false
    moviePlayer.scalingMode = MPMovieScalingMode.aspectFill
    moviePlayer.controlStyle = MPMovieControlStyle.default

    }
    
    func _showloader()
    {
        if(counter == 5){
            self.removeloader()
            timer.invalidate()
            processlbl.isHidden = true
            playVideo()

        }
        
        counter += 1
    }
    
    
//MARK: Class's private methods======================
    
    func _visualize()
    {
        self.title = "Stream"
//        let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"back.png"), style:UIBarButtonItemStyle.Plain, target: self, action: "backBtnTapped")
//        self.navigationItem.leftBarButtonItem = leftBtn

        
    }
    
    func backBtnTapped()
    {
      _ =  self.navigationController?.popViewController(animated: true)
  
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
