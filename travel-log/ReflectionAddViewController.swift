//
//  ReflectionAddViewController.swift
//  travel-log
//
//  Created by Eunseo Lee and Karen Ren on 2022/4/21.
//

import UIKit
import AVFoundation

class ReflectionAddViewController: UIViewController {
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var soundTextField: UITextField!
    var audioRecorder : AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Create Audio Session
        let session = AVAudioSession.sharedInstance()
        
        try? session.setCategory(.playAndRecord, mode: .default)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setActive(true)
        
        //URL to save the audio
        if let basePath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let pathComponents = [basePath, "audio.m4a"]
            if let audioURL = NSURL.fileURL(withPathComponents: pathComponents) {
                self.audioURL = audioURL
                //Create some settings
                var settings :[String:Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44100.0
                settings[AVNumberOfChannelsKey] = 2
                //Create the audio recorder
                 audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder?.prepareToRecord()
            }
        }
        play.isEnabled = false;
        add.isEnabled = false
        soundTextField.isEnabled = false
    }//viewDidLoad()
    
    
    @IBAction func recordButton(_ sender: Any) {
        if let audioRecorder = self.audioRecorder {
            if audioRecorder.isRecording {
                audioRecorder.stop()
                record.setTitle("Record", for: .normal)
                
                play.isEnabled = true
                add.isEnabled = true
                soundTextField.isEnabled = true
            }//if
            else {
                audioRecorder.record()
                 record.setTitle("Stop", for: .normal)
                play.isEnabled = false;
                add.isEnabled = false
                soundTextField.isEnabled = false
            }//else
        }
        
    }//recordButton
    
    @IBAction func playButton(_ sender: Any) {
        
        if let audioURL = self.audioURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        }
        
    }//playButton
    
    @IBAction func addButton(_ sender: Any) {
        
        if let context =  (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let sound = LogObject(entity: LogObject.entity(), insertInto: context)
            sound.soundName = soundTextField.text
             if let audioURL = self.audioURL {
               sound.audioData = try? Data(contentsOf: audioURL)
               try? context.save()
                navigationController?.popViewController(animated: true)
            }
        }
        
    }//addButton
    
}//ReflectionAddViewController
