//
//  PinView.swift
//  piggy
//
//  Created by Dason Tiovino on 23/08/24.
//

import Foundation
import UIKit
import SwiftUI

class PinViewController: UIViewController, UITextFieldDelegate {

    @Published internal var router: NavigationRouteController = .init()

    private let piggyPlanImageView = UIImageView()
    private let instructionLabel = UILabel()
    private let backgroundImageView = UIImageView()
    private var pinTextFields: [UITextField] = [] // Array to hold the 6 text fields
    private let darkOverlayView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Background Image View
        backgroundImageView.image = UIImage(named: "HomeBackground")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)

        // Setup Dark Overlay View
        darkOverlayView.backgroundColor = UIColor(white: 0, alpha: 0.5) // 50% darkness
        darkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(darkOverlayView)

        // Setup Piggy Plan Image View
//        piggyPlanImageView.image = UIImage(named: "PiggyPlan")
//        piggyPlanImageView.contentMode = .scaleAspectFit
        piggyPlanImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(piggyPlanImageView)

        // Setup Instruction Label
        instructionLabel.text = "Enter the passcode to verify!"
        instructionLabel.font = UIFont.systemFont(ofSize: 64, weight: .bold) // SF Pro with size 64 and bold weight
        instructionLabel.textColor = UIColor(hex: "#FF3181") // Adjust color
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(instructionLabel)

        // Setup PIN Text Fields
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)

        for i in 0..<6 {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.font = UIFont.systemFont(ofSize: 24)
            textField.textAlignment = .center
            textField.delegate = self
            textField.tag = i + 1 // Set tag to identify each text field
            textField.layer.cornerRadius = 25 // Set corner radius
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.widthAnchor.constraint(equalToConstant: 125).isActive = true // Set width
            textField.heightAnchor.constraint(equalToConstant: 150).isActive = true // Set height
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = false
            pinTextFields.append(textField)
            stackView.addArrangedSubview(textField)
        }

        // Add the piggy mascot image view
        let piggyImageView = UIImageView(image: UIImage(named: "Mascot"))
        piggyImageView.contentMode = .scaleAspectFit
        piggyImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(piggyImageView)

        // Add constraints
        NSLayoutConstraint.activate([
            // Set backgroundImageView constraints to fill the entire view
            backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            // Set darkOverlayView constraints to cover the entire view
            darkOverlayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            darkOverlayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            darkOverlayView.topAnchor.constraint(equalTo: self.view.topAnchor),
            darkOverlayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            // Center the piggyPlanImageView at the top center
            piggyPlanImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            piggyPlanImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            piggyPlanImageView.widthAnchor.constraint(equalToConstant: 100),
            piggyPlanImageView.heightAnchor.constraint(equalToConstant: 100),

            // Center the instructionLabel below piggyPlanImageView
            instructionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: piggyPlanImageView.bottomAnchor, constant: 20),

            // Center the stackView containing the 6 text fields
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),

            // Center the piggyImageView at the bottom right corner
            piggyImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            piggyImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            piggyImageView.widthAnchor.constraint(equalToConstant: 300),
            piggyImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
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
            
            // Check if all text fields are filled and then validate the PIN
            if nextTag == 7 {
                validatePIN()
            }
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

    private func validatePIN() {
        let enteredPIN = pinTextFields.compactMap { $0.text }.joined()
        let correctPIN = UserDefaultsManager.shared.getPIN() ?? "123456"

        if enteredPIN == correctPIN {
            moveToNextPage()
        } else {
            // Optionally, show an error message or clear the text fields
            print("Incorrect PIN")
        }
    }

    private func moveToNextPage() {
        router.push(.parentalSetting)
//
//        let nextViewController = NextViewController() // Replace with your actual next view controller
//        nextViewController.modalTransitionStyle = .crossDissolve
//        nextViewController.modalPresentationStyle = .fullScreen
//        self.present(nextViewController, animated: true, completion: nil)
    }
}

struct PinViewControllerRepresentable: UIViewControllerRepresentable {
    
    @EnvironmentObject private var router: NavigationRouteController
    
    typealias UIViewControllerType = PinViewController
    
    func makeUIViewController(context: Context) -> PinViewController {
        let viewController = PinViewController()
        viewController.router = router
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: PinViewController, context: Context) {}
}


// UIColor extension to handle hex color conversion
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, int & 0xF * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
