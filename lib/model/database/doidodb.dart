import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DoidoDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'doidodb');

    Database mydb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  _onUpgrade(Database db, int version, int newVersion) async {
    Batch bd = db.batch();
    bd.execute("""
      INSERT INTO Tache
      (
        Title,
        time_start,
        time_end,
        Description,
        DateEcheance,
        Statut_ID
      )
      VALUES
      (
        'Course Flutter',
        '17:00 PM',
        '12:00 AM',
        'Cross-Platform',
        '2023-07-09',
        1
      )
    """);
    print("_onUpgrade ===========");
  }

  _onCreate(Database db, int version) async {
    Batch dbbatch = db.batch();
    dbbatch.execute("""
      CREATE TABLE Statut (
        Statut_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        NomDuStatut TEXT
      )""");
    dbbatch.execute("""
      CREATE TABLE Tache (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Title TEXT,
        time_start TEXT NOT NULL,
        time_end TEXT NOT NULL,
        Description TEXT,
        DateEcheance DATE,
        Statut_ID INTEGER,
         FOREIGN KEY (Statut_ID) REFERENCES Statut(Statut_ID)
        )
    """);
    dbbatch.execute("INSERT INTO Statut(NomDuStatut) VALUES ('Completé')");
    dbbatch.execute("INSERT INTO Statut(NomDuStatut) VALUES ('Incompleté')");
    // dbbatch.execute("""
    //   INSERT INTO Tache
    //   (
    //     Title,
    //     time_start,
    //     time_end,
    //     Description,
    //     DateEcheance,
    //     Statut_ID
    //   )
    //   VALUES
    //   (
    //     'Course Flutter',
    //     '10:00 AM',
    //     '12:00 PM',
    //     'GetX',
    //     '2023-07-09',
    //     1
    //   )
    // """);
    // dbbatch.execute("""
    //   INSERT INTO Tache
    //   (
    //     Title,
    //     time_start,
    //     time_end,
    //     Description,
    //     DateEcheance,
    //     Statut_ID
    //   )
    //   VALUES
    //   (
    //     'Ceremonie Officiel',
    //     '17:00 PM',
    //     '12:00 AM',
    //     'Ceremonie',
    //     '2023-07-01',
    //     1
    //   )
    // """);
    await dbbatch.commit();
    print("_onCreate ====================");
  }

  Future<List<Map<String, Object?>>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, Object?>> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  Future<int> updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<List<Map<String, Object?>>> selectData(String table) async {
    Database? mydb = await db;
    List<Map<String, Object?>> response = await mydb!.query(table);
    return response;
  }

  Future<int> insertRows(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, values);
    return response;
  }

  updateRows(String table, Map<String, Object?> values, mywhere) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, values, where: mywhere);
    return response;
  }

  deleteRows(String table, mywhere) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: mywhere);
    return response;
  }
}
