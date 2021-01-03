//
//  ViewController.swift
//  UpdateMyText
//
//  Created by Dennis Schaefer on 12/29/20.
//  Recreated on 01/03/2021.
//

import Cocoa


class ViewController: NSViewController {
    public var saveFilepath = ""

    @IBOutlet var textBox: NSTextView!
    @IBOutlet weak var filenameBox: NSTextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.font = NSFont(name: "Arial Bold", size: 13)
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

   @IBAction func fileButton(_ sender: Any) {
        
        print("openDocument ViewController")

        
        var xfileName:String = filenameBox.stringValue
        print(xfileName)
        if xfileName == "" {
            print("no text?")
            let myAlert = NSAlert()
            myAlert.window.title = "Missing File Name"
            myAlert.messageText = "You must enter a File name!"
            myAlert.addButton(withTitle:"OK")
            myAlert.runModal()
        } else {
            xfileName = xfileName + ".txt"
            if let url = NSOpenPanel().getDirectory {
                //imageView2.image = NSImage(contentsOf: url)
                print("directory selected:", url.path)
                let mypath = "\(url.path)/\(xfileName)"
                print("full path is ", mypath)
                let completeURL = URL(fileURLWithPath:mypath)
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: mypath) {
                    print("\(mypath) exists.")
                
                    let myAlert = NSAlert()
                    myAlert.window.title = "File Overwrite Question"
                    myAlert.messageText = "File Exists!\nOverwrite it?"
                    myAlert.addButton(withTitle:"Yes")
                    myAlert.addButton(withTitle:"No")
                
                    let modalResult = myAlert.runModal()
                
                    switch modalResult {
                    case .alertFirstButtonReturn: // NSApplication.ModalResponse.alertFirstButtonReturn
                        print("Overwrite")
                        let mytext:String = textBox.string
                        print(mytext)
                        do {
                            try mytext.write(to: completeURL, atomically: true, encoding: .utf8)
                            print("successful")
                        } catch {
                            print(error)
                        }
                    default:
                        print("No overwrite")
                    }
                } else {
                    let mytext:String = textBox.string
                        print(mytext)
                        do {
                            try mytext.write(to: completeURL, atomically: true, encoding: .utf8)
                            print("successful")
                        } catch {
                            print(error)
                        }
                }
            } else {
                print("directory selection was canceled")
            }
        }
    filenameBox.stringValue = ""
    }

    @IBAction func processButton(_ sender: Any) {
        
        //empty for future code
        
    }
    
    @IBAction func readButton(_ sender: Any) {
        print("openDocument ViewController")
        if let url = NSOpenPanel().selectUrl {
            //imageView2.image = NSImage(contentsOf: url)
            print("file selected:", url.path)
            let mypieces:Array = url.pathComponents
            var filenamewithextension:String = ""
            for mypart in mypieces {
              filenamewithextension = mypart
            }
            let filenamepieces:Array = filenamewithextension.components(separatedBy: ".txt")
            let filenamewithoutextension:String = filenamepieces[0]
            
            print(filenamewithoutextension)
            filenameBox.stringValue = filenamewithoutextension
            var mytext:String = ""
                        
            try? String(contentsOf: url, encoding: .utf8)
                .split(separator: "\n")
                .forEach { line in
                    if mytext.isEmpty {
                        mytext = String(line)
                    } else {
                        mytext = mytext + "\n" + String(line)
                    }
                    //print("line: \(line)")
                }
            textBox.string = mytext
        } else {
            print("file selection was canceled")
        }
    }
}

extension NSOpenPanel {
    var getDirectory: URL? {
        title = "Select Directory"
        allowsMultipleSelection = false
        canChooseDirectories = true
        canChooseFiles = false
        canCreateDirectories = false
        //allowedFileTypes = ["txt"]  // to allow only images, just comment out this line to allow any file type to be selected
        return runModal() == .OK ? urls.first : nil
    }
    var selectUrl: URL? {
        title = "Select File"
        allowsMultipleSelection = false
        canChooseDirectories = false
        canChooseFiles = true
        canCreateDirectories = false
        //allowedFileTypes = ["txt"]  // to allow only images, just comment out this line to allow any file type to be selected
        return runModal() == .OK ? urls.first : nil
    }
}

