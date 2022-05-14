import 'package:flutter_simple_dependency_injection/src/injector.dart';
import 'package:collection/collection.dart';
import 'dart:developer';

class TypeFactory<T extends Object> {
  final bool _isSingleton;
  final bool _isParametrizedSingleton;
  final ObjectFactoryWithParamsFn<T> _factoryFn;
  T? _instance;
  final Map<Map<String, dynamic>, T> _instances = <Map<String, dynamic>, T> {};

  TypeFactory(this._factoryFn, {bool isSingleton = false, bool isParametrizedSingleton = false }):
    _isSingleton = isSingleton,
    _isParametrizedSingleton = isParametrizedSingleton;


  T get(Injector injector, Map<String, dynamic> additionalParameters) {
    if (_isSingleton && _instance != null) {
      return _instance!;
    }

    if (_isParametrizedSingleton){
     final cached_instance = _findInstanceByParams(additionalParameters);
     if (cached_instance != null){
       return cached_instance;
     }
    }

    final instance = _factoryFn(injector, additionalParameters);
    if (_isSingleton) {
      _instance = instance;
    }
    if (_isParametrizedSingleton){
      _instances[additionalParameters] = instance;
    }
    return instance;
  }

  T? _findInstanceByParams(Map<String, dynamic> params){
    return _instances.entries.firstWhereOrNull((MapEntry<Map<String, dynamic>, T> entry) => DeepCollectionEquality().equals(params, entry.key))?.value;
  }
}
