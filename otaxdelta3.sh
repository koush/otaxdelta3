TMP=tmp

if [ -z "$UNZIP" ]
then
  UNZIP=unzip
fi

if [ -z "$XDELTA3" ]
then
  XDELTA3=xdelta3
fi

if [ -z "$CP" ]
then
  CP="$BB cp"
fi

if [ -z "$DIRNAME" ]
then
  DIRNAME=$"$BB dirname"
fi

if [ -z "$BASENAME" ]
then
  BASENAME="$BB basename"
fi

if [ -z "$MKDIR" ]
then
  MKDIR="mkdir"
fi

if [ -z "$ZIP" ]
then
  ZIP="$BB zip"
fi

if [ -z "$FIND" ]
then
  FIND="$BB find"
fi

if [ -z "$GREP" ]
then
  GREP="$BB grep"
fi

if [ -z "$SED" ]
then
  SED="$BB sed"
fi

function usage {
  echo Create delta:
  echo $0 c 1.zip 2.zip diff.zip
  echo
  echo Restore from delta:
  echo $0 x 1.zip diff.zip 2.zip
  echo
  echo Environment variables of note:
  echo 'export BB=/path/to/busybox'
  echo 'export ZIP=/path/to/zip'
  echo 'export UNZIP=/path/to/unzip'
  exit 1
}

function realpath {
  cd $($DIRNAME $1)
  echo $PWD/$($BASENAME $1)
}

function mkdirp {
  if [ "$1" == "." ]
  then
      return
  fi
  if [ "$1" == "/" ]
  then
      return
  fi
  
  DIR=$($DIRNAME $1)
  mkdirp $DIR
  BASE=$($BASENAME $1)
  $MKDIR $1 2> /dev/null
}

if [ -z "$4" ]
then
  usage
fi

if [ "$1" == "c" ]
then
  Z1=$(realpath $2)
  Z2=$(realpath $3)
  OUT=$(realpath $4)
  
  rm -f $OUT
  
  if [ ! -f "$Z1" ]
  then
    echo "$Z1 not found."
  fi

  if [ ! -f "$Z2" ]
  then
    echo "$Z2 not found."
  fi

  rm -rf $TMP
  mkdirp $TMP 2> /dev/null
  cd $TMP

  mkdirp z1 2> /dev/null
  mkdirp z2 2> /dev/null
  mkdirp out 2> /dev/null

  cd z1
  $UNZIP -o $Z1
  cd ..
  cd z2
  $UNZIP -o $Z2
  cd ..

  cd z1
  for f in $($FIND .)
  do
    $MKDIR ../out/$($DIRNAME $f) 2> /dev/null
    EQUIV=../z2/$f
    OUTFILE=../out/$f

    if [ -f $f ]
    then
      if [ -f $EQUIV ]
      then
        echo "delta: $f"
        $XDELTA3 -D -R -e -s $f $EQUIV $OUTFILE.delta
      else
        echo "copying: $f"
        $CP $f $OUTFILE
      fi
    fi
  done
  
  cd ../out
  zip -r $OUT .
else
  if [ "$1" == "x" ]
  then
    Z1=$(realpath $2)
    Z2=$(realpath $3)
    OUT=$(realpath $4)
    rm -f $OUT

    rm -rf $TMP
    mkdirp $TMP 2> /dev/null
    cd $TMP

    mkdirp z1 2> /dev/null
    mkdirp z2 2> /dev/null
    mkdirp out 2> /dev/null
    
    cd z1
    $UNZIP -o $Z1
    cd ..
    cd z2
    $UNZIP -o $Z2
    for f in $($FIND .)
    do
      if [ -f $f ]
      then
        mkdirp ../out/$($DIRNAME $f) 2> /dev/null
        DELTA=$(echo $f | $GREP \\.delta$)
        if [ ! -z "$DELTA" ]
        then
          NAME=$(echo $f | $SED s/\\.delta//)
          EQUIV=../z1/$NAME
          OUTFILE=../out/$NAME
          if [ ! -f "$EQUIV" ]
          then
            echo "Delta origin for $f not found."
            exit 1
          fi
          echo "patching: $NAME"
          $XDELTA3 -D -R -d -s $EQUIV $f $OUTFILE
          if [ "0" != "$?" ]
          then
            exit 1
          fi
        else
          echo "copying: $f"
          $CP $f ../out/$f
        fi
      fi
    done
    cd ..
    cd out
    $ZIP -r $OUT .
  else
    usage
  fi
fi