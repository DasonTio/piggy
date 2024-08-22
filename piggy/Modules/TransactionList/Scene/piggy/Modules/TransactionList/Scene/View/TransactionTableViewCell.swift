//
//  TransactionTableViewCell.swift
//  piggy
//
//  Created by Eric Fernando on 21/08/24.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    var dateLabel = UILabel()
    var categoryLabel = UILabel()
    var iconView = UIImageView()
    var transactionLabel = UILabel()
    var balanceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        
        addSubview(dateLabel)
        addSubview(categoryLabel)
        addSubview(iconView)
        addSubview(transactionLabel)
        addSubview(balanceLabel)
        
        configurationLabel()
        configureIconView()
        setDateLabelConstraints()
        setCategoryLabel()
        setIconViewConstraints()
        setTransactionLabelConstraints()
        setBalanceLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(transactionListEntity: TransactionListEntity){
        dateLabel.text = "14/08"
        categoryLabel.text = "Toy"
        transactionLabel.text = "+ Rp75.000"
        balanceLabel.text = "Rp425.000"
        iconView.image = UIImage(named: "happyIcon")
    }
    
    func configurationLabel() {
        dateLabel.numberOfLines = 0
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.boldSystemFont(ofSize: 28)
        dateLabel.textColor = UIColor.shade2
        
        categoryLabel.numberOfLines = 0
        categoryLabel.adjustsFontSizeToFitWidth = true
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 28)
        categoryLabel.textColor = UIColor.shade2
        
        transactionLabel.numberOfLines = 0
        transactionLabel.adjustsFontSizeToFitWidth = true
        transactionLabel.textAlignment = .center
        transactionLabel.font = UIFont.boldSystemFont(ofSize: 28)
        transactionLabel.textColor = UIColor.greenIncome
        
        
        balanceLabel.numberOfLines = 0
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.textAlignment = .center
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 28)
        balanceLabel.textColor = UIColor.shade2
    }
    
    func configureIconView() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = UIColor.shade2
    }
    
    func setDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13)
        ])
    }
    
    func setCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 0),
            categoryLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
        ])
    }
    
    func setIconViewConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 0),
            iconView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.08),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)  // Make the icon square
        ])
    }
    
    func setTransactionLabelConstraints() {
        transactionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            transactionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 0),
            transactionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
        ])
    }
    
    func setBalanceLabelConstraints() {
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            balanceLabel.leadingAnchor.constraint(equalTo: transactionLabel.trailingAnchor, constant: 0),
            balanceLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
        ])
    }
}
