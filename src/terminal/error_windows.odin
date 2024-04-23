//+build windows
//+private
package terminal

import "core:c"

ERROR_INVALID_HANDLE       :: 6    // The handle is invalid.


// TODO[Jeppe]: Need to add more errors!
Create_Terminal_Error :: enum c.int
{
    None                 = 0,
    Invalid_Handle       = ERROR_INVALID_HANDLE,
}
