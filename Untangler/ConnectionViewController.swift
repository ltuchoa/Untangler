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
                
                var isLineClear = true
                
                for other in connections {
                    if (linesCross(start1: connection.center, end1: connection.after.center, start2: other.center, end2: other.after.center) != nil) {
                        isLineClear = false
                        break
                    }
                }
                
                if isLineClear {
                    UIColor.white.set()
                } else {
                    UIColor.init(red: 0.831, green: 0, blue: 0, alpha: 1).set()                }
                
                ctx.cgContext.setLineWidth(5)
                ctx.cgContext.strokeLineSegments(between: [connection.after.center, connection.center])
            }
        }
    }
    
    func linesCross(start1: CGPoint, end1: CGPoint, start2: CGPoint, end2: CGPoint) -> (x: CGFloat, y: CGFloat)? {
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = end1.x - start1.x
        let delta1y = end1.y - start1.y
        let delta2x = end2.x - start2.x
        let delta2y = end2.y - start2.y

        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.0001 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }

        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant

        if ab > 0 && ab < 1 {
            let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant

            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = start1.x + ab * delta1x
                let intersectY = start1.y + ab * delta1y
                return (intersectX, intersectY)
            }
        }

        // lines don't cross
        return nil
    }


}

