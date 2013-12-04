import 'package:unittest/unittest.dart';
//import '../bin/picasa_best_of.dart' as bestof;

main(){

  test("year", (){
    
    var re = new RegExp( r'\d\d\d\d');
    expect( "2013".contains( re), true);
  });

  
  test("fill", (){
    
    var re = new RegExp( r'\d{4}[-_]\d{2}[-_]\d{2}');
    expect( "2013-11-25".contains( re), true);
  });
  
  test("split", (){
    expect( "2013-11-25".split(  new RegExp(r'[-_]'))[0], "2013");
  });
}