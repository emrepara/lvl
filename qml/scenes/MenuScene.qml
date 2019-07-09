import QtQuick 2.0
import VPlay 2.0
import "../common"
import "dialogs"
import "sceneElements"

SceneBase {
  id: menuScene

  signal levelScenePressed

  // background
  Rectangle {
    id: background

    anchors.fill: parent.gameWindowAnchorItem

    gradient: Gradient {
      GradientStop { position: 0.0; color: "#4595e6" }
      GradientStop { position: 0.9; color: "#80bfff" }
      GradientStop { position: 0.95; color: "#009900" }
      GradientStop { position: 1.0; color: "#804c00" }
    }
  }

  // header
  Rectangle {
    id: header

    height: 95

    anchors.top: menuScene.gameWindowAnchorItem.top
    anchors.left: menuScene.gameWindowAnchorItem.left
    anchors.right: menuScene.gameWindowAnchorItem.right
    anchors.margins: 5

    // background color
    color: "#cce6ff"

    radius: height / 4

    // header image
    MultiResolutionImage {
      fillMode: Image.PreserveAspectFit

      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right

      anchors.topMargin: 10

      source: "../../assets/ui/header.png"
    }
  }

  PlatformerImageButton {
    id: playButton

    image.source: "../../assets/ui/playButton.png"

    width: 150
    height: 40

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: header.bottom
    anchors.topMargin: 40

    color: "#cce6ff"

    radius: height / 4
    borderColor: "transparent"

    onClicked: {
      levelScene.state = "demoLevels"
      levelScenePressed()
    }
  }

  PlatformerImageButton {
    id: levelSceneButton

    image.source: "../../assets/ui/levelsButton.png"

    width: 150
    height: 40

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: playButton.bottom
    anchors.topMargin: 30

    color: "#cce6ff"

    radius: height / 4
    borderColor: "transparent"

    onClicked: {
      levelScene.state = "myLevels"
      levelScene.subState = "createdLevels"
      levelScenePressed()
    }
  }

  MultiResolutionImage {
    id: musicButton

    // show music icon
    source: "../../assets/ui/music.png"
    // reduce opacity, if music is disabled
    opacity: settings.musicEnabled ? 0.9 : 0.4

    anchors.top: header.bottom
    anchors.topMargin: 30
    anchors.left: parent.left
    anchors.leftMargin: 30

    MouseArea {
      anchors.fill: parent

      onClicked: {
        // switch between enabled and disabled
        if(settings.musicEnabled)
          settings.musicEnabled = false
        else
          settings.musicEnabled = true
      }
    }
  }

  MultiResolutionImage {
    id: soundButton

    // show sound_on or sound_off icon, depending on if sound is enabled or not
    source: settings.soundEnabled ? "../../assets/ui/sound_on.png" : "../../assets/ui/sound_off.png"
    // reduce opacity, if sound is disabled
    opacity: settings.soundEnabled ? 0.9 : 0.4

    anchors.top: musicButton.bottom
    anchors.topMargin: 10
    anchors.left: parent.left
    anchors.leftMargin: 30

    MouseArea {
      anchors.fill: parent

      onClicked: {
        // switch between enabled and disabled
        if(settings.soundEnabled) {
          settings.soundEnabled = false
        }
        else {
          settings.soundEnabled = true

          // play sound to signal, that sound is now on
          audioManager.playSound("playerJump")
        }
      }
    }
  }

  // V-Play logo with link to website
  MultiResolutionImage {
    source: "../../assets/logo-vp/logo-vp.png"

    anchors.right: parent.right
    anchors.rightMargin: 30
    anchors.top: header.bottom
    anchors.topMargin: 70

    MouseArea {
      anchors.fill: parent
      onClicked: {
        nativeUtils.displayMessageBox(qsTr("V-Play Game Engine"), qsTr("This game is built with V-Play Game Engine. The source code is available in the free V-Play SDK - so you can build your own platformer in minutes!\n\nVisit V-Play.net now? \n(It contains a tutorial how to use the V-Play Level Editor to create your own platform game and more details)"), 2)
      }
    }
  }

  Connections {
    target: nativeUtils
    onMessageBoxFinished: {
      if(accepted) {
        nativeUtils.openUrl("http://v-play.net/")
      }
    }
  }

}
