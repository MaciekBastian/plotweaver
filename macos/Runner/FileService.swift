//
//  FileService.swift
//  Runner
//
//  Created by Maciej Bastian on 23/12/2023.
//
import Foundation
import AppKit
import FlutterMacOS

class FileService {
    func pickFile(result: FlutterResult) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.title = "pick-file"
        panel.styleMask = .titled
        panel.canHide = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        if panel.runModal() == .OK {
            result(panel.url?.absoluteString)
        } else {
            result(nil)
        }
    }
    
    func pickDirectory(result: FlutterResult) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.titleVisibility = .visible
        panel.title = "pick-folder"
        panel.styleMask = .titled
        panel.canHide = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        
        if panel.runModal() == .OK {
            result(panel.url?.absoluteString)
        } else {
            result(nil)
        }
    }
    
    func createNewProjectFile(result: FlutterResult) {
        let panel = NSSavePanel()
        panel.allowedFileTypes = [
            "weave"
        ]
        if panel.runModal() == .OK {
            result(panel.url?.absoluteString)
        } else {
            result(nil)
        }
    }
}
