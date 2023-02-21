library verilog;
use verilog.vl_types.all;
entity aes_sbox is
    port(
        i_data          : in     vl_logic_vector(7 downto 0);
        o_data          : out    vl_logic_vector(7 downto 0)
    );
end aes_sbox;
