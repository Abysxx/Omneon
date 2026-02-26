import Orion
import SwiftUI
import UIKit

class ProfileSettingsSectionHook: ClassHook<NSObject> {
    static let targetName = "ProfileSettingsSection"

    private var myRowIndex: Int {
        return orig.numberOfRows()
    }

    func numberOfRows() -> Int {
        let base = orig.numberOfRows()
        return base + 1
    }

    func didSelectRow(_ row: Int) {
        let base = orig.numberOfRows()

        if row == base {
            guard let rootSettingsController = WindowHelper.shared.findFirstViewController("RootSettingsViewController"),
                  let navigationController = rootSettingsController.navigationController
            else { return }

            let OmneonSettingsController = OmneonSettingsViewController(
                rootSettingsController.view.bounds,
                settingsView: AnyView(OmneonSettingsView(navigationController: navigationController)),
                navigationTitle: "Omneon"
            )

            let button = UIButton()
            button.setImage(BundleHelper.shared.uiImage("github").withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(OmneonSettingsController, action: #selector(OmneonSettingsController.openRepositoryUrl(_:)), for: .touchUpInside)

            let menuBarItem = UIBarButtonItem(customView: button)
            menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 22).isActive = true
            menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 22).isActive = true
            OmneonSettingsController.navigationItem.rightBarButtonItem = menuBarItem

            navigationController.pushViewController(OmneonSettingsController, animated: true)
            return
        }

        orig.didSelectRow(row)
    }

    func cellForRow(_ row: Int) -> UITableViewCell {
        let base = orig.numberOfRows()

        if row == base {
            let settingsTableCell = Dynamic.SPTSettingsTableViewCell
                .alloc(interface: SPTSettingsTableViewCell.self)
                .initWithStyle(3, reuseIdentifier: "Omneon")

            let tableViewCell = Dynamic.convert(settingsTableCell, to: UITableViewCell.self)
            tableViewCell.accessoryView = type(
                of: Dynamic.SPTDisclosureAccessoryView
                    .alloc(interface: SPTDisclosureAccessoryView.self)
            )
            .disclosureAccessoryView()

            tableViewCell.textLabel?.text = "Omneon"
            return tableViewCell
        }

        return orig.cellForRow(row)
    }
}
