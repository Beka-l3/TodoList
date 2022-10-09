//
//  AppCoordinator.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 01.10.2022.
//


//
//  AppCoordinator.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 01.10.2022.
//
import Foundation

final class AppCoordinator {
    
    let fileCache: FileCache
    private let constants: Constants
    let mainPage: MainPageController
    let itemEditorPage: ItemEditorPageController
    
    private(set) var isDoneShown: Bool {
        get {
            let value = UserDefaults.standard.integer(forKey: constants.key)
            if value == 0 {
                UserDefaults.standard.set(2, forKey: constants.key)
            } else if value == 1 {
                return false
            }
            return true
        }
        set {
            if newValue {
                UserDefaults.standard.set(2, forKey: constants.key)
            } else {
                UserDefaults.standard.set(1, forKey: constants.key)
            }
        }
    }
    var doneCount: Int {
        get {
            return fileCache.items.values.reduce(0) {
                if $1.isDone { return $0 + 1 }
                else { return $0 }
            }
        }
    }
    
    private var currentItem: TodoItem
    
    
    init() {
        fileCache = FileCache()
        constants = Constants()
        mainPage = MainPageController(data: [])
        itemEditorPage = ItemEditorPageController()
        currentItem = TodoItem()
        
        mainPage.appCoordinator = self
        mainPage.viewModels.appCoordinator = self
        mainPage.reloadData()
        
        itemEditorPage.appCoordinator = self
        itemEditorPage.viewModels.appCoordinator = self
    }
    
    func getMainPage() -> MainPageController {
        return mainPage
    }
    
    func getData() -> [TodoItem] {
        if isDoneShown { return Array(fileCache.items.values).sorted { $0.createdDate < $1.createdDate } }
        return Array(fileCache.items.values).filter { !$0.isDone }.sorted { $0.createdDate < $1.createdDate }
    }
    
    func itemDone(with id: String, item: TodoItem) {
        fileCache.changeItem(with: id, item)
        mainPage.reloadData()
    }
    
    func toggleDoneButton() {
        isDoneShown.toggle()
        mainPage.reloadData()
    }
    
    func presentItemEditor(with item: TodoItem = TodoItem()) {
        currentItem = item
        itemEditorPage.setItem(item)
        
        mainPage.navigationController?.present(itemEditorPage, animated: true)
    }
    
    func dismissItemEditor() {
        itemEditorPage.dismiss(animated: true, completion: nil)
        mainPage.reloadData()
    }
    
    func saveItemChanges(text: String, priority: ItemPriority, deadline: Date?) {
        let item = TodoItem(
            id: currentItem.id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: currentItem.isDone,
            createdDate: currentItem.createdDate,
            lastChangeDate: Date()
        )
        fileCache.changeItem(with: currentItem.id, item)
        
        dismissItemEditor()
    }
    
    func deleteItem(with id: String? = nil) {
        let id = id ?? currentItem.id
        fileCache.removeItem(with: id)
        dismissItemEditor()
    }

    private struct Constants {
        let key = "isDoneShownKey"
    }
}

