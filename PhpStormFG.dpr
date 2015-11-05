program PhpStormFG;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,WinAPI.Windows,WinAPI.ShellApi;

var
  pw :hwnd; // ���� ������ ����, �� ��� �������� ��� ����������
  i: integer;
  StartUpInfo: TStartUpInfo; //��������� �������� ��������
  ProcessInfo: TProcessInformation; //������������ ����������
  app,p: string;

function GetWindowClass(hwnd: HWND): string;
begin
  SetLength(Result, 255);
  SetLength(Result, GetClassName(hwnd, PChar(Result), 255));
end;

function FindFunc(h:hwnd):boolean;stdcall;
 var   WindowName: PwideChar;
begin
 result:=true; // ���������� �����
 GetMem(WindowName, 256);
 if GetWindowText(h,WindowName,255) > 0 then
 begin
//   writeln( WindowName );
//   writeln( GetWindowClass(h) );
   if (pos('PhpStorm ',WindowName) > 0) AND (pos('SunAwtFrame', GetWindowClass(h)) > 0)  then begin
     pw := h;
     result:=false; // �� ����� ��, ��� �����, ����� ����������
   end;
 end;
 FreeMem(WindowName, 256);
end;

begin
//  for i := 1 to System.ParamCount do writeln(  );
//  readln;
  if ParamCount > 0 then
  begin
//    writeln( ParamStr(1) );
    FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);
    //����� ����� ���������� � ��� ��������� ���������.
    with StartUpInfo do
    begin
      //�������� ���������� ������, ���������� ���������� TStartUpInfo.
      //����������� ��� ����������. ��������������� ��� SizeOf(TStartUpInfo).
      cb := SizeOf(TStartUpInfo);
      //�������� ����� ������, ����������� ��������� ��������� ��������� ��������.
      //���������� ����, ������ - ������.
//      dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
        dwFlags := 0;
      //���������� ��� ������ ��������� ���� ����������� ����������.
      //���������� �����������
      //wShowWindow := SW_SHOWMAXIMIZED;
    end;

    app := '"'+StringReplace( ParamStr(0), 'FG','',[] )+'" '+ParamStr(1);

//    writeln( app );

    if CreateProcess( nil, PChar(app) ,
      nil, nil, false, NORMAL_PRIORITY_CLASS,
      nil, nil, StartUpInfo, ProcessInfo) then
    begin
//      writeln('ok');
//      readln;
    end
    else
    begin
      writeln(SysErrorMessage(GetLastError));
      readln;
    end;
   end
   else
   begin
     writeln('Usage: PhpStormFG <filename>');
     readln;
   end;

  pw := 0;
  try
   EnumWindows(@FindFunc,0); // ��������� ������������
   if pw <> 0 then begin
     SetForegroundWindow(pw);
     setfocus(pw);
//     writeln('Found PhpStorm window');

   end;

//   readln;


  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ReadLn;
    end;
  end;
end.
