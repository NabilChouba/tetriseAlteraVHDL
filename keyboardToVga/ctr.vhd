library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity ctr is
    Port ( clk : in  STD_LOGIC;          -- System Clock
           rst : in  STD_LOGIC;          -- System Reset
			  kb_data_ready : in  STD_LOGIC;-- there is data waiting
           kb_ack : out  STD_LOGIC;      -- data is read you can clear it and go to next
           counter_inc: out  STD_LOGIC;  -- move cursor to next position
           counter_dec: out  STD_LOGIC;  -- move cursor to previous position
			  ky_back_space : in STD_LOGIC; -- back space key detected
           ram_we : out  STD_LOGIC);     -- write a data keybord in the ram
end ctr;

architecture RTL of ctr is
  -- FSM States
   type state_type is (idle,kb_save,kb_back,kb_back2);
  -- FSM registers
  signal state_reg : state_type;
  signal state_next: state_type;

begin

 cloked_process : process( clk, rst )
  begin
    if( rst='1' ) then
      state_reg <=  idle ;
    elsif( clk'event and clk='1' ) then
      state_reg<= state_next ;
    end if;
 end process ;
 
  --next state processing state machine
  combinatory_FSM_next : process(state_reg,kb_data_ready,ky_back_space)
  begin
    state_next<= state_reg;
	 
    case state_reg is
    when idle =>
      if kb_data_ready = '1' then
		  if ky_back_space = '1' then 
		    state_next <= kb_back; 
        else		  
          state_next <= kb_save;  
		  end if;
      end if;
		
    when kb_back =>
	   state_next <= kb_back2; 
		
	when kb_back2 =>
	   state_next <= idle; 
		
    when kb_save =>
	   state_next <= idle; 
        when others =>
    end case;
  end process;
  
	
 --output
  combinatory_output : process(state_reg,kb_data_ready)
  begin
    kb_ack <='0';
    counter_inc<='0';
	 counter_dec<='0';
    ram_we <='0';
	 
    case state_reg is
    when idle =>
    
	 when kb_save =>
	   kb_ack <='1';
      counter_inc <='1';
      ram_we <='1';  
	 
	 when kb_back =>
      counter_dec <='1';
    
	 when kb_back2 =>
	   kb_ack <='1';
      ram_we <='1';
		
	 when others =>
	 end case;
  end process;	

end RTL;

