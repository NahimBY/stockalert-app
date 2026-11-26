enum NavigationTab { home, productos, movimientos, alertas }

class NavigationState {
  final NavigationTab currentTab;

  const NavigationState({this.currentTab = NavigationTab.home});

  NavigationState copyWith({NavigationTab? currentTab}) {
    return NavigationState(currentTab: currentTab ?? this.currentTab);
  }
}
