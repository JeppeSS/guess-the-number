package terminal

Terminal_Error :: union #shared_nil
{
    Create_Terminal_Error,
}



Terminal :: struct
{
    using specific: Terminal_Os_Specific
}