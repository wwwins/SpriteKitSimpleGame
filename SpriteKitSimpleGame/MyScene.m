//
//  MyScene.m
//  SpriteKitSimpleGame
//
//  Created by wwwins on 2014/6/18.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import "MyScene.h"


@implementation MyScene
{

  SKEmitterNode *_myEmitter;
  SKEmitterNode *_myEmitter2;
  CGMutablePathRef _pathToDraw;
  SKShapeNode *_lineNode;
  SKSpriteNode *_box;
  
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
      
      NSLog(@"Size: %@",NSStringFromCGSize(size));
      self.backgroundColor = [SKColor blackColor];
      
    }
    return self;
}

// called the method before this view is removed.
-(void)willMoveFromView:(SKView *)view
{
  
}

// called the method after this view is presented.
-(void)didMoveToView:(SKView *)view
{
  // create label node
  SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
  myLabel.text = @"Hello, World!";
  myLabel.fontSize = 30;
  myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame));
  [self addChild:myLabel];
  
  // create path
  CGPathRef ballPath = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 100, 100), nil);
  // create Shape node
  SKShapeNode *ball = [SKShapeNode node];
  ball.lineWidth = 1.0;
  ball.fillColor = [SKColor redColor];
  ball.strokeColor = [SKColor whiteColor];
  ball.glowWidth = 0.5;
  // add ball path
  ball.path = ballPath;
  [self addChild:ball];
  CGPathRelease(ballPath);
  
  // create path
  CGPathRef myPath = CGPathCreateWithRect(CGRectMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), 100, 100), nil);
  // create action
  SKAction *actionFollowing = [SKAction followPath:myPath asOffset:NO orientToPath:NO duration:5];
  // create repeat action
  SKAction *actionForever = [SKAction repeatActionForever:actionFollowing];
  
  // load particle file from the bundle
  NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
  _myEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
  _myEmitter.name = @"myEmitter";
  _myEmitter.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
  // add a action
  [_myEmitter runAction:actionForever];
  //_myEmitter.particleAction = actionForever;
  
  [self addChild:_myEmitter];
  CGPathRelease(myPath);
  
  
  
  _box = [SKSpriteNode spriteNodeWithImageNamed:@"spark"];
//  UIBezierPath *square = [UIBezierPath bezierPathWithRect:CGRectMake(0, 100, 300, 100)];
//  SKAction *followSquare = [SKAction followPath:square.CGPath asOffset:YES orientToPath:NO duration:5.0];
//  [_box runAction:followSquare];
  [self addChild:_box];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.xScale = sprite.yScale = 0.3;
        sprite.color = [SKColor redColor];
        sprite.colorBlendFactor = 0.5;
        sprite.position = location;
      
        // add actions for the sprite
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        SKAction *actionMove = [SKAction moveTo:CGPointMake(0, 0) duration:1];
        SKAction *actionRemove = [SKAction removeFromParent];
        [sprite runAction:[SKAction sequence:@[
                                               [SKAction group:@[action,actionMove]],
                                               actionRemove
                                               ]]];
       
        //[sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];

        // create a mutable path
        _pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(_pathToDraw, NULL, location.x, location.y);
        _lineNode = [SKShapeNode node];
        _lineNode.path = _pathToDraw;
        _lineNode.strokeColor = [SKColor yellowColor];
        [self addChild:_lineNode];
      
        _box.position = location;
      
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  // add a line from the current point to the new location
  CGPathAddLineToPoint(_pathToDraw, NULL, location.x, location.y);
  _lineNode.path = _pathToDraw;
  
  _box.position = location;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  /* delete the following line */
  //[_lineNode removeFromParent];
  CGPathRelease(_pathToDraw);
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
