for i in './dot.*' '../dot.*'; do
	ls -1 $i | while read line; do 
		echo $line 
		ln -s `pwd`/$line teste/`echo $line | sed -e 's/^\.\/dot//' | sed -e 's/^\.\.\/dot//'`; 
	done
done