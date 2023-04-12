unit IniUtils;

interface

function iniLocalDataBaseSQLite: String;

procedure SaveUserSettings;

var gUserCode : Integer;

implementation

uses Data.DB, Datasnap.DBClient, LocalWorkUnit,
     iniFiles, Controls, Classes, SysUtils, Forms, vcl.Dialogs, dsdDB,
     UnilWin, FormStorage, Updater, DateUtils;

const
  LocalDBNameSQLite: String = 'FarmacyInventorySQLite.db';

function iniLocalDataBaseSQLite: String;
begin
  Result := LocalDBNameSQLite;
end;

procedure SaveUserSettings;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Inventory_UserSettings';
        sp.Params.Clear;
        sp.Execute;
        SaveLocalData(ds,UserSettings_lcl);

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        ShowMessage('SaveUserSettings Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;


end.
