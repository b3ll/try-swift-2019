//
//  ViewController.swift
//  SimpleSquareSynth
//
//  Created by Adam Bell on 3/3/19.
//  Copyright © 2019 Adam Bell. All rights reserved.
//

import AudioKit
import UIKit

class ViewController: UIViewController, AKMIDIListener {

  var squareOscillator: AKPWMOscillatorBank!

  override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)

    setupSynth()
  }

  fileprivate func setupSynth() {
    self.squareOscillator = AKPWMOscillatorBank()
    squareOscillator.pulseWidth = 0.65

    squareOscillator.attackDuration = 5.0
    squareOscillator.decayDuration = 2.5
    squareOscillator.sustainLevel = 1.0
    squareOscillator.releaseDuration = 1.5

    let filter = AKMoogLadder(squareOscillator)
    filter.cutoffFrequency = 16000.0

    let chorus = AKChorus(filter)
    chorus.dryWetMix = 0.5

    let reverb = AKReverb(chorus)

    AudioKit.output = reverb
    try? AudioKit.start()

    AudioKit.midi.openInput()
    AudioKit.midi.addListener(self)
  }

  func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
    squareOscillator.play(noteNumber: noteNumber, velocity: 127, frequency: noteNumber.midiNoteToFrequency())
  }

  func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
    squareOscillator.stop(noteNumber: noteNumber)
  }

}

