//
//  Scene.swift
//  ARTrexRunner
//
//  Created by Hiten Patel on 2019-04-05.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import SpriteKit
import Firebase
import FirebaseDatabase

class Scene: SKScene {
    var db:DatabaseReference!
    
    override func didMove(to view: SKView) {
        checkData()
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
        
        //get phone name
        let systemName = UIDevice.current.name as String
        
        //get phone id
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        
        //asssign data to dictionary
        let ScoreData = ["name": systemName,"DeviceID": deviceId,"score" : "0"] as! [String : Any]
       //  self.db.child("score").childByAutoId().setValue(ScoreData)
        //get the data from firebase
        //check if device is already registered to db or not
        self.db.child("score").observe(DataEventType.childAdded, with:{
            (snapshot) in
            let x  = snapshot.value! as! NSDictionary
            
            //check if current device id is in db
            print("Dev: \(x["DeviceID"])")
            print("ABC\(deviceId)")
            //if yes then....
            if(x["DeviceID"] as! String == deviceId) {
                print("UserName\(x["name"])")
            }
            //if no then add to firebase
            else {
                //assign dictionary to firebase
                 self.db.child("score").childByAutoId().setValue(ScoreData)
                print("Device Added to Firebase")
            }
        })
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
