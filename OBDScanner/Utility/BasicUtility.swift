
import UIKit
import SystemConfiguration
class ShowToast: NSObject {
    static var lastToastLabelReference:UILabel?
    static var initialYPos:CGFloat = 0
    class func show(toatMessage:String){
        if let app = UIApplication.shared.delegate as? AppDelegate, let keyWindow = app.window{
            ShowHud.hide()
            if lastToastLabelReference != nil{
                let prevMessage = lastToastLabelReference!.text?.replacingOccurrences(of: " ", with: "").lowercased()
                let currentMessage = toatMessage.replacingOccurrences(of: " ", with: "").lowercased()
                if prevMessage == currentMessage{
                    return
                }
            }
            let cornerRadious:CGFloat = 12
            let toastContainerView:UIView={
                let view = UIView()
                view.layer.cornerRadius = cornerRadious
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = UIColor.rgb(24, green: 54, blue: 91, a: 1.0)
                view.alpha = 0.8
                return view
            }()
            let labelForMessage:UILabel={
                let label = UILabel()
                label.layer.cornerRadius = cornerRadious
                label.layer.masksToBounds = true
                label.textAlignment = .center
                label.numberOfLines = 0
                label.adjustsFontSizeToFitWidth = true
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = toatMessage
                label.textColor = .white
                label.backgroundColor = UIColor.init(white: 0, alpha: 0)
                return label
            }()
            
            keyWindow.addSubview(toastContainerView)
        
            let fontType = UIFont.boldSystemFont(ofSize: DeviceType.isIpad() ? 26 : 12)
            labelForMessage.font = fontType
            let sizeOfMessage = NSString(string: toatMessage).boundingRect(with: CGSize(width: keyWindow.frame.width, height: keyWindow.frame.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:fontType], context: nil)
            let topAnchor = toastContainerView.bottomAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0)
            keyWindow.addConstraint(topAnchor)
            toastContainerView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor, constant: 0).isActive = true
            var extraHeight:CGFloat = 0
            if (keyWindow.frame.size.width) < (sizeOfMessage.width+20) {
                extraHeight = (sizeOfMessage.width+20) - (keyWindow.frame.size.width)
                toastContainerView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor, constant: 5).isActive = true
                toastContainerView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor, constant: -5).isActive = true
            }else{
                toastContainerView.widthAnchor.constraint(equalToConstant: sizeOfMessage.width+20).isActive = true
            }
            let totolHeight:CGFloat = sizeOfMessage.height+25+extraHeight
            toastContainerView.heightAnchor.constraint(equalToConstant:totolHeight).isActive = true
            toastContainerView.addSubview(labelForMessage)
            lastToastLabelReference = labelForMessage
            labelForMessage.topAnchor.constraint(equalTo: toastContainerView.topAnchor, constant: 0).isActive = true
            labelForMessage.bottomAnchor.constraint(equalTo: toastContainerView.bottomAnchor, constant: 0).isActive = true
            labelForMessage.leftAnchor.constraint(equalTo: toastContainerView.leftAnchor, constant: 5).isActive = true
            labelForMessage.rightAnchor.constraint(equalTo: toastContainerView.rightAnchor, constant: -5).isActive = true
            keyWindow.layoutIfNeeded()
            
            let padding:CGFloat = initialYPos == 0 ? (DeviceType.isIpad() ? 140 : 100) : 10 // starting position
            initialYPos += padding+totolHeight
            topAnchor.constant = initialYPos
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
                keyWindow.layoutIfNeeded()
            }, completion: { (bool) in
                topAnchor.constant = 0
                UIView.animate(withDuration: 0.4, delay: 3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                    keyWindow.layoutIfNeeded()
                }, completion: { (bool) in
                    if let lastToastShown = lastToastLabelReference,labelForMessage == lastToastShown{
                        lastToastLabelReference = nil
                    }
                    initialYPos -= (padding+totolHeight)
                    toastContainerView.removeFromSuperview()
                })
            })
        }
    }
}

class ShowGreetingToast: NSObject {
    static var lastToastLabelReference:UILabel?
    static var initialYPos:CGFloat = 0
    class func show(toatMessage:String){
        if let app = UIApplication.shared.delegate as? AppDelegate, let keyWindow = app.window{
            ShowHud.hide()
            if lastToastLabelReference != nil{
                let prevMessage = lastToastLabelReference!.text?.replacingOccurrences(of: " ", with: "").lowercased()
                let currentMessage = toatMessage.replacingOccurrences(of: " ", with: "").lowercased()
                if prevMessage == currentMessage{
                    return
                }
            }
            let cornerRadious:CGFloat = 12
            let toastContainerView:UIView={
                let view = UIView()
                view.layer.cornerRadius = cornerRadious
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = UIColor.black//UIColor.buttonBackgroundColor()
                view.alpha = 0.8
                return view
            }()
            let labelForMessage:UILabel={
                let label = UILabel()
                label.layer.cornerRadius = cornerRadious
                label.layer.masksToBounds = true
                label.textAlignment = .center
                label.numberOfLines = 0
                label.adjustsFontSizeToFitWidth = true
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = toatMessage
                label.textColor = .white
                label.backgroundColor = UIColor.init(white: 0, alpha: 0)
                return label
            }()
            
            keyWindow.addSubview(toastContainerView)
            
            let fontType = UIFont.boldSystemFont(ofSize: DeviceType.isIpad() ? 26 : 14)
            labelForMessage.font = fontType
            let sizeOfMessage = NSString(string: toatMessage).boundingRect(with: CGSize(width: keyWindow.frame.width, height: keyWindow.frame.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:fontType], context: nil)
            let topAnchor = toastContainerView.bottomAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0)
            keyWindow.addConstraint(topAnchor)
            toastContainerView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor, constant: 0).isActive = true
            var extraHeight:CGFloat = 0
            if (keyWindow.frame.size.width) < (sizeOfMessage.width+30) {
                extraHeight = (sizeOfMessage.width+30) - (keyWindow.frame.size.width)
                toastContainerView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor, constant: 5).isActive = true
                toastContainerView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor, constant: -5).isActive = true
            }else{
                toastContainerView.widthAnchor.constraint(equalToConstant: sizeOfMessage.width+30).isActive = true
            }
            let totolHeight:CGFloat = sizeOfMessage.height+30+extraHeight
            toastContainerView.heightAnchor.constraint(equalToConstant:totolHeight).isActive = true
            toastContainerView.addSubview(labelForMessage)
            lastToastLabelReference = labelForMessage
            labelForMessage.topAnchor.constraint(equalTo: toastContainerView.topAnchor, constant: 0).isActive = true
            labelForMessage.bottomAnchor.constraint(equalTo: toastContainerView.bottomAnchor, constant: 0).isActive = true
            labelForMessage.leftAnchor.constraint(equalTo: toastContainerView.leftAnchor, constant: 5).isActive = true
            labelForMessage.rightAnchor.constraint(equalTo: toastContainerView.rightAnchor, constant: -5).isActive = true
            keyWindow.layoutIfNeeded()
            
            let padding:CGFloat = initialYPos == 0 ? (DeviceType.isIpad() ? 170 : 110) : 10 // starting position
            initialYPos += padding+totolHeight
            topAnchor.constant = initialYPos
            
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
                keyWindow.layoutIfNeeded()
            }, completion: { (bool) in
                topAnchor.constant = 0
                UIView.animate(withDuration: 0.7, delay: 5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                    keyWindow.layoutIfNeeded()
                }, completion: { (bool) in
                    if let lastToastShown = lastToastLabelReference,labelForMessage == lastToastShown{
                        lastToastLabelReference = nil
                    }
                    initialYPos -= (padding+totolHeight)
                    toastContainerView.removeFromSuperview()
                })
            })
        }
    }
}
class ShowHud:NSObject{
    static let disablerView:UIView={
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    static let containerView:UIView={
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    static var loadingIndicator:UIActivityIndicatorView={
        let loading = UIActivityIndicatorView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.style = .whiteLarge
        loading.backgroundColor = .clear
        loading.layer.cornerRadius = 16
        loading.layer.masksToBounds = true
        return loading
    }()
    
    static var timerToHideHud:Timer?
    static var timerToShowHud:Timer?
    class func show(){
        ShowHud.timerToHideHud?.invalidate()
        UIApplication.shared.resignFirstResponder()
        ShowHud.timerToShowHud = Timer.scheduledTimer(timeInterval: 0.5, target: ShowHud.self, selector: #selector(ShowHud.showHudAfterOneSecond), userInfo: nil, repeats: false)
    }
    
    class func hide(){
        ShowHud.timerToShowHud?.invalidate()
        ShowHud.timerToHideHud = Timer.scheduledTimer(timeInterval: 0.5, target: ShowHud.self, selector: #selector(ShowHud.hideAfterOneSecond), userInfo: nil, repeats: false)
    }
    
    @objc class func hideAfterOneSecond(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        ShowHud.loadingIndicator.stopAnimating()
        ShowHud.disablerView.removeFromSuperview()
        timerToHideHud?.invalidate()
    }
   
    @objc class func showHudAfterOneSecond(){
        if let app = UIApplication.shared.delegate as? AppDelegate, let keyWindow = app.window{
            if !ShowHud.loadingIndicator.isAnimating{
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                keyWindow.addSubview(disablerView)
                disablerView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor).isActive = true
                disablerView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
                disablerView.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true
                disablerView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor).isActive = true
                ShowHud.loadingIndicator.startAnimating()
                disablerView.addSubview(containerView)
                containerView.centerXAnchor.constraint(equalTo: disablerView.centerXAnchor).isActive = true
                containerView.centerYAnchor.constraint(equalTo: disablerView.centerYAnchor).isActive = true
                let squareSize:CGFloat = DeviceType.isIpad() ? 140 : 100
                containerView.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
                containerView.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
                containerView.addSubview(loadingIndicator)
                loadingIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
                loadingIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                
//                let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "THANK YOU", withExtension: "gif")!)
//                let advTimeGif = UIImage.sd_animatedGIF(with: imageData!)
//                self.loadingIndicator.image = advTimeGif
            }
        }
    }
}



class DeviceType{
    class func isIpad()->Bool{
        return UIDevice.current.userInterfaceIdiom == .pad ? true : false
    }
    class func isIphone5sAndBelow()->Bool{
        if UIScreen.main.bounds.height < 570{
            return true
        }
        return false
    }
    class func isIphone6()->Bool{
        if UIScreen.main.bounds.height <= 667{
            return true
        }
        return false
    }
}
class Reachability {
    class func isAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
class ShowAlertView{
    class func show(titleMessage:String="Success",desciptionMessage:String="Successfully completed"){
        if let app = UIApplication.shared.delegate as? AppDelegate, let keyWindow = app.window,let rootVC = keyWindow.rootViewController{
            let alert = UIAlertController.init(title: titleMessage, message: desciptionMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
}


extension UIView{
    
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func showNoDataFound(msg:String = "No Transaction History"){
        self.removeNoDataLabel()
        let noDataLabel:UILabel={
            let label = UILabel(frame: self.bounds)
         //   label.font = UIFont.regularFont(ofSize: DeviceType.isIpad() ? 24 : (DeviceType.isIphone5sAndBelow() ? 16 : 20))
            label.textColor = UIColor.lightGray
            label.tag = 112103
            label.numberOfLines = 0
            label.textAlignment = .center
            label.backgroundColor = UIColor.clear
            label.text = msg.capitalized
            return label
        }()
        //noDataLabel.setHieghtOrWidth(height: DeviceType.isIpad() ? 60 : 50, width: nil)
      
        self.addSubview(noDataLabel)
        noDataLabel.centerOnYOrX(x: true, y: nil)

    }
    
    func removeNoDataLabel(){
        for view1 in self.subviews{
            if view1.tag == 112103{
                view1.removeFromSuperview()
            }
        }
    }

    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics:nil, views: viewsDictionary))
    }
    
    func anchors(left:NSLayoutXAxisAnchor?,right:NSLayoutXAxisAnchor?,top:NSLayoutYAxisAnchor?,bottom:NSLayoutYAxisAnchor?,leftConstant:CGFloat = 0,rightConstant:CGFloat = 0,topConstant:CGFloat = 0,bottomCosntant:CGFloat = 0){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let leftAnchor = left{
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstant).isActive = true
        }
        if let rightAnchor = right{
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: rightConstant).isActive = true
        }
        if let topAnchor = top{
            self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        }
        if let bottomAnchor = bottom{
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomCosntant).isActive = true
        }
    }
    
    func fillOnSupperView(){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let subperView = self.superview{
            self.leftAnchor.constraint(equalTo: subperView.leftAnchor, constant: 0).isActive = true
            self.rightAnchor.constraint(equalTo: subperView.rightAnchor, constant: 0).isActive = true
            self.topAnchor.constraint(equalTo: subperView.topAnchor, constant: 0).isActive = true
            self.bottomAnchor.constraint(equalTo: subperView.bottomAnchor, constant: 0).isActive = true
        }
    }
    
    func centerOnSuperView(constantX:CGFloat = 0 , constantY:CGFloat = 0 ){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let subperView = self.superview{
            self.centerXAnchor.constraint(equalTo: subperView.centerXAnchor, constant: constantX).isActive = true
            self.centerYAnchor.constraint(equalTo: subperView.centerYAnchor, constant: constantY).isActive = true
        }
    }
    
    func setHieghtOrWidth(height:CGFloat?,width:CGFloat?){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let heightConst = height{
            self.heightAnchor.constraint(equalToConstant: heightConst).isActive = true
        }
        if let widthAnchor = width{
            self.widthAnchor.constraint(equalToConstant: widthAnchor).isActive = true
        }
    }
    
    func centerOnYOrX(x:Bool?,y:Bool?,xConst:CGFloat=0,yConst:CGFloat=0){
        self.translatesAutoresizingMaskIntoConstraints = false
        if x != nil && y != nil{
            self.centerOnSuperView(constantX: xConst , constantY: yConst)
        }else if x != nil{
            self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor, constant: xConst ).isActive = true
        }else if y != nil{
            self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor, constant: yConst).isActive = true
        }
    }
    func addSubviews(views:[UIView]){
        for view in views{
            self.addSubview(view)
        }
    }
}
extension UIColor {
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat,a:CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: a)
    }
   convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension UIImageView{
    
    //kenburn effect
    func transition(toImage: UIImage, withDuration duration: TimeInterval){
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { (bool) in
            
            UIView.animate(withDuration: duration, animations: {
                self.image = toImage
                self.alpha = 1
            }, completion: nil)
        }
    }
}

extension UIPageControl {
    
    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat, dotheight:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = UIColor.black
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }else{
                dotView.backgroundColor = .white
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
    
}

extension UIImage {
    
    /// Creates a circular outline image.
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        // Inset the rect to account for the fact that strokes are
        // centred on the bounds of the shape.
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    

        enum JPEGQuality: CGFloat {
            case lowest  = 0
            case low     = 0.25
            case medium  = 0.5
            case high    = 0.75
            case highest = 1
        }
        
        /// Returns the data for the specified image in JPEG format.
        /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
        /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
        func jpeg(_ quality: JPEGQuality) -> Data? {
            return self.jpegData(compressionQuality:quality.rawValue)//UIImageJPEGRepresentation(self, quality.rawValue)
        }
    
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let TermConditionLblfontSize :CGFloat = DeviceType.isIpad() ? 18 : (DeviceType.isIphone5sAndBelow() ? 12 : 14)
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "OpenSans-Bold", size: TermConditionLblfontSize)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}

extension String{
    func removeWhiteSpaces()->String{
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool { //
        //Does not have to have special characters
        let passwordRegexOriginal = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let passwordRegexNew = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
    
        return NSPredicate(format: "SELF MATCHES %@", passwordRegexOriginal).evaluate(with: self) || NSPredicate(format: "SELF MATCHES %@", passwordRegexNew).evaluate(with: self)
    }
    
    func trim() -> String{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func getAttributedString(questring:String) -> NSMutableAttributedString {
        var attributedString = NSMutableAttributedString()
        let range = NSRange(location:0,length:1)
        attributedString = NSMutableAttributedString(string: questring, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 45, weight: UIFont.Weight(rawValue: 0.1))])
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        return attributedString
    }
}

extension TimeInterval {
    var durationText:String {
        let totalSeconds = self
        let hours:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
extension UICollectionViewCell{
    
    /// Table view cell fade in animation for best way to represent
    /// tableview
    ///
    /// - Parameters:
    ///   - duration: animation duration default value 0.1
    ///   - index: cell index
    func fadeInAnimation(withDuration duration: Double = 0.1,forIndex index : Int) {
        self.alpha = 0
        UIView.animate(withDuration: duration, delay: (duration * Double(index)),  animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    /// Table view cell bounce animation for best way to represent
    /// tableview
    ///
    /// - Parameters:
    ///   - duration: animation duration default value 0.8
    ///   - delay: animation delay default value 0.05
    ///   - index: cell index
    func bouncingAnimation(withDuration duration: Double = 0.8,withDelay delay : Double = 0.05,forIndex index : Int) {
        self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        UIView.animate(withDuration: duration,delay: delay * Double(index),usingSpringWithDamping: 0.8,initialSpringVelocity: 0.1,animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    /// Table view cell move in animation for best way to represent
    /// tableview
    ///
    /// - Parameters:
    ///   - duration: animation duration default value 0.5
    ///   - delay: animation delay default value 0.08
    ///   - index: cell index
    func moveInAnimation(withDuration duration: Double = 0.5,withDelay delay : Double = 0.08,forIndex index : Int) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: self.frame.height / 2)
        UIView.animate(withDuration: duration,delay: delay * Double(index),animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    /// Table view cell right side to in animation for best way to represent
    /// tableview
    ///
    /// - Parameters:
    ///   - duration: animation duration default value 0.5
    ///   - delay: animation delay default value 0.08
    ///   - index: cell index
    func rightInAnimation(withDuration duration: Double = 0.5,withDelay delay : Double = 0.08,forIndex index : Int) {
        self.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
        UIView.animate(withDuration: duration,delay: delay * Double(index),animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    /// Table view cell left side to in animation for best way to represent
    /// tableview
    ///
    /// - Parameters:
    ///   - duration: animation duration default value 0.5
    ///   - delay: animation delay default value 0.08
    ///   - index: cell index
    func leftInAnimation(withDuration duration: Double = 0.5,withDelay delay : Double = 0.08,forIndex index : Int) {
        self.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
        UIView.animate(withDuration: duration,delay: delay * Double(index),animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
}
class BasicComponent:NSObject{
    static func getTextfield()->UITextField{
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.leftViewMode = .always
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 2))
        return tf
    }
}

class BaseCell:UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpViews(){
    }
}
