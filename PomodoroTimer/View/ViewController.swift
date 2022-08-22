//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Aleksandr Pimanov on 19.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let playImage = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
    let pauseImage = UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate)
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "60"
        var fontSize: CGFloat = 85.0
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var timer = Timer()
    var durationTime = 60
    let shapeLayer = CAShapeLayer()
    let animationShapeLayer = CAShapeLayer()
    var isWorkTime = false
    var isStarted = false
    var isPaused = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        timerLabel.text = timeString(time: TimeInterval(durationTime))
        configureStackView()
        addButtonAndLabelToStackView()
        drawMainCircul()
        drawAnimationCircul()
        setConstraints()
        
        playPauseButton.addTarget(self, action: #selector(playButton), for: .touchUpInside)
    }
    
    @objc func playButton() {
        if !isStarted {
            basicAnimation()
            playPauseButton.setImage(pauseImage, for: .normal)
            createTimer()
            isStarted = true
        } else if isPaused {
            playPauseButton.setImage(playImage, for: .normal)
            timer.invalidate()
            pauseAnimation()
            isPaused = false
        } else {
            createTimer()
            playPauseButton.setImage(pauseImage, for: .normal)
            resumeAnimation()
            isPaused = true
        }
    }
    
    @objc func timerAction() {
        durationTime -= 1
        timerLabel.text = timeString(time: TimeInterval(durationTime))
        
        if durationTime == 0, !isWorkTime {
            animationShapeLayer.strokeColor = UIColor.systemGreen.cgColor
            playPauseButton.setImage(playImage, for: .normal)
            playPauseButton.tintColor = .systemGreen
            timerLabel.textColor = .systemGreen
            timer.invalidate()
            durationTime = 25
            timerLabel.text = timeString(time: TimeInterval(durationTime))
            isStarted = false
            isWorkTime = true
        } else if durationTime == 0, isWorkTime {
            durationTime = 60
            timer.invalidate()
            animationShapeLayer.strokeColor = UIColor.systemRed.cgColor
            playPauseButton.setImage(playImage, for: .normal)
            playPauseButton.tintColor = .systemRed
            timerLabel.textColor = .systemRed
            isStarted = false
            isWorkTime = false
            timerLabel.text = timeString(time: TimeInterval(durationTime))
        }
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
    }
    
    private func addButtonAndLabelToStackView() {
        stackView.addArrangedSubview(timerLabel)
        stackView.addArrangedSubview(playPauseButton)
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    private func drawMainCircul() {
        let center = view.center
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi
        let path = UIBezierPath(arcCenter: center,
                                radius: 150,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 1
        shapeLayer.strokeColor = UIColor.systemGray6.cgColor
        
        view.layer.addSublayer(shapeLayer)
    }
    
    private func drawAnimationCircul() {
        let center = view.center
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi
        let path = UIBezierPath(arcCenter: center,
                                radius: 150,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        animationShapeLayer.path = path.cgPath
        animationShapeLayer.fillColor = UIColor.clear.cgColor
        animationShapeLayer.strokeColor = UIColor.systemPink.cgColor
        animationShapeLayer.lineWidth = 10
        animationShapeLayer.strokeEnd = 0
        animationShapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(animationShapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.speed = 8.0
        basicAnimation.duration = CFTimeInterval(durationTime)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        animationShapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    private func pauseAnimation() {
        let pausedTime = animationShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        animationShapeLayer.speed = 0
        animationShapeLayer.timeOffset = pausedTime
    }
    
    private func resumeAnimation() {
        let pausedTime = animationShapeLayer.timeOffset
        animationShapeLayer.speed = 1
        animationShapeLayer.timeOffset = 0
        animationShapeLayer.beginTime = 0
        let timeSincePause = animationShapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        animationShapeLayer.beginTime = timeSincePause
    }
    
    private func setConstraints() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
