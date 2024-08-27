unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, FMX.DialogService,
  Data.DB, Datasnap.DBClient, FMX.dsdDB, FMX.Storage, FMX.UnilWin
  {$IFDEF MSWINDOWS}
  , Winapi.ActiveX
  {$ENDIF}
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
    TaskName: string;
    FidSecretly: Boolean;

    procedure SetTaskName(AName : string);

    function UpdateProgram: string;
  protected
    procedure Execute; override;
    property idSecretly: Boolean read FidSecretly write FidSecretly default False;
  end;


  TDM = class(TDataModule)
    cdsChoiceCelEdit: TClientDataSet;
    cdsChoiceCelEditChoiceCellId: TIntegerField;
    cdsChoiceCelEditGoodsId: TIntegerField;
    cdsChoiceCelEditChoiceCellCode: TIntegerField;
    cdsChoiceCelEditChoiceCellName: TStringField;
    cdsChoiceCelEditGoodsCode: TIntegerField;
    cdsChoiceCelEditGoodsName: TStringField;
    cdsChoiceCelEditGoodsKindId: TIntegerField;
    cdsChoiceCelEditGoodsKindName: TStringField;
    cdsChoiceCelEditPartionGoodsDate: TDateTimeField;
    cdsChoiceCelEditPartionGoodsDate_next: TDateTimeField;
    cdsChoiceCelListTop: TClientDataSet;
    cdsChoiceCelListTopId: TIntegerField;
    cdsChoiceCelListTopGoodsId: TIntegerField;
    cdsChoiceCelListTopGoodsCode: TIntegerField;
    cdsChoiceCelListTopOperDate: TDateTimeField;
    cdsChoiceCelList: TClientDataSet;
    cdsChoiceCelListId: TIntegerField;
    cdsChoiceCelListGoodsId: TIntegerField;
    cdsChoiceCelListGoodsCode: TIntegerField;
    cdsChoiceCelListOperDate: TDateTimeField;
    cdsChoiceCelListStatusCode: TIntegerField;
    cdsChoiceCelListTopStatusCode: TIntegerField;
    cdsChoiceCelListGoodsName: TStringField;
    cdsChoiceCelListTopGoodsName: TStringField;
    cdsChoiceCelListMovementItemId: TIntegerField;
    cdsChoiceCelListTopMovementItemId: TIntegerField;
    cdsChoiceCelListChoiceCellCode: TIntegerField;
    cdsChoiceCelListTopChoiceCellCode: TIntegerField;
    cdsChoiceCelListChoiceCellName: TStringField;
    cdsChoiceCelListTopChoiceCellName: TStringField;
    cdsChoiceCelListGoodsKindName: TStringField;
    cdsChoiceCelListTopGoodsKindName: TStringField;
    cdsChoiceCelListPartionGoodsDate: TDateTimeField;
    cdsChoiceCelListTopPartionGoodsDate: TDateTimeField;
    cdsChoiceCelListPartionGoodsDate_next: TDateTimeField;
    cdsChoiceCelListTopPartionGoodsDate_next: TDateTimeField;
    cdsChoiceCelListInsertName: TStringField;
    cdsChoiceCelListTopInsertName: TStringField;
    cdsChoiceCelListInsertDate: TDateTimeField;
    cdsChoiceCelListTopInsertDate: TDateTimeField;
    cdsChoiceCelListInvNumber: TStringField;
    cdsChoiceCelListTopInvNumber: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    // Ограничение количества строк для справочника
    FLimitList : Integer;
  public
    { Public declarations }
    function GetCurrentVersion: string;
    function GetMobileVersion : String;
    function GetAPKFileName : String;
    procedure CheckUpdate;
    function CompareVersion(ACurVersion, AServerVersion: string): integer;
    procedure UpdateProgram(const AResult: TModalResult);

    function DownloadConfig : Boolean;

    { загрузка места отбора по коду}
    function DownloadChoiceCelBarCode(ABarCode: String) : Boolean;
    { подтверждение места отбора}
    function ConfirmChoiceCel(ABarCode: String) : Boolean;

    function DownloadChoiceCelList(AIsOrderBy, AIsAllUser, AIsErased: Boolean; AFilter: String) : Boolean;
    function DownloadChoiceCelListTop : Boolean;

    property LimitList : Integer read FLimitList write FLimitList default 300;
  end;

var
  DM: TDM;
  ProgressThread : TProgressThread;
  WaitThread : TWaitThread;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses uMain;

{$R *.dfm}

{ TProgressThread }

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
  if not FidSecretly then
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
  BytesStream : TBytesStream;
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
  try
    GetStoredProc.StoredProcName := 'gpGet_Object_Program';
    GetStoredProc.OutputType := otBlob;
    GetStoredProc.Params.AddParam('inProgramName', ftString, ptInput, ApplicationName);
    try
      BytesStream := TBytesStream.Create(ReConvertConvertBute(GetStoredProc.Execute(false, false, false)));
      try

        if BytesStream.Size = 0 then
        begin
          Result := 'Новая версия программы не загружена из базы данных';
          exit;
        end;

        BytesStream.Position := 0;
        {$IFDEF ANDROID}
        OutputDir := TAndroidHelper.Context.getExternalCacheDir();
        Path := JStringToString(OutputDir.getAbsolutePath);
        FileName := path + '/' + ApplicationName;
        BytesStream.SaveToFile(filename);
        {$ELSE}
        BytesStream.SaveToFile(ApplicationName);
        {$ENDIF}

      finally
        FreeAndNil(BytesStream);
      end;
    except
      on E : Exception do
      begin
        Result := GetTextMessage(E);
        exit;
      end;
    end;
  finally
    FreeAndNil(GetStoredProc);
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

procedure TWaitThread.Execute;
var
  Res : string;
begin
  Res := '';

  if FidSecretly then
  begin
    Synchronize(procedure
                begin
                  frmMain.vsbMain.Enabled := false;
                end);

  end else
  begin
    Synchronize(procedure
                begin
                  frmMain.lProgress.Visible := false;
                  frmMain.pieAllProgress.Visible := false;
                  frmMain.pProgress.Visible := true;
                  frmMain.vsbMain.Enabled := false;
                end);

    ProgressThread := TProgressThread.Create(true);
  end;

  {$IFDEF MSWINDOWS}
  CoInitialize(nil);
  {$ENDIF}
  try

    if not FidSecretly then
    begin
      ProgressThread.FreeOnTerminate := true;
      ProgressThread.Start;
    end;

    if TaskName = 'UpdateProgram' then
    begin
      SetTaskName('Получение файла обновления');
      Res := UpdateProgram;
    end;

  finally
    {$IFDEF MSWINDOWS}
    CoUninitialize;
    {$ENDIF}
    if FidSecretly then
    begin
      Synchronize(procedure
                  begin
                    frmMain.vsbMain.Enabled := true;
                  end);

    end else
    begin
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
                      TDialogService.ShowMessage(Res);
                    end);
      end;
    end;
  end;
end;

{ TDM }

{ получение текущей версии программы }
function TDM.GetCurrentVersion: string;
{$IF DEFINED(ANDROID)}
var
  PackageManager: JPackageManager;
  PackageInfo : JPackageInfo;
{$ELSEIF DEFINED(IOS)}
var
  LValueObject: Pointer;
{$ENDIF}
begin
  {$IF DEFINED(ANDROID)}
  PackageManager := TAndroidHelper.Activity.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName(), TJPackageManager.JavaClass.GET_ACTIVITIES);
  Result := JStringToString(PackageInfo.versionName);
  {$ELSEIF DEFINED(IOS)}
  LValueObject := TNSBundle.Wrap(TNSBundle.OCClass.mainBundle).infoDictionary.objectForKey(StringToID('CFBundleVersion'));
  if LValueObject <> nil then
    Result := NSStrToStr(TNSString.Wrap(LValueObject));
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

    StoredProc.StoredProcName := 'gpGetMobile_WmsMobile_Version';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('MajorVersion', ftString, ptOutput, '');
    StoredProc.Params.AddParam('MinorVersion', ftString, ptOutput, '');

    try
      StoredProc.Execute(false, false, false);

      if (StoredProc.Params.ParamByName('MajorVersion').Value = '') or
         (StoredProc.Params.ParamByName('MinorVersion').Value = '') then
      begin
        Result := '';
        Exit;
      end;

      if StoredProc.Params.ParamByName('MajorVersion').Value > 65536 then
        Result := IntToStr(StoredProc.Params.ParamByName('MajorVersion').Value div 65536) + '.'
      else Result := '';

      Result := Result + IntToStr(StoredProc.Params.ParamByName('MajorVersion').Value MOD 65536) + '.';
      Result := Result + IntToStr(StoredProc.Params.ParamByName('MinorVersion').Value DIV 65536) + '.';
      Result := Result + IntToStr(StoredProc.Params.ParamByName('MinorVersion').Value MOD 65536);
    except
      on E : Exception do
      begin
        raise Exception.Create(GetTextMessage(E));
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

    StoredProc.StoredProcName := 'gpGetMobile_WmsMobile_Version';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('APKFileName', ftString, ptOutput, '');

    try
      StoredProc.Execute(false, false, false);
      Result := StoredProc.Params.ParamByName('APKFileName').Value;
    except
      on E : Exception do
      begin
        raise Exception.Create(GetTextMessage(E));
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

{ загрузка конфигурации }
function TDM.DownloadConfig : Boolean;
var
  StoredProc : TdsdStoredProc;
begin

  Result := False;
  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otResult;

    StoredProc.StoredProcName := 'gpGet_MobilebConfig';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('BarCodePref', ftString, ptOutput, frmMain.BarCodePref);
    StoredProc.Params.AddParam('DocBarCodePref', ftString, ptOutput, frmMain.DocBarCodePref);
    StoredProc.Params.AddParam('ItemBarCodePref', ftString, ptOutput, frmMain.ItemBarCodePref);
    StoredProc.Params.AddParam('ArticleSeparators', ftString, ptOutput, frmMain.ArticleSeparators);

    StoredProc.Params.AddParam('isCameraScanerSet', ftBoolean, ptOutput, False);
    StoredProc.Params.AddParam('isCameraScaner', ftBoolean, ptOutput, frmMain.isCameraScaner);
    StoredProc.Params.AddParam('isOpenScanChangingModeSet', ftBoolean, ptOutput, False);
    StoredProc.Params.AddParam('isOpenScanChangingMode', ftBoolean, ptOutput, frmMain.isOpenScanChangingMode);
    StoredProc.Params.AddParam('isHideScanButtonSet', ftBoolean, ptOutput, False);
    StoredProc.Params.AddParam('isHideScanButton', ftBoolean, ptOutput, frmMain.isHideScanButton);
    StoredProc.Params.AddParam('isHideIlluminationButtonSet', ftBoolean, ptOutput, False);
    StoredProc.Params.AddParam('isHideIlluminationButton', ftBoolean, ptOutput, frmMain.isHideIlluminationButton);
    StoredProc.Params.AddParam('isIlluminationModeSet', ftBoolean, ptOutput, False);
    StoredProc.Params.AddParam('isIlluminationMode', ftBoolean, ptOutput, frmMain.isIlluminationMode);

    try
      StoredProc.Execute(false, false, false);

      if StoredProc.ParamByName('BarCodePref').Value <> frmMain.BarCodePref then
        frmMain.BarCodePref := StoredProc.ParamByName('BarCodePref').Value;
      if StoredProc.ParamByName('DocBarCodePref').Value <> frmMain.DocBarCodePref then
        frmMain.DocBarCodePref := StoredProc.ParamByName('DocBarCodePref').Value;
      if StoredProc.ParamByName('ItemBarCodePref').Value <> frmMain.ItemBarCodePref then
        frmMain.ItemBarCodePref := StoredProc.ParamByName('ItemBarCodePref').Value;

      if StoredProc.ParamByName('ArticleSeparators').Value <> frmMain.ArticleSeparators then
        frmMain.ArticleSeparators := StoredProc.ParamByName('ArticleSeparators').Value;

      if StoredProc.ParamByName('isCameraScanerSet').Value and
        (StoredProc.ParamByName('isCameraScaner').Value <> frmMain.isCameraScaner) then frmMain.isCameraScaner := StoredProc.ParamByName('isCameraScaner').Value;
      if StoredProc.ParamByName('isOpenScanChangingModeSet').Value and
        (StoredProc.ParamByName('isOpenScanChangingMode').Value <> frmMain.isOpenScanChangingMode) then frmMain.isOpenScanChangingMode := StoredProc.ParamByName('isOpenScanChangingMode').Value;
      if StoredProc.ParamByName('isHideScanButtonSet').Value and
        (StoredProc.ParamByName('isHideScanButton').Value <> frmMain.isHideScanButton) then frmMain.isHideScanButton := StoredProc.ParamByName('isHideScanButton').Value;
      if StoredProc.ParamByName('isHideIlluminationButtonSet').Value and
        (StoredProc.ParamByName('isHideIlluminationButton').Value <> frmMain.isHideIlluminationButton) then frmMain.isHideIlluminationButton := StoredProc.ParamByName('isHideIlluminationButton').Value;
      if StoredProc.ParamByName('isIlluminationModeSet').Value and
        (StoredProc.ParamByName('isIlluminationMode').Value <> frmMain.isIlluminationMode) then frmMain.isIlluminationMode := StoredProc.ParamByName('isIlluminationMode').Value;

      Result := True;
    except
    end;
  finally
    FreeAndNil(StoredProc);
  end;
end;

{ загрузка места отбора по коду}
procedure TDM.DataModuleCreate(Sender: TObject);
begin
  FLimitList := 300;
end;

function TDM.DownloadChoiceCelBarCode(ABarCode: String) : Boolean;
var
  StoredProc : TdsdStoredProc;
begin

  Result := False;
  if Trim(ABarCode) = '' then Exit;

  StoredProc := TdsdStoredProc.Create(nil);
  cdsChoiceCelEdit.DisableControls;
  try
    StoredProc.OutputType := otDataSet;

    StoredProc.StoredProcName := 'gpGet_MovementItem_ChoiceCell';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inBarCode', ftString, ptInput, ABarCode);
    StoredProc.DataSet := cdsChoiceCelEdit;

    try
      StoredProc.Execute(false, false, false);
      Result := cdsChoiceCelEdit.Active;
    except
      on E : Exception do TDialogService.ShowMessage(GetTextMessage(E));
    end;
  finally
    FreeAndNil(StoredProc);
    cdsChoiceCelEdit.EnableControls;
  end;
end;

{ подтверждение места отбора}
function TDM.ConfirmChoiceCel(ABarCode: String) : Boolean;
var
  StoredProc : TdsdStoredProc;
begin

  Result := False;
  if Trim(ABarCode) = '' then Exit;

  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.OutputType := otResult;

    StoredProc.StoredProcName := 'gpInsertUpdate_MovementItem_ChoiceCell';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inBarCode', ftString, ptInput, ABarCode);

    try
      StoredProc.Execute(false, false, false);
      Result := True;
    except
      on E : Exception do TDialogService.ShowMessage(GetTextMessage(E));
    end;
  finally
    FreeAndNil(StoredProc);
  end;
end;

function TDM.DownloadChoiceCelList(AIsOrderBy, AIsAllUser, AIsErased: Boolean; AFilter: String) : Boolean;
var
  StoredProc : TdsdStoredProc;
  nId: Integer;
begin

  if cdsChoiceCelList.Active and not cdsChoiceCelList.IsEmpty then
    nID := DM.cdsChoiceCelListId.AsInteger
  else nID := 0;

  StoredProc := TdsdStoredProc.Create(nil);
  cdsChoiceCelList.DisableControls;
  try
    StoredProc.OutputType := otDataSet;

    StoredProc.StoredProcName := 'gpSelect_Movement_ChoiceCellMobile';
    StoredProc.Params.Clear;
    StoredProc.Params.AddParam('inIsOrderBy', ftBoolean, ptInput, AIsOrderBy);
    StoredProc.Params.AddParam('inIsAllUser', ftBoolean, ptInput, AIsAllUser);
    StoredProc.Params.AddParam('inLimit', ftInteger, ptInput, FLimitList);
    StoredProc.Params.AddParam('inFilter', ftWideString, ptInput, AFilter);
    StoredProc.Params.AddParam('inIsErased', ftBoolean, ptInput, AIsErased);
    StoredProc.DataSet := cdsChoiceCelList;

    try
      StoredProc.Execute(false, false, false);
      Result := cdsChoiceCelList.Active;
      if Result and (nID <> 0) then cdsChoiceCelList.Locate('Id', nId, []);
      if cdsChoiceCelList.RecordCount >= FLimitList then
        frmMain.llwChoiceCelList.Text := 'Выборка первых ' + IntToStr(FLimitList) + ' записей'
      else frmMain.llwChoiceCelList.Text := 'Найдено ' + IntToStr(cdsChoiceCelList.RecordCount) + ' записей';
    except
      on E : Exception do
      begin
        raise Exception.Create(GetTextMessage(E));
        exit;
      end;
    end;
  finally
    FreeAndNil(StoredProc);
    cdsChoiceCelList.EnableControls;
  end;
end;

function TDM.DownloadChoiceCelListTop : Boolean;
var
  StoredProc : TdsdStoredProc;
begin

  Result := False;

  StoredProc := TdsdStoredProc.Create(nil);
  cdsChoiceCelListTop.DisableControls;
  try
    StoredProc.OutputType := otDataSet;

    StoredProc.StoredProcName := 'gpSelect_Movement_ChoiceCellMobileTop';
    StoredProc.Params.Clear;
    StoredProc.DataSet := cdsChoiceCelListTop;

    try
      StoredProc.Execute(false, false, false, 2);
      Result := cdsChoiceCelListTop.Active;
    except
    end;
  finally
    FreeAndNil(StoredProc);
    cdsChoiceCelListTop.EnableControls;
  end;
end;


end.
