### Quick Steps   
1. _Upload_ a **text file** (<250 MB).   
The file size is limited to 250MB, as we have limited resources online  
2. _Tweak_ **minimum frequency, maximum words or rotation** for the cloud.   
3. It _generates_ a **word cloud** and a **frequency table**.   
4. _Download_ the word cloud as an **image (png)** and the frequency table as a **CSV file**.  
5. _Analyse_ top 7 frequencies; in **analysis** tab. 
<hr/>

### More Info
1. 230 KB file uploads in <2 secs, online. So, if it is slow, it could be due to other factors, please wait.
2. The processing of the file takes a few more seconds, there is a progress status displayed to the right corner - "Processing uploaded file's corpus ..."; before you upload a file - "Processing dummy file's corpus ...".
3. More details at [Pitch slides](http://studentcoursera.github.io/09_DDP_project_slidify)

### Limitations
1. If the value chosen for 'Minimum Frequency' is above the maximum frequency, then, it defaults to 1.  
2. By default, Shiny limits file uploads to 5MB per file. But, this app further limits to 500 MB.
3. All delimiters are not recognised as word seperator. So, you may see big words, with the delimiter removed but no space between words.
4. The word cloud, tries to rotate and realign; so, we notice the 'word cloud' shifting
5. Once you CANCEL while you 'choose file', the previously chosen filename goes off.   
<hr/>

### REFERENCES   
1. Built this app by refering to shiny apps gallery 'word cloud',  and added a few more features into it.  
2. Download feature has been refered to 'TrigonaMinima' code.  
3. https://sites.google.com/site/miningtwitter/basics/text-mining
