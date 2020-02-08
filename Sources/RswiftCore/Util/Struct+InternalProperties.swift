//
//  Struct+InternalProperties.swift
//  R.swift
//
//  Created by Mathijs Kadijk on 06-10-16.
//  Copyright © 2016 Mathijs Kadijk. All rights reserved.
//

import Foundation

extension Struct {
  func addingInternalProperties(forBundleIdentifier bundleIdentifier: String) -> Struct {

    let internalProperties = [
      Let(
        comments: [],
        accessModifier: .filePrivate,
        isStatic: true,
        name: "hostingBundle",
        typeDefinition: .inferred(Type._Bundle),
        value: """Bundle.main
                static func updateLocale() {
                    bundle = Bundle.bundle(for: LocalUserBridge_iOS.default().appLocale())
                }
    
                @objc static func byKey(_ key: String) -> String {
                    return NSLocalizedString(key, bundle: hostingBundle, value: "", comment: "")
                }
    
                // For access from ObjC code
                @objc static func replacePlaceholders(for string: NSString, with values: [NSString]) -> NSString {
                    let stringValue = string as String
                    let replacedString = stringValue.replacePlaceholders(with: values.map { $0 as String })
        
                    return replacedString as NSString
                }
        """),
      Let(
        comments: [],
        accessModifier: .filePrivate,
        isStatic: true,
        name: "applicationLocale",
        typeDefinition: .inferred(Type._Locale),
        value: "hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current")
    ]

    let internalClasses = [
      Class(accessModifier: .filePrivate, type: Type(module: .host, name: "Class"))
    ]

    var externalStruct = self
    externalStruct.properties.append(contentsOf: internalProperties)
    externalStruct.classes.append(contentsOf: internalClasses)

    return externalStruct
  }
}
