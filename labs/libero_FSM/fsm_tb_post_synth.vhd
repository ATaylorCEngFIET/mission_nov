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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_tb is
end;

architecture bench of fsm_tb is

  component fsm
    port (
      rst      : in std_logic;
      clk      : in std_logic;
      data_in  : in std_logic_vector(31 downto 0);
      start    : in std_logic;
      mode     : in std_logic;
      data_out : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal rst      : std_logic;
  signal clk      : std_logic;
  signal data_in  : std_logic_vector(31 downto 0);
  signal start    : std_logic;
  signal mode     : std_logic;
  signal data_out : std_logic_vector(31 downto 0);

begin

  fsm_inst : fsm
  port map(
    rst      => rst,
    clk      => clk,
    data_in  => data_in,
    start    => start,
    mode     => mode,
    data_out => data_out
  );

  clk_process : process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process clk_process;


  stim : process
  begin
    rst     <= '1';
    data_in <= (others => '0');
    start   <= '0';
    mode    <= '0';
    wait until rising_edge(clk);
    rst <= '0';
    wait for 1 us;
    wait until rising_edge(clk);
    start   <= '1';
    mode    <= '1';
    data_in <= x"55aa55aa";
    wait until rising_edge(clk);
    start <= '0';
    wait for 1 us;
    wait until rising_edge(clk);
    start <= '1';
    mode  <= '0';
    wait until rising_edge(clk);
    start <= '0';
    mode  <= '0';
    wait for 1 us;
    wait until falling_edge(clk);
    << signal .fsm_tb.fsm_inst.\current_state[0]\.Q: std_logic >> <= force '1'; 
    << signal .fsm_tb.fsm_inst.\current_state[1]\.Q: std_logic >> <= force '1'; 
    wait until falling_edge(clk);
    << signal .fsm_tb.fsm_inst.\current_state[0]\.Q: std_logic >> <= release; 
    << signal .fsm_tb.fsm_inst.\current_state[1]\.Q: std_logic >> <= release; 
    wait for 1 us;
    report "simulation complete" severity failure;
  end process;

end;