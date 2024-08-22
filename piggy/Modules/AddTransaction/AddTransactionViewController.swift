//
//  AddTransactionViewController.swift
//  piggy
//
//  Created by Eric Fernando on 21/08/24.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    @Published internal var addTransactionWrapper: AddTransactionWrapper = .init()
    var textFieldWidthConstraint: NSLayoutConstraint!
    var segmentedControl: UISegmentedControl!
    var textField: UITextField!
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "id_ID") // Indonesian locale
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.tint2
        view.layer.borderWidth = 6
        view.layer.borderColor = UIColor.white.cgColor
        setupUI()
    }
    
    func setupUI() {
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "New Transaction"
        titleLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.black, width: UIFont.Width.standard)
        titleLabel.textColor = UIColor.shade2
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "I Use This for :"
        subtitleLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.black, width: UIFont.Width.standard)
        subtitleLabel.textColor = UIColor.shade2
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        
        let image1 = UIImage(named: "candy")?.withRenderingMode(.alwaysOriginal)
        let image2 = UIImage(named: "drink")?.withRenderingMode(.alwaysOriginal)
        let image3 = UIImage(named: "toy")?.withRenderingMode(.alwaysOriginal)
        
        // Create a UISegmentedControl with image items
        segmentedControl = UISegmentedControl(items: [image1, image2, image3].compactMap { $0 })
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 1
        view.addSubview(segmentedControl)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "How Much I’ve Spent ?"
        descriptionLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.black, width: UIFont.Width.standard)
        descriptionLabel.textColor = UIColor.shade2
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.buttonFill
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 6
        textField.layer.borderColor = UIColor.white.cgColor
        textField.font = UIFont.systemFont(ofSize: 28)
        textField.textColor = UIColor.shade2
        textField.textAlignment = .center
        let placeholder = NSAttributedString(string: "Rp10.000", attributes: [.foregroundColor: UIColor.darkGray])
        textField.attributedPlaceholder = placeholder
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        textFieldWidthConstraint = textField.widthAnchor.constraint(equalToConstant: 200)
        textFieldWidthConstraint.isActive = true
        view.addSubview(textField)
        
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("OK", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = UIColor.base
        submitButton.layer.borderWidth = 6
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.layer.cornerRadius = 32
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            
            titleLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -160),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            subtitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 84),
            segmentedControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -84),
            segmentedControl.heightAnchor.constraint(equalToConstant: 150),
            
            descriptionLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 24),
            descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            textField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 65),
            
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            submitButton.widthAnchor.constraint(equalToConstant: 170),
            submitButton.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    @objc func cancelButtonTapped() {
        addTransactionWrapper.isPresented = false
    }
    
    
    @objc func submitButtonTapped() {
        addTransactionWrapper.isPresented = false
        
        let categories = ["candy", "drink", "toy"]
        addTransactionWrapper.category = categories[segmentedControl.selectedSegmentIndex]
        if let text = textField.text, let amount = currencyFormatter.number(from: text)?.intValue {
            addTransactionWrapper.amount = amount
        }
    }
        
    @objc func textFieldDidChange(_ textField: UITextField) {
        let cleanedString = textField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? ""
        let amount = Double(cleanedString) ?? 0 / 100.0
        let formattedString = currencyFormatter.string(from: NSNumber(value: amount)) ?? "Rp0"

        textField.text = formattedString

        let textWidth = (textField.text as NSString?)?.size(withAttributes: [NSAttributedString.Key.font: textField.font!]).width ?? 0
        let padding: CGFloat = 40
        textFieldWidthConstraint.constant = (textWidth + padding) > 200 ? (textWidth + padding) : 200
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow backspace
        if string.isEmpty {
            return true
        }
        
        // Only allow numeric characters
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
    }
}
