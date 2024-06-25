library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.SAD_Package.ALL;

entity SAD_TB is
end SAD_TB;

architecture Behavioral of SAD_TB is
    signal CLK : STD_LOGIC := '0';
    signal RST : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal memA_Dout, memB_Dout : STD_LOGIC_VECTOR(7 downto 0);
    signal SAD_out : STD_LOGIC_VECTOR(7 downto 0);
    signal done : STD_LOGIC;

    signal memA_addr, memB_addr : integer := 0;
    signal memA_we, memB_we, memA_re, memB_re : STD_LOGIC := '0';
    signal memA_Din, memB_Din : STD_LOGIC_VECTOR(7 downto 0);

    component ComputeSAD is
        Port ( 
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            start : in STD_LOGIC;
            memA_Dout : in STD_LOGIC_VECTOR(7 downto 0);
            memB_Dout : in STD_LOGIC_VECTOR(7 downto 0);
            SAD_out : out STD_LOGIC_VECTOR(7 downto 0);
            done : out STD_LOGIC
        );
    end component;

    component Memory is
        Port ( 
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            write_enable : in STD_LOGIC;
            read_enable  : in STD_LOGIC;
            address      : in integer;
            data_in      : in STD_LOGIC_VECTOR(7 downto 0);
            data_out     : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    type matrix_type is array (0 to 8) of STD_LOGIC_VECTOR(7 downto 0);

    signal matrixA1, matrixB1 : matrix_type;
    signal i : integer := 0;

begin
    UUT: ComputeSAD port map (
        CLK => CLK,
        RST => RST,
        start => start,
        memA_Dout => memA_Dout,
        memB_Dout => memB_Dout,
        SAD_out => SAD_out,
        done => done
    );

    memA: Memory port map (
        CLK => CLK,
        RST => RST,
        write_enable => memA_we,
        read_enable => memA_re,
        address => memA_addr,
        data_in => memA_Din,
        data_out => memA_Dout
    );

    memB: Memory port map (
        CLK => CLK,
        RST => RST,
        write_enable => memB_we,
        read_enable => memB_re,
        address => memB_addr,
        data_in => memB_Din,
        data_out => memB_Dout
    );

    -- Clock process
    CLK_process :process
    begin
        while true loop
            CLK <= not CLK;
            wait for 10 ns;
        end loop;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Initialize matrices with smaller numbers
        matrixA1 <= (std_logic_vector(to_unsigned(5, 8)), std_logic_vector(to_unsigned(2, 8)), std_logic_vector(to_unsigned(3, 8)),
                     std_logic_vector(to_unsigned(12, 8)), std_logic_vector(to_unsigned(5, 8)), std_logic_vector(to_unsigned(6, 8)),
                     std_logic_vector(to_unsigned(7, 8)), std_logic_vector(to_unsigned(8, 8)), std_logic_vector(to_unsigned(9, 8)));
        matrixB1 <= (std_logic_vector(to_unsigned(9, 8)), std_logic_vector(to_unsigned(7, 8)), std_logic_vector(to_unsigned(20, 8)),
                     std_logic_vector(to_unsigned(6, 8)), std_logic_vector(to_unsigned(5, 8)), std_logic_vector(to_unsigned(4, 8)),
                     std_logic_vector(to_unsigned(1, 8)), std_logic_vector(to_unsigned(2, 8)), std_logic_vector(to_unsigned(1, 8)));

        -- Reset and wait for some time
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 20 ns;

        -- Load matrixA1 and matrixB1 into memory
        for i in 0 to 8 loop
            memA_addr <= i;
            memB_addr <= i;
            memA_we <= '1';
            memB_we <= '1';
            memA_Din <= matrixA1(i);
            memB_Din <= matrixB1(i);
            wait for 20 ns;
            memA_we <= '0';
            memB_we <= '0';
        end loop;

        -- ??c d? li?u t? b? nh? và b?t ??u tính toán SAD
        for i in 0 to 8 loop
            memA_addr <= i;
            memB_addr <= i;
            memA_re <= '1';
            memB_re <= '1';
            wait for 20 ns;

            -- Start computation
            start <= '1';
            wait for 20 ns;
            start <= '0';
        end loop;

        wait until done = '1';
        wait for 20 ns;

        -- Display SAD result in decimal
        report "SAD result (matrixA1, matrixB1): " & integer'image(to_integer(unsigned(SAD_out)));

        wait;
    end process;

end Behavioral;
