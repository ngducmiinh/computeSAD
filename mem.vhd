library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory is
    Port ( 
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        write_enable : in STD_LOGIC;
        read_enable  : in STD_LOGIC;
        address      : in integer;
        data_in      : in STD_LOGIC_VECTOR(7 downto 0);
        data_out     : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Memory;

architecture Behavioral of Memory is
    type memory_array is array (0 to 8) of STD_LOGIC_VECTOR(7 downto 0);
    signal mem : memory_array := (others => (others => '0'));
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if write_enable = '1' then
                mem(address) <= data_in;
            end if;
            if read_enable = '1' then
                data_out <= mem(address);
            end if;
        end if;
    end process;
end Behavioral;
