package terminal

import "core:fmt"

create_terminal :: proc() -> ^Terminal
{
    p_terminal := new( Terminal )

    _initialize_os_specific( p_terminal )

    return p_terminal
}


destroy_terminal :: proc(p_terminal: ^Terminal)
{
    _destroy_os_specific( p_terminal )
    free(p_terminal)
}


clear :: proc()
{
    fmt.printf( "\x1b[2J" )
}

set_cursor_position :: proc( x: u32, y: u32 )
{
    fmt.printf( "\x1b[%d;%dH", y, x )
}

write_at :: proc( x: u32, y: u32, text: string )
{
    set_cursor_position( x, y )
    fmt.printf( "%s",  text )
}

disable_cursor_blinking :: proc()
{
    fmt.printf( "\x1b[?12l" )
}

hide_cursor :: proc()
{
    fmt.printf( "\x1b[?25l" )
}