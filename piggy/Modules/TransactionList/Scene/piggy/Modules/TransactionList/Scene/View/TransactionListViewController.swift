//
//  TransactionViewController.swift
//  piggy
//
//  Created by Eric Fernando on 19/08/24.
//

import UIKit
import Combine

internal class TransactionListViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: TransactionListViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    @Published internal var addTransactionWrapper: AddTransactionWrapper = .init()
        
    var transactionList: [TransactionListEntity] = []
    var tableView: UITableView!
    
    // MARK: - Publisher
    private let didLoadPublisher = PassthroughSubject<Void, Never>()
    private let didAddNewTransaction = PassthroughSubject<SaveTransactionListRequest, Never>()
    
    // MARK: - Initialization Method
    static func create(
        with viewModel: TransactionListViewModel
    ) -> TransactionListViewController {
        let vc = TransactionListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemPink
        title = "Transaction Page"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupUI()
        bindViewModel()
        bindEnvironmentObject()
        didLoadPublisher.send()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    // MARK: - Bind View Model
    private func bindViewModel() {
        let input = TransactionListViewModel.Input(
            didLoad: didLoadPublisher,
            didAddNewTransaction: didAddNewTransaction
        )
        viewModel.bind(input)
        bindViewModelOutput()
    }
    
    private func bindViewModelOutput() {
        viewModel.output.$result
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failed(_):
                    return
                case .success(let data):
                    self.transactionList = data
                    tableView.reloadData()
                    return
                case .loading:
                    return
                default:
                    return
                }
            }
            .store(in: &cancellables)

        viewModel.output.$addTransaction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .failed(_):
                    return
                case .success(_):
                    return
                case .loading:
                    return
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    internal func bindEnvironmentObject() {
        addTransactionWrapper.$amount.sink { [weak self] amount in
            guard let self = self, let amount = amount else { return }
            
            
            guard let category = self.addTransactionWrapper.category else { return }
            
            let id = UUID().uuidString
            transactionList.append(.init(id: id, date: Date(), category: category, amount: amount))
            didAddNewTransaction.send(.init(date: Date(), category: category, amount: amount))
            tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    func setupUI() {
        
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        

        let leftContainerView = UIView()
        leftContainerView.backgroundColor = UIColor.tint2
        leftContainerView.layer.borderWidth = 6
        leftContainerView.layer.borderColor = UIColor.white.cgColor
        leftContainerView.layer.cornerRadius = 25
        leftContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftContainerView)

        // Constraints for left container
        NSLayoutConstraint.activate([
            leftContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            leftContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            leftContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            leftContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
        ])

        // Piggy bank image
        let piggyBankImageView = UIImageView()
        piggyBankImageView.image = UIImage(named: "piggyBank") // Add the piggy bank image here
        piggyBankImageView.contentMode = .scaleAspectFit
        piggyBankImageView.translatesAutoresizingMaskIntoConstraints = false
        leftContainerView.addSubview(piggyBankImageView)

        // Constraints for piggy bank
        NSLayoutConstraint.activate([
            piggyBankImageView.topAnchor.constraint(equalTo: leftContainerView.topAnchor, constant: 65),
            piggyBankImageView.leadingAnchor.constraint(equalTo: leftContainerView.leadingAnchor, constant: 30),
            piggyBankImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.18),
            piggyBankImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.48)
        ])
        
        let shieldView = UIView()
        shieldView.backgroundColor = UIColor.tint2
        shieldView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shieldView)

        // Constraints for shieldView
        NSLayoutConstraint.activate([
            shieldView.centerXAnchor.constraint(equalTo: leftContainerView.centerXAnchor),
            shieldView.topAnchor.constraint(equalTo: piggyBankImageView.topAnchor, constant: 270),
            shieldView.leftAnchor.constraint(equalTo: leftContainerView.leftAnchor, constant: 30),
            shieldView.rightAnchor.constraint(equalTo: leftContainerView.rightAnchor, constant: -30),
            shieldView.heightAnchor.constraint(equalTo: leftContainerView.heightAnchor, multiplier: 0.48)
        ])
        
        shieldView.layoutIfNeeded()
        
        let shieldPath = UIBezierPath()
        let width = shieldView.frame.width
        let height = shieldView.frame.height

        shieldPath.move(to: CGPoint(x: 0, y: 0))
        shieldPath.addLine(to: CGPoint(x: width, y: 0))
        shieldPath.addLine(to: CGPoint(x: width, y: height * 0.75))
        shieldPath.addLine(to: CGPoint(x: width / 2, y: height))
        shieldPath.addLine(to: CGPoint(x: 0, y: height * 0.75))
        shieldPath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shieldPath.cgPath
        shieldView.layer.mask = shapeLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = shieldPath.cgPath
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 8
        shieldView.layer.addSublayer(borderLayer)
        
        let insetAmount: CGFloat = 12.0
        let insetShieldPath = UIBezierPath()
        insetShieldPath.move(to: CGPoint(x: insetAmount, y: insetAmount))
        insetShieldPath.addLine(to: CGPoint(x: width - insetAmount, y: insetAmount))
        insetShieldPath.addLine(to: CGPoint(x: width - insetAmount, y: height * 0.75 - 8))
        insetShieldPath.addLine(to: CGPoint(x: width / 2, y: height - insetAmount))
        insetShieldPath.addLine(to: CGPoint(x: insetAmount, y: height * 0.75 - 8))
        insetShieldPath.close()

        // Add the dashed border layer inside
        let borderDash = CAShapeLayer()
        borderDash.path = insetShieldPath.cgPath
        borderDash.strokeColor = UIColor.tint1.cgColor
        borderDash.fillColor = UIColor.clear.cgColor
        borderDash.lineWidth = 3
        borderDash.lineDashPattern = [6, 3]
        shieldView.layer.addSublayer(borderDash)
        
        let titleLabel = UILabel()
        titleLabel.text = "Pocket Money"
        titleLabel.font = UIFont.systemFont(ofSize: 28)
        titleLabel.textColor = UIColor.shade2
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        shieldView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: shieldView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: shieldView.topAnchor, constant: 24),
        ])
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "You can buy 10 candies"
        subtitleLabel.font = UIFont.systemFont(ofSize: 17)
        subtitleLabel.textColor = UIColor.shade2
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        shieldView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: shieldView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
        ])
        
        let candyStackView = UIStackView()
        candyStackView.axis = .vertical
        candyStackView.alignment = .center
        candyStackView.spacing = 0
        candyStackView.translatesAutoresizingMaskIntoConstraints = false
        shieldView.addSubview(candyStackView)

        for _ in 0..<2 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .center
            rowStackView.spacing = 0

            // Add candies to each row
            for _ in 0..<5 {
                let candyImageView = UIImageView()
                candyImageView.image = UIImage(named: "candy") // Use your candy image here
                candyImageView.contentMode = .scaleAspectFit
                candyImageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
                candyImageView.heightAnchor.constraint(equalToConstant: 67).isActive = true
                rowStackView.addArrangedSubview(candyImageView)
            }

            candyStackView.addArrangedSubview(rowStackView)
        }

        NSLayoutConstraint.activate([
            candyStackView.centerXAnchor.constraint(equalTo: shieldView.centerXAnchor),
            candyStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
        ])
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.tint2
        containerView.layer.cornerRadius = 25
        containerView.layer.borderWidth = 6
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        let titleMoneyLabel = UILabel()
        titleMoneyLabel.text = "Pocket Money:"
        titleMoneyLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleMoneyLabel.textColor = UIColor.shade2
        titleMoneyLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleMoneyLabel)
        
        let amountLabel = UILabel()
        amountLabel.text = "Rp500.000"
        amountLabel.font = UIFont.boldSystemFont(ofSize: 34)
        amountLabel.textColor = UIColor.shade2
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(amountLabel)

        let addButton = UIButton(type: .custom)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        containerView.addSubview(addButton)

        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 34, weight: .bold, scale: .large)
        let plusImage = UIImage(systemName: "plus.square.fill", withConfiguration: symbolConfiguration)
        addButton.setImage(plusImage, for: .normal)
        addButton.tintColor = UIColor.base
        addButton.layer.borderColor = UIColor.white.cgColor
        addButton.layer.borderWidth = 4
        addButton.layer.cornerRadius = 12
                
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            containerView.heightAnchor.constraint(equalToConstant: 125),
            
            titleMoneyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleMoneyLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            amountLabel.leadingAnchor.constraint(equalTo: titleMoneyLabel.trailingAnchor, constant: 16),
            amountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            addButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        
        let tableContainerView = UIView()
        tableContainerView.backgroundColor = UIColor.tint2
        tableContainerView.layer.cornerRadius = 25
        tableContainerView.layer.borderWidth = 6
        tableContainerView.layer.borderColor = UIColor.white.cgColor
        tableContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableContainerView)
        
        NSLayoutConstraint.activate([
            tableContainerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32),
            tableContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            tableContainerView.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor, constant: 32),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        let dateLabel = UILabel()
        dateLabel.text = "Date"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 28)
        dateLabel.textColor = UIColor.shade2
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .center
        tableContainerView.addSubview(dateLabel)
        
        let categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 28)
        categoryLabel.textColor = UIColor.shade2
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textAlignment = .center
        tableContainerView.addSubview(categoryLabel)
        
        let transactionLabel = UILabel()
        transactionLabel.text = "Transaction"
        transactionLabel.font = UIFont.boldSystemFont(ofSize: 28)
        transactionLabel.textColor = UIColor.shade2
        transactionLabel.translatesAutoresizingMaskIntoConstraints = false
        transactionLabel.textAlignment = .center
        tableContainerView.addSubview(transactionLabel)
        
        let balanceLabel = UILabel()
        balanceLabel.text = "Balance"
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 28)
        balanceLabel.textColor = UIColor.shade2
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.textAlignment = .center
        tableContainerView.addSubview(balanceLabel)
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.white
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        tableContainerView.addSubview(bottomBorder)
        
//        transactionList = fetchData()
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: tableContainerView.topAnchor, constant: 18),
            dateLabel.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor, constant: 32),
            dateLabel.widthAnchor.constraint(equalTo: tableContainerView.widthAnchor, multiplier: 0.15),
            
            categoryLabel.topAnchor.constraint(equalTo: tableContainerView.topAnchor, constant: 18),
            categoryLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 0),
            categoryLabel.widthAnchor.constraint(equalTo: tableContainerView.widthAnchor, multiplier: 0.2),
                        
            transactionLabel.topAnchor.constraint(equalTo: tableContainerView.topAnchor, constant: 18),
            transactionLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 0),
            transactionLabel.widthAnchor.constraint(equalTo: tableContainerView.widthAnchor, multiplier: 0.3),
            
            balanceLabel.topAnchor.constraint(equalTo: tableContainerView.topAnchor, constant: 18),
            balanceLabel.leadingAnchor.constraint(equalTo: transactionLabel.trailingAnchor, constant: 0),
            balanceLabel.widthAnchor.constraint(equalTo: tableContainerView.widthAnchor, multiplier: 0.25),
            
            bottomBorder.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            bottomBorder.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            bottomBorder.heightAnchor.constraint(equalToConstant: 5),
            
            tableView.topAnchor.constraint(equalTo: bottomBorder.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc func addButtonTapped() {
        addTransactionWrapper.isPresented = true
    }
}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as! TransactionTableViewCell
        
        let transactionListEntity = transactionList[indexPath.row]
        cell.set(transactionListEntity: transactionListEntity)
        
        return cell
    }
}

