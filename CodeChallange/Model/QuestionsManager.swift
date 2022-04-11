//
//  QuestionsViewModel.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/9/22.
//

import Foundation
import UIKit

protocol QuestionsDelegate: AnyObject {
//    func didUpDateQuestion(question: String, queationID: Int)
    func didUpdateQuestions(questions: [QuestionData])
    func didFailWithError(error: Error)
}

class QuestionsManager {
    
    private let decoder = JSONDecoder()
    weak var delegate: QuestionsDelegate?
    
    //MARK: - Network Call
    private let questionURL = "https://api.stackexchange.com/2.3/search/advanced?order=desc&sort=activity"

    func fetchQuestion(for question: String) {
        let urlString = "\(questionURL)&title=\(question)&site=stackoverflow"
        print("\(urlString)")
        let cleaned = urlString
            .replacingOccurrences(of: " ", with: "%20")
            .replacingOccurrences(of: "\t", with: "")
        
        if let url = URL(string: cleaned) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                guard let uwData = data else { return }
                do {
                    let decoded = try self.decoder.decode(QuestionsResponse.self, from: uwData)
                    let results = decoded.items
                    self.delegate?.didUpdateQuestions(questions: results)
                    
                } catch {
                    print(error)
                }
                
            }
            
            task.resume()
        } else {
            print("Failed to create URL")
        }
    }
}
