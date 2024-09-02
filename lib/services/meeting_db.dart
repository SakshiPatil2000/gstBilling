import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MeetingDb {

  static final MeetingDb _instance = MeetingDb._internal();
  static Database? _database;

  factory MeetingDb(){
    return _instance;
  } 
  
  MeetingDb._internal();

  Future<Database> get database async{
    if(_database !=null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async{
    String path = join(await getDatabasesPath(),'meeting.db');
    // Print the database path
    print('Database path: $path');
    return await openDatabase(
      path,
      version:1,
      onCreate: (db,version){
        return db.execute(
        'CREATE TABLE meetings(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, mobile TEXT, business TEXT, location TEXT)',

        );
      },
    );
  }
  Future<void> insertMeeting(Map<String, dynamic> meeting) async{
    final db = await database;
    await db.insert('meetings', meeting,conflictAlgorithm: ConflictAlgorithm.replace);
  }
 
 
 //get all the records from table
  Future<List<Map<String, dynamic>>> getAllMeetings() async {
    final db = await database;
    return await db.query('meetings');
  }





}