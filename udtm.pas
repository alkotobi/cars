unit udtm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Uni, SQLiteUniProvider, MySQLUniProvider, MemData, DBAccess,Dialogs;

type

  { Tdtm_login }

  Tdtm_login = class(TDataModule)
    conn: TUniConnection;
    MySQLUniProvider1: TMySQLUniProvider;
    qry_groups: TUniQuery;
    qry_users: TUniQuery;
    qry_permissions: TUniQuery;
    SQLiteUniProvider1: TSQLiteUniProvider;
    procedure connConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
  private

  public

  end;

var
  dtm_login: Tdtm_login;

implementation

{$R *.lfm}

{ Tdtm_login }

procedure Tdtm_login.connConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
  showMessage('connection lost');
  RetryMode := TRetryMode.rmReconnect;
end;

end.

