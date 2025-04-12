//  Created by Илья Беников on 12.04.25.

import Foundation
import UIKit

/// Coordinator handles navigation within the app
protocol CoordinatorProtocol: AnyObject {
    /// The navigation controller for the coordinator
    var navigationController: UINavigationController { get set }
    
    /**
     The Coordinator takes control and activates itself.
     - Parameters:
        - animated: Set the value to true to animate the transition. Pass false if you are setting up a navigation controller before its view is displayed.
    */
    func start(animated: Bool)
    
    /**
        Pops out the active View Controller from the navigation stack.
        - Parameters:
            - animated: Set this value to true to animate the transition.
     */
    func popViewController(animated: Bool)
}

extension CoordinatorProtocol {
    /**
     Pops the top view controller from the navigation stack and updates the display.
     */
    
    func popViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    /**
     Pops view controllers until the specified view controller is at the top of the navigation stack.
     - Parameters:
        - ofClass: The view controller that you want to be at the top of the stack. This view controller must currently be on the navigation stack.
        - animated: Set this value to true to animate the transition.
     */
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        navigationController.popToViewController(ofClass: ofClass, animated: animated)
    }
    
    /**
    Pops view controllers until the specified view controller is at the top of the navigation stack.
     
    - Parameters:
       -  viewController: The view controller that you want to be at the top of the stack. This view controller must currently be on the navigation stack.
       - animated: Set the value to true to animate the transition.
    */
    func popViewController(to viewController: UIViewController, animated: Bool) {
        navigationController.popToViewController(viewController, animated: animated)
    }
}

/// All the top-level coordinators should conform to this protocol
protocol ParentCoordinatorProtocol: CoordinatorProtocol {
    /// Each Coordinator can have its own children coordinators
    var childCoordinators: [CoordinatorProtocol] { get set }
    /**
     Adds the given coordinator to the list of children.
     - Parameters:
        - child: A coordinator.
     */
    func addChild(_ child: CoordinatorProtocol?)
    /**
     Tells the parent coordinator that given coordinator is done and should be removed from the list of children.
     - Parameters:
        - child: A coordinator.
     */
    func childDidFinish(_ child: CoordinatorProtocol?)
}

extension ParentCoordinatorProtocol {
    //MARK: - Coordinator Functions
    /**
     Appends the coordinator to the children array.
     - Parameters:
     - child: The child coordinator to be appended to the list.
     */
    func addChild(_ child: CoordinatorProtocol?){
        if let _child = child {
            childCoordinators.append(_child)
        }
    }
    
    /**
     Removes the child from children array.
     - Parameters:
     - child: The child coordinator to be removed from the list.
     */
    func childDidFinish(_ child: CoordinatorProtocol?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

/// All Child coordinators should conform to this protocol
protocol ChildCoordinator: CoordinatorProtocol {
    /**
     The body of this function should call `childDidFinish(_ child:)` on the parent coordinator to remove the child from parent's `childCoordinators`.
     */
    func coordinatorDidFinish()
    /// A reference to the view controller used in the coordinator.
    var viewControllerRef: UIViewController? {get set}
}
