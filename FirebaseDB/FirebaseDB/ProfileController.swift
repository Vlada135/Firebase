//
//  ProfileController.swift
//  FirebaseDB
//
//  Created by Владислава on 5.10.23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

let database = Database.database(url: "https://testproject-b42c4-default-rtdb.firebaseio.com/")

class ProfileController: UIViewController {
    private lazy var nameInput: UITextField = {
        let input = UITextField()
        input.layer.cornerRadius = 12
        input.layer.borderColor = UIColor.lightGray.cgColor
        input.layer.borderWidth = 1
        input.leftViewMode = .always
        input.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        return input
    }()
    
    private lazy var surnameInput: UITextField = {
        let input = UITextField()
        input.layer.cornerRadius = 12
        input.layer.borderColor = UIColor.lightGray.cgColor
        input.layer.borderWidth = 1
        input.leftViewMode = .always
        input.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        return input
    }()
    private lazy var noteInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Заметка"
        input.layer.cornerRadius = 12
        input.layer.borderColor = UIColor.lightGray.cgColor
        input.layer.borderWidth = 1
        input.leftViewMode = .always
        input.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        return input
    }()
    
    private lazy var saveDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        return button
    }()
    
    private lazy var addCarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить машину", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(addCar), for: .touchUpInside)
        return button
    }()
    private lazy var addNoteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить заметку", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readUserData()
        view.backgroundColor = .white
        self.view.addSubview(nameInput)
        self.view.addSubview(surnameInput)
        self.view.addSubview(noteInput)
        self.view.addSubview(saveDataButton)
        self.view.addSubview(addCarButton)
        self.view.addSubview(addNoteButton)

        
        nameInput.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        surnameInput.snp.makeConstraints { make in
            make.top.equalTo(nameInput.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        noteInput.snp.makeConstraints { make in
            make.top.equalTo(surnameInput.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        saveDataButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addCarButton.snp.makeConstraints { make in
            make.bottom.equalTo(saveDataButton.snp.top).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addCarButton.snp.makeConstraints { make in
            make.bottom.equalTo(saveDataButton.snp.top).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        addNoteButton.snp.makeConstraints { make in
            make.bottom.equalTo(addCarButton.snp.top).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    @objc private func saveData() {
        guard let name = nameInput.text,
              let surName = surnameInput.text,
              let user = Auth.auth().currentUser
        else { return }
        
        let userData: [String: Any] = [
            "username": name,
            "surname": surName
        ]
        
        database.reference().child("users/\(user.uid)/userData").setValue(userData)
    }
    
    @objc private func addCar() {
        guard let user = Auth.auth().currentUser
        else { return }
        
        let userData: [String: Any] = [
            "name": "Toyota"
        ]
        
        database.reference().child("users/\(user.uid)/userCars").childByAutoId().setValue(userData)
    }
    
    @objc private func addNote() {
        guard let note = noteInput.text,
              let user = Auth.auth().currentUser
        else { return }
        
        let userData: [String: Any] = [
            "note": note
        ]
        
        database.reference().child("users/\(user.uid)/userNote").setValue(userData)
    }
    
    private func readUserData() {
        guard let user = Auth.auth().currentUser else { return }
        database.reference().child("users/\(user.uid)/userData").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let userData = snapshot.value as? [String: Any] else { return }
            print(userData)
            if let name = userData["username"] as? String {
                self?.nameInput.text = name
            }
            if let surname = userData["surname"] as? String {
                self?.surnameInput.text = surname
            }
        }
        
        database.reference().child("users/\(user.uid)/userNote").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let userNote = snapshot.value as? [String: Any] else { return }
            print(userNote)
            if let note = userNote["note"] as? String {
                self?.noteInput.text = note
            }
        }
    }
    
}
