-- /*Copyright (c) 2020 Adiuvo Engineering & Training Ltd
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:

-- 1. Redistributions of source code must retain the above copyright notice, this
-- list of conditions and the following disclaimer. 
-- 2. Redistributions in binary form must reproduce the above copyright notice,
-- this list of conditions and the following disclaimer in the documentation
-- and/or other materials provided with the distribution.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
-- ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- The views and conclusions contained in the software and documentation are those
-- of the authors and should not be interpreted as representing official policies, 
-- either expressed or implied, of the FreeBSD Project*/

--- TerosHDL capabilites are below
--!{ signal: [
--!   { name: "rst", wave: 'x10......' },
--!   { name: "clk", wave: 'P.......' },
--!   { name: "start", wave: '0..1010.' },
--!   { name: "mode", wave: '0..1010.' },
--!   { name: "data_in",   wave: "x..=x..x", data: ["IP"] },
--!   { name: "data_out",  wave: "x....=x.", data: ["OP"] },
--! ]}

--!{reg: [
--!    {name: 'IPO',   bits: 8, attr: 'RO'},
--!]}

library ieee;
use ieee.std_logic_1164.all;

--! Example of FSM for Mission Critical course this has not mitigation 
--! by default
entity fsm is
  port (

    rst : in std_logic; --!clock
    clk : in std_logic; --!reset

    data_in : in std_logic_vector(31 downto 0); --!data in 
    start   : in std_logic; --! 0 = idle 1 = start transaction
    mode    : in std_logic; --!0 = read 1 - write

    data_out : out std_logic_vector(31 downto 0)--!data out
  );
end fsm;

architecture rtl of fsm is
  --attribute syn_safe_case        : string;
  --attribute syn_safe_case of rtl : architecture is "true";
  type state is (idle, rd, wr, unmapped);

  signal current_state : state;
  signal transfer_word : std_logic_vector(31 downto 0);
begin

  fsm : process (rst, clk)
  begin
    if rst = '1' then
      current_state <= idle;
      transfer_word <= (others => '0');
      data_out      <= (others => '0');
    elsif rising_edge(clk) then
      case current_state is
        when idle =>
          if start = '1' then
            if mode = '0' then
              current_state <= rd;
            else
              current_state <= wr;
            end if;
          end if;
        when rd =>
          data_out      <= transfer_word;
          current_state <= idle;
        when wr =>
          transfer_word <= data_in;
          current_state <= idle;
        when others =>
          --current_state <= idle;
          --null;
      end case;
    end if;
  end process;

end architecture;