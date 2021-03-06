import UIKit

public class CodeInputView: UIView, UIKeyInput {
    public var delegate: CodeInputViewDelegate?
    private var nextTag = 1

    // MARK: - UIResponder

    public override func canBecomeFirstResponder() -> Bool {
        return true
    }

    // MARK: - UIView

    public override init(frame: CGRect) {
        super.init(frame: frame)

        // Add four digitLabels
        var frame = CGRect(x: 15, y: 10, width: 35, height: 40)
        for index in 1...4 {
            let digitLabel = UILabel(frame: frame)
            digitLabel.font = UIFont.systemFontOfSize(42)
            digitLabel.tag = index
            digitLabel.text = "–"
            digitLabel.textAlignment = .Center
            addSubview(digitLabel)
            frame.origin.x += 35 + 15
        }
    }
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") } // NSCoding

    // MARK: - UIKeyInput

    public func hasText() -> Bool {
        return nextTag > 1 ? true : false
    }

    public func insertText(text: String) {
        if nextTag < 5 {
            (viewWithTag(nextTag)! as! UILabel).text = text
            nextTag += 1

            if nextTag == 5 {
                var code = ""
                for index in 1..<nextTag {
                    code += (viewWithTag(index)! as! UILabel).text!
                }
                delegate?.codeInputView(self, didFinishWithCode: code)
            }
        }
    }

    public func deleteBackward() {
        if nextTag > 1 {
            nextTag -= 1
            (viewWithTag(nextTag)! as! UILabel).text = "–"
        }
    }

    public func clear() {
        while nextTag > 1 {
            deleteBackward()
        }
    }

    // MARK: - UITextInputTraits

    public var keyboardType: UIKeyboardType { get { return .NumberPad } set { } }
}

public protocol CodeInputViewDelegate {
    func codeInputView(codeInputView: CodeInputView, didFinishWithCode code: String)
}
