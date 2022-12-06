-module(aoc_05).

-export([stack/0, run/0]).

% one stack of crates, modeled as a process
stack() -> stack([]).
stack(L) ->
	NextL = receive
		{push, Boxes, ReportBack} ->
			ReportBack ! {ready, self()},
			lists:append(Boxes, L);
		{move, ToPid, Amount, ReportBack} ->
			Boxes = lists:sublist(L, Amount),
			ReportBack ! {ready, self()},
			ToPid ! {push, Boxes, ReportBack},
			lists:nthtail(Amount, L);
		{top, Pid} ->
			Pid ! {top_is, lists:sublist(L, 1)},
			L
	end,
	stack(NextL).

% for initial pushing, no pingback is needed.
% so this is run as a receiver to ignore it
trash() -> receive _ -> ok end, trash().

% main program
run() ->
	register(trash, spawn(fun() -> trash() end)),
	{N, Input} = read_init_lines(),
	StackPids = lists:map(fun(_) -> spawn(fun() -> stack() end) end, lists:seq(1, N)),
	lists:foreach(fun(Line) -> push_line(StackPids, Line) end, Input),
	lists:foreach(fun(Pid) -> self() ! {ready, Pid} end, StackPids),
	cmd_loop(StackPids),
	Res = collect(StackPids),
	io:fwrite("~s\n", [Res]).

% reads the initial input lines and returns them in reversed order.
% additionally the number of stacks is returned.
read_init_lines() -> read_init_lines([]).
read_init_lines(Lines) ->
	case io:get_line("") of
		"\n" ->
			[Nums | Data] = Lines,
			N = trunc((length(Nums))/4),
			{N, Data};
		L -> read_init_lines([L|Lines])
	end.

% push_line(Pids, Line)
%  Parses an input line: Pushes all the crates in Line to the Pids
%  As the line ends with \n, we can parse it in blocks of 4 characters:
%  "[x] " or "    ".
push_line([], "") -> ok;
%  ignore spaces
push_line([_P|Pids], [$ ,$ ,$ ,_Sep|Line]) -> push_line(Pids, Line);
%  push crate
push_line([P|Pids], [_A,B,_C,_Sep |Line]) ->
	P ! {push, [B], trash},
	push_line(Pids, Line).


%  Reads and executes the command inputs
cmd_loop(StackPids) ->
	R = io:fread("", "move ~d from ~d to ~d\n"),
	case R of
		{ok, [Amount, From, To]} ->
			FromPid = lists:nth(From, StackPids),
			ToPid = lists:nth(To, StackPids),
			move_cmd(Amount, FromPid, ToPid),
			cmd_loop(StackPids);
		eof -> ok;
		{error, _} -> error
	end.

%  Dispatches a move command after waiting for the stacks
move_cmd(Amount, FromPid, ToPid) ->
	% wait, that the stacks are ready
	receive {ready, FromPid} -> ok end,
	receive {ready, ToPid} -> ok end,
	FromPid ! {move, ToPid, Amount, self()}.

% collect(Pids)
%   Waits for the given stack processes and concatenates the top elements.
collect([]) -> "";
collect([P|Pids]) ->
	receive {ready, P} -> ok end,
	P ! {top, self()},
	S = receive {top_is,X} -> X end,
	lists:append(S, collect(Pids)).
