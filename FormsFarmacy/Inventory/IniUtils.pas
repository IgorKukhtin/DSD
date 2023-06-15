unit IniUtils;

interface

function iniLocalDataBaseSQLite: String;

procedure SaveUserSettings;
procedure SaveFormData;
procedure SaveUserUnit;
procedure SaveGoods;
procedure SaveGoodsBarCode;
procedure SaveRemains;
function SaveInventory(AUnitId : Integer; AOperDate : TDateTime) : Boolean;

function InventoryDate_Table: String;
function Inventory_Table: String;
function InventoryChild_Table: String;

function ChechActiveInv(var AOperDate : TDateTime; var AUnitName : String; var AisSave : Boolean) : boolean;
function CreateInventoryTable : boolean;

var gUserCode : Integer;

const
    InventoryGetActiveSQL: String =
      'SELECT i.Id, i.OperDate, u.Id AS UnitId, u.Name AS UnitName'#13#10 +
      'FROM Inventory AS i'#13#10 +
      '     LEFT JOIN Unit AS u ON u.id = i.UnitId';

    GetGoodsBarCodeSQL: String =
      'SELECT G.Id, G.Code, G.Name'#13#10 +
      'FROM GoodsBarCode AS gbc'#13#10 +
      '     LEFT JOIN Goods AS G ON G.GoodsMainId = gbc.GoodsMainId'#13#10 +
      'WHERE gbc.barcode LIKE ''%s''';

    GetGoodsIdSQL: String =
      'SELECT G.Id, G.Code, G.Name'#13#10 +
      'FROM Goods AS G'#13#10 +
      'WHERE G.GoodsMainId = %s';

    GetGoodsCodeSQL: String =
      'SELECT G.Id, G.Code, G.Name'#13#10 +
      'FROM Goods AS G'#13#10 +
      'WHERE G.Code = %s';

implementation

uses Data.DB, Datasnap.DBClient, LocalWorkUnit, StorageSQLite,
     iniFiles, Controls, Classes, SysUtils, Forms, vcl.Dialogs, dsdDB,
     UnilWin, FormStorage, Updater, DateUtils;

const
  LocalDBNameSQLite: String = 'FarmacyInventorySQLite.db';

  InventoryCreateSQL: String =
      'CREATE TABLE IF NOT EXISTS Inventory ('#13#10 +
      'ID           integer PRIMARY KEY AUTOINCREMENT NOT NULL,'#13#10 +

      'OperDate     date           not null,'#13#10 +

      'UnitId       integer,'#13#10 +

      'DateInput    datetime,'#13#10 +
      'UserInputId  integer,'#13#10 +

      'FOREIGN KEY (UnitId) REFERENCES Unit)';


  InventoryChildCreateSQL: String =
      'CREATE TABLE IF NOT EXISTS InventoryChild ('#13#10 +
      'ID            integer PRIMARY KEY AUTOINCREMENT NOT NULL,'#13#10 +
      'Inventory     integer            not null,'#13#10 +

      'GoodsId       integer,'#13#10 +

      'Amount        numeric(16, 4) not null default 0.0,'#13#10 +

      'DateInput     datetime,'#13#10 +
      'UserInputId   integer,'#13#10 +

      'CheckId       integer,'#13#10 +

      'IsSend        Boolean        not null default False,'#13#10 +

      'FOREIGN KEY (GoodsId) REFERENCES Goods)';

    InventoryCheckSQL: String =
      'SELECT i.OperDate, u.Name, COALESCE (ic.CountNoSend, 0) AS CountNoSend'#13#10 +
      'FROM Inventory AS i'#13#10 +
      '     LEFT JOIN Unit AS u ON u.id = i.UnitId'#13#10 +
      '     LEFT JOIN (SELECT ic.Inventory, COUNT(*) AS CountNoSend'#13#10 +
      '                FROM InventoryChild AS ic'#13#10 +
      '                WHERE ic.IsSend = ''N'''#13#10 +
      '                GROUP BY ic.Inventory) AS ic ON ic.Inventory = i.Id';

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

function Remains_Table: String;
Begin
  Result := 'Remains';
End;

function InventoryDate_Table: String;
Begin
  Result := 'InventoryDate';
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
  finally
    freeAndNil(sp);
  end;
end;

procedure SaveRemains;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      sp.OutputType := otDataSet;
      sp.DataSet := ds;

      sp.StoredProcName := 'gpSelect_Inventory_Remains';
      sp.Params.Clear;
      sp.Execute;
      SaveLocalData(ds, Remains_Table);

    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
  end;
end;

function SaveInventory(AUnitId : Integer; AOperDate : TDateTime) : Boolean;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  Result := False;
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      sp.OutputType := otDataSet;
      sp.DataSet := ds;

      sp.StoredProcName := 'gpSelect_Inventory_MI_Full';
      sp.Params.Clear;
      sp.Params.AddParam('inUnitId', ftInteger, ptInput, AUnitId);
      sp.Params.AddParam('inOperDate', ftDateTime, ptInput, AOperDate);
      sp.Execute;
      SaveLocalData(ds, InventoryDate_Table);
      Result := True;

    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
  end;
end;


function ChechActiveInv(var AOperDate : TDateTime; var AUnitName : String; var AisSave : Boolean) : boolean;
  var ACDS: TClientDataSet;
begin
  Result := False;
  if not SQLite_TableExists(Inventory_Table) then Exit;

  ACDS := TClientDataSet.Create(Nil);
  try
    LoadSQLiteSQL(ACDS, InventoryCheckSQL);
    if ACDS.Active and (ACDS.RecordCount = 1) then
    begin
      AOperDate := ACDS.FieldByName('OperDate').AsDateTime;
      AUnitName := ACDS.FieldByName('Name').AsString;
      AisSave := ACDS.FieldByName('CountNoSend').AsInteger = 0;
      Result := True;
      Exit;
    end;
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
