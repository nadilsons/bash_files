for i in './dot.*' $CUSTOM_DIR; do
    ls -1 $i | while read line; do 
        echo $line 
        ln -fs `pwd`/$line ~/`echo $line | sed -e 's/^\.\/dot//' | sed -e 's/^\.\.\/dot//'`;
    done
done
