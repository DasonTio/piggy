//
//  ParentalSettingView.swift
//  piggy
//
//  Created by Dason Tiovino on 23/08/24.
//

import UIKit
import SwiftUI

class ParentalSettingViewController: UIViewController, UITextFieldDelegate {
    
    @Published internal var router: NavigationRouteController = .init()
    @Published internal var addAchievementWrapper: AddAchievementWrapper = .init()

    let sheetView = UIView()
    let segmentedControl = UISegmentedControl(items: ["Reset Password", "Allowance", "Add Achievement"])
    var textFields: [UITextField] = []
    
    // Reset Password Page Elements
    let inputNewPinLabel = UILabel()
    
    // Allowance Page Elements
    let allowanceAmountLabel = UILabel()
    let allowanceTextField = UITextField()
    let repeatLabel = UILabel()
    let repeatSegmentedControl = UISegmentedControl(items: ["Daily", "Weekly"])
    let startDateLabel = UILabel()
    let startDatePicker = UIDatePicker()
    
    // Add Achievement Page Elements
    let achievementLabel = UILabel()
    let achievementDropdown = UIPickerView()
    let addButton = UIButton(type: .system)
    
    // Buttons for each page
    let saveButton = UIButton(type: .system)
    let submitButton = UIButton(type: .system)
    let verifyButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
        verifyButton.addTarget(self, action: #selector(handleVerifyButton), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(handleAddAchievementButton), for: .touchUpInside)
        
        // Background setup
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let darkOverlayView = UIView()
        darkOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(darkOverlayView)
        darkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let backButton = UIButton(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        let bakButtonSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 34, weight: .bold, scale: .large)
        let backButtonImage = UIImage(systemName: "arrow.backward.square.fill", withConfiguration: bakButtonSymbolConfiguration)?
            .withRenderingMode(.alwaysOriginal)
            .applyingSymbolConfiguration(.preferringMulticolor())
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = UIColor.base
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 4
        backButton.layer.cornerRadius = 12
        
        let screenName = UILabel()
        screenName.text = "Parental Setting"
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
        screenName.font = UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
        screenName.textColor = UIColor.tint2
        screenName.textAlignment = .center
        screenName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(screenName)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            
            screenName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenName.topAnchor.constraint(equalTo: view.topAnchor, constant: 28)
        ])
        
        // Set up the sheet view
        sheetView.backgroundColor = UIColor(red: 0.863, green: 0.722, blue: 1.0, alpha: 1.0)
        sheetView.layer.borderColor = UIColor.white.cgColor
        sheetView.layer.borderWidth = 4.0
        sheetView.layer.cornerRadius = 40.0 * 0.6
        sheetView.layer.masksToBounds = true
        self.view.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up the segmented control
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.selectedSegmentTintColor = UIColor(red: 1.0, green: 0.671, blue: 0.945, alpha: 1.0)
        segmentedControl.tintColor = UIColor(red: 0.313, green: 0.153, blue: 0.471, alpha: 1.0)
        segmentedControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: UIFont.systemFontSize * 1.2 + 3, weight: .bold), .foregroundColor: UIColor.black], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        sheetView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Add "Input New Pin" label
        inputNewPinLabel.text = "Input New Pin"
        inputNewPinLabel.font = UIFont.boldSystemFont(ofSize: 64)
        inputNewPinLabel.textColor = UIColor(red: 0.314, green: 0.153, blue: 0.471, alpha: 1.0)
        inputNewPinLabel.textAlignment = .center
        inputNewPinLabel.isHidden = true
        sheetView.addSubview(inputNewPinLabel)
        inputNewPinLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add text fields for Reset Password
        for i in 0..<6 {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.textAlignment = .center
            textField.font = UIFont.boldSystemFont(ofSize: 24)
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
            textField.delegate = self
            textField.tag = i
            textField.layer.cornerRadius = 40 * 0.6 * 1.25  // Increase the border radius by 25%
            textField.isHidden = segmentedControl.selectedSegmentIndex != 0
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.widthAnchor.constraint(equalToConstant: 125).isActive = true
            textField.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            textFields.append(textField)
        }
        
        // Create a stack view for the text fields with reduced spacing
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10 // Reduced spacing to bring the text fields closer together
        stackView.isHidden = segmentedControl.selectedSegmentIndex != 0
        sheetView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Allowance Page UI setup
        allowanceAmountLabel.text = "Allowance Amount"
        allowanceAmountLabel.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        allowanceAmountLabel.textAlignment = .center
        allowanceAmountLabel.isHidden = true
        sheetView.addSubview(allowanceAmountLabel)
        allowanceAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        allowanceTextField.borderStyle = .roundedRect
        allowanceTextField.font = UIFont.boldSystemFont(ofSize: 24)
        allowanceTextField.textAlignment = .center  // Center the text within the text field
        allowanceTextField.text = "Rp.10.000"
        allowanceTextField.isHidden = true
        sheetView.addSubview(allowanceTextField)
        allowanceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        repeatLabel.text = "Repeat"
        repeatLabel.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        repeatLabel.textAlignment = .center
        repeatLabel.isHidden = true
        sheetView.addSubview(repeatLabel)
        repeatLabel.translatesAutoresizingMaskIntoConstraints = false
        
        repeatSegmentedControl.selectedSegmentIndex = 0
        repeatSegmentedControl.backgroundColor = UIColor.white
        repeatSegmentedControl.selectedSegmentTintColor = UIColor(red: 1.0, green: 0.671, blue: 0.945, alpha: 1.0)
        repeatSegmentedControl.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 24), .foregroundColor: UIColor.black], for: .normal)
        repeatSegmentedControl.isHidden = true
        sheetView.addSubview(repeatSegmentedControl)
        repeatSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        startDateLabel.text = "Start Date"
        startDateLabel.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        startDateLabel.textAlignment = .center
        startDateLabel.isHidden = true
        sheetView.addSubview(startDateLabel)
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        startDatePicker.datePickerMode = .date
        startDatePicker.isHidden = true
        sheetView.addSubview(startDatePicker)
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up the "Add Achievement" label
        achievementLabel.text = "<August Achievement>"
        achievementLabel.font = UIFont.systemFont(ofSize: 56, weight: .bold)
        achievementLabel.textColor = UIColor(red: 80/255, green: 39/255, blue: 120/255, alpha: 1.0)
        achievementLabel.textAlignment = .center
        achievementLabel.isHidden = true
        sheetView.addSubview(achievementLabel)
        achievementLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up the achievement dropdown
        achievementDropdown.isHidden = true
        sheetView.addSubview(achievementDropdown)
        achievementDropdown.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up the "+" button
        addButton.setTitle("+", for: .normal)
        addButton.backgroundColor = UIColor(red: 80/255, green: 39/255, blue: 120/255, alpha: 1.0)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        addButton.layer.cornerRadius = 10 // Make the button a box shape
        addButton.isHidden = true
        sheetView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up the save, submit, and verify buttons
        configureButton(saveButton, title: "Save")
        configureButton(submitButton, title: "Submit")
        configureButton(verifyButton, title: "Verify")
        
        // Constraints
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            darkOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            darkOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            darkOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            darkOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            //            label.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            //            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            sheetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sheetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sheetView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            sheetView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            segmentedControl.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: sheetView.widthAnchor, multiplier: 0.8),
            
            inputNewPinLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            inputNewPinLabel.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: inputNewPinLabel.bottomAnchor, constant: 50),
            stackView.widthAnchor.constraint(equalTo: sheetView.widthAnchor, multiplier: 0.8),
            
            saveButton.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor, constant: -30),
            saveButton.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: sheetView.widthAnchor, multiplier: 0.5),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            allowanceAmountLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            allowanceAmountLabel.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            
            allowanceTextField.topAnchor.constraint(equalTo: allowanceAmountLabel.bottomAnchor, constant: 20),
            allowanceTextField.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            allowanceTextField.widthAnchor.constraint(equalTo: sheetView.widthAnchor, multiplier: 0.5),
            
            repeatLabel.topAnchor.constraint(equalTo: allowanceTextField.bottomAnchor, constant: 20),
            repeatLabel.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            
            repeatSegmentedControl.topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: 20),
            repeatSegmentedControl.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            repeatSegmentedControl.widthAnchor.constraint(equalTo: sheetView.widthAnchor, multiplier: 0.5),
            
            startDateLabel.topAnchor.constraint(equalTo: repeatSegmentedControl.bottomAnchor, constant: 20),
            startDateLabel.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            
            startDatePicker.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 20),
            startDatePicker.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            
            submitButton.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor, constant: -30),
            submitButton.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            submitButton.widthAnchor.constraint(equalTo: sheetView.widthAnchor, multiplier: 0.5),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            achievementLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            achievementLabel.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20),
            
            addButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: achievementLabel.trailingAnchor, constant: 10), // Position to the right of the label
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            achievementDropdown.topAnchor.constraint(equalTo: achievementLabel.bottomAnchor, constant: 20),
            achievementDropdown.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            achievementDropdown.widthAnchor.constraint(equalTo: sheetView.widthAnchor, multiplier: 0.8),
            
            verifyButton.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor, constant: -30),
            verifyButton.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            verifyButton.widthAnchor.constraint(equalTo: sheetView.widthAnchor, multiplier: 0.5),
            verifyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        updateUI()
    }
    
    private func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(red: 0.314, green: 0.153, blue: 0.471, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24 * 1.1) // Increase font size by 10%
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.isHidden = true
        sheetView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        updateUI()
    }
    
    private func updateUI() {
        let isResetPasswordPage = segmentedControl.selectedSegmentIndex == 0
        let isAllowancePage = segmentedControl.selectedSegmentIndex == 1
        let isAddAchievementPage = segmentedControl.selectedSegmentIndex == 2
        
        inputNewPinLabel.isHidden = !isResetPasswordPage
        textFields.forEach { $0.isHidden = !isResetPasswordPage }
        saveButton.isHidden = !isResetPasswordPage
        
        allowanceAmountLabel.isHidden = !isAllowancePage
        allowanceTextField.isHidden = !isAllowancePage
        repeatLabel.isHidden = !isAllowancePage
        repeatSegmentedControl.isHidden = !isAllowancePage
        startDateLabel.isHidden = !isAllowancePage
        startDatePicker.isHidden = !isAllowancePage
        submitButton.isHidden = !isAllowancePage
        
        achievementLabel.isHidden = !isAddAchievementPage
        achievementDropdown.isHidden = !isAddAchievementPage
        addButton.isHidden = !isAddAchievementPage
        verifyButton.isHidden = !isAddAchievementPage
    }
    
    @objc private func backButtonTapped() {
        // Handle the back button tap
        router.popToRoot()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Limit the text field to 1 character
        if let text = textField.text, text.count >= 1 && !string.isEmpty {
            return false
        }

        // Automatically move to the next text field when a digit is entered
        if !string.isEmpty {
            let nextTag = textField.tag + 1
            if let nextResponder = view.viewWithTag(nextTag) as? UITextField {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            textField.text = string
            return false
        } else { // Handle backspace (deletion)
            let previousTag = textField.tag - 1
            if let previousResponder = view.viewWithTag(previousTag) as? UITextField {
                previousResponder.becomeFirstResponder()
            }
            textField.text = ""
            return false
        }
    }
    
    // Pin
    @objc func handleSaveButton() {
        guard segmentedControl.selectedSegmentIndex == 0 else { return }
        let enteredPIN = textFields.compactMap { $0.text }.joined()
        if enteredPIN.count == 6 {
            UserDefaultsManager.shared.savePIN(enteredPIN)
        }else{
            print("Cannot lower than 6")
        }
    }
     
    // Allowance
    @objc func handleSubmitButton() {
        guard segmentedControl.selectedSegmentIndex == 1 else { return }
    }
    
    // Verify
    @objc func handleVerifyButton() {
        guard segmentedControl.selectedSegmentIndex == 2 else { return }
    }
    
    @objc func handleAddAchievementButton(){
        addAchievementWrapper.isPresented.toggle()
    }
    
}



struct ParentalSettingViewControllerRepresentable: UIViewControllerRepresentable {
    
    @EnvironmentObject private var addAchievementWrapper: AddAchievementWrapper
    @EnvironmentObject private var router: NavigationRouteController
    
    typealias UIViewControllerType = ParentalSettingViewController
    
    func makeUIViewController(context: Context) -> ParentalSettingViewController {
        let viewController =  ParentalSettingViewController()
        viewController.addAchievementWrapper = addAchievementWrapper
        viewController.router = router
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ParentalSettingViewController, context: Context) {}
}
