# Pipeline CPU

### **HDL simulator you used:**
- modelsim
### **Features:**
-  Data hazard + Control hazard
### **Architecture diagrams:**
![](https://i.imgur.com/zPdfkB6.png)
 

### **Hardware module analysis:**
HazardDetectionUnit:
-  在branch or jump 時 activate IF_flush,ID_flush, EX_flush 
- 在 load時 pull down PCwrite, IF_IDwrite
Forwarding: 
- 在data hazard時 determine ForwardA, ForwardB

### **Problems I met and solutions:**
1. Branch or jump時, pc的值會更新, 但pc+4 的值卻還是舊的, 所以要更新pc+4的值
2. 想利用IF/IDwrite, pcwrite preventing the PC register and the IF/ID pipeline register from changing 時, 如果以clk Pull up 時才做就晚了一個cycle, 所以要用IF/IDwrite, pcwrite 先控制the input of the PC register and the IF/ID pipeline register
### **Summary:**
Data hazard + Control hazard 的功能都正常支援ADD, ADDI, SUB, AND, OR, NOR, LUI, SLT, SLL, LW,SW,BEQ, BNE, JUMP
