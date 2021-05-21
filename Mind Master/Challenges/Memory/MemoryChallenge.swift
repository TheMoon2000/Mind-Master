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
    
    let MAX_ITEMS = 30
    let MIN_ITEMS = 4
    
    // MARK: Start screen UI elements
    
    private var startView: UIView!
    private var welcomeMessage: UILabel!
    private var numberOfItemsLabel: UILabel!
    private var numberOfItems: UILabel!
    private var numberOfItemsSlider: UISlider!
    private var numberOfItemsSliderTrack: UIView!
    private var thumbWidth: CGFloat = 27
    private var numberOfItemsPrompt: UILabel!
    private var delayPerItemLabel: UILabel!
    private var delayPerItem: UILabel!
    private var delayPerItemSlider: UISlider!
    private var delayPerItemPrompt: UILabel!
    private var testTypePrompt: UILabel!
    private var testType: UIButton!
    private var beginButton: UIButton!
    
    
    // MARK: Countdown related UI elements
    
    private var countdownView: UIView!
    private var countdownTitle: UILabel!
    private var countdownSubtitle: UILabel!
    private var countdownDigit: UILabel!
    private var countdownCaption: UILabel!
    private var countdownFrom = 3
    private var countdownTimer: Timer?
    
    
    // MARK: Color-related recall tasks
    
    /// The parent view containing all other UI elements for the memorization phase.
    private var memorizationDisplayView: UIView!
    
    /// The title label that is shown during the memorization phase.
    private var displayTitle: UILabel!
    
    /// The subtitle label that is shown during the memorization phase.
    private var displaySubtitle: UILabel!
    
    /// The digit which is shown to the user during the memorization phase.
    private var displayedDigit: UILabel!
    
    /// The view which is shown to the user during the memorization phase.
    private var displayedVisual: UIView!
    
    /// The circle whose size the user is supposed to memorize in the “size” task.
    private var circle: CircleView!
    
    /// The bar indicating the time remaining for the current item to memorize.
    private var displayTimeRemaining: UIProgressView!
    
    /// A descriptive text describing the user's progress during the memorization phase.
    private var displayProgressLabel: UILabel!
    
    /// The bar indicating the user's progress during the memorization phase.
    private var displayProgress: UIProgressView!
    
    
    /// The list of correct answers.
    private(set) var recallList = [Any]()
    
    /// The indices of the correct answers (0 = top left, 1 = top right, 2 = bottom left, 3 = bottom right).
    private(set) var correctIndices = [Int]()
    
    
    // MARK: Recall phase UI elements
    
    private var recallView: UIView!
    private var recallTitle: UILabel!
    private var recallSubtitle: UILabel!
    private var recallIndexLabel: UILabel!
    
    /// A transparent container view containing the `recallChoices`.
    private var recallItemsContainer: UIView!
    
    /// The 4 buttons which the user can press during recall phase.
    private var recallChoices = [UIButton]()
    
    /// Recall circles centered at each of the 4 recall chocie buttons.
    private var recallCircles = [CircleView]()
    
    private var completionLabel: UILabel!
    private var completionProgress: UIProgressView!
    private var recallBeginTime = Date()
    
    /// The four choices that were displayed to the user for each question.
    private(set) var recallOptions = [[Any]]()
    
    /// The indices that the user selected (0 = top left, 1 = top right, 2 = bottom left, 3 = bottom right).
    private(set) var userIndices = [Int]()
    
    
    private var resultView: UIView!
    private var resultTitle: UILabel!
    private var resultMessage: UILabel!
    private var scorePrompt: UILabel!
    private(set) var score: UILabel!
    private var recallScoreCaption: UILabel!
    private var returnToMenu: UIButton!
    private var viewAnswersButton: UIButton!
    
    let TEST_NAMES = ["Digits", "Letters", "Digits and Letters", "Colors", "Monochrome", "2D Size"]
    let DIGITS = (0...9).map { String($0) }
    let LETTERS = (65...90).map { String(UnicodeScalar($0)!) }
    let BOTH = Set(48...57).union(65...90).map { String(UnicodeScalar($0)) }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK - UI setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Short-term Memorization"
        view.backgroundColor = AppColors.background
        
        view.tintColor = AppColors.memory

        startView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
            
            v.widthAnchor.constraint(lessThanOrEqualToConstant: 600).isActive = true
            v.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            v.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
            v.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
            
            v.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).withPriority(.defaultHigh).isActive = true
            
            v.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).withPriority(.defaultHigh).isActive = true
            
            v.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
            v.heightAnchor.constraint(lessThanOrEqualToConstant: 1000).isActive = true
            
            v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).withPriority(.defaultHigh).isActive = true
            
            v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).withPriority(.defaultHigh).isActive = true
            
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
        
        func makeBlankView() -> UIView {
            let v = UIView()
            v.isHidden = true
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
            
            v.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            v.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            return v
        }
        
        memorizationDisplayView = makeBlankView()
        recallView = makeBlankView()
        resultView = {
            let v = UIView()
            v.isHidden = true
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
            
            v.widthAnchor.constraint(lessThanOrEqualToConstant: 600).isActive = true
            v.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            v.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
            v.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
            
            v.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).withPriority(.defaultHigh).isActive = true
            
            v.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).withPriority(.defaultHigh).isActive = true
            
            v.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
            v.heightAnchor.constraint(lessThanOrEqualToConstant: 1000).isActive = true
            
            v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).withPriority(.defaultHigh).isActive = true
            
            v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).withPriority(.defaultHigh).isActive = true
            
            return v
        }()
        
        setupStartView()
        setupCountdownView()
        setupDigitDisplayView()
        setupRecallView()
        setupResultView()
    }
    
    private func setupStartView() {
        
        welcomeMessage = {
            let label = UILabel()
            label.attributedText = "This test measures your ability to memorize a set of items in limited time. You will be scored based on the number of items, delay per item and your accuracy of recall.".styled(with: .textStyle)
            label.textAlignment = .center
            label.numberOfLines = 10
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: startView.leftAnchor, constant: 25).isActive = true
            label.rightAnchor.constraint(equalTo: startView.rightAnchor, constant: -25).isActive = true
            label.topAnchor.constraint(equalTo: startView.topAnchor, constant: 20).isActive = true
            
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
            slider.minimumValue = Float(MIN_ITEMS)
            slider.maximumValue = Float(MAX_ITEMS)
            slider.value = Float(PlayerRecord.current.memoryItemCount)
            slider.maximumTrackTintColor = .clear
            slider.minimumTrackTintColor = .clear
            slider.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(slider)
            
            slider.layoutIfNeeded()
            
            slider.topAnchor.constraint(equalTo: numberOfItemsLabel.bottomAnchor, constant: 8).isActive = true
            slider.leftAnchor.constraint(equalTo: welcomeMessage.leftAnchor).isActive = true
            slider.rightAnchor.constraint(equalTo: welcomeMessage.rightAnchor).isActive = true
            
            slider.addTarget(self, action: #selector(numberOfItemsChanged(_:)), for: .valueChanged)
            
            return slider
        }()
        
        numberOfItemsSliderTrack = {
            let ticks = UIView()
            ticks.translatesAutoresizingMaskIntoConstraints = false
            startView.insertSubview(ticks, belowSubview: numberOfItemsSlider)
            ticks.leftAnchor.constraint(equalTo: numberOfItemsSlider.leftAnchor).isActive = true
            ticks.rightAnchor.constraint(equalTo: numberOfItemsSlider.rightAnchor).isActive = true
            ticks.topAnchor.constraint(equalTo: numberOfItemsSlider.topAnchor).isActive = true
            ticks.bottomAnchor.constraint(equalTo: numberOfItemsSlider.bottomAnchor).isActive = true
            
            let segmentCount = CGFloat(MAX_ITEMS - MIN_ITEMS)
            /*
            thumbWidth = numberOfItemsSlider.thumbRect(
                forBounds: numberOfItemsSlider.bounds,
                trackRect: numberOfItemsSlider.trackRect(forBounds: numberOfItemsSlider.bounds), value: 0).width
            */
 
            let track = UIView()
            track.backgroundColor = AppColors.line
            track.translatesAutoresizingMaskIntoConstraints = false
            ticks.addSubview(track)
            
            track.heightAnchor.constraint(equalToConstant: 2).isActive = true
            track.leftAnchor.constraint(equalTo: numberOfItemsSlider.leftAnchor).isActive = true
            track.rightAnchor.constraint(equalTo: numberOfItemsSlider.rightAnchor).isActive = true
            track.centerYAnchor.constraint(equalTo: numberOfItemsSlider.centerYAnchor).isActive = true
            
            // Ticks
            
            func makeTickmark() -> UIView {
                let tick = UIView()
                tick.backgroundColor = track.backgroundColor
                tick.translatesAutoresizingMaskIntoConstraints = false
                ticks.addSubview(tick)
                
                tick.widthAnchor.constraint(equalToConstant: 2).isActive = true
                tick.heightAnchor.constraint(equalToConstant: 12).isActive = true
                tick.centerYAnchor.constraint(equalTo: numberOfItemsSlider.centerYAnchor).isActive = true
                
                return tick
            }
            
            for i in 0...(MAX_ITEMS - MIN_ITEMS) {
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
            slider.maximumTrackTintColor = AppColors.line
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
        
        testTypePrompt = {
            let label = UILabel()
            label.text = "Test category:"
            label.textColor = AppColors.value
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: delayPerItemPrompt.leftAnchor).isActive = true
            label.topAnchor.constraint(equalTo: delayPerItemPrompt.bottomAnchor, constant: 15).isActive = true
            
            return label
        }()
        
        testType = {
            let button = UIButton(type: .system)
            button.setTitle(TEST_NAMES[PlayerRecord.current.memoryTestType.rawValue], for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.tintColor = AppColors.emphasis
            button.titleLabel?.textAlignment = .right
            button.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(button)
            
            button.titleLabel?.rightAnchor.constraint(equalTo: delayPerItemPrompt.rightAnchor).isActive = true
            button.titleLabel?.centerYAnchor.constraint(equalTo: testTypePrompt.centerYAnchor).isActive = true
            
            button.addTarget(self, action: #selector(testTypeChanged(_:)), for: .touchUpInside)
            
            return button
        }()
        
        beginButton = {
            let button = UIButton(type: .system)
            button.setTitle("Begin Test", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
            button.layer.cornerRadius = 24
            button.layer.borderColor = AppColors.memory.cgColor
            button.layer.borderWidth = 1
            button.translatesAutoresizingMaskIntoConstraints = false
            startView.addSubview(button)
            
            button.topAnchor.constraint(greaterThanOrEqualTo: testTypePrompt.bottomAnchor, constant: 10).isActive = true
            
            button.bottomAnchor.constraint(equalTo: startView.bottomAnchor, constant: -10).withPriority(.defaultHigh).isActive = true
            
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
    
    private func setupDigitDisplayView() {
        
        displayTitle = {
            let label = UILabel()
            label.text = "Test in Progress!"
            label.textColor = AppColors.label
            label.font = .systemFont(ofSize: 18, weight: .semibold)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            memorizationDisplayView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: memorizationDisplayView.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: memorizationDisplayView.topAnchor, constant: 55).isActive = true
            
            return label
        }()
        
        displaySubtitle = {
            let label = UILabel()
            label.text = "Try to remember everything you see..."
            label.textColor = AppColors.label
            label.numberOfLines = 3
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            memorizationDisplayView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: memorizationDisplayView.leftAnchor, constant: 30).isActive = true
            label.rightAnchor.constraint(equalTo: memorizationDisplayView.rightAnchor, constant: -30).isActive = true
            label.topAnchor.constraint(equalTo: displayTitle.bottomAnchor, constant: 10).isActive = true
            
            return label
        }()
        
        displayedDigit = {
            let digit = UILabel()
            digit.text = "0"
            digit.isHidden = true
            digit.font = .systemFont(ofSize: 120)
            digit.textAlignment = .center
            digit.translatesAutoresizingMaskIntoConstraints = false
            memorizationDisplayView.addSubview(digit)
            
            digit.centerXAnchor.constraint(equalTo: memorizationDisplayView.centerXAnchor).isActive = true
            digit.centerYAnchor.constraint(equalTo: memorizationDisplayView.centerYAnchor, constant: -20).isActive = true
            
            return digit
        }()
        
        displayedVisual = {
            let v = UIView()
            v.layer.borderColor = AppColors.line.cgColor
            v.layer.borderWidth = 1
            v.layer.cornerRadius = 5
            v.isHidden = true
            v.translatesAutoresizingMaskIntoConstraints = false
            memorizationDisplayView.addSubview(v)
            
            v.centerYAnchor.constraint(equalTo: displayedDigit.centerYAnchor).isActive = true
            v.widthAnchor.constraint(equalTo: v.heightAnchor).isActive = true
            v.centerXAnchor.constraint(equalTo: memorizationDisplayView.centerXAnchor).isActive = true
            v.heightAnchor.constraint(greaterThanOrEqualTo: displayedDigit.heightAnchor).isActive = true
            v.leftAnchor.constraint(greaterThanOrEqualTo: memorizationDisplayView.leftAnchor, constant: 80).isActive = true
            v.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
            let width = v.widthAnchor.constraint(equalToConstant: 400)
            width.priority = .defaultLow
            width.isActive = true
            
            return v
        }()
        
        circle = {
            let v = CircleView()
            v.translatesAutoresizingMaskIntoConstraints = false
            memorizationDisplayView.addSubview(v)
            
            v.centerXAnchor.constraint(equalTo: displayedVisual.centerXAnchor).isActive = true
            v.centerYAnchor.constraint(equalTo: displayedVisual.centerYAnchor).isActive = true
            
            return v
        }()
        
        displayTimeRemaining = {
            let bar = UIProgressView()
            bar.trackTintColor = AppColors.line
            bar.progressTintColor = AppColors.lightControl
            bar.translatesAutoresizingMaskIntoConstraints = false
            memorizationDisplayView.addSubview(bar)
            
            bar.topAnchor.constraint(equalTo: displayedVisual.bottomAnchor, constant: 40).isActive = true
            bar.widthAnchor.constraint(equalToConstant: 200).isActive = true
            bar.centerXAnchor.constraint(equalTo: memorizationDisplayView.centerXAnchor).isActive = true
            
            return bar
        }()
        
        displayProgress = {
            let bar = UIProgressView()
            bar.trackTintColor = AppColors.line
            bar.progressTintColor = AppColors.memory
            bar.translatesAutoresizingMaskIntoConstraints = false
            memorizationDisplayView.addSubview(bar)
            
            bar.widthAnchor.constraint(equalToConstant: 210).isActive = true
            bar.centerXAnchor.constraint(equalTo: memorizationDisplayView.centerXAnchor).isActive = true
            bar.bottomAnchor.constraint(equalTo: memorizationDisplayView.bottomAnchor, constant: -32).isActive = true
            
            return bar
        }()
        
        displayProgressLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 15)
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            memorizationDisplayView.addSubview(label)
            
            label.bottomAnchor.constraint(equalTo: displayProgress.topAnchor, constant: -12).isActive = true
            label.centerXAnchor.constraint(equalTo: memorizationDisplayView.centerXAnchor).isActive = true
            label.topAnchor.constraint(greaterThanOrEqualTo: displayTimeRemaining.bottomAnchor, constant: 20).isActive = true
            
            return label
        }()
    }
    
    private func setupRecallView() {
        
        recallTitle = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .medium)
            label.text = "Recall Section"
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            recallView.addSubview(label)
            
            let t = label.topAnchor.constraint(equalTo: recallView.topAnchor, constant: 50)
            t.priority = .defaultHigh
            t.isActive = true
            
            label.topAnchor.constraint(greaterThanOrEqualTo: recallView.topAnchor, constant: 30).isActive = true
            label.centerXAnchor.constraint(equalTo: recallView.centerXAnchor).isActive = true
            
            return label
        }()
        
        recallSubtitle = {
            let label = UILabel()
            label.text = "Recall the items you have seen in order. There is no going back."
            label.numberOfLines = 3
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14)
            label.textColor = AppColors.value
            label.translatesAutoresizingMaskIntoConstraints = false
            recallView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: recallView.leftAnchor, constant: 50).isActive = true
            label.rightAnchor.constraint(equalTo: recallView.rightAnchor, constant: -50).isActive = true
            label.topAnchor.constraint(equalTo: recallTitle.bottomAnchor, constant: 12).isActive = true
            
            return label
        }()
        
        completionProgress = {
            let bar = UIProgressView()
            bar.trackTintColor = AppColors.line
            bar.progressTintColor = AppColors.memory
            bar.translatesAutoresizingMaskIntoConstraints = false
            recallView.addSubview(bar)
            
            bar.centerXAnchor.constraint(equalTo: recallView.centerXAnchor).isActive = true
            bar.widthAnchor.constraint(lessThanOrEqualToConstant: 450).isActive = true
            bar.bottomAnchor.constraint(equalTo: recallView.bottomAnchor, constant: -30).isActive = true
            
            let w = bar.leftAnchor.constraint(equalTo: recallView.leftAnchor, constant: 60)
            w.priority = .defaultHigh
            w.isActive = true
            
            return bar
        }()
        
        completionLabel = {
            let label = UILabel()
            label.text = "Completion:"
            label.textColor = AppColors.label
            label.font = .systemFont(ofSize: 13)
            label.translatesAutoresizingMaskIntoConstraints = false
            recallView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: completionProgress.leftAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: completionProgress.topAnchor, constant: -6).isActive = true
            
            return label
        }()
        
        recallItemsContainer = {
            let v = UIView()
            v.layer.borderWidth = 1
            v.layer.borderColor = AppColors.line.cgColor
            v.layer.cornerRadius = 5
            v.clipsToBounds = true
            v.translatesAutoresizingMaskIntoConstraints = false
            recallView.addSubview(v)
            
            v.widthAnchor.constraint(equalTo: v.heightAnchor).isActive = true
            v.centerXAnchor.constraint(equalTo: recallView.centerXAnchor).isActive = true
            v.leftAnchor.constraint(greaterThanOrEqualTo: recallView.leftAnchor, constant: 55).isActive = true
            v.widthAnchor.constraint(lessThanOrEqualToConstant: 520).isActive = true
            v.bottomAnchor.constraint(lessThanOrEqualTo: completionLabel.topAnchor, constant: -20).isActive = true
            
            let centerY = v.centerYAnchor.constraint(equalTo: recallView.centerYAnchor, constant: 40)
            centerY.priority = .defaultHigh
            centerY.isActive = true
            
            let l = v.leftAnchor.constraint(equalTo: recallView.leftAnchor, constant: 55)
            l.priority = .defaultHigh
            l.isActive = true
            
            return v
        }()
        
        // Configure the 4 choice buttons during answer phase.
        for _ in 0..<4 {
            let choice = UIButton(type: .system)
            choice.titleLabel?.font = .systemFont(ofSize: 24)
            choice.translatesAutoresizingMaskIntoConstraints = false
            recallItemsContainer.addSubview(choice)
            recallChoices.append(choice)
            
            choice.widthAnchor.constraint(equalTo: recallItemsContainer.widthAnchor, multiplier: 0.5).isActive = true
            choice.heightAnchor.constraint(equalTo: choice.widthAnchor).isActive = true
            
            choice.addTarget(self, action: #selector(submitRecallResponse(_:)), for: .touchUpInside)
            
            // Circle
            let circle = CircleView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            recallItemsContainer.addSubview(circle)
            recallCircles.append(circle)
            
            circle.centerXAnchor.constraint(equalTo: choice.centerXAnchor).isActive = true
            circle.centerYAnchor.constraint(equalTo: choice.centerYAnchor).isActive = true
        }
        
        recallChoices[0].leftAnchor.constraint(equalTo: recallItemsContainer.leftAnchor).isActive = true
        recallChoices[0].topAnchor.constraint(equalTo: recallItemsContainer.topAnchor).isActive = true
        
        recallChoices[1].topAnchor.constraint(equalTo: recallItemsContainer.topAnchor).isActive = true
        recallChoices[1].rightAnchor.constraint(equalTo: recallItemsContainer.rightAnchor).isActive = true
        
        recallChoices[2].leftAnchor.constraint(equalTo: recallItemsContainer.leftAnchor).isActive = true
        recallChoices[2].bottomAnchor.constraint(equalTo: recallItemsContainer.bottomAnchor).isActive = true
        
        recallChoices[3].rightAnchor.constraint(equalTo: recallItemsContainer.rightAnchor).isActive = true
        recallChoices[3].bottomAnchor.constraint(equalTo: recallItemsContainer.bottomAnchor).isActive = true
        
        recallIndexLabel = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.text = "REPLACE ME"
            label.translatesAutoresizingMaskIntoConstraints = false
            recallView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: recallView.centerXAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: recallItemsContainer.topAnchor, constant: -20).isActive = true
            label.topAnchor.constraint(greaterThanOrEqualTo: recallSubtitle.bottomAnchor, constant: 20).isActive = true
            
            return label
        }()
        
        let _: UIView = {
            let line = UIView()
            line.backgroundColor = AppColors.line
            line.translatesAutoresizingMaskIntoConstraints = false
            recallItemsContainer.addSubview(line)
            
            line.widthAnchor.constraint(equalToConstant: 1).isActive = true
            line.topAnchor.constraint(equalTo: recallItemsContainer.topAnchor).isActive = true
            line.bottomAnchor.constraint(equalTo: recallItemsContainer.bottomAnchor).isActive = true
            line.centerXAnchor.constraint(equalTo: recallItemsContainer.centerXAnchor).isActive = true
            
            return line
        }()
        
        let _: UIView = {
            let line = UIView()
            line.backgroundColor = AppColors.line
            line.translatesAutoresizingMaskIntoConstraints = false
            recallItemsContainer.addSubview(line)
            
            line.heightAnchor.constraint(equalToConstant: 1).isActive = true
            line.leftAnchor.constraint(equalTo: recallItemsContainer.leftAnchor).isActive = true
            line.rightAnchor.constraint(equalTo: recallItemsContainer.rightAnchor).isActive = true
            line.centerYAnchor.constraint(equalTo: recallItemsContainer.centerYAnchor).isActive = true
            
            return line
        }()
    }
    
    private func setupResultView() {
        
        score = {
            let label = UILabel()
            label.textColor = AppColors.memory
            label.font = .systemFont(ofSize: 60)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: resultView.centerYAnchor).isActive = true
            
            return label
        }()
        
        scorePrompt = {
            let label = UILabel()
            label.text = "Your score:"
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: score.topAnchor, constant: -12).isActive = true
            
            return label
        }()
        
        resultTitle = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 24, weight: .medium)
            label.textColor = AppColors.label
            label.textAlignment = .center
            label.numberOfLines = 3
            label.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: resultView.leftAnchor, constant: 40).isActive = true
            label.rightAnchor.constraint(equalTo: resultView.rightAnchor, constant: -40).isActive = true
            label.topAnchor.constraint(greaterThanOrEqualTo: resultView.topAnchor, constant: 15).isActive = true
            
            return label
        }()
        
        resultMessage = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 15)
            label.textColor = AppColors.value
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: resultTitle.bottomAnchor, constant: 10).isActive = true
            let b = label.bottomAnchor.constraint(equalTo: scorePrompt.topAnchor, constant: -85)
            b.priority = .defaultHigh
            b.isActive = true
            label.bottomAnchor.constraint(lessThanOrEqualTo: scorePrompt.topAnchor, constant: -15).isActive = true
            
            return label
        }()
        
        recallScoreCaption = {
            let label = UILabel()
            label.textColor = AppColors.emphasis
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            let h = label.topAnchor.constraint(equalTo: score.bottomAnchor, constant: 25)
            h.priority = .defaultHigh
            h.isActive = true
            label.topAnchor.constraint(greaterThanOrEqualTo: score.bottomAnchor, constant: 5).isActive = true
            
            return label
        }()
        
        returnToMenu = {
            let button = UIButton(type: .system)
            button.setTitle("Return to Menu", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17)
            button.layer.cornerRadius = 24
            button.layer.borderColor = AppColors.memory.cgColor
            button.layer.borderWidth = 1
            button.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(button)
            
            button.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.widthAnchor.constraint(equalToConstant: 220).isActive = true
            let t = button.topAnchor.constraint(equalTo: recallScoreCaption.bottomAnchor, constant: 60)
            t.priority = .defaultHigh
            t.isActive = true
            button.topAnchor.constraint(greaterThanOrEqualTo: recallScoreCaption.bottomAnchor, constant: 10).isActive = true
            
            button.bottomAnchor.constraint(lessThanOrEqualTo: resultView.bottomAnchor, constant: -20).isActive = true
            
            button.addTarget(self, action: #selector(backToMenu(_:)), for: .touchUpInside)
            
            return button
        }()
        
        viewAnswersButton = {
            let button = UIButton(type: .system)
            button.tintColor = AppColors.link
            button.setTitle("View Answers", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(button)
            
            button.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -20).isActive = true
            
            button.addTarget(self, action: #selector(viewAnswers), for: .touchUpInside)
            
            return button
        }()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = AppColors.memory
    }
}

// MARK: - Gameplay events
extension MemoryChallenge {
    
    @objc private func numberOfItemsChanged(_ slider: UISlider) {
        // let offset = thumbWidth / 2 / slider.frame.width * CGFloat(MAX_ITEMS - MIN_ITEMS)
        slider.value = round(slider.value)
        if Int(slider.value) != PlayerRecord.current.memoryItemCount {
            numberOfItems.text = Int(slider.value).description
            PlayerRecord.current.memoryItemCount = Int(slider.value)
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
    
    @objc private func delayChanged(_ sender: UISlider) {
        let newValue = round(sender.value * 10) / 10
        delayPerItem.text = String(format: "%.1f", newValue)
        PlayerRecord.current.delayPerItem = Double(newValue)
    }
    
    @objc private func testTypeChanged(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select test category", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        
        for i in 0..<TEST_NAMES.count {
            alert.addAction(.init(title: TEST_NAMES[i], style: .default, handler: { _ in
                PlayerRecord.current.memoryTestType = RecallType.init(rawValue: i) ?? .digits
                self.testType.setTitle(self.TEST_NAMES[i], for: .normal)
            }))
        }
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.permittedArrowDirections = .up
            popoverController.sourceView = sender
            let bottomPoint = sender.convert(CGPoint(x: sender.frame.midX, y: sender.frame.maxY), from: startView)
            popoverController.sourceRect = CGRect(origin: bottomPoint, size: CGSize(width: 1, height: 1))
        }
        
        present(alert, animated: true)
    }
    
    
    @objc private func beginTest(_ sender: UIButton) {
        countdownFrom = 3
        countdownDigit.text = "3"
        countdownSubtitle.text = "Difficulty: \(PlayerRecord.current.memoryItemCount) items, \(String(format: "%.1f", PlayerRecord.current.delayPerItem))s per item"
         
        let timer = Timer(timeInterval: 1, repeats: true) { timer in
            self.countdownFrom -= 1
            if self.countdownFrom > 0 {
                self.countdownDigit.text = self.countdownFrom.description
            } else {
                timer.invalidate()
                self.countdownView.isHidden = true
                self.memorizationDisplayView.isHidden = false
                self.generateNextItem()
            }
        }
        
        RunLoop.main.add(timer, forMode: .default)
        countdownTimer = timer
        
        startView.isHidden = true
        countdownView.isHidden = false
    }
    
    /// Generates an item for the user to memorize.
    private func generateNextItem() {
        
        /// The correct answer to the upcoming recall question.
        let nextItem: Any
        
        switch PlayerRecord.current.memoryTestType {
        case .digits:
            nextItem = DIGITS.randomElement()!
        case .letters:
            nextItem = LETTERS.randomElement()!
        case .alphaNumerical:
            nextItem = BOTH.randomElement()!
        case .colors:
            let r = CGFloat(Int.random(in: 0...245)) / 255
            let g = CGFloat(Int.random(in: 0...245)) / 255
            let b = CGFloat(Int.random(in: 0...245)) / 255
            
            nextItem = UIColor(red: r, green: g, blue: b, alpha: 1)
        case .monochrome:
            let grayScale = CGFloat.random(in: 0...1)
            nextItem = UIColor(white: grayScale, alpha: 1)
        case .size:
            nextItem = CGFloat.random(in: 0.1...0.95)
        }
        
        // Determine which of the 4 choice buttons will display the correct answer.
        correctIndices.append(Int.random(in: 0..<4))
        recallList.append(nextItem)
        
        // Display this item to the player.
        if let nextChar = nextItem as? String {
            displayedDigit.isHidden = false
            displayedVisual.isHidden = true
            displayedDigit.text = nextChar
        } else if let nextColor = nextItem as? UIColor {
            displayedVisual.isHidden = false
            displayedDigit.isHidden = true
            displayedVisual.backgroundColor = nextColor
        } else if let nextSize = nextItem as? CGFloat {
            displayedDigit.isHidden = true
            displayedVisual.isHidden = false
            displayedVisual.backgroundColor = nil
            circle.radius = nextSize * displayedVisual.frame.width / 2
        }
        
        displayProgressLabel.text = "Item \(recallList.count) of \(PlayerRecord.current.memoryItemCount)"
        displayProgress.setProgress(Float(recallList.count) / Float(PlayerRecord.current.memoryItemCount), animated: true)
                
        
        let beginDisplayTime = Date()
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            let elapsed = Date().timeIntervalSince(beginDisplayTime)
            self.displayTimeRemaining.progress = Float(elapsed / PlayerRecord.current.delayPerItem)
            if elapsed > PlayerRecord.current.delayPerItem {
                timer.invalidate()
                self.displayTimeRemaining.setProgress(0, animated: false)
                if self.recallList.count < PlayerRecord.current.memoryItemCount {
                    self.generateNextItem()
                } else {
                    self.memorizationDisplayView.isHidden = true
                    self.recallView.isHidden = false
                    self.completionProgress.progress = 0
                    self.displayRecallScreen()
                }
            }
        }
        
    }
    
    private func displayRecallScreen() {
        let recallIndex = Int(userIndices.count)
        if recallIndex == 0 {
            recallBeginTime = Date()
        }
        let recallItem = recallList[recallIndex]
        let correctIndex = correctIndices[recallIndex]
        recallIndexLabel.text = "Item \(recallIndex + 1) of \(recallList.count)"
        
        /// Consists of 4 answers that are presented to the user.
        var answerOptions = [Any]()
        
        if let recallColor = recallItem as? UIColor, PlayerRecord.current.memoryTestType == .colors {
            let components = recallColor.cgColor.components!
           
            UIView.animate(withDuration: 0.15) {
                self.recallChoices[correctIndex].backgroundColor = recallColor
            }
            var usedColors = Set<[Int]>()
            usedColors.insert([0, 0, 0])
            
            let granularity: CGFloat = 25
            let maxOffset = 4
            
            let rMinOffset = -min(Int(components[0] * 255 / granularity), maxOffset)
            let rMaxOffset = min(Int((1 - components[0]) * 255 / granularity), maxOffset)
            let gMinOffset = -min(Int(components[1] * 255 / granularity), maxOffset)
            let gMaxOffset = min(Int((1 - components[1]) * 255 / granularity), maxOffset)
            let bMinOffset = -min(Int(components[2] * 255 / granularity), maxOffset)
            let bMaxOffset = min(Int((1 - components[2]) * 255 / granularity), maxOffset)
            
            for index in 0..<recallChoices.count {
                if index == correctIndex {
                    answerOptions.append(recallColor)
                    continue
                }
                
                var offsetCombo = [0, 0, 0]
                while usedColors.contains(offsetCombo) {
                    let r = Int.random(in: rMinOffset...rMaxOffset)
                    let g = Int.random(in: gMinOffset...gMaxOffset)
                    let b = Int.random(in: bMinOffset...bMaxOffset)
                    offsetCombo = [r, g, b]
                }
                
                usedColors.insert(offsetCombo)
                
                let r = CGFloat(offsetCombo[0]) * granularity / 255 + components[0]
                let g = CGFloat(offsetCombo[1]) * granularity / 255 + components[1]
                let b = CGFloat(offsetCombo[2]) * granularity / 255 + components[2]
                
                let randomColor = UIColor(red: r, green: g, blue: b, alpha: 1)
                
                UIView.animate(withDuration: 0.15) {
                    self.recallChoices[index].backgroundColor = randomColor
                }
                answerOptions.append(randomColor)
            }
        } else if let recallGray = recallItem as? UIColor, PlayerRecord.current.memoryTestType == .monochrome {
            
            let grayComponent = recallGray.cgColor.components![0]
            
            UIView.animate(withDuration: 0.15) {
                self.recallChoices[correctIndex].backgroundColor = recallGray
            }
            
            let granularity: CGFloat = 25.0
            let cap = 8
            let minOffset = -min(Int(grayComponent * 255 / granularity), cap)
            let maxOffset = min(Int((1 - grayComponent) * 255 / granularity), cap)
            var possibilities = Set(minOffset...maxOffset)
            possibilities.remove(0)
            
            for index in 0..<recallChoices.count {
                if index == correctIndex {
                    answerOptions.append(recallGray)
                    continue
                }
                
                let randomGray = possibilities.randomElement()!
                possibilities.remove(randomGray)
                
                let randomColor = UIColor(white: CGFloat(randomGray) * granularity / 255 + grayComponent, alpha: 1)
                
                UIView.animate(withDuration: 0.15) {
                    self.recallChoices[index].backgroundColor = randomColor
                }
                
                answerOptions.append(randomColor)
            }
            
        } else if let recallLetter = recallItem as? String {
            
            self.recallChoices[correctIndex].setTitle(recallLetter, for: .normal)
            
            var possibilities = Set([DIGITS, LETTERS, BOTH][PlayerRecord.current.memoryTestType.rawValue])
            possibilities.remove(recallLetter)
            
            for i in 0..<recallChoices.count {
                if i == correctIndex {
                    answerOptions.append(recallLetter)
                    continue
                }
                let randomLetter = possibilities.randomElement()!
                possibilities.remove(randomLetter)
                answerOptions.append(randomLetter)
                UIView.performWithoutAnimation {
                    self.recallChoices[i].setTitle(randomLetter, for: .normal)
                }
            }
        } else if let recallSize = recallItem as? CGFloat {
            
            UIView.animate(withDuration: 0.15) {
                self.recallCircles[correctIndex].radius = recallSize * self.recallChoices[correctIndex].frame.width / 2
            }
            
            for i in 0..<recallChoices.count {
                if i == correctIndex {
                    answerOptions.append(recallSize)
                    continue
                }
                
                var randomSize: CGFloat = recallSize
                
                /// Make sure the wrong answers aren't too close to the true answer.
                while answerOptions.contains(where: { abs(randomSize - ($0 as! CGFloat)) < 0.09 }) ||
                abs(randomSize - recallSize) < 0.09 {
                    randomSize = CGFloat.random(in: 0.1...0.95)
                }
                
                answerOptions.append(randomSize)
                recallCircles[i].radius = randomSize * recallChoices[i].frame.width / 2
            }
        }
        
        recallOptions.append(answerOptions)
    }
    
    @objc private func submitButtonPressed(_ sender: UIButton) {
        if sender.backgroundColor == nil {
            sender.backgroundColor = AppColors.line
        }
    }
    
    @objc private func submitButtonLifted(_ sender: UIButton) {
        if sender.backgroundColor == AppColors.line {
            UIView.animate(withDuration: 0.15) {
                sender.backgroundColor = nil
            }
        }
    }
    
    @objc private func submitRecallResponse(_ sender: UIButton) {
        let userIndex = recallChoices.firstIndex(of: sender)!
        userIndices.append(userIndex)
        completionProgress.progress = Float(userIndices.count) / Float(recallList.count)
        
        if userIndices.count < recallList.count {
            displayRecallScreen()
        } else {
            recallView.isHidden = true
            resultView.isHidden = false
            
            var correctCount = 0
            for i in 0..<correctIndices.count {
                if correctIndices[i] == userIndices[i] {
                    correctCount += 1
                }
            }
            
            let correctPercentage = Double(correctCount) / Double(correctIndices.count)
            let rounded = Int(round(correctPercentage * 100))
            if correctPercentage == 1.0 {
                resultTitle.text = "Perfect! 100% Correct!"
                generateConfetti()
            } else if correctPercentage >= 0.9 {
                resultTitle.text = "Excellent! \(rounded)% Correct!"
            } else if correctPercentage >= 0.8 {
                resultTitle.text = "Good job! You got \(rounded)% correct."
            } else if correctPercentage >= 0.7 {
                resultTitle.text = "Satisfactory - You got \(rounded)% correct."
            } else {
                resultTitle.text = "Oops, you only got \(rounded)% correct."
            }
            
            let totalDuration = Date().timeIntervalSince(recallBeginTime)
            resultMessage.text = "Average speed: \(String(format: "%.2f", totalDuration / Double(recallList.count)))s / response"
            
            score.text = "\(correctCount)/\(correctIndices.count)"
            recallScoreCaption.text = "Recall type: \(TEST_NAMES[PlayerRecord.current.memoryTestType.rawValue])"
        }
    }
    
    @objc private func backToMenu(_ sender: UIButton) {
        recallList.removeAll()
        recallOptions.removeAll()
        userIndices.removeAll()
        correctIndices.removeAll()
        countdownTimer?.invalidate()
        completionProgress.progress = 0
        displayProgress.progress = 0
        countdownFrom = 3
        
        for i in 0..<recallChoices.count {
            recallChoices[i].backgroundColor = nil
            recallChoices[i].setTitle(nil, for: .normal)
            recallCircles[i].radius = 0
        }
        
        startView.isHidden = false
        resultView.isHidden = true
    }
    
    private func generateConfetti() {
        
        let particlesLayer = CAEmitterLayer()

        view.layer.addSublayer(particlesLayer)

        particlesLayer.backgroundColor = UIColor.clear.cgColor
        particlesLayer.emitterShape = .line
        particlesLayer.emitterPosition = CGPoint(x: view.frame.midX, y: view.safeAreaLayoutGuide.layoutFrame.minY + 15)
        particlesLayer.emitterSize = .init(width: resultView.frame.width, height: 1)


        let cell1 = CAEmitterCell()
        cell1.birthRate = 20.0
        cell1.lifetime = 6
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
    
    @objc private func viewAnswers() {
        let vc = MemoryUserAnswers(parent: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
