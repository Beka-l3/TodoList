//
//  ViewController.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 01.10.2022.
//

import UIKit

class MainPageController: UIViewController, ThemeColors, Fonts {
    
    var appCoordinator: AppCoordinator?
    var data: [TodoItem]
    internal var doneAmount: Int {
        get {
            if let appCoordinator = appCoordinator {
                return appCoordinator.doneCount
            }
            return 0
        }
    }
    
    internal var viewModels: MainPageViewModels
    internal let tableView: UITableView
    internal lazy var constants: MainPageViewConstants = {
        return MainPageViewConstants(headerViewWidth: view.frame.width - 32)
    }()
    
    init(data d: [TodoItem]) {
        data = d
        viewModels = MainPageViewModels()
        tableView  = viewModels.todoListTableView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
//    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backIosPrimary
        
        setNavigationItem()
        setupViews()
        setupTabelView()
    }
    
//    MARK: - func
    func setupViews() {
        view.addSubview(tableView)
        
        let addButton = viewModels.addNewItemButton
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constants.basicPadding),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constants.basicPadding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: constants.addButtonSize),
            addButton.widthAnchor.constraint(equalToConstant: constants.addButtonSize),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -constants.addButtonBottomPadding)
        ])
    }
    
    func setNavigationItem() {
        navigationItem.title = constants.navigationTitleText
        navigationController?.navigationBar.backgroundColor = backIosPrimary
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = supportNavBarBlur
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : labelPrimary, NSAttributedString.Key.font: bodyBold]
            
            let p = NSMutableParagraphStyle()
            p.firstLineHeadIndent = constants.basicPadding
            
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : labelPrimary, NSAttributedString.Key.paragraphStyle: p]
            navigationController?.navigationBar.standardAppearance = appearance
        }
    }
    
    func setupTabelView() {
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: constants.reusableCellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    func reloadData() {
        data = appCoordinator?.getData() ?? []
        
        updateDoneLabel()
        tableView.reloadData()
    }
    
    func updateDoneLabel() {
        viewModels.doneCountLabel.text = constants.doneCountLabelText + " - \(doneAmount)"
    }
    
    internal struct MainPageViewConstants {
        let reusableCellId: String = "TodoItemTableViewCell"
        let navigationTitleText: String = "Мои дела"
        let doneCountLabelText: String = "Выполнено"
        
        let headerViewHeight: CGFloat = 32
        let headerViewWidth: CGFloat?
        
        let tableViewCellHeight1: CGFloat = 66
        let tableViewCellHeight2: CGFloat = 76
        let tableViewCellHeight3: CGFloat = 98
        
        let basicPadding: CGFloat = 16
        
        let addButtonSize: CGFloat = 44
        let addButtonBottomPadding: CGFloat = 27
        
        let maxCharsInCellLabel: Double = 30
        
        let doneSwipeImageName: String = "doneSwipe"
        let deleteSwipeImageName: String = "deleteSwipe"
        let editSwipeImageName: String = "editSwipe"
    }
}
