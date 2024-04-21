package terminal

create_terminal :: proc() -> ^Terminal
{
    p_terminal := new( Terminal )
    
    _initialize_os_specific( p_terminal )

    return p_terminal
}


destroy_terminal :: proc(p_terminal: ^Terminal)
{
    free(p_terminal)
}