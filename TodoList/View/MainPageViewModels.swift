//
//  MainPageViewModels.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 01.10.2022.
//

import UIKit


class MainPageViewModels: ThemeColors, Fonts {
    var appCoordinator: AppCoordinator?
    private let constants = Constants()
    
    lazy var doneCountLabel: UILabel = {
        let l = UILabel()
        l.text = ""
        l.textColor = labelTertiary
        l.font = subhead
        
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var hideAndShowButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle(getTitle(), for: .normal)
        b.titleLabel?.font = subheadBold
        b.addTarget(self, action: #selector(handleDoneToggleButton), for: .touchUpInside)
        
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    lazy var doneInfoView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.addSubview(doneCountLabel)
        v.addSubview(hideAndShowButton)

        NSLayoutConstraint.activate([
            doneCountLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: constants.basePadding),
            doneCountLabel.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -constants.doneCountLabelBottomConstraint),
            
            hideAndShowButton.centerYAnchor.constraint(equalTo: doneCountLabel.centerYAnchor),
            hideAndShowButton.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -constants.basePadding),
            hideAndShowButton.widthAnchor.constraint(equalToConstant: constants.hideAndShowButtomSize.width),
            
            doneCountLabel.trailingAnchor.constraint(equalTo: hideAndShowButton.leadingAnchor)
        ])
        
        return v
    }()
    
    
    lazy var todoListTableView: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.backgroundColor = .clear
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    
    lazy var addNewItemButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(constants.newItemButtonImage, for: .normal)
        b.layer.cornerRadius = constants.newItemButtonCornerRadius
//        b.layer.shadowColor = UIColor(red: 0, green: 73.0/255.0, blue: 153.0/255, alpha: 1).cgColor
        b.layer.shadowColor = blue.cgColor
        b.layer.shadowOffset = constants.newItemButtonShadowOffset
        b.layer.shadowRadius = constants.newItemButtonShadowRadius
        b.layer.shadowOpacity = constants.newItemButtonShadowOpacity
        b.addTarget(self, action: #selector(handleAddNewItemButton), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
//  MARK: - objc
    @objc func handleDoneToggleButton(btn: UIButton) {
        if let appCoordinator = appCoordinator {
            appCoordinator.toggleDoneButton()
            if appCoordinator.isDoneShown { btn.setTitle(getTitle(), for: .normal) }
            else { btn.setTitle(getTitle(), for: .normal) }
        }
    }
    
    @objc func handleAddNewItemButton(btn: UIButton) {
        appCoordinator?.presentItemEditor()
    }
    
//  MARK: - func
    
    private func getTitle() -> String {
        if let appCoordinator = appCoordinator {
            if appCoordinator.isDoneShown { return constants.hideText }
            return constants.showText
        }
        return constants.buttontext
    }
    
    
    private struct Constants {
        let basePadding: CGFloat = 16
        let doneCountLabelBottomConstraint: CGFloat = 12
        let hideAndShowButtomSize = CGSize(width: 75, height: 0)
        
        let newItemButtonImage = UIImage(named: "plusButton")!
        let newItemButtonCornerRadius: CGFloat = 22
        let newItemButtonShadowRadius: CGFloat = 20
        let newItemButtonShadowOffset = CGSize(width: 0, height: 8)
        let newItemButtonShadowOpacity: Float = 0.6
        
        let hideText = "Скрыть"
        let showText = "Показать"
        let buttontext = "button"
    }
}

