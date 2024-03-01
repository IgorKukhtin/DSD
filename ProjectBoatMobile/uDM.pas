unit uDM;

interface

uses
  System.SysUtils, System.Classes, FMX.DialogService, System.UITypes,
  Data.DB, dsdDB, Datasnap.DBClient, System.Variants
  {$IFDEF ANDROID}
  , Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
  Androidapi.JNI.Net, Androidapi.JNI.JavaTypes, Androidapi.JNI.App,
  Androidapi.JNI.Support
  {$ENDIF};

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
    cdsGoodsisErased: TBooleanField;
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
    cdsGoodsListisErased: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FGoodsFile: String;
    FInventoryGoodsFile: String;
  public
    { Public declarations }
    function GetCurrentVersion: string;
    function GetMobileVersion : String;
    function GetAPKFileName : String;
    procedure CheckUpdate;
    function CompareVersion(ACurVersion, AServerVersion: string): integer;
    procedure UpdateProgram(const AResult: TModalResult);

    function DownloadGoods : Boolean;
    function DownloadInventoryJournal : Boolean;
    function DownloadInventory : Boolean;
    function DownloadInventoryList : Boolean;

    function LoadGoodsList : Boolean;

    procedure LoadGoods;
    procedure SaveGoods;

    procedure InitInventoryGoods;
    procedure SaveInventoryGoods;
    procedure AddInventoryGoods(AList : Boolean = False);
    procedure DeleteInventoryGoods;
    function isInventoryGoodsSend : Boolean;

    procedure UploadAllData;
    procedure UploadInventoryGoods;
  end;

var
  DM: TDM;
  ProgressThread : TProgressThread;
  WaitThread : TWaitThread;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses System.IOUtils, System.DateUtils, System.ZLib, FMX.Dialogs, uMain;

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
  nId: Integer;
begin

  if DM.cdsGoods.Active and not DM.cdsGoods.IsEmpty then
    nID := DM.cdsGoodsId.AsInteger
  else nID := 0;

  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otDataSet;

    StoredProc.StoredProcName := 'gpSelect_Object_MobileGoods';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inIsErased', ftBoolean, ptInput, False);
    StoredProc.DataSet := DM.cdsGoods;

    try
      StoredProc.Execute(false, false, false);
      if DM.cdsGoods.Active and (nID <> 0) then DM.cdsGoods.Locate('Id', nId, [])
    except
      on E : Exception do
      begin
        Result := E.Message;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
    DM.SaveGoods;
    frmMain.DateDownloadGoods := Now;
    if frmMain.tcMain.ActiveTab = frmMain.tiGoods then TaskName := 'LoadGoodsList';
  end;
end;

// Открытие справочника Комплектующих
function TWaitThread.LoadGoodsList: string;
  var nID: Integer;
begin
  frmMain.lwGoods.Visible := False;
  //frmMain.lwGoods.BeginUpdate;
  try
    if DM.cdsGoodsList.Active then nID := DM.cdsGoodsListId.AsInteger
    else nID := 0;
    DM.cdsGoodsList.Close;
    if not DM.cdsGoods.Active then DM.LoadGoods;
    //DM.cdsGoodsList.DisableControls;
    if DM.cdsGoods.Active then DM.cdsGoodsList.AppendData(DM.cdsGoods.Data, False);
  finally
    if DM.cdsGoodsList.Active and (nID <> 0) then DM.cdsGoodsList.Locate('Id', nId, []);
    //DM.cdsGoodsList.EnableControls;
    //frmMain.lwGoods.EndUpdate;
    Synchronize(procedure
              begin
                frmMain.lwGoods.Visible := True;
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
  // Определим имена файлов
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FGoodsFile := TPath.Combine(TPath.GetDocumentsPath, 'Goods.dat');
  FInventoryGoodsFile := TPath.Combine(TPath.GetDocumentsPath, 'InventoryGoods.dat');
  {$ELSE}
  FGoodsFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'Goods.dat');
  FInventoryGoodsFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'InventoryGoods.dat');
  {$ENDIF}
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
function TDM.DownloadInventory : Boolean;
var
  StoredProc : TdsdStoredProc;
  nId: Integer;
begin

  if cdsInventory.Active and not cdsInventory.IsEmpty then
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

function TDM.LoadGoodsList : Boolean;
begin
  if (frmMain.DateDownloadGoods >= IncDay(Now, - 1)) then
  begin
    WaitThread := TWaitThread.Create(true);
    WaitThread.FreeOnTerminate := true;
    WaitThread.TaskName := 'LoadGoodsList';
    WaitThread.Start;
    Result := True;
  end else DM.DownloadGoods;
end;

procedure TDM.LoadGoods;
begin

  if (frmMain.DateDownloadGoods >= IncDay(Now, - 1)) then
  begin

    if FileExists(FGoodsFile) then cdsGoods.LoadFromFile(FGoodsFile);

  end else DownloadGoods;
end;

procedure TDM.SaveGoods;
begin

  if cdsGoods.Active then
  begin
    cdsGoods.SaveToFile(FGoodsFile);
  end;
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
procedure TDM.AddInventoryGoods(AList : Boolean = False);
  var nAmount : Currency;
begin

  if TryStrToCurr(frmMain.edInventScanАmount.Text, nAmount) then nAmount := 1;

  if AList then
  begin
    if cdsInventoryGoods.Locate('MovementId;GoodsId;PartNumber', VarArrayOf([cdsInventoryId.AsInteger,cdsGoodsListId.AsInteger,frmMain.edInventScanPartNumber.Text]), []) then
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
      cdsInventoryGoodsGoodsId.AsInteger := cdsGoodsListId.AsInteger;
      cdsInventoryGoodsGoodsCode.AsInteger := cdsGoodsListCode.AsInteger;
      cdsInventoryGoodsGoodsName.AsString := cdsGoodsListName.AsString;
      cdsInventoryGoodsGoodsGroupName.AsString := cdsGoodsListGoodsGroupName.AsString;
      cdsInventoryGoodsArticle.AsString := cdsGoodsListArticle.AsString;
      cdsInventoryGoodsMeasureName.AsString := cdsGoodsListMeasureName.AsString;
      cdsInventoryGoodsAmount.AsFloat := nAmount;
      cdsInventoryGoodsPartNumber.AsString := frmMain.edInventScanPartNumber.Text;
      cdsInventoryGoodsisSend.AsBoolean := False;
      cdsInventoryGoodsDeleteId.AsInteger := 0;
      cdsInventoryGoods.Post;
    end;
  end else
  begin
    if cdsInventoryGoods.Locate('MovementId;GoodsId;PartNumber', VarArrayOf([cdsInventoryId.AsInteger,cdsGoodsId.AsInteger,frmMain.edInventScanPartNumber.Text]), []) then
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
      cdsInventoryGoodsPartNumber.AsString := frmMain.edInventScanPartNumber.Text;
      cdsInventoryGoodsisSend.AsBoolean := False;
      cdsInventoryGoodsDeleteId.AsInteger := 0;
      cdsInventoryGoods.Post;
    end;
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
