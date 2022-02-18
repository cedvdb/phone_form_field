@Deprecated('use CountrySelectorNavigation instead')
abstract class SelectorConfig {
  const SelectorConfig();
  static coverSheet() => const SelectorConfigCoverSheet();
  static bottomSheet(double? height) => SelectorConfigBottomSheet(height);
  static dialog() => const SelectorConfigDialog();
}

@Deprecated('use CountrySelectorNavigation instead')
class SelectorConfigDialog extends SelectorConfig {
  const SelectorConfigDialog();
}

@Deprecated('use CountrySelectorNavigation instead')
class SelectorConfigCoverSheet extends SelectorConfig {
  const SelectorConfigCoverSheet();
}

@Deprecated('use CountrySelectorNavigation instead')
class SelectorConfigBottomSheet extends SelectorConfig {
  final double? height;
  const SelectorConfigBottomSheet(this.height);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectorConfigBottomSheet && other.height == height;
  }

  @override
  int get hashCode => height.hashCode;
}
