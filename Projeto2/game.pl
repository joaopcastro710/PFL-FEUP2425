% Blackstone implementation in Prolog

:- use_module(library(random)). % Needed to pick a random move
:- use_module(library(lists)). % Needed for some list operations (not many, almost all the operations are custom made)

% Starting "play/0" predicate, calls menu
play :-
    menu(6, n, hh, 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MENU %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose game variant, using cuts for the different options and defaulting to the Main Variant. 
% n - Main Variant, m - Medium Churn Variant, h - High Churn Variant
choose_variant(Variant) :-
    write('Choose game variant (1 for Main Variant, 2 for Medium Churn Variant, 3 for High Churn Variant): '),
    read(Choice),
    choose_variant_choice(Choice, Variant).
choose_variant_choice(1, n) :- !.
choose_variant_choice(2, m) :- !.
choose_variant_choice(3, h) :- !.
choose_variant_choice(_, n) :-
    write('Invalid choice. Defaulting to the Main Variant.'), nl.

% Choose game mode, using cuts for the different options and defaulting to the Human vs Human variant
% hh - Human vs Human, hb - Human vs Bot, bh - Bot vs Human, bb - Bot vs Bot. The order is always Red vs Blue
choose_mode(Mode) :-
    write('Choose game mode (Red vs Blue. 1 for Human vs Human, 2 for Human vs Bot, 3 for Bot vs Human, 4 for Bot vs Bot): '),
    read(Choice),
    choose_mode_choice(Choice, Mode).
choose_mode_choice(1, hh) :- !.
choose_mode_choice(2, hb) :- !.
choose_mode_choice(3, bh) :- !.
choose_mode_choice(4, bb) :- !.
choose_mode_choice(_, hh) :-
    write('Invalid choice. Defaulting to Human vs Human.'), nl.

% Choose difficulty setting for the bot, using cuts for the different options and defaulting to Random
% 1 - Random moves, 2 - Greedy algorithm to pick the best current move according to the evaluation of the position
choose_difficulty(Difficulty) :-
    write('Choose bot difficulty (1 for Random, 2 for Greedy): '),
    read(Choice),
    choose_difficulty_choice(Choice, Difficulty).
choose_difficulty_choice(1, 1) :- !.
choose_difficulty_choice(2, 2) :- !.
choose_difficulty_choice(_, 1) :-
    write('Invalid choice. Defaulting to Random.'), nl.

% Menu function to change settings before starting the game. 
menu(Size, Variant, Mode, Difficulty) :-
    nl, write('--------------- Blackstone Game Menu ---------------'), nl,
    write('1. Change Board Size (current: '), write(Size), write('x'), write(Size), write(')'), nl,
    write('2. Change Variant (current: '),
    display_variant(Variant),
    write(')'), nl,
    write('3. Change Mode (current: '),
    display_mode(Mode),
    write(')'), nl,
    write('4. Change Difficulty (current: '),
    display_difficulty(Difficulty),
    write(')'), nl,
    write('5. Start Game with current settings'), nl, nl,
    write('--------------- Algorithm Matches ---------------'), nl,
    write('6. Watch Greedy vs Random on current settings'), nl,
    write('7. Watch Random vs Greedy on current settings'), nl,
    write('-------------------------------------------------'), nl,
    write('Enter your choice: '),
    read(Choice), nl,
    menu_choice(Choice, Size, Variant, Mode, Difficulty).

menu_choice(1, _, Variant, Mode, Difficulty) :- % Change board size using the read_board_size predicate
    read_board_size(NewSize),
    menu(NewSize, Variant, Mode, Difficulty). %Go back to menu with the new size
menu_choice(2, Size, _, Mode, Difficulty) :-  % Change game variant using the choose_variant predicate
    choose_variant(NewVariant),
    menu(Size, NewVariant, Mode, Difficulty). % Go back to menu with the new variant
menu_choice(3, Size, Variant, _, Difficulty) :- % Change game mode using the choose_mode predicate
    choose_mode(NewMode),
    menu(Size, Variant, NewMode, Difficulty). % Go back to menu with the new mode
menu_choice(4, Size, Variant, Mode, _) :- % Change bot difficulty/mode using the choose_difficulty predicate
    choose_difficulty(NewDifficulty),
    menu(Size, Variant, Mode, NewDifficulty). % Go back to menu with the new difficulty
menu_choice(5, Size, Variant, Mode, Difficulty) :- % Start the game with the current settings
    GameConfig = game_config(Size, Variant, Mode, Difficulty),
    initial_state(GameConfig, GameState), % Generate the initial state using the GameConfig compound term and receive the initial GameState
    play_game(GameState). % Start the game with the initial GameState

menu_choice(6, Size, Variant, _, _) :- % Start the game with the current settings, but with a greedy vs random algorithm match
    GameConfig = game_config(Size, Variant, bb, 3), % Set the difficulty to 3 and Mode to Bot vs Bot
    initial_state(GameConfig, GameState), % Generate the initial state using the GameConfig compound term and receive the initial GameState
    play_game(GameState). % Start the game with the initial GameState
menu_choice(7, Size, Variant, _, _) :- % Start the game with the current settings, but with a random vs greedy algorithm match
    GameConfig = game_config(Size, Variant, bb, 4), % Set the difficulty to 4 and Mode to Bot vs Bot
    initial_state(GameConfig, GameState), % Generate the initial state using the GameConfig compound term and receive the initial GameState
    play_game(GameState). % Start the game with the initial GameState

menu_choice(_, Size, Variant, Mode, Difficulty) :- % Invalid choice, go back to the menu
    write('Invalid choice. Try again.'), nl,
    menu(Size, Variant, Mode, Difficulty).

% Helper to display the current variant
display_variant(h) :- !, write('High Churn Variant').
display_variant(m) :- !, write('Medium Churn Variant').
display_variant(n) :- write('Main Variant').

% Helper to display the current mode
display_mode(hh) :- !, write('Human vs Human').
display_mode(hb) :- !, write('Human vs Bot').
display_mode(bh) :- !, write('Bot vs Human').
display_mode(bb) :- write('Bot vs Bot').

% Helper to display the current difficulty
display_difficulty(1) :- !, write('Random').
display_difficulty(2) :- write('Greedy').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIAL STATE AND GAMECONFIG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Initial Board Setup ---
% Board is represented as a list of rows, each row is a list of cells.
% Cells are 'r' (Red), 'b' (Blue), 'n' (Neutral/Empty), or 'x' (Black).

% Define the initial Game State
initial_state(GameConfig, GameState) :-
    GameConfig = game_config(Size, Variant, Mode, Difficulty),
    generate_board(Size, Board),
    GameState = game_state(Board, Variant, Mode, r, Difficulty).

% Read the board size from the menu
read_board_size(Size) :-
    write('Enter the size of the board (even number higher than 6, e.g., 6 for a 6x6 board): '),
    read(InputSize),
    integer(InputSize),
    InputSize > 5,
    InputSize mod 2 =:= 0,
    Size = InputSize.

% Generate the board for the initial setup
generate_board(Size, Board) :-
    generate_rows(Size, Size, TempBoard), % Generate the board with the specified size but top left as (1,1).
    reverse_list(TempBoard, Board). % Reverse the board to have the bottom left corner as (1,1).

% Generate the rows of the board, calls generate_row for each row, R works as a counter for how many rows are left
generate_rows(0, _, []).
generate_rows(R, Size, [Row|Rows]) :-
    R > 0,
    generate_row(R, Size, Row),
    NextR is R - 1,
    generate_rows(NextR, Size, Rows).

% Generate a row of the board
generate_row(RowNum, Size, Row) :-
    findall(Cell, (between(1, Size, ColNum), generate_cell(RowNum, ColNum, Size, Cell)), Row).

% Generate a single cell based on the row and column number, according to the board setup given for the game
generate_cell(RowNum, ColNum, Size, r) :-
    RowNum =:= 1,
    ColNum mod 2 =:= 0,
    ColNum =< Size - 2,
    !.
generate_cell(RowNum, ColNum, Size, r) :-
    RowNum =:= Size,
    ColNum mod 2 =:= 1,
    ColNum >= 3,
    !.
generate_cell(RowNum, ColNum, _, b) :-
    ColNum =:= 1,
    RowNum mod 2 =:= 1,
    RowNum >= 3,
    !.
generate_cell(RowNum, ColNum, Size, b) :-
    ColNum =:= Size,
    RowNum mod 2 =:= 0,
    RowNum =< Size - 2,
    !.
generate_cell(_, _, _, n).
    

% Helper function to reverse a list
reverse_list([], []).
reverse_list([H|T], Reversed) :-
    reverse_list(T, ReversedT),
    append(ReversedT, [H], Reversed).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% VISUAL GAME LOGIC AND MAIN LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pass the turn to the next player, from red to blue or vice-versa
next_player(r, b).
next_player(b, r).

% --- Text-Based Visualization ---
% Display the board in the terminal.
display_game(GameState) :-
    GameState = game_state(Board, _, _, Player, _),
    nl, write('-- Current Board --'), nl, nl,
    maplist(display_row, Board), nl,
    write('Player on the Board: '),
    display_player(Player), nl,
    nl.

% Helper to display the player color
display_player(b) :-
    !, write('Blue').
display_player(r) :-
    write('Red').
  
% Display a single row of the board
display_row(Row) :-
    maplist(display_cell, Row),
    nl.
  
% Display a single cell of the board according to the characters we attributed to the pieces in line 103
display_cell(r) :- write('R').
display_cell(b) :- write('B').
display_cell(n) :- write('.').
display_cell(x) :- write('X').

% --- Main ---
% Main game loop.
play_game(GameState) :-
    GameState = game_state(_, Variant, Mode, Player, Difficulty), % Unpack the GameState
    display_game(GameState), % Display the current game state
    choose_move(GameState, Difficulty, Move), % Choose a move based on the current game state, either Human or Bot
    move(GameState, Move, NewGameState), % Make the move
    !, % Cut to prevent changes to the GameState if the move is invalid
    NewGameState = game_state(NewBoard, _, _, _, _), % Pack the new game state
    remove_surrounded_pieces(NewBoard, FinalBoard, Variant, yes), % Remove surrounded pieces from the board if appliable
    handle_game_over(FinalBoard, Player, Variant, Mode, Difficulty). % Check if the game is over and handle the outcome
play_game(GameState) :-
    write('Invalid move. Try again.'), nl,
    play_game(GameState).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MOVE LOGIC AND VALIDATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Move Validation ---
% Valid move: A piece can move like a chess queen to an empty spot, leaving behind a black stone.
valid_move(Board, Player, StartRow, StartCol, EndRow, EndCol) :-
    get_cell(Board, StartRow, StartCol, Player),  % Start cell must contain the player's piece
    get_cell(Board, EndRow, EndCol, n),          % Destination must be empty
    queen_path_clear(Board, StartRow, StartCol, EndRow, EndCol). % Path must be clear

% --- Valid Moves ---
% Find all valid moves for a player on a given board.
valid_moves(GameState, ListOfMoves) :-
    GameState = game_state(Board, _, _, Player, _),
    length(Board,Size), % Get the size of the board
    findall([StartRow, StartCol, EndRow, EndCol], % Find all possible moves using the between predicate and filter through the valid ones for the player
            (between(1, Size, StartRow),
             between(1, Size, StartCol),
             between(1, Size, EndRow),
             between(1, Size, EndCol),
             valid_move(Board, Player, StartRow, StartCol, EndRow, EndCol)),
            ListOfMoves).

% Helper function to generate all numbers between Low and High.
between(Low, High, Low) :-
    Low =< High.
between(Low, High, Value) :-
    Low < High,
    NextLow is Low + 1,
    between(NextLow, High, Value).

% Check if the path of a Chess queen is clear between two points.
queen_path_clear(Board, R1, C1, R2, C2) :-
    direction(R1, C1, R2, C2, DR, DC), % Get the direction of the move
    path_clear(Board, R1, C1, DR, DC, R2, C2). % Check if the path is clear

% Define movement direction.
% Clause for diagonal movement
direction(R1, C1, R2, C2, DR, DC) :-
    DR is R2 - R1,
    DC is C2 - C1,
    abs(DR) =:= abs(DC),
    DR \== 0,
    !.
% Clause for vertical movement
direction(R1, _, R2, _, DR, 0) :-
    DR is R2 - R1,
    DR \== 0,
    !.
% Clause for horizontal movement
direction(_, C1, _, C2, 0, DC) :-
    DC is C2 - C1,
    DC \== 0.
% Ensure all cells along the path are empty.
path_clear(_, R, C, _, _, R, C).
path_clear(Board, R1, C1, DR, DC, R2, C2) :-
    sign(DR, SignR),
    sign(DC, SignC),
    NextR is R1 + SignR,
    NextC is C1 + SignC,
    get_cell(Board, NextR, NextC, n),
    path_clear(Board, NextR, NextC, DR, DC, R2, C2).

% Helper for direction signs, simply checks if a number is negative or not to determine which way it is pointing, like a 2d arrow.
% We then follow the trail built by the cells to which the arrow is pointing and check if they are empty
sign(X, Sign) :- X > 0, !, Sign = 1.
sign(X, Sign) :- X < 0, !, Sign = -1.
sign(0, 0).

% --- Perform a Move ---
% Move a stone and place a black stone on its place.
move(GameState, Move, NewGameState) :-
    GameState = game_state(Board, _, _, Player, _),
    Move = board_move(StartRow, StartCol, EndRow, EndCol), % Unpack the gamestate and the move
    valid_move(Board, Player, StartRow, StartCol, EndRow, EndCol), % Check if the move is valid
    replace_cell(Board, StartRow, StartCol, x, TempBoard),  % Place black stone at origin
    replace_cell(TempBoard, EndRow, EndCol, Player, NewBoard), % Move player piece to destination
    NewGameState = game_state(NewBoard, _, _, Player, _). % Pack the new game state

% --- Cell Access ---
% Get the value of a cell in the board.
get_cell(Board, Row, Col, Value) :-
    length(Board, Size),
    AdjRow is Size - Row + 1,
    nth1(AdjRow, Board, CurrentRow), % Get the row
    nth1(Col, CurrentRow, Value). % Get the column

% Replace the value in a cell of the board.
replace_cell(Board, Row, Col, Value, NewBoard) :-
    length(Board, Size),
    AdjRow is Size - Row + 1, % Adjust the row to match the board
    nth1(AdjRow, Board, CurrentRow), % Get the row
    replace_in_list(CurrentRow, Col, Value, NewRow), % Replace the value in the row
    replace_in_list(Board, AdjRow, NewRow, NewBoard). % Replace the row in the board
  
% Helper function to replace an element in a list.
replace_in_list([_|T], 1, Value, [Value|T]).
replace_in_list([H|T], Pos, Value, [H|NewT]) :-
    Pos > 1,
    NextPos is Pos - 1,
    replace_in_list(T, NextPos, Value, NewT).
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SURROUNDS AND REMOVAL OF PIECES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Redefine directions for queen movement, allows to quickly check for trapped pieces, we chose to define this predicate instead of adapting the previous direction predicate
% The trapped_direction predicate is used to check if a piece can move in a any direction, if it can, it is not trapped.
% Clause for upward movement
trapped_direction(Row, Col, R, C, -1, 0) :-
    R is Row - 1,
    C is Col.
% Clause for downward movement
trapped_direction(Row, Col, R, C, 1, 0) :-
    R is Row + 1,
    C is Col.
% Clause for leftward movement
trapped_direction(Row, Col, R, C, 0, -1) :-
    R is Row,
    C is Col - 1.
% Clause for rightward movement
trapped_direction(Row, Col, R, C, 0, 1) :-
    R is Row,
    C is Col + 1.
% Clause for upward-left diagonal movement
trapped_direction(Row, Col, R, C, -1, -1) :-
    R is Row - 1,
    C is Col - 1.
% Clause for upward-right diagonal movement
trapped_direction(Row, Col, R, C, -1, 1) :-
    R is Row - 1,
    C is Col + 1.
% Clause for downward-left diagonal movement
trapped_direction(Row, Col, R, C, 1, -1) :-
    R is Row + 1,
    C is Col - 1.
% Clause for downward-right diagonal movement
trapped_direction(Row, Col, R, C, 1, 1) :-
    R is Row + 1,
    C is Col + 1.

% Similar function to queen_path_clear in theory, but checks if a piece can move in any direction, instead of checking if it can follow a trail.
queen_can_move(Board, Row, Col) :-
    trapped_direction(Row, Col, R, C, _, _),
    get_cell(Board, R, C, n).

% Check if a piece is surrounded 
piece_surrounded(Board, Row, Col) :-
    get_cell(Board, Row, Col, Piece), % Get the piece at the current position
    member(Piece, [r, b]), % Check if the piece is a player piece
    !,
    \+ queen_can_move(Board, Row, Col). % Check if the piece can move in any direction
piece_surrounded(_, _, _) :-
    fail. 

% Remove surrounded pieces from the board in the different variants. Code has been doubled simply to improve readability while playing, allowing printing the eliminated pieces only when a move has been made and not every time a candidate move is evaluated.
remove_surrounded_pieces(Board, NewBoard, n, yes) :-
    length(Board, Size), % Get the size of the board
    findall([R, C], (between(1, Size, R), between(1, Size, C), piece_surrounded(Board, R, C)), SurroundedPieces),  % Find all surrounded pieces
    write('Eliminated surrounded pieces: '), write(SurroundedPieces), nl, % Print the list of eliminated pieces
    !,
    remove_pieces(Board, SurroundedPieces, NewBoard). % Remove the surrounded pieces from the board, repeat predicate for all combinations of variants/printing option
remove_surrounded_pieces(Board, NewBoard, n, no) :-
    length(Board, Size),
    findall([R, C], (between(1, Size, R), between(1, Size, C), piece_surrounded(Board, R, C)), SurroundedPieces),
    !,
    remove_pieces(Board, SurroundedPieces, NewBoard).
remove_surrounded_pieces(Board, NewBoard, m, yes) :-
    length(Board, Size),
    findall([R, C], (between(1, Size, R), between(1, Size, C), piece_surrounded(Board, R, C)), SurroundedPieces),
    write('Eliminated surrounded pieces (variant m): '), write(SurroundedPieces), nl,
    findall([BR, BC], (member([SR, SC], SurroundedPieces), between(1, Size, BR), between(1, Size, BC), adjacent_black_pieces(Board, SR, SC, BR, BC)), BlackPieces),
    write('Eliminated black pieces (variant m): '), write(BlackPieces), nl,
    !,
    append(SurroundedPieces, BlackPieces, AllPieces),
    remove_pieces(Board, AllPieces, NewBoard).
remove_surrounded_pieces(Board, NewBoard, m, no) :-
    length(Board, Size),
    findall([R, C], (between(1, Size, R), between(1, Size, C), piece_surrounded(Board, R, C)), SurroundedPieces),
    findall([BR, BC], (member([SR, SC], SurroundedPieces), between(1, Size, BR), between(1, Size, BC), adjacent_black_pieces(Board, SR, SC, BR, BC)), BlackPieces),
    !,
    append(SurroundedPieces, BlackPieces, AllPieces),
    remove_pieces(Board, AllPieces, NewBoard).
remove_surrounded_pieces(Board, NewBoard, h, yes) :-
    length(Board, Size),
    findall([R, C], (between(1, Size, R), between(1, Size, C), piece_surrounded(Board, R, C)), SurroundedPieces),
    write('Eliminated surrounded pieces (variant h): '), write(SurroundedPieces), nl,
    SurroundedPieces \== [],
    !,
    findall([R, C], (between(1, Size, R), between(1, Size, C), get_cell(Board, R, C, x)), BlackPieces),
    write('Eliminated all black pieces (variant h): '), write(BlackPieces), nl,
    append(SurroundedPieces, BlackPieces, AllPieces),
    remove_pieces(Board, AllPieces, NewBoard).
remove_surrounded_pieces(Board, NewBoard, h, yes) :-
    length(Board, Size),
    findall([R, C], (between(1, Size, R), between(1, Size, C), piece_surrounded(Board, R, C)), SurroundedPieces),
    write('Eliminated surrounded pieces (variant h): '), write(SurroundedPieces), nl,
    SurroundedPieces = [],
    !,
    NewBoard = Board.
remove_surrounded_pieces(Board, NewBoard, h, no) :-
    length(Board, Size),
    findall([R, C], (between(1, Size, R), between(1, Size, C), piece_surrounded(Board, R, C)), SurroundedPieces),
    SurroundedPieces \== [],
    !,
    findall([R, C], (between(1, Size, R), between(1, Size, C), get_cell(Board, R, C, x)), BlackPieces),
    append(SurroundedPieces, BlackPieces, AllPieces),
    remove_pieces(Board, AllPieces, NewBoard).
remove_surrounded_pieces(Board, NewBoard, h, no) :-
    length(Board, Size),
    findall([R, C], (between(1, Size, R), between(1, Size, C), piece_surrounded(Board, R, C)), SurroundedPieces),
    SurroundedPieces = [],
    !,
    NewBoard = Board.

% Find adjacent black pieces
adjacent_black_pieces(Board, Row, Col, R, C) :-
    trapped_direction(Row, Col, R, C, _, _), 
    get_cell(Board, R, C, x). 

% Remove a list of pieces from the board
remove_pieces(Board, [], Board).
remove_pieces(Board, [[R, C]|Rest], NewBoard) :-
    replace_cell(Board, R, C, n, TempBoard), % Replace the piece with an empty cell
    remove_pieces(TempBoard, Rest, NewBoard). % Recursively remove the rest of the pieces

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GAME OVER AND MOVE MAKING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check for all game over conditions.
game_over(game_state(Board, _, _, _LastPlayer, _), red) :- % Check if the game is over and blue has no pieces left
    \+ (member(Row, Board), member(b, Row)),
    !.
game_over(game_state(Board, _, _, _LastPlayer, _), blue) :- % Check if the game is over and red has no pieces left
    \+ (member(Row, Board), member(r, Row)),
    !.
game_over(game_state(Board, _, _, LastPlayer, _), LastPlayer) :- % Check if the game is over for both players, in which case the last player won
    \+ (member(Row, Board), member(r, Row)),
    \+ (member(Row, Board), member(b, Row)),
    !.

% Handle the game over logic
% If the game is over, display the winner and save the game status
handle_game_over(FinalBoard, Player, Variant, Mode, Difficulty) :-
    GameState = game_state(FinalBoard, Variant, Mode, Player, Difficulty),
    write('Checking game over...'), nl,
    game_over(GameState, Winner),
    !,
    handle_winner(FinalBoard, Winner, Player, Variant, Mode, Difficulty).
% If the game is not over, pass the turn to the next player and continue the game
handle_game_over(FinalBoard, Player, Variant, Mode, Difficulty) :-
    next_player(Player, NextPlayer),
    NewGameState = game_state(FinalBoard, Variant, Mode, NextPlayer, Difficulty),
    play_game(NewGameState).

%Handle the game winner and print the outcome
% Handle the case where there is no winner yet, continue the game with the next player
handle_winner(FinalBoard, none, Player, Variant, Mode, Difficulty) :-
    !,
    next_player(Player, NextPlayer),
    NewGameState = game_state(FinalBoard, Variant, Mode, NextPlayer, Difficulty),
    play_game(NewGameState).
% Handle the case where there is a winner, save the game result and display the final board
handle_winner(FinalBoard, Winner, _, Variant, Mode, Difficulty) :-
    FinalGameState = game_state(FinalBoard, Variant, Mode, Winner, Difficulty),
    save_game_status(FinalGameState, 'last_game_result.txt'), % Save the game result to a file
    nl,
    write('Winner: '), write(Winner), nl, nl, write('-- Final Board --'), nl,
    maplist(display_row, FinalBoard),
    write('-----Game Over-----'), nl.

% Choose a move for the bot using evaluation functions.
choose_move(GameState, Level, Move) :- % Level is the same as difficulty, just changed to match the specs in the project description
    GameState = game_state(Board, Variant, Mode, Player, _),
    is_bot_mode(Mode, Player), % Check if the current player is a bot
    !,
    bot_choose_move(Board, Variant, Player, Level, StartRow, StartCol, EndRow, EndCol), % Choose a move for the bot if it is indeed a bot
    Move = board_move(StartRow, StartCol, EndRow, EndCol). % Pack the move
choose_move(_, _, Move) :-
    human_choose_move(StartRow, StartCol, EndRow, EndCol), % Choose a move for the human if the current player is not a bot
    Move = board_move(StartRow, StartCol, EndRow, EndCol). % Pack the move

% Check if the current mode and player indicate a bot
is_bot_mode(hb, b) :- !.
is_bot_mode(bh, r) :- !.
is_bot_mode(bb, _).

% Display an explanation of the evaluation value.
% The evaluation value is a number that represents the bot's evaluation of the current position.
% The higher the value, the better the position for the bot.
% If value is 0, the bot thinks the position is equal, 0-0.6 is slightly better, 0.6-2 is better, 2+ much better and the reverse with negative values.
display_value_explanation(Value) :-
    Value >= -0.01,
    Value =< 0.01,
    !,
    write('Bot thinks its position is equal').
display_value_explanation(Value) :-
    Value > 0,
    Value < 0.6,
    !,
    write('Bot thinks its position is slightly better').
display_value_explanation(Value) :-
    Value >= 0.6,
    Value < 2,
    !,
    write('Bot thinks its position is better').
display_value_explanation(Value) :-
    Value >= 2,
    !,
    write('Bot thinks its position is much better').
display_value_explanation(Value) :-
    Value < 0,
    Value > -0.6,
    !,
    write('Bot thinks its position is slightly worse').
display_value_explanation(Value) :-
    Value =< -0.6,
    Value > -2,
    !,
    write('Bot thinks its position is worse').
display_value_explanation(Value) :-
    Value =< -2,
    !,
    write('Bot thinks its position is much worse').

% Handle bot move
bot_choose_move(Board, Variant, Player, Difficulty, StartRow, StartCol, EndRow, EndCol) :-
    write('Bot '),
    display_player(Player),
    write(' is evaluating the position...'), nl,
    GameState = game_state(Board, Variant, _, Player, _), % Create a game state from the board
    valid_moves(GameState, Moves), % Get all valid moves
    value(GameState, Player, Value), % Evaluate the current position
    write('Current Bot '),
    display_player(Player),
    write(' Position Evaluation: '),
    write(Value), nl,
    display_value_explanation(Value), nl, % Display the evaluation explanation
    select_bot_move(Difficulty, Moves, Board, Player, Variant, StartRow, StartCol, EndRow, EndCol), % Select the bot's move based on the difficulty setting (1-Random, 2-Greedy)
    write('Bot played a move.'), nl, nl.

% Select the bot's move based on difficulty
select_bot_move(1, Moves, _, _, _, StartRow, StartCol, EndRow, EndCol) :- % If difficulty seting is set to Random
    random_member([StartRow, StartCol, EndRow, EndCol], Moves), % Randomly select a move from the list of valid moves
    !.
select_bot_move(2, Moves, Board, Player, Variant, StartRow, StartCol, EndRow, EndCol) :- % If difficulty setting is set to Greedy
    best_move(Board, Player, Variant, Moves, StartRow, StartCol, EndRow, EndCol), % Select the best current move based on the evaluation function
    !.
select_bot_move(3, Moves, Board, Player, Variant, StartRow, StartCol, EndRow, EndCol) :- % If difficulty setting is 3, it means we are watching a greedy algorithm vs random algorithm match, so each color uses a different algorithm
    Player = r, !,
    best_move(Board, Player, Variant, Moves, StartRow, StartCol, EndRow, EndCol). % If the player is red, use the greedy algorithm
select_bot_move(3, Moves, _, Player, _, StartRow, StartCol, EndRow, EndCol) :-
    Player = b, !,
    random_member([StartRow, StartCol, EndRow, EndCol], Moves). % If the player is blue, use the random algorithm
select_bot_move(4, Moves, Board, Player, Variant, StartRow, StartCol, EndRow, EndCol) :- % If difficulty setting is 4, it means we are watching a random algorithm vs greedy algorithm match, so each color uses a different algorithm
    Player = b, !,
    best_move(Board, Player, Variant, Moves, StartRow, StartCol, EndRow, EndCol). % If the player is blue, use the greedy algorithm
select_bot_move(4, Moves, _, Player, _, StartRow, StartCol, EndRow, EndCol) :-
    Player = r, !,
    random_member([StartRow, StartCol, EndRow, EndCol], Moves). % If the player is red, use the random algorithm

% Read human move
human_choose_move(StartRow, StartCol, EndRow, EndCol) :- 
    write('Enter StartRow '), read(StartRow),
    write('Enter StartCol '), read(StartCol),
    write('Enter EndRow '), read(EndRow),
    write('Enter EndCol '), read(EndCol).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EVALUATION FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Value function to evaluate the board state for the current player. The higher the value the better the position.
% There is a lot to be said about this function, the evaluation takes into account the amount of pieces both players have, each piece is worth 1 point.
% The amount of moves the player can make is also taken into account, the more moves the better the position.
% For every extra move the player can make in comparison with the opponent, the player gets a higher amount of points.
% This makes the bot aware, not only of possibly trapped enemy pieces, but also improvements to the amount of moves it can make, as well as moves that restrict the opponent.
% For every variant the evaluation is different. For Higher churn variants, the amount of moves is not as important
% Due to the fact that black pieces are removed along with trapped pieces in these variants, the board gets freer and the amount of moves one can make tends to increase after a piece gets trapped.
% For the Normal Variant however, the amount of moves available is very important, as the board gets more and more cluttered with black pieces, the amount of moves decreases constantly.
% For this reason, sometimes the bot may choose to make a not-so-obvious move, that does not immediately trap an enemy piece, as it surely increases the amount of moves it can make in the following move, or restrict the opponent's.
% The values chosen to evaluate the amount of moves available are semi-arbitrary, the evaluation has been tested with several values, but these were found to make for a challenging bot, still beatable by a human player.
% The bot is noticeably stronger in the Main Variant, as it doesn't grasp the concept of predicting clearances on the board after one of their own pieces gets trapped in higher churn variants.
value(GameState, Player, Value) :-
    GameState = game_state(Board, Variant, _, _, _), % Unpack the game state
    length(Board, Size), % Get the size of the board
    findall([R, C], (between(1, Size, R), between(1, Size, C), get_cell(Board, R, C, Player)), PlayerPieces), % Find all player pieces
    length(PlayerPieces, PlayerValue), % Get the amount of player pieces
    next_player(Player, Opponent), % Pass to the opponent
    findall([R, C], (between(1, Size, R), between(1, Size, C), get_cell(Board, R, C, Opponent)), OpponentPieces), % Find all opponent pieces
    length(OpponentPieces, OpponentValue), % Get the amount of opponent pieces
    CGameState = game_state(Board, Variant, _, Player, _), % Create a game state for the current player
    valid_moves(CGameState, Moves), % Get all valid moves for the current player
    length(Moves, NumMoves), % Get the amount of moves the player can make
    OGameState = game_state(Board, Variant, _, Opponent, _), % Create a game state for the opponent
    valid_moves(OGameState, OpponentMoves), % Get all valid moves for the opponent
    length(OpponentMoves, OpponentNumMoves), % Get the amount of moves the opponent can make
    value_variant(Variant, PlayerValue, OpponentValue, NumMoves, OpponentNumMoves, Value). % Calculate the value based on the data selected and the variant

% Predicate that actually calculates the value.
value_variant(h, PlayerValue, OpponentValue, NumMoves, OpponentNumMoves, Value) :-
    !,
    Value is floor((PlayerValue - OpponentValue + 0.03 * NumMoves - 0.03 * OpponentNumMoves) * 100) / 100. % We use floor/1 to help round the value to 2 decimal places due to prolog's funky floating point arithmetic
value_variant(m, PlayerValue, OpponentValue, NumMoves, OpponentNumMoves, Value) :-
    !,
    Value is floor((PlayerValue - OpponentValue + 0.06 * NumMoves - 0.06 * OpponentNumMoves) * 100) / 100.
value_variant(n, PlayerValue, OpponentValue, NumMoves, OpponentNumMoves, Value) :-
    Value is floor((PlayerValue - OpponentValue + 0.1 * NumMoves - 0.1 * OpponentNumMoves) * 100) / 100.

% Greedy function to find the best move for the bot in the current position by evaluating all possible moves according to the evaluation function.
best_move(Board, Player, Variant, Moves, BestStartRow, BestStartCol, BestEndRow, BestEndCol) :-
    write('Bot '),
    display_player(Player),
    write(' is finding the best move...'), nl,
    findall(Value-Move, generate_move_values(Moves, Board, Player, Variant, Value, Move), MoveValues), % Generate all the move values by calling the generate_move_values predicate for all the moves
    keysort(MoveValues, SortedMoveValues), % Sort the move values in ascending order
    extract_best_move(SortedMoveValues, BestMove), % Extract the best move from the sorted list
    BestMove = [BestStartRow, BestStartCol, BestEndRow, BestEndCol].

% Helper to generate move values
generate_move_values(Moves, Board, Player, Variant, Value, Move) :-
    member(Move, Moves), % Get a move from the list of moves
    evaluate_move(Board, Player, Variant, Move, Value). % Evaluate the move

% Extract the best move from the sorted list
extract_best_move([_-Move], Move) :- 
    !. % Cut to prevent backtracking once the best move is found
extract_best_move([_|Tail], BestMove) :-
    extract_best_move(Tail, BestMove). % Recursively extract the tail value, which is the greatest

% Evaluate a move by making the move and calculating the resulting board evaluation.
evaluate_move(Board, Player, Variant, [StartRow, StartCol, EndRow, EndCol], Value) :-
    GameState = game_state(Board, _, _, Player, _), % Create a game state from the board
    Move = board_move(StartRow, StartCol, EndRow, EndCol), % Create a move from the coordinates
    move(GameState, Move, NewGameState), % Make the move
    NewGameState = game_state(NewBoard, _, _, _, _), % Pack the new game state with the board in which the move was made
    remove_surrounded_pieces(NewBoard, FinalBoard, Variant, no), % Remove surrounded pieces from the new board and get the final board
    MoveGameState = game_state(FinalBoard, Variant, _, _, _), % Create a game state for the final board
    value(MoveGameState, Player, Value). % Evaluate the final board

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SAVING GAME RESULT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save the game result and configuration to a text file.
save_game_status(GameState, FileName) :-
    open(FileName, write, Stream), % Open the file in write mode
    write(Stream, 'Last Game Results:'), nl(Stream),
    write_game_status(Stream, GameState), % Write the game status to the stream
    close(Stream). % Close the file

% Write the game status to the stream.
write_game_status(Stream, game_state(Board, Variant, Mode, Player, Difficulty)) :- % Write all the game status values to the stream
    write(Stream, '-- Final Board --'), nl(Stream),
    write_board(Stream, Board), % Write the board to the stream
    write(Stream, 'Variant: '), write(Stream, Variant), nl(Stream),
    write(Stream, 'Mode: '), write(Stream, Mode), nl(Stream),
    write(Stream, 'Winner: '), write(Stream, Player), nl(Stream),
    write(Stream, 'Difficulty: '), write(Stream, Difficulty), nl(Stream).

% Write the board to the stream.
write_board(_, []).  % Base case for the recursion
write_board(Stream, [Row|Rows]) :- % Write each row of the board to the stream
    write(Stream, Row), nl(Stream),
    write_board(Stream, Rows).