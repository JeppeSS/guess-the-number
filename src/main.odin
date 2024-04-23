package main

import "core:fmt"
import "core:log"

import "core:math/rand"
import "core:os"
import "core:strconv"
import "core:strings"

import term "terminal"

Game_Event :: enum u8 {
    Event_Guess_To_High,
    Event_Guess_To_Low,
    Event_Guess_Correct,
    Event_Invalid_Input
}


play_round :: proc(number_to_guess: i32) -> Game_Event {
    term.write_at( 10, 10, "Please enter a guess: " )
    guess, is_valid := get_user_input()
    if !is_valid 
    {
        return .Event_Invalid_Input
    }

    if guess < number_to_guess
    {
        return .Event_Guess_To_Low
    }
    else if guess > number_to_guess
    {
        return .Event_Guess_To_High
    }
    else
    {
        return .Event_Guess_Correct
    }
}



run_game :: proc() {
    number_to_guess  := rand.int31_max(20)

    max_attempts  := 3
    attempts_used := 0

    for ; attempts_used < max_attempts;
    {
        game_event := play_round(number_to_guess)
        switch game_event
        {
            case .Event_Invalid_Input:
                fmt.println("Invalid input, you're guess should be a number between 0 - 20")
            case .Event_Guess_To_High:
                fmt.println("You're guess was to high!")
                attempts_used += 1
            case .Event_Guess_To_Low:
                fmt.println("You're guess was to low!")
                attempts_used += 1
            case .Event_Guess_Correct:
                fmt.println("You guessed correctly!")
                return
        }

        if attempts_used < max_attempts
        {
            fmt.println("Try again!")
        }
    }

    fmt.println("Unfourunaly you used all you're guesses!")
}


get_user_input :: proc() -> (guess: i32, is_valid: bool) {
    input_buffer: [8]byte
    total_read, read_error := os.read(os.stdin, input_buffer[:])
    if read_error < 0
    {
        return -1, false
    }

    string_input    := string(input_buffer[:total_read])
    sanatized_input := strings.trim(string_input, "\r\n ")

    value, is_numeric := strconv.parse_int(sanatized_input)
    if !is_numeric
    {
        return -1, false
    }

    return i32(value), true
}

main :: proc() {
    
    handle, handle_error := os.open("game.log", os.O_WRONLY | os.O_CREATE )
    if handle_error != os.ERROR_NONE {
        fmt.printfln( "Failed to open file: %d", handle_error )
        return
    }

    context.logger = log.create_file_logger(handle, opt = log.Full_Timestamp_Opts | log.Options{ .Level })


    p_terminal := term.create_terminal()
    defer term.destroy_terminal(p_terminal)

    term.hide_cursor()

    run_game()
}