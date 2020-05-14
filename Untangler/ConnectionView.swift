//
//  ConnectionView.swift
//  Untangler
//
//  Created by Larissa Uchoa on 13/05/20.
//  Copyright © 2020 Larissa Uchoa. All rights reserved.
//

import UIKit

class ConnectionView: UIView {

    var dragChanged: (() -> Void)?
    var dragFinished: (() -> Void)?
    var touchStartPos = CGPoint.zero
    var after: ConnectionView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStartPos = touch.location(in: self)
        
        // Find the center
        touchStartPos.x -= frame.width / 2
        touchStartPos.y -= frame.height / 2
        
        // When clicked it gets bigger
        transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        superview?.bringSubviewToFront(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // Find the where the user moved the connection
        let point = touch.location(in: superview)
        
        // Set new center
        center = CGPoint(x: point.x - touchStartPos.x, y: point.y - touchStartPos.y)
        
        dragChanged?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Scale down
        transform = .identity
        
        dragFinished?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

}
