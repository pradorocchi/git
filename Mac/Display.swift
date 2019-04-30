import Git
import AppKit

class Display: NSView {
    private weak var createButton: Button!
    private weak var message: Label!
    private weak var image: NSImageView!
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        image.image = NSImage(named: "logo")
        addSubview(image)
        self.image = image
        
        let message = Label()
        message.font = .systemFont(ofSize: 16, weight: .ultraLight)
        message.textColor = NSColor(white: 1, alpha: 0.6)
        message.alignment = .center
        addSubview(message)
        self.message = message
        
        let createButton = Button(target: NSApp, action: #selector(App.create))
        createButton.setButtonType(.momentaryChange)
        createButton.image = NSImage(named: "createOff")
        createButton.alternateImage = NSImage(named: "createOn")
        createButton.width.constant = 60
        createButton.height.constant = 60
        createButton.isHidden = true
        addSubview(createButton)
        self.createButton = createButton
        
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        image.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        message.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        message.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
        message.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        createButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        createButton.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func repository() {
        alphaValue = 0
        createButton.isHidden = true
    }
    
    func notRepository() {
        alphaValue = 1
        image.image = NSImage(named: "error")
        message.stringValue = .local("Display.notRepository")
        createButton.isHidden = false
    }
    
    func upToDate() {
        alphaValue = 1
        image.image = NSImage(named: "updated")
        message.stringValue = .local("Display.upToDate")
        createButton.isHidden = true
    }
}
