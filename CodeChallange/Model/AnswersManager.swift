//
//  AnswersDelegate.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/10/22.
//

import Foundation
import UIKit

protocol AnswersManagerDelegate {
    func didUpDateAnswer(answer: [AnswersData])
    func didFailWithError(error: Error)
}

class AnswerManager {
    
    var delegate: AnswersManagerDelegate?
    private let decoder = JSONDecoder()
    
//    MARK: - Network Call 
    
    private let questionURL = "https://api.stackexchange.com/2.3/questions/"
    private let questionURL2 = "/answers?order=desc&sort=activity&site=stackoverflow&filter=!*MZqiH2u6968c87E"

    
    func getAnswers(for questionId: String) {
        let urlString = "\(questionURL)\(questionId)\(questionURL2)"
        if let url = URL(string: urlString) {
            print(urlString)
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                guard let uwData = data else { return }
                do {
                    let decoded = try self?.decoder.decode(AnswersResponse.self, from: uwData)
                    let results = decoded?.items ?? []
                    self?.delegate?.didUpDateAnswer(answer: results)
                    
                } catch {
                    print(error)
                }
                
            }
            task.resume()
        }
        
    }
}
