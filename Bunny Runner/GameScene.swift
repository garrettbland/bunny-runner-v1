//
//  GameScene.swift
//  Bunny Run 4
//
//  Created by Garrett Bland on 1/16/16.
//  Copyright (c) 2016 Flat Circle Interactive. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    
    //creates play button node
    var playbutton = SKSpriteNode(imageNamed: "playButton")
    var logoBunnyRunner = SKSpriteNode(imageNamed: "logoBunnyRunner")
    let playText = SKLabelNode(fontNamed:"Small Pixel7")
    let websiteText = SKLabelNode(fontNamed:"Small Pixel7")
    
    //user settings (high score, games played, ect)
    let userDefaults = NSUserDefaults()
    
    //---speakers----
    var playMusic = Int() //1 = true, 2 = false. 3 is nothing for first time use
    var speakerOnButton = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //refer to sound effects value
        let SoundEffects = userDefaults.integerForKey("userSoundEffects")
      
        
        
        //make the play button appear on the screen on startup
        self.playbutton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.logoBunnyRunner.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 200)
        
        //instructions text
        //---Tap-------
        self.playText.text = "Press anywhere to play!"
        self.playText.fontSize = 26
        self.playText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100)
        self.playText.zPosition = 2
        
        //-----website name----
        self.websiteText.text = "BunnyRunner.com"
        self.websiteText.fontSize = 33
        self.websiteText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 200)
        self.websiteText.zPosition = 2
        
        //---speaker on button-------------
        speakerOnButton = SKSpriteNode(imageNamed: "speaker_on")
        speakerOnButton.position = CGPoint(x:self.frame.width / 2, y: CGRectGetMinY(self.frame) + 1)
        speakerOnButton.anchorPoint = CGPointMake(0.5, 0);
        speakerOnButton.physicsBody?.affectedByGravity = false
        speakerOnButton.physicsBody?.dynamic = false
        speakerOnButton.zPosition = 4
        speakerOnButton.setScale(0.6)
        
        //background color
        self.backgroundColor = UIColor(hue: 0.5528, saturation: 1, brightness: 0.95, alpha: 1.0) /* #00a5f2 */
        
        self.addChild(logoBunnyRunner)
        self.addChild(playbutton)
        self.addChild(playText)
        self.addChild(websiteText)
        self.addChild(speakerOnButton)
        
        
        if SoundEffects == 2 {
            speakerOnButton.texture = SKTexture(imageNamed: "speaker_off")
        }
        
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //continues loop to check for restart button being pushed. Then will run restartScene function
    for touch in touches {
    
    let location = touch.locationInNode(self)
    
        if playbutton.containsPoint(location){
         //presents game
            self.removeAllChildren()
            
            
            //scene is the CLASS in the playscene.swift file.
            let scene = PlayScene(size: self.size)
            
            //scalemode is same. Aposed to AspectFill. Don't know why
            scene.scaleMode = .AspectFill
            
            
            //present the scene in a neat way with a sktransition
            let transition = SKTransition.fadeWithDuration(2.0)
            
            
            
            //present the PlayScene
            view?.presentScene(scene, transition: transition)

            
        }

        
        if speakerOnButton.containsPoint(location){
        //speaker button
            //save the user prefrence so sound is set to liking after app closes
            let SoundEffects = userDefaults.integerForKey("userSoundEffects")
            
            
            if SoundEffects == 1 {
                
                //turns sound effects off
                speakerOnButton.texture = SKTexture(imageNamed: "speaker_off")
                playMusic = 2
                userDefaults.setInteger(playMusic, forKey: "userSoundEffects")
                
            }else if SoundEffects == 2 {
                
                //turns sound effects back on
                speakerOnButton.texture = SKTexture(imageNamed: "speaker_on")
                playMusic = 1
                userDefaults.setInteger(playMusic, forKey: "userSoundEffects")
                
            }else if SoundEffects == 0 {
                //turns sound effects off. FIRST TIME USE
                speakerOnButton.texture = SKTexture(imageNamed: "speaker_off")
                playMusic = 2
                userDefaults.setInteger(playMusic, forKey: "userSoundEffects")
                
                
            }

            
            
            
        }
        
    }
    
    
}

}