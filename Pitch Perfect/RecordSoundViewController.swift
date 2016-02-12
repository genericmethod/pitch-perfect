//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Chris Farrugia on 07/02/2016.
//  Copyright © 2016 Chris Farrugia. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var microphoneButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var recording:Bool!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingStatusLabel.hidden = false
        microphoneButton.enabled = true
        recordingStatusLabel.text = "Tap to Record"
        recording = false
    
        initAudioRecorder()
    }
    
    func initAudioRecorder(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "pitch_perfect.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()

    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(filePathUrl:recorder.url, title:recorder.url.lastPathComponent!)
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayback)
            
            performSegueWithIdentifier("stopRecord", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecord"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data;
            
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
       
        if (!recording){
            recordingStatusLabel.hidden = false
            recordingStatusLabel.text = "Recording. Tap to pause"
            stopButton.hidden = false
            audioRecorder.record()
            recording = true
        } else {
            audioRecorder.pause()
            recordingStatusLabel.text = "Tap again to resume recording"
            recording = false
        }
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        recordingStatusLabel.hidden = true
        stopButton.hidden = true
        microphoneButton.enabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }



}

