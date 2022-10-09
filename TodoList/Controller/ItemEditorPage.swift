//
//  ItemEditorPage.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 06.10.2022.
//

import UIKit


class ItemEditorPageController: UIViewController, ThemeColors, Fonts {
    
    var appCoordinator: AppCoordinator?
    private(set) var todoItem: TodoItem
    var viewModels: ItemEditorPageViewModels
    private var constants = Constatns()
    
//  MARK: - LifeCycle
    init() {
        todoItem = TodoItem()
        viewModels = ItemEditorPageViewModels()
        super.init(nibName: nil, bundle: nil)
        
        viewModels.inputTextView.delegate = self
        viewModels.delegate = self
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backPrimary
        
        setupViews()
    }
    
//  MARK: - func
    func setItem(_ item: TodoItem) {
        todoItem = item
        setData()
    }
    
    func setData() {
        viewModels.inputTextView.text = todoItem.text.isEmpty ? constants.textViewPlaceHolder : todoItem.text
        viewModels.inputTextView.textColor = todoItem.text.isEmpty ? labelTertiary : labelPrimary
        
        viewModels.saveButton.setTitleColor(labelTertiary, for: .normal)
        viewModels.deleteButton.setTitleColor((todoItem.text.isEmpty ? labelTertiary : red), for: .normal)

        viewModels.prioritySegments.selectedSegmentIndex = todoItem.priority.rawValue
        if let deadline = todoItem.deadline {
            viewModels.deadlineSwitch.isOn = true
            viewModels.datePicker.date = deadline
        } else {
            viewModels.deadlineSwitch.isOn = false
        }
        viewModels.checkForDeadLine()
        viewModels.checkForHeightConstraints()
    }
    
    func checkForChanges() {
        let text = viewModels.inputTextView.text ?? todoItem.text
        let textColor = viewModels.inputTextView.textColor
        let priority = ItemPriority(rawValue: viewModels.prioritySegments.selectedSegmentIndex)
        let deadline: Date? = viewModels.deadlineSwitch.isOn ? viewModels.datePicker.date : nil
        
        if (textColor != labelTertiary && !text.isEmpty) && (text != todoItem.text || priority != todoItem.priority || deadline != todoItem.deadline) {
            viewModels.saveButton.setTitleColor(blue, for: .normal)
        } else {
            viewModels.saveButton.setTitleColor(labelTertiary, for: .normal)
        }
    }
    
    private func setupViews() {
        let stackView = viewModels.topStackView
        view.addSubview(stackView)
        
        let scrollView = viewModels.scrollView
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: constants.stackViewSize.height),
            
            scrollView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: viewModels.deleteButton.bottomAnchor, constant: constants.basePadding),
            
            viewModels.inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constants.basePadding)
        ])
    }
}

extension ItemEditorPageController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkForChanges()
        viewModels.checkForHeightConstraints()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if viewModels.inputTextView.textColor == labelTertiary {
            viewModels.inputTextView.text = ""
            viewModels.inputTextView.textColor = labelPrimary
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if viewModels.inputTextView.text == "" {
            viewModels.inputTextView.text = constants.textViewPlaceHolder
            viewModels.inputTextView.textColor = labelTertiary
        }
    }
    
    private struct Constatns {
        let textViewPlaceHolder: String = "Что надо сделать"
        let stackViewSize = CGSize(width: 0, height: 56)
        let basePadding: CGFloat = 16
    }
}

extension ItemEditorPageController: ItemEditorPageViewModelsDelegate {
    func switchDidChange() {
        checkForChanges()
    }
    
    func priorityDidChange() {
        checkForChanges()
    }
    
    func datePickerClicked() {
        checkForChanges()
    }
    
    func dateChanged() {
        checkForChanges()
    }
}
