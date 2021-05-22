//
//  ConnectTheDots.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2020/9/11.
//  Copyright © 2020 Calpha Dev. All rights reserved.
//

import UIKit

class ConnectTheDots: UIViewController {
    
    // MARK: Start view UI elements
    private var startView: UIView!
    private var welcomeMessage: UILabel!
    private var numberOfEdgesLabel: UILabel!
    private var numberOfEdges: UILabel!
    private var edgeSlider: SegmentedSlider!
    private var numberOfNodesLabel: UILabel!
    private var numberOfNodes: UILabel!
    private var nodesSlider: SegmentedSlider!
    private var useDirectedEdgesLabel: UILabel!
    private var useDirectedEdgesSwitch: UISwitch!
    private var beginButton: UIButton!
    
    // MARK: Display view UI elements
    private var displayView: UIView!
    private var displayPrompt: UILabel!
    private var displayRing: RingView!
    private var continueButton: UIButton!
    private var memorizeTimer: Timer?
    
    // MARK: Recall UI elements
    private var recallView: UIView!
    private var resultTitle: UILabel!
    private var resultMessage: UILabel!
    private var recallPrompt: UILabel!
    private var recallRing: RingView!
    private var submitButton: UIButton!
    
    // MARK: Results UI elements
    private var resultView: UIView!
    private var scorePrompt: UILabel!
    private var score: UILabel!
    private var viewAnswersButton: UIButton!
    private var returnButton: UIButton!
    
    private var memorizationTimeLimit: TimeInterval {
        return max(5, Double(PlayerRecord.current.connectionCount))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Connect the Dots"
        view.backgroundColor = AppColors.background
        view.tintColor = AppColors.connection
        
        setupStartView()
        setupDisplayView()
        setupRecallView()
        setupResultsView()
    }
    
    func makeBlankView() -> UIView {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v)
        
        v.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        v.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        v.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        v.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).withPriority(.defaultHigh).isActive = true
        v.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).withPriority(.defaultHigh).isActive = true
        v.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
            
        return v
    }
    
    
    private func setupStartView() {
        startView = makeBlankView()
        startView.widthAnchor.constraint(lessThanOrEqualToConstant: 700).isActive = true
        startView.heightAnchor.constraint(lessThanOrEqualToConstant: 1000).isActive = true
        startView.isHidden = false
        
        welcomeMessage = {
            let label = UILabel()
            label.attributedText = "This test measures your ability to memorize spatial information. You will be scored based on the proportion of correct edges selected (recall), and the proportion of selected edges being correct (precision).".styled(with: .textStyle)
            label.textAlignment = .center
            label.numberOfLines = 10
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: startView.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
            label.rightAnchor.constraint(equalTo: startView.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
            label.topAnchor.constraint(equalTo: startView.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
            
            return label
        }()
        
        numberOfEdgesLabel = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = "Number of edges:"
            label.font = .systemFont(ofSize: 17, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(greaterThanOrEqualTo: welcomeMessage.leftAnchor).isActive = true
            label.topAnchor.constraint(equalTo: welcomeMessage.bottomAnchor, constant: 40).isActive = true
            
            label.setContentHuggingPriority(.required, for: .horizontal)
            
            return label
        }()
        
        numberOfEdges = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = PlayerRecord.current.connectionCount.description
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: numberOfEdgesLabel.rightAnchor, constant: 12).isActive = true
            label.centerYAnchor.constraint(equalTo: numberOfEdgesLabel.centerYAnchor).isActive = true
            label.rightAnchor.constraint(lessThanOrEqualTo: startView.rightAnchor, constant: -30).isActive = true
            
            return label
        }()
        
        edgeSlider = {
            let sliderView = SegmentedSlider()
            sliderView.tintColor = AppColors.spatial
            sliderView.minItems = 2
            sliderView.maxItems = 30
            sliderView.currentItem = PlayerRecord.current.connectionCount
            sliderView.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(sliderView)
            
            sliderView.topAnchor.constraint(equalTo: numberOfEdgesLabel.bottomAnchor, constant: 8).isActive = true
            sliderView.centerXAnchor.constraint(equalTo: startView.centerXAnchor).isActive = true
            sliderView.widthAnchor.constraint(equalTo: startView.widthAnchor, multiplier: 0.8).isActive = true
            sliderView.leftAnchor.constraint(equalTo: numberOfEdgesLabel.leftAnchor).isActive = true
            
            sliderView.onUpdate = { newCount in
                PlayerRecord.current.connectionCount = newCount
                self.numberOfEdges.text = newCount.description
            }
            
            return sliderView
        }()
        
        numberOfNodesLabel = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = "Number of nodes:"
            label.font = .systemFont(ofSize: 17, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(greaterThanOrEqualTo: welcomeMessage.leftAnchor).isActive = true
            label.topAnchor.constraint(equalTo: edgeSlider.bottomAnchor, constant: 20).isActive = true
            
            label.setContentHuggingPriority(.required, for: .horizontal)
            
            return label
        }()
        
        numberOfNodes = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = PlayerRecord.current.nodeCount.description
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: numberOfNodesLabel.rightAnchor, constant: 12).isActive = true
            label.centerYAnchor.constraint(equalTo: numberOfNodesLabel.centerYAnchor).isActive = true
            label.rightAnchor.constraint(lessThanOrEqualTo: startView.rightAnchor, constant: -30).isActive = true
            
            return label
        }()
        
        nodesSlider = {
            let sliderView = SegmentedSlider()
            sliderView.tintColor = AppColors.spatial
            sliderView.minItems = 4
            sliderView.maxItems = 24
            sliderView.currentItem = PlayerRecord.current.nodeCount
            sliderView.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(sliderView)
            
            sliderView.topAnchor.constraint(equalTo: numberOfNodesLabel.bottomAnchor, constant: 8).isActive = true
            sliderView.centerXAnchor.constraint(equalTo: startView.centerXAnchor).isActive = true
            sliderView.widthAnchor.constraint(equalTo: edgeSlider.widthAnchor).isActive = true
            sliderView.leftAnchor.constraint(equalTo: numberOfNodesLabel.leftAnchor).isActive = true
            
            sliderView.onUpdate = { newCount in
                PlayerRecord.current.nodeCount = newCount
                self.numberOfNodes.text = newCount.description
            }
            
            return sliderView
        }()
        
        useDirectedEdgesLabel = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = "Use directed edges:"
            label.font = .systemFont(ofSize: 17, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(greaterThanOrEqualTo: welcomeMessage.leftAnchor).isActive = true
            label.topAnchor.constraint(equalTo: nodesSlider.bottomAnchor, constant: 20).isActive = true
            
            label.setContentHuggingPriority(.required, for: .horizontal)
            
            return label
        }()
        
        useDirectedEdgesSwitch = {
            let sw = UISwitch()
            sw.isOn = PlayerRecord.current.isDirected
            sw.translatesAutoresizingMaskIntoConstraints = false
            sw.addTarget(self, action: #selector(toggleDirectedness), for: .valueChanged)
            startView.addSubview(sw)
            
            sw.rightAnchor.constraint(equalTo: welcomeMessage.rightAnchor).isActive = true
            sw.centerYAnchor.constraint(equalTo: useDirectedEdgesLabel.centerYAnchor).isActive = true
            
            return sw
        }()
        
        beginButton = {
            let button = UIButton(type: .system)
            button.setTitle("Begin Test", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
            button.layer.cornerRadius = 24
            button.layer.borderColor = AppColors.connection.cgColor
            button.layer.borderWidth = 1
            button.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(button)
            
            button.topAnchor.constraint(greaterThanOrEqualTo: nodesSlider.bottomAnchor, constant: 10).isActive = true
            
            button.bottomAnchor.constraint(equalTo: startView.bottomAnchor, constant: -10).withPriority(.defaultHigh).isActive = true
            
            button.widthAnchor.constraint(equalToConstant: 220).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.centerXAnchor.constraint(equalTo: startView.centerXAnchor).isActive = true
            button.leftAnchor.constraint(greaterThanOrEqualTo: startView.leftAnchor).isActive = true
            button.rightAnchor.constraint(lessThanOrEqualTo: startView.rightAnchor).isActive = true
            button.topAnchor.constraint(greaterThanOrEqualTo: useDirectedEdgesLabel.bottomAnchor, constant: 5).isActive = true
            
            button.addTarget(self, action: #selector(beginTest), for: .touchUpInside)
            
            return button
        }()
    }
    
    
    private func setupDisplayView() {
        
        displayView = makeBlankView()
        
        displayPrompt = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            displayView.addSubview(label)
            
            label.topAnchor.constraint(equalTo: displayView.topAnchor, constant: 10).isActive = true
            label.leftAnchor.constraint(equalTo: displayView.leftAnchor, constant: 20).isActive = true
            label.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
            
            return label
        }()
        
        displayRing = {
            let ring = RingView()
            ring.editable = false
            ring.translatesAutoresizingMaskIntoConstraints = false
            displayView.addSubview(ring)
            
            ring.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
            ring.centerYAnchor.constraint(equalTo: displayView.centerYAnchor, constant: 20).isActive = true
            ring.widthAnchor.constraint(lessThanOrEqualToConstant: 800).isActive = true
            ring.leftAnchor.constraint(greaterThanOrEqualTo: displayView.leftAnchor).isActive = true
            ring.rightAnchor.constraint(lessThanOrEqualTo: displayView.rightAnchor).isActive = true
            ring.bottomAnchor.constraint(lessThanOrEqualTo: displayView.bottomAnchor).isActive = true
            ring.topAnchor.constraint(greaterThanOrEqualTo: displayPrompt.bottomAnchor, constant: 20).isActive = true
            
            ring.widthAnchor.constraint(equalTo: displayView.widthAnchor, multiplier: 0.95).withPriority(.defaultHigh).isActive = true
            
            return ring
        }()
        
        continueButton = {
            let button = UIButton()
            button.setTitle("Continue", for: .normal)
            button.setTitleColor(AppColors.connection, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
            button.layer.cornerRadius = 24
            button.layer.borderColor = AppColors.connection.cgColor
            button.layer.borderWidth = 1
            button.translatesAutoresizingMaskIntoConstraints = false
            displayView.addSubview(button)
            
            let b = button.bottomAnchor.constraint(equalTo: displayView.bottomAnchor, constant: -10)
            b.priority = .defaultHigh
            b.isActive = true
            
            button.widthAnchor.constraint(equalToConstant: 220).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
            button.leftAnchor.constraint(greaterThanOrEqualTo: displayView.leftAnchor).isActive = true
            button.rightAnchor.constraint(lessThanOrEqualTo: displayView.rightAnchor).isActive = true
            
            button.addTarget(self, action: #selector(beginRecall), for: .touchUpInside)
            
            return button
        }()
    }
    
    private func setupRecallView() {
        recallView = makeBlankView()
        
        recallPrompt = {
            let label = UILabel()
            label.text = "Now try to reproduce the graph you saw."
            label.textColor = AppColors.label
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            recallView.addSubview(label)
            
            label.topAnchor.constraint(equalTo: displayView.topAnchor, constant: 10).isActive = true
            label.leftAnchor.constraint(equalTo: displayView.leftAnchor, constant: 20).isActive = true
            label.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
            
            return label
        }()
        
        recallRing = {
            let ring = RingView()
            ring.numberOfDots = PlayerRecord.current.nodeCount
            ring.translatesAutoresizingMaskIntoConstraints = false
            recallView.addSubview(ring)
            
            ring.widthAnchor.constraint(lessThanOrEqualToConstant: 800).isActive = true
            ring.topAnchor.constraint(greaterThanOrEqualTo: recallPrompt.bottomAnchor, constant: 10).isActive = true
            ring.centerXAnchor.constraint(equalTo: recallView.centerXAnchor).isActive = true
            ring.centerYAnchor.constraint(equalTo: recallView.centerYAnchor, constant: 20).isActive = true
            ring.widthAnchor.constraint(equalTo: recallView.widthAnchor, multiplier: 0.95).withPriority(.defaultHigh).isActive = true
            
            return ring
        }()
        
        submitButton = {
            let button = UIButton()
            button.setTitle("Done", for: .normal)
            button.setTitleColor(AppColors.connection, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
            button.layer.cornerRadius = 24
            button.layer.borderColor = AppColors.connection.cgColor
            button.layer.borderWidth = 1
            button.translatesAutoresizingMaskIntoConstraints = false
            recallView.addSubview(button)
            
            let b = button.bottomAnchor.constraint(equalTo: recallView.bottomAnchor, constant: -10)
            b.priority = .defaultHigh
            b.isActive = true
            
            button.widthAnchor.constraint(equalToConstant: 220).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.centerXAnchor.constraint(equalTo: recallView.centerXAnchor).isActive = true
            button.leftAnchor.constraint(greaterThanOrEqualTo: recallView.leftAnchor).isActive = true
            button.rightAnchor.constraint(lessThanOrEqualTo: recallView.rightAnchor).isActive = true
            
            button.addTarget(self, action: #selector(showResults), for: .touchUpInside)
            
            return button
        }()
    }
    
    private func setupResultsView() {
        resultView = makeBlankView()
        resultView.widthAnchor.constraint(lessThanOrEqualToConstant: 700).isActive = true
        resultView.heightAnchor.constraint(lessThanOrEqualToConstant: 1000).isActive = true
        
        resultTitle = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 24, weight: .medium)
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.numberOfLines = 3
            label.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: resultView.leftAnchor, constant: 10).isActive = true
            label.rightAnchor.constraint(equalTo: resultView.rightAnchor, constant: -10).isActive = true
            label.topAnchor.constraint(greaterThanOrEqualTo: resultView.topAnchor, constant: 15).isActive = true
            
            return label
        }()
        
        resultMessage = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 15)
            label.textColor = AppColors.value
            label.textAlignment = .center
            label.numberOfLines = 3
            label.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: resultTitle.bottomAnchor, constant: 10).isActive = true
            
            return label
        }()
        
        score = {
            let label = UILabel()
            label.textColor = view.tintColor
            label.font = .systemFont(ofSize: 60)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: resultView.safeAreaLayoutGuide.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: resultView.safeAreaLayoutGuide.centerYAnchor).isActive = true
            
            return label
        }()
        
        scorePrompt = {
            let label = UILabel()
            label.text = "Your accuracy:"
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: score.topAnchor, constant: -12).isActive = true
            label.topAnchor.constraint(greaterThanOrEqualTo: resultMessage.bottomAnchor, constant: 15).isActive = true
            label.topAnchor.constraint(equalTo: resultMessage.bottomAnchor, constant: 80).withPriority(.defaultHigh).isActive = true
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            
            return label
        }()
        
        
        viewAnswersButton = {
            let button = UIButton(type: .system)
            button.tintColor = AppColors.link
            button.setTitle("View Answers", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15)
            button.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(button)
            
            button.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: resultView.bottomAnchor).isActive = true
            
            button.addTarget(self, action: #selector(viewAnswers), for: .touchUpInside)
            
            return button
        }()
        
        returnButton = {
            let button = UIButton(type: .system)
            button.setTitle("Return to Menu", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17)
            button.layer.cornerRadius = 24
            button.layer.borderColor = AppColors.connection.cgColor
            button.layer.borderWidth = 1
            button.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(button)
            
            button.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.widthAnchor.constraint(equalToConstant: 220).isActive = true
            button.topAnchor.constraint(equalTo: score.bottomAnchor, constant: 80).withPriority(.defaultHigh).isActive = true
            button.topAnchor.constraint(greaterThanOrEqualTo: score.bottomAnchor, constant: 10).isActive = true
            
            button.bottomAnchor.constraint(lessThanOrEqualTo: viewAnswersButton.topAnchor, constant: 10).isActive = true
            
            button.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
            
            return button
        }()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = AppColors.spatial
    }
    
    private func generateConfetti() {
        
        let particlesLayer = CAEmitterLayer()

        view.layer.addSublayer(particlesLayer)

        particlesLayer.backgroundColor = UIColor.clear.cgColor
        particlesLayer.emitterShape = .line
        particlesLayer.emitterPosition = CGPoint(x: view.frame.midX, y: view.safeAreaLayoutGuide.layoutFrame.minY + 15)
        particlesLayer.emitterSize = .init(width: recallView.frame.width, height: 1)


        let cell1 = CAEmitterCell()
        cell1.birthRate = 20.0
        cell1.lifetime = 7
        cell1.scale = 1
        cell1.yAcceleration = 100

        let subcells: [CAEmitterCell] = [#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "8")].map {
            let cell = CAEmitterCell()
            cell.contents = $0.cgImage
            cell.birthRate = 50
            cell.lifetime = 10.0
            cell.beginTime = 0.0
            cell.duration = 0.1
            cell.velocity = 100.0
            cell.yAcceleration = 85.0
            cell.emissionRange = 360.0 * (.pi / 180.0)
            cell.spin = 2 * .pi
            cell.spinRange = 0.5 * .pi
            cell.scale = 0.12
            cell.scaleRange = 0.05
            cell.alphaSpeed = -0.5
            
            return cell
        }

        cell1.emitterCells = subcells

        particlesLayer.emitterCells = [cell1]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             particlesLayer.birthRate = 0.0
        }
    }
    
    @objc private func toggleDirectedness() {
        PlayerRecord.current.isDirected = useDirectedEdgesSwitch.isOn
    }
    
    @objc private func beginTest() {
        var availableTime = max(5, PlayerRecord.current.connectionCount)
        displayPrompt.attributedText = "Please memorize the edge configuration below. You have up to \(availableTime) seconds. You can rotate the graph if that helps.".styled(with: .textStyle)
        displayRing.numberOfDots = PlayerRecord.current.nodeCount
        displayRing.directed = PlayerRecord.current.isDirected
        
        let n = PlayerRecord.current.nodeCount
        let e = PlayerRecord.current.connectionCount
        
        // Check that edges are valid
        guard n * (n - 1) / 2 >= e else {
            let alert = UIAlertController(title: "Too many edges specified", message: "You have specified more edges than the maximum possible number of edges formed by \(n) vertices (\(n * (n - 1) / 2)). Please try a smaller number.", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
            
            return
        }
        
        // Constructing `e` edges
        var possibleEdges = [Connection]()
        for i in 0..<n-1 {
            for j in (i+1)..<n {
                if Int.random(in: 0...1) == 0 {
                    possibleEdges.append(Connection(i, j))
                } else {
                    possibleEdges.append(Connection(j, i))
                }
            }
        }
        
        let edges = Set(possibleEdges.shuffled()[..<e])
        
        displayRing.connections = edges
        
        self.continueButton.setTitle("Continue (\(availableTime))", for: .normal)
        memorizeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            availableTime -= 1
            if availableTime > 0 {
                UIView.performWithoutAnimation {
                    self.continueButton.setTitle("Continue (\(availableTime))", for: .normal)
                }
            } else {
                self.beginRecall()
            }
        }
        
        startView.isHidden = true
        displayView.isHidden = false
    }
    
    @objc private func beginRecall() {
        memorizeTimer?.invalidate()
        memorizeTimer = nil
        recallRing.connections.removeAll()
        recallRing.numberOfDots = PlayerRecord.current.nodeCount
        recallRing.directed = PlayerRecord.current.isDirected
        
        displayView.isHidden = true
        recallView.isHidden = false
    }
    
    @objc private func showResults() {
        let (p, r, similarity) = displayRing.bestStats(with: recallRing.connections)
        score.text = String(format: "%.1f%%", arguments: [similarity * 100])
        
        let rounded = Int(round(similarity * 100))
        if similarity == 1.0 {
            resultTitle.text = "Perfect! 100% Correct!"
        } else if similarity >= 0.9 {
            resultTitle.text = "Excellent! \(rounded)% Correct!"
        } else if similarity >= 0.8 {
            resultTitle.text = "Good job! You got \(rounded)% correct."
        } else if similarity >= 0.7 {
            resultTitle.text = "Satisfactory - You got \(rounded)% correct."
        } else {
            resultTitle.text = "Oops, you only got \(rounded)% correct."
        }
        
        resultMessage.attributedText = String(format: "Precision: %.2f%%\nRecall: %.2f%%", arguments: [p * 100, r * 100]).styled(with: .textStyle, .font(.systemFont(ofSize: 15)))
        resultMessage.textAlignment = .center

        recallView.isHidden = true
        resultView.isHidden = false
        
        if similarity == 1.0 {
            generateConfetti()
        }
    }
    
    @objc private func viewAnswers() {
        navigationItem.backBarButtonItem = .init(title: "Results", style: .plain, target: nil, action: nil)
        let bestAlignment = recallRing.alignedConnections(at: displayRing.bestAlignment(for: recallRing.connections))
        let answerVC = GraphUserAnswers(userCon: bestAlignment, trueCon: displayRing.connections, directed: PlayerRecord.current.isDirected)
        navigationController?.pushViewController(answerVC, animated: true)
    }
    
    @objc private func backToMenu() {
        recallRing.connections.removeAll()
        resultView.isHidden = true
        startView.isHidden = false
    }
}
