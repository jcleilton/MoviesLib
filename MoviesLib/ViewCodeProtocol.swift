//
//  ViewCodeProtocol.swift
//  MoviesLib
//
//  Created by Ricardo Espirito Santo Bailoni on 29/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import Foundation


protocol ViewCodePrococol: class {
    func viewCodeSetup()
    func viewCodeHierarchySetup()
    func viewCodeConstraintSetup()
    func viewCodeThemeSetup()
}


extension ViewCodePrococol {
    
    func viewCodeSetup() {
        viewCodeHierarchySetup()
        viewCodeConstraintSetup()
        viewCodeThemeSetup()
    }
    
    func viewCodeThemeSetup() {}
}
