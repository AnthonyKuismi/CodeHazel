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
var isTouching = false

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        setup()
        
    }
    
    func setup(){
        self.camera = theCamera
        Dino.name = "Dino"
        Dino.size = CGSize(width: 24*scale, height: 24*scale)
        Dino.physicsBody = SKPhysicsBody(circleOfRadius: 8 * scale)
        Dino.physicsBody?.affectedByGravity = false
        Dino.physicsBody?.contactTestBitMask = 1
        Dino.physicsBody?.categoryBitMask = 0
        Dino.position = CGPoint(x: 100, y: 220)

        setTexture(folderName: "dino_idle", sprite: Dino, spriteName: "dinoidle", speed: 10)
        addChild(Dino)
        physicsWorld.contactDelegate = self

        for node in self.children{
            if (node is SKTileMapNode){
                if let theMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBody(map: theMap)
                }
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        theCamera.position = Dino.position
        for node in self.children{
           
            if (node.name == "spike"){
                if (CGPointDistance(from: Dino.position, to: node.position) < 8*scale){
                        Dino.position = CGPoint(x: 100, y: 220)
                }
            }
            
        }
        
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location:CGPoint = (touch?.location(in: self))!
        let path = UIBezierPath()
        
        let dx = location.x - Dino.position.x
        if dx < 0 {
            Dino.xScale = -1
        } else {
            Dino.xScale = 1
        }
        
        path.move(to: Dino.position)
        path.addLine(to: location)
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: Dino_speed)
        Dino.run(move)
    }
    
    func giveTileMapPhysicsBody(map: SKTileMapNode ){
        let tileMap = map
        let startingLocation:CGPoint = tileMap.position
    
        var tileSize = tileMap.tileSize
        tileSize.width = tileSize.width*tileMap.xScale
        tileSize.height = tileSize.height*tileMap.yScale
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
    
        for col in 0..<tileMap.numberOfColumns {
    
            for row in 0..<tileMap.numberOfRows {
                let tilename:String = (tileMap.tileDefinition(atColumn: col, row: row)?.textures.description)!
                if tileMap.tileDefinition(atColumn: col, row: row) != nil && !(tilename.contains("floor")) {
                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                
                    let tileNode = SKSpriteNode()
                
                    tileNode.position = CGPoint(x: x, y: y)
                    if !tilename.contains("spike"){
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSize.width, height: tileSize.height))
                        tileNode.physicsBody?.linearDamping = 60.0
                        tileNode.physicsBody?.restitution = 0
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.isDynamic = false
                        tileNode.physicsBody?.friction = 0
                        tileNode.physicsBody?.contactTestBitMask = 0
                        tileNode.physicsBody?.collisionBitMask = 0
                        tileNode.physicsBody?.categoryBitMask = 1
                        tileNode.name = "tile"

                    }
                    else if tilename.contains("spike"){
                        tileNode.name = "spike"
                    }
                    self.addChild(tileNode)
    
                    tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x, y: tileNode.position.y + startingLocation.y)
    
                }
        }
        }
        
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
                
        if (nodeA?.name == "Dino" && nodeB?.name == "tile") || (nodeA?.name == "tile" && nodeB?.name == "Dino") {
            Dino.removeAllActions()
            setTexture(folderName: "dino_idle", sprite: Dino, spriteName: "dinoidle", speed: 10)
        }
        
    }
}
