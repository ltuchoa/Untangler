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
    
    let scoreLabel = UILabel()
    let levelLabel = UILabel()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 0 {
        didSet {
            levelLabel.text = "LEVEL \(level)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        level = 0
        levelLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        levelLabel.font = levelLabel.font.withSize(24)
        levelLabel.font = UIFont(name: "Avenir-Black", size: levelLabel.font.pointSize)
        
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelLabel)
        
        score = 0
        scoreLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scoreLabel.font = scoreLabel.font.withSize(24)
        scoreLabel.font = UIFont(name: "Avenir-Black", size: scoreLabel.font.pointSize)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        renderedLines.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(renderedLines)
        
        NSLayoutConstraint.activate([
            renderedLines.topAnchor.constraint(equalTo: view.topAnchor),
            renderedLines.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderedLines.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            renderedLines.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            levelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
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
            
            connection.dragFinished = { [weak self] in
                self?.checkMove()
            }
        }
        
        for i in 0..<connections.count {
            if i == connections.count - 1 {
                connections[i].after = connections[0]
            } else {
                connections[i].after = connections[i + 1]
            }
        }
        
        repeat {
            connections.forEach(place(_:))
        } while levelClear()
        
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

    func levelClear() -> Bool {
        for connection in connections {
            for other in connections {
                if linesCross(start1: connection.center, end1: connection.after.center, start2: other.center, end2: other.after.center) != nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    func checkMove() {
        if levelClear() {
            score += currentLevel * 2
            level += 1
            
            view.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.4, delay: 1, options: [], animations: {
                self.renderedLines.alpha = 0
                
                for connection in self.connections {
                    connection.alpha = 0
                }
            }, completion: { finished in
                self.view.isUserInteractionEnabled = true
                self.renderedLines.alpha = 1
                self.levelUp()
            })
        } else {
            // still playing this level
            if level != 0 {
                score -= 1
            }
            
            if score < 0 {
                let alert = UIAlertController.init(title: "You lost 😢", message: "Better luck next time.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

