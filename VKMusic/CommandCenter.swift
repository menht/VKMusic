//
//  CommandCenter.swift
//  VKMusic
//
//  Created by Yaro
//

import Foundation
import MediaPlayer

class CommandCenter: NSObject {
    
    static let defaultCenter = CommandCenter()
    
    fileprivate let player = AudioPlayer.defaultPlayer
    
    fileprivate override init() {
        super.init()
        setCommandCenter()
        setAudioSeccion()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    fileprivate func setAudioSeccion() {
        let audioSeccion = AVAudioSession.sharedInstance()
        do {
            try audioSeccion.setCategory("AVAudioSessionCategoryPlayback", with: .mixWithOthers)
            try audioSeccion.setActive(true)
        } catch {
            print("ERROR")
        }
    }
    
    //MARK: - Remote Command Center
    fileprivate func setCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.pauseCommand.addTarget(self, action: #selector(CommandCenter.remoteCommandPause))
        commandCenter.playCommand.addTarget(self, action: #selector(CommandCenter.remoteCommandPlay))
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(CommandCenter.remoteCommandNext))
    }
    
    @objc fileprivate func remoteCommandPause() {
        player.pause()
    }
    
    @objc fileprivate func remoteCommandPlay() {
        player.play()
    }
    
    @objc fileprivate func remoteCommandNext() {
       player.next()
    }
    
    //MARK: - Public Methods
    
    func setNowPlayingInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: player.currentAudio.title,
                                                                MPMediaItemPropertyArtist: player.currentAudio.artist,
                                                                MPNowPlayingInfoPropertyPlaybackRate: 1.0]
    }
}