import 'dart:math';

import 'package:realm_dart/realm.dart';

part 'ni_np.g.dart';

@RealmModel()
class _MyModel {
  @Indexed()
  late int myInt;
}

final config = Configuration.local([MyModel.schema]);

Realm insertData(int count, bool wipeExisting) {
  if (wipeExisting) {
    Realm.deleteRealm(config.path);
  }

  final realm = Realm(config);

  print('Realm located at ${config.path}');

  final sw = Stopwatch()..start();

  final objects = realm.all<MyModel>();
  if (objects.length != count) {
    print('Need to reinsert data: ${objects.length} != $count');

    realm.write(() {
      realm.deleteAll<MyModel>();
      // One-by-one (fast)
      //for (var i = 0; i < count; i++) {
      //  realm.add(MyModel(i));
      //}
      // Add-all (slow)
      realm.addAll(List.generate(count, MyModel.new));
    });
    print('Inserted ${objects.length} objects in ${sw.elapsed}');
  }

  sw.stop();

  return realm;
}

void runTest(Realm realm, int lookups) {
  final rnd = Random(42);
  final objCount = realm.all<MyModel>().length;
  final toLookup = List.generate(lookups, (_) => rnd.nextInt(objCount));

  final sw = Stopwatch()..start();
  final found = <MyModel>[];

  for (var i in toLookup) {
    found.add(realm.query<MyModel>('myInt = $i').first);
  }

  sw.stop();

  print('Did $lookups lookups in ${sw.elapsedMilliseconds} ms: ${sw.elapsedMicroseconds / lookups} us/lookup');

  for (var i = 0; i < lookups; i++) {
    if (found[i].myInt != toLookup[i]) {
      print('Lookup $i failed: ${found[i].myInt} != ${toLookup[i]}');
    }
  }
}

void main(List<String> arguments) async {
  final count = int.parse(arguments[0]);
  final wipeExisting = arguments.length > 1 ? arguments[1] == 'true' : false;

  final realm = insertData(count, wipeExisting);

  // Can provoke on a pre-populated database as well, if the following line is uncommented
  //final lotsOfHandles = realm.all<MyModel>().toList();

  // If you want to allow the GC some time to run, uncomment the following line
  //await Future<void>.delayed(Duration(seconds: 10));

  // Note that it is not because the native handles are not reaped we see this slowdown...

  runTest(realm, 1000);
  realm.close();
  Realm.shutdown();
}
