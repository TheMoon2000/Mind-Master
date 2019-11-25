//
//  GridChallenge.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/22.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class GridChallenge: UIViewController {
    
    private var sliderPrompt: UILabel!
    private var sliderValue: UILabel!
    private var slider: UISlider!
    private var sliderTrack: UIView!
    private var thumbWidth: CGFloat = 0
    
    private var grid: UIView!
    private var buttons = [UIButton]()
    private var beginButton: UIButton!
    private var leftPrompt: UILabel!
    private var rightPrompt: UILabel!
    private var progress: UIProgressView!
    private var countdownPlate: UIView!
    private var countdownDigit: UILabel!
    
    let MIN_ITERATIONS = 2
    let MAX_ITERATIONS = 30
    
    // Game variables
    var gameTimer: Timer?
    var startTime = Date.timeIntervalSinceReferenceDate
    var currentIterations = 0
    
    var currentValue: Float = Float(PlayerRecord.current.gridIterations) {
        didSet (oldValue) {
            if currentValue != oldValue {
                let xValue = Int(currentValue) * 5
                sliderValue.text = xValue.description
                PlayerRecord.current.gridIterations = xValue
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Grid Space"
        view.backgroundColor = AppColors.background
        
        navigationItem.rightBarButtonItem = .init(image: #imageLiteral(resourceName: "more"), style: .plain, target: self, action: #selector(menu))
        
        sliderPrompt = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.text = "Number of iterations:"
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
            label.text = String(PlayerRecord.current.gridIterations)
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
            slider.maximumValue = Float(MAX_ITERATIONS)
            slider.minimumValue = Float(MIN_ITERATIONS)
            slider.value = Float(PlayerRecord.current.gridIterations / 5)
            
            slider.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(slider)
            
            slider.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
            slider.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
            slider.topAnchor.constraint(equalTo: sliderPrompt.bottomAnchor, constant: 10).isActive = true
                
            slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
            
            return slider
        }()
        
        grid = {
            let grid = UIView()
            grid.alpha = DISABLED_ALPHA
            grid.isUserInteractionEnabled = false
            grid.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(grid)
            
            let l = grid.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50)
            l.priority = .defaultHigh
            l.isActive = true
            
            let r = grid.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50)
            r.priority = .defaultHigh
            r.isActive = true
            
            grid.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
            grid.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50).isActive = true
            grid.topAnchor.constraint(greaterThanOrEqualTo: slider.bottomAnchor, constant: 15).isActive = true
                        
            grid.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            grid.widthAnchor.constraint(equalTo: grid.heightAnchor, multiplier: 1.0).isActive = true
            
            let h = grid.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 10)
            h.priority = .defaultHigh
            h.isActive = true
            
            return grid
        }()
        
        for i in 0..<4 {
            let button = UIButton()
            button.layer.cornerRadius = 6
            button.backgroundColor = AppColors.disabled
            button.tintColor = AppColors.invertedLabel
            button.setTitle(String(i), for: .disabled)
            button.translatesAutoresizingMaskIntoConstraints = false
            grid.addSubview(button)
            
            button.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
            
            button.addTarget(self, action: #selector(tilePressed(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(tileReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
            button.addTarget(self, action: #selector(tileTapped(_:)), for: .touchUpInside)
            
            buttons.append(button)
        }
        
        buttons[0].leftAnchor.constraint(equalTo: grid.leftAnchor).isActive = true
        buttons[0].topAnchor.constraint(equalTo: grid.topAnchor).isActive = true
        buttons[0].rightAnchor.constraint(equalTo: grid.centerXAnchor, constant: -5).isActive = true
        
        buttons[1].rightAnchor.constraint(equalTo: grid.rightAnchor).isActive = true
        buttons[1].topAnchor.constraint(equalTo: grid.topAnchor).isActive = true
        buttons[1].widthAnchor.constraint(equalTo: buttons[0].widthAnchor).isActive = true
        
        buttons[2].leftAnchor.constraint(equalTo: grid.leftAnchor).isActive = true
        buttons[2].bottomAnchor.constraint(equalTo: grid.bottomAnchor).isActive = true
        buttons[2].widthAnchor.constraint(equalTo: buttons[0].widthAnchor).isActive = true
        
        buttons[3].rightAnchor.constraint(equalTo: grid.rightAnchor).isActive = true
        buttons[3].bottomAnchor.constraint(equalTo: grid.bottomAnchor).isActive = true
        buttons[3].widthAnchor.constraint(equalTo: buttons[0].widthAnchor).isActive = true
        
        beginButton = {
            let button = UIButton(type: .system)
            button.layer.borderWidth = 1
            button.layer.borderColor = AppColors.reaction.cgColor
            button.layer.cornerRadius = 25
            button.setTitle("Begin Challenge", for: .normal)
            button.tintColor = AppColors.reaction
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            button.topAnchor.constraint(greaterThanOrEqualTo: grid.bottomAnchor, constant: 20).isActive = true
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -28).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.widthAnchor.constraint(equalToConstant: 225).isActive = true
            
            button.addTarget(self, action: #selector(beginChallenge), for: .touchUpInside)
            
            return button
        }()
        
        countdownPlate = {
            let plate = UIView()
            plate.isHidden = true
            plate.backgroundColor = AppColors.card
            plate.layer.borderColor = UIColor.gray.cgColor
            plate.layer.cornerRadius = 45
            plate.layer.borderColor = AppColors.line.cgColor
            plate.layer.borderWidth = 1
            plate.applyMildShadow()
            plate.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(plate)
            
            plate.widthAnchor.constraint(equalToConstant: 90).isActive = true
            plate.heightAnchor.constraint(equalTo: plate.widthAnchor).isActive = true
            plate.centerXAnchor.constraint(equalTo: grid.centerXAnchor).isActive = true
            plate.centerYAnchor.constraint(equalTo: grid.centerYAnchor).isActive = true
            
            return plate
        }()
        
        countdownDigit = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 35, weight: .medium)
            label.textAlignment = .center
            label.textColor = AppColors.label
            label.translatesAutoresizingMaskIntoConstraints = false
            countdownPlate.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: countdownPlate.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: countdownPlate.centerYAnchor).isActive = true
            
            return label
        }()
        
        progress = {
            let bar = UIProgressView()
            bar.isHidden = true
            bar.progressTintColor = AppColors.reaction
            bar.trackTintColor = AppColors.reactionLight.withAlphaComponent(0.3)
            bar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bar)
            
            bar.leftAnchor.constraint(equalTo: grid.leftAnchor, constant: 20).isActive = true
            bar.rightAnchor.constraint(equalTo: grid.rightAnchor, constant: -20).isActive = true
            bar.bottomAnchor.constraint(equalTo: beginButton.bottomAnchor, constant: -10).isActive = true
            
            return bar
        }()
        
        leftPrompt = {
            let label = UILabel()
            label.isHidden = true
            label.textColor = AppColors.value
            label.textAlignment = .center
            label.numberOfLines = 5
            label.text = ""
            label.font = .systemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: progress.leftAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: progress.topAnchor, constant: -15).isActive = true
            
            return label
        }()
        
        rightPrompt = {
            let label = UILabel()
            label.isHidden = true
            label.textColor = AppColors.value
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            label.rightAnchor.constraint(equalTo: progress.rightAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: progress.topAnchor, constant: -15).isActive = true
            
            return label
        }()
        
        sliderTrack = {
            let ticks = UIView()
            ticks.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(ticks, belowSubview: slider)
            ticks.leftAnchor.constraint(equalTo: slider.leftAnchor).isActive = true
            ticks.rightAnchor.constraint(equalTo: slider.rightAnchor).isActive = true
            ticks.topAnchor.constraint(equalTo: slider.topAnchor).isActive = true
            ticks.bottomAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            
            let segmentCount = CGFloat(MAX_ITERATIONS - MIN_ITERATIONS)
            slider.layoutIfNeeded()
            thumbWidth = slider.thumbRect(
                forBounds: slider.bounds,
                trackRect: slider.trackRect(forBounds: slider.bounds), value: 0).width
            
            let track = UIView()
            track.backgroundColor = AppColors.line
            track.translatesAutoresizingMaskIntoConstraints = false
            ticks.addSubview(track)
            
            track.heightAnchor.constraint(equalToConstant: 2).isActive = true
            track.leftAnchor.constraint(equalTo: slider.leftAnchor/*,
                                        constant: thumbWidth / 2*/).isActive = true
            track.rightAnchor.constraint(equalTo: slider.rightAnchor/*,
                                         constant: -thumbWidth / 2*/).isActive = true
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
            
            for i in 0...(MAX_ITERATIONS - MIN_ITERATIONS) {
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
        
    // MARK - Implementation
    
    @objc private func sliderChanged() {
        
        // let halfThumb = thumbWidth / 2 / slider.frame.width * CGFloat(MAX_ITERATIONS - MIN_ITERATIONS)
        
        // Note: we need to recalculate the actual slider value as appeared to the user, because our custom track is narrower than the default track.
        let apparentSliderValue = slider.value // max(0, CGFloat(slider.value) - halfThumb) * slider.frame.width / (slider.frame.width - 2 * halfThumb)
                        
        slider.value = round(Float(apparentSliderValue))
        if slider.value != currentValue {
            currentValue = slider.value
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
    
    @objc private func beginChallenge() {
        countdownDigit.text = "3"
        self.slider.thumbTintColor = AppColors.reactionLight
        self.slider.isUserInteractionEnabled = false
        self.leftPrompt.text = ""
        self.rightPrompt.text = ""
        
        UIView.transition(with: view, duration: 0.2, options: .curveEaseInOut, animations: {
            self.sliderTrack.alpha = DISABLED_ALPHA
            self.countdownPlate.isHidden = false
            self.beginButton.setTitle("Get ready...", for: .normal)
            self.beginButton.isEnabled = false
            self.beginButton.layer.borderColor = AppColors.reactionLight.cgColor
        })
        
        var countdown = 3
        let timer = Timer(timeInterval: 1, repeats: true) { timer in
            if countdown == 1 {
                timer.invalidate()
                UIView.transition(with: self.view, duration: 0.3, options: .curveEaseOut, animations: {
                    self.grid.alpha = 1.0
                    self.leftPrompt.isHidden = false
                    self.rightPrompt.isHidden = false
                    self.beginButton.isHidden = true
                    self.progress.isHidden = false
                    self.countdownPlate.isHidden = true
                }, completion: { completion in
                    self.gameTimer = Timer(timeInterval: 0.01, repeats: true) { timer in
                        let elapsed = Date.timeIntervalSinceReferenceDate - self.startTime
                        self.leftPrompt.text = String(format: "%.2fs", elapsed)
                    }
                    self.grid.isUserInteractionEnabled = true
                    self.startTime = Date.timeIntervalSinceReferenceDate
                    self.currentIterations = 0
                    RunLoop.current.add(self.gameTimer!, forMode: .default)
                    self.gameIteration()
                })
            } else {
                countdown -= 1
                self.countdownDigit.text = String(countdown)
            }
        }
        RunLoop.current.add(timer, forMode: .default)
    }
    
    private func gameIteration() {
        if currentIterations >= PlayerRecord.current.gridIterations {
            handleGameCompletion(time: Date.timeIntervalSinceReferenceDate - self.startTime)
            return
        }
        
        rightPrompt.text = "\(currentIterations) / \(PlayerRecord.current.gridIterations)"
        progress.setProgress(Float(currentIterations) / Float(PlayerRecord.current.gridIterations), animated: true)
        
        currentIterations += 1
        
        let chosenIndex = Int.random(in: 0...3)
        for i in 0..<4 {
            UIView.animate(withDuration: 0.1) {
                self.buttons[i].backgroundColor = i == chosenIndex ? AppColors.reaction : AppColors.disabled
            }
        }
            
    }
    
    @objc private func tilePressed(_ sender: UIButton) {
        if sender.backgroundColor == AppColors.reaction {
            UIView.animate(withDuration: 0.05) {
                sender.backgroundColor = AppColors.reactionDark
            }
        }
    }
    
    @objc private func tileReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.backgroundColor = sender.backgroundColor == AppColors.reactionDark ? AppColors.reaction : AppColors.disabled
        }
    }
    
    @objc private func tileTapped(_ sender: UIButton) {
        if sender.backgroundColor == AppColors.reaction {
            UISelectionFeedbackGenerator().selectionChanged()
            gameIteration()
        } else {
            let alert = UIAlertController(title: "Game Over", message: "You pressed on the wrong tile!", preferredStyle: .alert)
            alert.addAction(.init(title: "Try Again", style: .cancel))
            present(alert, animated: true)
            handleGameCompletion()
        }
    }
    
    private func handleGameCompletion(time: Double? = nil) {
       
        gameTimer?.invalidate()
        gameTimer = nil
        self.slider.thumbTintColor = AppColors.reaction

        for button in buttons {
            button.backgroundColor = AppColors.disabled
        }
        
        beginButton.layer.borderColor = AppColors.reaction.cgColor
        grid.isUserInteractionEnabled = false
        slider.isUserInteractionEnabled = true
        
        UIView.transition(with: self.view, duration: 0.2, options: .curveEaseInOut, animations: {
            self.grid.alpha = DISABLED_ALPHA
            self.beginButton.isHidden = false
            self.beginButton.isEnabled = true
            self.beginButton.setTitle("Begin Challenge", for: .normal)
            self.sliderTrack.alpha = 1.0
            self.leftPrompt.isHidden = true
            self.rightPrompt.isHidden = true
            self.progress.isHidden = true
            self.progress.progress = 0
        })
        
        if let time = time {
            let previousBest = PlayerRecord.current.gridRecord[PlayerRecord.current.gridIterations]
            var message = ""
            if (previousBest ?? .infinity) > time {
                PlayerRecord.current.gridRecord[PlayerRecord.current.gridIterations] = time
                message = "\nThis is your highest score for \(PlayerRecord.current.gridIterations) iterations!"
            }
            let alert = UIAlertController(
                title: "Challenge Completed",
                message: String(format: "Duration: %.2fs\nAvg. time: %.2fs / iteration" + message, time, time / Double(PlayerRecord.current.gridIterations)),
                preferredStyle: .alert)
            alert.addAction(.init(title: "Close", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PlayerRecord.current.gridHelp {
            PlayerRecord.current.gridHelp = false
            help()
        }
    }
    
    @objc private func menu() {
        let alert = UIAlertController()
        alert.view.tintColor = AppColors.reaction
        alert.addAction(.init(title: "High Scores", style: .default, handler: { _ in
            let hs = GridHighScores(parent: self)
            self.navigationController?.pushViewController(hs, animated: true)
        }))
        alert.addAction(.init(title: "Help", style: .default, handler: { _ in
            self.help()
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    private func help() {
        let alert = UIAlertController(title: "Grid space challenge", message: "In every iteration, one of the four squares will turn green. Your goal is to tap that square as quickly as possible.", preferredStyle: .actionSheet)
        alert.addAction(.init(title: "OK", style: .cancel))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
