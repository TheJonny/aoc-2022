% vim: ft=prolog

:- dynamic(link/3).  % link(ParentUUID, ChildName, ChildUUID)
:- dynamic(directory/1). % directory(UUID)
:- dynamic(file/2). % file(UUID, Size)

directory(root).

doit(X) :- assert(parent("/", "bin")), X = 3.

read_input(I) :- read_line_to_string(user_input, L), (L = end_of_file, I=[], !; split_string(L, " ", " ", S), I = [S | J], read_input(J)).

commands([],[]).
commands([["$" | Line] | Lines], [cmd(Line,Output) | Commands]) :- 
	append(Output, RestLines, Lines),
	commands(RestLines, Commands), !.

read_commands(C) :- read_input(I), commands(I, C).


handle_cd(cmd(["cd","/"],[]), _OldCwd, root) :- !.
handle_cd(cmd(["cd",".."],[]), OldCwd, NewCwd) :- !, link(NewCwd, _Name, OldCwd), !.
handle_cd(cmd(["cd",Name],[]), OldCwd, NewCwd) :- link(OldCwd, Name, NewCwd).


resolve_link(Cwd, Name, Thing) :- link(Cwd, Name, Thing), !.
resolve_link(Cwd, Name, Thing) :- nonvar(Cwd), nonvar(Name), uuid(Thing), assertz(link(Cwd, Name, Thing)).

handle_ls(cmd(["ls"], []), _Cwd).
handle_ls(cmd(["ls"], [["dir", Name] | Rest]), Cwd) :-
	mkdir(Cwd, Name),
	handle_ls(cmd(["ls"], Rest), Cwd).
handle_ls(cmd(["ls"], [[SizeStr, Name] | Rest]), Cwd) :-
	number_string(SizeNum, SizeStr),
	mkfile(Cwd, Name, SizeNum),
	handle_ls(cmd(["ls"], Rest), Cwd).

handle_command(cmd([C|Args],Output), OldCwd, NewCwd) :-
	(C="ls", NewCwd=OldCwd, handle_ls(cmd([C|Args],Output), OldCwd));
	(C="cd", handle_cd(cmd([C|Args],Output), OldCwd, NewCwd)).

handle_commands([], D,D).
handle_commands([C|Cs], OldCwd,EndCwd) :- handle_command(C, OldCwd, NewCwd), !, handle_commands(Cs, NewCwd, EndCwd).

mkdir(Cwd, Name) :- resolve_link(Cwd, Name, Thing), assertz(directory(Thing)).
mkfile(Cwd, Name, Size) :- resolve_link(Cwd, Name, Thing), assertz(file(Thing, Size)).


treesize(D, OverallSize) :-
	directory(D),
	findall(Size,(link(D, _FName,Id), file(Id, Size)), Fs), sumlist(Fs, FileSize),
	findall(Size, (link(D, _DName, Id), directory(Id), treesize(Id, Size)), Ds), sumlist(Ds, DirSize),
	OverallSize is FileSize + DirSize.


% Use this to read the input
process_input():- read_commands(Commands), !, handle_commands(Commands, root, _).

% Answer to part 1
q1(Res) :- findall(S, (treesize(_D, S), S =< 100000), Sizes), sumlist(Sizes, Res).


capacity(70000000).
required(30000000).

% Answer to part 2
q2(Res) :-
	capacity(C), required(R), treesize(root, RootSize),
	findall(Free-S, (treesize(_D, S), Free is (C - RootSize + S), Free >= R), Sizes), min_member(_-Res, Sizes).
