# round-robin_arbiter

## 概述/Overview
一种数字芯片设计中常见的round-robin仲裁器。输入请求，当拍输出准予结果。支持参数化配置请求数量  
>A universal round-robin arbiter for digital IC design. Input request, at the same cycle output grant. Support parameterized configuration request number

## 架构图/Architecture diagram  
<img src="https://github.com/MosTransistor/round-robin_arbiter/assets/143840188/6e091f67-eec9-404d-8e69-55943507d7db" width="600" height="150" atl="rr_arb">

基于以下思路  
>Based on the following ideas:
> 
假如存在4个请求者：A,B,C,D；A为最高优先级，D为最低优先级,电路复位后，默认优先级为DCBA
>If there are 4 requesters: A, B, C, D; A is the highest priority, and D is the lowest priority. After the circuit is reset, the default priority is DCBA
>
根据round robin的规则：当前获得许可的请求，在下一时刻优先级变为最低；而前许可请求的左侧请求，下一时刻优先级变为最高。总结规律，只会存在4种优先级顺序，<DCBA，CBAD，BADC，ADCB>  
>According to the rules of round robin: the current permission request will have the lowest priority at the next moment; and the left request of the previous permission request will have the highest priority at the next moment. To sum up the rules, there will only be 4 priority orders, <DCBA, CBAD, BADC, ADCB>
>
所以将输入的请求分为2路处理，掩盖上一次获得许的请求者和其右侧的请求者，其他的请求者进入固定优先仲裁器（first）；所有的请求者进入固定优先仲裁器（second）,
>Divide all requesters to two way: mask the requester who obtained last grant and the requester on its right, other requester enter the fixed priority; all requesters enter the fixed priority
>
| DCBA | first | second | 
| --- | --- | --- |
| hit A | DCBx | dcbA |
| hit B | DCxx | dcBA |
| hit C | Dxxx | dCBA |
| hit D | xxxx | DCBA |

第一路仲裁结果更高，只有第一路的结果为全0，即采用第二路仲裁结果
>The result of the first way of arbitration is higher, only the result of the first way is all 0,the result of the second way of arbitration is used
>

## 数据结构/database
src -> 源代码，rr_arb_opt是在原基础上更加优化的verilog版本，相同功能但具有更小面积   
sim(Icarus Verilog + gtkwave) -> 仿真   
syn(yosys) -> 综合  
>verilog code in "src" folder（rr_arb_opt is a ultimate version and it have same function with less area）, simulation code in "sim" folder（use 'Icarus Verilog' tool）, synthesis script in "syn"(use 'yosys' tool)
>


## 备注/comment
仿真目录：“make sim”执行编译，“make wave”打开波形；综合目录：“make syn”执行综合  
> in "sim" folder, "make sim" for compile, "make wave" for open waveform; in "syn" folder, "make syn" for synthesis
> 
