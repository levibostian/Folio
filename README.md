[![CI Status](https://img.shields.io/travis/levibostian/Folio.svg?style=flat)](https://travis-ci.org/levibostian/Folio)
[![Version](https://img.shields.io/cocoapods/v/Folio.svg?style=flat)](https://cocoapods.org/pods/Folio)
[![License](https://img.shields.io/cocoapods/l/Folio.svg?style=flat)](https://cocoapods.org/pods/Folio)
[![Platform](https://img.shields.io/cocoapods/p/Folio.svg?style=flat)](https://cocoapods.org/pods/Folio)
![Swift 5.2.x](https://img.shields.io/badge/Swift-5.2.x-orange.svg)

# Folio

Flexible way to detect when you scroll to the end of a `UITableView`.

![project logo](misc/header.jpg)

## What is Folio? 

Sometimes it's valuable to detect when you scroll to the end of a `UITableView`. One scenario is if your app is trying to implement [pagination](https://en.wikipedia.org/wiki/Pagination). Folio's job is to tell you when you have scrolled to the bottom of your `UITableView`. Nothing more, nothing less. 

## Why use Folio? 

* **Lightweight** - Folio is very small. 1 class with a handful lines of code. [Check it out for yourself](https://github.com/levibostian/Folio/blob/master/Folio/Classes/Folio.swift).
* **Works with sectioned `UITableView`** - Some scrolling detectors only work if your table has 1 section. Folio will tell you when you scroll to the end of your `UITableView` no matter how many sections you have. It tells you when you get to the end of the last section of your table. 
* **Flexible** - You don't need to change your existing implementation. You don't need to use a custom subclass of `UITableView`. Use whatever `UITableView` instance you want!
* **Easy to implement** - There are 2 steps. (1) set delegate and (2) one function call. 

## Installation

Folio is available through [CocoaPods](https://cocoapods.org/pods/Folio). To install it, simply add the following line to your Podfile:

```ruby
pod 'Folio', '~> version-here'
```

Replace `version-here` with: [![Version](https://img.shields.io/cocoapods/v/Folio.svg?style=flat)](https://cocoapods.org/pods/Folio) as this is the latest version at this time. 

# Getting started 

* Create an instance of Folio and set a `delegate` on it:

```swift
import UIKit
import Folio

class ViewController: UIViewController {

    fileprivate var folio: Folio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        folio = Folio(tableView: tableView)
        folio.delegate = self
        ...
    }
}
```

* Implement the `FolioDelegate`:

```swift
extension ViewController: FolioDelegate {

    func reachedBottom(in tableView: UITableView) {
        // Reached bottom of UITableView. 
        //
        // Note: This function is only called once until you call `tableView.reloadData()`. 
    }
}
```

* In your `UITableViewDelegate`, pass some info to Folio:

```swift
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {        
        folio.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }

}
```

## How does this work? 

Folio is quite simple. To help make sure Folio is not a black box, let's get into how Folio works. 

[It is 1 short file](https://github.com/levibostian/Folio/blob/master/Folio/Classes/Folio.swift) that (1) determines the last section and last row of that section of your `UITableView` and then (2) notifies your set `delegate` when the `UITableView` is just about to display the cell in the last section and last row of your `UITableView`. 

A `UITableView` instance displays a certain number of sections with a certain number of rows in each section. The number of sections and rows in each section does not matter to Folio except *the last section and last row* of the `UITableView`. 

Check out the [source code file](https://github.com/levibostian/Folio/blob/master/Folio/Classes/Folio.swift) for Folio. It has some comments inside to explain this to you. 

## Example app

This project comes with an iOS app you can run and view the source code to get an idea of a full implementation of pagination with Folio. 

To run the example app, follow these instructions:
```
cd Example/
pod install
```
Then, open the Folio workspace in XCode.  

## Author

* Levi Bostian - [GitHub](https://github.com/levibostian), [Twitter](https://twitter.com/levibostian), [Website/blog](https://levibostian.com)

![Levi Bostian image](https://gravatar.com/avatar/22355580305146b21508c74ff6b44bc5?s=250)

## Contribute

Folio is open for pull requests. Check out the [list of issues](https://github.com/levibostian/folio/issues) for tasks planned out, if there are any. Check them out if you wish to contribute in that way.

**Want to add features to Folio?** Before you decide to take a bunch of time and add functionality to the library, please, [create an issue](https://github.com/levibostian/Folio/issues/new) stating what you wish to add. This might save you some time in case your purpose does not fit well in the use cases of Folio. Nothing is stopping you from making a fork of this library and making any changes you wish!

# Where did the name come from?

After a quick search for synonyms of "paging", folio came up. Folio is defined as arranging sheets of paper in a certain order. Fun word that aligns well with what it's common use case -> paging. 

# Credits

Header photo by [JJ Ying](https://unsplash.com/@jjying) on [Unsplash](https://unsplash.com/photos/WmnsGyaFnCQ)

## License

Folio is available under the MIT license. See the LICENSE file for more info.
