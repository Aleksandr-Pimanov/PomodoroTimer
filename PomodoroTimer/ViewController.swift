//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Aleksandr Pimanov on 19.08.2022.
//

import UIKit

class ViewController: UIViewController {

    let workTimerLabel: UILabel = {
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
        button.setImage(UIImage(named: "pause"), for: .selected)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureStackView()
        addButtonAndLabelToStackView()
        drawCircul()
        animationCircular()
        setConstraints()
        
        playPauseButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        basicAnimation()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        durationTimer -= 1
        workTimerLabel.text = "\(durationTimer)"
        
        if durationTimer <= 0 {
            timer.invalidate()
        }
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
    }
    
    private func addButtonAndLabelToStackView() {
        stackView.addArrangedSubview(workTimerLabel)
        stackView.addArrangedSubview(playPauseButton)
    }
     
    private func drawCircul() {
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
        shapeLayer.strokeEnd = 0
        shapeLayer.strokeColor = UIColor.black.cgColor
                
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animationCircular() {
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
        animationShapeLayer.strokeColor = UIColor.systemPurple.cgColor
        animationShapeLayer.lineWidth = 10
        animationShapeLayer.strokeEnd = 1
        animationShapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(animationShapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        animationShapeLayer.add(basicAnimation, forKey: "basicAnimation")
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

