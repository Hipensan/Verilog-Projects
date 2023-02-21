library verilog;
use verilog.vl_types.all;
entity MixCol is
    port(
        i_D             : in     vl_logic_vector(31 downto 0);
        i_fDec          : in     vl_logic;
        o_D             : out    vl_logic_vector(31 downto 0)
    );
end MixCol;
