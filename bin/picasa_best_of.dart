import "FixPicasaImportDirectory.dart" as fixImportDirectory;
import "dart:io";
import 'package:path/path.dart' as path;
import "package:ini/ini.dart";

/* 
 * Best of YYYY section has the following format
 [.album:best_of_2013]
name=Best of 2013
token=best_of_2013
 * 
 *  add all the .album sections  
 *  determine year of photos - based on [Picasa]name field if has format yyyy-mm-dd, yyyy_mm_dd, or use file path 
 *    for every section 
 *      if section key star=yes then
 *        if albums key not defined then add albums key
 *         add token of 'best_of_YYYY' if nessary
 *        
 *         if no Best of YYYY section then add it
 *
 * 
 * best of albums can now be synced with Google Albums    


TODO: What happens when remove a star?


*/
void main() {
  fixImportDirectory.fixPicasaImportDirectories();

  Directory photos = new Directory(
      "C:/Users/hangs_000/Pictures");

  //neested function
  bool isYearDirectory(FileSystemEntity entity) {


    if (FileSystemEntity.isDirectorySync(entity.path)) {

      String basename = path.basename(entity.path);
      print(basename);

      //return basename == '2013';

      if (basename.length == 4) {
        return basename.contains(new RegExp(r'\d{4}'));
      }
    }
    return false;
  }

  photos.listSync().where(isYearDirectory).forEach((e) => procesYearDirectory(e)
      );

}



void procesYearDirectory(Directory entity) {

  String year = path.basename(entity.path);

  //nested function
  bool _isYyyymmDdDirectory(FileSystemEntity entity) {

    if (FileSystemEntity.isDirectorySync(entity.path)) {
      String basename = path.basename(entity.path);
      //   return basename == '2013-11-14';
      return basename.contains(new RegExp(r'\d{4}[-_]\d{2}[-_]\d{2}'));
    }
    return false;
  }
  //nested function
  bool containsPicasaIni(Directory directory) {

    if (fileExists(directory, "picasa.ini")) {

      File f = new File(directory.path + "\\" + "picasa.ini");
      f.rename(directory.path + "//.picasa.ini");
    }

    return fileExists(directory, ".picasa.ini");
  }


  new Directory(entity.path).listSync().where((e) => _isYyyymmDdDirectory(e) &&
      containsPicasaIni(e)).forEach((e) => processDiretory(year, e));
}

bool fileExists(Directory directory, String fileName) {
  File f = new File(directory.path + "\\" + fileName);
  return f.existsSync();
}


void processDiretory(String year, Directory directory) {

  print("directory to proces ${directory}");

  var file = new File(directory.path + "\\.picasa.ini");
  Config config = Config.readFileSync(file);

  String albumToken = "best_of_${year}";
  insureConfigContainsBestOfYearAlbum(year, albumToken, config);


  bool madeChange = false;
  config.sections().forEach((String section) {

    if (config.has_option(section, "star")) {
      //     print( "${directory} ${section} is stared");

      if (!config.has_option(section, 'albums')) {
        config.set(section, 'albums', '${albumToken}');
        madeChange = true;
      }
      String albumValues = config.get(section, 'albums');
      if (!albumValues.split(',').contains(albumToken)) {
        albumValues = '${albumValues},${albumToken}';
        config.set(section, 'albums', albumValues);
        madeChange = true;
      }
    }
  });

  if (madeChange) {

    //Cannot save a file starting with '.' - no idea why
    //but we can rename a file
    file.renameSync(file.path + '.old');
    var fileNew = new File(directory.path + "\\.picasa.ini.new");
    String contents = config.toString().replaceAll(" = ", "=");
    fileNew.writeAsStringSync(contents);
    fileNew.renameSync(directory.path + "\\.picasa.ini");
    print("changed directory " + directory.path);

  }
}
/**
 [.album:test_2013]
name=Best_Of_2013
token=test_2013
 */
void insureConfigContainsBestOfYearAlbum(String year, String albumToken, Config
    config) {

  String section = '.album:${albumToken}';
  if (!config.has_section(section)) {
    config.add_section(section);
    config.set(section, 'token', albumToken);
    config.set(section, 'name', 'Best Of ${year}');
  }

}

String getAlbumToken(String year) {
  return "best_of_${year}";
}


