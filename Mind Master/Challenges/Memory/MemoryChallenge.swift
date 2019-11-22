//
//  MemoryChallenge.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit
import BonMot

class MemoryChallenge: UIViewController {
    
    private var startView: UIView!
    private var welcomeMessage: UILabel!
    private var numberOfItemsLabel: UILabel!
    private var numberOfItems: UILabel!
    private var numberOfItemsSlider: UISlider!
    private var numberOfItemsPrompt: UILabel!
    private var delayPerItemLabel: UILabel!
    private var delayPerItem: UILabel!
    private var delayPerItemSlider: UISlider!
    private var delayPerItemPrompt: UILabel!
    private var testType: UISegmentedControl!
    private var beginButton: UIButton!
    
    private var countdownView: UIView!
    private var countdownTitle: UILabel!
    private var countdownSubtitle: UILabel!
    private var countdownDigit: UILabel!
    private var countdownCaption: UILabel!
    private var countdownFrom = 3
    private var countdownTimer: Timer?
    
    private var digitView: UIView!
    private var recallView: UIView!
    private var resultView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Short-term Memorization"
        view.backgroundColor = AppColors.background
        
        view.tintColor = AppColors.memory

        startView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
            
            v.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
            v.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            v.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
            v.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
            
            let l = v.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30)
            l.priority = .defaultHigh
            l.isActive = true
            
            let r = v.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30)
            r.priority = .defaultHigh
            r.isActive = true
            
            v.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
            v.heightAnchor.constraint(lessThanOrEqualToConstant: 1000).isActive = true
            
            let t = v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
            t.priority = .defaultHigh
            t.isActive = true
            
            let b = v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            b.priority = .defaultHigh
            b.isActive = true
            
            return v
        }()
        
        countdownView = {
            let v = UIView()
            v.isHidden = true
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
            
            v.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
            v.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
            v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
            
            return v
        }()
        
        setupStartView()
        setupCountdownView()
    }
    
    private func setupStartView() {
        
        welcomeMessage = {
            let label = UILabel()
            label.attributedText = "This test measures your ability to memorize a set of itmes in limited time. You will be scored based on the number of items, delay per item and your accuracy of recall.".styled(with: .textStyle)
            label.textAlignment = .center
            label.numberOfLines = 10
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: startView.leftAnchor, constant: 25).isActive = true
            label.rightAnchor.constraint(equalTo: startView.rightAnchor, constant: -25).isActive = true
            label.topAnchor.constraint(equalTo: startView.topAnchor, constant: 25).isActive = true
            
            label.setContentHuggingPriority(.required, for: .vertical)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            
            return label
        }()
        
        
        numberOfItemsLabel = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = "Number of items:"
            label.font = .systemFont(ofSize: 17, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: welcomeMessage.leftAnchor).isActive = true
            label.topAnchor.constraint(equalTo: welcomeMessage.bottomAnchor, constant: 40).isActive = true
            
            label.setContentHuggingPriority(.required, for: .horizontal)
            
            return label
        }()
        
        numberOfItems = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = PlayerRecord.current.memoryItemCount.description
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: numberOfItemsLabel.rightAnchor, constant: 12).isActive = true
            label.centerYAnchor.constraint(equalTo: numberOfItemsLabel.centerYAnchor).isActive = true
            label.rightAnchor.constraint(lessThanOrEqualTo: startView.rightAnchor, constant: -30).isActive = true
            
            return label
        }()
        
        numberOfItemsSlider = {
            let slider = UISlider()
            slider.isContinuous = true
            slider.minimumValue = 4
            slider.maximumValue = 32
            slider.value = Float(PlayerRecord.current.memoryItemCount)
            slider.maximumTrackTintColor = AppColors.disabled
            slider.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(slider)
            
            slider.topAnchor.constraint(equalTo: numberOfItemsLabel.bottomAnchor, constant: 8).isActive = true
            slider.leftAnchor.constraint(equalTo: welcomeMessage.leftAnchor).isActive = true
            slider.rightAnchor.constraint(equalTo: welcomeMessage.rightAnchor).isActive = true
            
            slider.addTarget(self, action: #selector(numberOfItemsChanged(_:)), for: .valueChanged)
            
            return slider
        }()
        
        numberOfItemsPrompt = {
            let label = UILabel()
            label.text = "The number of items you would to memorize and recall."
            label.numberOfLines = 5
            label.font = .systemFont(ofSize: 13)
            label.textColor = AppColors.value
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: numberOfItemsLabel.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: welcomeMessage.rightAnchor).isActive = true
            label.topAnchor.constraint(equalTo: numberOfItemsSlider.bottomAnchor, constant: 8).isActive = true
            
            return label
        }()
        
        delayPerItemLabel = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = "Delay per item:"
            label.font = .systemFont(ofSize: 17, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: welcomeMessage.leftAnchor).isActive = true
            label.topAnchor.constraint(equalTo: numberOfItemsPrompt.bottomAnchor, constant: 20).isActive = true
            
            label.setContentHuggingPriority(.required, for: .horizontal)
            
            return label
        }()
        
        delayPerItem = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = String(format: "%.1f", PlayerRecord.current.delayPerItem)
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: delayPerItemLabel.rightAnchor, constant: 12).isActive = true
            label.centerYAnchor.constraint(equalTo: delayPerItemLabel.centerYAnchor).isActive = true
            label.rightAnchor.constraint(lessThanOrEqualTo: startView.rightAnchor, constant: -30).isActive = true
            
            return label
        }()
        
        delayPerItemSlider = {
            let slider = UISlider()
            slider.isContinuous = true
            slider.minimumValue = 0.1
            slider.maximumValue = 5.0
            slider.value = Float(PlayerRecord.current.delayPerItem)
            slider.maximumTrackTintColor = AppColors.disabled
            slider.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(slider)
            
            slider.topAnchor.constraint(equalTo: delayPerItemLabel.bottomAnchor, constant: 8).isActive = true
            slider.leftAnchor.constraint(equalTo: welcomeMessage.leftAnchor).isActive = true
            slider.rightAnchor.constraint(equalTo: welcomeMessage.rightAnchor).isActive = true
            
            slider.addTarget(self, action: #selector(delayChanged(_:)), for: .valueChanged)
            
            return slider
        }()
        
        delayPerItemPrompt = {
            let label = UILabel()
            label.text = "The number of seconds you would like to see and memorize each item."
            label.numberOfLines = 5
            label.font = .systemFont(ofSize: 13)
            label.textColor = AppColors.value
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: delayPerItemLabel.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: welcomeMessage.rightAnchor).isActive = true
            label.topAnchor.constraint(equalTo: delayPerItemSlider.bottomAnchor, constant: 8).isActive = true
            
            return label
        }()
        
        testType = {
            let seg = UISegmentedControl(items: ["Digits", "Letters", "Both"])
            seg.selectedSegmentIndex = PlayerRecord.current.memoryTestType
            seg.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(seg)
            
            seg.topAnchor.constraint(equalTo: delayPerItemPrompt.bottomAnchor, constant: 18).isActive = true
            seg.leftAnchor.constraint(equalTo: welcomeMessage.leftAnchor).isActive = true
            seg.rightAnchor.constraint(equalTo: welcomeMessage.rightAnchor).isActive = true
            
            seg.addTarget(self, action: #selector(testTypeChanged(_:)), for: .valueChanged)
            
            return seg
        }()
        
        beginButton = {
            let button = UIButton(type: .system)
            button.setTitle("Begin Test", for: .normal)
            button.layer.cornerRadius = 24
            button.layer.borderColor = AppColors.memory.cgColor
            button.layer.borderWidth = 1
            button.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(button)
            
            button.topAnchor.constraint(equalTo: testType.bottomAnchor, constant: 28).isActive = true
            button.widthAnchor.constraint(equalToConstant: 220).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.centerXAnchor.constraint(equalTo: startView.centerXAnchor).isActive = true
            button.leftAnchor.constraint(greaterThanOrEqualTo: startView.leftAnchor).isActive = true
            button.rightAnchor.constraint(lessThanOrEqualTo: startView.rightAnchor).isActive = true
            
            button.addTarget(self, action: #selector(beginTest(_:)), for: .touchUpInside)
            
            return button
        }()
    }

    private func setupCountdownView() {
        
        countdownTitle = {
            let label = UILabel()
            label.text = "The test is about to begin!"
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 19, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            countdownView.addSubview(label)
            
            label.topAnchor.constraint(equalTo: countdownView.topAnchor, constant: 30).isActive = true
            label.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor).isActive = true
            
            return label
        }()
        
        countdownSubtitle = {
            let label = UILabel()
            label.text = "Difficulty: \(PlayerRecord.current.memoryItemCount) items, \(PlayerRecord.current.delayPerItem)s per item"
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
            countdownView.addSubview(label)
            
            label.topAnchor.constraint(equalTo: countdownTitle.bottomAnchor, constant: 10).isActive = true
            label.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor).isActive = true
            
            return label
        }()
        
        countdownDigit = {
            let label = UILabel()
            label.text = "3"
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 120)
            label.translatesAutoresizingMaskIntoConstraints = false
            countdownView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: countdownView.centerYAnchor, constant: -10).isActive = true
            
            return label
        }()
        
        countdownCaption = {
            let label = UILabel()
            label.text = "Get ready..."
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            countdownView.addSubview(label)
            
            label.topAnchor.constraint(equalTo: countdownDigit.bottomAnchor, constant: 50).isActive = true
            label.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor).isActive = true
            
            return label
        }()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = AppColors.memory
    }
}

// MARK: - Handles events for start view
extension MemoryChallenge {
    
    @objc private func numberOfItemsChanged(_ sender: UISlider) {
        let newValue = Int(round(sender.value))
        numberOfItems.text = newValue.description
        PlayerRecord.current.memoryItemCount = newValue
    }
    
    @objc private func delayChanged(_ sender: UISlider) {
        let newValue = round(sender.value * 10) / 10
        delayPerItem.text = String(format: "%.1f", newValue)
        PlayerRecord.current.delayPerItem = Double(newValue)
    }
    
    @objc private func testTypeChanged(_ sender: UISegmentedControl) {
        UISelectionFeedbackGenerator().selectionChanged()
        PlayerRecord.current.memoryTestType = sender.selectedSegmentIndex
    }
    
    @objc private func beginTest(_ sender: UIButton) {
        let timer = Timer(timeInterval: 1, repeats: true) { timer in
            if self.countdownFrom > 0 {
                self.countdownFrom -= 1
                self.countdownDigit.text = self.countdownFrom.description
            } else {
                timer.invalidate()
            }
        }
        RunLoop.main.add(timer, forMode: .default)
        countdownTimer = timer
        
        startView.isHidden = true
        countdownView.isHidden = false
    }
}
