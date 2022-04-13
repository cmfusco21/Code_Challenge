//
//  QuestionsViewModel.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/9/22.
//

import Foundation
import UIKit

protocol QuestionsDelegate: AnyObject {
    func didUpdateQuestions(questions: [QuestionData])
    func didFailWithError(error: Error)
}

class QuestionsManager {
    
    private let decoder = JSONDecoder()
    weak var delegate: QuestionsDelegate?
    
    //MARK: - Network Call /2.3/search/advanced?order=desc&sort=activity&accepted=True&answers=2&title=swift&site=stackoverflow
    private let questionURL = "https://api.stackexchange.com/2.3/search/advanced?order=desc&sort=activity&accepted=True&answers=2"

    func fetchQuestion(for question: String) {
        let urlString = "\(questionURL)&title=\(question)&site=stackoverflow"
        print("\(urlString)")
        let cleaned = urlString
            .replacingOccurrences(of: " ", with: "%20")
            .replacingOccurrences(of: "\t", with: "")
        
        if let url = URL(string: cleaned) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                guard let uwData = data else { return }
                do {
                    let decoded = try self?.decoder.decode(QuestionsResponse.self, from: uwData)
                    let results = decoded?.items ?? []
                    self?.delegate?.didUpdateQuestions(questions: results)
                    
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
