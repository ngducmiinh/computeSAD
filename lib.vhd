library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package SAD_Package is
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

    component Controller is
        Port (
            CLK       : in  STD_LOGIC;
            RST       : in  STD_LOGIC;
            start     : in  STD_LOGIC;
            cnt       : in  integer;
            calc_done : in  STD_LOGIC;
            done      : out STD_LOGIC;
            enable    : out STD_LOGIC
        );
    end component;

    component Datapath is
        Port ( 
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            memA_Dout : in STD_LOGIC_VECTOR(7 downto 0);
            memB_Dout : in STD_LOGIC_VECTOR(7 downto 0);
            cnt : in integer;
            sad_temp : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component Counter is
        Port ( 
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            enable : in STD_LOGIC;
            cnt : out integer
        );
    end component;
end SAD_Package;
