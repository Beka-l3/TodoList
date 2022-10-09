//
//  TodoItemTableViewCell.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 02.10.2022.
//

import UIKit


class TodoItemTableViewCell: UITableViewCell, ThemeColors, Fonts {
    
    var appCoordinator: AppCoordinator?
    
    private var _todoItem: TodoItem?
    var todoItem: TodoItem {
        get {
            if let item = _todoItem { return item }
            else { return TodoItem() }
        }
        set { _todoItem = newValue }
    }
    
    var highStateOnConstraints: [NSLayoutConstraint] = []
    var highStateOffConstraints: [NSLayoutConstraint] = []
    var deadLineOnConstraints: [NSLayoutConstraint] = []
    var deadLineOffConstraints: [NSLayoutConstraint] = []
    
    private let constants = Constants()
    
    var leftIconImage: UIImage {
        get {
            if todoItem.isDone { return constants.doneStateImage }
            else if todoItem.priority == .high { return constants.hightStateImage }
            return constants.normalStateImage.withTintColor(supportSeparator)
        }
    }
    var todoTextColor: UIColor { get { todoItem.isDone ? labelTertiary : labelPrimary } }
    
    lazy var todoText: UILabel = {
        let l = UILabel()
        l.font = body
        l.lineBreakMode = .byTruncatingTail
        l.numberOfLines = .zero
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var leftIcon: UIButton = {
        let b = UIButton(type: .system)
        b.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    lazy var disclosureIndecator: UIImageView = {
        let i = UIImageView()
        i.image = constants.disclosureIndicatorImage.withTintColor(supportSeparator)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    lazy var separtorLine: UIView = {
        let v = UIView()
        v.backgroundColor = supportSeparator
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var deadlineLabel: UILabel = {
        let l = UILabel()
        l.text = ""
        l.font = subhead
        l.textColor = labelTertiary
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var highStateIcon: UIImageView = {
        let i = UIImageView()
        i.image = constants.highStateIconImage
        i.isHidden = true
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    
//  MARK: - init, lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = backSecondary
        contentView.isUserInteractionEnabled = true
        setupViews()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
//  MARK: - objc
    @objc func handleButton(btn: UIButton) {
        todoItem.isDone.toggle()
        appCoordinator?.itemDone(with: todoItem.id, item: todoItem)
//        checkForIsDoneStyle()
    }
    
    
//  MARK: - func
    private func setupViews() {
        contentView.addSubview(leftIcon)
        addSubview(todoText)
        addSubview(disclosureIndecator)
        addSubview(separtorLine)
        addSubview(deadlineLabel)
        addSubview(highStateIcon)
        
        NSLayoutConstraint.activate([
            leftIcon.heightAnchor.constraint(equalToConstant: constants.leftIconSize.height),
            leftIcon.widthAnchor.constraint(equalToConstant: constants.leftIconSize.width),
            leftIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constants.basePadding),
            leftIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            disclosureIndecator.widthAnchor.constraint(equalToConstant: constants.disclosureSize.width),
            disclosureIndecator.heightAnchor.constraint(equalToConstant: constants.disclosureSize.height),
            disclosureIndecator.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -constants.basePadding),
            disclosureIndecator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            highStateIcon.widthAnchor.constraint(equalToConstant: constants.highStateIconSize.width),
            highStateIcon.heightAnchor.constraint(equalToConstant: constants.highStateIconSize.height),
            highStateIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            highStateIcon.leadingAnchor.constraint(equalTo: leftIcon.trailingAnchor, constant: constants.basePadding),
            
            todoText.trailingAnchor.constraint(equalTo: disclosureIndecator.leadingAnchor, constant: -constants.basePadding),
            todoText.topAnchor.constraint(equalTo: topAnchor, constant: constants.basePadding),
            
            deadlineLabel.leadingAnchor.constraint(equalTo: todoText.leadingAnchor),
            deadlineLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constants.basePadding),
            deadlineLabel.heightAnchor.constraint(equalToConstant: constants.deadlineLabelSize.height),
            
            separtorLine.leadingAnchor.constraint(equalTo: highStateIcon.leadingAnchor),
            separtorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separtorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separtorLine.heightAnchor.constraint(equalToConstant: constants.separatorSize.height)
        ])
        
        highStateOnConstraints = [ todoText.leadingAnchor.constraint(equalTo: highStateIcon.trailingAnchor, constant: constants.todoTextHighStateOnConstraint) ]
        highStateOffConstraints = [todoText.leadingAnchor.constraint(equalTo: leftIcon.trailingAnchor, constant: constants.todoTextHighStateOffConstraint)]
        deadLineOffConstraints = [ todoText.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -constants.basePadding) ]
        deadLineOnConstraints = [ todoText.bottomAnchor.constraint(equalTo: deadlineLabel.topAnchor) ]
//        reloadData()
    }
    
    private func checkForIsDoneStyle() {
        leftIcon.setImage(leftIconImage, for: .normal)
        todoText.textColor = todoTextColor
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: todoItem.text)
        if todoItem.isDone {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        }
        todoText.attributedText = attributeString
    }
    
    private func checkForDeadline() {
        if let deadLine = todoItem.deadline {
            for c in deadLineOffConstraints { c.isActive = false }
            for c in deadLineOnConstraints { c.isActive = true }
            let date = convertDate(date: deadLine)
            deadlineLabel.text = "🗓 \(date)"
            deadlineLabel.isHidden = false
        } else {
            for c in deadLineOnConstraints { c.isActive = false }
            for c in deadLineOffConstraints { c.isActive = true }
            deadlineLabel.isHidden = true
        }
    }
    
    private func checkForPriority() {
        if todoItem.priority == .high {
            for c in highStateOffConstraints { c.isActive = false }
            for c in highStateOnConstraints { c.isActive = true }
            highStateIcon.isHidden = false
        } else {
            for c in highStateOnConstraints { c.isActive = false }
            for c in highStateOffConstraints { c.isActive = true }
            highStateIcon.isHidden = true
        }
    }
    
    func reloadData(isZero: Bool) {
        leftIcon.isHidden = isZero
        deadlineLabel.isHidden = isZero
        disclosureIndecator.isHidden = isZero
        highStateIcon.isHidden = isZero
        
        checkForIsDoneStyle()
        checkForDeadline()
        checkForPriority()
        
        if isZero {
            todoText.text = constants.lastRowCellText
            todoText.textColor = labelTertiary
        }
    }
    
    private func convertDate(date d: Date) -> String {
        let dateFormatter = DateFormatter()
//        let deadline = todoItem.deadline ?? Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ru")
        return dateFormatter.string(from: d)
    }
    
    
    private struct Constants {
        let doneStateImage = UIImage(named: "doneState")!
        let hightStateImage = UIImage(named: "highState")!
        let normalStateImage = UIImage(named: "normalState")!
        let disclosureIndicatorImage = UIImage(named: "disclosureIndicator")!
        let highStateIconImage = UIImage(named: "highStateIcon")!
        
        let lastRowCellText: String = "Новое"
        
        let basePadding: CGFloat = 16
        let leftIconSize = CGSize(width: 24, height: 24)
        let disclosureSize = CGSize(width: 6.95, height: 11.9)
        let highStateIconSize = CGSize(width: 10, height: 16)
        let deadlineLabelSize = CGSize(width: 0, height: 20)
        let separatorSize = CGSize(width: 0, height: 0.5)
        let todoTextHighStateOnConstraint: CGFloat = 5
        let todoTextHighStateOffConstraint: CGFloat = 12
    }
}


