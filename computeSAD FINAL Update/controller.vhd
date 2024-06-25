library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
    Port (
        CLK       : in  STD_LOGIC;
        RST       : in  STD_LOGIC;
        start     : in  STD_LOGIC;
        cnt       : in  integer;
        calc_done : in  STD_LOGIC;
        done      : out STD_LOGIC;
        enable    : out STD_LOGIC
    );
end Controller;

architecture Behavioral of Controller is
    type state_type is (IDLE, CALCULATE, DONE_STATE);
    signal state, next_state : state_type;
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            state <= IDLE;
        elsif rising_edge(CLK) then
            state <= next_state;
        end if;
    end process;

    process(state, start, calc_done)
    begin
        case state is
            when IDLE =>
                done <= '0';
                enable <= '0';
                if start = '1' then
                    next_state <= CALCULATE;
                else
                    next_state <= IDLE;
                end if;
            when CALCULATE =>
                enable <= '1';
                if calc_done = '1' then
                    next_state <= DONE_STATE;
                else
                    next_state <= CALCULATE;
                end if;
            when DONE_STATE =>
                enable <= '0';
                done <= '1';
                next_state <= IDLE;
        end case;
    end process;
end Behavioral;
