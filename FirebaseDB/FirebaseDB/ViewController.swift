//
//  ViewController.swift
//  FirebaseDB
//
//  Created by Владислава on 28.09.23.
//

import UIKit
import SnapKit
import FirebaseAuth

class ViewController: UIViewController {

    private lazy var loginStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 15
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var loginInput: UITextField = {
        let input = UITextField()
        input.layer.cornerRadius = 12
        input.layer.borderColor = UIColor.lightGray.cgColor
        input.layer.borderWidth = 1
        input.leftViewMode = .always
        input.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        return input
    }()
    
    private lazy var passwordInput: UITextField = {
        let input = UITextField()
        input.layer.cornerRadius = 12
        input.layer.borderColor = UIColor.lightGray.cgColor
        input.layer.borderWidth = 1
        input.leftViewMode = .always
        input.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        return input
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(registration), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()

        if let userId = Auth.auth().currentUser?.uid {
            print("Залогинен пользователь: \(userId)")
        } else {
            print("Пользователь не залогинен")
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        self.view.addSubview(loginStack)
        loginStack.addArrangedSubview(loginInput)
        loginStack.addArrangedSubview(passwordInput)
        self.view.addSubview(loginButton)
        self.view.addSubview(registrationButton)
    }
    
    private func setupConstraints() {
        self.loginStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(registrationButton.snp.top).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc private func login() {
        guard let login = loginInput.text,
              let password = passwordInput.text
        else { return }
        Auth.auth().signIn(withEmail: login, password: password) { [weak self] result, error in
            guard error == nil,
                  let result
            else {
                print(error!.localizedDescription)
                self?.view.backgroundColor = .red
                return
            }
            
            self?.view.backgroundColor = .green
            self?.navigationController?.pushViewController(ProfileController(), animated: true)
        }
    }
    
    @objc private func registration() {
        guard let login = loginInput.text,
              let password = passwordInput.text
        else { return }
        
        Auth.auth().createUser(withEmail: login, password: password) { [weak self] result, error in
            guard error == nil,
                  let result
            else {
                print(error!.localizedDescription)
                self?.view.backgroundColor = .red
                return
            }
            
            self?.view.backgroundColor = .green
        }
    }
}
