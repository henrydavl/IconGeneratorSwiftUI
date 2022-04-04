//
//  IconFileGeneratorService.swift
//  IconGenerator
//
//  Created by Henry David Lie on 04/04/22.
//

import Foundation
import UIKit

protocol IconFileGeneratorServiceProtocol {
    func generateIconsURL(for appIconTypes: [AppIconType], with image: UIImage) async throws -> URL
}

struct IconFileGeneratorService: IconFileGeneratorServiceProtocol {
    
    let fileServicee: FileIconServiceProtocol
    let resizeService: IconResizerServiceProtocol
    
    func generateIconsURL(for appIconTypes: [AppIconType], with image: UIImage) async throws -> URL {
        self.fileServicee.deleteExistingTemporaryDirectoryURL()
        
        for appIconType in appIconTypes {
            let icons = try await self.resizeService.resizeIcons(from: image, for: appIconType)
            try await self.fileServicee.saveIconsToTemporaryDirectory(icons: icons, appIconType: appIconType)
        }
        
        let url = try await self.fileServicee.archiveTemporaryDirectoryToURL()
        return url
    }
}
