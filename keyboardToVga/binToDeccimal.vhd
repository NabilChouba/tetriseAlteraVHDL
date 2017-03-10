
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity binaryToDeccimal is
   port(
      clk: in std_logic;
      rst: in std_logic;
      go: in std_logic;
      binary: in std_logic_vector(12 downto 0);
      decimal: out std_logic_vector(11 downto 0)
   );
end binaryToDeccimal ;

architecture RTL of binaryToDeccimal is
   type state_type is (idle, op, done);
   signal state_q, state_d: state_type;
   signal p2s_q, p2s_d: std_logic_vector(12 downto 0);
   signal iteration_q, iteration_d: unsigned(3 downto 0);
   signal decimal1_q,decimal0_q: unsigned(3 downto 0);
   signal decimal1_d,decimal0_d: unsigned(3 downto 0);
   signal decimal1_tmp,decimal0_tmp: unsigned(3 downto 0);
begin
   
   process (clk,rst)
   begin
      if rst='1' then
         state_q <= idle;
         p2s_q <= (others=>'0');
         iteration_q <= (others=>'0');
         decimal1_q <= (others=>'0');
         decimal0_q <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_q <= state_d;
         p2s_q <= p2s_d;
         iteration_q <= iteration_d;
         decimal1_q <= decimal1_d;
         decimal0_q <= decimal0_d;
      end if;
   end process;

  decimal0_tmp <= decimal0_q + 3 when decimal0_q > 4 else decimal0_q;
  decimal1_tmp <= decimal1_q + 3 when decimal1_q > 4 else decimal1_q;
  decimal <= "0000" & std_logic_vector(decimal1_q) & std_logic_vector(decimal0_q) ;


   process(state_q,go,p2s_q,iteration_q,iteration_d,binary,decimal0_q,decimal1_q,decimal0_tmp,decimal1_tmp)
   begin
      state_d <= state_q;
      p2s_d <= p2s_q;
      decimal0_d <= decimal0_q;
		decimal1_d <= decimal1_q;
      iteration_d <= iteration_q;
      case state_q is
         when idle =>
            if go='1' then
               state_d <= op;
               decimal1_d <= (others=>'0');
               decimal0_d <= (others=>'0');
               iteration_d <="1101";  
               p2s_d <= binary;  
               state_d <= op;
            end if;
         when op =>
           
            p2s_d <= p2s_q(11 downto 0) & '0';
            decimal0_d <= decimal0_tmp(2 downto 0) & p2s_q(12);
            decimal1_d <= decimal1_tmp(2 downto 0) & decimal0_tmp(3);
            iteration_d <= iteration_q - 1;
            if (iteration_d=0) then
                state_d <= done;
            end if;
         when done =>
            state_d <= idle;
            
     end case;
   end process;


 	
end RTL;
