//
//  GameScene.swift
//  CodeHazel
//
//  Created by 90308589 on 12/22/20.
//
//  This is a change XD

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var startText = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    func setup(){
        setupStartScreen()
        setupNames()
    }
    
    func setupNames(){
        startText.name = "startText"
    }
    
    func setupStartScreen(){
        removeAllChildren()
        startText.fontSize = 30
        startText.fontColor = UIColor.green
        startText.text = "Place Holder"
        addChild(startText)
    }
    
    func setupGameScreen(){
        removeAllChildren()
        startText.fontColor = UIColor.red
        addChild(startText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonPress(touch: touches.first!)
    }
    
    func buttonPress(touch: UITouch){
        enumerateChildNodes(withName: "//*") { [self] (node, stop) in
            let location = touch.location(in: self)
            if node.name == "startText"{
                if (self.startText.contains(location)){
                    setupGameScreen()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
