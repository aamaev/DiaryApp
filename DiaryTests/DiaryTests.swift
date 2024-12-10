//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by Артём Амаев on 09.12.2024.
//

import XCTest
@testable import Diary
import RealmSwift

final class DiaryTests: XCTestCase {
    
    var taskService: TaskService!
    var calendar: Calendar!

    override func setUp() {
        super.setUp()
        taskService = TaskService()
        calendar = Calendar.current
    
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    override func tearDown() {
        taskService = nil
        calendar = nil
        super.tearDown()
    }
    
    // MARK: - Task Service Tests
    
    func testAddTask() {
        let task = Task(
            id: 1,
            dateStart: Int(Date().timeIntervalSince1970),
            dateFinish: Int(Date().addingTimeInterval(3600).timeIntervalSince1970),
            name: "Test Task",
            descriptionText: "This is a test"
        )

        taskService.saveTask(task)
        let tasks = taskService.loadTasks()
        XCTAssertTrue(tasks.contains(where: { $0.id == task.id }), "Task was not saved.")
    }
    
    func testEmptyTasks() {
        let tasks = taskService.loadTasks()
        XCTAssertTrue(tasks.isEmpty, "Task list should be empty.")
    }
    
    func testDeleteTask() {
        let task = Task(
            id: 2,
            dateStart: Int(Date().timeIntervalSince1970),
            dateFinish: Int(Date().addingTimeInterval(3600).timeIntervalSince1970),
            name: "Delete Task",
            descriptionText: "This task will be deleted"
        )
        
        taskService.saveTask(task)
        taskService.deleteTask(task)
        let tasks = taskService.loadTasks()
        XCTAssertFalse(tasks.contains(where: { $0.id == task.id }), "Task was not deleted.")
    }
    
    func testTasksForDate() {
        let today = Date()
        let startOfToday = calendar.startOfDay(for: today)
        
        let task1 = Task(id: 3, dateStart: Int(startOfToday.timeIntervalSince1970), dateFinish: Int(today.addingTimeInterval(3600).timeIntervalSince1970), name: "Morning Task", descriptionText: "Morning work")
        let task2 = Task(id: 4, dateStart: Int(today.addingTimeInterval(7200).timeIntervalSince1970), dateFinish: Int(today.addingTimeInterval(10800).timeIntervalSince1970), name: "Afternoon Task", descriptionText: "Afternoon work")
        
        taskService.saveTask(task1)
        taskService.saveTask(task2)
        
        let filteredTasks = taskService.tasks(for: startOfToday)
        XCTAssertEqual(filteredTasks.count, 2, "Task filtering failed.")
    }
}


