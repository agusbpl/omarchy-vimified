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

  // Pure Terminal / Neovim Monospace Font
  readonly property string monoFont: "JetBrainsMono Nerd Font"

  property bool opened: false
  property string currentSubmapName: "Hub"
  property var currentSubmap: SubmapsModel.getSubmap("Hub")

  // Auto-hide after 20s of inactivity
  Timer {
    id: autoHideTimer
    interval: 20000
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

    // Card dimensions
    readonly property real calculatedEntriesWidth: isTwoCol
      ? (col1.implicitWidth + entriesContainer.spacing + col2.implicitWidth)
      : col1.implicitWidth

    readonly property real headerMinWidth: iconWrapper.width + 10 + titleCol.implicitWidth + 20
    readonly property real footerMinWidth: escBadge.width + 8 + footerDesc.implicitWidth
    readonly property real cardInnerWidth: Math.max(240, calculatedEntriesWidth, headerMinWidth, footerMinWidth)

    // =========================================================================
    // TERMINAL / NEOVIM CARD (Square Corners, Sharp 1px Border, Pure Monospace)
    // =========================================================================
    Rectangle {
      id: card
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.topMargin: 54
      anchors.rightMargin: 20
      width: panel.cardInnerWidth + 30
      height: contentColumn.implicitHeight + 24
      color: "#10141f"
      border.color: "#7aa2f7"
      border.width: 1
      radius: 0 // Sharp square terminal corners

      Column {
        id: contentColumn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 12
        anchors.leftMargin: 15
        spacing: 0

        // ==========================================
        // 1. TERMINAL HEADER ([ Title ])
        // ==========================================
        Item {
          id: headerBox
          width: panel.cardInnerWidth
          height: Math.max(iconWrapper.height, titleCol.implicitHeight)

          Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Item {
              id: iconWrapper
              width: 20
              height: 20
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
                font.family: root.monoFont
                font.pixelSize: 16
                renderType: Text.NativeRendering
              }
            }

            Column {
              id: titleCol
              anchors.verticalCenter: parent.verticalCenter
              spacing: 2

              Text {
                id: titleText
                text: (root.currentSubmap && root.currentSubmap.title) || ""
                color: "#c0caf5"
                font.family: root.monoFont
                font.pixelSize: 14
                font.bold: true
                renderType: Text.NativeRendering
              }

              Text {
                id: tagText
                text: (root.currentSubmap && root.currentSubmap.tag) || ""
                color: "#566b88"
                font.family: root.monoFont
                font.pixelSize: 10
                font.bold: true
                renderType: Text.NativeRendering
              }
            }
          }
        }

        Item { width: 1; height: 8 }

        // Divider
        Rectangle {
          id: topSep
          width: panel.cardInnerWidth
          height: 1
          color: "#1e293b"
        }

        Item { width: 1; height: 9 }

        // ==========================================
        // 2. WHICH-KEY BINDINGS LIST (Columns)
        // ==========================================
        Row {
          id: entriesContainer
          spacing: 20

          // Column 1
          Column {
            id: col1
            spacing: 6

            Repeater {
              model: panel.col1Entries

              delegate: Row {
                spacing: 10

                // Key Badge: [ key ] (Square corners)
                Rectangle {
                  id: keyBadge1
                  width: panel.col1KeyWidth
                  height: 21
                  radius: 0 // Sharp square corner
                  color: "#161f30"
                  border.width: 1
                  border.color: "#273750"
                  anchors.verticalCenter: parent.verticalCenter

                  Text {
                    anchors.centerIn: parent
                    text: modelData[0] || ""
                    color: "#7dcfff"
                    font.family: root.monoFont
                    font.pixelSize: 11
                    font.bold: true
                    renderType: Text.NativeRendering
                  }
                }

                // Action description
                Row {
                  anchors.verticalCenter: parent.verticalCenter
                  spacing: 1

                  Text {
                    readonly property bool isGroup: (modelData[1] || "").indexOf("+") === 0
                    visible: isGroup
                    text: "+"
                    color: "#bb9af7"
                    font.family: root.monoFont
                    font.pixelSize: 12
                    font.bold: true
                    renderType: Text.NativeRendering
                  }

                  Text {
                    readonly property bool isGroup: (modelData[1] || "").indexOf("+") === 0
                    text: isGroup ? modelData[1].substring(1) : (modelData[1] || "")
                    color: isGroup ? "#bb9af7" : "#c0caf5"
                    font.family: root.monoFont
                    font.pixelSize: 12
                    renderType: Text.NativeRendering
                  }
                }
              }
            }
          }

          // Column 2 (if > 14 entries)
          Column {
            id: col2
            visible: panel.isTwoCol
            spacing: 6

            Repeater {
              model: panel.col2Entries

              delegate: Row {
                spacing: 10

                Rectangle {
                  id: keyBadge2
                  width: panel.col2KeyWidth
                  height: 21
                  radius: 0 // Sharp square corner
                  color: "#161f30"
                  border.width: 1
                  border.color: "#273750"
                  anchors.verticalCenter: parent.verticalCenter

                  Text {
                    anchors.centerIn: parent
                    text: modelData[0] || ""
                    color: "#7dcfff"
                    font.family: root.monoFont
                    font.pixelSize: 11
                    font.bold: true
                    renderType: Text.NativeRendering
                  }
                }

                Row {
                  anchors.verticalCenter: parent.verticalCenter
                  spacing: 1

                  Text {
                    readonly property bool isGroup: (modelData[1] || "").indexOf("+") === 0
                    visible: isGroup
                    text: "+"
                    color: "#bb9af7"
                    font.family: root.monoFont
                    font.pixelSize: 12
                    font.bold: true
                    renderType: Text.NativeRendering
                  }

                  Text {
                    readonly property bool isGroup: (modelData[1] || "").indexOf("+") === 0
                    text: isGroup ? modelData[1].substring(1) : (modelData[1] || "")
                    color: isGroup ? "#bb9af7" : "#c0caf5"
                    font.family: root.monoFont
                    font.pixelSize: 12
                    renderType: Text.NativeRendering
                  }
                }
              }
            }
          }
        }

        Item { width: 1; height: 9 }

        // Divider
        Rectangle {
          id: botSep
          width: panel.cardInnerWidth
          height: 1
          color: "#1e293b"
        }

        Item { width: 1; height: 7 }

        // ==========================================
        // 3. FOOTER (Which-Key Exit)
        // ==========================================
        Row {
          id: footerBox
          spacing: 7

          Rectangle {
            id: escBadge
            width: escText.implicitWidth + 10
            height: 19
            radius: 0 // Sharp square corner
            color: "#162032"
            border.width: 1
            border.color: "#2a3b5c"
            anchors.verticalCenter: parent.verticalCenter

            Text {
              id: escText
              anchors.centerIn: parent
              text: "ESC"
              color: "#7aa2f7"
              font.family: root.monoFont
              font.pixelSize: 10
              font.bold: true
              renderType: Text.NativeRendering
            }
          }

          Text {
            id: footerDesc
            anchors.verticalCenter: parent.verticalCenter
            text: "exit"
            color: "#566b88"
            font.family: root.monoFont
            font.pixelSize: 11
            renderType: Text.NativeRendering
          }
        }
      }
    }
  }
}
