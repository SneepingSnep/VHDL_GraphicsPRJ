--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    16:22:29 01/06/09
-- Design Name:    
-- Module Name:    BTNdb - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity local_db is
  port( Reset, Clk: in std_logic;
        BTNin: in std_logic;
        BTNout: out std_logic);
end local_db;

architecture Behavioral of local_db is

constant CountMax: std_logic_vector(11 downto 0) := X"F00";

type StateType is (BTNup, wBTNup, BTNdown, wBTNdown);
signal State, nState: StateType;  
signal count: std_logic_vector(11 downto 0);
signal CountEN, CountClr: std_logic;

begin

StateReg: process (Reset, Clk)
begin
  if Reset = '1' then State <= BTNup;
  elsif Clk'event and Clk = '1' then
    State <= nState;
  end if;
end process;

StateDec: process (state, BTNin, Count)
begin
  CountEN <= '0';
  CountClr <= '0';
  BTNout <= '0';
  nState <= BTNup;
  case state is
    when BTNup =>
		CountClr <= '1';
		if BTNin = '1' then
		  nState <= wBTNup;
		else
		  nState <= BTNup;
		end if;

    when wBTNup =>
		CountEN <= '1';
		if Count = CountMax then
		  BTNout <= '1';
		  nState <= BTNdown;
		  end if;
		else
		  nState <= wBTNup;
		end if;

    when BTNdown =>
		CountClr <= '1';
		if BTNin = '0' then
		  nState <= wBTNdown;
		else
		  nState <= BTNdown;
		end if;

    when wBTNdown =>
		CountEN <= '1';
		if Count = CountMax then
		  nState <= BTNup;
		else
		  nState <= wBTNdown;
		end if;

  end case;
end process;

CountReg: process(Reset, Clk)
begin
  if Reset = '1' then Count <= X"000";
  elsif Clk'event and Clk = '1' then
    if CountClr = '1' then
	   Count <= X"000";
    elsif CountEN = '1' then
	   Count <= Count + '1';
    end if;
  end if;
end process;

end Behavioral;
