//
//  FileCache.swift
//  TodoList
//
//  Created by Bekzhan Talgat on 05.10.2022.
//

import Foundation

class FileCache {
    private var currentFile: String? = nil
    private(set) var items: [String: TodoItem]
    private let constants: Constants
    
    init() {
        constants = Constants()
        items = [:]
        
        loadAllItems(from: constants.fileName)
    }
    
    func addItem(_ item: TodoItem) {
        if let it = items[item.id] { print("Already exists: \(it.id)") }
        else { items[item.id] = item }
    }
    
    func changeItem(with id: String, _ item: TodoItem) {
        items[id] = item
        saveAllItems(in: constants.fileName)
    }
    
    func removeItem(with id: String) {
        if let _ = items[id] {
            items.removeValue(forKey: id)
            saveAllItems(in: constants.fileName)
        } else { print("Does not exist: \(id)") }
    }
    
    func saveAllItems(in file: String) {
        currentFile = file
        
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(file)
            fileURL = fileURL.appendingPathExtension("json")
            
            do {
                let jsonData = items.map { $0.value.json }
                let data = try JSONSerialization.data(withJSONObject: jsonData, options: [.prettyPrinted])
                try data.write(to: fileURL, options: [.atomic])
            } catch { print(error) }
        }
    }
    
    private func loadAllItems(from file: String) {
        currentFile = file
        items.removeAll()
        
        var jsonData: [Any]?

        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)

        if let url = urls.first {
            var fileURL = url.appendingPathComponent(file)
            fileURL = fileURL.appendingPathExtension("json")

            do {
                let data = try Data(contentsOf: fileURL)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
                jsonData = jsonObject as? [Any]
            } catch {
                print(error)
            }
        }

        if let jsonData = jsonData {
            for j in jsonData {
                let i = TodoItem.parse(json: j)
                if let item = i {
                    addItem(item)
                }
            }
        }
    }
    
    private struct Constants {
        let fileName: String = "todoItems"
    }
}
