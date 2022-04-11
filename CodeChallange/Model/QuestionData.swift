//
//  QuestionData.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/10/22.
//

import Foundation

struct QuestionsResponse: Codable {
    let items: [QuestionData]
    let quota_remaining: Int
}

struct QuestionData: Codable {
    let title: String
    let question_id: Int
}

/*
 {
 "items": [30 items],
 "has_more": true,
 "quota_max": 300,
 "quota_remaining": 291
 }
 */
