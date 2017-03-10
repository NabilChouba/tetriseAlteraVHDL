
library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_arith.all;  
use ieee.std_logic_signed.all; 

ENTITY counter IS
PORT (  clk        : in    std_logic ; -- System Clock
        rst        : in    std_logic ; -- System Reset
		  dec        : in    std_logic ; -- count <= count - 1
		  inc        : in    std_logic ; -- count <= count + 1
		  rst_count  : in    std_logic ; -- Reset the conter count <= 0
        count      : OUT unsigned(11 DOWNTO 0)); 
END counter;

ARCHITECTURE RTL OF counter IS
signal  count_reg       : unsigned(11 downto 0)  ;  
signal  count_next      : unsigned(11 downto 0)  ;  
 BEGIN
 -----------------------------------------------------------
 -- Sequence Counter                                      --
 -----------------------------------------------------------
 COUNTER_GEN : process( inc,dec,count_reg,rst_count )
    begin
     count_next <= count_reg;
     
     if ( rst_count ='1' ) then
	    count_next <= (others=>'0');
	  elsif( inc ='1' ) then
            count_next <= count_reg + 1 ;
     elsif( dec ='1' ) then
            count_next <= count_reg - 1 ;
          
      end if ;
    
    end process ;

 cloked_process : process( clk, rst )
  begin
    if( rst='1' ) then
      count_reg  <= (others=>'0') ;
    elsif( clk'event and clk='1' ) then
      count_reg <= count_next;
    end if;
 end process ;
 
 count <= count_reg;

END RTL;
