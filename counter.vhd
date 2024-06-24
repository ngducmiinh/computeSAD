library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter is
    Port ( 
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        enable : in STD_LOGIC;
        cnt : out integer
    );
end Counter;

architecture Behavioral of Counter is
    signal count : integer := 0;
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            count <= 0;
        elsif rising_edge(CLK) then
            if enable = '1' then
                if count = 8 then
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
    cnt <= count;
end Behavioral;
