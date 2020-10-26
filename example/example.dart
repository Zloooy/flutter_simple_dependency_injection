import 'package:flutter_simple_dependency_injection/injector.dart';

void main() {
  // it is best to place all injector initialisation work into one or more modules
  // so it can act more like a dependency injector than a service locator
  final injector = ModuleContainer().initialise(Injector());

  // NOTE: it is best to architect your code so that you never need to
  // interact with the injector itself.  Make this framework act like a dependency injector
  // by having dependencies injected into objects in their constructors.  That way you avoid
  // any tight coupling with the injector itself.

  // Basic usage, however this kind of tight couple and direct interaction with the injector
  // should be limited.  Instead prefer dependencies injection.

  // simple dependency retrieval and method call
  injector.get<SomeService>().doSomething();

  // get an instance of each of the same mapped types
  final instances = injector.getAll<SomeType>();
  print(instances.length); // prints '3'

  // passing in additional arguments when getting an instance
  final instance =
      injector.get<SomeOtherType>(additionalParameters: {'id': 'some-id'});
  print(instance.id); // prints 'some-id'
}

class ModuleContainer {
  Injector initialise(Injector injector) {
    injector.map<Logger>((i) => Logger(), isSingleton: true);
    injector.map<String>((i) => 'https://api.com/', key: 'apiUrl');
    injector.map<SomeService>(
        (i) => SomeService(i.get<Logger>(), i.get<String>(key: 'apiUrl')));

    injector.map<SomeType>((injector) => SomeType('0'));
    injector.map<SomeType>((injector) => SomeType('1'), key: 'One');
    injector.map<SomeType>((injector) => SomeType('2'), key: 'Two');

    injector.mapWithParams<SomeOtherType>((i, p) => SomeOtherType(p['id']));

    return injector;
  }
}

class Logger {
  void log(String message) => print(message);
}

class SomeService {
  final Logger _logger;
  final String _apiUrl;

  SomeService(this._logger, this._apiUrl);

  void doSomething() {
    _logger.log('Doing something with the api at `$_apiUrl`');
  }
}

class SomeType {
  final String id;
  SomeType(this.id);
}

class SomeOtherType {
  final String id;
  SomeOtherType(this.id);
}
