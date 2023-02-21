library verilog;
use verilog.vl_types.all;
entity KeyExpansion is
    port(
        i_Key           : in     vl_logic_vector(127 downto 0);
        Rnd             : in     vl_logic_vector(3 downto 0);
        i_fDec          : in     vl_logic;
        i_fRKey         : in     vl_logic;
        Round_Key       : out    vl_logic_vector(127 downto 0)
    );
end KeyExpansion;
