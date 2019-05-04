curr="00000000000000000000000000000001"
# for i in range(32):
# 	print("\twhen \""+curr+"\" =>")
# 	print("\t\tgrantportint <= \""+format(i, '05b')+"\";")
# 	curr=curr[1:]+"0"
print("grantportint <= ")
for i in range(32):
	print("\t"+str(i)+" when grantport = \""+curr+"\" else ")
	curr=curr[1:]+"0"