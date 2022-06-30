//
//  GameScene.swift
//  Pachinko
//
//  Created by Rev on 16/02/2022.
//

import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    var scoreLabel : SKLabelNode!
    var editLabel : SKLabelNode!
    var randomPlates : SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -2
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        randomPlates = SKLabelNode(fontNamed: "Chalkduster")
        randomPlates.text = "Random"
        randomPlates.position = CGPoint(x: 250, y: 700)
        addChild(randomPlates)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        
        makeBouncers(at: CGPoint(x: 0, y: 0))
        makeBouncers(at: CGPoint(x: 256, y: 0))
        makeBouncers(at: CGPoint(x: 512, y: 0))
        makeBouncers(at: CGPoint(x: 768, y: 0))
        makeBouncers(at: CGPoint(x: 1024, y: 0))
        
        makeSlots(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlots(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlots(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlots(at: CGPoint(x: 896, y: 0), isGood: false)
        
        // generateRandomPlates()
        
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(randomPlates) {
            generateRandomPlates()
            return
        }
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                if let alreadyPlacedPlate = objects.first(where: {
                    SKNode in
                    SKNode.name == "plate"
                }) {
                    alreadyPlacedPlate.removeFromParent()
                } else {
                    makePlateBox(at: location)
                }
            } else {
                makeBall(at: location)
            }
        }
    }
    
    
    func makeBall(at position : CGPoint) {
        //let ballsImages = ["ballRed", "ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
        let ball = SKSpriteNode(imageNamed: "ballBlue")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.restitution = 0.8
        ball.position = CGPoint(x: position.x, y: 700)
        ball.name = "ball"
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0 // or force unwrap
        
        addChild(ball)
    }
    
    func makePlateBox(at position : CGPoint) {
        let plate = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: CGSize(width: CGFloat.random(in: 42...128), height: 16))
        plate.zRotation = CGFloat.random(in: 0...3)
        plate.position = position
        plate.physicsBody = SKPhysicsBody(rectangleOf: plate.size)
        plate.physicsBody?.isDynamic = false
        plate.name = "plate"
        addChild(plate)
    }
    
    func makeBouncers(at position : CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.position = position
        bouncer.physicsBody?.isDynamic = false
        bouncer.name = "bouncer"
        
        addChild(bouncer)
    }
    
    func makeSlots(at position : CGPoint, isGood : Bool) {
        var slotNode : SKSpriteNode
        var slotGlowNode : SKSpriteNode
        
        if isGood {
            slotNode = SKSpriteNode(imageNamed: "slotBaseGood")
            slotNode.name = "slotGood"
            slotGlowNode = SKSpriteNode(imageNamed: "slotGlowGood")
            
        } else {
            slotNode = SKSpriteNode(imageNamed: "slotBaseBad")
            slotNode.name = "slotBad"
            slotGlowNode = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        
        slotNode.position = position
        slotGlowNode.position = position
        
        slotGlowNode.run(spinForever)
        slotGlowNode.zPosition = -1
        
        slotNode.physicsBody = SKPhysicsBody(rectangleOf: slotNode.size)
        slotNode.physicsBody?.isDynamic = false
        
        addChild(slotNode)
        addChild(slotGlowNode)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node else { return }
        guard let bodyB = contact.bodyB.node else { return }
        
        if bodyA.name == "ball" {
            ballCollided(ball: bodyA, object: bodyB)
        } else if bodyB.name == "ball" {
            ballCollided(ball: bodyB, object: bodyA)
        }
    }
    
    func ballCollided(ball : SKNode , object : SKNode) {
        if object.name == "slotGood" {
            score += 1
            destroyBall(ball)
        } else if object.name == "slotBad" {
            score -= 1
            destroyBall(ball)
        }
    }
    
    func destroyBall(_ ball : SKNode) {
        if let fireParticle = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticle.position = ball.position
            addChild(fireParticle)
            
            let duration = Double(fireParticle.numParticlesToEmit) / Double(fireParticle.particleBirthRate) + Double(fireParticle.particleLifetime + fireParticle.particleLifetimeRange/2)
            let remove = SKAction.run({ [weak fireParticle] in fireParticle?.removeFromParent(); })
            let wait = SKAction.wait(forDuration: duration)
            let waitThenRemove = SKAction.sequence([wait, remove])
            self.run(waitThenRemove)
        }
        
        ball.removeFromParent()
    }
    
    func generateRandomPlates() {
        let nodes = self.children
        for node in nodes {
            if node.name == "plate" {
                node.removeFromParent()
            }
        }
        
        let ix = 150.0
        let iy = 170.0
        
        for num in 0...5 {
            for row in 0...2 {
                let x = ix + ix * CGFloat(num)
                let y = iy + iy * CGFloat(row) + CGFloat(50 * row)
                
                let pos = CGPoint(x: x, y: y)
                makePlateBox(at: pos)
            }
        }
    }
    
}
