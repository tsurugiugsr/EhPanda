//
//  AppReducer.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/12/25.
//

import ComposableArchitecture

let appReducer = Reducer<AltAppState, AltAppAction, AppEnvironment>.combine(
    appDelegateReducer.pullback(
        state: \.sharedData.setting.bypassesSNIFiltering,
        action: /AltAppAction.appDelegate,
        environment: { _ in AppDelegateEnvironment() }
    ),
    sharedDataReducer.pullback(
        state: \.sharedData,
        action: /AltAppAction.sharedData,
        environment: { _ in AnyEnvironment() }
    ),
    tabBarReducer.pullback(
        state: \.tabBarState,
        action: /AltAppAction.tabBar,
        environment: { _ in AnyEnvironment() }
    ),
    favoritesReducer.pullback(
        state: \.favoritesState,
        action: /AltAppAction.favorites,
        environment: { _ in FavoritesEnvironment() }
    ),
    settingReducer.pullback(
        state: \.settingState,
        action: /AltAppAction.setting,
        environment: { _ in AnyEnvironment() }
    )
)

struct AnyEnvironment {}
