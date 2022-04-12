//
//  ViewController.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/9/22.
//

import UIKit
import RealmSwift

class QuestionViewController: UIViewController {

    private let tableView = UITableView()
    private var data = [QuestionData]()
    private let searchBar = UISearchTextField(frame: .zero)
    private var segmentedControl = UISegmentedControl (items: ["API", "Realm"])
    private let manager = QuestionsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpConstraints()
    }

    private func configureUI() {
        title = "Code Challange"
        view.backgroundColor = .white

        view.addSubview(searchBar)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.placeholder = "Search"
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.segmentedValueChange(_:)), for: .valueChanged)
        
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        manager.delegate = self
        
        searchBar.delegate = self
    }
    
//MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor,constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func fetchQuestions() {
        data = []
        tableView.reloadData()
        
        let localRealm = try! Realm()
        let realmQuestions = localRealm.objects(QuestionDataRealm.self)
        realmQuestions.elements.forEach({ question in
            data.append(QuestionData(title: question.title, question_id: question.question_id))
        })
        
        tableView.reloadData()
    }
    
    @objc
    private func segmentedValueChange(_ sender:UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            searchBar.placeholder = "Search"
            data = []
            tableView.reloadData()
        case 1:
            searchBar.placeholder = "Filter"
            fetchQuestions()
        default: break
        }
    }
}

//MARK: - Tableview
extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? QuestionTableViewCell
        
        guard indexPath.row < data.count else { return UITableViewCell() }
        let question = data[indexPath.row]
        cell?.setup(question: question)

        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row < data.count else { return }
        let question = data[indexPath.row]
        
        let isStored = segmentedControl.selectedSegmentIndex == 1
        let viewController = AnswersViewController(question: question, isStored: isStored)
        navigationController?.pushViewController(viewController, animated: true)
    }
}


//MARK: - Questions
extension QuestionViewController: QuestionsDelegate {
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

extension QuestionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchString = textField.text ?? ""
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            manager.fetchQuestion(for: searchString)
        case 1:
            let filtered = data.filter({ $0.title.contains(searchString) })
            data = filtered
            tableView.reloadData()
            
        default: break
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            data = []
            tableView.reloadData()
        case 1:
            fetchQuestions()
        default: break
        }
        
        return true
    }
}
