unit IniUtils;

interface

function iniLocalDataBaseSQLite: String;

procedure SaveUserSettings;
procedure SaveFormData;
procedure SaveUserUnit;
procedure SaveGoods;
procedure SaveGoodsBarCode;


function ChechActiveInv(var ADate : TDateTime; var AUnitName : String; var AisSave : Boolean) : boolean;
function CreateInventoryTable : boolean;

var gUserCode : Integer;

implementation

uses Data.DB, Datasnap.DBClient, LocalWorkUnit, StorageSQLite,
     iniFiles, Controls, Classes, SysUtils, Forms, vcl.Dialogs, dsdDB,
     UnilWin, FormStorage, Updater, DateUtils;

const
  LocalDBNameSQLite: String = 'FarmacyInventorySQLite.db';

  InventoryCreateSQL: String =
      'CREATE TABLE IF NOT EXISTS Inventory ('#13#10 +
      'ID           integer PRIMARY KEY AUTOINCREMENT NOT NULL,'#13#10 +

      'Date         date           not null,'#13#10 +

      'Unit         int,'#13#10 +

      'DateInput    datetime,'#13#10 +
      'UserInput    int,'#13#10 +

      'FOREIGN KEY (Unit) REFERENCES Unit)';


  InventoryChildCreateSQL: String =
      'CREATE TABLE IF NOT EXISTS InventoryChild ('#13#10 +
      'ID            integer PRIMARY KEY AUTOINCREMENT NOT NULL,'#13#10 +
      'Inventory     int            not null,'#13#10 +

      'Goods         int,'#13#10 +

      'Amount        numeric(16, 4) not null default 0.0,'#13#10 +

      'DateInput     datetime,'#13#10 +
      'UserInput     int,'#13#10 +

      'IsSend        Boolean        not null default False,'#13#10 +

      'FOREIGN KEY (Goods) REFERENCES Goods)';

    InventoryCheckSQL: String =
      'SELECT i.Date, us.name, CAST((COALESCE (ic.CountNoSend, 0) > 0) AS Boolean) AS isActive'#13#10 +
      'FROM Inventory AS i'#13#10 +
      '     LEFT JOIN UserSettings AS us ON us.id = i.UserInput'#13#10 +
      '     LEFT JOIN (SELECT ic.Inventory, COUNT(*) AS CountNoSend'#13#10 +
      '                FROM InventoryChild AS ic'#13#10 +
      '                WHERE ic.IsSend = False'#13#10 +
      '                GROUP BY ic.Inventory) AS ic ON ic.Inventory = i.Id'#13#10 +
      'WHERE COALESCE (ic.CountNoSend, 0) > 0';


function iniLocalDataBaseSQLite: String;
begin
  Result := LocalDBNameSQLite;
end;

function Goods_Table: String;
Begin
  Result := 'Goods';
End;

function GoodsBarCode_Table: String;
Begin
  Result := 'GoodsBarCode';
End;

function Inventory_Table: String;
Begin
  Result := 'Inventory';
End;

function InventoryChild_Table: String;
Begin
  Result := 'InventoryChild';
End;

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
        SaveLocalData(ds, Goods_Table);

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
        SaveLocalData(ds, GoodsBarCode_Table);

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

function ChechActiveInv(var ADate : TDateTime; var AUnitName : String; var AisSave : Boolean) : boolean;
  var ACDS: TClientDataSet;
begin
  Result := False;
  if not SQLite_TableExists(Inventory_Table) then Exit;

  ACDS := TClientDataSet.Create(Nil);
  try
    LoadSQLiteSQL(ACDS, InventoryCheckSQL);
    if ACDS.Active and (ACDS.RecordCount = 1) then
    begin

    end;
    Result := True;
  finally
    ACDS.Free;
  end;

end;

function CreateInventoryTable : boolean;
begin
  Result := False;

  SQLite_TableDelete(Inventory_Table);
  SQLite_TableDelete(InventoryChild_Table);

  try

    if not SQLite_ExecSQL(InventoryCreateSQL) then Exit;
    if not SQLite_ExecSQL(InventoryChildCreateSQL) then Exit;

    Result := True;
  finally
  end;

end;

end.
