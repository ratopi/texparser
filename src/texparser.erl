%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2019, Ralf Thomas Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 18:20
%%%-------------------------------------------------------------------
-module(texparser).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

%% API
-export([parser/1]).

parser(<<Bin/binary>>) ->
	parser(Bin, start, []).


parser(<<"\\", Bin/binary>>, start, Elements) ->
	parser(Bin, {macro, <<"">>}, Elements);

parser(<<"{", Bin/binary>>, start, Elements) ->
	parser(Bin, {block, <<>>}, Elements);


parser(<<$\n, Bin/binary>>, {comment, State}, Elements) ->
	parser(Bin, State, Elements);

parser(<<_, Bin/binary>>, State = {comment, _}, Elements) ->
	parser(Bin, State, Elements);

parser(<<"%", Bin/binary>>, State, Elements) ->
	parser(Bin, {comment, State}, Elements);


parser(<<"">>, start, Elements) ->
	{ok, Elements};

parser(<<Bin/binary>>, start, Elements) ->
	parser(Bin, {text, <<"">>}, Elements);



parser(<<Letter, Bin/binary>>, {macro, <<Macro/binary>>}, Elements) when Letter >= $a, Letter =< $z ->
	parser(Bin, {macro, <<Macro/binary, Letter>>}, Elements);

parser(<<Bin/binary>>, {macro, <<Macro/binary>>}, Elements) ->
	parser(Bin, start, Elements ++ [{macro, Macro}]);



parser(<<Letter, Bin/binary>>, {block, <<Block/binary>>}, Elements) when Letter == $} ->
	parser(Bin, start, Elements ++ [{block, Block}]);

parser(<<Letter, Bin/binary>>, {block, <<Block/binary>>}, Elements) ->
	parser(Bin, {block, <<Block/binary, Letter>>}, Elements);



parser(Bin = <<Letter, _/binary>>, Text = {text, <<_/binary>>}, Elements) when Letter == $\\ ; Letter == ${ ->
	parser(Bin, start, Elements ++ [Text]);

parser(<<Letter, Bin/binary>>, {text, <<Text/binary>>}, Elements) ->
	parser(Bin, {text, <<Text/binary, Letter>>}, Elements);



parser(Bin, Bob, Elements) ->
	{error, {parsing_failed, Bin, Bob, Elements}}.
