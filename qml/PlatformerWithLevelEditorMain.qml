import VPlay 2.0
import QtQuick 2.0
import "scenes"
import "common"

GameWindow {
  id: gameWindow

  // You get free licenseKeys from http://v-play.net/licenseKey
  // With a licenseKey you can:
  //  * Publish your games & apps for the app stores
  //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
  //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)

  activeScene: menuScene

  // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
  // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
  // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
  // this resolution is for iPhone 4 & iPhone 4S
  width: 960
  height: 640

  // aliases to make levelEditor and itemEditor accessible from the outside
  property alias levelEditor: levelEditor
  property alias itemEditor: gameScene.itemEditor

  // update background music when scene changes
  onActiveSceneChanged: {
    audioManager.handleMusic()
  }

  // level editor
  LevelEditor {
    id: levelEditor

    Component.onCompleted: levelEditor.loadAllLevelsFromStorageLocation(authorGeneratedLevelsLocation)

    // These are the entity types, that the can be stored and removed by the entityManager.
    // Note, that the player is not here. This is because we only
    // want ONE player instance - we don't want to be able to place
    // another player or delete the existing player.
    toRemoveEntityTypes: [ "ground", "platform", "spikes", "opponent", "coin", "mushroom", "star", "finish" ]
    toStoreEntityTypes: [ "ground", "platform", "spikes", "opponent", "coin", "mushroom", "star", "finish" ]

    // set the gameNetwork
    gameNetworkItem: gameNetwork

    // directory where the predefined json levels are
    applicationJSONLevelsDirectory: "levels/"

    onLevelPublished: {
      // save level
      gameScene.editorOverlay.saveLevel()

      //report a dummy score, to initialize the leaderboard
      var leaderboard = levelId
      if(leaderboard) {
        gameNetwork.reportScore(100000, leaderboard, null, "lowest_is_best")
      }

      gameWindow.state = "level"
    }
  }

  AudioManager {
    id: audioManager
  }

  // the entity manager handles all our entities
  EntityManager {
    id: entityManager

    // here we define the container the entityManager manages
    // so all entities, the entityManager creates are in this container
    entityContainer: gameScene.container

    poolingEnabled: true
  }

  VPlayGameNetwork {
    id: gameNetwork

    // set id and secret
    gameId: 220
    secret: "platformerEditorDevPasswordForVPlayGameNetwork"

    // set gameNetworkView
    gameNetworkView: myGameNetworkView
  }

  // custom mario style font
  FontLoader {
    id: marioFont
    source: "../assets/fonts/SuperMario256.ttf"
  }

  // Scenes -----------------------------------------
  MenuScene {
    id: menuScene

    onLevelScenePressed: {
      gameWindow.state = "level"
    }
  }

  LevelScene {
    id: levelScene

    VPlayGameNetworkView {
      id: myGameNetworkView

      z: 1000

      anchors.fill: parent.gameWindowAnchorItem

      // invisible by default
      visible: false

      onShowCalled: {
        myGameNetworkView.visible = true
      }

      onBackClicked: {
        myGameNetworkView.visible = false
      }
    }

    onNewLevelPressed: {
      // create a new level
      var creationProperties = {
        levelMetaData: {
          levelName: "newLevel"
        }
      }
      levelEditor.createNewLevel(creationProperties)

      // switch to gameScene, edit mode
      gameWindow.state = "game"
      gameScene.state = "edit"

      // initialize level
      gameScene.initLevel()
    }

    onPlayLevelPressed: {
      // load level
      levelEditor.loadSingleLevel(levelData)

      // switch to gameScene, play mode
      gameWindow.state = "game"
      gameScene.state = "play"

      // initialize level
      gameScene.initLevel()
    }

    onEditLevelPressed: {
      // load level
      levelEditor.loadSingleLevel(levelData)

      // switch to gameScene, play mode
      gameWindow.state = "game"
      gameScene.state = "edit"

      // initialize level
      gameScene.initLevel()
    }

    onRemoveLevelPressed: {
      // load level
      levelEditor.loadSingleLevel(levelData)

      // remove loaded level
      levelEditor.removeCurrentLevel()
    }

    onBackPressed: {
      gameWindow.state = "menu"
    }
  }

  GameScene {
    id: gameScene

    onBackPressed: {
      // reset level
      gameScene.resetLevel()

      // switch to levelScene
      gameWindow.state = "level"
    }
  }

  // states
  state: "menu"

  // this state machine handles the transition between scenes
  states: [
    State {
      name: "menu"
      PropertyChanges {target: menuScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: menuScene}
    },
    State {
      name: "level"
      PropertyChanges {target: levelScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: levelScene}
    },
    State {
      name: "game"
      PropertyChanges {target: gameScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: gameScene}
    }
  ]

}

