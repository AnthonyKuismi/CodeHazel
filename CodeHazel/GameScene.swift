//
//  GameScene.swift
//  CodeHazel
//
//  Created by 90308589 on 12/22/20.
//
//  This is a change XD

import SpriteKit
import GameplayKit

var Dino = SKSpriteNode()
var scale:CGFloat = 4
var Dino_speed:CGFloat = 300
var theCamera = SKCameraNode()
class GameScene: SKScene {
    override func didMove(to view: SKView) {
        setup()
    }
    
    func setup(){
        self.camera = theCamera
        Dino.name = "Dino"
        Dino.size = CGSize(width: 24*scale, height: 24*scale)
        Dino.physicsBody = SKPhysicsBody(circleOfRadius: 8 * scale)
        Dino.physicsBody?.affectedByGravity = false
        setTexture(folderName: "dino_idle", sprite: Dino, spriteName: "dinoidle", speed: 10)
        addChild(Dino)
    }
    
    override func update(_ currentTime: TimeInterval) {
        theCamera.position.y = Dino.position.y
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location:CGPoint = (touch?.location(in: self))!
        let path = UIBezierPath()
        path.move(to: Dino.position)
        path.addLine(to: location)
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: Dino_speed)
        Dino.run(move)
        
       // Dino.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }
    
    func setTexture(folderName: String,sprite:SKSpriteNode,spriteName: String,speed:Double){
           let textureAtlas = SKTextureAtlas(named: folderName)
           var frames: [SKTexture] = []
        
           for i in 0...textureAtlas.textureNames.count - 1{
               let name = "\(spriteName)\(i).png"
               let texture = SKTexture(imageNamed: name)
               texture.filteringMode = SKTextureFilteringMode.nearest
               frames.append(texture)
           }
        self.removeAllActions()
        let animation = SKAction.animate(with: frames, timePerFrame: (1/speed))
           sprite.run(SKAction.repeatForever(animation))
    }
}
