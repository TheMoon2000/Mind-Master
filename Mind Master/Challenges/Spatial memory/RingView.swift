//
//  RingView.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2020/9/11.
//  Copyright © 2020 Calpha Dev. All rights reserved.
//

import UIKit

class RingView: UIView {
    
    /// The total number of dots on the ring. If changed, it will clear everything else.
    var numberOfDots = 0 {
        didSet {
            if oldValue != numberOfDots {
                selectedPosition = nil
                connections.removeAll()
                setNeedsDisplay()
            }
        }
    }
    
    /// The angle offset of the ring, in radians. Should be from 0 to 2π.
    dynamic var rotationAngle: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    /// How much is rotated (in radians) during a rotation gesture event.
    private dynamic var rotationDelta: CGFloat = 0
    
    /// The dot which is selected.
    var selectedPosition: Int? {
        didSet { setNeedsDisplay() }
    }
    
    var draggedPosition: CGPoint? {
        didSet { setNeedsDisplay() }
    }
    
    var editable = true
    
    private var sourceIsActivelySelected = false
    
    /// The dots which are connected.
    private(set) var connections = Set<Connection>()
    
    // MARK: Colors
    
    /// The color of the ring.
    var ringColor: UIColor = AppColors.line.withAlphaComponent(0.9) {
        didSet { setNeedsDisplay() }
    }
    
    /// The color of the dots.
    var dotColor: UIColor = AppColors.spatial {
        didSet { setNeedsDisplay() }
    }
    
    /// The color of the selected dots.
    var selectionColor: UIColor = AppColors.spatialLight {
        didSet { setNeedsDisplay() }
    }
    
    /// The color of the connection lines.
    var connectionColor: UIColor = AppColors.connection {
        didSet { setNeedsDisplay() }
    }
    
    private var selfCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// The radius of the ring.
    private let ringWidth: CGFloat = 3
    
    /// The radius of a dot.
    private var dotRadius: CGFloat {
        return max(ringWidth + 5, min(35, bounds.width / 32 - CGFloat(numberOfDots) / 4 + 4))
    }
    
    /// The radius of the selection.
    private var selectionWidth: CGFloat {
        return max(5, min(20, dotRadius / 4))
    }
    
    /// The distance in pixels between the dot and its selection ring.
    private var selectionSpacing: CGFloat {
        return max(3, selectionWidth)
    }
    
    private var connectionWidth: CGFloat {
        return max(5, min(20, bounds.width / 100))
    }
    
    /// The radius of the ring, measured by the stroke line.
    var radius: CGFloat {
        return max(0, bounds.width / 2 - dotRadius - selectionWidth - selectionSpacing - 5)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init(_ connections: Set<Connection> = []) {
        super.init(frame: .init(x: 0, y: 0, width: 300, height: 300))
        
        self.connections = connections
        isOpaque = false
        isUserInteractionEnabled = true
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:))))
    }
    
    func addConnections(_ connections: Set<Connection>) {
        self.connections.formUnion(connections)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        
        guard bounds.width >= 100 else { return }
        
        // Draw the ring
        let ringPath = UIBezierPath(arcCenter: selfCenter, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        ringPath.lineWidth = ringWidth // lineWidth
        ringPath.lineCapStyle = .round
        ringColor.setStroke()
        ringPath.stroke()
        
        var possibleDestination: CGPoint?

        // Draw the dots
        let points = circlePoints()
        
        for i in 0..<numberOfDots {
            
            if selectedPosition == i
                || (draggedPosition?.distance(to: points[i]) ?? .infinity) < visibleRadius(at: i) {
                let outer = UIBezierPath(arcCenter: points[i], radius: dotRadius + selectionSpacing * 2 + selectionWidth, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                AppColors.background.setFill()
                outer.fill()
                
                let selectionRing = UIBezierPath(arcCenter: points[i], radius: dotRadius + selectionSpacing + selectionWidth, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                selectionColor.setFill()
                selectionRing.fill()
                
                let bg = UIBezierPath(arcCenter: points[i], radius: dotRadius + selectionSpacing, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                AppColors.background.setFill()
                bg.fill()
                
                if selectedPosition != i { // Dragged position is close to point i
                    possibleDestination = pointAt(index: i)
                }
            }
        }
        
        // Draw the intended connection, if exists.
        if let sourceIndex = selectedPosition, let target = draggedPosition {
            let path = UIBezierPath()
            path.move(to: pointAt(index: sourceIndex))
            path.addLine(to: possibleDestination ?? target)
            path.lineCapStyle = .round
            path.lineWidth = connectionWidth
            let dashStyle: [CGFloat] = [connectionWidth, connectionWidth * 2]
            path.setLineDash(dashStyle, count: 2, phase: 0)
            AppColors.spatialLight.withAlphaComponent(0.6).setStroke()
            path.stroke()
        }
        
        // Draw the connections
        for conn in connections {
            let path = UIBezierPath()
            path.move(to: pointAt(index: conn.indexA))
            path.addLine(to: pointAt(index: conn.indexB))
            path.lineWidth = connectionWidth
            connectionColor.setStroke()
            path.stroke()
        }
        
        
        for i in 0..<numberOfDots {
            let dot = UIBezierPath(arcCenter: points[i], radius: dotRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            dotColor.setFill()
            dot.fill()
        }
    }
    
    /// Returns a point on the ring that's `angle` radians from north.
    private func pointAt(angle: CGFloat) -> CGPoint {
        let x = selfCenter.x + sin(angle) * radius
        let y = selfCenter.y - cos(angle) * radius
        return CGPoint(x: x, y: y)
    }
    
    private func pointAt(index: Int) -> CGPoint {
        let angle = (rotationAngle + rotationDelta) + 2 * .pi * CGFloat(index) / CGFloat(numberOfDots)
        return pointAt(angle: angle)
    }
    
    /// Return all points on the ring.
    private func circlePoints() -> [CGPoint] {
        return (0..<numberOfDots).map { pointAt(index: $0) }
    }
    
    private func visibleRadius(at index: Int) -> CGFloat {
        return dotRadius + selectionSpacing * 2 + selectionWidth
    }
    
    @objc private func didRotate(_ gestureRecognizer: UIRotationGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            rotationDelta = gestureRecognizer.rotation
            setNeedsDisplay()
        } else if gestureRecognizer.state == .ended {
            rotationAngle += rotationDelta
            rotationDelta = 0
        }
    }

}

// MARK: - Handle user interactions
extension RingView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard editable && touches.count == 1 else { return }
        let touch = touches.first!
        let points = circlePoints()
        
        for i in 0..<numberOfDots {
            if touch.location(in: self).distance(to: points[i]) < visibleRadius(at: i) {
                UISelectionFeedbackGenerator().selectionChanged()
                if selectedPosition == nil {
                    selectedPosition = i
                    sourceIsActivelySelected = true
                } else if i != selectedPosition {
                    let new = Connection(i, selectedPosition!)
                    connections.formSymmetricDifference([new])
                    selectedPosition = nil
                }
                return
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard editable && touches.count == 1 else { return }
        let touch = touches.first!
        
        if selectedPosition != nil {
            draggedPosition = touch.location(in: self)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard editable && touches.count == 1 && selectedPosition != nil else { return }
        let touch = touches.first!
        draggedPosition = nil
        
        let points = circlePoints()
        
        for i in 0..<numberOfDots {
            if touch.location(in: self).distance(to: points[i]) < visibleRadius(at: i) {
                if selectedPosition != i {
                    UISelectionFeedbackGenerator().selectionChanged()
                }
                let new = Connection(i, selectedPosition!)
                connections.formSymmetricDifference([new])
                if selectedPosition == i && sourceIsActivelySelected {
                    sourceIsActivelySelected = false
                    return
                }
                break
            }
        }
        sourceIsActivelySelected = false
        selectedPosition = nil
    }
}

/// An internal class that represents a connection between two dots on a ring.
struct Connection: Hashable, Equatable {
    
    /// The first point
    let indexA: Int
    let indexB: Int
    
    init(_ indexA: Int, _ indexB: Int) {
        self.indexA = min(indexA, indexB)
        self.indexB = max(indexA, indexB)
    }
    
    static func ==(lhs: Connection, rhs: Connection) -> Bool {
        return lhs.indexA == rhs.indexA && lhs.indexB == rhs.indexB
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(indexA)
        hasher.combine(indexB)
    }
}
