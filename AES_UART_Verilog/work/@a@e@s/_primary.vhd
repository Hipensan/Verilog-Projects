library verilog;
use verilog.vl_types.all;
entity AES is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        INIT            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        ROUND           : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        LSTROUND        : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        DONE            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        i_Clk           : in     vl_logic;
        i_Rst           : in     vl_logic;
        i_Start         : in     vl_logic;
        i_fDec          : in     vl_logic;
        i_Key           : in     vl_logic_vector(127 downto 0);
        i_Text          : in     vl_logic_vector(127 downto 0);
        o_fDone         : out    vl_logic;
        o_Text          : out    vl_logic_vector(127 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of INIT : constant is 1;
    attribute mti_svvh_generic_type of ROUND : constant is 1;
    attribute mti_svvh_generic_type of LSTROUND : constant is 1;
    attribute mti_svvh_generic_type of DONE : constant is 1;
end AES;
