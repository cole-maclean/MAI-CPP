numbers = [13,26,39,52,2,15,28,31,
1,14,27,40,3,16,29,42,
2,15,28,41,4,17,30,43,
3,16,29,42,5,18,31,44,
4,17,30,43,6,19,32,45, 
5,18,31,44,7,20,33,46, 
6,19,32,45,8,21,34,47, 
7,20,33,46,9,22,35,48,
8,21,34,47,10,23,36,49, 
9,22,35,48,11,24,37,50,
10,23,36,49,12,25,38,51,
11,24,37,50,13,26,39,52,
12,25,38,51,14,27,40,1,
13,26,39,52,2,15,28,31,
1,14,27,40,3,16,29,42,
2,15,28,41,4,17,30,43,
3,16,29,42,5,18,31,44,
4,17,30,43,6,19,32,45, 
5,18,31,44,7,20,33,46, 
6,19,32,45,8,21,34,47, 
7,20,33,46,9,22,35,48,
8,21,34,47,10,23,36,49, 
9,22,35,48,11,24,37,50,
10,23,36,49,12,25,38,51,
11,24,37,50,13,26,39,52,
12,25,38,51,14,27,40,1,
13,26,39,52,2,15,28,31,
1,14,27,40,3,16,29,42,
2,15,28,41,4,17,30,43,
3,16,29,42,5,18,31,44,
4,17,30,43,6,19,32,45, 
5,18,31,44,7,20,33,46, 
6,19,32,45,8,21,34,47, 
7,20,33,46,9,22,35,48,
8,21,34,47,10,23,36,49, 
9,22,35,48,11,24,37,50,
10,23,36,49,12,25,38,51,
11,24,37,50,13,26,39,52,
12,25,38,51,14,27,40,1,
13,26,39,52,2,15,28,31,
1,14,27,40,3,16,29,42,
2,15,28,41,4,17,30,43,
3,16,29,42,5,18,31,44,
4,17,30,43,6,19,32,45, 
5,18,31,44,7,20,33,46, 
6,19,32,45,8,21,34,47, 
7,20,33,46,9,22,35,48,
8,21,34,47,10,23,36,49, 
9,22,35,48,11,24,37,50,
10,23,36,49,12,25,38,51,
11,24,37,50,13,26,39,52,
12,25,38,51,14,27,40,1]

combos = []
indx = 1
for i,num in enumerate(numbers):
	if i == 0:
		i = 1
	if i % 8 == 0:
		indx = indx + 1
	combos.append(str(indx) + ',' + str(num))
print (",\n".join([comb for comb in combos]))
