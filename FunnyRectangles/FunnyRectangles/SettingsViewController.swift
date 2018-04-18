//
//  SettingsViewController.swift
//  FunnyRectangles
//
//  Created by Alex Voronov on 17.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: Properties
    let defaults = UserDefaults.standard
    let rotatedBackgroundKey: String = "rotatedBackground"
    let showAlertKey: String = "showAlert"
    let widthLimitKey: String = "widthLimit"
    let heightLimitKey: String = "heightLimit"
    
    var currentWidthLimit: Int = 20 {
        willSet {
            widthTextField.text = newValue >= 20 ?  "\(newValue)" : "100"
        }
    }
    
    var currentHeightLimit: Int = 20 {
        willSet {
            heightTextField.text = newValue >= 20 ?  "\(newValue)" : "100"
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var randomizeSwitch: UISwitch!
    @IBOutlet weak var alertSwitch: UISwitch!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController?.topViewController is SettingsViewController {
            navigationController?.topViewController?.title = "Settings"
        }
        
        setupStartValues()
        configureView()
        
        // TODO: implement handling changing value via numpad
        widthTextField.isEnabled = false
        heightTextField.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParentViewController {
            saveAsDefaults()
        }
    }
    
    deinit {
        saveAsDefaults()
    }
}

// MARK: Private
private extension SettingsViewController {
    
    func setupStartValues() {
        
        alertSwitch.setOn(true, animated: true)
        randomizeSwitch.setOn(true, animated: true)
        
        let widthMid = (widthSlider.maximumValue - widthSlider.minimumValue) / 2
        let heightMid = (heightSlider.maximumValue - heightSlider.minimumValue) / 2
        
        widthSlider.setValue(widthMid, animated: true)
        heightSlider.setValue(heightMid, animated: true)
        
        widthTextField.text = "\(Int(widthMid))"
        heightTextField.text = "\(Int(heightMid))"
    }
    
    func configureView() {
        
        let savedAlertState: Bool? = defaults.value(forKey: showAlertKey) as? Bool
        let savedRotatabilityState: Bool? = defaults.value(forKey: rotatedBackgroundKey) as? Bool
        let savedWidthLimit: Int? = defaults.integer(forKey: widthLimitKey)
        let savedHeightLimit: Int? = defaults.integer(forKey: heightLimitKey)
        
        if let state = savedAlertState {
            self.alertSwitch.setOn(state, animated: true)
        }
        
        if let state = savedRotatabilityState {
            self.randomizeSwitch.setOn(state, animated: true)
        }
        
        if let widthLimit = savedWidthLimit {
            guard widthLimit > 0 else { return }
            self.currentWidthLimit = widthLimit
            self.widthSlider.setValue(Float(widthLimit), animated: true)
        }
        
        if let heightLimit = savedHeightLimit {
            guard heightLimit > 0 else { return }
            self.currentHeightLimit = heightLimit
            self.heightSlider.setValue(Float(heightLimit), animated: true)
        }
    }
    
    func saveAsDefaults() {
        
        defaults.setValue(alertSwitch.isOn, forKeyPath: showAlertKey)
        defaults.setValue(randomizeSwitch.isOn, forKeyPath: rotatedBackgroundKey)
        defaults.setValue(currentWidthLimit, forKeyPath: widthLimitKey)
        defaults.setValue(currentHeightLimit, forKeyPath: heightLimitKey)
    }
}

// MARK: IBActions
extension SettingsViewController {
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        switch sender.tag {
        case 1:
            self.currentWidthLimit = Int(sender.value)
        case 2:
            self.currentHeightLimit = Int(sender.value)
        default:
            print("switch default")
        }
    }
}
