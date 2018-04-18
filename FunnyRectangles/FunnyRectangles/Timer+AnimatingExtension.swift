//
//  Extension.swift
//  FunnyRectangles
//
//  Created by Alex Voronov on 18.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

extension DesktopViewController {
    
    // MARK: Timer
    func runTimer() {
        
        // TODO: implement KVO / KVC
        guard let rotatable: Bool = UserDefaults.standard.value(forKey: "rotatedBackground") as? Bool, rotatable else {
            //self.timer.invalidate()
            return
        }
        guard rotatable else { return }
        
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self,   selector: (#selector(self.rotateBackground)), userInfo: nil, repeats: true)
        
        //return timer
    }
    
    @objc func rotateBackground() {
        
        //guard let rotatable: Bool = UserDefaults.standard.value(forKey: "rotatedBackground") as? Bool, rotatable else { return }
        
        let imageManager = ImageManager()
        
        imageManager.delegate = self
        imageManager.changeBackground(firstTime: true)
    }
    
    func showAlertAndRemoveView(poorView: UIView) {
        
        let message = "Sorry, that rect was...\ntoo little (\(Int(currentRectView.frame.width)) x \(Int(currentRectView.frame.height)))\nlimits: (\(Int(widthLimit)) x \(Int(heightLimit)))"
        
        let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        
        let okTitle = "Ok :("
        let okAction = UIAlertAction(title: okTitle, style: .cancel, handler: { (okAction) in
            
            if okAction.title == okTitle {
                
                self.animatedRemoving(poorView: poorView)
            }
        })
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    func animatedRemoving(poorView: UIView) {
        
        UIView.animate(withDuration: 0.9, animations: {
            
            poorView.frame = CGRect.zero
            
        }, completion: { (flag) in
            
            poorView.removeFromSuperview()
            //print("finished! - \(flag)")
        })
    }
}
