//
//  HandleGesturesEstension.swift
//  FunnyRectangles
//
//  Created by Alex Voronov on 18.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

extension DesktopViewController {

    // MARK: handle gestures
    @objc func handleTapToHighlight(_ sender: UITapGestureRecognizer) {
        self.view.bringSubview(toFront: sender.view!)
        self.view.bringSubview(toFront: logoImageView)
        self.view.bringSubview(toFront: addRectButton)
        
        //print("one tap...")
        //print("tag: \(String(describing: sender.view?.tag))")
    }
    
    @objc func handleTapDelete(_ sender: UITapGestureRecognizer) {
        
        guard let deletedRect = sender.view else { return }
        
        self.view.bringSubview(toFront: deletedRect)
        
        let message = "Are you sure you want to kill it?"
        let alertController = UIAlertController(title: "Removing", message: message, preferredStyle: .alert)
        
        let cancelTitle = "Cancel"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        
        let okTitle = "Yes!"
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { (okAction) in
            
            if okAction.title == okTitle {
                
                deletedRect.gestureRecognizers?.forEach(deletedRect.removeGestureRecognizer)
                self.animatedRemoving(poorView: deletedRect)
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        self.view.bringSubview(toFront: logoImageView)
        self.view.bringSubview(toFront: addRectButton)
    }
    
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        
        let mode = _mode(sender)
        
        // vertical scaling
        if mode == "V" {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: 1.0, y: sender.scale))!
            sender.scale = 1.0
        }
        
        // horizontal scaling
        if mode == "H" {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: 1.0))!
            sender.scale = 1.0
        }
        
        // diagonal scaling
        if mode == "D" {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: 1.0 + (sender.scale - 1.0) / 2, y: 1.0 + (sender.scale - 1.0) / 2))!
            sender.scale = 1.0
        }
        
        // TODO: add some fun feature in future
        let vel = sender.velocity
        if vel < 0 {
            //print("you're squeezing the screen!")
        }
    }
    
    // MARK: determinate asis - func for handling pinch
    func _mode(_ sender: UIPinchGestureRecognizer) -> String {
        
        guard sender.numberOfTouches < 2 else { return "" }
        
        let A = sender.location(ofTouch: 0, in: sender.view)
        let B = sender.location(ofTouch: 1, in: sender.view)
        
        let xD = fabs( A.x - B.x )
        let yD = fabs( A.y - B.y )
        if (xD == 0) { return "V" }
        if (yD == 0) { return "H" }
        let ratio = xD / yD
        // print(ratio)
        if (ratio > 2) { return "H" }
        if (ratio < 0.5) { return "V" }
        return "D"
    }
    
    @objc func handleRotate(_ sender: UIRotationGestureRecognizer) {
        
        var lastRotation = CGFloat()
        
        if(sender.state == UIGestureRecognizerState.ended){
            lastRotation = 0.0;
        }
        let rotation = 0.0 - (lastRotation - sender.rotation)
        let currentTrans = sender.view?.transform
        let _ = currentTrans!.rotated(by: rotation) // newTrans
        sender.view?.transform = CGAffineTransform(rotationAngle: sender.rotation) //newTrans
        lastRotation = sender.rotation
        
        //FIXME: if rotation after scaling - frame rotatable view returns to start size
        
        //        if let view = sender.view {
        //            view.transform = CGAffineTransform(rotationAngle: sender.rotation)
        //        }
    }
    
    @objc func handleLongPress(_ sender: UIPinchGestureRecognizer) {
        
        if sender.state == .ended {
            sender.view?.backgroundColor = .randomColor()
        }
    }
    
    func setGestureRecognizers() -> [UIGestureRecognizer] {
        return [
            setTapGestureToMove(),
            setTapGestureToDelete(),
            setPanGesture(),
            setPinchGesture(),
            setRotateGesture(),
            setLongPressGesture() ]
    }
}

// MARK: set gestures

extension DesktopViewController {

    func setTapGestureToMove() -> UITapGestureRecognizer {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapToHighlight(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }
    
    func setTapGestureToDelete() -> UITapGestureRecognizer {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapDelete(_:)))
        tapRecognizer.numberOfTapsRequired = 2
        return tapRecognizer
    }
    
    func setPanGesture() -> UIPanGestureRecognizer {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        return panRecognizer
    }
    
    func setPinchGesture() -> UIPinchGestureRecognizer {
        let pinchRecognizer = UIPinchGestureRecognizer (target: self, action: #selector(handlePinch(_:)))
        return pinchRecognizer
    }
    
    func setRotateGesture() -> UIRotationGestureRecognizer {
        let rotateRecognizer = UIRotationGestureRecognizer (target: self, action: #selector(handleRotate(_:)))
        return rotateRecognizer
    }
    
    func setLongPressGesture() -> UILongPressGestureRecognizer {
        let longPressRecognizer = UILongPressGestureRecognizer (target: self, action: #selector(handleLongPress(_:)))
        return longPressRecognizer
    }
}

// MARK: UIGestureRecognizerDelegate
extension DesktopViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == longPressGestureRecognizer {
            print("out") // FIXME: never goes here
            allowedCreating = true
            
            return true
        }
        
        //print("point is in rect")
        //disallow creating new rect if finger is on one of existing rectangles
        //blocks launching longPressGesture method = (only for main view)
        allowedCreating = false
        
        return false
    }
}
