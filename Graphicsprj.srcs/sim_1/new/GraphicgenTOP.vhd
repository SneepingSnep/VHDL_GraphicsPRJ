-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity GraphicgenTOP_tb is
end;

architecture bench of GraphicgenTOP_tb is

  component GraphicgenTOP
      Port (
          clk       : in  STD_LOGIC;
          reset : in std_logic;
          BTNL,BTNR,BTNUP,BTNDOWN : in std_logic;
          rgb   : out STD_LOGIC_VECTOR (11 downto 0);
          hsync    : out STD_LOGIC;
          vsync    : out STD_LOGIC
      );
  end component;

  signal clk: STD_LOGIC;
  signal reset: std_logic;
  signal BTNL,BTNR,BTNUP,BTNDOWN: std_logic;
  signal rgb: STD_LOGIC_VECTOR (11 downto 0);
  signal hsync: STD_LOGIC;
  signal vsync: STD_LOGIC ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: GraphicgenTOP port map ( clk     => clk,
                                reset   => reset,
                                BTNL    => BTNL,
                                BTNR    => BTNR,
                                BTNUP   => BTNUP,
                                BTNDOWN => BTNDOWN,
                                rgb     => rgb,
                                hsync   => hsync,
                                vsync   => vsync );

  stimulus: process
  begin

    -- Put initialisation code here

    reset <= '0';
    wait for 5 ns;
    reset <= '1';
    wait for 5 ns;

    -- Put test bench stimulus code here
    BTNL <= '1';
    wait for 20 ns;
    stop_the_clock <= false;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      Clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  