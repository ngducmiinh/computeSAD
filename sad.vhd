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
    signal sad_temp : unsigned(7 downto 0) := (others => '0');
    signal calc_done : STD_LOGIC := '0';

    type state_type is (IDLE, CALCULATE, DONE_STATE);
    signal state, next_state : state_type;

begin
    process(CLK, RST)
    begin
        if RST = '1' then
            state <= IDLE;
            cnt_int <= 0;
            sad_temp <= (others => '0');
            SAD_out <= (others => '0');
            done <= '0';
        elsif rising_edge(CLK) then
            state <= next_state;

            if state = CALCULATE then
                sad_temp <= sad_temp + unsigned(abs(signed(memA_Dout) - signed(memB_Dout)));
                if cnt_int = 8 then
                    calc_done <= '1';
                else
                    cnt_int <= cnt_int + 1;
                end if;
            elsif state = IDLE then
                cnt_int <= 0;
                sad_temp <= (others => '0');
                SAD_out <= (others => '0');
                done <= '0';
            elsif state = DONE_STATE then
                SAD_out <= std_logic_vector(sad_temp);
                done <= '1';
            end if;
        end if;
    end process;

    process(state, start, calc_done)
    begin
        next_state <= state; -- Default assignment to avoid latches
        case state is
            when IDLE =>
                if start = '1' then
                    next_state <= CALCULATE;
                    calc_done <= '0';
                end if;
            when CALCULATE =>
                if calc_done = '1' then
                    next_state <= DONE_STATE;
                else
                    next_state <= CALCULATE;
                end if;
            when DONE_STATE =>
                next_state <= IDLE;
        end case;
    end process;

end Behavioral;
