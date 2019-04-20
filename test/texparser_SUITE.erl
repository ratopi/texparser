%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2019, Ralf Thomas Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 13:43
%%%-------------------------------------------------------------------
-module(texparser_SUITE).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

-include_lib("common_test/include/ct.hrl").

%% API
-export([init_per_suite/1, end_per_suite/1, init_per_testcase/2, end_per_testcase/2, all/0]).
-export([parse/1]).

all() -> [
	parse
].

% ---

init_per_suite(Config) ->
	Config.

end_per_suite(_Config) ->
	ok.

init_per_testcase(_, Config) ->
	Config.

end_per_testcase(_, _Config) ->
	ok.

% ---

parse(_Config) ->
	{
		ok,
		[
			{macro, <<"macro">>},
			{block, <<"Arg1">>},
			{block, <<"Arg2">>}
		]
	} = texparser:parser(<<"\\macro{Arg1}{Arg2}">>),

	{
		ok,
		[
			{macro, <<"begin">>},
			{block, <<"document">>},
			{text, <<"This is a test">>},
			{macro, <<"end">>},
			{block, <<"document">>}
		]
	} = texparser:parser(<<"\\begin{document}This is a test\\end{document}">>).
