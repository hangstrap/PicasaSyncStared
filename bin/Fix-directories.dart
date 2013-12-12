import "dart:io";
import 'package:path/path.dart' as path;

void main(){
  processYearDirectory( "C:\\Users\\Public\\Pictures\\Pictures\\2011");
}

void processYearDirectory( String pathToDirectory){
    
  Directory directoryToProcess = _constructDirectoryObject( pathToDirectory);
  
  String year = path.basename( pathToDirectory);
  
  directoryToProcess.listSync()
    .where( (e)=>isDirectory(e))
      .forEach((f)=> processMonthDirectory( directoryToProcess, f.path));  
  
}

void processMonthDirectory( Directory year, String pathToMonthDirectory){
  
  String month   = path.basename( pathToMonthDirectory);
  Directory directoryToProcess = _constructDirectoryObject( pathToMonthDirectory);
  
  directoryToProcess.listSync()
    .where( (e)=>isDirectory(e))
      .forEach((f)=> processDayDirectory( year, month, f.path));  
  
  
}

void processDayDirectory( Directory year, String month, String pathToDayDirectory){
  
  String day   = path.basename( pathToDayDirectory);  
  String targetDirectoryName = "${path.basename(year.path)}_${ month}_${day}";
  String targetDirectoryPath = path.join( year.path, targetDirectoryName );
  
  print( "${targetDirectoryPath} ${pathToDayDirectory}");
  
  Directory dayDirectory = _constructDirectoryObject( pathToDayDirectory);
  dayDirectory.renameSync( targetDirectoryPath);
  
  
}

Directory _constructDirectoryObject( String path){
  
  Directory directory = new Directory( path);
  if( !directory.existsSync()){
    throw new Exception( "Directory ${path} does not exist");
  }
  return directory;
}
bool isDirectory( entity){
  return FileSystemEntity.isDirectorySync(entity.path);
}