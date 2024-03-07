unit uDM;

interface

uses
  System.SysUtils, System.Classes, FMX.DialogService, System.UITypes,
  Data.DB, dsdDB, Datasnap.DBClient, System.Variants, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Comp.Client,
  FireDAC.Comp.UI, FireDAC.Stan.Param, FireDAC.DApt, Datasnap.Provider,
  FMX.Forms, FireDAC.Phys.SQLiteWrapper, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, System.Generics.Collections
  {$IFDEF ANDROID}
  , Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
  Androidapi.JNI.Net, Androidapi.JNI.JavaTypes, Androidapi.JNI.App,
  Androidapi.JNI.Support
  {$ENDIF};

CONST
  DataBaseFileName = 'BoatMobile.sdb';

type
  { отдельный поток для показа бегущего круга }
  TProgressThread = class(TThread)
  private
    { Private declarations }
    FProgress : integer;

    procedure Update;
  protected
    procedure Execute; override;
  end;

  { отдельный поток для выполнения процедур получения данных с сервера }
  TWaitThread = class(TThread)
  private
    TaskName : string;

    procedure SetTaskName(AName : string);

    function UpdateProgram: string;
    function LoadGoods: string;
    function LoadGoodsList: string;
    function UploadInventoryGoods: string;
  protected
    procedure Execute; override;
  end;

  { классы для создания БД на основе TFDTable модуля TDM }
  TDataSets = TObjectList<TFDTable>;

  TStructure = Class(TObject)
  private
    FDataSets: TDataSets;
    FLastDataSet: TFDTable;
    FIndexes: TStringList;
    function GetDataSet(const ATableName: String): TFDTable;
    function GetIndex(const AIndex: integer): string;
    function GetIndexCount: integer;
    procedure MakeIndex(ATable: TFDTable);
    procedure MakeDopIndex(ATable: TFDTable);
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure OpenDS(ATable: TFDTable);
    procedure AddTable(ATable: TFDTable);
    property DataSets: TDataSets read FDataSets;
    property DataSet[const ATableName: String]: TFDTable read GetDataSet;
    property Indexes[const AIndex: integer]: string read GetIndex;
    property IndexCount: integer read GetIndexCount;
  End;

  TDM = class(TDataModule)
    cdsInventoryJournal: TClientDataSet;
    cdsInventoryJournalId: TIntegerField;
    cdsInventoryJournalStatusId: TIntegerField;
    cdsInventoryJournalisList: TBooleanField;
    cdsInventoryJournalInvNumber: TWideStringField;
    cdsInventoryJournalStatusName: TWideStringField;
    cdsInventoryJournalUnitName: TWideStringField;
    cdsInventoryJournalComment: TWideStringField;
    cdsInventoryJournalOperDate: TWideStringField;
    cdsInventoryJournalTotalCount: TWideStringField;
    cdsInventoryJournalEditButton: TIntegerField;
    cdsInventory: TClientDataSet;
    cdsInventoryId: TIntegerField;
    cdsInventoryInvNumber: TWideStringField;
    cdsInventoryStatusName: TWideStringField;
    cdsInventoryStatusId: TIntegerField;
    cdsInventoryUnitName: TWideStringField;
    cdsInventoryComment: TWideStringField;
    cdsInventoryisList: TBooleanField;
    cdsInventoryOperDate: TDateTimeField;
    cdsInventoryTotalCount: TFloatField;
    cdsInventoryList: TClientDataSet;
    cdsInventoryListId: TIntegerField;
    cdsInventoryListGoodsId: TIntegerField;
    cdsInventoryListGoodsCode: TIntegerField;
    cdsInventoryListGoodsName: TWideStringField;
    cdsInventoryListArticle: TWideStringField;
    cdsInventoryListEAN: TWideStringField;
    cdsInventoryListGoodsGroupId: TIntegerField;
    cdsInventoryListGoodsGroupName: TWideStringField;
    cdsInventoryListMeasureName: TWideStringField;
    cdsInventoryListAmount: TFloatField;
    cdsInventoryListAmountRemains: TFloatField;
    cdsInventoryListAmountDiff: TFloatField;
    cdsInventoryListAmountRemains_curr: TFloatField;
    cdsInventoryListPrice: TFloatField;
    cdsInventoryListSumma: TFloatField;
    cdsInventoryUnitId: TIntegerField;
    cdsGoods: TClientDataSet;
    cdsGoodsId: TIntegerField;
    cdsGoodsCode: TIntegerField;
    cdsGoodsName: TWideStringField;
    cdsGoodsArticle: TWideStringField;
    cdsGoodsEAN: TWideStringField;
    cdsGoodsGoodsGroupName: TWideStringField;
    cdsGoodsMeasureName: TWideStringField;
    cdsInventoryListPartNumber: TWideStringField;
    cdsGoodsList: TClientDataSet;
    cdsGoodsListId: TIntegerField;
    cdsGoodsListCode: TIntegerField;
    cdsGoodsListName: TWideStringField;
    cdsGoodsListArticle: TWideStringField;
    cdsGoodsListEAN: TWideStringField;
    cdsGoodsListGoodsGroupName: TWideStringField;
    cdsGoodsListMeasureName: TWideStringField;
    conMain: TFDConnection;
    fdGUIxWaitCursor: TFDGUIxWaitCursor;
    fdDriverLink: TFDPhysSQLiteDriverLink;
    fdfAnsiUpperCase: TFDSQLiteFunction;
    cdsGoodsisErased: TBooleanField;
    tblInventoryGoods: TFDTable;
    tblInventoryGoodsGoodsId: TIntegerField;
    tblInventoryGoodsAmount: TFloatField;
    tblInventoryGoodsPartNumber: TWideStringField;
    tblInventoryGoodsMovementId: TIntegerField;
    qryMeta: TFDMetaInfoQuery;
    qryMeta2: TFDMetaInfoQuery;
    qryInventoryGoods: TFDQuery;
    qryInventoryGoodsMovementId: TIntegerField;
    qryInventoryGoodsGoodsId: TIntegerField;
    qryInventoryGoodsGoodsCode: TIntegerField;
    qryInventoryGoodsGoodsName: TWideStringField;
    qryInventoryGoodsArticle: TWideStringField;
    qryInventoryGoodsEAN: TWideStringField;
    qryInventoryGoodsGoodsGroupName: TWideStringField;
    qryInventoryGoodsMeasureName: TWideStringField;
    qryInventoryGoodsPartNumber: TWideStringField;
    qryInventoryGoodsAmount: TFloatField;
    fdcUTF16NoCase: TFDSQLiteCollation;
    qryInventoryGoodsDeleteId: TIntegerField;
    cdsOrderInternal: TClientDataSet;
    cdsOrderInternalMovementItemId: TIntegerField;
    cdsOrderInternalInvNumber_Full: TWideStringField;
    cdsOrderInternalInvNumberFull_OrderClient: TWideStringField;
    cdsOrderInternalGoodsName: TWideStringField;
    cdsOrderInternalAmount: TFloatField;
    cdsOrderInternalInvNumberFull_ProductionUnion: TWideStringField;
    cdsOrderInternalMovementPUId: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure fdfAnsiUpperCaseCalculate(AFunc: TSQLiteFunctionInstance;
      AInputs: TSQLiteInputs; AOutput: TSQLiteOutput; var AUserData: TObject);
    procedure qryInventoryGoodsCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    FConnected: Boolean;

    FFilterGoods: String;
    FFilterGoodsEAN: Boolean;
    FLimitList : Integer;

    procedure InitStructure;
  public
    { Public declarations }
    function Connect: Boolean;
    function CheckStructure: Boolean;
    procedure CreateIndexes;

    procedure SaveSQLiteData(ASrc: TClientDataSet; ATableName, AUpperField: String);
    procedure LoadSQLiteData(ADst: TClientDataSet; ATableName: String);
    procedure LoadSQLite(ADst: TClientDataSet; ASQL: String);

    function GetCurrentVersion: string;
    function GetMobileVersion : String;
    function GetAPKFileName : String;
    procedure CheckUpdate;
    function CompareVersion(ACurVersion, AServerVersion: string): integer;
    procedure UpdateProgram(const AResult: TModalResult);

    function DownloadGoods : Boolean;
    function DownloadInventoryJournal : Boolean;
    function DownloadInventory(AId : Integer = 0) : Boolean;
    function DownloadInventoryList : Boolean;

    function DownloadOrderInternal(AId : Integer) : Boolean;
    function InsertProductionUnion(AId : Integer) : Boolean;

    function GetInventoryActive(AisCreate : Boolean) : Boolean;


    function LoadGoodsList : Boolean;

    procedure LoadGoods;

    procedure OpenInventoryGoods;
    procedure AddInventoryGoods(AGoodsId : Integer; AAmount: Currency; APartNumber : String);
    procedure UpdateInventoryGoods(AAmount: Currency);
    procedure DeleteInventoryGoods;
    function isInventoryGoodsSend : Boolean;

    procedure UploadAllData;
    procedure UploadInventoryGoods;

    property Connected: Boolean read FConnected;
    property FilterGoods : String read FFilterGoods write FFilterGoods;
    property FilterGoodsEAN : Boolean read FFilterGoodsEAN write FFilterGoodsEAN default False;
    property LimitList : Integer read FLimitList write FLimitList default 300;

  end;

var
  DM: TDM;
  Structure: TStructure;
  ProgressThread : TProgressThread;
  WaitThread : TWaitThread;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses System.IOUtils, System.DateUtils, System.ZLib, System.RegularExpressions,
     FMX.Dialogs, Storage, uMain;

{$R *.dfm}

{ Процедура по символьно переводит строку в набор цифр }
function ReConvertConvert(S: string): TBytes;
var
  i, l, k: integer;
  InB: TBytes;
begin
  i := Low(S);
  l := High(S);
  SetLength(InB, Length(S) div 2);
  k := 0;
  while i <= l do
  begin
    InB[k] := StrToInt('$' + s[i] + s[i+1]);
    inc(k);
    i := i + 2;
  end;
  ZDecompress(InB, Result);
end;

{ Процедура по символьно переводит строку в набор цифр }
function ConvertConvert(S: TBytes): String;
var
  i, l: integer;
  ArcS: TBytes;
begin
  ZCompress(S, ArcS);
  result := '';
  l := Length(ArcS);
  for I := 0 to l - 1 do
    result := result + IntToHex(ArcS[i], 2);
end;

{ обновление бегущего круга }
procedure TProgressThread.Update;
const
  Colors : array[0..5] of TAlphaColor = ($FF1AF71A, $FF1305DA, $FFF818D2, $FF02F2FA, $FFFB1028, $FFFE7FE8);
var
  d: single;
  NewColor, OldColor: TAlphaColor;
  ColorIndex: integer;
begin
  inc(FProgress);
  if FProgress>= 100 then
  begin
    FProgress := 0;

    OldColor := frmMain.pieProgress.Fill.Color;
    repeat
      ColorIndex := Random(5);

      NewColor := Colors[ColorIndex];
    until OldColor <> NewColor;
    frmMain.pieProgress.Fill.Color := NewColor;
  end;

  d := (-FProgress * 360 / 100);

  frmMain.pieProgress.StartAngle := d + 20;
  frmMain.pieProgress.EndAngle := d;
end;

procedure TProgressThread.Execute;
begin
  FProgress := 0;

  while true do
  begin
    if ProgressThread.Terminated then
      exit;

    Synchronize(Update);
    sleep(20);
  end;
end;

{ TWaitThread }

procedure TWaitThread.SetTaskName(AName : string);
begin
  Synchronize(procedure
              begin
                frmMain.lProgressName.Text := AName;
              end);
end;

{ получение новой версии программы }
function TWaitThread.UpdateProgram: string;
var
  GetStoredProc : TdsdStoredProc;
  ApplicationName: string;
  FileStream : TMemoryStream;
  FileBytes: TBytes;
  {$IFDEF ANDROID}
  OutputDir: JFile;
  intent: JIntent;
  Path, FileName: string;
  ApkFile: JFile;
  ApkUri: Jnet_Uri;
  {$ENDIF}
begin
  Result := '';

  ApplicationName := DM.GetAPKFileName;

  GetStoredProc := TdsdStoredProc.Create(nil);
  FileStream := TMemoryStream.Create;
  try
    GetStoredProc.StoredProcName := 'gpGet_Object_Program';
    GetStoredProc.OutputType := otBlob;
    GetStoredProc.Params.AddParam('inProgramName', ftString, ptInput, ApplicationName);
    try
      FileBytes := ReConvertConvert(GetStoredProc.Execute(false, false, false));
      FileStream.Write(FileBytes, Length(FileBytes));

      if FileStream.Size = 0 then
      begin
        Result := 'Новая версия программы не загружена из базы данных';
        exit;
      end;

      FileStream.Position := 0;
      {$IFDEF ANDROID}
      OutputDir := TAndroidHelper.Context.getExternalCacheDir();
      Path := JStringToString(OutputDir.getAbsolutePath);
      FileName := path + '/' + ApplicationName;
      FileStream.SaveToFile(filename);
      {$ELSE}
      FileStream.SaveToFile(ApplicationName);
      {$ENDIF}

    except
      on E : Exception do
      begin
        Result := GetTextMessage(E);
        exit;
      end;
    end;
  finally
    FreeAndNil(GetStoredProc);
    FreeAndNil(FileStream);
  end;

  // Update programm
  {$IFDEF ANDROID}
  try

    ApkFile := TJfile.JavaClass.init( StringToJstring(FileName));
    ApkUri := TAndroidHelper.JFileToJURI(ApkFile);

    Intent := TJIntent.Create();
    Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
    Intent.addFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK
                 or TJIntent.JavaClass.FLAG_ACTIVITY_CLEAR_TOP
                 or TJIntent.JavaClass.FLAG_GRANT_WRITE_URI_PERMISSION
                 or TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
    Intent.setDataAndType(apkuri, StringToJString('application/vnd.android.package-archive'));
    TAndroidHelper.Activity.startActivity(Intent);

  except
    on E : Exception do
    begin
      Result := GetTextMessage(E);
      exit;
    end;
  end;
  {$ENDIF}
end;

// Получение справочника Комплектующих
function TWaitThread.LoadGoods: string;
var
  StoredProc : TdsdStoredProc;
begin

  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otDataSet;

    StoredProc.StoredProcName := 'gpSelect_Object_MobileGoods';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inIsErased', ftBoolean, ptInput, False);
    StoredProc.DataSet := DM.cdsGoods;

    try
      StoredProc.Execute(false, false, false);
      frmMain.DateDownloadGoods := Now;
      DM.SaveSQLiteData(DM.cdsGoods, 'Goods', 'Name,Article')
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    FreeAndNil(StoredProc);
    frmMain.DateDownloadGoods := Now;
    if frmMain.tcMain.ActiveTab = frmMain.tiGoods then TaskName := 'LoadGoodsList';
  end;
end;

// Открытие справочника Комплектующих
function TWaitThread.LoadGoodsList: string;
  var nID: Integer;
begin
  frmMain.lwGoods.Visible := False;
  frmMain.lGoodsSelect.Visible := False;
  if DM.cdsGoodsList.Active then nID := DM.cdsGoodsListId.AsInteger
  else nID := 0;
  try
    DM.LoadGoodsList;
  finally
    if DM.cdsGoodsList.Active and (nID <> 0) then DM.cdsGoodsList.Locate('Id', nId, []);
    Synchronize(procedure
              begin
                frmMain.lwGoods.Visible := True;
                frmMain.lGoodsSelect.Visible := True;
              end);
  end;
end;

// Отправить инвентаризации
function TWaitThread.UploadInventoryGoods: string;
var
  StoredProc : TdsdStoredProc;
  FDQuery: TFDQuery;
begin

  StoredProc := TdsdStoredProc.Create(nil);
  FDQuery := TFDQuery.Create(nil);
  try
    StoredProc.OutputType := otResult;

    StoredProc.StoredProcName := 'gpInsertUpdate_MovementItem_MobileInventory';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('ioId', ftInteger, ptInputOutput, 0);
    StoredProc.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
    StoredProc.Params.AddParam('inGoodsId', ftInteger, ptInput, 0);
    StoredProc.Params.AddParam('inAmount', ftFloat, ptInput, 0);
    StoredProc.Params.AddParam('inPartNumber', ftWideString, ptInput, '');

    try

      FDQuery.Connection := DM.conMain;
      FDQuery.SQL.Text := 'Select MovementId, GoodsId, Amount, PartNumber FROM InventoryGoods';
      FDQuery.Open;

      FDQuery.First;
      while not FDQuery.Eof do
      begin
        StoredProc.ParamByName('ioId').Value := 0;
        StoredProc.ParamByName('inMovementId').Value := FDQuery.FieldByName('MovementId').AsInteger;
        StoredProc.ParamByName('inGoodsId').Value := FDQuery.FieldByName('GoodsId').AsInteger;
        StoredProc.ParamByName('inAmount').Value := FDQuery.FieldByName('Amount').AsInteger;
        StoredProc.ParamByName('inPartNumber').Value := FDQuery.FieldByName('PartNumber').AsString;
        StoredProc.Execute(false, false, false);

        FDQuery.Delete;
        FDQuery.First;
      end;

    except
      on E : Exception do
      begin
        Result := GetTextMessage(E);
      end;
    end;
  finally
    FreeAndNil(StoredProc);
    FreeAndNil(FDQuery);
  end;

end;

procedure TWaitThread.Execute;
var
  Res : string;
begin
  Res := '';

  Synchronize(procedure
              begin
                frmMain.lProgress.Visible := false;
                frmMain.pieAllProgress.Visible := false;
                frmMain.pProgress.Visible := true;
                frmMain.vsbMain.Enabled := false;
              end);

  ProgressThread := TProgressThread.Create(true);
  try
    ProgressThread.FreeOnTerminate := true;
    ProgressThread.Start;

    if TaskName = 'UpdateProgram' then
    begin
      SetTaskName('Получение файла обновления');
      Res := UpdateProgram;
    end;

    if (Res = '') and (TaskName = 'LoadGoods') then
    begin
      SetTaskName('Получение справочника Комплектующих');
      Res := LoadGoods;
    end;

    if (Res = '') and (TaskName = 'LoadGoodsList') then
    begin
      SetTaskName('Открытие справочника Комплектующих');
      Res := LoadGoodsList;
    end;

    if (Res = '') and (TaskName = 'UploadInventoryGoods') or (TaskName = 'UploadAll') then
    begin
      SetTaskName('Отправка инвентаризаций');
      Res := UploadInventoryGoods;
    end;

  finally
    ProgressThread.Terminate;

    Synchronize(procedure
                begin
                  frmMain.pProgress.Visible := false;
                  frmMain.pieAllProgress.Visible := true;
                  frmMain.lProgress.Visible := true;
                  frmMain.vsbMain.Enabled := true;
                end);

    if Res <> '' then
    begin
      Synchronize(procedure
                  begin
                    ShowMessage(Res);
                  end);
    end;
  end;
end;

{ TStructure }

procedure TStructure.AddTable(ATable: TFDTable);
begin
  if not FDataSets.Contains(ATable) then
  begin
    MakeIndex(ATable);
    MakeDopIndex(ATable);
    FDataSets.Add(ATable);
  end;
end;

constructor TStructure.Create;
begin
  inherited Create;
  FDataSets := TDataSets.Create(False);
  FIndexes := TStringList.Create;
end;

destructor TStructure.Destroy;
begin
  FreeAndNil(FIndexes);
  freeAndNil(FDataSets);
  inherited;
end;

function TStructure.GetDataSet(const ATableName: String): TFDTable;
var
  T: TFDTable;
begin
  if Assigned(FLastDataSet) AND SameText(FLastDataSet.TableName, ATableName)
  then
    Exit(FLastDataSet);

  for T in DataSets do
    if SameText(T.TableName, ATableName) then
    begin
      FLastDataSet := T;
      Exit(FLastDataSet);
    end;
  result := nil;
end;

function TStructure.GetIndex(const AIndex: integer): string;
begin
  if (AIndex >=0) and (AIndex < FIndexes.Count)  then
    Result := FIndexes[AIndex]
  else
    Result := '';
end;

function TStructure.GetIndexCount: integer;
begin
  Result := FIndexes.Count;
end;

procedure TStructure.OpenDS(ATable: TFDTable);
begin
  if ATable.Active then
    Exit;
  ATable.IndexName := '';
  ATable.Open;
  MakeIndex(ATable);
end;

procedure TStructure.MakeIndex(ATable: TFDTable);
var
  IndexName: String;
begin
  if (ATable.IndexDefs.Count = 0) then
  Begin
    IndexName := 'PK_' + ATable.TableName;

    if SameText(ATable.TableName, 'InventoryGoods') then
      FIndexes.Add('CREATE UNIQUE INDEX IF NOT EXISTS ' + IndexName + ' ON ' + ATable.TableName + ' (MovementId, GoodsId, PartNumber COLLATE UTF16NoCase)')
    else
    if SameText(ATable.Fields[0].FieldName, 'Id') and (ATable.Fields[0].DataType <> ftAutoInc) then
      FIndexes.Add('CREATE UNIQUE INDEX IF NOT EXISTS `' + IndexName + '` ON `' + ATable.TableName + '` (`Id`)');
  End;
end;

procedure TStructure.MakeDopIndex(ATable: TFDTable);
begin
//  if SameText(ATable.TableName, 'Object_GoodsListSale') then
//  begin
//    FIndexes.Add('CREATE INDEX IF NOT EXISTS `idx_GoodsListSale_GoodsId` ON `' + ATable.TableName + '` (`GoodsId`)');
//    FIndexes.Add('CREATE INDEX IF NOT EXISTS `idx_GoodsListSale_GoodsKindId` ON `' + ATable.TableName + '` (`GoodsKindId`)');
//    FIndexes.Add('CREATE INDEX IF NOT EXISTS `idx_GoodsListSale_PartnerId` ON `' + ATable.TableName + '` (`PartnerId`)');
//  end
End;

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  InitStructure;
  FConnected := Connect;

  FLimitList := 300;
  FFilterGoods := '';
  FFilterGoodsEAN := False;
end;

procedure TDM.InitStructure;
var
  C: TComponent;
begin
  for C in Self do
    if C is TFDTable then
    begin
      Structure.AddTable((C as TFDTable));
    end;
end;

function TDM.Connect: Boolean;
begin
  if conMain.Connected then
    Exit(True);

  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  conMain.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, DataBaseFileName);
  {$ELSE}
  conMain.Params.Values['Database'] := DataBaseFileName;
  {$ENDIF}

  try
    conMain.Connected := True;
    fdfAnsiUpperCase.Active := True;
    fdcUTF16NoCase.Active := True;
    conMain.ExecSQL('VACUUM;');
  except
    ON E: Exception DO
    begin
//      if not ConnectWithOutDB or not CreateDataBase then
//        Exit(False);
    end;
  end;
  if not conMain.Connected then
    Exit(False);

  if not CheckStructure then
  begin
    conMain.Connected := False;
    Exit(False);
  end
  else
    CreateIndexes;

  result := conMain.Connected;
end;

{ проверка структуры БД }
function TDM.CheckStructure: Boolean;
var
  T: TFDTable;
  F: TField;
  ChangeStructure: Boolean;
  TempTable: TFDTable;
  J: Integer;

  DestDataType: TFDDataType;
  DestSize: LongWord;
  DestPrec, DestScale: Integer;
  DestAttrs: TFDDataAttributes;

  TempTableName: string;
  InsertSQL: string;
  Error: boolean;
begin
  // Check Tables
  qryMeta.Active := False;
  qryMeta.MetaInfoKind := mkTables;
  try
    qryMeta.Active := True;
  except
    ON E: Exception Do
    Begin
      //WriteLogE(E.Message);
      Exit(False);
    End;
  end;
  for T in Structure.DataSets do
  begin
    if not qryMeta.Locate('TABLE_NAME', T.TableName, [loCaseInsensitive]) then
    begin
      try
        T.CreateTable(False);
      except
        ON E: Exception DO
        Begin
          //WriteLog(E.Message);
          Exit(False);
        End;
      end;
    end
    else
    begin
      qryMeta2.Active := False;
      qryMeta2.MetaInfoKind := mkTableFields;
      qryMeta2.ObjectName := T.TableName;
      try
        qryMeta2.Active := True;
      except
        ON E: Exception Do
        Begin
          //WriteLogE(E.Message);
          Exit(False);
        End;
      end;
      ChangeStructure := False;
      for F in T.Fields do
      Begin
        if F.FieldKind <> fkData then
          Continue;
        if not qryMeta2.Locate('TABLE_NAME;COLUMN_NAME',
          VarArrayOf([T.TableName, F.FieldName]), [loCaseInsensitive]) then
        Begin
          ChangeStructure := True;
          break;
        End
        else
        Begin
          TFDFormatOptions.FieldDef2ColumnDef(F, DestDataType, DestSize,
            DestPrec, DestScale, DestAttrs);
          if (Integer(DestDataType) <> qryMeta2.FieldByName('COLUMN_DATATYPE')
            .AsInteger) or
            (Integer(DestSize) <> qryMeta2.FieldByName('COLUMN_LENGTH')
            .AsInteger) then
          Begin
            ChangeStructure := True;
            break;
          End;
        End;
      End;

      if not ChangeStructure then
      begin
        qryMeta2.First;
        while not qryMeta2.Eof do
        Begin
          if (T.FindField(qryMeta2.FieldByName('COLUMN_NAME').AsString) = nil)
            or (T.FindField(qryMeta2.FieldByName('COLUMN_NAME').AsString)
            .FieldKind <> fkData) then
          begin
            ChangeStructure := True;
            break;
          end;
          qryMeta2.Next;
        End;
      end;

      if ChangeStructure then
      Begin
        TempTable := TFDTable.Create(nil);
        T.DisableConstraints;
        Error := false;
        try
          TempTableName := T.TableName + '_temp_for_recreate';
          conMain.ExecSQL('DROP TABLE IF EXISTS ' + TempTableName);
          conMain.ExecSQL('ALTER TABLE ' + T.TableName + ' RENAME TO ' + TempTableName);

          TempTable.Connection := conMain;
          TempTable.TableName := TempTableName;
          TempTable.Open;
          conMain.StartTransaction;
          try
            T.CreateTable(False);
            Structure.OpenDS(T);
            TempTable.First;

            InsertSQL := '';
            for J := 0 to TempTable.FieldCount - 1 do
              if T.FindField(TempTable.Fields[J].FieldName) <> nil then
                InsertSQL := InsertSQL + TempTable.Fields[J].FieldName + ',';

            delete(InsertSQL, Length(InsertSQL), 1);
            InsertSQL := 'insert into ' + T.TableName + ' (' + InsertSQL + ') select ' + InsertSQL + ' from ' + TempTableName;
            conMain.ExecSQL(InsertSQL);

            conMain.Commit;
          except
            on E: Exception do
            Begin
              //WriteLogE(E.Message);
              Error := true;
              conMain.Rollback;
              Exit(False);
            End;
          end;
        finally
          T.EnableConstraints;
          TempTable.Close;
          freeAndNil(TempTable);

          if Error then
          begin
            conMain.ExecSQL('DROP TABLE IF EXISTS ' + T.TableName);
            conMain.ExecSQL('ALTER TABLE ' + TempTableName + ' RENAME TO ' + T.TableName);
          end
          else
          begin
            conMain.ExecSQL('DROP TABLE IF EXISTS ' + TempTableName);
          end;
        end;
      End;
    end;

  end;

  result := True;
end;

{ создание индексов }
procedure TDM.CreateIndexes;
var
  i : integer;
  qryCreateIndex : TFDQuery;
begin
  if Structure.IndexCount > 0 then
  begin
    qryCreateIndex := TFDQuery.Create(nil);
    try
      qryCreateIndex.Connection := DM.conMain;

      for i := 0 to Structure.IndexCount - 1 do
      begin
        qryCreateIndex.SQL.Text := Structure.Indexes[i];
        qryCreateIndex.ExecSQL;
      end;
    finally
      FreeAndNil(qryCreateIndex);
    end;
  end;
end;

procedure TDM.SaveSQLiteData(ASrc: TClientDataSet; ATableName, AUpperField: String);
  var I, J : Integer; S : string;
      AParams: TFDParams;
      Res: TArray<string>;
begin
  if not Connect and not ASrc.Active then Exit;

  Res := TRegEx.Split(AUpperField, ',');

  try
    ASrc.DisableControls;
    try

        // Удаляем новую если вдркг остался мусор
      conMain.ExecSQL('drop table if exists ' + ATableName+ 'New');

        // Создаем новую таблицу
      S :=  'CREATE TABLE ' + ATableName + 'New (';
      for I := 0 to ASrc.FieldCount - 1 do
      begin
        if I > 0 then S := S + ', ';
        S := S + ASrc.Fields.Fields[I].FieldName + ' ';
        case ASrc.Fields.Fields[I].DataType of
          ftInteger, ftLargeint : S := S + 'Integer';
          ftDateTime : S := S + 'DateTime';
          ftString, ftWideString :
            if (ASrc.Fields.Fields[I].Size > 0) and (ASrc.Fields.Fields[I].Size <= 255) then
              S := S + 'NVarChar(255)'
            else S := S + 'TEXT';
          ftMemo, ftWideMemo : S := S + 'TEXT';
          ftFloat, ftCurrency : S := S + 'Float';
          ftBoolean : S := S + 'Boolean';
        else
          ;
        end;
      end;

      for J := 0 to High(Res) do
        S := S + ', ' + Res[J] + 'Upper NVarChar(255)';

      S := S + ')';

      conMain.ExecSQL(S);

        // Заливаем данные построчно т.к. через JSON UTF-8 не проходит
      AParams := TFDParams.Create;
      try
        S :=  '';
        for I := 0 to ASrc.Fields.Count - 1 do
        begin
          if I > 0 then S := S + ', ';
          S := S + ':' + ASrc.Fields.Fields[I].FieldName;
          AParams.Add(ASrc.Fields.Fields[I].FieldName, Null, ptInput);
        end;

        for J := 0 to High(Res) do
        begin
          S := S + ', :' + Res[J] + 'Upper';
          AParams.Add(Res[J] + 'Upper', Null, ptInput);
        end;

        ASrc.First;
        while not ASrc.Eof do
        begin
          for I := 0 to ASrc.Fields.Count - 1 do
            if not ASrc.Fields.Fields[I].IsNull and (ASrc.Fields.Fields[I].DataType in [ftString, ftWideString, ftMemo, ftWideMemo]) then
              AParams.ParamByName(ASrc.Fields.Fields[I].FieldName).AsWideString :=  ASrc.Fields.Fields[I].AsWideString
            else AParams.ParamByName(ASrc.Fields.Fields[I].FieldName).Value :=  ASrc.Fields.Fields[I].Value;

          for J := 0 to High(Res) do
            AParams.ParamByName(Res[J] + 'Upper').AsWideString := AnsiUpperCase(ASrc.FieldByName(Res[J]).AsWideString);

          conMain.ExecSQL('INSERT INTO ' + ATableName + 'New SELECT ' + S, AParams);

          ASrc.Next;
        end;

      finally
        AParams.Free;
      end;

        // Удаляем предыдущий вариант
      conMain.ExecSQL('drop table if exists ' + ATableName);

        // Переименовываем
      conMain.ExecSQL('ALTER TABLE ' + ATableName + 'New RENAME TO ' + ATableName);

    finally
      ASrc.EnableControls;
    end;
  Except on E: Exception do
    raise Exception.Create('Ошибка сохранения в локальную базу. ' + E.Message);
  end;
end;

procedure TDM.LoadSQLiteData(ADst: TClientDataSet; ATableName: String);
  var  DataSetProvider: TDataSetProvider;
       ClientDataSet: TClientDataSet;
       FDQuery: TDataSet;
begin

  if not Connect then Exit;

  try
    try

      // Проверяем наличие таблицы
      conMain.ExecSQL('SELECT * FROM sqlite_master WHERE type = ''table'' AND name= ''' + ATableName + '''', Nil, FDQuery);

      if FDQuery.RecordCount < 1 then Exit;

      FDQuery.Close;
      TFDQuery(FDQuery).SQL.Text := 'select * FROM ' + ATableName;

      DataSetProvider := TDataSetProvider.Create(Application);
      DataSetProvider.Name := 'DataSetProvider';
      DataSetProvider.DataSet := FDQuery;
      ClientDataSet := TClientDataSet.Create(Application);
      ClientDataSet.ProviderName := DataSetProvider.Name;
      try

        ClientDataSet.Active := True;

        ADst.DisableControls;
        if ADst.Active then ADst.Close;
        try
          ADst.AppendData(ClientDataSet.Data, False);
        finally
          ADst.EnableControls;
        end;

      finally
        if Assigned(FDQuery) then FDQuery.Free;
        ClientDataSet.Free;
        DataSetProvider.Free;
      end;
    finally

    end;
  Except on E: Exception do
    raise Exception.Create('Ошибка чтенич из локальной базы. ' + E.Message);
  end;
end;

procedure TDM.LoadSQLite(ADst: TClientDataSet; ASQL: String);
  var  DataSetProvider: TDataSetProvider;
       ClientDataSet: TClientDataSet;
       FDQuery: TFDQuery;
begin

  if not Connect then Exit;

  FDQuery := TFDQuery.Create(nil);
  FDQuery.Connection := DM.conMain;
  FDQuery.SQL.Text := ASQL;
  try

    FDQuery := TFDQuery.Create(nil);
    FDQuery.Connection := DM.conMain;
    FDQuery.SQL.Text := ASQL;

    DataSetProvider := TDataSetProvider.Create(Application);
    DataSetProvider.Name := 'DataSetProvider';
    DataSetProvider.DataSet := FDQuery;
    ClientDataSet := TClientDataSet.Create(Application);
    ClientDataSet.ProviderName := DataSetProvider.Name;
    try

      ClientDataSet.Active := True;

      ADst.DisableControls;
      if ADst.Active then ADst.Close;
      try
        ADst.AppendData(ClientDataSet.Data, False);
      finally
        ADst.EnableControls;
      end;

    finally
      FDQuery.Free;
      ClientDataSet.Free;
      DataSetProvider.Free;
    end;
  Except on E: Exception do
    raise Exception.Create('Ошибка чтенич из локальной базы. ' + E.Message);
  end;
end;

{ получение текущей версии программы }
function TDM.GetCurrentVersion: string;
{$IFDEF ANDROID}
var
  PackageManager: JPackageManager;
  PackageInfo : JPackageInfo;
{$ENDIF}
begin
  {$IFDEF ANDROID}
  PackageManager := TAndroidHelper.Activity.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName(), TJPackageManager.JavaClass.GET_ACTIVITIES);
  Result := JStringToString(PackageInfo.versionName);
  {$ELSE}
  Result := '1.0.0.0';
  {$ENDIF}
end;

{ получение версии программы с сервера}
function TDM.GetMobileVersion : String;
var
  StoredProc : TdsdStoredProc;
begin
  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otResult;

    StoredProc.StoredProcName := 'gpGetMobile_BoatMobile_Version';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('MajorVersion', ftString, ptOutput, '');
    StoredProc.Params.AddParam('MinorVersion', ftString, ptOutput, '');

    try
      StoredProc.Execute(false, false, false);

      if StoredProc.Params.ParamByName('MajorVersion').Value > 65536 then
        Result := IntToStr(StoredProc.Params.ParamByName('MajorVersion').Value div 65536) + '.'
      else Result := '';

      Result := Result + IntToStr(StoredProc.Params.ParamByName('MajorVersion').Value MOD 65536) + '.';
      Result := Result + IntToStr(StoredProc.Params.ParamByName('MinorVersion').Value DIV 65536) + '.';
      Result := Result + IntToStr(StoredProc.Params.ParamByName('MinorVersion').Value MOD 65536);
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
  end;
end;

{ получение названия файла APK программы с сервера}
function TDM.GetAPKFileName : String;
var
  StoredProc : TdsdStoredProc;
begin
  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otResult;

    StoredProc.StoredProcName := 'gpGetMobile_BoatMobile_Version';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('APKFileName', ftString, ptOutput, '');

    try
      StoredProc.Execute(false, false, false);
      Result := StoredProc.Params.ParamByName('APKFileName').Value;
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
  end;
end;

{ проверка необходимо ли обновление программы }
procedure TDM.CheckUpdate;
begin
  if CompareVersion(GetCurrentVersion, GetMobileVersion) > 0 then
    TDialogService.MessageDialog('Обнаружена новая версия программы! Обновить?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbYes, 0, UpdateProgram);
end;

{ сравнение версий }
function TDM.CompareVersion(ACurVersion, AServerVersion: string): integer;
var
  ArrValueC, ArrValueS : TArray<string>;
  MajorC, MinorC, ReleaseC, BuildC,
  MajorS, MinorS, ReleaseS, BuildS : integer;
begin
  ArrValueC := ACurVersion.Split(['.']);
  ArrValueS := AServerVersion.Split(['.']);
  //major
  if Length(ArrValueC) > 0 then
    MajorC := StrToIntDef(ArrValueC[0], 0)
  else
    MajorC := 0;
  if Length(ArrValueS) > 0 then
    MajorS := StrToIntDef(ArrValueS[0], 0)
  else
    MajorS := 0;
  //minor
  if Length(ArrValueC) > 1 then
    MinorC := StrToIntDef(ArrValueC[1], 0)
  else
    MinorC := 0;
  if Length(ArrValueS) > 1 then
    MinorS := StrToIntDef(ArrValueS[1], 0)
  else
    MinorS := 0;
  //release
  if Length(ArrValueC) > 2 then
    ReleaseC := StrToIntDef(ArrValueC[2], 0)
  else
    ReleaseC := 0;
  if Length(ArrValueS) > 2 then
    ReleaseS := StrToIntDef(ArrValueS[2], 0)
  else
    ReleaseS := 0;
  //build
  if Length(ArrValueC) > 3 then
    BuildC := StrToIntDef(ArrValueC[3], 0)
  else
    BuildC := 0;
  if Length(ArrValueS) > 3 then
    BuildS := StrToIntDef(ArrValueS[3], 0)
  else
    BuildS := 0;

  if (MajorC = MajorS) and (MinorC = MinorS) and (ReleaseC = ReleaseS) and (BuildC = BuildS) then
    Result := 0
  else
  if (MajorC > MajorS) or ((MajorC = MajorS) and (MinorC > MinorS)) or
     ((MajorC = MajorS) and (MinorC = MinorS) and (ReleaseC > ReleaseS)) or
     ((MajorC = MajorS) and (MinorC = MinorS) and (ReleaseC = ReleaseS) and (BuildC > BuildS))
  then
    Result := -1
  else
    Result := 1;
end;

procedure TDM.UpdateProgram(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    WaitThread := TWaitThread.Create(true);
    WaitThread.FreeOnTerminate := true;
    WaitThread.TaskName := 'UpdateProgram';
    WaitThread.Start;
  end;
end;

{ начитка товаров }
function TDM.DownloadGoods : Boolean;
begin
  WaitThread := TWaitThread.Create(true);
  WaitThread.FreeOnTerminate := true;
  WaitThread.TaskName := 'LoadGoods';
  WaitThread.Start;
  Result := True;
end;


function TDM.GetInventoryActive(AisCreate : Boolean) : Boolean;
var
  StoredProc : TdsdStoredProc;
begin

  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otResult;

    StoredProc.StoredProcName := 'gpInsertUpdate_Movement_MobileInventory';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inisCreateNew', ftBoolean, ptInput, AisCreate);
    StoredProc.Params.AddParam('outMovementId', ftInteger, ptOutput, 0);

    try
      StoredProc.Execute(false, false, false);
      Result := StoredProc.ParamByName('outMovementId').Value <> 0;
      if Result then
        Result := DownloadInventory(StoredProc.ParamByName('outMovementId').Value);
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
  end;
end;

{ начитка журнала инвентаризаций }
function TDM.DownloadInventoryJournal : Boolean;
var
  StoredProc : TdsdStoredProc;
  nId: Integer;
begin

  if cdsInventoryJournal.Active and not cdsInventoryJournal.IsEmpty then
    nID := DM.cdsInventoryJournalId.AsInteger
  else nID := 0;

  StoredProc := TdsdStoredProc.Create(nil);
  cdsInventoryJournal.DisableControls;
  try
    StoredProc.OutputType := otDataSet;

    StoredProc.StoredProcName := 'gpSelect_Movement_MobileInventory';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inStartDate', ftDateTime, ptInput, frmMain.deInventoryStartDate.Date);
    StoredProc.Params.AddParam('inEndDate', ftDateTime, ptInput, frmMain.deInventoryEntDate.Date);
    StoredProc.Params.AddParam('inIsErased', ftBoolean, ptInput, False);
    StoredProc.DataSet := cdsInventoryJournal;

    try
      StoredProc.Execute(false, false, false);
      Result := cdsInventoryJournal.Active;
      if Result and (nID <> 0) then cdsInventoryJournal.Locate('Id', nId, [])
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
    cdsInventoryJournal.EnableControls;
  end;
end;

{ начитка инвентаризации}
function TDM.DownloadInventory(AId : Integer = 0) : Boolean;
var
  StoredProc : TdsdStoredProc;
  nId: Integer;
begin

  if AId <> 0 then
    nId := AId
  else  if cdsInventory.Active and not cdsInventory.IsEmpty then
    nID := DM.cdsInventoryId.AsInteger
  else nID := DM.cdsInventoryJournalId.AsInteger;

  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otDataSet;

    StoredProc.StoredProcName := 'gpGet_Movement_MobileInventory';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inMovementId', ftInteger, ptInput, nID);
    StoredProc.DataSet := cdsInventory;

    try
      StoredProc.Execute(false, false, false);
      Result := cdsInventory.Active;
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
  end;
end;

{ начитка строк инвентаризации}
function TDM.DownloadInventoryList : Boolean;
var
  StoredProc : TdsdStoredProc;
  nId: Integer;
begin

  Result := False;
  if not cdsInventory.Active or cdsInventory.IsEmpty then Exit;

  if cdsInventoryList.Active and not cdsInventoryList.IsEmpty then
    nID := DM.cdsInventoryId.AsInteger
  else nID := 0;

  StoredProc := TdsdStoredProc.Create(nil);
  cdsInventoryList.DisableControls;
  try
    StoredProc.OutputType := otDataSet;

    StoredProc.StoredProcName := 'gpSelect_MovementItem_MobileInventory';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inMovementId', ftInteger, ptInput, DM.cdsInventoryId.AsInteger);
    StoredProc.Params.AddParam('inIsErased', ftBoolean, ptInput, False);
    StoredProc.DataSet := cdsInventoryList;

    try
      StoredProc.Execute(false, false, false);
      Result := cdsInventoryList.Active;
      if Result and (nID <> 0) then cdsInventoryList.Locate('Id', nId, [])
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
    cdsInventoryList.EnableControls;
  end;
end;

{ начитка внутреннего заказа + производство}
function TDM.DownloadOrderInternal(AId : Integer) : Boolean;
var
  StoredProc : TdsdStoredProc;
begin

  Result := False;
  if AId = 0 then Exit;

  StoredProc := TdsdStoredProc.Create(nil);
  cdsOrderInternal.DisableControls;
  try
    StoredProc.OutputType := otDataSet;

    StoredProc.StoredProcName := 'gpGet_MovementItem_MobileOrderInternal';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inMovementItemId', ftInteger, ptInput, AId);
    StoredProc.DataSet := cdsOrderInternal;

    try
      StoredProc.Execute(false, false, false);
      Result := cdsOrderInternal.Active;
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
    cdsOrderInternal.EnableControls;
  end;
end;

{ Создание документа производства}
function TDM.InsertProductionUnion(AId : Integer) : Boolean;
var
  StoredProc : TdsdStoredProc;
begin

  Result := False;
  if AId = 0 then Exit;

  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otResult;

    StoredProc.StoredProcName := 'gpInsertUpdate_Movement_MobileProductionUnion';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inMovementItemId', ftInteger, ptInput, AId);
    StoredProc.DataSet := cdsOrderInternal;

    try
      StoredProc.Execute(false, false, false);
      Result := True;
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
  end;
end;

procedure TDM.fdfAnsiUpperCaseCalculate(AFunc: TSQLiteFunctionInstance;
  AInputs: TSQLiteInputs; AOutput: TSQLiteOutput; var AUserData: TObject);
begin
  AOutput.AsString := AnsiUpperCase(AInputs[0].AsString);
end;

function TDM.LoadGoodsList : Boolean;
  var sql: string;
begin
  Result := False;
  if (frmMain.DateDownloadGoods >= IncDay(Now, - 1)) then
  begin
    cdsGoodsList.DisableControls;
    try
      cdsGoodsList.Close;
      cdsGoodsList.CreateDataSet;

      sql := 'SELECT Id, Code, Name, Article, EAN, GoodsGroupName, MeasureName FROM Goods';
      sql := sql + #13#10'WHERE isErased = 0';

      if FFilterGoods <> '' then
      begin
        if not FFilterGoodsEAN then
        begin
          sql := sql + #13#10'and (';
          sql := sql + #13#10' NameUpper LIKE ''%' + AnsiUpperCase(FFilterGoods) + '%''';
          sql := sql + #13#10'OR Article LIKE ''%' + AnsiUpperCase(FFilterGoods) + '%''';
          sql := sql + #13#10'OR EAN LIKE ''%' + AnsiUpperCase(FFilterGoods) + '%''';
          sql := sql + #13#10'OR Code LIKE ''%' + AnsiUpperCase(FFilterGoods) + '%''';
          sql := sql + #13#10')';
        end else sql := sql + #13#10'AND EAN LIKE ''%' + AnsiUpperCase(FFilterGoods) + '%''';
      end;

      sql := sql + #13#10'ORDER BY NameUpper';
      sql := sql + #13#10'LIMIT ' + IntToStr(FLimitList);

      LoadSQLite(cdsGoodsList, sql);

      Result := cdsGoodsList.Active;
      if cdsGoodsList.RecordCount >= FLimitList then
        frmMain.lGoodsSelect.Text := 'Выборка первых ' + IntToStr(FLimitList) + ' комплектующих'
      else frmMain.lGoodsSelect.Text := 'Найдено ' + IntToStr(cdsGoodsList.RecordCount) + ' комплектующих';
      if FFilterGoodsEAN then frmMain.lGoodsSelect.Text := frmMain.lGoodsSelect.Text + ' по штрихкоду'
    finally
      cdsGoodsList.EnableControls;
    end;
  end else DM.DownloadGoods;
end;

procedure TDM.LoadGoods;
begin

  if (frmMain.DateDownloadGoods >= IncDay(Now, - 1)) then
  begin

    LoadSQLiteData(cdsGoods, 'Goods');
    if not cdsGoods.Active then DownloadGoods;

  end else DownloadGoods;
end;

// Иницилизация хранилища результатов сканирования
procedure TDM.OpenInventoryGoods;
begin
  qryInventoryGoods.Close;
  qryInventoryGoods.ParamByName('MovementId').Value := cdsInventoryId.AsInteger;
  qryInventoryGoods.Open;
end;

procedure TDM.qryInventoryGoodsCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('DeleteId').AsInteger := 0;
end;

// Добавить товар для вставки в инвентаризацию
procedure TDM.AddInventoryGoods(AGoodsId : Integer; AAmount: Currency; APartNumber : String);
  var FDQuery: TFDQuery;
begin

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := conMain;
    FDQuery.SQL.Text := 'Select * FROM InventoryGoods ' +
                        'WHERE MovementId = :MovementId AND GoodsId = :GoodsId AND AnsiUpperCase(PartNumber) = AnsiUpperCase(:PartNumber)';
    FDQuery.ParamByName('MovementId').AsInteger := cdsInventoryId.AsInteger;
    FDQuery.ParamByName('GoodsId').AsInteger := AGoodsId;
    FDQuery.ParamByName('PartNumber').AsString := APartNumber;
    FDQuery.Open;

    if FDQuery.IsEmpty then
    begin
      FDQuery.Insert;
      FDQuery.FieldByName('MovementId').AsInteger := cdsInventoryId.AsInteger;
      FDQuery.FieldByName('GoodsId').AsInteger := AGoodsId;
      FDQuery.FieldByName('PartNumber').AsString := APartNumber;
      FDQuery.FieldByName('Amount').AsFloat := AAmount;
      FDQuery.Post;
    end else
    begin
      FDQuery.Edit;
      FDQuery.FieldByName('Amount').AsFloat := FDQuery.FieldByName('Amount').AsFloat + AAmount;
      FDQuery.Post;
    end;

  finally
    FDQuery.Free;
  end;

  qryInventoryGoods.DisableControls;
  try
    OpenInventoryGoods;
    qryInventoryGoods.Locate('MovementId;GoodsId;PartNumber', VarArrayOf([cdsInventoryId.AsInteger, AGoodsId, APartNumber]), [loCaseInsensitive])
  finally
    qryInventoryGoods.EnableControls;
  end;
end;

// Добавить товар для вставки в инвентаризацию
procedure TDM.UpdateInventoryGoods(AAmount: Currency);
  var FDQuery: TFDQuery;
      nMovementId, nGoodsId: Integer;
      cPartNumber: String;
begin

  if qryInventoryGoods.Active and not qryInventoryGoods.IsEmpty then
  begin
    FDQuery := TFDQuery.Create(nil);
    try
      FDQuery.Connection := conMain;
      FDQuery.SQL.Text := 'Select * FROM InventoryGoods ' +
                          'WHERE MovementId = :MovementId AND GoodsId = :GoodsId AND AnsiUpperCase(PartNumber) = AnsiUpperCase(:PartNumber)';
      FDQuery.ParamByName('MovementId').AsInteger := qryInventoryGoods.FieldByName('MovementId').AsInteger;
      FDQuery.ParamByName('GoodsId').AsInteger := qryInventoryGoods.FieldByName('GoodsId').AsInteger;
      FDQuery.ParamByName('PartNumber').AsString := qryInventoryGoods.FieldByName('PartNumber').AsString;
      FDQuery.Open;

      if not FDQuery.IsEmpty then
      begin
        FDQuery.Edit;
        FDQuery.FieldByName('Amount').AsFloat := AAmount;
        FDQuery.Post;
      end;

    finally
      FDQuery.Free;
    end;

    qryInventoryGoods.DisableControls;
    try
      nMovementId := qryInventoryGoods.FieldByName('MovementId').AsInteger;
      nGoodsId := qryInventoryGoods.FieldByName('GoodsId').AsInteger;
      cPartNumber := qryInventoryGoods.FieldByName('PartNumber').AsString;

      OpenInventoryGoods;
      qryInventoryGoods.Locate('MovementId;GoodsId;PartNumber', VarArrayOf([nMovementId, nGoodsId, cPartNumber]), [loCaseInsensitive])
    finally
      qryInventoryGoods.EnableControls;
    end;
  end;
end;

procedure TDM.DeleteInventoryGoods;
  var FDQuery: TFDQuery;
      nPos: Integer;
begin

  if qryInventoryGoods.Active and not qryInventoryGoods.IsEmpty then
  begin
    FDQuery := TFDQuery.Create(nil);
    try
      FDQuery.Connection := conMain;
      FDQuery.SQL.Text := 'Select * FROM InventoryGoods ' +
                          'WHERE MovementId = :MovementId AND GoodsId = :GoodsId AND AnsiUpperCase(PartNumber) = AnsiUpperCase(:PartNumber)';
      FDQuery.ParamByName('MovementId').AsInteger := qryInventoryGoods.FieldByName('MovementId').AsInteger;
      FDQuery.ParamByName('GoodsId').AsInteger := qryInventoryGoods.FieldByName('GoodsId').AsInteger;
      FDQuery.ParamByName('PartNumber').AsString := qryInventoryGoods.FieldByName('PartNumber').AsString;
      FDQuery.Open;

      if not FDQuery.IsEmpty then FDQuery.Delete;

    finally
      FDQuery.Free;
    end;

    nPos := qryInventoryGoods.RecNo - 1;
    qryInventoryGoods.DisableControls;
    try
      OpenInventoryGoods;
      if (nPos > 0) and (nPos < qryInventoryGoods.RecordCount) then qryInventoryGoods.RecNo := nPos;
    finally
      qryInventoryGoods.EnableControls;
    end;
  end;
end;

// Проверим необходимость отправки инвентаризаций
function TDM.isInventoryGoodsSend : Boolean;
  var FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := conMain;
    FDQuery.SQL.Text := 'Select * FROM InventoryGoods LIMIT 1';
    FDQuery.Open;

    Result := FDQuery.IsEmpty;

  finally
    FDQuery.Free;
  end;
end;

procedure TDM.UploadAllData;
begin
  WaitThread := TWaitThread.Create(true);
  WaitThread.FreeOnTerminate := true;
  WaitThread.TaskName := 'UploadAll';
  WaitThread.Start;
end;

procedure TDM.UploadInventoryGoods;
begin
  WaitThread := TWaitThread.Create(true);
  WaitThread.FreeOnTerminate := true;
  WaitThread.TaskName := 'UploadInventoryGoods';
  WaitThread.Start;
end;

initialization
  Structure := TStructure.Create;
  Randomize;
finalization
  FreeAndNil(Structure);
end.
