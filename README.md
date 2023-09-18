# Cred-assignment-2023
Assignment for cred application for iOS developer (2023).

## Project goal and information
To develop an abstraction layer for stack framework supporting expand & collapse state
of view, Using that abstraction layer you can create one sample stack view
implementation.

## Requirements
* iOS 16.0+
* Swift 5

## Usage
`CardStack` behaves like a standard `UICollectionView`. To use it inside your UIViewController:

```swift
import CardStack

class SampleViewController: UIViewController, CardStackDatasource {

    @IBOutlet private var cardStack: CardStack!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardStack = CardStack(frame: self.view.bounds)
        view.addSubview(cardStack)
        cardStack.datasource = self
        
        // register cardcell for storyboard use
        cardStack.register(nib: UINib(nibName: "SampleCell", bundle: nil), forCellWithReuseIdentifier: "SampleCell")
    }
    
   func cardForItemAt(cardStackView: CardStackView, cardForItemAt index: Int) -> CardCell {
        
        if let cardCell = cardStackView.dequeueReusableCell(withReuseIdentifier: "SampleCell", for: index) as? SampleCardCell {
            return cardCell
        }
        return CardCell()    }
    
    func numberOfCards(cardStackView: CardStackView) -> Int {
        return 3
    }
}
```

#### Properties
```swift
/// The inset (spacing) at each side of the cards. Default is 160.
@IBInspectable public var topInset: CGFloat = 160
    
 /// The inset (spacing) at each side of the cards. Default is 0.
@IBInspectable public var sideInset: CGFloat = 0
    
/// Sets how much of the next card should be visible. Default is 0.
@IBInspectable public var visibleNextCardHeight: CGFloat = 0 
   
/// Vertical spacing between the focussed card and the bottom (next) card. Default is 40.
@IBInspectable public var cardSpacing: CGFloat = 40
    
/// The transform animation that is shown on the top card when scrolling through the cards. Default is 0.05.
@IBInspectable public var firstItemTransform: CGFloat = 0.05
    
/// Allows to enable/disable the stacking effect. Default is `true`.
@IBInspectable public var isStackingEnabled: Bool = true
    
/// Allows to set the view to Stack at the Top or at the Bottom. Default is `true`.
@IBInspectable public var isStackOnBottom: Bool = true
    
/// Sets how many cards of the stack are visible in the background. Default is 1.
@IBInspectable public var stackedCardsCount: Int = 1
```

##### Get the current focussed card index
```swift
cardStack.focussedCardIndex
```

##### Get a card at a specified index
```swift
cardStack.cardForItem(at: Int) -> CardCell?
```

### Delegation
To handle swipe gestures, implement the `CardStackDelegate`


```swift
class ViewController: UIViewController, CardStackDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        cardStack.delegate = self
    }
    
    func didEndScroll(cardStackView: CardStackView) {
    
    // Tells the delegate when scrolling through the cards came to an end (optional).
    }
    
     func didTapCard(cardStackView: CardStackView, index: Int) {
    
    // Tells the delegate when the user taps a card (optional).
    }

    func sizeForItem(cardStackView: CardStackView, index: Int) -> CGSize {

    // Allows you to return custom card sizes (optional).
    return CGSize(width: CardStackView.frame.width * 0.75, height: CardStackView.frame.height * 0.75)
    }
    
}
```

### Customization
Subclass the `CardCell` to customize the cards.
```swift
Subclass the CardCell to customize the cards.
class SampleCardCell: CardCell {

}

```

## Key Features
- [x] Create custom Card view
- [x] Sliding Card view
- [x] dismiss by clicking on the topView section of Cell
- [x] Option to disable stacking
- [x] Set custom number of stacked cards
- [x] Code documentation in README.md file

## Author
Abha Wadjikar, awadjikar@gmail.com

