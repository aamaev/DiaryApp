//
//  Task.swift
//  Diary
//
//  Created by Артём Амаев on 05.12.2024.
//

import Foundation
import RealmSwift

class Task: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var dateStart: Int = 0
    @Persisted var dateFinish: Int = 0
    @Persisted var name: String = ""
    @Persisted var descriptionText: String = ""

    convenience init(id: Int, dateStart: Int, dateFinish: Int, name: String, descriptionText: String) {
        self.init()
        self.id = id
        self.dateStart = dateStart
        self.dateFinish = dateFinish
        self.name = name
        self.descriptionText = descriptionText
    }
}


