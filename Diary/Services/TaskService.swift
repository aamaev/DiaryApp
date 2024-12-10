//
//  TaskService.swift
//  Diary
//
//  Created by Артём Амаев on 05.12.2024.
//

import Foundation
import RealmSwift

class TaskService {
    private let realm = try! Realm()

    func saveTask(_ task: Task) {
        try! realm.write {
            realm.add(task, update: .all)
        }
    }
    
    func loadTasks() -> [Task] {
        return Array(realm.objects(Task.self))
    }
    
    func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    func tasks(for date: Date) -> [Task] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        let startTimestamp = Int(startOfDay.timeIntervalSince1970)
        let endTimestamp = Int(endOfDay.timeIntervalSince1970)

        return Array(realm.objects(Task.self).filter("dateStart >= %@ AND dateStart < %@", startTimestamp, endTimestamp))
    }
}


// Первый уровень сервисного слоя (при данных в файле tasks.json):

//class TaskService {
//    func loadTasksFromFile() -> [Task] {
//        guard let fileURL = Bundle.main.url(forResource: "tasks", withExtension: "json") else {
//            print("ERROR: TaskService: tasks.json is not found.")
//            return []
//        }
//        
//        do {
//            let data = try Data(contentsOf: fileURL)
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .secondsSince1970
//            
//            let tasks = try decoder.decode([Task].self, from: data)
//            return tasks
//        } catch {
//            print("ERROR: TaskService: \(error)")
//            return []
//        }
//        
//    }
//}


