library IEEE;
use IEE.STD_LOGIC_1164.ALL;

entity sequence_detector is
	Port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		din : in STD_LOGIC;
		detected : in STD_LOGIC;
	);
end sequence_detector;

architecture Behavioral of sequence_detector is
	type state_type is (S0, S1, S2, S3);
	signal current_state, next_state : state_type;
begin
	process(clk, reset) -- state register
	begin
		if reset = '1' then
			current_state <= S0;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
process(current_state, din) -- next state
begin
	detected <= '0';
	next_state <= current_state;

	case_current_state is

	when S0 =>
		if din = '1' then
			next_state <= S1;
		else
			next_state <= S0;
		end if;

	when S1 =>
		if din = '0' then
			next_state <= S10;
		else
			next_state <= S1;
		end if;

	when S10 => 
		if din = '1' then
			next_state <= S101;
		else
			next_state <= S0;
		end if;

	when S101 =>
		if din = '1' then
			detected <= '1';
			next_state <= S1;
		else
			next_state <= S10;
		end if;

end case
end process;

end Behavioral;
		
	
