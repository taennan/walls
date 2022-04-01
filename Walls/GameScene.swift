//
//  GameScene.swift
//  Walls
//
//  Created by Taennan Rickman on 23/8/20.
//


import SpriteKit
import GameplayKit


// GLOBAL DATA AND FUNCTION STORAGE //

// The default size of the game board
var rowsAndColumns: Int = 5

// The seperate teams in the game. Case 'none' is used for the beginning of the game
enum Team {
    case gold
    case silver
    case none
}

// Sets which teams' turn it is
var teamToMove: Team = Team.none

// The size of the view
var viewWidth: CGFloat = 0
var viewHeight: CGFloat = 0

// The standard size for every tile. It is declared here so it can be accessed in any class
var standardSize: CGFloat = 0
var standardTileSize: CGSize = CGSize(width: 0, height: 0)

// The enum which initialises the TileNode class
enum TileNodeType {
    case goldWall
    case silverWall
    case background
}

// The enum which initializes the YesNo class
enum Button {
    case yes
    case no
}

// The enum which initializes the game mode
enum GameMode {
    case classic
    case sparse
}

var gameMode: GameMode = .classic

// Does what it says
func startGame() {
    pieceTileNode.loadPieces(mode: gameMode)
    notificationLabel.text = notificationLabel.textArray[0]
    notificationLabel.fontColor = .white
    teamToMove = .none
    
}

// Does what it says
func endGame(winner: Team) {
    switch winner {
    case .gold:
        notificationLabel.text = notificationLabel.textArray[4]
        notificationLabel.fontColor = .yellow
        
    case .silver:
        notificationLabel.text = notificationLabel.textArray[5]
        notificationLabel.fontColor = .lightGray
        
    default:
        notificationLabel.text = notificationLabel.textArray[6]
        notificationLabel.fontColor = .white
    }
    
    // So that no further moves can be made on the board
    pieceTileNode.isUserInteractionEnabled = false
    
    print("Game has ended")
    
}


// LAYERS FOR GAME SCENE
let helpLayer = SKNode()
let menuLayer = SKNode()
let gameLayer = SKNode()
let settingsLayer = SKNode()


// CLASSES //

// Object for a standard TileMap Node
class TileNode: SKTileMapNode {
    
    // The textures, tile definitions, tile groups and tile sets for the Tile Node
    // The standard tile group to be used
    let tileTexture: SKTexture
    let tileDef: SKTileDefinition
    let tileGroup: SKTileGroup
    // The void group
    let voidTexture: SKTexture
    let voidTile: SKTileDefinition
    let voidGroup: SKTileGroup
    
    let nodeTileSet: SKTileSet
    
    // Sets what type the Tile Node is
    let tileNodeType: TileNodeType
    
    
    init(nodeType: TileNodeType) {
        
        switch nodeType {
        case .goldWall:
            tileTexture = SKTexture(imageNamed: "GoldWall")
            tileNodeType = .goldWall
            
        case .silverWall:
            tileTexture = SKTexture(imageNamed: "SilverWall")
            tileNodeType = .silverWall
            
        case .background:
            tileTexture = SKTexture(imageNamed: "EmptyTile")
            tileNodeType = .background
            fallthrough
            
        default:
            break
        }
        
        // Initializes the void tile group
        voidTexture = SKTexture(imageNamed: "VoidTile")
        voidTile = SKTileDefinition(texture: voidTexture)
        voidGroup = SKTileGroup(tileDefinition: voidTile)
        // Initializes the standard tile group
        tileDef = SKTileDefinition(texture: tileTexture)
        tileGroup = SKTileGroup(tileDefinition: tileDef)
        // Initializes the tile set
        nodeTileSet = SKTileSet(tileGroups: [tileGroup, voidGroup])
        
        super.init()
        
        // Initializes the TileMap Node
        super.tileSet = nodeTileSet
        super.numberOfColumns = rowsAndColumns
        super.numberOfRows = rowsAndColumns
        super.tileSize = standardTileSize
        super.position = CGPoint(x: 0, y: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}

// The Wall Nodes
let goldColumnWalls = TileNode(nodeType: .goldWall)
let goldRowWalls = TileNode(nodeType: .goldWall)

let silverColumnWallls = TileNode(nodeType: .silverWall)
let silverRowWalls = TileNode(nodeType: .silverWall)

// The Background node
let backgroundTileNode = TileNode(nodeType: .background)


// Object for the PieceTileNode
class PieceTileNode: SKTileMapNode {
    
    let voidTexture: SKTexture
    let voidTile: SKTileDefinition
    let voidGroup: SKTileGroup
    
    let moveTileTexture: SKTexture
    let moveTile: SKTileDefinition
    let moveGroup: SKTileGroup
    
    let goldPieceTexture: SKTexture
    let goldPiece: SKTileDefinition
    let goldGroup: SKTileGroup
    
    let silverPieceTexture: SKTexture
    let silverPiece: SKTileDefinition
    let silverGroup: SKTileGroup
    
    let pieceTileSet: SKTileSet
    
    override init() {
        
        // The textures, tile definitions, tile groups and tile sets for the Piece Tile Node
        
        // Initializes the void tile group
        voidTexture = SKTexture(imageNamed: "VoidTile")
        voidTile = SKTileDefinition(texture: voidTexture)
        voidGroup = SKTileGroup(tileDefinition: voidTile)
        // Initializes the move tile group
        moveTileTexture = SKTexture(imageNamed: "MoveTile")
        moveTile = SKTileDefinition(texture: moveTileTexture)
        moveGroup = SKTileGroup(tileDefinition: moveTile)
        // Initializes the gold piece group
        goldPieceTexture = SKTexture(imageNamed: "GoldPiece")
        goldPiece = SKTileDefinition(texture: goldPieceTexture)
        goldGroup = SKTileGroup(tileDefinition: goldPiece)
        // Initializes the silver piece group
        silverPieceTexture = SKTexture(imageNamed: "SilverPiece")
        silverPiece = SKTileDefinition(texture: silverPieceTexture)
        silverGroup = SKTileGroup(tileDefinition: silverPiece)
        // Initializes the tile set for the Piece Tile Node
        pieceTileSet = SKTileSet(tileGroups: [voidGroup, moveGroup, goldGroup, silverGroup])
        
        // Initialises the var used in the selectTile method
        previousColourSelected = voidGroup
        
        super.init()
        
        super.isUserInteractionEnabled = true
        super.tileSet = pieceTileSet
        super.numberOfColumns = rowsAndColumns
        super.numberOfRows = rowsAndColumns
        super.tileSize = standardTileSize
        super.position = CGPoint(x: 0, y: 0)
        super.zPosition = 4
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // Does what it says
    func loadPieces(mode: GameMode) {
        // Clears all tileDef's in PieceTileNode
        self.fill(with: voidGroup)
        
        if mode == .classic {
            // Loads gold pieces
            for tile in 0...rowsAndColumns {
                self.setTileGroup(goldGroup, forColumn: tile, row: 0)
            }
            
            // Loads silver pieces
            for tile in 0...rowsAndColumns {
                self.setTileGroup(silverGroup, forColumn: tile, row: rowsAndColumns - 1)
            }
            
        } else if mode == .sparse {
            // Loads gold pieces
            for tile in 0...rowsAndColumns - 3 {
                self.setTileGroup(goldGroup, forColumn: tile + 1, row: 0)
            }
            
            // Loads silver pieces
            for tile in 0...rowsAndColumns - 3 {
                self.setTileGroup(silverGroup, forColumn: tile + 1, row: rowsAndColumns - 1)
            }
            
        }
        
    }
    
    // Urgh... there must be a more efficient way to do this
    func erectWalls(forTeam: Team) {
        if forTeam == .gold {
            
            // Fills the Gold Wall nodes with gold walls (excluding starting rows)
            for column in 0...rowsAndColumns {
                for row in 0...rowsAndColumns {
                    
                    if row == 0 || row == rowsAndColumns - 1 {
                        continue
                        
                    } else { goldColumnWalls.setTileGroup(goldColumnWalls.tileGroup, forColumn: column, row: row) }
                    
                }
            }
            //
            for row in 0...rowsAndColumns {
                for column in 0...rowsAndColumns {
                    
                    if row == 0 || row == rowsAndColumns - 1 {
                        continue
                        
                    } else { goldRowWalls.setTileGroup(goldRowWalls.tileGroup, forColumn: column, row: row) }
                    
                }
            }
            
            // Scans the Gold Column Node
            for column in 0...rowsAndColumns {
                ColumnScan: for row in 0...rowsAndColumns {
                    
                    goldColumnWalls.setTileGroup(goldColumnWalls.voidGroup, forColumn: column, row: row)
                    
                    if pieceTileNode.tileGroup(atColumn: column, row: row) == pieceTileNode.goldGroup {
                        
                        for r in 0...rowsAndColumns {
                            goldColumnWalls.setTileGroup(goldColumnWalls.voidGroup, forColumn: column, row: rowsAndColumns - r)
                            
                            if pieceTileNode.tileGroup(atColumn: column, row: rowsAndColumns - r) == pieceTileNode.goldGroup {
                                break ColumnScan
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            // Scans the Gold Row Node
            for row in 0...rowsAndColumns {
                RowScan: for column in 0...rowsAndColumns {
                    
                    goldRowWalls.setTileGroup(goldRowWalls.voidGroup, forColumn: column, row: row)
                    
                    if pieceTileNode.tileGroup(atColumn: column, row: row) == pieceTileNode.goldGroup {
                        
                        for c in 0...rowsAndColumns {
                            goldRowWalls.setTileGroup(goldRowWalls.voidGroup, forColumn: rowsAndColumns - c, row: row)
                            
                            if pieceTileNode.tileGroup(atColumn: rowsAndColumns - c, row: row) == pieceTileNode.goldGroup {
                                break RowScan
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            // Scans once more for any gold pieces within a friendly wall
            for column in 0...rowsAndColumns {
                for row in 0...rowsAndColumns {
                    
                    if pieceTileNode.tileGroup(atColumn: column, row: row) == pieceTileNode.goldGroup {
                        goldColumnWalls.setTileGroup(goldColumnWalls.voidGroup, forColumn: column, row: row)
                        goldRowWalls.setTileGroup(goldRowWalls.voidGroup, forColumn: column, row: row)
                    }
                    
                    
                }
            }
            
        } else if forTeam == .silver {
            
            // Fills the Silver Wall nodes with silver walls (excluding starting rows)
            for column in 0...rowsAndColumns {
                for row in 0...rowsAndColumns {
                    
                    if row == 0 || row == rowsAndColumns - 1 {
                        continue
                        
                    } else { silverColumnWallls.setTileGroup(silverColumnWallls.tileGroup, forColumn: column, row: row) }
                    
                }
            }
            //
            for row in 0...rowsAndColumns {
                for column in 0...rowsAndColumns {
                    
                    if row == 0 || row == rowsAndColumns - 1 {
                        continue
                        
                    } else { silverRowWalls.setTileGroup(silverRowWalls.tileGroup, forColumn: column, row: row) }
                    
                }
            }
            
            // Scans the Silver Column Node
            for column in 0...rowsAndColumns {
                ColumnScan: for row in 0...rowsAndColumns {
                    
                    silverColumnWallls.setTileGroup(silverColumnWallls.voidGroup, forColumn: column, row: row)
                    
                    if pieceTileNode.tileGroup(atColumn: column, row: row) == pieceTileNode.silverGroup {
                        
                        for r in 0...rowsAndColumns {
                            silverColumnWallls.setTileGroup(silverColumnWallls.voidGroup, forColumn: column, row: rowsAndColumns - r)
                            
                            if pieceTileNode.tileGroup(atColumn: column, row: rowsAndColumns - r) == pieceTileNode.silverGroup {
                                break ColumnScan
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            // Scans the Silver Row Node
            for row in 0...rowsAndColumns {
                RowScan: for column in 0...rowsAndColumns {
                    
                    silverRowWalls.setTileGroup(silverRowWalls.voidGroup, forColumn: column, row: row)
                    
                    if pieceTileNode.tileGroup(atColumn: column, row: row) == pieceTileNode.silverGroup {
                        
                        for c in 0...rowsAndColumns {
                            silverRowWalls.setTileGroup(silverRowWalls.voidGroup, forColumn: rowsAndColumns - c, row: row)
                            
                            if pieceTileNode.tileGroup(atColumn: rowsAndColumns - c, row: row) == pieceTileNode.silverGroup {
                                break RowScan
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            // Scans once more for any silver pieces within a friendly wall
            for column in 0...rowsAndColumns {
                for row in 0...rowsAndColumns {
                    
                    if pieceTileNode.tileGroup(atColumn: column, row: row) == pieceTileNode.silverGroup {
                        silverColumnWallls.setTileGroup(silverColumnWallls.voidGroup, forColumn: column, row: row)
                        silverRowWalls.setTileGroup(silverRowWalls.voidGroup, forColumn: column, row: row)
                    }
                    
                    
                }
            }
            
        } else { fatalError("Attempted to call erectWalls() for non-existent team") }
        
    }
    
    // Changes which side is allowed to move and displays appropriate text on the Notification Label
    func changeWhoMoves() {
        if pieceTileNode.previousColourSelected == pieceTileNode.goldGroup {
            teamToMove = .silver
            notificationLabel.text = notificationLabel.textArray[2]
            notificationLabel.fontColor = .lightGray
            
        } else {
            teamToMove = .gold
            notificationLabel.text = notificationLabel.textArray[1]
            notificationLabel.fontColor = .yellow
            
        }
    }
    
    // Stores the coordinates and colour of the previously touched tile
    var previousColourSelected: SKTileGroup
    var previousColumnSelected: Int = 0
    var previousRowSelected: Int = 0
    
    // Finds out what the tile definition is for the tile clicked
    func selectTile(point: CGPoint) {
        
        // Gets the tile index under the position of the touch
        let column = self.tileColumnIndex(fromPosition: point)
        let row = self.tileRowIndex(fromPosition: point)
        
        // Detects the tile definition
        let pieceColour = self.tileDefinition(atColumn: column, row: row)
        var boardTile: String
        
        
        // Searches for empty tiles in the neighbourhood
        func findNeighbours() {
            let columnArray: [Int] = [1, -1, 0, 0]
            let rowArray: [Int] = [0, 0, 1, -1]
            
            for index in 0...3 {
                let nCol = column + columnArray[index]
                let nRow = row + rowArray[index]
                
                let neighbour = self.tileDefinition(atColumn: nCol, row: nRow )
                
                if neighbour == voidTile {
                    self.setTileGroup(moveGroup, forColumn: nCol, row: nRow)
                    
                }
                
            }
            
        }
        
        // Removes any move tiles from the board
        func clearMoveTiles() {
            for column in 0...rowsAndColumns {
                for row in 0...rowsAndColumns {
                    
                    if self.tileDefinition(atColumn: column, row: row) == moveTile {
                        self.setTileGroup(voidGroup, forColumn: column, row: row)
                        
                    }
                    
                }
            }
            
        }
        
        // Sets the tile that was touched previously.
        func setPreviousTile() {
            previousColumnSelected = column
            previousRowSelected = row
            
            previousColourSelected = self.tileGroup(atColumn: column, row: row)!
            
        }

        // Handles piece selection and movement
        switch pieceColour {
        case goldPiece:
            // Checks if it is the gold teams' turn
            guard teamToMove != .silver else {
                print("Is not golds' turn")
                return
            }
            
            // Checks if the selected piece is locked
            guard silverColumnWallls.tileGroup(atColumn: column, row: row) != silverColumnWallls.tileGroup else {
                print("Selected piece is locked")
                return
            }
            guard silverRowWalls.tileGroup(atColumn: column, row: row) != silverRowWalls.tileGroup else {
                print("Selected piece is locked")
                return
            }
            
            clearMoveTiles()
            findNeighbours()
            setPreviousTile()
                
            boardTile = "gold"
            
        case silverPiece:
            // Checks if it s the silver teams' turn
            guard teamToMove != .gold else {
                print("Is not silvers' turn")
                return
            }
            
            // Checks if the selected piece is locked
            guard goldColumnWalls.tileGroup(atColumn: column, row: row) != goldColumnWalls.tileGroup else {
                notificationLabel.lockedPiece(forTeam: .silver)
                
                print("Selceted piece is locked")
                return
            }
            guard goldRowWalls.tileGroup(atColumn: column, row: row) != goldRowWalls.tileGroup else {
                notificationLabel.lockedPiece(forTeam: .silver)
                
                print("Selected piece is locked")
                return
            }
            
            clearMoveTiles()
            findNeighbours()
            setPreviousTile()
                
            boardTile = "silver"
            
        case moveTile:
            // Moves the previously selected piece to the new location
            self.setTileGroup(voidGroup, forColumn: previousColumnSelected, row: previousRowSelected)
            self.setTileGroup(previousColourSelected, forColumn: column, row: row)
            
            clearMoveTiles()
            
            // Erects walls for appropriate team
            if previousColourSelected == goldGroup {
                erectWalls(forTeam: .gold)
                
            } else {
                erectWalls(forTeam: .silver)
                
            }
            
            changeWhoMoves()
            
            if row == rowsAndColumns - 1 && previousColourSelected == pieceTileNode.goldGroup {
                endGame(winner: .gold)
                
            } else if row == 0 && previousColourSelected == pieceTileNode.silverGroup {
                endGame(winner: .silver)
                
            }

            boardTile = "move"
            
        default:
            clearMoveTiles()
            
            boardTile = "empty"
            
        }
        
        print("Touched \(boardTile) tile at row \(row), column \(column) and zPosition \(self.zPosition)")
        
    }
    
    
    override func mouseUp(with event: NSEvent) {
        let clickLocation = event.location(in: self)
        
        selectTile(point: clickLocation)
        
    }
    
}

// This is initialised so the LayerButton class can use the loadPieces() method
let pieceTileNode = PieceTileNode()


// The node which hides the Wall Nodes if told to
let masterCN = SKSpriteNode(imageNamed: "Curtain")
// Test Node (delete later)
let masterOCN = SKSpriteNode(imageNamed: "Curtain")


// Object for button which changes the layer presented
class LayerButton: SKLabelNode  {
    
    var newLayer: SKNode
    
    // Initializes the class
    init(toLayer: SKNode) {
        newLayer = toLayer
        
        super.init()
        
        // Sets the font and enables user interaction
        super.isUserInteractionEnabled = true
        super.fontName = "Helvetica"
        
    }
    
    // Don't really know why this has to be here
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func changeLayer(to: SKNode) {
        menuLayer.isHidden = true
        gameLayer.isHidden = true
        settingsLayer.isHidden = true
        helpLayer.isHidden = true
        
        // Resets all Tile Nodes if the layer is changed to gameLayer
        if to == gameLayer {
            // Sets the standard size for every tile, tile map and texture
            standardSize = ( viewHeight / CGFloat(rowsAndColumns) )
            standardTileSize = CGSize(width: standardSize, height: standardSize)
            
            
            goldColumnWalls.fill(with: goldColumnWalls.voidGroup)
            goldColumnWalls.numberOfColumns = rowsAndColumns
            goldColumnWalls.numberOfRows = rowsAndColumns
            goldColumnWalls.tileSize = standardTileSize
            goldColumnWalls.tileDef.size = standardTileSize
            
            goldRowWalls.fill(with: goldRowWalls.voidGroup)
            goldRowWalls.numberOfColumns = rowsAndColumns
            goldRowWalls.numberOfRows = rowsAndColumns
            goldRowWalls.tileSize = standardTileSize
            goldRowWalls.tileDef.size = standardTileSize
            
            silverColumnWallls.fill(with: silverColumnWallls.voidGroup)
            silverColumnWallls.numberOfColumns = rowsAndColumns
            silverColumnWallls.numberOfRows = rowsAndColumns
            silverColumnWallls.tileSize = standardTileSize
            silverColumnWallls.tileDef.size = standardTileSize
            
            silverRowWalls.fill(with: silverRowWalls.voidGroup)
            silverRowWalls.numberOfColumns = rowsAndColumns
            silverRowWalls.numberOfRows = rowsAndColumns
            silverRowWalls.tileSize = standardTileSize
            silverRowWalls.tileDef.size = standardTileSize
            
            backgroundTileNode.numberOfColumns = rowsAndColumns
            backgroundTileNode.numberOfRows = rowsAndColumns
            backgroundTileNode.tileSize = standardTileSize
            backgroundTileNode.tileDef.size = standardTileSize
            backgroundTileNode.fill(with: backgroundTileNode.tileGroup)
            
            pieceTileNode.numberOfColumns = rowsAndColumns
            pieceTileNode.numberOfRows = rowsAndColumns
            pieceTileNode.tileSize = standardTileSize
            pieceTileNode.goldPiece.size = standardTileSize
            pieceTileNode.silverPiece.size = standardTileSize
            pieceTileNode.moveTile.size = standardTileSize
            pieceTileNode.isUserInteractionEnabled = true
            
            startGame()
            
        }
        
        // Shows the layer specified
        to.isHidden = false
        
    }
    
    
    override func mouseUp(with event: NSEvent) {
        changeLayer(to: newLayer)
        
        print("Layer changed to \(newLayer)")
        print("Tile size equals \(backgroundTileNode.tileSize) and Map size equals \(backgroundTileNode.mapSize)")
        
    }
    
}

// Object for the Notification Label in the GameLayer
class NotificationLabel: SKLabelNode {
    
    var textArray: [String] = ["Any side moves", "Gold to move", "Silver to move", "Piece is locked", "Gold Wins!", "Silver Wins!", "Stalemate!"]
    
    override init() {
        
        super.init()
        
        text = textArray[0]
        fontName = "Helvetica"
        fontSize = 50
        fontColor = .white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Displays approprite text on the notification node if the slected piece is locked
    func lockedPiece(forTeam: Team) {
        
        // Does what it says
        func setLabelText() {
            if teamToMove == .gold {
                notificationLabel.text = notificationLabel.textArray[1]
                
            } else {
                notificationLabel.text = notificationLabel.textArray[2]
                
            }
            
        }
        
        notificationLabel.text = notificationLabel.textArray[3]
        
        if forTeam == .gold {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                setLabelText()
                
            })
            
        } else if forTeam == .silver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                setLabelText()
                
            })
            
        } else { fatalError("Called locked piece function for non-existent team") }
        
    }
    
}

// This is initialized here so that the Notification Label can be accessed globally
let notificationLabel = NotificationLabel()

// This object is used to change the value of rowsAndColumns in the SettingsLayer
class ValueChanger: SKLabelNode {
    
    let changeBy: Int
    let buttonText: String
    let initialUserInteraction: Bool
    let initialFontColour: NSColor
    
    init(asAdder: Bool) {
        
        if asAdder == true {
            changeBy = 1
            buttonText = ">"
            initialUserInteraction = true
            initialFontColour = .white
            
        } else {
            changeBy = -1
            buttonText = "<"
            initialUserInteraction = false
            initialFontColour = .lightGray

        }
        
        super.init()
        
        isUserInteractionEnabled = initialUserInteraction
        text = buttonText
        fontName = "Helvetica"
        fontSize = 70
        fontColor = initialFontColour
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseUp(with event: NSEvent) {
        // Changes the value of rowsAndColumns
        rowsAndColumns += changeBy
        
        valueLabel.text = String(rowsAndColumns)
        
        // Switches the button on or off if rowsAndColumns are 5 or 8 respectively
        if changeBy == -1 && rowsAndColumns == 5 {
            isUserInteractionEnabled = false
            fontColor = .lightGray
            
        } else if changeBy == 1 && rowsAndColumns == 8 {
            isUserInteractionEnabled = false
            fontColor = .lightGray
            
        } else {
            valueAdder.isUserInteractionEnabled = true
            valueAdder.fontColor = .white
            valueSubtractor.isUserInteractionEnabled = true
            valueSubtractor.fontColor = .white
            
        }

        print("Board size now equals \(rowsAndColumns)")
        
    }
    
}

// These are initialized here so that the ValueChanger class can interact with them
let valueAdder = ValueChanger(asAdder: true)
let valueSubtractor = ValueChanger(asAdder: false)
let valueLabel = SKLabelNode()


// The object that is used to show or hide walls in the GameLayer
class YesNoButton: SKLabelNode {
    
    let textShown: String
    var buttonColour: NSColor
    
    init(asButton: Button) {
        if asButton == .yes {
            textShown = "Yes"
            buttonColour = .white
            
            masterCN.isHidden = false
            // Test (delete later)
            masterOCN.isHidden = false
            
        } else {
            textShown = "No"
            buttonColour = .lightGray
            
            masterCN.isHidden = true
            // Test (delete later)
            masterOCN.isHidden = true
            
        }
        
        super.init()
        
        isUserInteractionEnabled = true
        text = textShown
        fontName = "Helvetica"
        fontSize = 70
        fontColor = buttonColour
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseUp(with event: NSEvent) {
        if textShown == "Yes" {
            showWallsButton.fontColor = .white
            hideWallsButton.fontColor = .lightGray
            
            masterCN.isHidden = true
            // Test (delete later)
            masterOCN.isHidden = true
            
            print("Walls are visible")
            
        } else {
            showWallsButton.fontColor = .lightGray
            hideWallsButton.fontColor = .white
            
            masterCN.isHidden = false
            // Test (delete later)
            masterOCN.isHidden = false
            
            print("Walls are hidden")
            
        }
        
    }
    
}

let showWallsButton = YesNoButton(asButton: .yes)
let hideWallsButton = YesNoButton(asButton: .no)


// THE SCENE //
class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // Gets the scene's size so that it can be accessed globally
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        
        print("The scene height is \(viewHeight) and width is \(viewWidth)")
        
        
        // HELP LAYER
        
        helpLayer.isHidden = true
        
        let exitButton = LayerButton(toLayer: menuLayer)
        exitButton.text = "Exit button"
        exitButton.fontSize = 50
        exitButton.fontName = "Helvetica"
        exitButton.fontColor = .gray
        exitButton.position = CGPoint(x: 0, y: -((self.frame.height / 8) * 3) - 30)
        helpLayer.addChild(exitButton)
        
        // Test Tile Node
        /*
        let testTileNode = TileNode(nodeType: .goldWall)
        testTileNode.tileSize = CGSize(width: 100, height: 100)
        testTileNode.zPosition = 0
        testTileNode.zRotation = .pi / 2
        testTileNode.fill(with: testTileNode.tileGroup)
        helpLayer.addChild(testTileNode)
        
        print("Test tile node loaded. Tile size equals \(backgroundTileNode.tileSize)")
        print("Test Tile node zRotation equals \(testTileNode.zRotation)")
        
        // Test Curtain Node (delete later)
        let otherCN = masterOCN
        otherCN.size = testTileNode.mapSize
        otherCN.setScale(1.01)
        otherCN.position = CGPoint(x: 0, y: 0)
        otherCN.zPosition = 1
        helpLayer.addChild(otherCN)
        
        // Test Tile Node 2
        let testNode = TileNode(nodeType: .background)
        testNode.tileSize = testTileNode.tileSize
        testNode.zPosition = 2
        testNode.fill(with: testNode.tileGroup)
        helpLayer.addChild(testNode)
        */
        
        self.addChild(helpLayer)
 
        
        // MENU LAYER
        
        menuLayer.isHidden = false
        
        // The Labels and Buttons
        let helpButton = LayerButton(toLayer: helpLayer)
        helpButton.text = "Help"
        helpButton.fontSize = 40
        helpButton.fontColor = .gray
        helpButton.position = CGPoint(x: self.frame.width / 9, y: -(self.frame.height) / 5)
        menuLayer.addChild(helpButton)
        //
        let titleLabel = SKLabelNode(text: "WALLS")
        titleLabel.fontSize = 170
        titleLabel.fontName = "Helvetica"
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: 0, y: (self.frame.height) / 5)
        menuLayer.addChild(titleLabel)
        //
        let settingsButton = LayerButton(toLayer: settingsLayer)
        settingsButton.text = "Settings"
        settingsButton.fontSize = 40
        settingsButton.fontColor = .gray
        settingsButton.position = CGPoint(x: -self.frame.width / 9, y: -(self.frame.height) / 5)
        menuLayer.addChild(settingsButton)
        //
        let playButton = LayerButton(toLayer: gameLayer)
        playButton.text = "PLAY!"
        playButton.fontSize = 60
        playButton.fontColor = .white
        playButton.position = CGPoint(x: 0, y: -((self.frame.height) / 3))
        menuLayer.addChild(playButton)

        self.addChild(menuLayer)
        
        
        // GAME LAYER
        
        gameLayer.isHidden = true
        
        // Notification Label Node
        notificationLabel.position = CGPoint(x: 0, y: (self.frame.height / 8) * 3)
        notificationLabel.zPosition = 5
        gameLayer.addChild(notificationLabel)
        
        // Back Button
        let backButton = LayerButton(toLayer: menuLayer)
        backButton.text = "Menu"
        backButton.position = CGPoint(x: 0, y: -((self.frame.height / 8) * 3) - 30)
        backButton.zPosition = 5
        backButton.fontColor = .white
        backButton.fontSize = 30
        gameLayer.addChild(backButton)

        // Gold and Silver Wall Nodes
        goldColumnWalls.zPosition = 0
        goldColumnWalls.setScale(1.25)
        gameLayer.addChild(goldColumnWalls)
        
        goldRowWalls.zPosition = 1
        goldRowWalls.setScale(goldColumnWalls.xScale)
        gameLayer.addChild(goldRowWalls)
        
        silverColumnWallls.zPosition = 2
        silverColumnWallls.setScale(goldColumnWalls.xScale)
        gameLayer.addChild(silverColumnWallls)
        
        silverRowWalls.zPosition = 3
        silverRowWalls.setScale(goldColumnWalls.xScale)
        gameLayer.addChild(silverRowWalls)
        
        // Curtain Node
        let curtainNode = masterCN
        curtainNode.size = CGSize(width: self.frame.width, height: self.frame.height)
        curtainNode.zPosition = 4
        gameLayer.addChild(curtainNode)
        
        // Background Tile Node
        backgroundTileNode.zPosition = 5
        backgroundTileNode.setScale(goldColumnWalls.xScale)
        backgroundTileNode.fill(with: backgroundTileNode.tileGroup)
        gameLayer.addChild(backgroundTileNode)
        
        // Piece Tile Node
        pieceTileNode.zPosition = 6
        pieceTileNode.setScale(goldColumnWalls.xScale)
        gameLayer.addChild(pieceTileNode)
        
        self.addChild(gameLayer)
        
        
        // SETTINGS LAYER
        
        settingsLayer.isHidden = true
        
        // The Labels and Buttons
        
        // The Settings Layer Label
        let settingsLabel = SKLabelNode()
        settingsLabel.text = "SETTINGS"
        settingsLabel.fontName = "Helvetica"
        settingsLabel.fontSize = 100
        settingsLabel.fontColor = .white
        settingsLabel.position = CGPoint(x: 0, y: (self.frame.height / 6) * 2 )
        settingsLayer.addChild(settingsLabel)
        
        // The Exit Button
        let button = LayerButton(toLayer: menuLayer)
        button.text = "Done"
        button.fontColor = .gray
        button.fontSize = 40
        button.position = CGPoint(x: 0, y: -((self.frame.height / 5) * 2) )
        settingsLayer.addChild(button)
        
        // The buttons which control the board size and the label that displays it
        let boardSizeLabel = SKLabelNode(text: "Board Size:")
        boardSizeLabel.fontName = "Helvetica"
        boardSizeLabel.fontSize = 70
        boardSizeLabel.fontColor = .white
        boardSizeLabel.position = CGPoint(x: -((self.frame.width / 9) * 2 ), y: self.frame.height / 6 )
        settingsLayer.addChild(boardSizeLabel)
        
        valueAdder.position = CGPoint(x: (self.frame.width / 9) * 3, y: boardSizeLabel.position.y + 5 )
        settingsLayer.addChild(valueAdder)
        
        valueSubtractor.position = CGPoint(x: (self.frame.width / 9), y: valueAdder.position.y )
        settingsLayer.addChild(valueSubtractor)
        
        valueLabel.text = String(rowsAndColumns)
        valueLabel.fontName = "Helvetica"
        valueLabel.fontSize = 80
        valueLabel.fontColor = .white
        valueLabel.position = CGPoint(x: (self.frame.width / 9) * 2, y: boardSizeLabel.position.y )
        settingsLayer.addChild(valueLabel)
        
        // The buttons which control whether walls are shown in the GameLayer
        let showWallsLabel = SKLabelNode(text: "Show Walls:")
        showWallsLabel.fontName = "Helvetica"
        showWallsLabel.fontSize = boardSizeLabel.fontSize
        showWallsLabel.fontColor = boardSizeLabel.fontColor
        showWallsLabel.position = CGPoint(x: boardSizeLabel.position.x, y: 0 )
        settingsLayer.addChild(showWallsLabel)
        
        showWallsButton.position = CGPoint(x: (self.frame.width / 6), y: showWallsLabel.position.y)
        settingsLayer.addChild(showWallsButton)
        
        hideWallsButton.position = CGPoint(x: showWallsButton.position.x * 2, y: showWallsLabel.position.y)
        settingsLayer.addChild(hideWallsButton)
        
        // The buttons which control which game mode will be played
        let gameModeLabel = SKLabelNode(text: "Game Mode:")
        gameModeLabel.fontName = "Helvetica"
        gameModeLabel.fontSize = boardSizeLabel.fontSize
        gameModeLabel.fontColor = boardSizeLabel.fontColor
        gameModeLabel.position = CGPoint(x: boardSizeLabel.position.x, y: -(boardSizeLabel.position.y) )
        settingsLayer.addChild(gameModeLabel)
        
        classicButton.position = CGPoint(x: -(boardSizeLabel.position.x), y: gameModeLabel.position.y )
        settingsLayer.addChild(classicButton)
        
        sparseButton.position = CGPoint(x: -(boardSizeLabel.position.x), y: -(boardSizeLabel.position.y * 2)  + 50 )
        settingsLayer.addChild(sparseButton)
        
        self.addChild(settingsLayer)
        
    }
    
}
