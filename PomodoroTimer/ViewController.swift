//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Aleksandr Pimanov on 19.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

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
    
    var timer = Timer()
    var durationTimer = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        containerView.frame = CGRect(x: view.frame.width/2 - 150, y: view.frame.height/2 - 150, width: 300, height: 300)
        view.addSubview(containerView)
        
        drawCircul()
        setConstraints()
        
        playPauseButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        durationTimer -= 1
        workTimerLabel.text = "\(durationTimer)"
        
        if durationTimer <= 0 {
            timer.invalidate()
        }
    }
     
    private func drawCircul() {
        let path = UIBezierPath(ovalIn: containerView.bounds)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.strokeColor = UIColor.black.cgColor
                
        containerView.layer.addSublayer(shapeLayer)
        
    }
}

extension ViewController {
    
    private func setConstraints() {
        containerView.addSubview(workTimerLabel)
        NSLayoutConstraint.activate([
            workTimerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            workTimerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            workTimerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50)
        ])
        
        containerView.addSubview(playPauseButton)
        NSLayoutConstraint.activate([
            playPauseButton.topAnchor.constraint(equalTo: workTimerLabel.bottomAnchor, constant: 50),
            playPauseButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 125),
            playPauseButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -125)
        ])
    }
}
