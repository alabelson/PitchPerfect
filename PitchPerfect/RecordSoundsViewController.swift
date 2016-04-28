//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Adam Labelson on 4/27/16.
//  Copyright © 2016 Adam Labelson. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stopRecordingButton.enabled=false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func recordAudio(sender: AnyObject) {
        print("Record Audio Pressed")
        recordingLabel.text="Recording in progress"
        stopRecordingButton.enabled=true
        recordButton.enabled=false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.
            UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
  
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("Stop Recording Pressed")
        recordingLabel.text="Tap to Record"
        stopRecordingButton.enabled=false
        recordButton.enabled=true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if(flag) {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }
        else {
            print("Saving of recording failed")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundVC.recordedAudioURL=recordedAudioURL
        }
    }

}

