// Code your testbench here
// or browse Examples
module tb_avion_cpu;
 
    parameter TEST_CASE = 2;
    
    parameter ADDRESS_WIDTH = 6;
    parameter DATA_WIDTH = 10;
    
    reg clk;
    reg rst;
    
    initial begin
      clk =1;
    end
    
    wire [ADDRESS_WIDTH-1:0] addr_toRAM;
    wire [DATA_WIDTH-1:0] data_toRAM, data_fromRAM;
    wire [ADDRESS_WIDTH-1:0] pCounter;
    wire wrEn;
 
    always clk = #5 !clk;
    
    reg error;
    integer i;
    
    initial begin
      rst = 1;
      error = 0;
      #100;
      rst <= #1 0;
      #5000;
      
      if(TEST_CASE == 1)
        memCheck(52,15);
      
      else if(TEST_CASE == 2)
        memCheck(52,50);
      
      else if(TEST_CASE == 3)
        memCheck(52,50);
      
      #500;
      $display("==== SIMULATION RESULT ====");
      $display("RAM[52] = %d", blram.memory[52]);
      if (error == 0)
        $display("✅ SUCCESS: Output is correct.");
      else
        $display("❌ FAIL: Output is wrong.");

      $finish;
      
    end
    
    avion_cpu #(
        ADDRESS_WIDTH,
        DATA_WIDTH
    ) avion_cpu_Inst(
        .clk(clk), 
        .rst(rst), 
        .MDRIn(data_toRAM), 
        .RAMWr(wrEn), 
        .MAR(addr_toRAM), 
        .MDROut(data_fromRAM), 
        .PC(pCounter)
    );
    
    blram #(ADDRESS_WIDTH, 64, TEST_CASE) blram(
      .clk(clk),
      .rst(rst),
      .i_we(wrEn),
      .i_addr(addr_toRAM),
      .i_ram_data_in(data_toRAM),
      .o_ram_data_out(data_fromRAM)
    );
    
    task memCheck;
        input [31:0] memLocation, expectedValue;
        begin
          if(blram.memory[memLocation] != expectedValue[9:0]) begin
                error = 1;
          end
        end
    endtask
    
endmodule
 
