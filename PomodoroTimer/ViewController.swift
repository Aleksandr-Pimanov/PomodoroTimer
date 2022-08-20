//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Aleksandr Pimanov on 19.08.2022.
//

import UIKit

class ViewController: UIViewController {

    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.boldSystemFont(ofSize: 85)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var timer = Timer()
    var durationTimer = 10
    let shapeLayer = CAShapeLayer()
    let animationShapeLayer = CAShapeLayer()
    var isWorkTime = true
    var isStarted = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureStackView()
        addButtonAndLabelToStackView()
        drawMainCircul()
        drawAnimationCircul()
        setConstraints()
        
        playPauseButton.addTarget(self, action: #selector(playButton), for: .touchUpInside)
    }
    
    @objc func playButton() {
        if isStarted {
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
            
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            resumeAnimation()
            isStarted = false
        } else {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            timer.invalidate()
            pauseAnimation()
            isStarted = true
        }
    }
    
    @objc func timerAction() {
        if durationTimer <= 0 {
            animationShapeLayer.strokeColor = UIColor.systemGreen.cgColor
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            timerLabel.textColor = .systemGreen
            timer.invalidate()
            durationTimer = 5
            timerLabel.text = "\(durationTimer)"
        }
        
        else {
        durationTimer -= 1
        timerLabel.text = "\(durationTimer)"
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
        basicAnimation.speed = 0.8
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
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
}
 
extension ViewController {
    
    private func setConstraints() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

