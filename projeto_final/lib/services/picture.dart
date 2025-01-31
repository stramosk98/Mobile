import 'database.dart';
import '../models/picture.dart';

class PictureRepository {
  final DatabaseHandler _dbHandler;

  PictureRepository(this._dbHandler);

  Future<void> insertPicture(Picture picture) async {
    await _dbHandler.insertPicture([picture]);
  }

  Future<List<Picture>> retrievePictures() async {
    return await _dbHandler.retrievePictures();
  }
}