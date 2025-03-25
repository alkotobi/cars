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
uses udtm, Uni, ulibrary;

procedure Tfrm_login.Button1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_login.btn_loginClick(Sender: TObject);
var
  qry_users, qry_groups, qry_permissions: TUniQuery;
begin
  with dtm do
  begin
    if (edt_name.Text = '') or (edt_pass.Text = '') then
    begin
      ShowMessage('pleease enter a valid  name/pass');
      exit;
    end;
    try
      conn.Open;

    except
      on e: Exception do
      begin
        ShowMessage(e.Message);
        conn.Close();
        exit;
      end;
    end;
    qry_users := TUniQuery.Create();
    qry_users.SQL.Text :=
      'select * from tbl_users where name=:name and password=:password';
    qry_users.Prepare;
    qry_users.Params[0].AsString := edt_name.Text;
    qry_users.Params[1].AsString := edt_pass.Text;
    try
      qry_users.Open;
      if (qry_users.IsEmpty) then
      begin
        ModalResult := mrCancel;
        qry_users.Free;
        conn.Close();
        Exit;
      end;
      fillBufDatasetFromDataset(qry_users, tbl_users);
      qry_users.Free;
    except
      on e: Exception do
      begin
        ShowMessage(e.Message);
        qry_users.Free;
        conn.Close();
        exit;

      end;
    end;

    qry_groups := TUniQuery.Create();
    qry_groups.SQL.Text := 'select * from `tbl_groups` where id = :id';
    qry_groups.Prepare;
    qry_groups.Params[0].AsInteger := qry_users.FieldByName('id_group').AsInteger;
    try
      qry_groups.Open;
      fillBufDatasetFromDataset(qry_groups, tbl_groups);
      qry_groups.Free;
    except
      on e: Exception do
      begin
        ShowMessage(e.Message);
        qry_groups.Free;
        conn.Close();
        exit;

      end;
    end;
    qry_permissions := TUniQuery.Create();
    qry_permissions.SQL.Text :=
      'select * from tbl_permissions where id_group =:id_group';
    qry_permissions.Prepare;
    qry_permissions.Params[0].AsInteger := qry_groups.FieldByName('id').AsInteger;
    try
      qry_permissions.Open;
      fillBufDatasetFromDataset(qry_permissions, tbl_permissions);
      qry_permissions.Free;
    except
      on e: Exception do
      begin
        ShowMessage(e.Message);
        qry_permissions.Free;
        conn.Close();
        exit;
      end;
    end;
    conn.Close();
  end;

  ModalResult := mrOk;
end;

procedure Tfrm_login.edt_passKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
  begin
    btn_login.Click;

  end;
end;

end.
