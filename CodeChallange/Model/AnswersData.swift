//
//  AnswersViewController.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/10/22.
//

import Foundation
import RealmSwift

struct AnswersResponse: Codable {
    let items: [AnswersData]
    let quota_remaining: Int
}

class AnswersData: Codable {
    let question_id: Int
    let answer_id: Int
    let is_accepted: Bool
    let body_markdown: String
    let up_vote_count: Int
    let down_vote_count: Int

    init(question_id: Int, answer_id: Int, is_accepted: Bool, body_markdown: String, up_vote_count: Int, down_vote_count: Int) {
        self.question_id = question_id
        self.answer_id = answer_id
        self.is_accepted = is_accepted
        self.body_markdown = body_markdown
        self.up_vote_count = up_vote_count
        self.down_vote_count = down_vote_count
    }
    
    func writeDataToRealm() {
        do {
            let localRealm = try Realm()
            let answer = AnswerDataRealm(question_id: self.question_id,
                                         answer_id: self.answer_id,
                                         is_accepted: self.is_accepted,
                                         body_markdown: self.body_markdown,
                                         up_vote_count: self.up_vote_count,
                                         down_vote_count: self.down_vote_count)
            
            try localRealm.write {
                localRealm.add(answer, update: .modified)
            }
        } catch {
            print(error)
        }
    }
}

class AnswerDataRealm: Object {
    @Persisted var question_id: Int = 0
    @Persisted(primaryKey: true) var answer_id: Int = 0
    @Persisted var is_accepted: Bool = false
    @Persisted var body_markdown: String = ""
    @Persisted var up_vote_count: Int = 0
    @Persisted var down_vote_count: Int = 0
    
    convenience init(question_id: Int, answer_id: Int, is_accepted: Bool, body_markdown: String, up_vote_count: Int, down_vote_count: Int) {
        self.init()
        self.question_id = question_id
        self.answer_id = answer_id
        self.is_accepted = is_accepted
        self.body_markdown = body_markdown
        self.up_vote_count = up_vote_count
        self.down_vote_count = down_vote_count
    }
}
