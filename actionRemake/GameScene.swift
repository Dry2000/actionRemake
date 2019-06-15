
import SpriteKit
import GameplayKit
struct information{
    var hp:Int
    var inform:Int
    var jumping:Bool
}
var player = SKSpriteNode(imageNamed:"player")
let playerCategory:UInt32 = 0x0001
let enemyCategory:UInt32 = 0x0010
let blockCategory:UInt32 = 0x0100
var enemy:[SKSpriteNode]=[]
var enemyInfo:[information]=[]
var map:[SKSpriteNode]=[]
var leftArrow = SKSpriteNode(imageNamed:"leftArrow")
var rightArrow = SKSpriteNode(imageNamed:"rightArrow")
var upArrow = SKSpriteNode(imageNamed:"upArrow")
var oneScale:CGFloat!
var isJumping:Bool = false
var playerYpos:CGFloat!
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
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            print(touchedNode)
            if touchedNode == upArrow && !isJumping{
               /* // move up 20
                let jumpUpAction = SKAction.moveBy(x:0,y:oneScale*2.5,duration:0.5)
                // move down 20
               // let jumpDownAction = SKAction.moveBy(x:0,y:-oneScale*2.5,duration:0.2)
                // sequence of move yup then down
                let jumpSequence = SKAction.sequence([jumpUpAction/*, jumpDownAction*/])
                
                // make player run sequence
                player.run(jumpSequence)
 */             player.physicsBody?.velocity.dy = oneScale*5
            }
            let moveLeft = SKAction.move(by:CGVector(dx:10,dy:0), duration:0.5)
            if touchedNode == leftArrow{
                for i in 0..<map.count{
                    map[i].run(moveLeft)
                }
            }
             let moveRight = SKAction.move(by:CGVector(dx:-10,dy:0), duration: 0.5)
            if touchedNode == rightArrow{
                for i in 0..<map.count{
                    map[i].run(moveRight)
                }
            }
        }
    
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            let moveLeft = SKAction.move(by:CGVector(dx:10,dy:0), duration: 0.5)
            if touchedNode == leftArrow{
                for i in 0..<map.count{
                    map[i].run(moveLeft)
                }
            }
            let moveRight = SKAction.move(by:CGVector(dx:-10,dy:0), duration: 0.5)
            if touchedNode == rightArrow{
                for i in 0..<map.count{
                    map[i].run(moveRight)
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if player.position.y < -frame.height/2{
            isPaused = true
            print("GameOver")
            let gameover = SKLabelNode(text:"Game Over")
            gameover.fontName = "PixelMplus12-Regular"
            self.addChild(gameover)
        }
        if(player.position.y==playerYpos){
            isJumping = false
        }else{
            isJumping = true
        }
        playerYpos = player.position.y
    }
   
}
