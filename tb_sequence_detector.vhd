library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sequence_detector is
end tb_sequence_detector;

architecture test of tb_sequence_detector is
	signal clk : STD_LOGIC := '0';
	signal reset : STD_LOGIC := '0';
	signal din : STD_LOGIC := '0';
	signal detected : STD_LOGIC;

begin
	uut: entity work.sequence_detector
		port map (
			clk => clk,
			reset => reset,
			din => din,
			detected => detected
		);

	clk_process : process
	begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;

	stim_process : process
	begin
	reset <= '1';
	wait for 20 ns;
	reset <= '0';
	wait for 20 ns;
	
	din <= '1';
	wait for 20 ns;

	din <= '0';
	wait for 20 ns;

	din <= '1';
	wait for 20 ns;

	din <= '1';
	wait for 20 ns;

	din <= '0';
	wait for 20 ns;

	din <= '1';
	wait for 20 ns;

	din <= '1';
	wait for 20 ns;

	wait;
end process;

end test;
