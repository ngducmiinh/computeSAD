library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.SAD_Package.ALL;

entity ComputeSAD is
    Port ( 
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        start : in STD_LOGIC;
        memA_Dout : in STD_LOGIC_VECTOR(7 downto 0);
        memB_Dout : in STD_LOGIC_VECTOR(7 downto 0);
        SAD_out : out STD_LOGIC_VECTOR(7 downto 0);
        done : out STD_LOGIC
    );
end ComputeSAD;

architecture Behavioral of ComputeSAD is
    signal cnt_int : integer := 0;
    signal sad_result : unsigned(15 downto 0) := (others => '0');
    signal computation_done : STD_LOGIC := '0';
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            cnt_int <= 0;
            sad_result <= (others => '0');
            computation_done <= '0';
        elsif rising_edge(CLK) then
            if start = '1' then
                if cnt_int <= 8 then  -- ??m b?o tính c? ph?n t? cu?i cùng
                    sad_result <= sad_result + unsigned(abs(signed(memA_Dout) - signed(memB_Dout)));
                    cnt_int <= cnt_int + 1;
                else
                    computation_done <= '1';
                end if;
            end if;
        end if;
    end process;

    SAD_out <= std_logic_vector(sad_result(7 downto 0));
    done <= computation_done;
end Behavioral;
