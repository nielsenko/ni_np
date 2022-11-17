// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ni_np.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class MyModel extends _MyModel with RealmEntity, RealmObjectBase, RealmObject {
  MyModel(
    int myInt,
  ) {
    RealmObjectBase.set(this, 'myInt', myInt);
  }

  MyModel._();

  @override
  int get myInt => RealmObjectBase.get<int>(this, 'myInt') as int;
  @override
  set myInt(int value) => RealmObjectBase.set(this, 'myInt', value);

  @override
  Stream<RealmObjectChanges<MyModel>> get changes =>
      RealmObjectBase.getChanges<MyModel>(this);

  @override
  MyModel freeze() => RealmObjectBase.freezeObject<MyModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MyModel._);
    return const SchemaObject(ObjectType.realmObject, MyModel, 'MyModel', [
      SchemaProperty('myInt', RealmPropertyType.int, indexed: true),
    ]);
  }
}
