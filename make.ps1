$arr = (ls bower_components).Name
foreach($a in $arr){
  (ls "bower_components\$a").Name
  if ((ls "bower_components\$a").Name -contains 'demo'){
    echo $a
  }
}
