//
//  SegmentedSlider.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2020/9/12.
//  Copyright © 2020 Calpha Dev. All rights reserved.
//

import UIKit

class SegmentedSlider: UIView {
    
    let thumbWidth: CGFloat = 27

    var maxItems: Int = 1 {
        didSet {
            subviews.forEach { subview in
                if subview != slider { subview.removeFromSuperview() }
                slider.maximumValue = Float(maxItems)
                slider.minimumValue = Float(minItems)
                setupTicks()
            }
        }
    }
    var minItems: Int = 0 {
        didSet {
            if minItems > maxItems { return }
            subviews.forEach { subview in
                if subview != slider { subview.removeFromSuperview() }
                slider.minimumValue = Float(minItems)
                slider.maximumValue = Float(maxItems)
                setupTicks()
            }
        }
    }
    var currentItem: Int = 0 {
        didSet {
            slider.value = Float(currentItem)
        }
    }
    var onUpdate: ((Int) -> Void)?
    private(set) var slider = UISlider()

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init() {
        super.init(frame: .zero)
        
        slider.isContinuous = true
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        slider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(slider)
        
        slider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        slider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: topAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        setupTicks()
    }
    
    func setupTicks() {
               
        let segmentCount = CGFloat(maxItems - minItems)

        let track = UIView()
        track.backgroundColor = AppColors.line
        track.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(track, belowSubview: slider)

        track.heightAnchor.constraint(equalToConstant: 2).isActive = true
        track.leftAnchor.constraint(equalTo: slider.leftAnchor).isActive = true
        track.rightAnchor.constraint(equalTo: slider.rightAnchor).isActive = true
        track.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true

        // Ticks

        func makeTickmark() -> UIView {
            let tick = UIView()
            tick.backgroundColor = track.backgroundColor
            tick.translatesAutoresizingMaskIntoConstraints = false
            insertSubview(tick, belowSubview: slider)

            tick.widthAnchor.constraint(equalToConstant: 2).isActive = true
            tick.heightAnchor.constraint(equalToConstant: 12).isActive = true
            tick.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true

            return tick
        }

        for i in 0...(maxItems - minItems) {
            let tickmark = makeTickmark()

            //  Note: The `multiplier` property cannot be zero, so we need to use a sufficiently small but  positive number instead.

            NSLayoutConstraint(item: tickmark,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .right,
                               multiplier: max(0.000001,
                                               CGFloat(i) / segmentCount),
                               constant: -thumbWidth * CGFloat(i) / segmentCount + thumbWidth / 2).isActive =  true

        }

    }
    
    @objc private func sliderChanged() {
        slider.value = round(slider.value)
        if Int(slider.value) != currentItem {
            UISelectionFeedbackGenerator().selectionChanged()
            currentItem = Int(slider.value)
            onUpdate?(Int(slider.value))
        }
    }

}
