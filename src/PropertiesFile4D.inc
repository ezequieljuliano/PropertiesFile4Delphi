{$IF System.CompilerVersion > 22.0}
  {$DEFINE CompilerVersion_DelphiXE_greater}
{$IFEND}

{$IFDEF CompilerVersion_DelphiXE_greater}
  {$DEFINE USE_SYSTEM_NAMESPACE}
  {$DEFINE USE_STRING_CLASS}
{$ENDIF CompilerVersion_DelphiXE_greater}