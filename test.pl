% prolog filetype
%
% use_module(library(clpfd)).

совместимо(курица, брокколи).

% math
natural(1).
natural(N) :-
    natural(N0),
    N is N0 + 1.

range(Min, _, Min). % возвращает генератор для указанного ренжа
range(Min, Max, Val) :- NewMin is Min+1, Max >= NewMin, range(NewMin, Max, Val).

natural(A,B) :-
	natural(N), N >= 2,
	LimitA is N - 1, range(1,LimitA,A),
	B is N - A.

natural(A,B,C) :-
	natural(N), N >= 3,
	LimitA is N - 2,     range(1,LimitA,A),
	LimitB is N - 1 - A, range(1,LimitB,B),
	C is N - A - B.

% В условиях покоя и комфортной температуры уровень энергетических затрат взрослого человека
% составляет от 1300 до 1900 ккал в сутки, что соответствует основному обмену.
%	Основной обмен соответствует 1 ккал на 1 кг массы тела в 1 час.
basic_exchange(Z, Y, X) :- % Z - кол-во ккал, Y\X - масса, кол-во часов
	natural(X,Y),
	Z is Y * X, !. % у задачи единственный ответ

% Основной энергетический материал дают организму жиры, белки и углеводы.
% Считают, что 1 г белков пищи обеспечивает организму 4.1 ккал (17.17 кДж)
%			   1 г жиров - 9.3 ккал (38.96 кДж)
%			   1 г углеводов - 4.1 ккал (17.17 кДж)
basic_material(Kkal, Protein, Fat, Carbohydr) :-
	natural(Kkal),
	write("Kkal "), write(Kkal), write("\n"),
	Max_grams is Kkal // 3, % больше этой граммовки суммарно точно не должно выйти
	range(1, Max_grams,                 Protein),
	write("Protein "), write(Protein), write("\n"),
	range(1, Max_grams - Protein,       Fat),
	write("Fat "), write(Fat), write("\n"),
	range(1, Max_grams - Protein - Fat, Carbohydr),
	write("Carbohydr "), write(Carbohydr), write("\n"),
	Summ is (Protein * 4.1) + (Fat * 9.3) + (Carbohydr * 4.1),
	Kkal > Summ - 10, Kkal < Summ + 10.

bm(Kkal, Protein) :-
	natural(Kkal), !,
	write("Kkal: "), write(Kkal), write("\n"),
	range(1, Kkal, Protein),
	write("Protein: "), write(Protein), write("\n"),
	Summ is Protein * 4.1,
	write("Summ: "), write(Summ), write("\n"),
	Kkal > Summ - 10,
	Kkal < Summ + 10.
	

% Человек нуждается не в каких-либо продуктах, а в определенном соотношении
% содержащихся в них пищевых веществ: в одни продуктах могут преобладать незаменимые
% (эссенциальные) аминокислоты, в других - незаменимые (эссенциальные) жирные кислоты

out_solution(Stream, Белки, Жиры, Углеводы) :-
	write(Stream, "Белки: "),    write(Stream, Белки),
	write(Stream, "Жиры: "),     write(Stream, Жиры),
	write(Stream, "Углеводы: "), write(Stream, Углеводы),
	write(Stream, "\n").


main :-
    open('out.txt',write,Stream),
	write("Calculate basic exchange\n"),
	basic_exchange(X, 80, 24),
	write("Calc solutions to basic material\n"),
    forall(basic_material(X, Белки, Жиры, Углеводы), out_solution(Stream, Белки,Жиры,Углеводы)),
	write("Close stream\n"),
    close(Stream).
