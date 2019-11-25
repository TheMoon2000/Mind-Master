//
//  ColorDodgeChallenge.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/22.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class ColorDodgeChallenge: UIViewController {
    
    private var sliderPrompt: UILabel!
    private var sliderValue: UILabel!
    private var slider: UISlider!
    private var sliderTrack: UIView!
    private var thumbWidth: CGFloat = 0.0
    
    private var track: DodgeTrack!
    
    let MIN_TRACK = 2
    let MAX_TRACK = 8
    
    var currentValue: Float = Float(PlayerRecord.current.trackNumber) {
        didSet (oldValue) {
            if currentValue != oldValue {
                sliderValue.text = Int(currentValue).description
                PlayerRecord.current.trackNumber = Int(currentValue)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Color Dodge"
        view.backgroundColor = AppColors.background
        
        sliderPrompt = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = "Number of tracks:"
            label.font = .systemFont(ofSize: 17, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            
            label.setContentHuggingPriority(.required, for: .horizontal)
            
            return label
        }()
        
        sliderValue = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.textAlignment = .right
            label.text = String(PlayerRecord.current.trackNumber)
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: sliderPrompt.rightAnchor, constant: 12).isActive = true
            label.centerYAnchor.constraint(equalTo: sliderPrompt.centerYAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
            
            return label
        }()
        
        slider = {
            let slider = UISlider()
            slider.isContinuous = true
            slider.maximumTrackTintColor = .clear
            slider.minimumTrackTintColor = .clear
            slider.thumbTintColor = AppColors.reaction
            slider.maximumValue = Float(MAX_TRACK)
            slider.minimumValue = Float(MIN_TRACK)
            slider.value = Float(PlayerRecord.current.trackNumber)
            
            slider.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(slider)
            
            slider.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 28).isActive = true
            slider.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -28).isActive = true
            slider.topAnchor.constraint(equalTo: sliderPrompt.bottomAnchor, constant: 10).isActive = true
                
            slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
            
            return slider
        }()
        
        track = {
            let track = DodgeTrack()
            track.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(track, at: 0)
            
            track.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
            track.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
            track.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            track.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            return track
        }()
        
        sliderTrack = {
            let ticks = UIView()
            ticks.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(ticks, belowSubview: slider)
            ticks.leftAnchor.constraint(equalTo: slider.leftAnchor).isActive = true
            ticks.rightAnchor.constraint(equalTo: slider.rightAnchor).isActive = true
            ticks.topAnchor.constraint(equalTo: slider.topAnchor).isActive = true
            ticks.bottomAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            
            let segmentCount = CGFloat(MAX_TRACK - MIN_TRACK)
            thumbWidth = slider.thumbRect(
                forBounds: slider.bounds,
                trackRect: slider.trackRect(forBounds: slider.bounds), value: 0).width
            
            let track = UIView()
            track.backgroundColor = AppColors.line
            track.translatesAutoresizingMaskIntoConstraints = false
            ticks.addSubview(track)
            
            track.heightAnchor.constraint(equalToConstant: 2).isActive = true
            track.leftAnchor.constraint(equalTo: slider.leftAnchor,
                                        constant: thumbWidth / 2).isActive = true
            track.rightAnchor.constraint(equalTo: slider.rightAnchor,
                                         constant: -thumbWidth / 2).isActive = true
            track.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
            
            // Ticks
            
            func makeTickmark() -> UIView {
                let tick = UIView()
                tick.backgroundColor = track.backgroundColor
                tick.translatesAutoresizingMaskIntoConstraints = false
                ticks.addSubview(tick)
                
                tick.widthAnchor.constraint(equalToConstant: 2).isActive = true
                tick.heightAnchor.constraint(equalToConstant: 12).isActive = true
                tick.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
                
                return tick
            }
            
            for i in 0...(MAX_TRACK - MIN_TRACK) {
                let tickmark = makeTickmark()
                
                
                //  Pseudocode:
                //  tick.centerX = (slider.right - thumbWidth) * i / segmentCount + thumbWidth / 2
                
                
                //  Note: The `multiplier` property cannot be zero, so we need to use a sufficiently small but positive number instead.
                
                NSLayoutConstraint(item: tickmark,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: ticks,
                                   attribute: .right,
                                   multiplier: max(0.000001,
                                                   CGFloat(i) / segmentCount),
                                   constant: -thumbWidth * CGFloat(i) / segmentCount + thumbWidth / 2).isActive = true
                
            }
            
            return ticks
        }()
    }
    
    @objc private func sliderChanged() {
        slider.value = round(Float(slider.value))
        if slider.value != currentValue {
            currentValue = slider.value
            UISelectionFeedbackGenerator().selectionChanged()
            track.numberOfSlots = Int(slider.value)
        }
    }

}
