module LoadUse(MemRead_3,rt_2,rt_3,rs_2,stall,pcwrite,ifwrite);
input MemRead_3;//id_ex的MemRead信号
input rt_2;//if_id输出的rt
input rt_3;//id_ex输出的rt
input rs_2;//if_id输出的rs
output reg stall;//stall信号将id_ex流水线寄存器中的EX、MEM和WB级控制信号全部清零
output reg pcwrite;//pcwrite信号禁止PC寄存器接收新数据，低电平有效。
output reg ifwrite;//ifwrite信号禁止if_id流水段寄存器接受新数据，低电平有效。

always @(*)
begin
     stall<=MemRead_3&((rt_3==rs_2)||(rt_3==rt_2));
     pcwrite<=~stall;
     ifwrite<=~stall;	
end
endmodule