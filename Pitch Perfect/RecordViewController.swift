//
//  RecordViewController.swift
//  Pitch Perfect
//
//  Created by João Leite on 03/10/18.
//  Copyright © 2018 João Leite. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var lblRecord: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called")
    }

    @IBAction func btnRecordPressed(_ sender: Any) {
        
        configureUI(recordingAudio: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSession.Category.playAndRecord,
                                 mode: AVAudioSession.Mode.videoRecording,
                                 options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func configureUI(recordingAudio: Bool){
        if(recordingAudio){
            lblRecord.text = "Recording..."
            recordButton.isEnabled = false
            stopButton.isEnabled = true
        }else{
            lblRecord.text = "Tap to Record"
            recordButton.isEnabled = true
            stopButton.isEnabled = false
        }
    }
    
    @IBAction func btnRecordStopPressed(_ sender: Any) {
        audioRecorder.stop()
        configureUI(recordingAudio: false)
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        flag ? performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) : print("recording was not successful")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playbackVC = segue.destination as! PlaybackViewController
            let recordedAudioURL = sender as! URL
            playbackVC.recordedAudioURL = recordedAudioURL
        }
    }
}

