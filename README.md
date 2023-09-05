# round-robin_arbiter
A light round-robin arbiter for digital IC design. Support parameterized configuration request number

数字芯片设计中比较常用的仲裁模块

对比“选择组合电路”，“轮换-固定优先级仲裁-轮换”等设计思路，缺乏优雅，精巧，公用性的设计

总结规律性，共通性，目前的思路基于以下方法：

假如存在4个请求者，A,B,C,D，电路复位后，A为最高优先级，D为最低优先级

| TIME | request | grant | current priority | next prority |
|      |   DCBA  |       |                  |              |
|   0  |   0110  | 0010  |    DCBA          |    BADC      |
|------|---------|-------|------------------|--------------|
|   1  |   0101  | 0100  |    BADC          |    CBAD      |
|------|---------|-------|------------------|--------------|
|   2  |   1011  | 0001  |    DCAB          |    ADCB      |

默认优先级为DCBA，从左到右，优先级提升
round robin的规则，当前获得许可的请求，在下一时刻优先级变为最低；而前许可请求的左侧请求，下一时刻优先级变为最高
根据排列组合逻辑，只会存在4种优先级顺序，<DCBA，CBAD，BADC，ADCB>

| DCBA  | nxt first | nxt second | 
|-------|-----------|------------|
| hit A |   DCB     |   A        |
|-------|-----------|------------|
| hit B |   DC      |   BA       |
|-------|-----------|------------|
| hit C |   D       |   CBA      |
|-------|-----------|------------|
| hit D |   None    |   DCBA     |
|-------|-----------|------------|
