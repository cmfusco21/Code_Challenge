//
//  QuestionData.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/10/22.
//

import Foundation
import RealmSwift

struct QuestionsResponse: Codable {
    let items: [QuestionData]
    let quota_remaining: Int    
}

struct QuestionData: Codable {
    let title: String
    let question_id: Int
    
    init(title: String, question_id: Int) {
        self.title = title
        self.question_id = question_id
    }
    
    func writeDataToRealm() {
        do {
            let localRealm = try Realm()
            let answer = QuestionDataRealm(title: self.title, question_id: self.question_id)
            
            try localRealm.write {
                localRealm.add(answer, update: .modified)
            }
        } catch {
            print(error)
        }   
    }
}

class QuestionDataRealm: Object {
    @Persisted var title: String = ""
    @Persisted(primaryKey: true) var question_id: Int = 0
    
    convenience init(title: String, question_id: Int) {
        self.init()
        self.title = title
        self.question_id = question_id
    }
}
