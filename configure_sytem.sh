ls -1 dot.* | while read line; do 
	ln -s `pwd`/$line ~/`echo $line | sed -e 's/^dot//'`; 
done
