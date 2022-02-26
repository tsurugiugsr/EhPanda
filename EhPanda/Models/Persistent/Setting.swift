//
//  Setting.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/01/09.
//

import SwiftUI
import Foundation
import ComposableArchitecture

struct Setting: Codable, Equatable {
    // Account
    var galleryHost: GalleryHost = .ehentai
    var showsNewDawnGreeting = false

    // General
    var enablesTagsExtension = false {
        didSet {
            if !enablesTagsExtension {
                translatesTags = false
                showsTagsSearchSuggestion = false
                showsImagesInTags = false
            }
        }
    }
    var translatesTags = false
    var showsTagsSearchSuggestion = false
    var showsImagesInTags = false
    var redirectsLinksToSelectedHost = false
    var detectsLinksFromClipboard = false
    var backgroundBlurRadius: Double = 10
    var autoLockPolicy: AutoLockPolicy = .never

    // Appearance
    var listDisplayMode: ListDisplayMode = DeviceUtil.isPadWidth ? .thumbnail : .detail
    var preferredColorScheme = PreferredColorScheme.automatic
    var accentColor: Color = .blue
    var appIconType: AppIconType = .default
    var showsTagsInList = false
    var listTagsNumberMaximum = 0

    // Reading
    var readingDirection: ReadingDirection = .vertical
    var prefetchLimit = 10
    var enablesLandscape = false
    var enablesDualPageMode = false
    var exceptCover = false
    var contentDividerHeight: Double = 0
    var maximumScaleFactor: Double = 3
    var doubleTapScaleFactor: Double = 2

    // Laboratory
    var bypassesSNIFiltering = false
}

enum GalleryHost: String, Codable, CaseIterable, Identifiable {
    case ehentai = "E-Hentai"
    case exhentai = "ExHentai"

    var id: Int { hashValue }
    var url: URL {
        switch self {
        case .ehentai:
            return Defaults.URL.ehentai
        case .exhentai:
            return Defaults.URL.exhentai
        }
    }
    var abbr: String {
        switch self {
        case .ehentai:
            return "eh"
        case .exhentai:
            return "ex"
        }
    }
}

enum AutoLockPolicy: Int, Codable, CaseIterable, Identifiable {
    var id: Int { rawValue }

    case never = -1
    case instantly = 0
    case sec15 = 15
    case min1 = 60
    case min5 = 300
    case min10 = 600
    case min30 = 1800
}

extension AutoLockPolicy {
    var value: String {
        switch self {
        case .never:
            return R.string.localizable.enumAutoLockPolicyValueNever()
        case .instantly:
            return R.string.localizable.enumAutoLockPolicyValueInstantly()
        case .sec15:
            return R.string.localizable.commonValueSeconds("\(rawValue)")
        case .min1:
            return R.string.localizable.commonValueMinute("\(rawValue / 60)")
        case .min5, .min10, .min30:
            return R.string.localizable.commonValueMinutes("\(rawValue / 60)")
        }
    }
}

enum PreferredColorScheme: Int, Codable, CaseIterable, Identifiable {
    var id: Int { rawValue }

    case automatic
    case light
    case dark
}
extension PreferredColorScheme {
    var value: String {
        switch self {
        case .automatic:
            return R.string.localizable.enumPerferredColorSchemeValueAutomatic()
        case .light:
            return R.string.localizable.enumPerferredColorSchemeValueLight()
        case .dark:
            return R.string.localizable.enumPerferredColorSchemeValueDark()
        }
    }
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .automatic:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

enum ReadingDirection: Int, Codable, CaseIterable, Identifiable {
    var id: Int { rawValue }

    case vertical
    case rightToLeft
    case leftToRight
}
extension ReadingDirection {
    var value: String {
        switch self {
        case .vertical:
            return R.string.localizable.enumReadingDirectionValueVertical()
        case .rightToLeft:
            return R.string.localizable.enumReadingDirectionValueRightToLeft()
        case .leftToRight:
            return R.string.localizable.enumReadingDirectionValueLeftToRight()
        }
    }
}

enum ListDisplayMode: Int, Codable, CaseIterable, Identifiable {
    var id: Int { rawValue }

    case detail
    case thumbnail
}
extension ListDisplayMode {
    var value: String {
        switch self {
        case .detail:
            return R.string.localizable.enumDisplayModeValueDetail()
        case .thumbnail:
            return R.string.localizable.enumDisplayModeValueThumbnail()
        }
    }
}

// swiftlint:disable line_length
// MARK: Manually decode
extension Setting {
    init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        // Account
        galleryHost = (try? container?.decodeIfPresent(GalleryHost.self, forKey: .galleryHost)) ?? .ehentai
        showsNewDawnGreeting = (try? container?.decodeIfPresent(Bool.self, forKey: .showsNewDawnGreeting)) ?? false
        // General
        enablesTagsExtension = (try? container?.decodeIfPresent(Bool.self, forKey: .enablesTagsExtension)) ?? false
        translatesTags = (try? container?.decodeIfPresent(Bool.self, forKey: .translatesTags)) ?? false
        showsTagsSearchSuggestion = (try? container?.decodeIfPresent(Bool.self, forKey: .showsTagsSearchSuggestion)) ?? false
        showsImagesInTags = (try? container?.decodeIfPresent(Bool.self, forKey: .showsImagesInTags)) ?? false
        redirectsLinksToSelectedHost = (try? container?.decodeIfPresent(Bool.self, forKey: .redirectsLinksToSelectedHost)) ?? false
        detectsLinksFromClipboard = (try? container?.decodeIfPresent(Bool.self, forKey: .detectsLinksFromClipboard)) ?? false
        backgroundBlurRadius = (try? container?.decodeIfPresent(Double.self, forKey: .backgroundBlurRadius)) ?? 10
        autoLockPolicy = (try? container?.decodeIfPresent(AutoLockPolicy.self, forKey: .autoLockPolicy)) ?? .never
        // Appearance
        listDisplayMode = (try? container?.decodeIfPresent(ListDisplayMode.self, forKey: .listDisplayMode)) ?? (DeviceUtil.isPadWidth ? .thumbnail : .detail)
        preferredColorScheme = (try? container?.decodeIfPresent(PreferredColorScheme.self, forKey: .preferredColorScheme)) ?? .automatic
        accentColor = (try? container?.decodeIfPresent(Color.self, forKey: .accentColor)) ?? .blue
        appIconType = (try? container?.decodeIfPresent(AppIconType.self, forKey: .appIconType)) ?? .default
        showsTagsInList = (try? container?.decodeIfPresent(Bool.self, forKey: .showsTagsInList)) ?? false
        listTagsNumberMaximum = (try? container?.decodeIfPresent(Int.self, forKey: .listTagsNumberMaximum)) ?? 0
        // Reading
        readingDirection = (try? container?.decodeIfPresent(ReadingDirection.self, forKey: .readingDirection)) ?? .vertical
        prefetchLimit = (try? container?.decodeIfPresent(Int.self, forKey: .prefetchLimit)) ?? 10
        enablesLandscape = (try? container?.decodeIfPresent(Bool.self, forKey: .enablesLandscape)) ?? false
        enablesDualPageMode = (try? container?.decodeIfPresent(Bool.self, forKey: .enablesDualPageMode)) ?? false
        exceptCover = (try? container?.decodeIfPresent(Bool.self, forKey: .exceptCover)) ?? false
        contentDividerHeight = (try? container?.decodeIfPresent(Double.self, forKey: .contentDividerHeight)) ?? 0
        maximumScaleFactor = (try? container?.decodeIfPresent(Double.self, forKey: .maximumScaleFactor)) ?? 3
        doubleTapScaleFactor = (try? container?.decodeIfPresent(Double.self, forKey: .doubleTapScaleFactor)) ?? 2
        // Laboratory
        bypassesSNIFiltering = (try? container?.decodeIfPresent(Bool.self, forKey: .bypassesSNIFiltering)) ?? false
    }
}
// swiftlint:enable line_length
