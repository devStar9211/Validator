import UIKit

#if os(iOS)
extension UITextView: ValidatableInterfaceElement {
        
    open var inputValue: String? { return text }
    
    open func validateOnInputChange(enabled: Bool) {
        
        switch enabled {        
        case true: NotificationCenter.default.addObserver(self, selector: #selector(performValidation), name: NSNotification.Name.UITextFieldTextDidChange, object: self)
        case false: NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: self)
        }
    }
    
    @objc internal func performValidation(_ sender: Notification) {
        
        validate()
    }
}
#endif
