
import SpriteKit
import GameplayKit

struct information{
    var hp:Int
    var inform:Int
    var isJumping:Bool
}
var player = SKSpriteNode(imageNamed:"player")
let playerCategory:UInt32 = 0x0001
let enemyCategory:UInt32 = 0x0010
let blockCategory:UInt32 = 0x0100
var enemies:[SKSpriteNode]=[]
var enemyInfo:[information]=[]
var map:[SKSpriteNode]=[]
var leftArrow = SKSpriteNode(imageNamed:"leftArrow")
var rightArrow = SKSpriteNode(imageNamed:"rightArrow")
var upArrow = SKSpriteNode(imageNamed:"upArrow")
var oneScale:CGFloat!
var isJumping:Bool = false
var isLeft = false
var isRight = false
var playerYpos:CGFloat!
var restart = SKLabelNode(text:"Continue?")
class GameScene: SKScene,SKPhysicsContactDelegate{
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx:0,dy:-3.0)
        self.physicsWorld.contactDelegate = self
        oneScale = self.frame.width/15
        player.xScale = oneScale/player.frame.width
        player.yScale = oneScale/player.frame.height
       // player.position = CGPoint(x:-self.frame.width+oneScale,y:-self.frame.height+2*oneScale)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:player.frame.width,height:player.frame.height))
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = enemyCategory+blockCategory
        player.physicsBody?.collisionBitMask = enemyCategory+blockCategory
        addChild(player)
        playerYpos = player.position.y
        leftArrow.xScale = oneScale/leftArrow.frame.width
        leftArrow.yScale = oneScale/leftArrow.frame.height
        rightArrow.xScale = oneScale/rightArrow.frame.width
        rightArrow.yScale = oneScale/rightArrow.frame.height
        upArrow.xScale = oneScale/upArrow.frame.width
        upArrow.yScale = oneScale/upArrow.frame.height
        leftArrow.position = CGPoint(x:oneScale*3,y:-oneScale*3)
        rightArrow.position = CGPoint(x:oneScale*6,y:-oneScale*3)
        upArrow.position = CGPoint(x:-oneScale*6,y:-oneScale*3)
        self.addChild(leftArrow)
        self.addChild(rightArrow)
        self.addChild(upArrow)
        for i in 0...15{
            let spot = SKSpriteNode(imageNamed:"block")
            spot.xScale = oneScale/spot.frame.width
            spot.yScale = oneScale/spot.frame.height
            spot.position = CGPoint(x:-self.frame.width/2+(CGFloat(i)*oneScale),y:-2*oneScale)
            spot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:spot.frame.width,height:spot.frame.height))
            spot.physicsBody?.categoryBitMask = blockCategory
            spot.physicsBody?.contactTestBitMask = enemyCategory+playerCategory
            spot.physicsBody?.collisionBitMask = enemyCategory+playerCategory
            spot.physicsBody?.isDynamic = false
            addChild(spot)
            map.append(spot)
        }
        for i in 0..<3{
            let enemy = SKSpriteNode(imageNamed:"\(i)")
            enemyInfo.append(information(hp:3,inform:0,isJumping:false))
            enemy.position = CGPoint(x:400,y:0)
            enemy.xScale = oneScale/enemy.frame.width
            enemy.yScale = oneScale/enemy.frame.height
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:enemy.frame.width,height:enemy.frame.height))
            enemy.physicsBody?.categoryBitMask = enemyCategory
            enemy.physicsBody?.contactTestBitMask = blockCategory+playerCategory
            enemy.physicsBody?.collisionBitMask = blockCategory+playerCategory
            if enemyInfo[i].inform == 2{
                enemy.physicsBody?.isDynamic = false
            }else{
                enemy.physicsBody?.isDynamic = true
            }
           /* let move=SKAction.moveTo(x:-frame.width/2,duration:10.0)
           /* let move = SKAction.run {
                if isLeft{
                    SKAction.moveTo(x:-self.frame.width/2,duration:0.2)
                }
                else if isRight{
                    SKAction.moveTo(x:-self.frame.width/2,duration:1.0)
                }
                else{
                    SKAction.moveTo(x:-oneScale/12,duration:2.0)
                }
            }*/
            let remove=SKAction.removeFromParent()
            enemy.run(SKAction.sequence([move,remove]))*/
            enemies.append(enemy)
            self.addChild(enemy)
            print(enemies[i].position)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            print(location)
            if touchedNode == upArrow && !isJumping{
            player.physicsBody?.velocity.dy = oneScale*5
            }
            else if touchedNode == leftArrow{
                isLeft = true
            }
            else if touchedNode == rightArrow{
                isRight = true
            }
            else if touchedNode.position == restart.position{
                conti();
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if touchedNode == leftArrow{
                isLeft = true
            }
            if touchedNode == rightArrow{
               isRight = true
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            if touchedNode == upArrow{
                return
            }
            isLeft = false
            isRight = false
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == enemyCategory && contact.bodyB.categoryBitMask == playerCategory{
            gameover()
            return
        }else if contact.bodyB.categoryBitMask == enemyCategory && contact.bodyA.categoryBitMask == playerCategory{
            gameover()
            return
        }
        
        if contact.bodyA.categoryBitMask == enemyCategory && contact.bodyB.categoryBitMask == blockCategory{
            for i in 0..<enemies.count{
                if enemies[i].position == contact.bodyA.node!.position && enemyInfo[i].inform == 2{
                    contact.bodyB.node?.removeFromParent()
                }
            }
        }else if contact.bodyB.categoryBitMask == enemyCategory && contact.bodyA.categoryBitMask == blockCategory{
            for i in 0..<enemies.count{
                if enemies[i].position == contact.bodyB.node!.position && enemyInfo[i].inform == 2{
                    contact.bodyA.node?.removeFromParent()
                }
            }
        }
    }
    func gameover(){
        if isPaused{
            return
        }
        isPaused = true
        print("GameOver")
        let gameover = SKLabelNode(text:"Game Over")
        gameover.fontName = "PixelMplus12-Bold"
        self.addChild(gameover)
        restart.position = CGPoint(x:0,y:frame.width/4)
        restart.fontName = "PixelMplus12-Bold"
        self.addChild(restart)
    }
    func conti(){
        isPaused = false
        player.position = CGPoint(x:0,y:0)
        enemies[0].position = CGPoint(x:300,y:0)
        }
    override func update(_ currentTime: TimeInterval) {
        if player.position.y < -frame.height/2{
            gameover()
        }
        if(player.position.y==playerYpos){
            isJumping = false
        }else{
            isJumping = true
        }
        playerYpos = player.position.y
        let moveLeft = SKAction.move(by:CGVector(dx:oneScale/12,dy:0), duration:0.5)
        if isLeft{
            for i in 0..<map.count{
                map[i].run(moveLeft)
            }
            let moveLeftEnemy = SKAction.move(by:CGVector(dx:oneScale/14,dy:0), duration:0.5)
            for i in 0..<enemies.count{
                enemies[i].run(moveLeftEnemy)
            }
        }else if isRight{
            let moveRight = SKAction.move(by:CGVector(dx:-oneScale/12,dy:0), duration: 0.5)
            for i in 0..<map.count{
                map[i].run(moveRight)
            }
            let moveRightEnemy = SKAction.move(by:CGVector(dx:-oneScale/10,dy:0), duration:0.5)
            for i in 0..<enemies.count{
                enemies[i].run(moveRightEnemy)
               
            }
        }else{
            let move = SKAction.move(by:CGVector(dx:-oneScale/24,dy:0), duration: 0.5)
            for i in 0..<enemies.count{
                enemies[i].run(move)
            }
        }
        
        
        for i in 0..<enemies.count{
            if enemyInfo[i].inform == 1 && abs(Int(player.position.x - enemies[i].position.x))<Int(oneScale)*2 && !enemyInfo[i].isJumping{
                enemies[i].physicsBody?.velocity.dy = oneScale*5
            }
            if enemyInfo[i].inform == 2 && abs(Int(player.position.x - enemies[i].position.x))<Int(oneScale)*2{
                enemies[i].physicsBody?.isDynamic = true
            }
        }
    }
   
}
