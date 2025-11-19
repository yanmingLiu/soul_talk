```
  Future<void> _getAndCheckPublicIP() async {
    _setLoadingState(true, '正在获取IP地址...');
    
    try {
      final locationInfo = await _ipService.getPublicIPAndLocation();
      _ipController.text = locationInfo.ip;
      _showLocationResult(locationInfo);
    } catch (e) {
      _setLoadingState(false, '❌ $e');
    }
  }

    void _showLocationResult(IPLocationInfo info) {
    setState(() {
      _isLoading = false;
      
      if (info.isMainlandChina) {
        _result = '✅ 中国大陆\n📍 ${info.countryName} - ${info.city}\n🔌 IP: ${info.ip}';
      } else if (info.isIreland) {
        _result = '✅ 爱尔兰\n📍 ${info.countryName} - ${info.city}\n🔌 IP: ${info.ip}';
      } else {
        _result = '❌ 其他地区\n📍 ${info.countryName} - ${info.city} (${info.countryCode})\n🔌 IP: ${info.ip}';
      }
    });
  }

```