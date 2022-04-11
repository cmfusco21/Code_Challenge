//
//  AnswersDelegate.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/10/22.
//

import Foundation
import UIKit

protocol AnswersDelegate {
    func didUpDateQuestion(answer: String, queationID: Int)
    func didFailWithError(error: Error)
}

struct AnswerManager {
    
    var delegate: QuestionsDelegate?
    
    //MARK: - Network Call
    let questionURL = "https://api.stackexchange.com/docs/answers-on-questions#order=desc&sort=activity&ids="
    let questionURL2 = "&filter=default&site=stackoverflow"
    let ids: (Int)
    
    func getQuestion(for question: String) {
        let urlString = "\(questionURL)\(ids)\(questionURL2)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
            }
            task.resume()
        }
        
    }
}
