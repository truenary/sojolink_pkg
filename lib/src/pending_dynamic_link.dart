
/// Provides data from received dynamic link.
class PendingDynamicLinkData {
  const PendingDynamicLinkData({
    required this.link,
    this.utmParameters = const {},
  });


  /// Deep link parameter of the dynamic link.
  final Uri link;

  /// UTM parameters associated with a dynamic link.
  final Map<String, String?> utmParameters;

  /// Returns the current instance as a [Map].
  Map<String, dynamic> asMap() => <String, dynamic>{
        'link': link.toString(),
        'utmParameters': utmParameters,
      };

  @override
  String toString() {
    return '$PendingDynamicLinkData(${asMap()})';
  }
}
