//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Adrian Lesniak on 15/02/2021.
//

import UIKit


class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celcuisLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelciusValue()
        }
    }
    
    var celciusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    var numberFormatter: NumberFormatter = {
       let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 1
        return f
    }()
    
    override func viewDidLoad() {
        updateCelciusValue()
    }

    @IBAction func fahrenheitFieldEditingChanged(_ target: UITextField) {
        
        if let text = target.text, let value = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: value.doubleValue, unit: UnitTemperature.fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ : UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelciusValue() {
        if let celciusValue = celciusValue {
            celcuisLabel.text = numberFormatter.string(from: NSNumber(value: celciusValue.value))
        } else {
            celcuisLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789\(decimalSeparator)").inverted
        
        let components = string.components(separatedBy: allowedCharacters)
        let filtred = components.joined(separator: "")
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            return false
        } else if string == filtred {
            return true
        } else {
            return false
        }
    }
}
