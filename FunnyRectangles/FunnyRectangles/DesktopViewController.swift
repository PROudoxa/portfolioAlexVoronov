//
//  ViewController.swift
//  FunnyRectangles
//
//  Created by Alex Voronov on 16.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

protocol DesktopBackgroundImageDelegate: class {
    func setBackgroundImage(imageName: String)
}

class DesktopViewController: UIViewController {

    // MARK: Properties
    let settingsController = SettingsViewController()
    var widthLimit: CGFloat {
        get {
            let restored = CGFloat(UserDefaults.standard.value(forKey: settingsController.widthLimitKey) as? Float ?? 100.0)
            return restored
        }
        //set {}
    }
    
    var heightLimit: CGFloat {
        get {
            let restored = CGFloat(UserDefaults.standard.value(forKey: settingsController.heightLimitKey) as? Float ?? 100.0)
            return restored
        }
        //set {}
    }
    
    var allowedCreating = true
    var tag = 1
    
    var currentRect = CGRect.zero
    lazy var currentRectView = UIView(frame: CGRect.zero)
    
    //origin for currentRectView
    var startPoint = CGPoint(x: 100.0, y: 200.0)
    var currentOrigin = CGPoint.zero
    
    lazy var timer = Timer()
    let timeInterval: Double = 10.0
    
    
    // MARK: IBOutlets
    @IBOutlet weak var longPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var addRectButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addRectButton.layer.cornerRadius = 5.0
        rotateBackground() // for first launch VC
        runTimer()
        
        /*// TODO: implement KVO or KVC
        self.widthLimit = CGFloat(UserDefaults.standard.value(forKey: settingsController.widthLimitKey) as? Float ?? 100.0)
        self.heightLimit = CGFloat(UserDefaults.standard.value(forKey: settingsController.heightLimitKey) as? Float ?? 100.0) */
        //guard let rotatable: Bool = UserDefaults.standard.value(forKey: "rotatedBackground") as? Bool, rotatable else { return }
    }
    
    deinit {
        self.timer.invalidate()
    }
}

// MARK: IBActions
extension DesktopViewController {
    
    @IBAction func randomTapped(_ sender: UIButton) {
        
        self.startPoint =  getRandomPointIn(alloyedArea: self.view)
        let diagonalPoint = getRandomPointIn(alloyedArea: self.view)

        initializeRectangle()
        configureRectangle(with: diagonalPoint, durationAnimation: 1.0)
        saveRectangle()
    }
        
    @IBAction func handleDeskLongPress(_ sender: UILongPressGestureRecognizer) {
        
        guard allowedCreating else { allowedCreating = true; return } // next touch on desktop allows creating rect
                                                                      // after touch(and canceling) on existing rect(s)
        switch sender.state {
        case .began:
            self.startPoint = sender.location(in: sender.view)
            initializeRectangle()
            
        case .changed:
            let newPoint = sender.location(in: self.view)
            configureRectangle(with: newPoint, durationAnimation: 0.2)
            
        case .ended:
            saveRectangle()
        
        default:
            print("default switch")
        }
    }
}

// MARK: DesktopBackgroundImageDelegate
extension DesktopViewController: DesktopBackgroundImageDelegate {

    func setBackgroundImage(imageName: String) {
        self.backgroundImageView.image = UIImage(named: imageName)
    }
}
