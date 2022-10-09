import Foundation


enum ItemPriority: Int {
    case low, medium, high
}

struct TodoItem {
    let id: String
    let text: String
    let priority: ItemPriority
    let deadline: Date?
    var isDone: Bool
    let createdDate: Date
    var lastChangeDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String = "",
        priority: ItemPriority = .medium,
        deadline: Date? = nil,
        isDone: Bool = false,
        createdDate: Date = Date(),
        lastChangeDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createdDate = createdDate
        self.lastChangeDate = lastChangeDate
    }
    
//    init() {
//        id = UUID().uuidString
//        text = "Some note"
//        priority = .medium
//        deadline = nil
//        isDone = false
//        createdDate = Date()
//        lastChangeDate = nil
//    }
}


extension TodoItem {
    var json: Any {
        var jsonDictionary: [String: Any] = [
            jsonKeys.id: id,
            jsonKeys.text: text,
            jsonKeys.isDone: isDone,
            jsonKeys.createdDate: createdDate.timeIntervalSince1970
        ]
        
        if priority != ItemPriority.medium {
            jsonDictionary[jsonKeys.priority] = priority.rawValue
        }
        
        if let deadline = deadline {
            jsonDictionary[jsonKeys.deadline] = deadline.timeIntervalSince1970
        }
        
        if let lastChageDate = lastChangeDate {
            jsonDictionary[jsonKeys.lastChangeDate] = lastChageDate.timeIntervalSince1970
        }
        
        return jsonDictionary
    }
    
    
    static func parse(json: Any) -> TodoItem? {
        guard let jsonDictionary = json as? [String: Any] else {
            print("Invalid json struct")
            return nil
        }
        
        guard let id = jsonDictionary[jsonKeys.id] as? String,
              let text = jsonDictionary[jsonKeys.text] as? String,
              let isDone = jsonDictionary[jsonKeys.isDone] as? Bool,
              let createdDate = jsonDictionary[jsonKeys.createdDate] as? TimeInterval else {
                  print("Invalid values")
                  return nil
              }
        
        var deadline: Date? = nil
        var lastChangeDate: Date? = nil
        var priorityRawValue: Int = 1
        if let d = jsonDictionary[jsonKeys.deadline] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: d)
        }
        if let l = jsonDictionary[jsonKeys.lastChangeDate] as? TimeInterval {
            lastChangeDate = Date(timeIntervalSince1970: l)
        }
        if let p = jsonDictionary[jsonKeys.priority] as? Int {
            priorityRawValue = p
        }
        
        guard let priority = ItemPriority(rawValue: priorityRawValue) else {
            print("Invalid priority")
            return nil
        }
        
        let todoItem: TodoItem = TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: isDone,
            createdDate: Date(timeIntervalSince1970: createdDate),
            lastChangeDate: lastChangeDate
        )
        
        return todoItem
    }
    
    
    private struct jsonKeys {
        static let id: String = "id"
        static let text: String = "text"
        static let priority: String = "priority"
        static let deadline: String = "deadline"
        static let isDone: String = "isDone"
        static let createdDate: String = "createdDate"
        static let lastChangeDate: String = "lastChangeDate"
    }
}
