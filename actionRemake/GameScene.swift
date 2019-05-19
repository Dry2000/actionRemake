
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
var oneScale:CGFloat!
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
        
    
    }
    override func update(_ currentTime: TimeInterval) {
        //print(player.position)
    }
   
}
