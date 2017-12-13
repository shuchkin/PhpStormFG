program PhpStormFG;

{$R *.res}

uses
  SysUtils,Windows;

var
  pw :hwnd;
  StartUpInfo: TStartUpInfo;
  wp: TWindowPlacement;
  ProcessInfo: TProcessInformation;
  app: string;
  i:integer;

function GetWindowClass(hwnd: HWND): string;
begin
  SetLength(Result, 255);
  SetLength(Result, GetClassName(hwnd, PChar(Result), 255));
end;

function FindFunc(h:hwnd):boolean;stdcall;
 var   WindowName: PwideChar;
begin
 result:=true;
 GetMem(WindowName, 256);
 if GetWindowText(h,WindowName,255) > 0 then
 begin
   if (pos('PhpStorm',WindowName) > 0) AND (pos('SunAwtFrame', GetWindowClass(h)) > 0)  then begin
     pw := h;
     result:=false;
   end;
 end;
 FreeMem(WindowName, 256);
end;

begin
  app := StringReplace( ParamStr(0), 'FG.','.',[rfReplaceAll] );


  if FileExists(app) then
  begin
    app := '"'+app+'"';

    FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);
    with StartUpInfo do
    begin
      cb := SizeOf(TStartUpInfo);
  //      dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
        dwFlags := 0;
      //wShowWindow := SW_SHOWMAXIMIZED;
    end;

    if ParamCount() > 0 then
    begin

      app := app + ' "';
      for i:=1 to ParamCount() do app := app + ParamStr(i)+' ';
      app := Copy(app,0,Length(app)-1 ) + '"';
    end;

//    MessageBox(0, PChar( app ), 'PHPStromFG', MB_OK or MB_TASKMODAL);

    CreateProcess( nil, PChar(app) ,
      nil, nil, false, NORMAL_PRIORITY_CLASS,
      nil, nil, StartUpInfo, ProcessInfo);
   sleep(10);
    pw := 0;
    EnumWindows(@FindFunc,0);
    if pw <> 0 then
    begin
      SetForegroundWindow(pw);
      setfocus(pw);
      wp.length := SizeOf(TWindowPlacement);
      GetWindowPlacement( pw, @wp );
      if wp.showCmd = SW_SHOWMINIMIZED then ShowWindow(pw, SW_RESTORE);
    end
  end
  else
  begin
      MessageBox(0, PChar('Please copy'#13#10+ParamStr(0)+#13#10'to PhpStorm /bin/ !'), 'PHPStromFG', MB_OK or MB_ICONSTOP or MB_TASKMODAL);
  end;
end.
