//
//  InputLabel.swift
//  FirebaseDB
//
//  Created by Владислава on 10.10.23.
//

import Foundation
import UIKit

class InputLabel: UILabel {
 
     init() {
         super.init(frame: .zero)
         initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.font = .systemFont(ofSize: 12, weight: .regular)
        self.textColor = .darkGray
        self.isUserInteractionEnabled = true
        self.textAlignment = .left
        self.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }

}
