//
//  VoiceRegisterVM.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation
import RxSwift
import AVFoundation
import SwiftKeychainWrapper

enum AudioError: LocalizedError {
    case accessDenied
}

final class VoiceRegisterVM: ViewModel {
    enum State {
        case waiting
        case ready
        case recording
        case sampled
        case failed(Error)
    }

    private let disposeBag = DisposeBag()
    let state = BehaviorSubject<State>(value: .waiting)
    var recordingSession: AVAudioSession {
        return AVAudioSession.sharedInstance()
    }
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?

    let enrollmentsRemain = BehaviorSubject<Int>(value: 3)

    var filePath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("recording.wav")
    }

    var _filePath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("demo-recording.wav")
    }

    override func viewModelDidLoad() {
        super.viewModelDidLoad()

        enrollmentsRemain.asObservable().subscribe(onNext: { (value) in
            if value <= 0 {
                AppRouter.shared.navigate(to: AppRoute.store)
            }
        }).disposed(by: disposeBag)
    }

    func next(sample: Bool) {
        let path = sample ? filePath : _filePath
        AppRouter.shared.showProgressHUD()
        EncryptionService.shared.start(url: path).subscribe { event in
            AppRouter.shared.dismissProgressHUD()
            switch event {
            case .completed:
                self.state.onNext(.ready)
                self.enrollmentsRemain.onNext(self.enrollmentsRemain.value! - 1)
            case .error:
                break
            }
        }.disposed(by: disposeBag)
    }

    func skip() {
        KeychainWrapper.standard.set("f4bededd-be67-46f2-ac7e-5ea8bf72d04c", forKey: "id")
        AppRouter.shared.navigate(to: AppRoute.store)
    }

    func requestMicAccess() -> Completable {
        return Completable.create { [weak self] event in
            do {
                try self?.recordingSession.setCategory(.playAndRecord, mode: .default)
                try self?.recordingSession.setActive(true)
                self?.recordingSession.requestRecordPermission() { isAllowed in
                    self?.state.onNext(.ready)
                    isAllowed ? event(.completed) : event(.error(AudioError.accessDenied))
                }
            } catch {
                event(.error(error))
            }
            return Disposables.create()
        }
    }

    func playSample() {
        do {
            try recordingSession.overrideOutputAudioPort(.speaker)
            audioPlayer = try AVAudioPlayer(contentsOf: filePath)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            state.onNext(.failed(error))
        }
    }

    func toggleRecording() {
        switch state.value! {
        case .ready, .sampled, .failed:
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 16000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            do {
                audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
                audioRecorder?.delegate = self
                audioRecorder?.record()
                state.onNext(.recording)
            } catch {
                state.onNext(.failed(error))
                Log.error(error)
            }
        case .recording:
            audioRecorder?.stop()
            audioRecorder = nil
            state.onNext(.sampled)

        case .waiting:
            requestMicAccess().subscribe().disposed(by: disposeBag)
        }
    }
}

extension VoiceRegisterVM: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            toggleRecording()
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            state.onNext(.failed(error))
            Log.error(error)
        }
    }
}


extension VoiceRegisterVM: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer = nil
    }
}
