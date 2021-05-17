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
    private var beginButton: UIButton!
    
    // MARK: Display view UI elements
    private var displayView: UIView!
    private var displayPrompt: UILabel!
    private var displayRing: RingView!
    private var continueButton: UIButton!
    private var memorizeTimer: Timer?
    
    // MARK: Recall UI elements
    
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
    }
    
    func makeBlankView() -> UIView {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v)
        
        v.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        v.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        
        return v
    }
    
    
    private func setupStartView() {
        startView = makeBlankView()
        startView.isHidden = false
        
        welcomeMessage = {
            let label = UILabel()
            label.attributedText = "This test measures your ability to memorize spatial information. You will be scored based on the proportion of correct edges selected (recall), and the proportion of selected edges being correct (precision), up to isomorphism.".styled(with: .textStyle)
            label.textAlignment = .center
            label.numberOfLines = 10
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: startView.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
            label.rightAnchor.constraint(equalTo: startView.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
            label.topAnchor.constraint(equalTo: startView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            
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
            label.topAnchor.constraint(equalTo: edgeSlider.bottomAnchor, constant: 25).isActive = true
            
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
            
            let b = button.bottomAnchor.constraint(equalTo: startView.bottomAnchor, constant: -10)
            b.priority = .defaultHigh
            b.isActive = true
            
            button.widthAnchor.constraint(equalToConstant: 220).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.centerXAnchor.constraint(equalTo: startView.centerXAnchor).isActive = true
            button.leftAnchor.constraint(greaterThanOrEqualTo: startView.leftAnchor).isActive = true
            button.rightAnchor.constraint(lessThanOrEqualTo: startView.rightAnchor).isActive = true
            
            button.addTarget(self, action: #selector(beginTest), for: .touchUpInside)
            
            return button
        }()
    }
    
    private func setupDisplayView() {
        
        displayView = makeBlankView()
        displayView.isHidden = true
        
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
            
            ring.widthAnchor.constraint(equalTo: displayView.widthAnchor).withPriority(.defaultHigh).isActive = true
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = AppColors.spatial
    }
    
    @objc private func beginTest() {
        var availableTime = max(5, PlayerRecord.current.connectionCount)
        displayPrompt.attributedText = "Please memorize the edge configuration below. You have up to \(availableTime) seconds. You can rotate the diagram if that helps.".styled(with: .textStyle)
        displayRing.numberOfDots = PlayerRecord.current.nodeCount
        
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
        var possibleEdges = Array(1...n * n).shuffled()
        
        var edges = Set<Connection>()
        for _ in 1...e {
            let coordinate = possibleEdges.removeLast()
            let a = coordinate % n
            let b = coordinate / n
            edges.insert(Connection(a, b))
        }
        
        displayRing.addConnections(edges)
        
        self.continueButton.setTitle("Continue (\(availableTime))", for: .normal)
        memorizeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            availableTime -= 1
            if availableTime > 0 {
                UIView.performWithoutAnimation {
                    self.continueButton.setTitle("Continue (\(availableTime))", for: .normal)
                }
            } else {
                timer.invalidate()
                self.beginRecall()
            }
        }
        
        startView.isHidden = true
        displayView.isHidden = false
    }
    
    @objc private func beginRecall() {
        
    }
}
