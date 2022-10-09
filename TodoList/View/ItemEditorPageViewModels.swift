//
//  ItemEditorPageViewModels.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 06.10.2022.
//

import UIKit

protocol ItemEditorPageViewModelsDelegate: AnyObject {
    func switchDidChange()
    func priorityDidChange()
    func datePickerClicked()
    func dateChanged()
}

class ItemEditorPageViewModels: ThemeColors, Fonts {
    var appCoordinator: AppCoordinator?
    var delegate: ItemEditorPageViewModelsDelegate?
    
    private var deadlineIsOnContraints: [NSLayoutConstraint] = []
    private var deadlineIsOffContraints: [NSLayoutConstraint] = []
    private var showDatePickerConstraints: [NSLayoutConstraint] = []
    private var hideDatePickerConstraints: [NSLayoutConstraint] = []
    private var textViewHeightConstraints: [NSLayoutConstraint] = []
    
    private var constants = Constants()
    
    lazy var itemLabel: UILabel = {
        let l = UILabel()
        l.text = constants.itemLabelText
        l.textColor = labelPrimary
        l.font = headline
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var cancleButton: UIButton = {
        let b: UIButton = UIButton(type: .system)
        b.setTitle(constants.cancleButtonTitle, for: .normal)
        b.titleLabel?.font = body
        b.setTitleColor(blue, for: .normal)
        b.addTarget(self, action: #selector(cancleButtonPressed), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    lazy var saveButton: UIButton = {
        let b: UIButton = UIButton(type: .system)
        b.setTitle(constants.saveButtonTitle, for: .normal)
        b.titleLabel?.font = bodyBold
        b.setTitleColor(labelTertiary, for: .normal)
        b.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    lazy var topStackView: UIView = {
        let v = UIView()
        
        v.addSubview(cancleButton)
        v.addSubview(itemLabel)
        v.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            cancleButton.widthAnchor.constraint(equalToConstant: constants.buttonSize.width),
            cancleButton.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: constants.basePadding),
            cancleButton.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            
            itemLabel.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            itemLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            
            saveButton.widthAnchor.constraint(equalToConstant: constants.buttonSize.width),
            saveButton.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant:  -constants.basePadding),
            saveButton.centerYAnchor.constraint(equalTo: v.centerYAnchor),
        ])
        
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var inputTextView: UITextView = {
        let t = UITextView()
        t.font = body
        t.text = constants.textViewPlaceHolder
        t.textColor = labelTertiary
        t.backgroundColor = backSecondary
        t.autocorrectionType = .no
        t.layer.cornerRadius = constants.basePadding
        t.textContainerInset = constants.textViewInset
        t.isScrollEnabled = false
        textViewHeightConstraints.append(t.heightAnchor.constraint(equalToConstant: constants.textViewMinHeight))
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    lazy var priorityLabel: UILabel = {
        let l = UILabel()
        l.text = constants.priorityLabelText
        l.textColor = labelPrimary
        l.font = body
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var prioritySegments: UISegmentedControl = {
        let p = constants.prioritySegments
        let sc = UISegmentedControl(items: p)
        sc.selectedSegmentIndex = constants.baseSegment
        sc.setTitleTextAttributes([NSAttributedString.Key.font: subhead], for: .normal)
        sc.layer.cornerRadius = constants.basePadding
        sc.tintColor = backElevated
        sc.addTarget(self, action: #selector(handlePrioritySegments), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    lazy var deadlineLabel: UILabel = {
        let l = UILabel()
        l.text = constants.deadlineLabelText
        l.textColor = labelPrimary
        l.font = body
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var deadlineSwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = false
        s.addTarget(self, action: #selector(handleSwitchButton), for: .touchUpInside)
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    lazy var datePicker: UIDatePicker = {
        var dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .inline
        dp.date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        dp.isHidden = true
        dp.addTarget(self, action: #selector(handleDatePickerValue), for: .valueChanged)
        
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    lazy var dateLabelButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle(constants.dateLabelButtonTitle, for: .normal)
        b.setTitleColor(blue, for: .normal)
        b.titleLabel?.font = footnote
        b.addTarget(self, action: #selector(handleDateButton), for: .touchUpInside)
        b.isHidden = true
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    lazy var separator1: UIView = {
        let v = UIView()
        v.backgroundColor = backElevated
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var separator2: UIView = {
        let v = UIView()
        v.backgroundColor = backElevated
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var detailBox: UIView = {
        let v = UIView()
        v.backgroundColor = backSecondary
        v.layer.cornerRadius = constants.basePadding
        
        v.addSubview(priorityLabel)
        v.addSubview(prioritySegments)
        v.addSubview(separator1)
        v.addSubview(deadlineLabel)
        v.addSubview(deadlineSwitch)
        v.addSubview(separator2)
        v.addSubview(datePicker)
        v.addSubview(dateLabelButton)
        
        NSLayoutConstraint.activate([
            priorityLabel.topAnchor.constraint(equalTo: v.topAnchor, constant: constants.priorityLabelConstraints.top),
            priorityLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: constants.priorityLabelConstraints.lead),
            
            prioritySegments.topAnchor.constraint(equalTo: v.topAnchor, constant: constants.prioritySegmentsConstraints.top),
            prioritySegments.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: constants.prioritySegmentsConstraints.trail),
            prioritySegments.heightAnchor.constraint(equalToConstant: constants.prioritySegmentsConstraints.height),
            prioritySegments.widthAnchor.constraint(equalToConstant: constants.prioritySegmentsConstraints.width),
            
            separator1.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor, constant: constants.separatorConstraints.top),
            separator1.leadingAnchor.constraint(equalTo: v.safeAreaLayoutGuide.leadingAnchor, constant: constants.separatorConstraints.lead),
            separator1.trailingAnchor.constraint(equalTo: v.safeAreaLayoutGuide.trailingAnchor, constant: constants.separatorConstraints.trail),
            separator1.heightAnchor.constraint(equalToConstant: constants.separatorConstraints.height),
            
            deadlineLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: constants.basePadding),
            
            deadlineSwitch.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: constants.deadlineSwitchConstraints.top),
            deadlineSwitch.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: constants.deadlineSwitchConstraints.trail),
            deadlineSwitch.widthAnchor.constraint(equalToConstant: constants.deadlineSwitchConstraints.width),
            deadlineSwitch.heightAnchor.constraint(equalToConstant: constants.deadlineSwitchConstraints.height),
            
            separator2.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: constants.separatorConstraints.top),
            separator2.leadingAnchor.constraint(equalTo: v.safeAreaLayoutGuide.leadingAnchor, constant: constants.separatorConstraints.lead),
            separator2.trailingAnchor.constraint(equalTo: v.safeAreaLayoutGuide.trailingAnchor, constant: constants.separatorConstraints.trail),
            separator2.heightAnchor.constraint(equalToConstant: constants.separatorConstraints.height),
            
            datePicker.topAnchor.constraint(equalTo: separator2.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: v.safeAreaLayoutGuide.leadingAnchor, constant: constants.datePickerConstraints.lead),
            datePicker.trailingAnchor.constraint(equalTo: v.safeAreaLayoutGuide.trailingAnchor, constant: constants.datePickerConstraints.trail),
            
            dateLabelButton.bottomAnchor.constraint(equalTo: separator2.topAnchor, constant: constants.dateLabelButtonConstraintsButtom),
            dateLabelButton.leadingAnchor.constraint(equalTo: deadlineLabel.leadingAnchor),
        ])
        
        showDatePickerConstraints.append(v.bottomAnchor.constraint(equalTo: datePicker.bottomAnchor))
        hideDatePickerConstraints.append(v.bottomAnchor.constraint(equalTo: separator1.bottomAnchor, constant: constants.detailBoxButtomConstraint))
        deadlineIsOnContraints.append(deadlineLabel.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: constants.deadlineLabelTopConstraintOn))
        deadlineIsOffContraints.append(deadlineLabel.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: constants.deadlineLabelTopConstraintOff))
        
        checkForDeadLine()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var deleteButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle(constants.deleteButtonTitle, for: .normal)
        b.titleLabel?.font = body
        b.backgroundColor = backSecondary
        b.setTitleColor(labelTertiary, for: .normal)
        b.layer.cornerRadius = constants.basePadding
        b.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = backPrimary
        
        s.addSubview(inputTextView)
        s.addSubview(detailBox)
        s.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            inputTextView.topAnchor.constraint(equalTo: s.topAnchor, constant: constants.basePadding),
            inputTextView.leadingAnchor.constraint(equalTo: s.leadingAnchor, constant: constants.basePadding),
            
            detailBox.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: constants.basePadding),
            detailBox.leadingAnchor.constraint(equalTo: inputTextView.leadingAnchor),
            detailBox.trailingAnchor.constraint(equalTo: inputTextView.trailingAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: detailBox.bottomAnchor, constant: constants.basePadding),
            deleteButton.leadingAnchor.constraint(equalTo: detailBox.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: detailBox.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: constants.deleteButtonHeight)
        ])
        
        s.sizeToFit()
        
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
//    MARK: - func
    
    @objc func cancleButtonPressed() {
        appCoordinator?.dismissItemEditor()
    }
    
    @objc func handlePrioritySegments() {
        delegate?.priorityDidChange()
    }
    
    @objc func handleSwitchButton() {
        checkForDeadLine()
        delegate?.switchDidChange()
    }
    
    @objc func handleDatePickerValue() {
        delegate?.dateChanged()
        setDateLabelText()
    }
    
    @objc func saveButtonPressed() {
        if saveButton.titleLabel?.textColor == blue {
            appCoordinator?.saveItemChanges(
                text: inputTextView.text,
                priority: ItemPriority(rawValue: prioritySegments.selectedSegmentIndex) ?? .medium,
                deadline: deadlineSwitch.isOn ? datePicker.date : nil
            )
        }
    }
    
    @objc func handleDateButton() {
        if datePicker.isHidden {
            showDatePicker()
        } else {
            hideDatePicker()
        }
    }
    
    @objc func handleDeleteButton() {
        if deleteButton.titleLabel?.textColor == red {
            appCoordinator?.deleteItem()
        }
    }
    
    func showDatePicker() {
        for c in hideDatePickerConstraints { c.isActive = false }
        for c in showDatePickerConstraints { c.isActive = true }
        datePicker.isHidden = false
    }
    
    func hideDatePicker() {
        datePicker.isHidden = true
        for c in showDatePickerConstraints { c.isActive = false }
        for c in hideDatePickerConstraints { c.isActive = true }
    }
    
    func setDateLabelText() {
        let dateFormatter = DateFormatter()
        let deadline = datePicker.date
        
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ru")
        dateLabelButton.setTitle(dateFormatter.string(from: deadline), for: .normal)
    }
    
    func checkForDeadLine() {
        if deadlineSwitch.isOn {
            for c in deadlineIsOffContraints { c.isActive = false }
            for c in deadlineIsOnContraints { c.isActive = true }
            hideDatePicker()
            dateLabelButton.isHidden = false
            setDateLabelText()
        } else {
            for c in deadlineIsOnContraints { c.isActive = false }
            for c in deadlineIsOffContraints { c.isActive = true }
            hideDatePicker()
            dateLabelButton.isHidden = true
        }
    }
    
    func checkForHeightConstraints() {
        if inputTextView.intrinsicContentSize.height < constants.textViewMinHeight {
            textViewHeightConstraints[0].isActive = true
        } else {
            textViewHeightConstraints[0].isActive = false
        }
    }
    
    private struct Constants {
        let itemLabelText = "Дело"
        let cancleButtonTitle = "Отменить"
        let saveButtonTitle = "Сохранить"
        let deleteButtonTitle = "Удалить"
        
        let basePadding: CGFloat = 16
        let buttonSize = CGSize(width: 90, height: 0)
        
        let textViewPlaceHolder = "Что надо сделать"
        let textViewInset = UIEdgeInsets(top: 17, left: 16, bottom: 17, right: 16)
        let textViewMinHeight: CGFloat = 120
        
        let priorityLabelText = "Важность"
        let prioritySegments = ["↓", "нет", "‼️"]
        let baseSegment = 1
        
        let deadlineLabelText = "Сделать до"
        let dateLabelButtonTitle = "DD MONTH YYYY"
        
        let priorityLabelConstraints: (top: CGFloat, lead: CGFloat) = (17, 16)
        let prioritySegmentsConstraints: (top: CGFloat, trail: CGFloat, height: CGFloat, width: CGFloat) = (10,-12,36,150)
        let separatorConstraints: (top: CGFloat, lead: CGFloat, trail: CGFloat, height: CGFloat) = (57,16,-16,0.5)
        let deadlineSwitchConstraints: (top: CGFloat, trail: CGFloat, width: CGFloat, height: CGFloat) = (12.5,-12,51,31)
        let datePickerConstraints: (lead: CGFloat, trail: CGFloat) = (8,-8)
        let dateLabelButtonConstraintsButtom: CGFloat = -3
        
        let detailBoxButtomConstraint: CGFloat = 58
        let deadlineLabelTopConstraintOn: CGFloat = 9
        let deadlineLabelTopConstraintOff: CGFloat = 17
        
        let deleteButtonHeight: CGFloat = 56
    }
}
