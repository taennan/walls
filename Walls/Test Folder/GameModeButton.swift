//
//  GameModeButton.swift
//  Walls
//
//  Created by Taennan Rickman on 13/9/20.
//

import GameplayKit
import SpriteKit

class GameModeChanger: SKLabelNode {
    let buttonText: String
    let initialFontColour: NSColor
    
    init(changeTo: GameMode) {
        if changeTo == .classic {
            buttonText = "Classic"
            initialFontColour = .white
            
        } else {
            buttonText = "Sparse"
            initialFontColour = .lightGray
            
        }
        
        
        super.init()
        
        isUserInteractionEnabled = true
        text = buttonText
        fontColor = initialFontColour
        fontSize = showWallsButton.fontSize
        fontName = "Helvetica"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func mouseUp(with event: NSEvent) {
        if buttonText == "Classic" {
            gameMode = .classic
            
            classicButton.fontColor = .white
            sparseButton.fontColor = .lightGray
            
            print("Game Mode changed to classic")
            
        } else {
            gameMode = .sparse
            
            sparseButton.fontColor = .white
            classicButton.fontColor = .lightGray
            
            print("Game mode changed to sparse")
            
        }
    }
    
}

let classicButton = GameModeChanger(changeTo: .classic)
let sparseButton = GameModeChanger(changeTo: .sparse)
