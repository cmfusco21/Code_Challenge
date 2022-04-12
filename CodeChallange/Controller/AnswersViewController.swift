//
//  QuestionViewController.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/9/22.
//

import UIKit
import RealmSwift

class AnswersViewController: UIViewController {
    
    private var label = UILabel(frame: .zero)
    private let tableView = UITableView(frame: .zero)
    private let question: QuestionData
    private var data = [AnswersData]()
    private let manager = AnswerManager()
    private let scoreLabel = UILabel(frame: .zero)
    private let defaults = UserDefaults.standard
    private var currentGuess: Int?
    
    init(question: QuestionData, isStored: Bool) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
        
        print(question.title)
        
        configureUI()
        constraints()
        
        if isStored {
            fetchAnswers()
        } else {
            loadAnswers()
        }
    }
    
    func configureUI() {
        title = "Which Answer was Accpeted?"
        view.backgroundColor = .white
        
        view.addSubview(label)
        view.addSubview(tableView)
        view.addSubview(scoreLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = question.title
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 25)
        label.backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: "cell")
        manager.delegate = self
        
        scoreLabel.text = "Score: \(defaults.integer(forKey: "UserScore"))"
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            scoreLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            scoreLabel.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAnswers() {
        manager.getAnswers(for: "\(question.question_id)")
    }
    
    func storeAnswers() {
        question.writeDataToRealm()
        
        data.forEach({ answer in
            answer.writeDataToRealm()
        })
    }
    
    func fetchAnswers() {
        let localRealm = try! Realm()
        let realmAnswers = localRealm.objects(AnswerDataRealm.self)
        realmAnswers.elements.forEach({ answer in
            data.append(AnswersData(question_id: answer.question_id,
                                    answer_id: answer.answer_id,
                                    is_accepted: answer.is_accepted,
                                    body_markdown: answer.body_markdown,
                                    up_vote_count: answer.up_vote_count,
                                    down_vote_count: answer.down_vote_count))
        })
        
        tableView.reloadData()
    }
    
    func scoreGuess(answer: AnswersData) {
        guard answer.answer_id != currentGuess else { return }
        
        var challageScore = defaults.integer(forKey: "UserScore")
        challageScore += answer.is_accepted ? 10 : -5
        challageScore += answer.up_vote_count * 2
        challageScore -= answer.down_vote_count * 2
        scoreLabel.text = "Score: \(challageScore)"
        
        defaults.set(challageScore, forKey: "UserScore")
    }
    
}
extension AnswersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AnswerTableViewCell
        
        guard indexPath.row < data.count else { return UITableViewCell() }
        let answer = data[indexPath.row]
        cell?.setup(answer: answer, currentGuess: currentGuess)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row < data.count else { return }
        let answer = data[indexPath.row]
        scoreGuess(answer: answer)
        currentGuess = answer.answer_id
        
        tableView.reloadData()
    }
}

extension AnswersViewController: AnswersManagerDelegate {
    func didUpDateAnswer(answer: [AnswersData]) {
        data = answer
        storeAnswers()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
