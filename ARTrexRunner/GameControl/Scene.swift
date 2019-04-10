//
//  Scene.swift
//  ARTrexRunner
//  Created by Hiten Patel on 2019-04-05.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import SpriteKit
import Firebase
import FirebaseDatabase

class Scene: SKScene {
    
    var db:DatabaseReference!
    var count = 30
    var ground = SKSpriteNode()
    var groundNodeNext = SKSpriteNode()

    // Time of last frame
    var lastFrameTime : TimeInterval = 0
    
    // Time since last frame
    var deltaTime : TimeInterval = 0
    
    
    var tempArray = [String]()
    
    //get phone name
    let systemName = UIDevice.current.name as! String
    
    //get phone id
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    //asssign data to dictionary
    var ScoreData = [String : Any]()
    
    
    override func didMove(to view: SKView) {
      //  addImage()
        ScoreData = ["name": self.systemName,"DeviceID": deviceId,"score" : "0"]
        checkData()
         createground()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
       
    }
    override func update(_ currentTime: TimeInterval) {
        moveground()
        
        
        
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        // Update delta time
        deltaTime = currentTime - lastFrameTime
        
        // Set last frame time to current time
        lastFrameTime = currentTime

    }
    
    func addImage() {
        //print("")
        ground = SKSpriteNode(texture:
            SKTexture(imageNamed: "background"))
        
        ground.position = CGPoint(x: size.width/6,
                                  y: size.height/6)
        ground.zPosition = -2
        groundNodeNext = ground.copy() as! SKSpriteNode
        groundNodeNext.position =
            CGPoint(x: ground.position.x + ground.size.width,
                    y: ground.position.y)
        
        self.addChild(ground)
        self.addChild(groundNodeNext)
    }
    
    func moveSprite(sprite : SKSpriteNode,
                    nextSprite : SKSpriteNode, speed : Float) -> Void {
        var newPosition = CGPoint.self
        
        // For both the sprite and its duplicate:
        for spriteToMove in [sprite, nextSprite] {
            
            // Shift the sprite leftward based on the speed
//            newPosition = spriteToMove.position
//            newPosition.x -= CGFloat(speed * Float(deltaTime))
//            spriteToMove.position = newPosition
            
            // If this sprite is now offscreen (i.e., its rightmost edge is
            // farther left than the scene's leftmost edge):
            if spriteToMove.frame.maxX < self.frame.minX {
                
                // Shift it over so that it's now to the immediate right
                // of the other sprite.
                // This means that the two sprites are effectively
                // leap-frogging each other as they both move.
                spriteToMove.position =
                    CGPoint(x: spriteToMove.position.x +
                        spriteToMove.size.width * 2,
                            y: spriteToMove.position.y)
            }
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        guard let touch = touches.first else{
            return
        }
        
        let mouseposition = touch.location(in: self)
        let nodeName = self.atPoint(mouseposition).name
        
        //redirect to startgame Screen
        if(nodeName == "startGame") {
            //print("Start Game\(nodeName)")
            perform(#selector(Scene.StartGame),with: nil, afterDelay: 1)
        }
        //redirect top high score screen
        else if(nodeName == "highScore"){
           // print("HighScore\(nodeName)")
            perform(#selector(Scene.HighScore),with: nil, afterDelay: 1)
        }
    }
    
    func checkData() {
        //create player details in firebase
        self.db = Database.database().reference()
        
       //  self.db.child("score").childByAutoId().setValue(ScoreData)
        //get the data from firebase
        //check if device is already registered to db or not
            self.db.child("score").observe(DataEventType.childAdded, with:{
                (snapshot) in
                let x = snapshot.value as! NSDictionary
                
                
                print("System ID:\(self.deviceId)")
                print("UserName\(x["name"])")
                self.tempArray.append(x["DeviceID"] as! String)
                print("Arrays\(self.tempArray.count)")
                print("Array vAlue1 is: \(self.tempArray)")
                
            })
        
        
        checkDevice()
        
        print("Array vAlue is: \(tempArray)")
        
        
    }
    
    func checkDevice() {
        print("CTGGtfgbtyfftvty:  \(self.tempArray.count)")
        
        for i in 0..<self.tempArray.count {
            print("tempsdevice:\(self.tempArray[i])")
            print("DEvice\(deviceId)")
            
            if(self.tempArray[i] == deviceId) {
                print("DatabsseId:\(self.tempArray[i])")
                print("IF")
            }
            else{
                print("ELSE")
                //assign dictionary to firebase
                self.db.child("score").childByAutoId().setValue(ScoreData)
                print("Device Added to Firebase")
            }
        }
    }
    
    func createground(){
        
                if(count == 0){
                    count = 30
                }else{
                    for i in 0...count {

                    count = count - 1
                  //   print("I is\(count)")
                    let ground = SKSpriteNode(imageNamed: "background")
                        
                    ground.name = "background"
                    ground.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
                    ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height/8))
                        ground.zPosition = -2
                    self.addChild(ground)
                }
            }
    }
    func moveground(){
        self.enumerateChildNodes(withName: "background", using: ({
            (node, error) in
            node.position.x -= 2
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    
    
    @objc func HighScore() {
        let scene = Scene(fileNamed: "HighScore")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
    
    @objc func StartGame() {
        let scene = Scene(fileNamed: "StartGame")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
}
