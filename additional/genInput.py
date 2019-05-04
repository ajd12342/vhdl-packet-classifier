import pyperclip
pktSize=144
res=""
for i in range(32):
	res+="iData("+str(i)+") <= iData_in("+str(i+1)+"*"+str(pktSize)+"-"+str(1)+" downto "+str(i)+"*"+str(pktSize)+");\n"
	print("iData("+str(i)+") <= iData_in("+str(pktSize*(i+1)-1)+" downto "+str(pktSize*i)+");")
pyperclip.copy(res)