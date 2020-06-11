//
//  RunButton.swift
//  DrillTimers
//
//  Created by Yaroslav Tytarenko on 09.06.2020.
//  Copyright © 2020 Yaros H. All rights reserved.
//

import UIKit

protocol RunButtonDelegate: class {
    func runButtonDidTap()
}

class RunButton: UIView {
    
    var delegate: RunButtonDelegate?
    
    let titleLabel = UILabel()
    let buttonView = UIView(frame: .zero)
    let buttonOverlayView = UIView(frame: .zero)
    
    var buttonViewWCnstr: NSLayoutConstraint!
    var buttonViewHCnstr: NSLayoutConstraint!
    var buttonOverlayViewTopCnstr: NSLayoutConstraint!
    
    var buttonViewTopCnstr: NSLayoutConstraint!
    
    private var startLocation: CGPoint = .zero
    private var currentOverlayPercent: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonSetup()
    }
    
    private func commonSetup() {
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonView)
        buttonViewWCnstr = buttonView.widthAnchor.constraint(equalToConstant: 180)
        buttonViewHCnstr = buttonView.heightAnchor.constraint(equalToConstant: 180)
        buttonViewTopCnstr = topAnchor.constraint(equalTo: buttonView.topAnchor)
        let buttonViewBottomCnstr = bottomAnchor.constraint(equalTo: buttonView.bottomAnchor)
        let buttonViewXCnstr = centerXAnchor.constraint(equalTo: buttonView.centerXAnchor)
        NSLayoutConstraint.activate([buttonViewWCnstr, buttonViewHCnstr, buttonViewBottomCnstr, buttonViewXCnstr])
        
        buttonOverlayView.isHidden = true
        buttonOverlayView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addSubview(buttonOverlayView)
        buttonOverlayView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        buttonOverlayViewTopCnstr = buttonOverlayView.topAnchor.constraint(equalTo: buttonView.topAnchor)
        
        let buttonOverlayViewBottomCnstr = buttonView.bottomAnchor.constraint(equalTo: buttonOverlayView.bottomAnchor)
        let buttonOverlayViewTCnstr = buttonOverlayView.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor)
        let buttonOverlayViewLCnstr = buttonOverlayView.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor)
        NSLayoutConstraint.activate([buttonOverlayViewTopCnstr, buttonOverlayViewBottomCnstr, buttonOverlayViewTCnstr, buttonOverlayViewLCnstr])
        
        titleLabel.font = UIFont.systemFont(ofSize: 36)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            buttonView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            buttonView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        buttonView.addGestureRecognizer(tap)
        
        let slide = UIPanGestureRecognizer(target: self, action: #selector(slide(_:)))
        buttonView.addGestureRecognizer(slide)
        slide.delegate = self
        
        setupStopMode(animated: false)
    }
    
    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        delegate?.runButtonDidTap()
    }
    
    @objc private func slide(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            startLocation = gesture.location(in: buttonView)
        case .changed:
            let slideY: CGFloat = max(gesture.location(in: buttonView).y, 0)
            print(slideY)
            buttonOverlayViewTopCnstr.constant = slideY
//
//            UIView.animate(withDuration: 0.3) {
//                self.layoutIfNeeded()
//            }
            
//            let changed: CGFloat = slideY - max(startLocation.y, 0)
//            let draggedThumb: CGFloat = -(changed * 100 / buttonView.frame.height)
//
//            setOverlay(percent: Int(draggedThumb))
        case .ended, .cancelled, .failed:
            break
//            let slideY: CGFloat = max(gesture.location(in: buttonView).y, 0)
//            let changed: CGFloat = slideY - max(startLocation.y, 0)
//            let draggedThumb: CGFloat = -(changed * 100 / buttonView.frame.height) / 2
//
//            setOverlay(percent: Int(draggedThumb) + currentOverlayPercent)
            
        default:
            break
        }
    }
    
    func setupSliderMode(animated: Bool = true) {
        buttonOverlayView.isHidden = false
        
        buttonOverlayViewTopCnstr.constant = 500
        layoutIfNeeded()
        
        buttonView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.262745098, blue: 0.2705882353, alpha: 1)
        buttonViewWCnstr.constant = 100
        buttonViewHCnstr.isActive = false
        buttonViewTopCnstr.isActive = true
        
        setOverlay(percent: 50)

        let duration: TimeInterval = animated ? 0.3 : 0
        UIView.animate(withDuration: duration, animations: {
            self.buttonView.layer.cornerRadius = 30
            self.buttonView.layer.masksToBounds = true
            self.layoutIfNeeded()
        }) { _ in
//            self.setOverlay(percent: 50)
        }
        
        titleLabel.text = ""
    }
    
    func setupStartMode(animated: Bool = true) {
        buttonView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.2196078431, blue: 0.3215686275, alpha: 1)
        
        buttonOverlayView.isHidden = true
        buttonViewWCnstr.constant = 180
        buttonViewHCnstr.constant = 180
        buttonViewTopCnstr.isActive = false
        buttonViewHCnstr.isActive = true
        
        let duration: TimeInterval = animated ? 0.3 : 0
        UIView.animate(withDuration: duration) {
            self.buttonView.layer.cornerRadius = 90
            self.buttonView.layer.masksToBounds = true
            self.layoutIfNeeded()
        }
        
        titleLabel.text = "stop"
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func setupStopMode(animated: Bool = true) {
        buttonView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        
        buttonOverlayView.isHidden = true
        buttonViewWCnstr.constant = 180
        buttonViewHCnstr.constant = 180
        buttonViewTopCnstr.isActive = false
        buttonViewHCnstr.isActive = true
        
        let duration: TimeInterval = animated ? 0.3 : 0
        UIView.animate(withDuration: duration) {
            self.buttonView.layer.cornerRadius = 90
            self.buttonView.layer.masksToBounds = true
            self.layoutIfNeeded()
        }
        
        titleLabel.text = "start"
        titleLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
    }
    
    private func setOverlay(percent: CGFloat) {
        let y: CGFloat = buttonView.frame.height * (percent / 100)
        buttonOverlayViewTopCnstr.constant = y
        
//        UIView.animate(withDuration: 0) {
//            self.layoutIfNeeded()
//        }
        
//        print("overlay y: \(y)")
//        let step: CGFloat = buttonView.frame.height / 100
        
    }
}

extension RunButton: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { true }
}