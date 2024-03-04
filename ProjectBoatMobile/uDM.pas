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
  FMX.Forms, FireDAC.Phys.SQLiteWrapper
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
    cdsInventoryGoods: TClientDataSet;
    cdsInventoryUnitId: TIntegerField;
    cdsGoods: TClientDataSet;
    cdsGoodsId: TIntegerField;
    cdsGoodsCode: TIntegerField;
    cdsGoodsName: TWideStringField;
    cdsGoodsArticle: TWideStringField;
    cdsGoodsEAN: TWideStringField;
    cdsGoodsGoodsGroupName: TWideStringField;
    cdsGoodsMeasureName: TWideStringField;
    cdsInventoryGoodsGoodsId: TIntegerField;
    cdsInventoryGoodsGoodsCode: TIntegerField;
    cdsInventoryGoodsGoodsName: TWideStringField;
    cdsInventoryGoodsArticle: TWideStringField;
    cdsInventoryGoodsEAN: TWideStringField;
    cdsInventoryGoodsGoodsGroupName: TWideStringField;
    cdsInventoryGoodsMeasureName: TWideStringField;
    cdsInventoryGoodsAmount: TFloatField;
    cdsInventoryGoodsPartNumber: TWideStringField;
    cdsInventoryListPartNumber: TWideStringField;
    cdsInventoryGoodsMovementId: TIntegerField;
    cdsInventoryGoodsisSend: TBooleanField;
    cdsInventoryGoodsDeleteId: TIntegerField;
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
    procedure DataModuleCreate(Sender: TObject);
    procedure fdfAnsiUpperCaseCalculate(AFunc: TSQLiteFunctionInstance;
      AInputs: TSQLiteInputs; AOutput: TSQLiteOutput; var AUserData: TObject);
  private
    { Private declarations }
    FInventoryGoodsFile: String;
    FFilterGoods: String;
    FFilterGoodsEAN: Boolean;
    FLimitList : Integer;
  public
    { Public declarations }
    function Connect: Boolean;
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

    function GetInventoryActive(AisCreate : Boolean) : Boolean;


    function LoadGoodsList : Boolean;

    procedure LoadGoods;

    procedure InitInventoryGoods;
    procedure SaveInventoryGoods;
    procedure AddInventoryGoods(AGoodsId : Integer; AAmount, APartNumber : String);
    procedure DeleteInventoryGoods;
    function isInventoryGoodsSend : Boolean;

    procedure UploadAllData;
    procedure UploadInventoryGoods;

    property FilterGoods : String read FFilterGoods write FFilterGoods;
    property FilterGoodsEAN : Boolean read FFilterGoodsEAN write FFilterGoodsEAN default False;
    property LimitList : Integer read FLimitList write FLimitList default 300;

  end;

var
  DM: TDM;
  ProgressThread : TProgressThread;
  WaitThread : TWaitThread;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses System.IOUtils, System.DateUtils, System.ZLib, System.RegularExpressions,
     FMX.Dialogs, uMain;

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
        Result := E.Message;
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
      Result := E.Message;
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
  CDS: TClientDataSet;
begin

  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otResult;

    CDS := TClientDataSet.Create(Nil);
    StoredProc.StoredProcName := 'gpInsertUpdate_MovementItem_MobileInventory';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('ioId', ftInteger, ptInputOutput, 0);
    StoredProc.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
    StoredProc.Params.AddParam('inGoodsId', ftInteger, ptInput, 0);
    StoredProc.Params.AddParam('inAmount', ftFloat, ptInput, 0);
    StoredProc.Params.AddParam('inPartNumber', ftWideString, ptInput, '');

    try
      CDS.LoadFromFile(DM.FInventoryGoodsFile);
      if CDS.IsEmpty then Exit;
      CDS.IndexFieldNames := 'MovementId;GoodsId;PartNumber';
      CDS.Filter := 'isSend = False';
      CDS.Filtered := True;
      CDS.First;
      while not CDS.Eof do
      begin
        StoredProc.ParamByName('ioId').Value := 0;
        StoredProc.ParamByName('inMovementId').Value := CDS.FieldByName('MovementId').AsInteger;
        StoredProc.ParamByName('inGoodsId').Value := CDS.FieldByName('GoodsId').AsInteger;
        StoredProc.ParamByName('inAmount').Value := CDS.FieldByName('Amount').AsInteger;
        StoredProc.ParamByName('inPartNumber').Value := CDS.FieldByName('PartNumber').AsString;
        StoredProc.Execute(false, false, false);

        CDS.Edit;
        CDS.FieldByName('isSend').AsBoolean := True;
        CDS.Post;
        CDS.SaveToFile(DM.FInventoryGoodsFile);

        CDS.First;
      end;

      CDS.Filtered := False;
      CDS.Filter := 'isSend = True';
      CDS.Filtered := True;
      while not CDS.Eof do CDS.Delete;

    except
      on E : Exception do
      begin
        Result := E.Message;
      end;
    end;
  finally
    CDS.SaveToFile(DM.FInventoryGoodsFile);
    FreeAndNil(StoredProc);
    FreeAndNil(CDS);
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

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  FLimitList := 300;
  FFilterGoods := '';
  FFilterGoodsEAN := False;
  // Определим имена файлов
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FInventoryGoodsFile := TPath.Combine(TPath.GetDocumentsPath, 'InventoryGoods.dat');
  {$ELSE}
  FInventoryGoodsFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'InventoryGoods.dat');
  {$ENDIF}
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
    conMain.ExecSQL('VACUUM;');
    fdfAnsiUpperCase.Active := True;
  except
    ON E: Exception DO
    begin
//      if not ConnectWithOutDB or not CreateDataBase then
//        Exit(False);
    end;
  end;
  if not conMain.Connected then
    Exit(False);


  result := conMain.Connected;
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
              S := S + 'VarWideChar(255)'
            else S := S + 'TEXT';
          ftMemo, ftWideMemo : S := S + 'TEXT';
          ftFloat, ftCurrency : S := S + 'Float';
          ftBoolean : S := S + 'Boolean';
        else
          ;
        end;
      end;

      for J := 0 to High(Res) do
        S := S + ', ' + Res[J] + 'Upper VarWideChar(255)';

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
      conMain.ExecSQL('SELECT COUNT(*) AS CounrTable FROM sqlite_master WHERE type = ''table'' AND name= ''' + ATableName + '''', Nil, FDQuery);

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
    StoredProc.Params.AddParam('inisCreateNew', ftBoolean, ptInput, False);
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

  end else DownloadGoods;
end;

// Иницилизация хранилища результатов сканирования
procedure TDM.InitInventoryGoods;
begin

  if not cdsInventoryGoods.Active then
  begin

    if FileExists(FInventoryGoodsFile) then cdsInventoryGoods.LoadFromFile(FInventoryGoodsFile);

    if not cdsInventoryGoods.Active then cdsInventoryGoods.CreateDataSet;

    try
      cdsInventoryGoods.Filtered := False;
      cdsInventoryGoods.Filter := 'isSend = True';
      cdsInventoryGoods.Filtered := True;
      while not cdsInventoryGoods.Eof do cdsInventoryGoods.Delete;
    finally
      cdsInventoryGoods.Filtered := False;
      cdsInventoryGoods.Filter := '';
    end;
  end;

  cdsInventoryGoods.Filtered := False;
  cdsInventoryGoods.Filter := 'MovementId = ' + cdsInventoryId.AsString;
  cdsInventoryGoods.Filtered := True;
end;

// Сохраним введенные данные по инвентаризации
procedure TDM.SaveInventoryGoods;
begin

  if cdsInventoryGoods.Active then
  begin

    cdsInventoryGoods.SaveToFile(FInventoryGoodsFile);
  end;
end;


// Добавить товар для вставки в инвентаризацию
procedure TDM.AddInventoryGoods(AGoodsId : Integer; AAmount, APartNumber : String);
  var nAmount : Currency;
begin

    if not TryStrToCurr(AAmount, nAmount) then nAmount := 1;

    if not cdsGoods.Active then LoadSQLiteData(cdsGoods, 'Goods');;

    if not cdsGoods.Locate('Id', AGoodsId, []) then
    begin
      raise Exception.Create('Ошибка позиционироания на товар.');
    end;

    if cdsInventoryGoods.Locate('MovementId;GoodsId;PartNumber', VarArrayOf([cdsInventoryId.AsInteger,cdsGoodsId.AsInteger,APartNumber]), []) then
    begin
      cdsInventoryGoods.Edit;
      if cdsInventoryGoodsisSend.AsBoolean = False then
        cdsInventoryGoodsAmount.AsFloat := cdsInventoryGoodsAmount.AsFloat + nAmount
      else cdsInventoryGoodsAmount.AsFloat := nAmount;
      cdsInventoryGoodsisSend.AsBoolean := False;
      cdsInventoryGoods.Post;
    end else
    begin
      cdsInventoryGoods.Last;
      cdsInventoryGoods.Append;
      cdsInventoryGoodsMovementId.AsInteger := cdsInventoryId.AsInteger;
      cdsInventoryGoodsGoodsId.AsInteger := cdsGoodsId.AsInteger;
      cdsInventoryGoodsGoodsCode.AsInteger := cdsGoodsCode.AsInteger;
      cdsInventoryGoodsGoodsName.AsString := cdsGoodsName.AsString;
      cdsInventoryGoodsGoodsGroupName.AsString := cdsGoodsGoodsGroupName.AsString;
      cdsInventoryGoodsArticle.AsString := cdsGoodsArticle.AsString;
      cdsInventoryGoodsMeasureName.AsString := cdsGoodsMeasureName.AsString;
      cdsInventoryGoodsAmount.AsFloat := nAmount;
      cdsInventoryGoodsPartNumber.AsString := APartNumber;
      cdsInventoryGoodsisSend.AsBoolean := False;
      cdsInventoryGoodsDeleteId.AsInteger := 0;
      cdsInventoryGoods.Post;
    end;

    SaveInventoryGoods;
end;



procedure TDM.DeleteInventoryGoods;
begin
  if cdsInventoryGoods.Active and not cdsInventoryGoods.IsEmpty then
  begin
    cdsInventoryGoods.Delete;
    SaveInventoryGoods;
  end;
end;

// Проверим необходимость отправки инвентаризаций
function TDM.isInventoryGoodsSend : Boolean;
begin

  try
    if cdsInventoryGoods.Active then cdsInventoryGoods.Close;

    if FileExists(FInventoryGoodsFile) then cdsInventoryGoods.LoadFromFile(FInventoryGoodsFile);

    if not cdsInventoryGoods.Active then cdsInventoryGoods.CreateDataSet;

    Result := not cdsInventoryGoods.Locate('isSend', False, []);
  finally
    cdsInventoryGoods.Close;
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

end.
