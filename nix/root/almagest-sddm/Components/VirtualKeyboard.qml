// Copyright (C) 2025 Sungbae Jeong
// Based on https://github.com/MarianArlt/sddm-sugar-dark
//      and https://github.com/Keyitdev/sddm-astronaut-theme
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.VirtualKeyboard 2.3

InputPanel {
    id: virtualKeyboard
    
    property bool activated: false
    active: activated && Qt.inputMethod.visible
    visible: active
}
