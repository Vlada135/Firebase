//
//  InputField.swift
//  FirebaseDB
//
//  Created by Владислава on 10.10.23.
//

import UIKit

class InputField: UITextField {
 
     init() {
         super.init(frame: .zero)
         initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.leftViewMode = .always
        self.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }

}
