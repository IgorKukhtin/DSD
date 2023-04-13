unit IniUtils;

interface

function iniLocalDataBaseSQLite: String;

procedure SaveUserSettings;
procedure SaveFormData;
procedure SaveUserUnit;
procedure SaveGoods;
procedure SaveGoodsBarCode;

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

procedure SaveFormData;
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

        sp.StoredProcName := 'gpSelect_Inventory_Object_Form';
        sp.Params.Clear;
        sp.Execute;
        SaveLocalData(ds, FormData_lcl);

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        ShowMessage('SaveFormData Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure SaveUserUnit;
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

        sp.StoredProcName := 'gpSelect_Object_Unit_Active';
        sp.Params.Clear;
        sp.Params.AddParam('inNotUnitId', ftInteger, ptInput, 0);
        sp.Execute;
        SaveLocalData(ds, 'Unit');

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        ShowMessage('SaveUserUnit Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure SaveGoods;
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

        sp.StoredProcName := 'gpSelect_Inventory_Goods';
        sp.Params.Clear;
        sp.Execute;
        SaveLocalData(ds, 'Goods');

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        ShowMessage('SaveGoods Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure SaveGoodsBarCode;
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

        sp.StoredProcName := 'gpSelect_Inventory_Goods_BarCode';
        sp.Params.Clear;
        sp.Execute;
        SaveLocalData(ds, 'GoodsBarCode');

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        ShowMessage('SaveGoods Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

end.
