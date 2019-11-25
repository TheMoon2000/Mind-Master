//
//  DodgeTrack.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/22.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class DodgeTrack: UIView {
    
    let TRACK_HEIGHT: CGFloat = 100
    let shapeLayer = CAShapeLayer()
    
    var numberOfSlots = 4 {
        didSet {
            if CGFloat(numberOfSlots - 1) < currentSlot {
                currentSlot = CGFloat(numberOfSlots - 1)
            } else {
                setNeedsDisplay()
            }
        }
    }
    
    var currentSlot: CGFloat = 0.0 {
        didSet (oldValue) {
            if round(currentSlot) == currentSlot && currentSlot != oldValue {
                UISelectionFeedbackGenerator().selectionChanged()
            }
            setNeedsDisplay()
        }
    }
    
    var concurrentFalls = Queue<FallingColor>()
    var streak = 0
    
    var gameoverHandler: ((Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.contentMode = .redraw
        
        self.gestureRecognizers = [UIPanGestureRecognizer(target: self, action: #selector(detectPan(_:)))]
        
        concurrentFalls.enqueue(.init(index: 0, fallRate: 1))
        
        Timer.scheduledTimer(withTimeInterval: 1 / 20, repeats: true) { timer in
            while let nextFall = self.concurrentFalls.dequeue() {
                
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let radius = TRACK_HEIGHT / 2
        let trackRect = CGRect(x: 0, y: rect.midY - radius, width: rect.width, height: TRACK_HEIGHT)
        let slotSpacing = (trackRect.width - trackRect.height) / CGFloat(numberOfSlots - 1)
        
        
        // Draw the track
        let border = UIBezierPath()
        border.addArc(withCenter: CGPoint(x: radius, y: trackRect.midY), radius: radius, startAngle: .pi / 2, endAngle: 1.5 * .pi, clockwise: true)
        border.addLine(to: CGPoint(x: trackRect.maxX - radius, y: trackRect.minY))
        border.addArc(withCenter: CGPoint(x: trackRect.maxX - radius, y: trackRect.midY), radius: radius, startAngle: 1.5 * .pi, endAngle: .pi / 2, clockwise: true)
        border.addLine(to: CGPoint(x: radius, y: trackRect.maxY))
        
        AppColors.trackColor.setFill()
        border.fill()
                
        for i in 0..<numberOfSlots {
            var dotRadius: CGFloat = 3.0
            if abs(currentSlot - CGFloat(i)) < 0.9 {
                dotRadius += pow((0.9 - abs(currentSlot - CGFloat(i))), 1.5) * 2
            }
            let dot = UIBezierPath(arcCenter: CGPoint(x: radius + CGFloat(i) * slotSpacing, y: trackRect.midY), radius: dotRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            UIColor.gray.withAlphaComponent(0.5).setFill()
            dot.fill()
        }
        
        let centerWidth = max(0, slotSpacing - trackRect.height)
        let centerX = radius + currentSlot * slotSpacing
        let arcRadius = min(slotSpacing / 1.5, radius - 10)

        // Draw falling colors
        /*
        for fall in concurrentFalls {
            let fallCircle = UIBezierPath(arcCenter: CGPoint(x: radius + CGFloat(fall.trackIndex) * slotSpacing, y: CGFloat(fall.fallPercentage) * rect.height), radius: arcRadius * 0.8, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            AppColors.tapOff.setFill()
            fallCircle.fill()
            
            if fall.fallPercentage > 2.0 {
                DispatchQueue.global(qos: .default).async {
                    self.concurrentFalls.remove(fall)
                }
                streak += 1
            }
        }*/
        
        let player = UIBezierPath()
        player.addArc(withCenter: CGPoint(x: max(radius, centerX - centerWidth / 2), y: trackRect.midY), radius: arcRadius, startAngle: .pi / 2, endAngle: 1.5 * .pi, clockwise: true)
        player.addLine(to: CGPoint(x: centerX + centerWidth / 2, y: trackRect.midY - arcRadius))
        player.addArc(withCenter: CGPoint(x: min(trackRect.width - radius, centerX + centerWidth / 2), y: trackRect.midY), radius: arcRadius, startAngle: 1.5 * .pi, endAngle: .pi / 2, clockwise: true)
        player.addLine(to: CGPoint(x: centerX - centerWidth / 2, y: trackRect.midY + arcRadius))
        
        if currentSlot == round(currentSlot) {
            AppColors.card.withAlphaComponent(0.85).setFill()
        } else {
            AppColors.card.withAlphaComponent(0.75).setFill()
        }
        player.fill()
    }
    
    @objc private func detectPan(_ recognizer: UIPanGestureRecognizer) {
        
        let trackRect = CGRect(x: 0, y: frame.midY - TRACK_HEIGHT / 2, width: frame.width, height: TRACK_HEIGHT)
        
        let slotSpacing = (trackRect.width - trackRect.height) / CGFloat(numberOfSlots - 1)

        let rawX = recognizer.location(in: self).x
        let normalized = max(0, (min(rawX, trackRect.width - trackRect.height / 2) - trackRect.height / 2)) / slotSpacing
        let closest = abs(round(normalized) - normalized)
        if closest * slotSpacing < min(12, slotSpacing / 4) {
            currentSlot = round(normalized)
        } else {
            currentSlot = normalized
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
