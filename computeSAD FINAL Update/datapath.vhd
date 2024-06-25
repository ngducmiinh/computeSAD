library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datapath is
    Port ( 
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        memA_Dout : in STD_LOGIC_VECTOR(7 downto 0);
        memB_Dout : in STD_LOGIC_VECTOR(7 downto 0);
        cnt : in integer;
        sad_temp : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Datapath;

architecture Behavioral of Datapath is
    signal sad_temp_int : unsigned(7 downto 0) := (others => '0');
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            sad_temp_int <= (others => '0');
        elsif rising_edge(CLK) then
            if cnt <= 8 then
                sad_temp_int <= sad_temp_int + unsigned(abs(signed(memA_Dout) - signed(memB_Dout)));
            end if;
        end if;
    end process;
    sad_temp <= std_logic_vector(sad_temp_int);
end Behavioral;
