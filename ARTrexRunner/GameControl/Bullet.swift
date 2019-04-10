//
//  Bullet.swift
//  ARTrexRunner
//
//  Created by Hiten Patel on 2019-04-09.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import Foundation
import SpriteKit
class Bullet: SKSpriteNode {
   
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        //load bullet image
        let texture = SKTexture(imageNamed: "bullet")
        //set image size
        let size = texture.size()
        
        //setup transparency
        let color = UIColor.clear
        
        //call super function with image
        super.init(texture:texture,color:color,size:size)
       
        //add physics to orange
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}