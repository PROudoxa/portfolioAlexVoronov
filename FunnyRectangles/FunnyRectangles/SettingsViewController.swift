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
        
        //UITextFieldDelegate
        self.widthTextField.delegate = self
        self.heightTextField.delegate = self
        addToolBarToKeypad()
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
        
        configureTextFields()
    }
    
    func configureTextFields() {
        
        widthTextField.layer.cornerRadius = 8.0
        widthTextField.layer.masksToBounds = true
        widthTextField.layer.borderWidth = 1
        widthTextField.layer.borderColor = UIColor.blue.cgColor
        
        heightTextField.layer.cornerRadius = 8.0
        heightTextField.layer.masksToBounds = true
        heightTextField.layer.borderWidth = 1
        heightTextField.layer.borderColor = UIColor.blue.cgColor
    }
    
    func saveAsDefaults() {
        
        defaults.setValue(alertSwitch.isOn, forKeyPath: showAlertKey)
        defaults.setValue(randomizeSwitch.isOn, forKeyPath: rotatedBackgroundKey)
        defaults.setValue(currentWidthLimit, forKeyPath: widthLimitKey)
        defaults.setValue(currentHeightLimit, forKeyPath: heightLimitKey)
    }
    
    func addToolBarToKeypad() {
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.widthTextField.inputAccessoryView = toolbar
        self.heightTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func showAlertFor(failed: String, min: Float, max: Float) {
        
        let alertVC = UIAlertController(title: "Wrong data", message: failed + " interval must be\n\(Int(min)) - \(Int(max))", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        alertVC.addAction(okAction)
        
        present(alertVC, animated: true)
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
            print("switch default: unknown slider tag")
        }
    }
}

// MARK: UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            guard let availableWidth = Float(textField.text!),
                availableWidth >= self.widthSlider.minimumValue,
                availableWidth <= self.widthSlider.maximumValue else {
                    
                    showAlertFor(failed: "width", min: self.widthSlider.minimumValue, max: self.widthSlider.maximumValue)
                    
                    return false }
            
            self.widthSlider.setValue(availableWidth, animated: true)
            self.currentWidthLimit = Int(availableWidth)
            
        case 2:
            guard let availableHeight = Float(textField.text!),
                availableHeight >= self.heightSlider.minimumValue,
                availableHeight <= self.heightSlider.maximumValue else {
                    
                    showAlertFor(failed: "height", min: self.heightSlider.minimumValue, max: self.heightSlider.maximumValue)
                    
                    return false }
            
            self.heightSlider.setValue(availableHeight, animated: true)
            self.currentHeightLimit = Int(availableHeight)
            
        default:
            print("switch default: unknown textField tag")
        }
        
        return true
    }
}
