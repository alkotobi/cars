unit ulogin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tfrm_login }

  Tfrm_login = class(TForm)
    Button1: TButton;
    btn_login: TButton;
    btn_signup: TButton;
    edt_name: TEdit;
    edt_pass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure btn_loginClick(Sender: TObject);
    procedure edt_passKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  frm_login: Tfrm_login;

implementation

{$R *.lfm}

{ Tfrm_login }
uses udtm;

procedure Tfrm_login.Button1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_login.btn_loginClick(Sender: TObject);
begin
  with dtm_login do
  begin
    if(edt_name.Text ='')  or (edt_pass.Text='') then
    begin
      ShowMessage('pleease enter a valid  name/pass');
      exit;
    end;
    conn.Open;
    qry_users.Close;
    qry_users.SQL.Text := 'select * from tbl_users where name=:name and password=:password';
    qry_users.Prepare;
    qry_users.Params[0].AsString := edt_name.Text;
    qry_users.Params[1].AsString := edt_pass.Text;
    qry_users.Open;
    if (qry_users.IsEmpty) then
    begin
      ModalResult := mrCancel;
      Exit;
    end;
    qry_groups.Close;
    qry_groups.SQL.Text := 'select * from `tbl_groups` where id = :id';
    qry_groups.Prepare;
    qry_groups.Params[0].AsInteger := qry_users.FieldByName('id_group').AsInteger;
    qry_groups.Open;
    qry_permissions.Close;
    qry_permissions.SQL.Text:='select * from tbl_permissions where id_group =:id_group';
    qry_permissions.Prepare;
    qry_permissions.Params[0].AsInteger:=qry_groups.FieldByName('id').AsInteger;
    qry_permissions.Open;
  end;
  ModalResult:=mrOK;
end;

procedure Tfrm_login.edt_passKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    btn_login.Click

  end;
end;

end.
