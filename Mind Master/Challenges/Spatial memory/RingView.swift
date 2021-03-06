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
    var numberOfDots = 8 {
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
    
    var wingLength: CGFloat {
        return max(connectionWidth * 2.8, 16)
    }
    
    var wingThickness: CGFloat = 2 {
        didSet { setNeedsDisplay() }
    }
    
    var wingAngle: CGFloat = .pi / 6.1 {
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
    var directed = false
    
    private var sourceIsActivelySelected = false
    
    /// The dots which are connected.
    var connections = Set<Connection>() {
        didSet { setNeedsDisplay() }
    }
    
    var wrongConnections = Set<Connection>() {
        didSet { setNeedsDisplay() }
    }
    var absentConnections = Set<Connection>() {
        didSet { setNeedsDisplay() }
    }
    
    var rightDirections = Set<Connection>() {
        didSet { setNeedsDisplay() }
    }
    
    var wrongDirections = Set<Connection>() {
        didSet { setNeedsDisplay() }
    }
    
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
    var connectionColor: UIColor = AppColors.connection.withAlphaComponent(0.9) {
        didSet { setNeedsDisplay() }
    }
    
    var wrongColor: UIColor = AppColors.incorrect.withAlphaComponent(0.9) {
        didSet { setNeedsDisplay() }
    }
    
    var missingColor: UIColor = AppColors.lightControl.withAlphaComponent(0.9) {
        didSet { setNeedsDisplay() }
    }
    
    private var selfCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// The radius of the ring.
    private let ringWidth: CGFloat = 3
    
    /// The radius of a dot.
    var dotRadius: CGFloat {
        return max(ringWidth + 5, min(30, bounds.width / 50 - CGFloat(numberOfDots) / 10 + ringWidth + 5))
    }
    
    /// The radius of the selection.
    private var selectionWidth: CGFloat {
        return max(5, min(25, dotRadius / 3))
    }
    
    /// Convenient computed variable for computing the entire radius of a focused node.
    private var selectedNodeRadius: CGFloat {
        return dotRadius + selectionSpacing * 1.5 + selectionWidth
    }
    
    /// The distance in pixels between the dot and its selection ring.
    private var selectionSpacing: CGFloat {
        return max(3, selectionWidth + 1)
    }
    
    private var connectionWidth: CGFloat {
        return max(5, dotRadius * 0.37)
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
                let outer = UIBezierPath(arcCenter: points[i], radius: selectedNodeRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
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
            let sourcePoint = pointAt(index: sourceIndex)
            path.move(to: sourcePoint)
            path.addLine(to: possibleDestination ?? target)
            
            if directed && (possibleDestination != nil || sourcePoint.distance(to: target) > selectedNodeRadius) {
                
                // First get the angle of the outgoing edge
                let angle = getAngle(from: sourcePoint, to: possibleDestination ?? target)
                
                // Next, figure out the top of the arrow.
                let arrowTop: CGPoint
                if let targetNodeCenter = possibleDestination {
                    let dx = dotRadius * cos(angle)
                    let dy = dotRadius * sin(angle)
                    arrowTop = CGPoint(x: targetNodeCenter.x - dx, y: targetNodeCenter.y + dy)
                } else {
                    arrowTop = target
                }
                
                drawArrowhead(from: sourcePoint, to: arrowTop, color: AppColors.spatialLight.withAlphaComponent(0.65))
            }
            
            path.lineCapStyle = .round
            path.lineWidth = connectionWidth
            let dashStyle: [CGFloat] = [connectionWidth, connectionWidth * 2]
            path.setLineDash(dashStyle, count: 2, phase: 0)
            AppColors.spatialLight.withAlphaComponent(0.6).setStroke()
            path.stroke()
        }
        
        // Draw the connections
        for conn in connections where max(conn.indexA, conn.indexB) < numberOfDots {
            let path = UIBezierPath()
            let sourcePoint = pointAt(index: conn.indexA)
            let targetPoint = pointAt(index: conn.indexB)
            path.move(to: sourcePoint)
            path.addLine(to: targetPoint)
            path.lineWidth = connectionWidth
            connectionColor.setStroke()
            path.stroke()
            
            if directed {
                let angle = getAngle(from: sourcePoint, to: targetPoint)
                let dx = dotRadius * cos(angle)
                let dy = dotRadius * sin(angle)
                let arrowTop = CGPoint(x: targetPoint.x - dx, y: targetPoint.y + dy)
                drawArrowhead(from: sourcePoint, to: arrowTop, color: connectionColor)
            }
        }
        
        // Draw the incorrect connections
        for conn in wrongConnections where max(conn.indexA, conn.indexB) < numberOfDots {
            let path = UIBezierPath()
            let sourcePoint = pointAt(index: conn.indexA)
            let targetPoint = pointAt(index: conn.indexB)
            path.move(to: sourcePoint)
            path.addLine(to: targetPoint)
            path.lineWidth = connectionWidth
            wrongColor.setStroke()
            path.stroke()
            
            if directed {
                let angle = getAngle(from: sourcePoint, to: targetPoint)
                let dx = dotRadius * cos(angle)
                let dy = dotRadius * sin(angle)
                let arrowTop = CGPoint(x: targetPoint.x - dx, y: targetPoint.y + dy)
                drawArrowhead(from: sourcePoint, to: arrowTop, color: wrongColor)
            }
        }
        
        // Draw the missing connections
        for conn in absentConnections where max(conn.indexA, conn.indexB) < numberOfDots {
            let path = UIBezierPath()
            let sourcePoint = pointAt(index: conn.indexA)
            let targetPoint = pointAt(index: conn.indexB)
            path.move(to: sourcePoint)
            path.addLine(to: targetPoint)
            path.lineWidth = connectionWidth
            missingColor.setStroke()
            path.stroke()
            
            if directed {
                let angle = getAngle(from: sourcePoint, to: targetPoint)
                let dx = dotRadius * cos(angle)
                let dy = dotRadius * sin(angle)
                let arrowTop = CGPoint(x: targetPoint.x - dx, y: targetPoint.y + dy)
                drawArrowhead(from: sourcePoint, to: arrowTop, color: missingColor)
            }
        }
        
        // Draw arrows for correct directions (for directed graphs only)
        if directed {
            for conn in rightDirections where max(conn.indexA, conn.indexB) < numberOfDots {
                let sourcePoint = pointAt(index: conn.indexA)
                let targetPoint = pointAt(index: conn.indexB)
                
                let angle = getAngle(from: sourcePoint, to: targetPoint)
                let arrowTop = CGPoint(x: targetPoint.x - dotRadius * cos(angle),
                                       y: targetPoint.y + dotRadius * sin(angle))
                drawArrowhead(from: sourcePoint, to: arrowTop, color: AppColors.correct)
            }
        }
        
        // Draw wrong directions (for directed graphs only)
        if directed {
            for conn in wrongDirections where max(conn.indexA, conn.indexB) < numberOfDots {
                let sourcePoint = pointAt(index: conn.indexA)
                let targetPoint = pointAt(index: conn.indexB)
                
                let wrongAngle = getAngle(from: sourcePoint, to: targetPoint)
                let wrongArrowTop = CGPoint(x: targetPoint.x - dotRadius * cos(wrongAngle),
                                       y: targetPoint.y + dotRadius * sin(wrongAngle))
                drawArrowhead(from: sourcePoint, to: wrongArrowTop, color: wrongColor)
                
                let missingAngle = getAngle(from: targetPoint, to: sourcePoint)
                let missingArrowTop = CGPoint(x: sourcePoint.x - dotRadius * cos(missingAngle),
                                       y: sourcePoint.y + dotRadius * sin(missingAngle))
                drawArrowhead(from: targetPoint, to: missingArrowTop, color: missingColor)
            }
        }
        
        
        for i in 0..<numberOfDots {
            let dot = UIBezierPath(arcCenter: points[i], radius: dotRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            dotColor.setFill()
            dot.fill()
        }
    }
    
    private func drawArrowhead(from sourcePoint: CGPoint, to targetPoint: CGPoint, color: UIColor) {
        let angle = getAngle(from: sourcePoint, to: targetPoint)
        let arrowhead = UIBezierPath()
        arrowhead.move(to: targetPoint)
        var leftWingAngle = angle - wingAngle
        if leftWingAngle < -.pi { leftWingAngle += 2 * .pi }
        let leftWingWidth = wingLength * cos(leftWingAngle)
        let leftWingHeight = wingLength * sin(leftWingAngle)
        arrowhead.addLine(to: CGPoint(x: targetPoint.x - leftWingWidth, y: targetPoint.y + leftWingHeight))
        arrowhead.move(to: targetPoint)
        var rightWingAngle = angle + wingAngle
        if rightWingAngle > .pi { rightWingAngle -= 2 * .pi }
        let rightWingWidth = wingLength * cos(rightWingAngle)
        let rightWingHeight = wingLength * sin(rightWingAngle)
        arrowhead.addLine(to: CGPoint(x: targetPoint.x - rightWingWidth, y: targetPoint.y + rightWingHeight))
        arrowhead.lineCapStyle = .round
        arrowhead.lineWidth = connectionWidth
        color.withAlphaComponent(1.0).setStroke()
        arrowhead.stroke()
    }
        
    /// Returns the angle (in radians) from the source point to the target point (between -pi and pi).
    private func getAngle(from source: CGPoint, to target: CGPoint) -> CGFloat {
        let hyp = sqrt(pow(target.x - source.x, 2) + pow(target.y - source.y, 2))
        let dx = target.x - source.x
        let dy = source.y - target.y // Negated because the origin is the top left corner in UIKit.
        let angle = dy > 0 ? acos(dx / hyp) : -acos(dx / hyp)
        return angle
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
    
    func bestAlignment(for otherConnections: Set<Connection>) -> Int {
        var bestF1 = 0.0
        var bestOrientation = 0
        for i in 0..<numberOfDots {
            let normalized = otherConnections.map { Connection(($0.indexA + i) % numberOfDots,
                                                               ($0.indexB + i) % numberOfDots) }
            let p = fixedPrecision(with: normalized)
            let r = fixedRecall(with: normalized)
            if f1(p, r) > bestF1 {
                bestF1 = f1(p, r)
                bestOrientation = i
            }
        }
        return bestOrientation
    }
    
    func bestStats(with otherConnections: Set<Connection>) -> (precision: Double, recall: Double, similarity: Double) {
        
        let i = bestAlignment(for: otherConnections)
        let normalized = otherConnections.map { Connection(($0.indexA + i) % numberOfDots,
                                                           ($0.indexB + i) % numberOfDots) }
        
        let bestP = fixedPrecision(with: normalized, directed: directed)
        let bestR = fixedRecall(with: normalized, directed: directed)
        let bestF1 = f1(bestP, bestR)
        
        return (bestP, bestR, bestF1.isNaN ? 0.0 : bestF1)
    }
    
    private func fixedPrecision(with otherConnections: [Connection], directed: Bool = false) -> Double {
        if directed {
            var sameCount = 0
            var target = Set(otherConnections)
            for conn in connections where otherConnections.contains(conn) {
                sameCount += 1
                if conn.indexA == target.remove(conn)?.indexA {
                    sameCount += 1
                }
            }
            return Double(sameCount) / Double(otherConnections.count * 2)
        } else {
            let sameCount = self.connections.intersection(otherConnections).count
            return Double(sameCount) / Double(otherConnections.count)
        }
    }
    
    private func fixedRecall(with otherConnections: [Connection], directed: Bool = false) -> Double {
        if directed {
            var sameCount = 0
            var target = Set(otherConnections)
            for conn in connections where otherConnections.contains(conn) {
                sameCount += 1
                if conn.indexA == target.remove(conn)?.indexA {
                    sameCount += 1
                }
            }
            return Double(sameCount) / Double(connections.count * 2)
        } else {
            let sameCount = self.connections.intersection(otherConnections).count
            return Double(sameCount) / Double(connections.count)
        }
    }

    private func f1(_ precision: Double, _ recall: Double) -> Double {
        return 2 * precision * recall / (precision + recall)
    }
    
    func alignedConnections(at offset: Int) -> Set<Connection> {
        return Set(connections.map { Connection(($0.indexA + offset) % numberOfDots,
                                                ($0.indexB + offset) % numberOfDots) })
    }
    
    func reset() {
        connections.removeAll()
        wrongConnections.removeAll()
        absentConnections.removeAll()
        rotationAngle = 0
        rotationDelta = 0
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
                    let new = Connection(selectedPosition!, i)
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
                    let new = Connection(selectedPosition!, i)
                    connections.formSymmetricDifference([new])
                }
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

