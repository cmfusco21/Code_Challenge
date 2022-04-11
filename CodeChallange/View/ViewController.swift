//
//  ViewController.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/9/22.
//

import UIKit

class ViewController: UIViewController {

    private let tableView = UITableView()
    private var data = [QuestionData]()
    private let seachBar = UISearchTextField(frame: .zero)

    private let manager = QuestionsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpConstraints()
    }
    
    private func configureUI() {
        title = "Code Challange"
        view.backgroundColor = .white

        view.addSubview(seachBar)
        view.addSubview(tableView)

        seachBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        seachBar.placeholder = "Search"
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        manager.delegate = self
        
        seachBar.delegate = self
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            seachBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            seachBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            seachBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: seachBar.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? QuestionTableViewCell
        if let uwCell = cell {
            let question = data[indexPath.row]
            uwCell.setup(question: question)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let question = data[indexPath.row]
        let viewController = QuestionViewController(question: question)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: QuestionsDelegate {
    func didUpdateQuestions(questions: [QuestionData]) {
        data = questions
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchString = textField.text ?? ""
        manager.fetchQuestion(for: searchString)
        return true
    }
}
