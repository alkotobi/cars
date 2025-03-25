unit udtm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Uni, MySQLUniProvider;

type

  { Tdtm }

  Tdtm = class(TDataModule)
    tbl_permissions: TBufDataset;
    tbl_users: TBufDataset;
    conn: TUniConnection;
    MySQLUniProvider1: TMySQLUniProvider;
    tbl_groups: TBufDataset;
    UniQuery1: TUniQuery;
  private

  public

  end;

var
  dtm: Tdtm;

implementation

{$R *.lfm}

end.

