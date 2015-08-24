import "dart:io";
import 'package:path/path.dart' as path;

void main(){
  fixPicasaImportDirectories();
}

void fixPicasaImportDirectories(){
  
  print( "Converting any import directories created by Picasa into the format YYYY \\ YYYY-MM-DD");
  
  Directory photos = new Directory( "C:/Users/hangs_000/Pictures");
  
  photos.listSync()
    .where( (e)=>_isImportDirectory(e)).forEach((e) => _processImportDirectory( e));
}

bool _isImportDirectory( FileSystemEntity entity){
  
  if(FileSystemEntity.isDirectorySync(entity.path)){
    String basename = path.basename( entity.path);
    return basename.contains( new RegExp( r'\d{4}[-_]\d{2}[-_]\d{2}')); 
  }
  return false;
}

void _processImportDirectory( FileSystemEntity entity ){
  
  String basename = path.basename( entity.path);
  var year = basename.split( new RegExp(r'[-_]'))[0];

  Directory parentYear = new Directory( "${entity.parent.path}\\${year}");  
  if( !parentYear.existsSync()){
    parentYear.createSync();
  }
  var newDir = '${parentYear.path}\\${basename}'; 
  entity.renameSync( newDir);
}