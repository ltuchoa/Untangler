//
//  ViewController.swift
//  Untangler
//
//  Created by Larissa Uchoa on 13/05/20.
//  Copyright © 2020 Larissa Uchoa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentLevel = 0
    var connections = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .black
        
        levelUp()
    }
    
    func levelUp() {
        currentLevel += 1
        
        connections.forEach { $0.removeFromSuperview() }
        connections.removeAll()
        
        for _ in 1...(currentLevel + 4) {
            let connection = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
            connection.backgroundColor = .white
            connection.layer.cornerRadius = 22
            
            connection.layer.contents = UIImage(named: "connection")?.cgImage
            
            connections.append(connection)
            view.addSubview(connection)
        }
        
        connections.forEach(place(_:))
        
    }
    
    func place(_ connection: UIView) {
        let randomX = CGFloat.random(in: 20...view.bounds.maxX - 20)
        let randomY = CGFloat.random(in: 50...view.bounds.maxY - 50)
        
        connection.center = CGPoint(x: randomX, y: randomY)
    }


}

