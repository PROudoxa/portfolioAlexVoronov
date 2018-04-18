//
//  CreateRectangleExtension.swift
//  FunnyRectangles
//
//  Created by Alex Voronov on 18.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

// MARK: create rectangle

extension DesktopViewController {

    func initializeRectangle() {
        
        self.currentOrigin = self.startPoint
        
        self.currentRect = CGRect(origin: self.startPoint, size: CGSize())
        self.currentRectView = UIView(frame: currentRect)
        
        self.currentRectView.backgroundColor = .blue
        self.view.addSubview(currentRectView)
    }
    
    func configureRectangle(with newPoint: CGPoint, durationAnimation: Double)  {
        
        // new point position relatively origin, deltaX and deltaY
        let incrementX = newPoint.x - self.startPoint.x
        let incrementY = newPoint.y - self.startPoint.y
        
        // new point is in (bottom + right) quarter
        if (incrementX >= 0) && (incrementY > 0) {
            bottomRightCorner(replacedBy: newPoint, duration: durationAnimation)
        }
        
        // new point is in (top + right) quarter
        if (incrementX >= 0) && (incrementY < 0) {
            topRightCorner(replacedBy: newPoint, incrementX: incrementX, incrementY: incrementY, duration: durationAnimation)
        }
        
        // new point is in (bottom + left) quarter
        if (incrementX < 0) && (incrementY >= 0) {
            bottomLeftCorner(replacedBy: newPoint, incrementX: incrementX, incrementY: incrementY, duration: durationAnimation)
        }
        
        // new point is in (top + left) quarter
        if (incrementX < 0) && (incrementY <= 0) {
            topLeftCorner(replacedBy: newPoint, incrementX: incrementX, incrementY: incrementY, duration: durationAnimation)
        }
    }
    
    func bottomRightCorner(replacedBy newPoint: CGPoint, duration: Double) {
        let incrementX = newPoint.x - self.currentOrigin.x
        let incrementY = newPoint.y - self.currentOrigin.y
        
        UIView.animate(withDuration: duration, animations: {
            self.currentRectView.frame.size.width = incrementX
            self.currentRectView.frame.size.height = incrementY
        })
    }
    
    func topRightCorner(replacedBy newPoint: CGPoint, incrementX: CGFloat, incrementY: CGFloat, duration: Double) {
        self.currentOrigin.y = newPoint.y
        
        UIView.animate(withDuration: duration, animations: {
            self.currentRectView.frame.origin = self.currentOrigin
            self.currentRectView.frame.size.width = incrementX
            self.currentRectView.frame.size.height = -incrementY
        })
    }
    
    func bottomLeftCorner(replacedBy newPoint: CGPoint, incrementX: CGFloat, incrementY: CGFloat, duration: Double) {
        self.currentOrigin.x = newPoint.x
        
        UIView.animate(withDuration: duration, animations: {
            self.currentRectView.frame.origin.x = self.currentOrigin.x
            self.currentRectView.frame.size.width = -incrementX
            self.currentRectView.frame.size.height = incrementY
        })
    }
    
    func topLeftCorner(replacedBy newPoint: CGPoint, incrementX: CGFloat, incrementY: CGFloat, duration: Double) {
        self.currentOrigin = newPoint
        
        UIView.animate(withDuration: duration, animations: {
            self.currentRectView.frame.origin = self.currentOrigin
            self.currentRectView.frame.size.width = -incrementX
            self.currentRectView.frame.size.height = -incrementY
        })
    }
    
    func saveRectangle() {
        
        if (self.currentRectView.frame.width > self.widthLimit) && (self.currentRectView.frame.height > self.heightLimit) {
            
            self.currentRectView.backgroundColor = .randomColor()
            self.currentRectView.tag = self.tag
            self.tag += 1
            
            let recognizers: [UIGestureRecognizer] = self.setGestureRecognizers()
            
            // Separates one and two taps gestures
            if recognizers.count >= 2 {
                recognizers[0].require(toFail: recognizers[1])
            }
            
            for recognizer in recognizers {
                self.currentRectView.addGestureRecognizer(recognizer)
                self.longPressGestureRecognizer.require(toFail: recognizer)
            }
            
            currentRectView.removeGestureRecognizer(longPressGestureRecognizer)
            self.view.bringSubview(toFront: logoImageView)
            self.view.bringSubview(toFront: addRectButton)
            
        } else {
            
            if (currentRectView.frame.width > 5.0) || (currentRectView.frame.height > 5.0) {
                
                let savedAlertState: Bool? = UserDefaults.standard.value(forKey: settingsController.showAlertKey) as? Bool
                
                let showingAllowed = savedAlertState ?? true
                
                showingAllowed ? showAlertAndRemoveView(poorView: self.currentRectView) : animatedRemoving(poorView: self.currentRectView)
                
            } else {
                // prevents appearing alert in case missclick(misstouch)
                self.currentRectView.removeFromSuperview()
            }
        }
    }
    
    func getRandomPointIn(alloyedArea: UIView) -> CGPoint {
        
        let diapasonX = alloyedArea.frame.width
        let diapasonY = alloyedArea.frame.height
        
        let randX = CGFloat.randomFloat() * diapasonX
        let randY = CGFloat.randomFloat() * diapasonY
        
        return CGPoint(x: randX, y: randY)
    }
}

// MARK: color extensions
extension CGFloat {
    static func randomFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .randomFloat(), green: .randomFloat(), blue:  .randomFloat(), alpha: 1.0)
    }
}
