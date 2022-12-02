with Ada.Text_IO;
procedure AoC_02 is
	function RPSValue(c: in Character) return Integer is
	begin
		if c <= 'C' then
			return Character'Pos(c) - Character'Pos('A') + 1;
		else
			return Character'Pos(c) - Character'Pos('X') + 1;
		end if;
	end;
	function RPSGame(opponent: Character; me: Character) return Integer is
	begin
		return 3 * ((RPSValue(me) - RPSValue(opponent) + 1) mod 3);
	end;
	function RPSMe(opponent: Character; result: Character) return Character is
		me_int : Integer := (RPSValue(result) + RPSValue(opponent) + 0) mod 3;
	begin
		return Character'Val(me_int + Character'Pos('A'));
	end;
	
	score_1: Long_Integer := 0;
	score_2: Long_Integer := 0;
begin
	Ada.Text_IO.Put_Line ("Hello, world!");


	loop
		exit when Ada.Text_IO.End_Of_File;
		declare
			input : String := Ada.Text_IO.Get_Line;
			opponent : Character := input(input'first);
			me_1 : Character := input(input'first + 2);
			me_2 : Character := RPSMe(opponent, me_1);
		begin

			Ada.Text_IO.Put_Line("Value: " & RPSValue(me_1)'Image);
			Ada.Text_IO.Put_Line("Game: " & RPSGame(opponent, me_2)'Image);
			Ada.Text_IO.Put_Line("Me: " & me_2);
			--Ada.Text_IO.Put_Line("Length: " & Integer'Image(String'Length(input)));
			score_1 := score_1 + Long_Integer(RPSValue(me_1) + RPSGame(opponent, me_1));
			score_2 := score_2 + Long_Integer(RPSValue(me_2) + RPSGame(opponent, me_2));
		end;
	end loop;
	Ada.Text_IO.Put_Line("Score 1:" & score_1'Image);
	Ada.Text_IO.Put_Line("Score 2:" & score_2'Image);
end AoC_02;

