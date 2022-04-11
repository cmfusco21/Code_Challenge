//
//  QuestionViewController.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/9/22.
//

import UIKit

class QuestionViewController: UIViewController {
    
    private let question: QuestionData
    
    init(question: QuestionData) {
        self.question = question
        
        super.init(nibName: nil, bundle: nil)
        
        print(question.title)
        
        view.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
