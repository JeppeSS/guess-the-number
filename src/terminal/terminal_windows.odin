//+build windows
//+private
package terminal

import win "core:sys/windows"

Terminal_Os_Specific :: struct
{
    output_handle:         win.HANDLE,
    original_console_mode: win.DWORD
}

_initialize_os_specific :: proc( p_terminal: ^Terminal ) -> Terminal_Error
{
    p_terminal.output_handle = win.GetStdHandle( win.STD_OUTPUT_HANDLE )
    if p_terminal.output_handle == win.INVALID_HANDLE_VALUE
    {
        return Create_Terminal_Error( win.GetLastError() )
    }

    console_mode: win.DWORD = 0
    if !win.GetConsoleMode( p_terminal.output_handle, &console_mode )
    {
        return Create_Terminal_Error( win.GetLastError() )
    }

    p_terminal.original_console_mode = console_mode
    console_mode |= win.ENABLE_VIRTUAL_TERMINAL_PROCESSING

    if !win.SetConsoleMode( p_terminal.output_handle, console_mode )
    {
        return Create_Terminal_Error( win.GetLastError() )
    }


    return nil
}


_destroy_os_specific :: proc( p_terminal: ^Terminal ) -> Terminal_Error
{
    if !win.SetConsoleMode( p_terminal.output_handle, p_terminal.original_console_mode )
    {
        return Create_Terminal_Error( win.GetLastError() )
    }
    
    return nil
}