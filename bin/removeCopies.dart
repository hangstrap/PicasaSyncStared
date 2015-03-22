
/**
 * Removed any duplictes photo
 * A duplicate has the same file name and path as the original except that it has '-001' at the end of the filename
 * 
 * 
 */

import 'dart:io';

import 'package:path/path.dart' as path;


Directory topDirectory = new Directory("C:/Users/hangs_000/Pictures");
RegExp regex = new RegExp( r"\d\d\d\d-\d\d-\d\d");

main(){
  List<FileSystemEntity> directories = topDirectory.listSync();
  directories.forEach( (FileSystemEntity entry){
    
    if( FileSystemEntity.isDirectorySync( entry.path)){
      if( picasaDirectory( entry.path)){
       
        processDirectory( entry); 
        
      }
    }
  });
  
}

bool picasaDirectory( String directoryPath){
  String basename  = path.basename( directoryPath);
  return regex.hasMatch( basename);
}

void processDirectory( Directory directory){
  
  List<FileSystemEntity> files = directory.listSync();
  files.forEach( (FileSystemEntity item){
    if( FileSystemEntity.isFileSync( item.path)){
      if( item.path.endsWith( "-002.jpg")){
        
        String otherPath = item.path.replaceAll( "-002.jpg", ".jpg");
        
        File original = new File( otherPath);
        bool exists = original.existsSync();
        
        print("${item} ${original} ${exists}");
        
        if( exists){
          item.deleteSync();
        }
      }
    }
  });
  
}