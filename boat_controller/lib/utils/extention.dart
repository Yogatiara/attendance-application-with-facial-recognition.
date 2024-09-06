String? validateIpAddress(String? ipAddress) {
  RegExp ip4Regex = RegExp(
      '(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])');

  RegExp ip6Regex = RegExp('((([0-9a-fA-F]){1,4})\\:){7}([0-9a-fA-F]){1,4}');
  bool isIpValid;
  ip4Regex.hasMatch(ipAddress ?? '')
      ? isIpValid = ip4Regex.hasMatch(ipAddress ?? '')
      : isIpValid = ip6Regex.hasMatch(ipAddress ?? '');

  if (!isIpValid) {
    isIpValid = false;

    return 'Please enter a IP Address';
  } else {
    isIpValid = true;

    return null;
  }
}
