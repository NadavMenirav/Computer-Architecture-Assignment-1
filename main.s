# Nadav Menirav 330845678
.section .data
user_seed:
	.quad 0
random_number:
	.quad 0
user_guess:
	.quad 0
rounds_won:
	.quad 0
is_easy_mode_char:
	.byte 0
space_eater_char:
	.byte 0
is_double_or_nothing_char:
	.byte 0
N:
	.quad 10
M:
	.quad 5

.section .rodata

incorrect_string:
	.string "Incorrect. "
game_over_lost_string:
	.string "Incorrect.\nGame over, you lost :(. The correct answer was %ld\n"
game_over_win_string:
	.string "Congratz! You won %ld rounds!\n"
welcome_string:
	.string "Enter configuration seed: "
easy_mode_string:
	.string "Would you like to play in easy mode? (y/n) "
what_is_your_guess_string:
	.string "What is your guess? "
double_or_nothing_string:
	.string "Double or nothing! Would you like to continue to another round? (y/n) "
lower_string:
	.string "Your guess was below the actual number ...\n"
higher_string:
	.string "Your guess was above the actual number ...\n"
quad_fmt:
	.string "%ld"
char_fmt:
	.string "%c"
y_var:
	.byte 'y'

.section .text
# main function, initiates game
.globl  main
.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp

	# print welcome
	movq	$welcome_string, %rdi
	xorq	%rax, %rax
	call	printf

	# scan seed
	movq	$quad_fmt, %rdi
	leaq	user_seed(%rip), %rsi
	xorq	%rax, %rax
	call	scanf

	# print easy mode
	movq	$easy_mode_string, %rdi
	xorq	%rax, %rax
	call	printf

	# scan redundant space
	xorq	%rax, %rax
	call	scan_space

	# scan easy mode
	movq	$char_fmt, %rdi
	leaq	is_easy_mode_char(%rip), %rsi
	xorq	%rax, %rax
	call	scanf
	# initialize random_number
	call	initialize_random_number

	# start game

	xorq	%rax, %rax
	call	play_game

	# main end
	movq	%rbp, %rsp
	popq	%rbp
	ret

.globl	scan_space
.type	scan_space, @function
scan_space:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	$char_fmt, %rdi
	leaq	space_eater_char(%rip), %rsi
	xorq	%rax, %rax
	call	scanf

	xorq	%rax, %rax
	movq	%rbp, %rsp
	popq	%rbp
	ret

.globl	get_mod_N
.type	get_mod_N, @function
get_mod_N:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, %rax
	xorq	%rdx, %rdx
	divq	N(%rip)
	movq	%rdx, %rax

	movq	%rbp, %rsp
	popq	%rbp
	ret

.globl	get_rand_number_under_N
.type	get_rand_number_under_N, @function
get_rand_number_under_N:
	pushq	%rbp
	movq	%rsp, %rbp

	# creating seed
	movq	user_seed(%rip), %rdi
	xorq	%rax, %rax
	call	srand

	# getting random number
	xorq	%rax, %rax
	call	rand

	# mod N
	movq	%rax, %rdi
	xorq	%rax, %rax
	call	get_mod_N

	# increase by 1
	incq	%rax

	movq	%rbp, %rsp
	popq	%rbp
	ret

.globl	play_game
.type	play_game, @function
play_game:
	pushq	%rbp
	movq	%rsp, %rbp

	game_loop:
		cmpq	$0, M(%rip)
		je		game_over_lose
		jl		game_over_win
		jg		another_guess

	game_over_lose:
		movq	$game_over_lost_string, %rdi
		movq	random_number, %rsi
		call	printf
		jmp		func_end

	game_over_win:
		movq	$game_over_win_string, %rdi
		movq	rounds_won(%rip), %rsi
		call	printf
		jmp		func_end
	another_guess:
		call	play_guess
		jmp		game_loop

	func_end:
		movq	%rbp, %rsp
		popq	%rbp
		ret

.globl	play_guess
.type	play_guess, @function
play_guess:
	pushq	%rbp
	movq	%rsp, %rbp

	# decrease M
	decq	M(%rip)

	# print guess
	movq	$what_is_your_guess_string, %rdi
	xorq	%rax, %rax
	call	printf

	# scan guess
	movq	$quad_fmt, %rdi
	leaq	user_guess(%rip), %rsi
	xorq	%rax, %rax
	call	scanf

	movq	random_number(%rip), %rdi
	movq	user_guess(%rip), %rsi

	cmpq	%rdi, %rsi
	je		equal_case
	jmp		not_equal_case

	equal_case:
		incq	rounds_won
		call	double_or_nothing
		jmp		end_guess

	not_equal_case:
		cmpq	$0, M(%rip)
		je		end_guess
		movq	$incorrect_string, %rdi
		call	printf
		call	easy_mode

	end_guess:
		movq	%rbp, %rsp
		popq	%rbp
		ret

.globl double_or_nothing
.type  double_or_nothing, @function
double_or_nothing:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	$double_or_nothing_string, %rdi
	call	printf

	# scan space
	call	scan_space

	# scan result
	movq	$char_fmt, %rdi
	leaq	is_double_or_nothing_char(%rip), %rsi
	call	scanf

	# compare
	movb	is_double_or_nothing_char(%rip), %al
	cmpb	$'y', %al
	je		isDouble
	jmp		notDouble

	isDouble:
		movq	$5, M(%rip)
		# multiply N

		movq	N(%rip), %rax
		movq	$2, %rbx
		mulq	%rbx
		movq	%rax, N(%rip)

		# multiply seed
		movq	user_seed(%rip), %rax
		movq	$2, %rbx
		mulq	%rbx
		movq	%rax, user_seed(%rip)

		# reinitialize random_number
		call	initialize_random_number
		jmp		end_double_or_nothing
	notDouble:
		movq	$-1, M(%rip)

	end_double_or_nothing:
		movq	%rbp, %rsp
		popq	%rbp
		ret

.globl initialize_random_number
.type  initialize_random_number, @function
initialize_random_number:
	pushq	%rbp
	movq	%rsp, %rbp

	# get random number
	xorq	%rax, %rax
	call	get_rand_number_under_N
	movq	%rax, random_number(%rip)

	xorq	%rax, %rax

	movq	%rbp, %rsp
	popq	%rbp
	ret

.globl	easy_mode
.type	easy_mode, @function
easy_mode:
	pushq	%rbp
	movq	%rsp, %rbp

	movb	is_easy_mode_char(%rip), %al
	cmpb	$'y', %al
	je		is_easy_mode
	jmp 	end_easy_mode

	is_easy_mode:
		movq	random_number(%rip), %rax
		cmpq	user_guess(%rip), %rax
		jg		guessLower
		jl		guessHigher

		guessLower:
			movq	$lower_string, %rdi
			call	printf
			jmp end_easy_mode
		guessHigher:
			movq	$higher_string, %rdi
			call	printf
			jmp end_easy_mode

	end_easy_mode:
		movq	%rbp, %rsp
		popq	%rbp
		ret
