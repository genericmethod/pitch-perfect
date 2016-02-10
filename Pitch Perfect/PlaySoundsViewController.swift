//
//  PlayAudioViewController.swift
//  Pitch Perfect
//
//  Created by Chris Farrugia on 07/02/2016.
//  Copyright © 2016 Chris Farrugia. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var player:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        setupAudio(receivedAudio.filePathUrl, type: "wav")
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func stopAudio(){
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariableRate(rate: Float){
        player.rate = rate;
        player.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    
    }
    
    func setupAudio(file:NSURL, type:String){
      
        player = try! AVAudioPlayer(contentsOfURL: file)
        player.enableRate = true;
        
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        stopAudio()
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        stopAudio()
        playAudioWithVariableRate(2.0)
    }
    
    @IBAction func stopAudioPlayer(sender: UIButton) {
        stopAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

}
