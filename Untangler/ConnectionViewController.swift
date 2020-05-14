//
//  ViewController.swift
//  Untangler
//
//  Created by Larissa Uchoa on 13/05/20.
//  Copyright © 2020 Larissa Uchoa. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController {

    var currentLevel = 0
    var connections = [ConnectionView]()
    let renderedLines = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderedLines.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(renderedLines)
        
        NSLayoutConstraint.activate([
            renderedLines.topAnchor.constraint(equalTo: view.topAnchor),
            renderedLines.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderedLines.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            renderedLines.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        levelUp()
    }
    
    func levelUp() {
        currentLevel += 1
        
        connections.forEach { $0.removeFromSuperview() }
        connections.removeAll()
        
        for _ in 1...(currentLevel + 4) {
            let connection = ConnectionView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
            connection.backgroundColor = .white
            connection.layer.cornerRadius = 22
            
            connection.layer.contents = UIImage(named: "connection")?.cgImage
            
            connections.append(connection)
            view.addSubview(connection)
            
            connection.dragChanged = { [weak self] in
                self?.redrawLines()
            }
        }
        
        for i in 0..<connections.count {
            if i == connections.count - 1 {
                connections[i].after = connections[0]
            } else {
                connections[i].after = connections[i + 1]
            }
        }
        
        connections.forEach(place(_:))
        redrawLines()
        
    }
    
    func place(_ connection: ConnectionView) {
        let randomX = CGFloat.random(in: 20...view.bounds.maxX - 20)
        let randomY = CGFloat.random(in: 50...view.bounds.maxY - 50)
        
        connection.center = CGPoint(x: randomX, y: randomY)
    }
    
    func redrawLines() {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        
        renderedLines.image = renderer.image { ctx in
            for connection in connections {
                UIColor.white.set()
                ctx.cgContext.setLineWidth(5)
                ctx.cgContext.strokeLineSegments(between: [connection.after.center, connection.center])
            }
        }
    }


}

