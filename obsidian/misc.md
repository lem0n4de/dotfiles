### ffmpeg
- copy audio data from right to left:
	- `ffmpeg -i inputfile -c:v copy -af "pan=stereo|FR=FR|FL=FR" outputfile`
