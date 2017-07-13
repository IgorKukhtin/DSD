unit uExec;

interface

procedure ExecSQL(ASQL: string);

implementation

uses
  Data.DB,
  dsdDB;

procedure ExecSQL(ASQL: string);
var
  StoredProc: TdsdStoredProc;
begin
  StoredProc := TdsdStoredProc.Create(nil);
  StoredProc.OutputType := otResult;
  StoredProc.StoredProcName := 'gpExecSql';
  StoredProc.Params.AddParam('inSqlText', ftBlob, ptInput, ASQL);

  try
    StoredProc.Execute(false, false, false);
  finally
    StoredProc.Free;
  end;
end;

end.
