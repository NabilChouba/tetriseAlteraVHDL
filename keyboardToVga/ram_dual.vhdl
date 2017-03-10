-------------------------------------------------------------------------------- 
-- Create Date   :    25/08/2008 
-- Design Name   :    Ram 
-- Developped by :    

-- Description   :    Module Ram dual port generic.  
-------------------------------------------------------------------------------- 

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
 

entity ram_dual is 
generic( d_width    : integer ; 
         addr_width : integer ; 
         mem_depth  : integer 
        ); 
port (
      o2        : out STD_LOGIC_VECTOR(d_width - 1 downto 0);
      we1       : in STD_LOGIC;     
      clk       : in STD_LOGIC; 
      d1        : in STD_LOGIC_VECTOR(d_width - 1 downto 0); 
      addr1     : in unsigned(addr_width - 1 downto 0);
      addr2     : in unsigned(addr_width - 1 downto 0)      
      ); 
end ram_dual; 

architecture RAM_dual_arch of ram_dual is 

type mem_type is array (mem_depth - 1 downto 0) of  STD_LOGIC_VECTOR (d_width - 1 downto 0); 

signal mem : mem_type; 
begin

   rwrite_port :  process ( clk )
      begin
        if   (clk'event and clk = '1') then
            if ( we1    = '1') then
                mem(conv_integer(addr1)) <= d1;
            end if;
				o2 <= mem(conv_integer(addr2)) ;
       end if;
    end process rwrite_port ;

end RAM_dual_arch; 
