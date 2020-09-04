//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 03/09/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import Foundation

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var switchAutoplay: UISwitch!
    @IBOutlet weak var segmentedControlColors: UISegmentedControl!
    @IBOutlet weak var textfieldCategory: UITextField!
    private let ud = UserDefaults.standard
    
    // MARK: - Properties
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldCategory.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        defaultsChanged()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBActions
    @IBAction func changeAutoplay(_ sender: UISwitch) {
        ud.set(sender.isOn, forKey: Key.autoplay)
        ud.synchronize()
    }
    
    @IBAction func changeColor(_ sender: UISegmentedControl) {
        ud.set(sender.selectedSegmentIndex, forKey: Key.color)
    }
    
    @IBAction func saveCategory(_ sender: UITextField) {
        ud.set(sender.text, forKey: Key.category)
        view.endEditing(true)
    }
    
    // MARK: - Methods
    @objc func defaultsChanged() {
        let autoplay = ud.bool(forKey: Key.autoplay)
        switchAutoplay.isOn = autoplay
        
        let colorIndex = ud.integer(forKey: Key.color)
        segmentedControlColors.selectedSegmentIndex = colorIndex
        
        let category = ud.string(forKey: Key.category)
        textfieldCategory.text = category
    }
}

extension SettingsViewController: UITextFieldDelegate {
    /*
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        return true
    }
    */
}
