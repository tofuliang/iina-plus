//
//  SuggestionsTableCellView.swift
//  iina+
//
//  Created by xjbeta on 2018/7/8.
//  Copyright © 2018 xjbeta. All rights reserved.
//

import Cocoa

class SuggestionsTableCellView: NSTableCellView {

    var isSelected: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let selectionRect = NSInsetRect(bounds, 0, 0)
        let selectionPath = NSBezierPath(roundedRect: selectionRect, xRadius: 3, yRadius: 3)
        if isSelected {
            if #available(OSX 10.14, *) {
                NSColor.selectedContentBackgroundColor.setFill()
            } else {
                NSColor.customHighlightColor.setFill()
            }
        } else {
            if #available(OSX 10.14, *) {
                NSColor.unemphasizedSelectedContentBackgroundColor.setFill()
            } else {
                NSColor.white.setFill()
            }
        }
        selectionPath.fill()
    }
    
}
