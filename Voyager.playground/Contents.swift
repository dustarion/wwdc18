//: ![Icon for a playground]( VoyagerLogo.png "Voyager Logo")
/*:
 # V O Y A G E R
 ## From the Stars We Came, and to The Stars We Return
 
 Voyager is a short educational playground that I designed and developed for the WWDC2018 scholarship. Made in memory of Stephen Hawking, one of the greatest minds of our time. May he rest in peace.
 > Please Turn On Your Volume
 
 ---
 ## Overview
 Voyager implements two key apple technologies, CoreML and Scenekit. Scenekit is used to render live scenes such as Voyager 1 floating in space and also 3 planets Voyager 1 Visited. CoreML was used to develop Karl, a fictatious Ai with odd sentiments to HAL 9000. Karl is also available as a standalone playground on my github.
 
 ---
 ## *KARL* - Kepler. Absolute. Relative. Logic.
 KARL stands for Kepler. Absolute. Relative. Logic.
 Way smarter than a human and oddly sarcastic, Karl has been developed to pilot Voyager 3 autonomously.
 Beyond that he can detect and express emotion. Recently a NASA intern exposed KARL to an
 episode of Star Wars as a joke, unfortunately he now occasionally jokes about taking over the Galaxy.
 Let’s just hope he isn’t serious.
 KARL gets his own section because he threathened to unleash skynet if I didn't.
 
 ---
 ## Getting Started
 Ensure you are running the latest version of xcode, open the playground file and click on the assistant editor to see the live view. Note that Voyager runs in a ipad sized liveView so do open the playground in fullscreen. I do not own an ipad, as such all testing was limited to the simulator in the liveview in xcode.
 */
let skipToKarl = false
//: > Change the above to true if you want to skip straight to talking to Karl, skipping the story behind Voyager 1 and Karl





/** Dev Notes to Apple :
 *  KarlViewController() has a wierd bug on my machine, when recording the screen with quicktime player,
 *  the keyboard will keep switching to punctuation, closing and opening the playground fixes it.
 *  Could not identify the problem, suspect it might be due to lag causing the mouse to click in unusual places.
 *  Please forgive me if there is bugs when running on an iPad, I was limited to testing on macbook from 2012.
 *
 */





//#-hidden-code
import UIKit
import AVFoundation
import SceneKit
import SceneKit.ModelIO
import PlaygroundSupport


class EndViewController: UIViewController {
    var wwdcLabel: UILabel?
    var quoteLabel: UILabel?
    
    override func viewDidLoad() {
        WwdcLabel()
        QuoteLabel()
    }
    
    func WwdcLabel() {
        print("#WWDC18")
        let label = UILabel(frame: CGRect(x: 232, y: 406, width: 400, height: 76))
        label.center.x = self.view.center.x
        label.textAlignment = .center
        label.text = "#WWDC18"
        label.alpha = 0
        label.textColor = uicolorFromHex(rgbValue: 0x595DFF)
        label.font = UIFont.systemFont(ofSize: 64.0, weight: .medium)
        wwdcLabel = label
        self.view.addSubview(wwdcLabel!)
        wwdcLabel?.fadeIn()
    }
    
    func QuoteLabel() {
        // This is a quote from president Jimmy Carter when voyager 1 was launched!
        print("This is a present from a small, distant world, a token of our sounds, our science, our images, our music, our thoughts and our feelings. We are attempting to survive our time so we may live into yours.")
        let label = UILabel(frame: CGRect(x: 114, y: 502, width: 541, height: 200))
        label.center.x = self.view.center.x
        label.textAlignment = .center
        label.text = "This is a present from a small, distant world, a token of our sounds, our science, our images, our music, our thoughts and our feelings. We are attempting to survive our time so we may live into yours."
        label.alpha = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        label.numberOfLines = 0
        quoteLabel = label
        self.view.addSubview(quoteLabel!)
        quoteLabel?.fadeIn()
    }
    
}
let EndVC = EndViewController()
EndVC.preferredContentSize = UIScreen.main.bounds.size
//PlaygroundPage.current.liveView = EndVC




// MARK:- KarlViewController
// See Karl.swift to understand how Karl Works, this holds a communication protocol to talk to Karl
// This class contains another level of guards and a little filtering of responses.
class KarlViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Some of the outlets we have on the view
    var messageTextField: UITextField?
    var messageTableView: UITableView!
    var nextButton: UIButton?
    
    // Arrays for the messages between Karl and the User, these contain the initial messages which will load into the view.
    var names = ["Karl", "Karl", "Karl", "Karl", "Karl", "Karl"]
    var messages = ["Hello Human, I am built using Core ML. I was trained with a dataset of 600 review comments.","I will try to tell you how you feel based on your message.","I ignore words less than 3 characters.", "I need at least 2 or more words to work properly.", "Try sending me something like 'I am feeling happy', 'I am feeling sad' or 'Who are you'", "When you are done talking to me, send 'Next' to continue."]
    
    // Setup the UI with code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up Keyboard Observers
        NotificationCenter.default.addObserver(self, selector: #selector(KarlViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KarlViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Common Values Needed
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // Create SendMessageBar
        let sendMessageBar = UIView(frame: CGRect(x: 0, y: displayHeight-47, width: displayWidth, height:47))
        sendMessageBar.backgroundColor = uicolorFromHex(rgbValue: 0x1A1A1A)
        
        // Create MessageTextField
        messageTextField = UITextField(frame: CGRect(x: 8, y: 8, width: displayWidth-66, height:30))
        messageTextField?.frame = CGRect(x: 8, y: 8, width: displayWidth-66, height:30)
        messageTextField?.borderStyle = .roundedRect
        messageTextField?.attributedPlaceholder = NSAttributedString(string: "  Enter a Message for Karl", attributes: [NSAttributedStringKey.foregroundColor: uicolorFromHex(rgbValue: 0x9B9B9B)])
        messageTextField?.backgroundColor = UIColor.black
        messageTextField?.textColor = UIColor.white
        sendMessageBar.addSubview(messageTextField!)
        
        // Create Send Button
        let sendButton = UIButton(frame: CGRect(x: (messageTextField?.frame.width)! + 16, y: 8, width: 44, height: 30))
        sendButton.setTitle("Send", for: .normal)
        sendButton.contentMode = .left
        sendButton.setTitleColor(uicolorFromHex(rgbValue: 0x5B5DFF), for: .normal)
        sendButton.addTarget(self, action: #selector(addMessage), for: .touchUpInside)
        sendMessageBar.addSubview(sendButton)
        
        // Add the sendMessageBar to View
        self.view.addSubview(sendMessageBar)
        
        // Create Message TableView
        let messagebarHeight: CGFloat = sendMessageBar.frame.height
        messageTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - messagebarHeight))
        messageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTableView.keyboardDismissMode = .onDrag
        messageTableView.separatorStyle = .none
        messageTableView.allowsSelection = false
        messageTableView.backgroundColor = UIColor.black
        
        // Add the messageTableView to View
        self.view.addSubview(messageTableView)
        
        // Make a next button appear after 30 seconds incase the user gets stuck or something...
        delayWithSeconds(30) { self.createNextButton() }
    }
    
    // This function is called when the 'Send' button is pressed
    @objc func addMessage(sender: UIButton!) {
        print("Sending Message to Karl")
        guard let messageToSend = messageTextField?.text else { return }
        if messageToSend.isEmpty == false {
            self.view.endEditing(true)
            addMessageHuman(Message: messageToSend)
            delayWithSeconds(1, completion: { self.sendToKarl(message: messageToSend) })
            messageTextField?.text = ""
        }
    }
    
    /// Add a message to the table as Karl.
    func addMessageKarl(Message: String) {
        names.append("Karl")
        messages.append(Message)
        // insert row in table
        let indexPath = IndexPath(row: messages.count-1, section: 0)
        messageTableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.left)
        messageTableView.scrollToBottom()
        //messageTableView.reloadData()
    }
    
    /// Add a message to the table as Human (Basically the user inputting a message.)
    func addMessageHuman(Message: String) {
        names.append("Human")
        messages.append(Message)
        messageTableView.reloadData()
        messageTableView.scrollToBottom()
    }
    
    /// Takes a message from a user and adds the response from Karl to the tableview. Communicates with Karl via the class Karl(), located in Karl.swift.
    func sendToKarl(message: String) {
        if message.isEmpty == false {
            switch message {
            case "Open the pod bay doors":
                addMessageKarl(Message: KarlsEmotion.openPodBayDoor.message)
            case "Hello","Hi","hello","hi","Yo", "Hello ":
                addMessageKarl(Message: "Hello Human")
            case "What is your name", "What is your name ", "Who are you", "Who are you ":
                addMessageKarl(Message: "My name is Karl, I am just like you except my body can withstand radiation. However you would die.")
            case "Should dalton get a wwdc scholarship": // hehe
                addMessageKarl(Message: "Yes. My Creator should.")
            case "Next","next","NEXT", "Next ","Go away", "Exit":
                toLaunchScene()
            case "Help", "help", "Help ", "help ":
                addMessageKarl(Message: "Try typing 'I am feeling happy', if you want to leave, type 'Next'")
            case "Karl", "karl":
                addMessageKarl(Message: "What")
            default:
                let response = Karl.predictEmotion(fromString: message)
                let KarlMessage = "I detect an emotion of " + response.emotion + ", " + response.message
                addMessageKarl(Message: KarlMessage)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Message: \(messages[indexPath.row])", indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // Setting up the Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MessageCell")
        cell.backgroundColor = UIColor.black
        guard names.count >= indexPath.row else { return cell }
        guard messages.count >= indexPath.row else { return cell }
        
        let name = names[indexPath.row]
        let text = messages[indexPath.row]
        
        if name == "Karl" {
            cell.textLabel?.text = name
            cell.textLabel?.textColor = uicolorFromHex(rgbValue: 0x4A4A4A)
            cell.detailTextLabel?.text = text
            cell.detailTextLabel?.textColor = uicolorFromHex(rgbValue: 0x9B9B9B)
            // Highlight this line because it's important
            if indexPath.row == 5 {
                cell.detailTextLabel?.textColor = uicolorFromHex(rgbValue: 0xFFD700)
            }
            return cell
        }
        else if name == "Human" {
            cell.textLabel?.text = name
            cell.textLabel?.textColor = uicolorFromHex(rgbValue: 0x5B5DFF)
            cell.detailTextLabel?.text = text
            cell.detailTextLabel?.textColor = UIColor.white
            return cell
        }
        else { return cell }
    }
    
    // Handling Keyboard Notifications in order to move sendMessageBar
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func createNextButton() {
        // The timing should allow the user to read all the content.
        // By fading it in after they have read the content should subconsciously prompt the user to click on it.
            let next = UIButton(frame: CGRect(x: 548, y: 21, width: 186, height: 72))
            next.setTitle("", for: .normal)
            next.setBackgroundImage(UIImage(named: "NextButton.png"), for: .normal)
        next.addTarget(self, action: #selector(self.toLaunchScene), for: .touchUpInside)
            next.alpha = 0
            self.nextButton = next
            self.view.addSubview(next)
            self.nextButton?.fadeIn(completion: { (finished: Bool) -> Void in })
    }
    
    @objc func toLaunchScene(){
        print("Next Button Pressed")
        addMessageKarl(Message: "Goodbye Human")
        view.fadeOut(completion: {
            (finished: Bool) -> Void in
            // Transition to next Scene
            PlaygroundPage.current.liveView = EndVC
        })
    }
}
let KarlVC = KarlViewController()
KarlVC.preferredContentSize = UIScreen.main.bounds.size
//PlaygroundPage.current.liveView = KarlVC




// MARK: - MissionViewController
// Wow this one just gives some context so we can show off Karl. Managed to slip in a star wars reference.
class MissionViewController : UIViewController {
    /**
     *  Brief Explanation :
     *  FADEIN "From the stars we came, and to the stars we return,"
     *  FADEIN "Voyager 3, The Human Touch"
     *  FADEIN Voyager
     *  FADE TO BLACK
     *  TRANSITION TO NEXT SCENE
     */

    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var bodyOneLabel: UILabel?
    var bodyTwoLabel: UILabel?
    var karlLabel: UILabel?
    var karlPointer: UIImageView?
    var voyagerImage: UIImageView?
    var nextButton: UIButton?
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = UIColor.black
        self.view = view
    }
    
    override func viewDidLoad() {
        missionContentTitle()
    }
    
    func missionContentTitle() {
        // Subtitle
        let subtitle = UILabel(frame: CGRect(x: 37, y: 42, width: 600, height: 29))
        subtitle.textAlignment = .left
        subtitle.text = "From the stars we came, and to the stars we return,"
        subtitle.alpha = 0
        subtitle.textColor = UIColor.white
        subtitle.font = UIFont.systemFont(ofSize: 24.0)
        subtitleLabel = subtitle
        
        // Title
        let title = UILabel(frame: CGRect(x: 37, y: 71, width: 472, height: 86))
        title.textAlignment = .left
        title.text = "Voyager 3, The Human Touch"
        title.alpha = 0
        title.numberOfLines = 0
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 36.0, weight: .medium)
        titleLabel = title
        
        self.view.addSubview(subtitle)
        self.view.addSubview(title)
        
        subtitleLabel?.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.titleLabel?.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.voyagerOutline()
            })
        })
    }
    
    func voyagerOutline() {
        let voyagerOutline = UIImageView(frame: CGRect(x: 237, y: 199, width: 327, height: 342))
        voyagerOutline.image = UIImage(named: "Voyager1.png")
        voyagerOutline.alpha = 0
        voyagerImage = voyagerOutline
        self.view.addSubview(voyagerImage!)
        voyagerImage?.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.karlInfo()
        })
    }
    
    func karlInfo() {
        // KarlPointer
        let karlDiagram = UIImageView(frame: CGRect(x: 301, y: 308, width: 247, height: 63))
        karlDiagram.image = UIImage(named: "KarlPointer.png")
        karlDiagram.alpha = 0
        karlPointer = karlDiagram
        
        // KARL label
        let karlText = UILabel(frame: CGRect(x: 559, y: 291, width: 70, height: 29))
        karlText.textAlignment = .left
        karlText.text = "KARL"
        karlText.alpha = 0
        karlText.textColor = UIColor.white
        karlText.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        karlLabel = karlText
        
        // BodyOneLabel, description of Karl
        let karlInfo = UILabel(frame: CGRect(x: 94, y: 586, width: 650, height: 116))
        karlInfo.center.x = self.view.center.x
        karlInfo.textAlignment = .center
        karlInfo.text = "Kepler. Absolute. Relative. Logic. Meet KARL."
        karlInfo.numberOfLines = 0
        karlInfo.alpha = 0
        karlInfo.textColor = uicolorFromHex(rgbValue: 0x595DFF)
        karlInfo.font = UIFont.systemFont(ofSize: 48.0, weight: .light)
        bodyOneLabel = karlInfo
        
        self.view.addSubview(karlPointer!)
        self.view.addSubview(karlLabel!)
        self.view.addSubview(bodyOneLabel!)
        
        karlPointer?.fadeIn()
        karlLabel?.fadeIn()
        bodyOneLabel?.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.titleLabel?.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.karlDescription()
            })
        })
    }
    
    func karlDescription() {
        // BodyTwoLabel, detailed description of Karl
        let karlDescription = UILabel(frame: CGRect(x: 94, y: 727, width: 580, height: 200))
        karlDescription.center.x = self.view.center.x
        karlDescription.textAlignment = .left
        karlDescription.text = "Way smarter than a human and oddly sarcastic, Karl has been developed to pilot Voyager 3 autonomously. Beyond that he can detect and express emotion. Recently a NASA intern exposed KARL to an episode of Star Wars as a joke, unfortunately he now occasionally jokes about taking over the Galaxy. Let’s just hope he isn’t serious."
        karlDescription.numberOfLines = 0
        karlDescription.alpha = 0
        karlDescription.textColor = UIColor.white
        karlDescription.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        bodyTwoLabel = karlDescription
        
        self.view.addSubview(bodyTwoLabel!)
        bodyTwoLabel?.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.titleLabel?.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.createNextButton()
            })
        })
    }
    
    func createNextButton() {
        // The timing should allow the user to read all the content.
        // By fading it in after they have read the content should subconsciously prompt the user to click on it.
        delayWithSeconds(2) {
            let next = UIButton(frame: CGRect(x: 548, y: 925, width: 186, height: 72))
            next.setTitle("", for: .normal)
            next.setBackgroundImage(UIImage(named: "NextButton.png"), for: .normal)
            next.addTarget(self, action: #selector(self.toKarlScene), for: .touchUpInside)
            next.alpha = 0
            self.nextButton = next
            self.view.addSubview(next)
            self.nextButton?.fadeIn(completion: { (finished: Bool) -> Void in })
        }
    }
    
    @objc func toKarlScene() {
        print("Next Button Pressed")
        view.fadeOut(completion: {
            (finished: Bool) -> Void in
            // Transition to next Scene
            PlaygroundPage.current.liveView = KarlVC
        })
    }
    
    
}
let MissionVC = MissionViewController()
MissionVC.preferredContentSize = UIScreen.main.bounds.size
//PlaygroundPage.current.liveView = MissionVC




// MARK: - Voyager3ViewController
class Voyager3ViewController : UIViewController {
    /**
     *  Brief Explanation :
     *  FADEIN "On August 25, 2012, Voyager 1 became the first spacecraft to reach interstellar space. " FADEOUT
     *  FADEIN "It is expected to continue sending data back to earth until around 2025
     *          when its radioisotope thermoelectric generators will no longer supply enough power." FADEOUT
     *  FADEIN Voyager 3
     *  FADEIN First Contact
     *  FADE TO BLACK
     *  TRANSITION TO
     */
    
    var contentLabel: UILabel?
    var firstContactLabel: UILabel?
    
    override func loadView() {
        print("Loading IntroViewController")
        let view = UIView()
        view.backgroundColor = UIColor.black
        self.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        interstelllarMessage()
    }
    
    func interstelllarMessage() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 600, height: 65))
        label.textAlignment = .center
        label.text = "On August 25, 2012, Voyager 1 became the first spacecraft to reach interstellar space."
        label.alpha = 0
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.center = self.view.center
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        contentLabel = label
        self.view.addSubview(label)
        contentLabel?.fadeIn(completion: {
            (finished: Bool) -> Void in
            delayWithSeconds(2) {
                self.contentLabel?.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.starMessage()
                })
            }
        })
    }
    
    func starMessage() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 600, height: 116))
        label.textAlignment = .center
        label.text = "It is expected to continue sending data back to earth until around 2025 when its radioisotope thermoelectric generators will no longer supply enough power."
        label.alpha = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        label.numberOfLines = 0
        label.center = self.view.center
        contentLabel = label
        self.view.addSubview(label)
        contentLabel?.fadeIn(completion: {
            (finished: Bool) -> Void in
            delayWithSeconds(3) {
                self.contentLabel?.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.voyager3()
                })
            }
        })
    }
    
    func voyager3() {
        let label = UILabel(frame: CGRect(x: 249, y: 452, width: 300, height: 86))
        label.textAlignment = .center
        label.text = "Voyager 3"
        label.alpha = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 72.0, weight: .ultraLight)
        label.center.x = self.view.center.x
        contentLabel = label
        self.view.addSubview(label)
        contentLabel = label
        contentLabel?.fadeIn()
        
        let subLabel = UILabel(frame: CGRect(x: 317, y: 538, width: 300, height: 86))
        subLabel.textAlignment = .center
        subLabel.text = "First Contact"
        subLabel.alpha = 0
        subLabel.textColor = UIColor.white
        subLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        subLabel.center.x = self.view.center.x
        firstContactLabel = subLabel
        self.view.addSubview(firstContactLabel!)
        firstContactLabel?.fadeIn()
        delayWithSeconds(2) {
            self.toMissionScene()
        }
        
    }
    
    func toMissionScene() {
        view.fadeOut(completion: {
            (finished: Bool) -> Void in
            // Transition to next Scene
            PlaygroundPage.current.liveView = MissionVC
        })
    }
    
}
let Voyager3VC = Voyager3ViewController()
Voyager3VC.preferredContentSize = UIScreen.main.bounds.size
//PlaygroundPage.current.liveView = Voyager3VC




// MARK: - JourneyViewController
class JourneyViewController : UIViewController {
    /**
     *  Brief Explanation :
     *  Jupiter | Titan | Saturn
     *  Tapping on the planet shows a description of the mission
     *  FADE TO BLACK
     *  TRANSITION TO VOYAGER3 SCENE
     */
    
    // Defining UI Elements / Scenekit Elements
    let scene = SCNScene()
    let cameraNode = SCNNode()
    var planetSelector = UISegmentedControl()
    var subtitleLabel = UILabel()
    var titleLabel = UILabel()
    var instruction1Label = UILabel()
    var instruction2Label = UILabel()
    var nextButton = UIButton()
    var planetDescriptionLabel = UILabel()
    var instructionDescriptionLabel = UILabel()
    var descriptionShowing = false
    
    
    // Defining other Constants
    let planetList = ["Jupiter", "Saturn", "Titan"]
    
    override func loadView() {
        let sceneView = SCNView()
        self.view = sceneView
    }
    
    override func viewDidLayoutSubviews() {
        loadPlanet()
        setupPlanetSegmentedControl()
        setupLabels()
        setupDescription()
        createNextButton()
    }
    
    //  We are using this method as it should have better performance then removing and then creating a new planet node
    /// Changes the planets texture to that of a different planet
    func changePlanetTexture(newTexture: String) {
        guard let existingPlanet = scene.rootNode.childNode(withName: "planet", recursively: true) else { return }
        existingPlanet.geometry?.firstMaterial?.diffuse.contents = UIImage(named: newTexture)
        
        // Add rings if it's Saturn, remove them if not
        if newTexture == Planets.saturn.texture { addRingsToSaturn(node: existingPlanet) }
        else { removeRingsFromPlanet(planet: existingPlanet) }
    }
    
    func removeRingsFromPlanet (planet: SCNNode) {
        // Ensure that the rings actually exist 
        guard let ring = planet.childNode(withName: "ring", recursively: false)
            else { return }
        ring.removeFromParentNode()
    }
    
    
    func loadPlanet(planetTexture: String = Planets.jupiter.texture) {
        let sceneView = self.view as! SCNView
        sceneView.scene = scene
        sceneView.showsStatistics = false
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = false
        let planetNode = createPlanet(withTexture: planetTexture)
        planetNode.name = "planet"
        scene.rootNode.addChildNode(planetNode)
        setupLight()
        setupCamera()
    }
    
    func setupLight() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 5, y: 5, z: 10)
        scene.rootNode.addChildNode(lightNode)
    }
    
    func setupCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x:0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func setupPlanetSegmentedControl() {
        let PlanetSelector = UISegmentedControl(items: planetList)
        PlanetSelector.frame = CGRect(x: 201, y: 800, width: 366, height: 30)
        PlanetSelector.center.x = self.view.center.x
        PlanetSelector.selectedSegmentIndex = 0
        PlanetSelector.layer.cornerRadius = 5.0
        PlanetSelector.backgroundColor = UIColor.black
        PlanetSelector.tintColor = UIColor.white
        PlanetSelector.addTarget(self, action: #selector(self.changePlanet(_:)), for: .valueChanged)
        planetSelector = PlanetSelector
        self.view.addSubview(planetSelector)
    }
    
    @objc func changePlanet(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            print("Changing Planet to Saturn")
            titleLabel.text = Planets.saturn.title
            changePlanetTexture(newTexture: Planets.saturn.texture)
        case 2:
            print("Changing Planet to Titan")
            titleLabel.text = Planets.titan.title
            changePlanetTexture(newTexture: Planets.titan.texture)
        default:
            print("Changing Planet to Jupiter")
            titleLabel.text = Planets.jupiter.title
            changePlanetTexture(newTexture: Planets.jupiter.texture)
        }
    }
    
    func setupLabels() {
        // Subtitle
        let subtitle = UILabel(frame: CGRect(x: 146, y: 62, width: 600, height: 29))
        subtitle.center.x = self.view.center.x
        subtitle.textAlignment = .center
        subtitle.text = "Voyager 1’s mission, a grand tour of the outer planets"
        subtitle.textColor = UIColor.white
        subtitle.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        subtitle.alpha = 0
        subtitleLabel = subtitle
        self.view.addSubview(subtitleLabel)
        subtitleLabel.fadeIn()
        
        // Title
        let title = UILabel(frame: CGRect(x: 221, y: 119, width: 500, height: 86))
        title.center.x = self.view.center.x
        title.textAlignment = .center
        title.text = Planets.jupiter.title
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 72.0, weight: .ultraLight)
        title.alpha = 0
        titleLabel = title
        self.view.addSubview(titleLabel)
        titleLabel.fadeIn()
        
        // Instruction1Label
        let instruction1 = UILabel(frame: CGRect(x: 36, y: 908, width: 500, height: 58))
        instruction1.textAlignment = .left
        instruction1.text = "Tap on the Planet to Learn More About the Mission for each Planet."
        instruction1.textColor = UIColor.white
        instruction1.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        instruction1.numberOfLines = 0
        instruction1.alpha = 0
        instruction1Label = instruction1
        self.view.addSubview(instruction1Label)
        instruction1Label.fadeIn()
        
        // Instruction2Label
        let instruction2 = UILabel(frame: CGRect(x: 36, y: 968, width: 500, height: 29))
        instruction2.textAlignment = .left
        instruction2.text = "Click Next when you’re done viewing."
        instruction2.textColor = UIColor.white
        instruction2.font = UIFont.systemFont(ofSize: 24.0)
        instruction2.alpha = 0
        instruction2Label = instruction2
        self.view.addSubview(instruction2Label)
        instruction2Label.fadeIn()
    }
    
    func setupDescription() {
        let description = UILabel(frame: CGRect(x: 221, y: 667, width: 600, height: 250))
        description.center.x = self.view.center.x
        description.textAlignment = .center
        description.text = Planets.jupiter.description
        description.textColor = UIColor.white
        description.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        description.numberOfLines = 0
        description.alpha = 0
        planetDescriptionLabel = description
        self.view.addSubview(planetDescriptionLabel)
        
        let descriptionInstructions = UILabel(frame: CGRect(x: 148, y: 930, width: 500, height: 29))
        descriptionInstructions.center.x = self.view.center.x
        descriptionInstructions.textAlignment = .center
        descriptionInstructions.text = "Tap on the planet again to dismiss."
        descriptionInstructions.textColor = UIColor.white
        descriptionInstructions.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        descriptionInstructions.alpha = 0
        instructionDescriptionLabel = descriptionInstructions
        self.view.addSubview(instructionDescriptionLabel)
    }
    
    func createNextButton() {
        // The timing should allow the user to read all the content.
        // By fading it in after they have read the content should subconsciously prompt the user to click on it.
        let next = UIButton(frame: CGRect(x: 548, y: 925, width: 186, height: 72))
        next.setTitle("", for: .normal)
        next.setBackgroundImage(UIImage(named: "NextButton.png"), for: .normal)
        next.addTarget(self, action: #selector(self.toVoyager3Scene), for: .touchUpInside)
        //next.alpha = 0
        self.nextButton = next
        self.view.addSubview(next)
        //self.nextButton?.fadeIn(completion: { (finished: Bool) -> Void in })
    }
    
    @objc func toVoyager3Scene(){
        print("Next Button Pressed")
        view.fadeOut(completion: {
            (finished: Bool) -> Void in
            // Transition to next Scene
            PlaygroundPage.current.liveView = Voyager3VC
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let tapLocation = touch.location(in: self.view)
        print(tapLocation)
        let sceneView = self.view as! SCNView
        let hitTestResults = sceneView.hitTest(tapLocation, options: nil)
        // This approach only works because we have a single SCNNode
        // If you are adding more Nodes, please check the hitTest Results for the Node you want.
        if !(hitTestResults.count == 0) {
            if descriptionShowing == false {
                planetDescriptionShow()
            }
            else {
                planetDescriptionHide()
            }
        }
    }
    
    func planetDescriptionShow() {
        // First set the label's text
        if titleLabel.text == Planets.jupiter.title {
            planetDescriptionLabel.text = Planets.jupiter.description
        }
        else if titleLabel.text == Planets.saturn.title {
            planetDescriptionLabel.text = Planets.saturn.description
        }
        else {
            planetDescriptionLabel.text = Planets.titan.description
        }
        
        // Hide the stuff that is at the bottom of the screen
        instruction1Label.alpha = 0
        instruction2Label.alpha = 0
        nextButton.alpha = 0
        nextButton.isEnabled = false
        planetSelector.isHidden = true
        planetDescriptionLabel.fadeIn()
        instructionDescriptionLabel.fadeIn()
        descriptionShowing = true
    }
    
    func planetDescriptionHide() {
        planetDescriptionLabel.fadeOut()
        instructionDescriptionLabel.fadeOut()
        descriptionShowing = false
        delayWithSeconds(1) {
            self.instruction1Label.fadeIn()
            self.instruction2Label.fadeIn()
            self.nextButton.fadeIn()
            self.nextButton.isEnabled = true
        }
        delayWithSeconds(1.5) {
            self.planetSelector.isHidden = false
        }
    }
}
let JourneyVC = JourneyViewController()
JourneyVC.preferredContentSize = UIScreen.main.bounds.size
//PlaygroundPage.current.liveView = JourneyVC




// MARK: - VoyagerViewController
// This has really low fps on the xcode simulator but I don't have an ipad and my mac is from 2012.
// Hopefully it isn't actually this slow, I've attempted to reduce the number of polygons which has improved performance.
// I obtained the Voyager 1 Model from Nasa's Website as a .blend file and exported it to .dae -> .scn
class VoyagerViewController : UIViewController {
    /**
     *  Brief Explanation :
     *  LOAD VOYAGER 1 SCENE. this consists of Voyager.scn and StarsParticles.scnp
     *  FADEIN "On the 5th of September 1977,"
     *  FADEIN "The Human Race Launched the Voyager 1 Probe."
     *  FADEIN "21,155,008,058 km away from earth"
     *      This will update with an estimation of Voyager 1's distance via offline calculations.
     *      See: GlobalFunctions.swift / voyagerDistanceFromSun() for how it works.
     *  FADEIN "On the 5th of September 1977,"
     *  FADEIN "Leaving our legacy buried within the stars"
     *  FADEIN NEXT BUTTON
     *  NEXT BUTTON = FADE TO BLACK * TRANSITION TO MISSION SCENE
     */
    
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var distanceLabel: UILabel?
    var explanationLabel: UILabel?
    var nextButton: UIButton?
    weak var timer = Timer()
    
    override func loadView() {
        let scnview = SCNView()
        self.view = scnview
        // Uncomment this next line if it's too low fps and you would like to still experience it well.
        // scnview.isUserInteractionEnabled = false
        voyagerScene()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voyagerContentTitle()
    }
    
    func voyagerScene() {
        let scene = SCNScene()
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x:0, y: 0, z: 20)
        scene.rootNode.addChildNode(cameraNode)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
        scene.rootNode.addChildNode(lightNode)
        let stars = SCNParticleSystem(named: "StarsParticles.scnp", inDirectory: nil)!
        scene.rootNode.addParticleSystem(stars)
        let voyager = SCNScene(named: "Voyager.scn")!
        let voyagerNode = voyager.rootNode
        scene.rootNode.addChildNode(voyagerNode)
        let action = SCNAction.rotate(by: 360 * CGFloat(Double.pi / 180), around: SCNVector3(x:0, y:2, z:1), duration: 120)
        let repeatAction = SCNAction.repeatForever(action)
        voyagerNode.runAction(repeatAction)
        let sceneView = self.view as! SCNView
        sceneView.scene = scene
        sceneView.showsStatistics = false
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
    }
    
    func voyagerContentTitle() {
        // Subtitle
        let subtitle = UILabel(frame: CGRect(x: 37, y: 42, width: 400, height: 29))
        subtitle.textAlignment = .left
        subtitle.text = "On the 5th of September 1977,"
        subtitle.alpha = 0
        subtitle.textColor = UIColor.white
        subtitle.font = UIFont.systemFont(ofSize: 24.0)
        subtitleLabel = subtitle
        
        // Title
        let title = UILabel(frame: CGRect(x: 37, y: 71, width: 472, height: 86))
        title.textAlignment = .left
        title.text = "Humanity Launched the Voyager 1 Probe."
        title.alpha = 0
        title.numberOfLines = 0
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 36.0, weight: .medium)
        titleLabel = title
        
        self.view.addSubview(subtitle)
        self.view.addSubview(title)
        
        subtitleLabel?.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.titleLabel?.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.voyagerDistance()
            })
        })
    }
    
    func voyagerDistance() {
        // The distance of voyager is estimated based on a calculation of the
        // speed of voyager 1 and the time of its epoch.
        // Distance Label
        let distance = UILabel(frame: CGRect(x: 37, y: 932, width: 472, height: 29))
        distance.textAlignment = .left
        distance.text = "21,155,008,058 km away from earth"
        distance.alpha = 0
        distance.textColor = UIColor.white
        distance.font = UIFont.boldSystemFont(ofSize: 24.0)
        distanceLabel = distance
        
        // Explanation Label
        let explanation = UILabel(frame: CGRect(x: 37, y: 968, width: 472, height: 29))
        explanation.textAlignment = .left
        explanation.text = "Live Render of Voyager 1 using Scenekit"
        explanation.alpha = 0
        explanation.textColor = UIColor.white
        explanation.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light)
        explanationLabel = explanation
        
        self.view.addSubview(explanation)
        self.view.addSubview(distance)
        startUpdatingDistance()
        self.distanceLabel?.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.startUpdatingDistance()
            self.explanationLabel?.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.createNextButton()
            })
        })
    }
    
    func createNextButton() {
        // The timing should allow the user to read all the content.
        // By fading it in after they have read the content should subconsciously prompt the user to click on it.
            let next = UIButton(frame: CGRect(x: 548, y: 925, width: 186, height: 72))
            next.setTitle("", for: .normal)
            next.setBackgroundImage(UIImage(named: "NextButton.png"), for: .normal)
            next.addTarget(self, action: #selector(self.toJourneyScene), for: .touchUpInside)
            next.alpha = 0
            self.nextButton = next
            self.view.addSubview(next)
            self.nextButton?.fadeIn(completion: { (finished: Bool) -> Void in })
    }
    
    func startUpdatingDistance () {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            let distanceMessage = "Distance from our Sun " + NumberFormatter.localizedString(from: NSNumber(value: voyagerDistanceFromSun()), number: NumberFormatter.Style.decimal) + "km"
            self.distanceLabel?.text = distanceMessage
        })
    }
    
    @objc func toJourneyScene() {
        print("Next Button Pressed")
        view.fadeOut(completion: {
            (finished: Bool) -> Void in
            // Transition to next Scene
            PlaygroundPage.current.liveView = JourneyVC
        })
    }
}
let VoyagerVC = VoyagerViewController()
VoyagerVC.preferredContentSize = UIScreen.main.bounds.size
//PlaygroundPage.current.liveView = VoyagerVC




// MARK: - IntroViewController
class IntroViewController : UIViewController {
    /**
     *  Brief Explanation :
     *  FADEIN "In Memory of Carl Sagan" FADEOUT
     *  FADEIN "From the stars we came, and to the stars we return." FADEOUT
     *  FADEIN Voyager Logo
     *  FADE TO BLACK
     *  TRANSITION TO VOYAGER SCENE
     */
    
    var contentLabel: UILabel?
    var logo: UIImageView?
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = UIColor.black
        self.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stephenHawking()
        playSound()
    }
    
    func stephenHawking() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 600, height: 29))
        label.center = self.view.center
        label.textAlignment = .center
        label.text = "In Memory of Stephen Hawking"
        label.alpha = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        contentLabel = label
        self.view.addSubview(label)
        contentLabel?.fadeIn(completion: {
            (finished: Bool) -> Void in
            delayWithSeconds(3){
                self.contentLabel?.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.starMessage()
                })
            }
        })
    }
    
    func starMessage() {
        print("From the Stars We Came, and to The Stars We Return")
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 600, height: 29))
        label.center = self.view.center
        label.textAlignment = .center
        label.text = "From the stars we came, and to the stars we return."
        label.alpha = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        contentLabel = label
        self.view.addSubview(label)
        contentLabel?.fadeIn(completion: {
            (finished: Bool) -> Void in
            delayWithSeconds(3){
                self.contentLabel?.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.voyagerLogo()
                })
            }
        })
    }
    
    func voyagerLogo() {
        let voyagerLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 547, height: 357))
        voyagerLogo.center = self.view.center
        voyagerLogo.image = UIImage(named: "VoyagerLogo.png")
        voyagerLogo.alpha = 0
        logo = voyagerLogo
        self.view.addSubview(voyagerLogo)
        logo?.fadeIn(completion: {
            (finished: Bool) -> Void in
            delayWithSeconds(3){
                self.logo?.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.toVoyagerScene()
                })
            }
        })
    }
    
    func toVoyagerScene() {
        // Transitiion to voyager scene
        PlaygroundPage.current.liveView = VoyagerVC
    }
    
}
let IntroVC = IntroViewController()
IntroVC.preferredContentSize = UIScreen.main.bounds.size
//PlaygroundPage.current.liveView = IntroVC




/// Main Display Selection
if skipToKarl { PlaygroundPage.current.liveView = KarlVC }
else { PlaygroundPage.current.liveView = IntroVC }
//#-end-hidden-code
