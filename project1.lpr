program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, umain, ulogin, udtm
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
    Application.CreateForm(Tdtm_login, dtm_login);
  frm_login := Tfrm_login.Create(Application);
   if frm_login.ShowModal <> mrOK then
   begin
       Application.Terminate;
   end;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

