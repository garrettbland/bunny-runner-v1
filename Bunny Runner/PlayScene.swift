//
//  PlayScene.swift
//  Bunny Run 4
//
//  Created by Garrett Bland on 1/16/16.
//  Copyright © 2016 Flat Circle Interactive. All rights reserved.
//

import SpriteKit


struct PhysicsCategory {
    
    //physics bodies categories
    static let bunny : UInt32 = 0x1 << 1
    static let groundPad : UInt32 = 0x1 << 2
    static let dieLine : UInt32 = 0x1 << 3
    static let minimumJumpForce:CGFloat = 5.0
    static let maximumJumpForce:CGFloat = 9.0
    
}



class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    
    //misc variables
    var sceneBackgroundColor =  UIColor(hue: 0.5528, saturation: 1, brightness: 0.95, alpha: 1.0) /* #00a5f2 */
    
    //node variables
    var bunny = SKSpriteNode()
    let scoreText = SKLabelNode(fontNamed:"Small Pixel7")
    var thePads = SKNode()
    var groundPad = SKSpriteNode()
    var theClouds = SKNode()
    var cloud = SKSpriteNode()
    
    //label variables
    var score = 0
    var isTouchingPad = Bool()
    var finalScore = SKLabelNode(fontNamed:"Small Pixel7")
    var userHighScore = SKLabelNode(fontNamed: "Small Pixel7")
    var userGamesPlayed = SKLabelNode(fontNamed: "Small Pixel7")
    var userJumps = SKLabelNode(fontNamed: "Small Pixel7")
    var userCumulativeScore = SKLabelNode(fontNamed: "Small Pixel7")
    var userAverageScorePerGame = SKLabelNode(fontNamed: "Small Pixel7")
    var userTotalTimePlayed = SKLabelNode(fontNamed: "Small Pixel7")
    var userAverageTimePerRound = SKLabelNode(fontNamed: "Small Pixel7")
    var rateInstructions = SKLabelNode(fontNamed: "Small Pixel7")//renamed from screenshotInstructions to rateInstructions 4/1/16
    var rateInstructions2 = SKLabelNode(fontNamed: "Small Pixel7")//renamed from screenshotInstructions to rateInstructions 4/1/16
    let websiteText = SKLabelNode(fontNamed: "Small Pixel7")
    let donateText = SKLabelNode(fontNamed: "Small Pixel7")

    
    //stats variables default number(used for SKLabelNodes)
    var displayHighScore = 0
    var displayGamesPlayed = 0
    var displayJumps = 0
    var displayCumulativeScore = 0
    var displayAverageScorePerGame = 0
    var displayTotalTimePlayed = 0
    var displayAverageTimePerRound = 0
    
    
    //stats counters
    var jumpsCounter = 0
    var playTimer = 0
    var startPlayTimer = Bool()
    
    //game mechanic variables
    var gameStarted = Bool()
    var moveAndRemove = SKAction()
    var moveAndRemoveClouds = SKAction()
    var moveAndRemoveLogo = SKAction()
    var bunnyTouching = Bool()
    var died = Bool()
    var scoreBoard = SKSpriteNode()
    var statsBoard = SKSpriteNode()
    var logo = SKSpriteNode()
    let dieLine = SKSpriteNode()
    var startTimeStamp = NSTimeInterval()
    var endTimeStamp = NSTimeInterval()
    var playerIsTouchingScreen = Bool()
    
    //buttons
    var restartButton = SKSpriteNode()
    var statsButton = SKSpriteNode()
    var rateButton = SKSpriteNode()
    var speakerOnButton = SKSpriteNode()
    
    //sound effects
    var soundScoreUp = SKAction.playSoundFileNamed("score_up_higher.caff", waitForCompletion: false)
    var soundDie = SKAction.playSoundFileNamed("sound_die.caff", waitForCompletion: false)
    var playMusic = Int() //1 = true, 2 = false. 3 is nothing for first time use

    
    //random blocks
    var textures = [SKTexture]()
    var cloudtextures = [SKTexture]()
    
    //user settings (high score, games played, ect)
    let userDefaults = NSUserDefaults()
    
    //instructions text
    let instructionsTap = SKLabelNode(fontNamed:"Small Pixel7")
    let instructionsTapHold = SKLabelNode(fontNamed:"Small Pixel7")
    let instructionsGameText = SKLabelNode(fontNamed: "Small Pixel7")
    let instructionsTapDrop = SKLabelNode(fontNamed: "Small Pixel7")
    
    //double jump mechanics
    var pressed = false
    var touchTime = NSTimeInterval()
    var startpushtimer = CGFloat(0)
    

    //---------------PLAYSCENE variables end-------------------
   
    
    override func didMoveToView(view: SKView) {
        
        //this is loaded first from GameScene
        //creates the scene
        createScene()
        
        //starts moving clouds and pads
        startMovingPads()
        startMovingClouds()
        
        
        
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //first touch actions
        
       
        
        
        if gameStarted == false{
            bunny.physicsBody?.dynamic = true
            bunny.physicsBody?.affectedByGravity = true
            
            gameStarted = true
            self.removeChildrenInArray([instructionsTap,instructionsTapHold, instructionsGameText, instructionsTapDrop, websiteText])
            
            //starts the playTimer
            startPlayTimer = true

            
        } else {
            
        }
        
        //sets touch and hold timer to zero and pressed variable to true
        startpushtimer = 0
        pressed = true
     
        //if the bunny physics body is touching, then apply the impulse
        if(bunnyTouching){
            bunny.physicsBody?.applyImpulse(CGVectorMake(0,14))//changed impulse up 8 units 4/1/16 by Garrett Bland
            
            //*******stats keeping the total jumps**********
            jumpsCounter++
            
            
            bunnyTouching = false
            
        }
       

           
            
            
        //continues loop to check for restart button being pushed. Then will run restartScene function
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if died == true{
                
                if restartButton.containsPoint(location){
                    
                    restartScene()
                    
                }
                
                if statsButton.containsPoint(location){
                    
               
                        createStatsPage()
                        
                    
                    
                    
                }
                
                
                if rateButton.containsPoint(location){
                    ratingRedirection()
                }
                
                
                if speakerOnButton.containsPoint(location){
                    

                    
                    
                    userPlayMusic()
                    
                    
                    
                }
                

                
                

                
            }
            
        }
        
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        
        //on touch end, the pressed variable is set to false and the startpushtimer timer is checked to do a high jump or low
        pressed = false
       
      
        
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        //gets the sound effects value
        let SoundEffects = userDefaults.integerForKey("userSoundEffects")
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        //checks to see if the bunny is touching the groupad or not
        if firstBody.categoryBitMask == PhysicsCategory.groundPad && secondBody.categoryBitMask == PhysicsCategory.bunny || firstBody.categoryBitMask == PhysicsCategory.bunny && secondBody.categoryBitMask == PhysicsCategory.groundPad{
            //print("grind me")
            bunnyTouching = true
            updateScore()
        }
        
        //checks to see if the bunny is touching the die line
        if firstBody.categoryBitMask == PhysicsCategory.dieLine && secondBody.categoryBitMask == PhysicsCategory.bunny ||
            firstBody.categoryBitMask == PhysicsCategory.bunny && secondBody.categoryBitMask == PhysicsCategory.dieLine{
                //print("touching die line")
                died = true
                
                //checks to see if volume is muted
                if SoundEffects == 2 {
                    //do not play sound
                }else {
                    runAction(soundDie)
                }
                
                //stops the playTimer
                startPlayTimer = false
                
                
                //********saves stats before UI is created to reflect changes eg. new high score
                saveStats()
                
                createRestartButton()
                
        }
        
    }
    
    
    
    override func update(currentTime: NSTimeInterval) {
        
        //runs every single frame
        
        //playtimer
        if(startPlayTimer){
            playTimer++
            //print(playTimer)
        }
        
        
        
        
        //if pressed then the startpushtimer will start counting up.
        if(pressed){
            
            
                self.startpushtimer++
            
                // startpushtimer timer is greater than set number, then high jump impulse added onto regular impulse
                if (startpushtimer > 8) {
                
                    bunny.physicsBody?.applyImpulse(CGVectorMake(0,10))//changed impulse up 2 units 4/1/16 by Garrett Bland
                    bunnyTouching = false
                    pressed = false
                    startpushtimer = 0
                
                }
            
        }
        
        //if score is greater equals 10, night time will start to happen
        if score == 10 {
            //self.backgroundColor = UIColor(hue: 0.6, saturation: 0.31, brightness: 0.11, alpha: 1.0) /* #13161c */
            //runAction(SKAction.colorizeWithColor(UIColor(hue: 0.6, saturation: 0.31, brightness: 0.11, alpha: 1.0) /* #13161c */, colorBlendFactor: 0.0, duration: 2.0))
            //runAction(SKAction.colorizeWithColor(sceneBackgroundColor, colorBlendFactor: 1.0, duration: 1.0))
        }
        
    }
    
    
    //custom functions-----------------------------------------------------------

    func createScene(){
        

        
        
        //resets the playTimer back to 0
        playTimer = 0
        
        //sets the rate button a long ways away so the rate redirection cant happen until the stats page is created
        self.rateButton.position = CGPoint(x: self.frame.width * 2, y: self.frame.height * 2)
        
        self.physicsWorld.contactDelegate = self
        
        //---background color---
        self.backgroundColor = sceneBackgroundColor
        
        //doesnt allow rate to be taken until statsboard or endgame is up
        rateButton.hidden = true
        
        
        //---bunny-----------
        bunny = SKSpriteNode(imageNamed:"bunny")
        bunny.position = CGPoint(x: self.frame.width / 2 - 120, y: self.frame.height / 2 - 20)
        bunny.physicsBody = SKPhysicsBody(rectangleOfSize: bunny.size)//changed to rectangle of size 4/1/16 by Garrett Bland
        bunny.physicsBody?.affectedByGravity = false
        bunny.physicsBody?.dynamic = false
        bunny.physicsBody?.categoryBitMask = PhysicsCategory.bunny
        bunny.physicsBody?.collisionBitMask = PhysicsCategory.groundPad
        bunny.physicsBody?.contactTestBitMask = PhysicsCategory.groundPad
        bunny.physicsBody?.velocity = CGVectorMake(0,0)
        bunny.zPosition = 2
        bunny.physicsBody?.usesPreciseCollisionDetection = false
        bunny.physicsBody?.allowsRotation = false
        bunny.physicsBody?.restitution = 0.0
        //-------------------
        
        //---dieLine---------
        dieLine.size = CGSize(width:self.frame.width + 600, height: 3)
        dieLine.position = CGPoint(x:self.frame.width / 2, y: CGRectGetMinY(self.frame) )
        dieLine.physicsBody = SKPhysicsBody(rectangleOfSize: dieLine.size)
        dieLine.physicsBody?.dynamic = false
        dieLine.physicsBody?.affectedByGravity = false
        dieLine.physicsBody?.categoryBitMask = PhysicsCategory.dieLine
        dieLine.physicsBody?.collisionBitMask = PhysicsCategory.bunny
        dieLine.physicsBody?.contactTestBitMask = PhysicsCategory.bunny
        dieLine.physicsBody?.restitution = 0.0
       
        //-------------------
        
        //---scoreText-------
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 10)
        self.scoreText.zPosition = 2
        
        self.finalScore.text = "Final"
        self.finalScore.fontSize = 42
        self.finalScore.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 40)
        self.finalScore.zPosition = 2
        
        self.userHighScore.text = "High"
        self.userHighScore.fontSize = 32
        self.userHighScore.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50 )
        self.userHighScore.zPosition = 2
        userHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        

       
        
        
        //---add the nodes to scene------
        self.addChild(bunny)
        self.addChild(scoreText)
        self.addChild(dieLine)
        self.addChild(instructionsTap)
        self.addChild(instructionsTapHold)
        self.addChild(instructionsTapDrop)
        //-------------------------------
        
        
        
        //---add the instructions text by running this function-----
        showInstructions()
        //----------------------------------------------------------
    }
    
    
    
    func updateScore(){
        
        //updates the score by 1
        //fires sound when score up
        
        //gets the sound effects value
        let SoundEffects = userDefaults.integerForKey("userSoundEffects")
        
        //if the sound is turned off, a sound effect will not fire unless its something other than 1
        if SoundEffects == 2 {
            //do not play sound
        }else{
            runAction(soundScoreUp)
        }
        self.score++
        self.scoreText.text = String(self.score)
        
    }
    
    
    
    func restartScene(){
        
        //re creates the scene
        //remove all the child nodes in this array. Does not remove clouds and pads for continuous play
        self.removeChildrenInArray([scoreText,dieLine,bunny,statsButton,restartButton,finalScore,userHighScore,scoreBoard])
         self.removeChildrenInArray([userJumps,userGamesPlayed,userCumulativeScore,userAverageScorePerGame,rateInstructions,statsBoard,rateButton,rateInstructions2,userTotalTimePlayed,userAverageTimePerRound,websiteText,donateText,speakerOnButton])

        
        //resets the variables to restart game from 0 then fires the createScene function
        died = false
        gameStarted = false
        score = 0
        createScene()
        logoFloatAway()
        startpushtimer = 0
        
    }
    
    func logoFloatAway(){
        
        //makes the logo float with the clouds to the left and then removes logo from scene. Created 4/2/16
        
        let moveLogoLeft = SKAction.moveTo(CGPointMake(CGRectGetMidX(self.frame) - 400, CGRectGetMidY(self.frame) + (self.frame.height) / 3), duration:2.0)
        let removeLogo = SKAction.removeFromParent()
        let logoSequence = SKAction.sequence([moveLogoLeft,removeLogo])
        
        logo.runAction(logoSequence)

    }
    
    func saveStats(){
        
        //save the stats. Example: high score, games played, high jumps, low jumps ect...
        
        //stats variables
        let highScore = userDefaults.integerForKey("highScore")
        let gamesPlayed = userDefaults.integerForKey("gamesPlayed")
        let totalJumps = userDefaults.integerForKey("totalJumps")
        let cumulativeScore = userDefaults.integerForKey("cumulativeScore")
        let averageScorePerGame = userDefaults.integerForKey("averageScorePerGame")
        let totalTimePlayed = userDefaults.integerForKey("totalTimePlayed")
        let averageTimePerRound = userDefaults.integerForKey("averageTimePerRound")

        
        
        //High Score
        if self.score > highScore {
            
            userDefaults.setInteger(self.score, forKey: "highScore")
            displayHighScore = self.score
            
        }else{
            
            displayHighScore = highScore
        }
        
        //Total Jumps
        let userTotalJumps = (jumpsCounter + totalJumps)
        userDefaults.setInteger(userTotalJumps, forKey: "totalJumps")
        displayJumps = userTotalJumps
        jumpsCounter = 0
        
        //Games played
        let userGamesPlayed = (gamesPlayed + 1)
        userDefaults.setInteger(userGamesPlayed, forKey: "gamesPlayed")
        displayGamesPlayed = userGamesPlayed
        
        //Cumulative Score
        let userCumulativeScore = (cumulativeScore + self.score)
        userDefaults.setInteger(userCumulativeScore, forKey: "cumulativeScore")
        displayCumulativeScore = userCumulativeScore
        
        //Average Score Per Game
        let userAverageScorePerGame = (userCumulativeScore / userGamesPlayed)
        userDefaults.setInteger(userAverageScorePerGame, forKey: "averageScorePerGame")
        displayAverageScorePerGame = userAverageScorePerGame
        
        
        //Total Time Played>>>>I divided by 60 because I count every single frame. So if its going 60 frames per second I divide by that. 
        //This produces number of seconds
        let userTotalTimePlayed = (totalTimePlayed + (self.playTimer / 60))
        userDefaults.setInteger(userTotalTimePlayed, forKey: "totalTimePlayed")
        displayTotalTimePlayed = userTotalTimePlayed
        
        //Average Time Per Round
        let userAverageTimePerRound = (userTotalTimePlayed / userGamesPlayed)
        userDefaults.setInteger(userAverageTimePerRound, forKey: "averageTimePerRound")
        displayAverageTimePerRound = userAverageTimePerRound
        
    }
    
    func createRestartButton(){
        
        //refrence to the sound effecs to the correct texture can be displayed
        let SoundEffects = userDefaults.integerForKey("userSoundEffects")
        
        //refrence the user defaults to display
        let ShowScore = displayHighScore
        
      
        
        userHighScore.text = "HighScore: \(ShowScore)"
        
        restartButton = SKSpriteNode(imageNamed: "restartButton")
        restartButton.position = CGPoint(x: self.frame.width / 2 - (self.restartButton.size.width / 3), y: self.frame.height / 2 - 125)
        restartButton.zPosition = 6
        restartButton.setScale(0.6)
        
        statsButton = SKSpriteNode(imageNamed: "statsButton")
        statsButton.position = CGPoint(x: self.frame.width / 2 + (self.statsButton.size.width / 3), y: self.frame.height / 2 - 125)
        statsButton.zPosition = 7
        statsButton.setScale(0.6)
        
        scoreBoard = SKSpriteNode(imageNamed: "scoreBoard")
        scoreBoard.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        scoreBoard.zPosition = 1
        scoreBoard.setScale(0.8)
        
        logo = SKSpriteNode(imageNamed: "logoBunnyRunner")
        logo.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 3)
        logo.zPosition = 5
        logo.setScale(0.8)
        
        //------rate button------
        
        //rate button
        self.rateButton = SKSpriteNode(imageNamed: "screenshotButton")
        self.rateButton.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2 - 200)
        self.rateButton.zPosition = 8
        self.rateButton.setScale(0.6)
        
        //rate text
        self.rateInstructions.text = "App Store!"
        self.rateInstructions.zPosition = 9
        self.rateInstructions.fontSize = 25
        self.rateInstructions.position = CGPoint(x: self.frame.width / 2 , y: self.frame.width / 2 - 345)
        
        self.rateInstructions2.text = "Rate on the"
        self.rateInstructions2.zPosition = 9
        self.rateInstructions2.fontSize = 25
        self.rateInstructions2.position = CGPoint(x: self.frame.width / 2 , y: self.frame.width / 2 - 325)
        //-----------------------
        
        //---speaker on button-------------
        speakerOnButton = SKSpriteNode(imageNamed: "speaker_on")
        speakerOnButton.position = CGPoint(x:self.frame.width / 2, y: CGRectGetMinY(self.frame) + 1)
        speakerOnButton.anchorPoint = CGPointMake(0.5, 0);
        speakerOnButton.physicsBody?.affectedByGravity = false
        speakerOnButton.physicsBody?.dynamic = false
        speakerOnButton.zPosition = 4
        speakerOnButton.setScale(0.6)
        
        
        //---dontation part---
        self.donateText.text = "Like ad-free? Donate at"
        self.donateText.fontSize = 25
        self.donateText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 255)
        self.donateText.zPosition = 2
        //---------------
        
        //-----website name----
        self.websiteText.text = "BunnyRunner.com"
        self.websiteText.fontSize = 36
        self.websiteText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 280)
        self.websiteText.zPosition = 2
        //-------------------
        
        showInstructions()
        
        self.addChild(logo)
        self.addChild(scoreBoard)
        self.addChild(statsButton)
        self.addChild(restartButton)
        self.addChild(finalScore)
        self.addChild(userHighScore)
        self.addChild(rateButton)
        self.addChild(rateInstructions)
        self.addChild(rateInstructions2)
        self.addChild(websiteText)
        self.addChild(speakerOnButton)
        
       
        if SoundEffects == 2 {
            speakerOnButton.texture = SKTexture(imageNamed: "speaker_off")
        }
        

   
       
        
    }
    
    func createStatsPage(){

        
        //remove the current restart board
        self.removeChildrenInArray([scoreText,dieLine,bunny,scoreBoard,finalScore,userHighScore,statsBoard,userAverageScorePerGame,userHighScore,userJumps,userCumulativeScore,userGamesPlayed,userTotalTimePlayed,userAverageTimePerRound])
        
        
        //stats board node
        self.statsBoard = SKSpriteNode(imageNamed: "statsBoard")
        self.statsBoard.position = CGPoint(x: self.frame.width / 2, y: self.frame.width / 2 - 75)
        self.statsBoard.zPosition = 7
        self.statsBoard.setScale(0.95)
        
        //stats board variables
        let ShowGamesPlayed = displayGamesPlayed
        let ShowJumps = displayJumps
        let ShowScore = displayHighScore
        let ShowCumulativeScore = displayCumulativeScore
        let ShowAverageScorePerGame = displayAverageScorePerGame
        let ShowTotalTimePlayed = displayTotalTimePlayed
        let ShowAverageTimePerRound = displayAverageTimePerRound
        
        //stats board sklabel nodes
        //high score
        self.userHighScore.text = "High Score...\(ShowScore)"
        self.userHighScore.zPosition = 8
        self.userHighScore.fontSize = 20
        self.userHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.userHighScore.position = CGPoint(x: self.frame.width / 2.74 , y: self.frame.height / 2 + 130)
        
        //games played
        self.userGamesPlayed.text = "Games Played...\(ShowGamesPlayed)"
        self.userGamesPlayed.zPosition = 8
        self.userGamesPlayed.position = CGPoint(x: self.frame.width / 2.74 , y: self.frame.height / 2 + 110)
        self.userGamesPlayed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.userGamesPlayed.fontSize = 20
        
        //user jumps
        self.userJumps.text = "Jumps...\(ShowJumps)"
        self.userJumps.zPosition = 8
        self.userJumps.position = CGPoint(x: self.frame.width / 2.74 , y: self.frame.height / 2 + 90)
        self.userJumps.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.userJumps.fontSize = 20
        
        //cumulative score
        self.userCumulativeScore.text = "Lifetime Score...\(ShowCumulativeScore)"
        self.userCumulativeScore.zPosition = 8
        self.userCumulativeScore.position = CGPoint(x: self.frame.width / 2.74 , y: self.frame.height / 2 + 70)
        self.userCumulativeScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.userCumulativeScore.fontSize = 20
        
        //average score per game
        self.userAverageScorePerGame.text = "Avg.Score Per Game...\(ShowAverageScorePerGame)"
        self.userAverageScorePerGame.zPosition = 8
        self.userAverageScorePerGame.position = CGPoint(x: self.frame.width / 2.74 , y: self.frame.height / 2 + 50)
        self.userAverageScorePerGame.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.userAverageScorePerGame.fontSize = 20
        
        //Total Time played
        if (ShowTotalTimePlayed > 60){
            self.userTotalTimePlayed.text = "Time Played...\(ShowTotalTimePlayed / 60) minutes"
        } else if (ShowTotalTimePlayed < 60){
            self.userTotalTimePlayed.text = "Time Played...\(ShowTotalTimePlayed) seconds"
        } 
        self.userTotalTimePlayed.zPosition = 8
        self.userTotalTimePlayed.position = CGPoint(x: self.frame.width / 2.74 , y: self.frame.height / 2 + 30)
        self.userTotalTimePlayed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.userTotalTimePlayed.fontSize = 20
        
        //Average time per round
        if (ShowAverageTimePerRound > 60){
            self.userAverageTimePerRound.text = "Avg.Time Per Game...\(ShowAverageTimePerRound / 60) minutes"
        } else if (ShowAverageTimePerRound < 60){
            self.userAverageTimePerRound.text = "Avg.Time Per Game...\(ShowAverageTimePerRound) seconds"
        }
        self.userAverageTimePerRound.zPosition = 8
        self.userAverageTimePerRound.position = CGPoint(x: self.frame.width / 2.74 , y: self.frame.height / 2 + 10)
        self.userAverageTimePerRound.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.userAverageTimePerRound.fontSize = 20

        
        
        
        //add nodes to scene
        self.addChild(statsBoard)
        self.addChild(userGamesPlayed)
        self.addChild(userJumps)
        self.addChild(userHighScore)
        self.addChild(userCumulativeScore)
        self.addChild(userAverageScorePerGame)
        self.addChild(userTotalTimePlayed)
        self.addChild(userAverageTimePerRound)

        

        
        
        
        
    }
    
    func startMovingPads(){
        
        //--random platforms---
        //this is used so the textures arent loaded every call. Called once and done. Saves memory
        textures.append(SKTexture(imageNamed: "platform_1"))
        textures.append(SKTexture(imageNamed: "platform_2"))
        textures.append(SKTexture(imageNamed: "platform_3"))
        //---------------------
        
        //moving the ground pads
        //print("spawn1")
        let SpawnDelay = SKAction.sequence([
            SKAction.runBlock({self.moveGroundPad()}),
            SKAction.waitForDuration(0.8, withRange: 0.4) //distane between pads
            ])
        let SpawnDelayForever = SKAction.repeatActionForever(SpawnDelay)
        self.runAction(SpawnDelayForever)
        let distance = CGFloat(self.frame.width + 150)
        let movePad = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.0035 * distance))//speed of the pads
        let removePad = SKAction.removeFromParent()
        
        moveAndRemove = SKAction.sequence([movePad, removePad])
        
    }
    

    
    func moveGroundPad(){
        //moves the groundPads
        
        thePads = SKNode()
        
        
       let groundPad = SKSpriteNode(imageNamed: "platform_1")
        
        // Randomly select a platform
        let randomPlatform = Int(arc4random_uniform(UInt32(textures.count)))
        let texture = textures[randomPlatform] as SKTexture
        


        
        
        
        //---groundPad-------
        groundPad.position = CGPoint(x: self.frame.width + 80, y: self.frame.height / 2 - 100)
        groundPad.physicsBody = SKPhysicsBody(rectangleOfSize: groundPad.size)//--updated 4/1/16 by Garrett Bland
        groundPad.physicsBody?.dynamic = false
        groundPad.physicsBody?.affectedByGravity = false
        groundPad.physicsBody?.categoryBitMask = PhysicsCategory.groundPad
        groundPad.physicsBody?.collisionBitMask = 0
        groundPad.physicsBody?.contactTestBitMask = PhysicsCategory.bunny
        groundPad.physicsBody?.restitution = 0.0
        groundPad.texture = texture
        //-------------------
        
        
        
        thePads.addChild(groundPad)
        
        
        
        //this the spread between the pads on y axis
        
        var reallyhigh = Bool()
        var superhigh = Bool()
        
        var randomPosition = CGFloat.random(min: -30, max: 20)
        
        if (randomPosition > 14){
            superhigh = true
        }else if(randomPosition > 10){
            reallyhigh = true
        }
        
        if (reallyhigh){
            randomPosition = CGFloat.random(min: -55, max: -65) //if reallyhigh boolean, the pads can be really low
        }
        
        if (superhigh){
            randomPosition = CGFloat.random(min: 10, max: 20) //if superhigh boolean, the pads can be really high
        }


        thePads.position.y = thePads.position.y + randomPosition
        thePads.runAction(moveAndRemove)
        
        self.addChild(thePads)
        
        
        
        
        
    }
    
    func startMovingClouds(){
       
        //--random clouds---
        //this is used so the textures arent loaded every call. Called once and done. Saves memory
        cloudtextures.append(SKTexture(imageNamed: "cloud_1"))
        cloudtextures.append(SKTexture(imageNamed: "cloud_2"))
        cloudtextures.append(SKTexture(imageNamed: "cloud_3"))
        cloudtextures.append(SKTexture(imageNamed: "cloud_4"))
        //---------------------
        
        
        //moving the clouds
        let SpawnDelay = SKAction.sequence([
            SKAction.runBlock({self.moveClouds()}),
            SKAction.waitForDuration(4, withRange: 0.8) //how often they spawn
            ])
        let SpawnDelayForever = SKAction.repeatActionForever(SpawnDelay)
        self.runAction(SpawnDelayForever)
        let distance = CGFloat(self.frame.width + 150)
        let moveCloud = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.01 * distance))
        let removeCloud = SKAction.removeFromParent()
        
        moveAndRemoveClouds = SKAction.sequence([moveCloud, removeCloud])
        
    }
    
    
    
    func moveClouds(){
        
        theClouds = SKNode()
        
        let cloud = SKSpriteNode(imageNamed: "cloud_1")
        
        // Randomly select a platform
        let randomCloud = Int(arc4random_uniform(UInt32(cloudtextures.count)))
        let cloudtexture = cloudtextures[randomCloud] as SKTexture
        
        
        
        //--clouds-------------

        cloud.position = CGPoint(x: self.frame.width + 50, y: (self.frame.height / 2) + (self.frame.height / 4))
        cloud.zPosition = 2
        //cloud.setScale(0.7)
        cloud.texture = cloudtexture
        //-------------------
        
        
        
        theClouds.addChild(cloud)
        
        //this the spread between the pads on y axis
        let randomCloudPosition = CGFloat.random(min: -30, max: 80) //how far up and down the pads are
        
        theClouds.position.y = theClouds.position.y + randomCloudPosition
        theClouds.runAction(moveAndRemoveClouds)
        
        self.addChild(theClouds)

    }
    
    func showInstructions(){
        //instructions text. 
        //v2 changes - changed font sizes up 8 pts. Changed color of lower two instructions to black 4/1/16
        //---Tap-------
        self.instructionsTap.text = "Tap for Low Jump"
        self.instructionsTap.fontSize = 28
        self.instructionsTap.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 310)
        self.instructionsTap.zPosition = 2
        self.instructionsTap.fontColor = UIColor(red: 14/255, green: 2/255, blue: 237/255, alpha: 1.0) /* #0e02ed */
        
        //---Tap + Hold-------
        self.instructionsTapHold.text = "Tap + Hold for High Jump"
        self.instructionsTapHold.fontSize = 28
        self.instructionsTapHold.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 330)
        self.instructionsTapHold.zPosition = 2
        self.instructionsTapHold.fontColor = UIColor(red: 14/255, green: 2/255, blue: 237/255, alpha: 1.0) /* #0e02ed */

        //------Game instructions-------NOT USED
        self.instructionsGameText.text = "Land on as many pads as you can to score"
        self.instructionsGameText.fontSize = 22
        self.instructionsGameText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 270)
        self.instructionsGameText.zPosition = 2
        
        //------instructionsTapDrop-------
        self.instructionsTapDrop.text = "Tap screen to drop the bunny!"
        self.instructionsTapDrop.fontSize = 30
        self.instructionsTapDrop.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 270)
        self.instructionsTapDrop.zPosition = 2
        
    }
    
    //removed screenshot method. Replaced with rateButton. 4/1/16
    
    func ratingRedirection() {
        //rate button. Take to app store to rate
        let url  = NSURL(string: "itms-apps://itunes.apple.com/app/id1076458002")
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        }
        
    }
    
    //this is the switch for the user to play sound effects or not
    func userPlayMusic(){
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
    
    
    //---end custom functions------------------------------------------------------
}







