$arr = (ls bower_components demo.html -Recurse)
$b = ''
$h = ''
foreach($a in $arr){
  $body=$false
  $p=$a.PSParentPath+"\"+$a.Name
  echo $p
  $a=$a.PSParentPath -replace '.+\\'
  foreach($l in (cat $p)){
    if(($l -like '*prettify*')){
      $l
      exit
    }
    if(($l.trimstart().startswith('<script ') -or `
       ($l.trimstart().startswith('<link ')))  -and `
      !($l -like '*/webcomponents.js*' -or `
        $l -like '*/platform.js*' -or `
        $l -like '*/polymer.html*')){
      $h += $l -replace 'href="', "href=`"bower_components/$a/" `
        -replace 'src="', "src=`"bower_components/$a/"
    }
    if(!$body){
      $body=$l.startswith('<body ')
    }else{
      $body=!$l.startswith('</body>')
      if($body){
        $b += $l -replace 'href="', "href=`"bower_components/$a/" `
          -replace 'src="', "src=`"bower_components/$a/"
      }
    }
  }
}

"<html>
<head>
  <script src=`"bower_components/webcomponentsjs/webcomponents.js`"></script>
$h
</head>
<body>
  <script src=`"bower_components/polymer/polymer.html`"></script>
$b
</body>
</html>" | sc test.html -Encoding utf8
