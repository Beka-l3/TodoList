//
//  MainPageTableViewExtension.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 02.10.2022.
//

import UIKit

extension MainPageController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: constants.reusableCellId, for: indexPath) as! TodoItemTableViewCell
        cell.appCoordinator = appCoordinator
        
        if indexPath.row == data.count {
            cell.layer.cornerRadius = constants.basicPadding
            if indexPath.row != .zero { cell.layer.maskedCorners = [.layerMaxXMaxYCorner , .layerMinXMaxYCorner] }
            else { cell.layer.maskedCorners = [.layerMaxXMaxYCorner , .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner ] }
            
            cell.separtorLine.backgroundColor = .clear
            cell.todoItem = TodoItem()
            cell.reloadData(isZero: true)
        } else {
            cell.tag = indexPath.row
            cell.todoItem = data[indexPath.row]
            cell.reloadData(isZero: false)
            
            if indexPath.row == .zero {
                cell.layer.cornerRadius = constants.basicPadding
                cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                cell.separtorLine.backgroundColor = supportSeparator
            } else {
                cell.layer.cornerRadius = .zero
                cell.separtorLine.backgroundColor = supportSeparator
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        updateDoneLabel()
        let header  = self.viewModels.doneInfoView
        
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalToConstant: constants.headerViewWidth!),
            header.heightAnchor.constraint(equalToConstant: constants.headerViewHeight),
        ])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == data.count { return constants.tableViewCellHeight1 }
        
        var lines = Double(data[indexPath.row].text.count) / constants.maxCharsInCellLabel
        if let _ = data[indexPath.row].deadline { lines += 1.0 }
        
        if lines <= 1.0 {
            return constants.tableViewCellHeight1
        } else if lines <= 2.0 {
            return constants.tableViewCellHeight2
        } else {
            return constants.tableViewCellHeight3
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == data.count {
            appCoordinator?.presentItemEditor()
        } else {
            appCoordinator?.presentItemEditor(with: data[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return constants.headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == data.count { return UISwipeActionsConfiguration(actions: []) }
        
        let edit = UIContextualAction(style: .normal, title: "", handler: { [weak self] _,_,_ in
            if let appC = self?.appCoordinator, let item = self?.data[indexPath.row] {
                appC.presentItemEditor(with: item)
            }
        })
        edit.image = UIImage(named: constants.editSwipeImageName)
        
        let delete = UIContextualAction(style: .normal, title: "", handler: { [weak self] _,_,_ in
            if let appC = self?.appCoordinator, let item = self?.data[indexPath.row] {
                appC.deleteItem(with: item.id)
            }
        })
        delete.backgroundColor = red
        delete.image = UIImage(named: constants.deleteSwipeImageName)
        
        let swipingActions = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipingActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == data.count { return UISwipeActionsConfiguration(actions: []) }
        let done = UIContextualAction(style: .normal, title: "", handler: { [weak self] _,_,_ in
            if let appC = self?.appCoordinator, var item = self?.data[indexPath.row] {
                item.isDone = true
                appC.itemDone(with: item.id, item: item)
            }
        })
        done.backgroundColor = green
        done.image = UIImage(named: constants.doneSwipeImageName)
        let swipingActions = UISwipeActionsConfiguration(actions: [done])
        return swipingActions
    }
    
    
}
