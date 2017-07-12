unit uExec;

interface

uses
  Data.DB,
  dsdDB;

procedure ExecSQL(ASQL: string);

implementation

(*
  DO $$
  BEGIN
        PERFORM gpExecSql(inSqlText:= 'DO $BODY$ BEGIN '
    '  PERFORM lfGetParams(inStoredProcName:=' || quote_literal('lfGetParams') || ', inSession:= ' || quote_literal('5') || '); '
    '  PERFORM lfGetParams(inStoredProcName:=' || quote_literal('gpGetMobile_Object_Const') || ', inSession:= ' || quote_literal('5') || '); '
    'END; $BODY$', inSession:= '5');
  END; $$;
*)

procedure ExecSQL(ASQL: string);
var
  StoredProc: TdsdStoredProc;
begin
  StoredProc := TdsdStoredProc.Create(nil);
  StoredProc.StoredProcName := 'gpExecSql';
  StoredProc.Params.AddParam('inSqlText', ftString, ptInput, ASQL);

  try
    StoredProc.Execute(false, false, false);
  finally
    StoredProc.Free;
  end;
end;

end.
