//
//  SettingsViewController.swift
//  FirebaseDB
//
//  Created by Владислава on 10.10.23.
//

import Foundation
import SnapKit
import UIKit
import FirebaseAuth

enum ControllerMode {
    case create
    case edit(Editable)
}

class SettingsViewController: UIViewController {
    
    private lazy var titleInput = InputField()
    private lazy var doctorInput = InputField()
    private lazy var clinicInput = InputField()
    private lazy var subtitleInput = InputField()
    private lazy var titleLabel: InputLabel = {
        let label = InputLabel()
        label.text = "Прием"
        return label
    }()
    private lazy var doctorLabel: InputLabel = {
        let label = InputLabel()
        label.text = "Врач"
        return label
    }()
    private lazy var clinicLabel: InputLabel = {
        let label = InputLabel()
        label.text = "Клиника"
        return label
    }()
    private lazy var sublitleLabel: InputLabel = {
        let label = InputLabel()
        label.text = "Заметки"
        return label
    }()
    private lazy var actionButton: UIButton = {
        let button = GradientButton(type: .system)
        button.tintColor = .white
        button.startColor = UIColor.purple
        button.endColor = UIColor.systemPink
        button.setTitle("Сохранить", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.addTarget(
            self,
            action: #selector(save),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var stackForPicker: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    lazy var pickerLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        pickerLabel.text = "Выберете дату:"
        picker.datePickerMode = .dateAndTime
        return picker
    }()
    
    private let mode: ControllerMode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        makeConstraints()
        setupControllerMode()
    }
    
    init(mode: ControllerMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(titleInput)
        self.view.addSubview(doctorLabel)
        self.view.addSubview(doctorInput)
        self.view.addSubview(clinicLabel)
        self.view.addSubview(clinicInput)
        self.view.addSubview(sublitleLabel)
        self.view.addSubview(subtitleInput)
        self.view.addSubview(actionButton)
        self.view.addSubview(stackForPicker)
        stackForPicker.addArrangedSubview(pickerLabel)
        stackForPicker.addArrangedSubview(datePicker)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        titleInput.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        doctorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleInput.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        doctorInput.snp.makeConstraints { make in
            make.top.equalTo(doctorLabel.snp.bottom).inset(-5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        clinicLabel.snp.makeConstraints { make in
            make.top.equalTo(doctorInput.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        clinicInput.snp.makeConstraints { make in
            make.top.equalTo(clinicLabel.snp.bottom).inset(-5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        sublitleLabel.snp.makeConstraints { make in
            make.top.equalTo(clinicInput.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        subtitleInput.snp.makeConstraints { make in
            make.top.equalTo(sublitleLabel.snp.bottom).inset(-5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        stackForPicker.snp.makeConstraints { make in
            make.top.equalTo(subtitleInput.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupControllerMode() {
        switch mode {
        case .create:
            title = "Создать событие"
        case .edit(let editable):
            title = "Изменить событие"

            guard let user = Auth.auth().currentUser,
                  let listId = editable.id
            else { return }
            Environment.ref.child("users/\(user.uid)/list/\(listId)").observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let listValue = snapshot.value as? [String: Any],
                      let listForEdit = try? List(key: listId, dict: listValue)
                else { return }
                
                self?.titleInput.text = listForEdit.title
                self?.doctorInput.text = listForEdit.doctor
                self?.clinicInput.text = listForEdit.clinic
                self?.subtitleInput.text = listForEdit.subtitle
                self?.datePicker.date = listForEdit.date
            }
            
            let addButton = UIButton(type: .system)
            addButton.addTarget(self, action: #selector(deleteList), for: .touchUpInside)
            addButton.setImage(UIImage(systemName: "trash"), for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        }
    }
    
    @objc private func deleteList() {
        switch mode {
        case .create:
            break
        case .edit(let editable):
            
            guard let user = Auth.auth().currentUser,
                  let listId = editable.id
            else { return }
            Environment.ref.child("users/\(user.uid)/list/\(listId)").removeValue()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func save() {
        guard let title = titleInput.text,
              let clinic = clinicInput.text,
              let user = Auth.auth().currentUser
        else { return }
        
        let list = List(
            id: nil,
            title: title,
            doctor: doctorInput.text,
            clinic: clinic,
            subtitle: subtitleInput.text,
            date: datePicker.date)
        
        switch mode {
        case .create:
            Environment.ref.child("users/\(user.uid)/list").childByAutoId().setValue(list.asDict)
        case .edit(let editable):
            guard let id = editable.id else { return }
            Environment.ref.child("users/\(user.uid)/list/\(id)").updateChildValues(list.asDict)
        }
        
    }
}
