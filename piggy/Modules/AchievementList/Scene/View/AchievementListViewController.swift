//
//  AchievementViewController.swift
//  piggy
//
//  Created by Dason Tiovino on 19/08/24.
//

import UIKit
import Combine

class AchievementListViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: AchievementListViewModel!
    
    @IBOutlet weak var stickerSide: UIView!
    @IBOutlet weak var achievementSide: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblErrorMessage: UILabel!
//    @IBOutlet weak var viewError: UIView!
    
    private let refreshControl = UIRefreshControl()
    private var toast: LoadingToast?
    
    private var achievementList: [AchievementListEntity] = []
    
    
    // MARK: - Publisher
    private let didLoadPublisher = PassthroughSubject<Void, Never>()
    private let didTapRewardButtonPublisher = PassthroughSubject<String, Never>()
    private let didTapAddAchievementListPublisher = PassthroughSubject<Void, Never>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: AchievementListViewController.nibName(), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    // MARK: - Initialization Method
    static func create(
        with viewModel: AchievementListViewModel
    ) -> AchievementListViewController {
        let vc = AchievementListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        didLoadPublisher.send()
    }
    
    private func bindViewModel() {
        let input = AchievementListViewModel.Input(
            didLoad: didLoadPublisher,
            didTapRewardButton: didTapRewardButtonPublisher,
            didTapAddAchievementList: didTapAddAchievementListPublisher
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
                case .failed(let reason):
                    self.lblErrorMessage.text = reason.toResponseError().errorMessage
                    
                    hideLoading()
                    self.refreshControl.endRefreshing()
//                    self.viewError.isHidden = false
                case .success(let data):
                    self.achievementList = data
                    self.tableView.reloadData()
                    
                    hideLoading()
                    self.refreshControl.endRefreshing()
//                    self.viewError.isHidden = true
                case .loading:
                    showLoading()
                default:
                    return
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.$addAchievement
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] result in
                guard let self = self else { return }
                switch result{
                case .failed(let reason):
                    hideLoading()
                    let alertController = UIAlertController(title: "Failed Add Note", message: reason.toResponseError().errorMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                        self?.viewModel.output.result = .loading
                        self?.didLoadPublisher.send()
                        alertController.dismiss(animated: true)
                    })
                    alertController.addAction(okAction)
                    present(alertController, animated: true)
                case .success(_):
                    didLoadPublisher.send()
                    hideLoading()
                case .loading:
                    showLoading()
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupView() {
        // Configure tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: AchievementListTableViewCell.nibName(), bundle: nil),
            forCellReuseIdentifier: AchievementListTableViewCell.cellIdentifier
        )
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
//        viewError.isHidden = true
        
        // MARK: Left and Right Side
        setupStickerSide()
        
    }
    
    func setupStickerTitle() -> UIView {
        let titleView = UIView()
        titleView.layer.cornerRadius = 25.0
        titleView.layer.borderWidth = 5.0
        titleView.layer.borderColor = UIColor.white.cgColor
        
        let label = UILabel()
        label.text = "Sticker"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            label.topAnchor.constraint(equalTo: titleView.topAnchor),
            label.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
        
        return titleView
    }
    
    func setupStickerContent() -> UIView{
        let stickerView = UIView()
        stickerView.layer.cornerRadius = 25.0
        stickerView.layer.borderWidth = 5.0
        stickerView.layer.borderColor = UIColor.white.cgColor
        
        let stickerViewContent = UIView()
        
        let stickerBackground = UIImageView()
        stickerBackground.image = UIImage(named: "StickerBackground")
        stickerBackground.contentMode = .scaleAspectFill
        
        stickerViewContent.addSubview(stickerBackground)
        stickerViewContent.sendSubviewToBack(stickerBackground)
        stickerView.addSubview(stickerViewContent)
        
        return stickerView
    }
    
    private func setupStickerSide(){
        let blockWidth = stickerSide.frame.width / 100
        let blockHeight = stickerSide.frame.height / 100
        
        // Stack View
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: blockHeight * 5,
            left: 20,
            bottom: blockHeight * 5,
            right: blockWidth * 15
        )
        
        // Title View
        let titleView = setupStickerTitle()
        stackView.addArrangedSubview(titleView)
        
        // Sticker View
        let stickerView = setupStickerContent()
        stackView.addArrangedSubview(stickerView)
        
        // Append All Views
        stickerSide.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: stickerSide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: stickerSide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: stickerSide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: stickerSide.bottomAnchor)
        ])
        
        titleView.heightAnchor.constraint(
            equalTo: stackView.heightAnchor,
            multiplier: 0.2).isActive = true
        
        stickerView.heightAnchor.constraint(
            equalTo: stackView.heightAnchor,
            multiplier: 0.7).isActive = true
    }
    
    
    @IBAction func didTapAddNewAchievementList(_ sender: Any) {
        viewModel.output.result = .loading
        didTapAddAchievementListPublisher.send()
    }
    
    @objc
    private func refresh() {
//        viewError.isHidden = true
        didLoadPublisher.send()
    }
    
    private func showLoading() {
        self.toast = LoadingToast()
        self.toast?.show(in: self.view)
//        self.viewError.isHidden = true
    }
    
    private func hideLoading() {
        self.toast?.hide()
    }
    
}

extension AchievementListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievementList.count >= 10 ? 10 : achievementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "AchievementListTableViewCell",
            for: indexPath
        ) as! AchievementListTableViewCell
        
        let achievement = achievementList[indexPath.row]
        cell.setText(
            text: achievement.title,
            indexPath: indexPath,
            delegate: self)
        
        return cell
    }
    
    // TODO: Update the value to be similar as the height in figma
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 55
    }
}

// MARK: - Function for Table Cell
extension AchievementListViewController: AchievementListTableViewCellDelegate {
    func didTapRewardButton(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        didTapRewardButtonPublisher.send(achievementList[indexPath.row].id)
        tableView.reloadData()
    }
}
