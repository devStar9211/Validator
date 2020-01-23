import Foundation

public enum ValidationResult {
    
    case valid
    
    case invalid([ValidationError])
    
    public var isValid: Bool {
        
        return self == .valid
    }
    
    /**
     
     Merges the receiving validation rule with another.
     
     ```
     .valid.merge(.valid) // = .valid
     .valid.merge(.invalid([err])) // = .invalid([err])
     .invalid([err1]).merge(.invalid([err2]) // = .invalid([err1, err2])
     ```
     
     - Parameters:
        - result: The result to merge into the receiver.
     
     - Returns:
     Merged validation result.
     
     */
    public func merge(with result: ValidationResult) -> ValidationResult {
        switch self {
        case .valid: return result
        case .invalid(let errorMessages):
            switch result {
            case .valid:
                return self
            case .invalid(let errorMessagesAnother):
                return .invalid([errorMessages, errorMessagesAnother].flatMap { $0 })
            }
        }
    }
    
    /**
     
     Merges the receiving validation rule with multiple others.
     
     - Parameters:
        - results: The results to merge the receiver.
     
     - Returns:
     Merged validation result.
     
     */
    public func merge(with results: [ValidationResult]) -> ValidationResult {
        return results.reduce(self) { return $0.merge(with: $1) }
    }
    
    /**
     
     Merges multiple validation rules together.
     
     - Parameters:
        - results: The results to merge.
     
     - Returns:
     Merged validation result.
     
     */
    public static func merge(results: [ValidationResult]) -> ValidationResult {
        return ValidationResult.valid.merge(with: results)
    }
}

extension ValidationResult: Equatable {
    
    public static func == (lhs: ValidationResult, rhs: ValidationResult) -> Bool {
        
        switch (lhs, rhs) {
       
        case (.valid, .valid):
            return true
        
        case (.invalid(let a), .invalid(let b)):
            return a.map({ $0.message }).joined() == b.map({ $0.message }).joined()
        
        default:
            return false
        }
    }
}
