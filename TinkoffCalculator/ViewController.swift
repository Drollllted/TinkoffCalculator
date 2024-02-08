//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Drolllted on 08.02.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonPressed = sender.titleLabel?.text else {return}
        
        print(buttonPressed)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Есть желание попробовать поработать именно через констрейнты кодом
    }


}

