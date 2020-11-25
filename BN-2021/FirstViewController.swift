//
//  FirstViewController.swift
//  BN-2021
//
//  Created by Patryk Strzemiecki on 05/11/2020.
//

import UIKit
import ContactsUI

final class FirstViewController: UIViewController {
    var coordinator: AppCoordinator?
    var contactsPesmissionsAllowed: Bool = false
    
    private var actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(mainButtonAction), for: .touchUpInside)
        button.accessibilityIdentifier = "actionButton"
        button.isAccessibilityElement = true
        button.accessibilityTraits = .button
        button.accessibilityIdentifier = "actionButton"
        return button
    }()
    
    private let defaultQueue = DispatchQueue(label: "FirstViewController_q1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        CNContactStore()
            .requestAccess(for: .contacts) { [weak self] (access, error) in
            self?.contactsPesmissionsAllowed = access
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setButton(enabled: true)
        
        defaultQueue.asyncAfter(
            deadline: .now() + .seconds(1),
            execute: { [weak self] in
                DispatchQueue.main.async {
                    self?.setButton(enabled: true)
                }
            }
        )
    }
    
    func neverEndingMethod() -> Int {
        sleep(999999999)
        return 1
    }
    
    func setButton(enabled: Bool) {
        actionButton.setTitle(enabled ? "Action" : "🐴", for: .normal)
        actionButton.setTitleColor(enabled ? .green : .red, for: .normal)
        actionButton.isEnabled = enabled
        
    }
    
    func buttonTitle() -> String? {
        actionButton.titleLabel?.text
    }
}

private extension FirstViewController {
    @objc func mainButtonAction() {
        coordinator?.contacts(permissionAllowed: contactsPesmissionsAllowed)
        setButton(enabled: false)
    }
    
    func setupUI() {
        setupButton()
    }
    
    func setupButton() {
        view.embed(actionButton)
    }
}

private extension UIView {
    func embed(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
