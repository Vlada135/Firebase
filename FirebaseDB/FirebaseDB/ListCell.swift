//
//  ListCell.swift
//  FirebaseDB
//
//  Created by Владислава on 10.10.23.
//

import UIKit
import SnapKit

class ListCell: UITableViewCell {
    static let id = String(describing: ListCell.self)
    
    var list: List?
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var doctorLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var clinicLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(doctorLabel)
        stack.addArrangedSubview(clinicLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.addArrangedSubview(dateLabel)
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        doctorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        clinicLabel.snp.makeConstraints { make in
            make.top.equalTo(doctorLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(clinicLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func initCell() {
        makeLayout()
        makeConstraints()
    }
    
    private func configure() {
        guard let list else { return }
        titleLabel.text = list.title
        doctorLabel.text = list.doctor
        clinicLabel.text = list.clinic
        subtitleLabel.text = list.subtitle
        dateLabel.text = dateToString(format: "dd-MM-yyyy HH:mm", date: list.date)
    }
    
    private func dateToString(format: String, date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let result = formatter.string(from: date)
        return result
    }
    
    func setList(list: List) {
        self.list = list
        configure()
    }
}
