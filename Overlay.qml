import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs.Commons
import qs.Ui
import "SubmapsModel.js" as SubmapsModel

Item {
  id: root

  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null

  property bool opened: false
  property string currentSubmapName: "Hub"
  property var currentSubmap: SubmapsModel.getSubmap("Hub")

  // Auto-hide after 15s of inactivity
  Timer {
    id: autoHideTimer
    interval: 15000
    repeat: false
    onTriggered: root.close()
  }

  // Watch for user configuration (~/.config/omarchy/submaps.json)
  property FileView userConfigFile: FileView {
    id: userConfigFile
    path: Quickshell.env("HOME") + "/.config/omarchy/submaps.json"
    watchChanges: true
    printErrors: false
    onLoaded: {
      SubmapsModel.setUserConfig(text())
      if (root.opened) {
        root.currentSubmap = SubmapsModel.getSubmap(root.currentSubmapName)
      }
    }
    onLoadFailed: {
      SubmapsModel.setUserConfig("")
    }
    onFileChanged: reload()
  }

  function open(payloadJson) {
    var name = "Hub";
    var dynamicOverrides = null;

    if (typeof payloadJson === "string") {
      try {
        var parsed = JSON.parse(payloadJson || "{}");
        if (parsed && typeof parsed === "object") {
          if (parsed.submap) name = String(parsed.submap);
          if (parsed.submaps) dynamicOverrides = parsed.submaps;
        } else if (typeof parsed === "string" && parsed.trim().length > 0) {
          name = parsed.trim();
        }
      } catch (e) {
        if (payloadJson && payloadJson.trim().length > 0) {
          name = payloadJson.trim();
        }
      }
    } else if (payloadJson && typeof payloadJson === "object") {
      if (payloadJson.submap) name = String(payloadJson.submap);
      if (payloadJson.submaps) dynamicOverrides = payloadJson.submaps;
    }

    root.currentSubmapName = name;
    root.currentSubmap = SubmapsModel.getSubmap(name, dynamicOverrides);
    root.opened = true;
    autoHideTimer.restart();
  }

  function close() {
    autoHideTimer.stop();
    root.opened = false;
  }

  function dismiss() {
    root.close();
    if (root.shell && typeof root.shell.hide === "function") {
      root.shell.hide((root.manifest && root.manifest.id) || "omarchy-vimified");
    }
  }

  function toggle(payloadJson) {
    if (root.opened) root.dismiss();
    else root.open(payloadJson);
  }

  PanelWindow {
    id: panel
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    WlrLayershell.namespace: "omarchy-vimified"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    exclusionMode: ExclusionMode.Ignore
    mask: Region {}

    readonly property var entries: (root.currentSubmap && root.currentSubmap.entries) || []
    readonly property bool isTwoCol: entries.length > 14
    readonly property int midIndex: Math.ceil(entries.length / 2)
    readonly property var col1Entries: isTwoCol ? entries.slice(0, midIndex) : entries
    readonly property var col2Entries: isTwoCol ? entries.slice(midIndex) : []

    readonly property real col1KeyWidth: SubmapsModel.calcKeyWidth(col1Entries)
    readonly property real col2KeyWidth: isTwoCol ? SubmapsModel.calcKeyWidth(col2Entries) : 0

    readonly property real calculatedEntriesWidth: isTwoCol
      ? (col1.implicitWidth + entriesContainer.spacing + col2.implicitWidth)
      : col1.implicitWidth

    readonly property real headerMinWidth: iconWrapper.width + 10 + titleCol.implicitWidth + 24 + activeBadge.width
    readonly property real footerMinWidth: escBadge.width + 6 + footerDesc.implicitWidth
    readonly property real cardInnerWidth: Math.max(260, calculatedEntriesWidth, headerMinWidth, footerMinWidth)

    BorderSurface {
      id: card
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.topMargin: 54
      anchors.rightMargin: 20
      width: panel.cardInnerWidth + 28
      height: contentColumn.implicitHeight + 22
      color: Color.menu.background
      borderSpec: Border.surfaceSpec("menu", "border", Color.menu.border, 1)
      radius: Style.cornerRadius > 0 ? Style.cornerRadius : 8

      Column {
        id: contentColumn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 12
        anchors.leftMargin: 14
        spacing: 0

        // Header
        Item {
          id: headerBox
          width: panel.cardInnerWidth
          height: Math.max(iconWrapper.height, titleCol.implicitHeight, activeBadge.height)

          Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Item {
              id: iconWrapper
              width: 22
              height: 22
              anchors.verticalCenter: parent.verticalCenter

              Image {
                id: svgIcon
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: (root.currentSubmap && root.currentSubmap.iconSvg) || ""
                visible: source !== ""
              }

              Text {
                id: fallbackIcon
                anchors.centerIn: parent
                visible: !svgIcon.visible
                text: (root.currentSubmap && root.currentSubmap.icon) || "⚡"
                color: "#7aa2f7"
                font.family: Style.fontFamily
                font.pixelSize: 18
                renderType: Text.NativeRendering
              }
            }

            Column {
              id: titleCol
              anchors.verticalCenter: parent.verticalCenter
              spacing: 1

              Text {
                id: titleText
                text: (root.currentSubmap && root.currentSubmap.title) || ""
                color: "#c0caf5"
                font.family: Style.fontFamily
                font.pixelSize: 14
                font.bold: true
                renderType: Text.NativeRendering
              }

              Text {
                id: tagText
                text: (root.currentSubmap && root.currentSubmap.tag) || ""
                color: "#566b88"
                font.family: Style.fontFamily
                font.pixelSize: 9.5
                font.bold: true
                renderType: Text.NativeRendering
              }
            }
          }

          Rectangle {
            id: activeBadge
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            color: "#161f30"
            border.width: 1
            border.color: "#273750"
            radius: 4
            width: activeText.implicitWidth + 14
            height: activeText.implicitHeight + 4

            Text {
              id: activeText
              anchors.centerIn: parent
              text: "ACTIVE"
              color: "#7aa2f7"
              font.family: Style.fontFamily
              font.pixelSize: 9.5
              font.bold: true
              renderType: Text.NativeRendering
            }
          }
        }

        Item { width: 1; height: 6 }

        Rectangle {
          id: topSep
          width: panel.cardInnerWidth
          height: 1
          color: "#1e293b"
        }

        Item { width: 1; height: 8 }

        // Entries Container
        Row {
          id: entriesContainer
          spacing: 20

          Column {
            id: col1
            spacing: 5

            Repeater {
              model: panel.col1Entries

              delegate: Row {
                spacing: 9

                Rectangle {
                  id: keyBadge1
                  width: panel.col1KeyWidth
                  height: 20
                  radius: 4
                  color: "#161f30"
                  border.width: 1
                  border.color: "#273750"
                  anchors.verticalCenter: parent.verticalCenter

                  Text {
                    anchors.centerIn: parent
                    text: modelData[0] || ""
                    color: "#7aa2f7"
                    font.family: Style.fontFamily
                    font.pixelSize: 11
                    font.bold: true
                    renderType: Text.NativeRendering
                  }
                }

                Text {
                  text: modelData[1] || ""
                  color: "#a9b1d6"
                  font.family: Style.menuFontFamily || Style.fontFamily
                  font.pixelSize: 12.5
                  anchors.verticalCenter: parent.verticalCenter
                  renderType: Text.NativeRendering
                }
              }
            }
          }

          Column {
            id: col2
            visible: panel.isTwoCol
            spacing: 5

            Repeater {
              model: panel.col2Entries

              delegate: Row {
                spacing: 9

                Rectangle {
                  id: keyBadge2
                  width: panel.col2KeyWidth
                  height: 20
                  radius: 4
                  color: "#161f30"
                  border.width: 1
                  border.color: "#273750"
                  anchors.verticalCenter: parent.verticalCenter

                  Text {
                    anchors.centerIn: parent
                    text: modelData[0] || ""
                    color: "#7aa2f7"
                    font.family: Style.fontFamily
                    font.pixelSize: 11
                    font.bold: true
                    renderType: Text.NativeRendering
                  }
                }

                Text {
                  text: modelData[1] || ""
                  color: "#a9b1d6"
                  font.family: Style.menuFontFamily || Style.fontFamily
                  font.pixelSize: 12.5
                  anchors.verticalCenter: parent.verticalCenter
                  renderType: Text.NativeRendering
                }
              }
            }
          }
        }

        Item { width: 1; height: 8 }

        Rectangle {
          id: botSep
          width: panel.cardInnerWidth
          height: 1
          color: "#1e293b"
        }

        Item { width: 1; height: 6 }

        // Footer Box
        Row {
          id: footerBox
          spacing: 6

          Rectangle {
            id: escBadge
            width: escText.implicitWidth + 10
            height: 18
            radius: 3
            color: "#141b29"
            border.width: 1
            border.color: "#1e293b"
            anchors.verticalCenter: parent.verticalCenter

            Text {
              id: escText
              anchors.centerIn: parent
              text: "ESC"
              color: "#566b88"
              font.family: Style.fontFamily
              font.pixelSize: 10
              font.bold: true
              renderType: Text.NativeRendering
            }
          }

          Text {
            id: footerDesc
            anchors.verticalCenter: parent.verticalCenter
            text: "Cancel / Exit"
            color: "#566b88"
            font.family: Style.fontFamily
            font.pixelSize: 11
            renderType: Text.NativeRendering
          }
        }
      }
    }
  }
}
