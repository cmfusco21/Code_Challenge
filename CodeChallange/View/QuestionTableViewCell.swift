//
//  QuestionTableViewCell.swift
//  CodeChallange
//
//  Created by Christopher Fusco on 4/10/22.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    private let label = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupContraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setup(question: QuestionData) {
        label.text = question.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}
