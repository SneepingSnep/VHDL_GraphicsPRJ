library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GraphicgenTOP is
    Port (
        clk       : in  STD_LOGIC;
        reset : in std_logic;
        BTNL,BTNR : in std_logic;
        rgb   : out STD_LOGIC_VECTOR (11 downto 0);
        hsync    : out STD_LOGIC;
        vsync    : out STD_LOGIC
    );
end GraphicgenTOP;

architecture Behavioral of GraphicgenTOP is

    signal clk25 : std_logic := '0';
    signal clk50 : std_logic := '0';
    
    Constant bSize : integer := 10;
    
    Constant MaxH : integer := 639;
    Constant MaxV : integer := 479;
    
    Constant MinH : integer := 0;
    Constant MinV : integer := 0;
    
    signal bPosH : integer :=40;
    signal bPosV : integer :=40;
    
    

    signal hs : integer range 0 to 799 := 0;
    signal vs : integer range 0 to 524 := 0;
    
    type positionstatetype is (left, right, stationary);
    signal posState, posNextState : positionstatetype;
    
    signal BTNRdb,BTNLdb : std_logic;
    signal leftEN,rightEN : std_logic;
    
    
    component BTNdb
  port( Reset, Clk: in std_logic;
        BTNin: in std_logic;
        BTNout: out std_logic);
end component;

begin

    ----------------------------------------------------------------
    -- 100 MHz -> 25 MHz
    ----------------------------------------------------------------
    slowerclock : process(Clk,reset)
    begin
        if rising_edge(Clk) then
            
            if clk50 = '0' then

                clk50 <= '1';

                if clk25 = '0' then
                    clk25 <= '1';
                else
                    clk25 <= '0';
                end if;

            else

                clk50 <= '0';

            end if;

        end if;
    end process;

--    drawsomething : process(clk25)
--    begin
--        if rising_edge(clk25) then
            
--            -- Horizontal counter
--            if hs < 799 then
--                hs <= hs + 1;
--            else
--                hs <= 0;

--                -- Vertical counter
--                if vs < 524 then
--                    vs <= vs + 1;
--                else
--                    vs <= 0;
--                end if;

--            end if;


--            -- Horizontal sync
--            if (hs >= 656 and hs < 752) then
--                hsync <= '0';
--            else
--                hsync <= '1';
--            end if;


--            -- Vertical sync
--            if (vs >= 490 and vs < 492) then
--                vsync <= '0';
--            else
--                vsync <= '1';
--            end if;

--             if hs < 640 and vs < 480 then
--            rgb <= "111100000000"; -- red
--        else
--            rgb <= (others => '0');
--        end if;

--        end if;
--    end process;
    
    
--    updateposition : process(clk25)
--    begin
        
--    end process;
    
    
    
    
    
    drawgame : process(clk25,reset)
    begin
        if reset = '1' then
            
        elsif rising_edge(clk25) then
            
            -- Horizontal counter
            if hs < 799 then
                hs <= hs + 1;
            else
                hs <= 0;

                -- Vertical counter
                if vs < 524 then
                    vs <= vs + 1;
                else
                    vs <= 0;
                end if;

            end if;


            -- Horizontal sync
            if (hs >= 656 and hs < 752) then
                hsync <= '0';
            else
                hsync <= '1';
            end if;


            -- Vertical sync
            if (vs >= 490 and vs < 492) then
                vsync <= '0';
            else
                vsync <= '1';
            end if;

             if hs < bPosH + bSize and hs >= bPosH and vs < bPosV + bSize and vs >= bPosV then
            rgb <= "111100000000"; -- red
        else
            rgb <= (others => '0');
        end if;

        end if;
    end process;
    
    
    
    
    posStateReg : process(Clk, Reset)
begin   
    if Reset = '1' then
        posState <= stationary;
    elsif rising_edge(Clk) then
        posState <= posNextState;
    end if;
    
 end process;


posHorizontalReg : process(leftEN, rightEN)
    begin
        if rising_edge(clk) then
        if leftEN = '1' then 
            bPosH <= bPosH - 1;
        elsif rightEN = '1' then
            bPosH <= bPosH + 1;
        end if;
        end if;
    end process;


posdec : process(posState,BTNRdb,BTNLdb)
    begin
    leftEN <='0';
    rightEN <= '0';
        case posState is
            when stationary =>
                if BTNRdb = '1' then
                    posNextState <= right;
                elsif BTNLdb = '1' then
                    posNextState <= left;
                else 
                    posNextState <= stationary;
                end if;
            when right =>
                rightEN <= '1';
                posNextState <= stationary; 
            when left =>
                leftEN <= '1';
                posNextState <= stationary;
         end case;
    end process;

DebR: BTNdb port map (Reset => Reset, Clk => Clk, BTNin => BTNR, BTNout => BTNRdb);
DebL: BTNdb port map (Reset => Reset, Clk => Clk, BTNin => BTNL, BTNout => BTNLdb);
    
end Behavioral;