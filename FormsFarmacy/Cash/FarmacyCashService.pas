unit FarmacyCashService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  DataModul,  Vcl.ActnList, dsdAction,
  Data.DB,  Vcl.ExtCtrls, dsdDB, Datasnap.DBClient,  Vcl.Menus,  Vcl.StdCtrls,
  IniFIles, dxmdaset,  ActiveX,  Math,  VKDBFDataSet, FormStorage, CommonData, ParentForm,
  LocalWorkUnit , IniUtils, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  cxButtons, Vcl.Grids, Vcl.DBGrids, AncestorBase, cxPropertiesStore, cxControls,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,  cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid,  cxSplitter, cxContainer,  cxTextEdit, cxCurrencyEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox,  cxCheckBox, cxNavigator, CashInterface,  cxImageComboBox , dsdAddOn,
  Vcl.ImgList, LocalStorage
  ;

type
 THeadRecord = record
    ID: Integer;//id чека
    PAIDTYPE:Integer; //тип оплаты
    MANAGER:Integer; //Id Менеджера (VIP)
    NOTMCS:Boolean; //Не для НТЗ
    COMPL:Boolean; //Напечатан
    SAVE:Boolean; //Сохранен
    NEEDCOMPL: Boolean; //Необходимо проведение
    DATE: TDateTime; //дата/Время чека
    UID: String[50];//uid чека
    CASH: String[20]; //серийник аппарата
    BAYER:String[254]; //Покупатель (VIP)
    FISCID:String[50]; //Номер фискального чека
    //***20.07.16
    DISCOUNTID : Integer;     //Id Проекта дисконтных карт
    DISCOUNTN  : String[254]; //Название Проекта дисконтных карт
    DISCOUNT   : String[50];  //№ Дисконтной карты
    //***16.08.16
    BAYERPHONE  : String[50];  //Контактный телефон (Покупателя) - BayerPhone
    CONFIRMED   : String[50];  //Статус заказа (Состояние VIP-чека) - ConfirmedKind
    NUMORDER    : String[50];  //Номер заказа (с сайта) - InvNumberOrder
    CONFIRMEDC  : String[50];  //Статус заказа (Состояние VIP-чека) - ConfirmedKindClient
    //***24.01.17
    USERSESION: string[50]; //Для сервиса - реальная сесия при продаже
    //***08.04.17
    PMEDICALID  : Integer;       //Id Медицинское учреждение(Соц. проект)
    PMEDICALN   : String[254];   //Название Медицинское учреждение(Соц. проект)
    AMBULANCE   : String[50];    //№ амбулатории (Соц. проект)
    MEDICSP     : String[254];   //ФИО врача (Соц. проект)
    INVNUMSP    : String[50];    //номер рецепта (Соц. проект)
    OPERDATESP  : TDateTime;     //дата рецепта (Соц. проект)
    //***15.06.17
    SPKINDID    : Integer;       //Id Вид СП
    //***05.02.18
    PROMOCODE    : Integer;      //Id промокода
  end;
  TBodyRecord = record
    ID: Integer;            //ид записи
    GOODSID: Integer;       //ид товара
    GOODSCODE: Integer;     //Код товара
    NDS: Currency;          //НДС товара
    AMOUNT: Currency;       //Кол-во
    PRICE: Currency;        //Цена, с 20.07.16 если есть скидка по Проекту дисконта, здесь будет цена с учетом скидки
    CH_UID: String[50];     //uid чека
    GOODSNAME: String[254]; //наименование товара
    //***20.07.16
    PRICESALE: Currency;    // Цена без скидки
    CHPERCENT: Currency;    // % Скидки
    SUMMCH: Currency;       // Сумма Скидки
    //***19.08.16
    AMOUNTORD: Currency;    // Кол-во заявка
    //***10.08.16
    LIST_UID: String[50]    // UID строки продажи
  end;
  TBodyArr = Array of TBodyRecord;


  TMainCashForm2 = class(TForm)
    FormParams: TdsdFormParams;
    spDelete_CashSession: TdsdStoredProc;
    spGet_BlinkCheck: TdsdStoredProc;
    spGet_BlinkVIP: TdsdStoredProc;

    spSelectCheck: TdsdStoredProc;
    spSelect_Alternative: TdsdStoredProc;
    AlternativeCDS: TClientDataSet;
    AlternativeDS: TDataSource;
    spSelectRemains: TdsdStoredProc;
    RemainsCDS: TClientDataSet;
    RemainsDS: TDataSource;
    spSelect_CashRemains_Diff: TdsdStoredProc;
    DiffCDS: TClientDataSet;
    spCheck_RemainsError: TdsdStoredProc;
    spGet_User_IsAdmin: TdsdStoredProc;
    TimerGetRemains: TTimer;
    ActionList: TActionList;
    actRefreshAll: TAction; //+
    actRefresh: TdsdDataSetRefresh;
    CheckDS: TDataSource;
    CheckCDS: TClientDataSet;
    actRefreshLite: TdsdDataSetRefresh;
    actShowMessage: TShowMessageAction;
    actSelectCheck: TdsdExecStoredProc;
    MemData: TdxMemData;
    MemDataID: TIntegerField;
    MemDataGOODSCODE: TIntegerField;
    MemDataGOODSNAME: TStringField;
    MemDataPRICE: TFloatField;
    MemDataREMAINS: TFloatField;
    MemDataMCSVALUE: TFloatField;
    MemDataRESERVED: TFloatField;
    MemDataNEWROW: TBooleanField;
    actSetCashSessionId: TAction;
    pmServise: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    TimerSaveReal: TTimer;
    tiServise: TTrayIcon;
    N4: TMenuItem;
    ilIcons: TImageList;
    N5: TMenuItem;
    N7: TMenuItem;
    actCashRemains: TAction;
    N8: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actRefreshAllExecute(Sender: TObject); //+
    procedure TimerGetRemainsTimer(Sender: TObject);
    procedure actSetCashSessionIdExecute(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure TimerSaveRealTimer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure actCashRemainsExecute(Sender: TObject);

  private
    { Private declarations }

    procedure AppMsgHandler(var Msg: TMsg; var Handled: Boolean);
  public
    { Public declarations }


    ThreadErrorMessage:String;

    FiscalNumber: String;
    FirstRemainsReceived: boolean;
    procedure SaveLocalVIP;
    procedure SaveRealAll;
    procedure ChangeStatus(AStatus: String);
    function InitLocalStorage: Boolean;
    function ExistNotCompletedCheck: boolean;

  end;


const
  CMD_SETLABELTEXT = 1;

var
  CountСhecksAtOnce : Integer = 7; // Колличество проводимых чеков за раз.
  MainCashForm2: TMainCashForm2;
  FLocalDataBaseHead : TVKSmartDBF;
  FLocalDataBaseBody : TVKSmartDBF;
  FLocalDataBaseDiff : TVKSmartDBF;
  LocalDataBaseisBusy: Integer = 0;
  csCriticalSection,
  csCriticalSection_Save,
  csCriticalSection_All: TRTLCriticalSection;
  AllowedConduct : Boolean = false;
  MutexDBF, MutexDBFDiff,  MutexVip, MutexRemains, MutexAlternative, MutexRefresh, MutexAllowedConduct: THandle;
  LastErr: Integer;

  FM_SERVISE: Integer;
    function GenerateGUID: String;
implementation

{$R *.dfm}

procedure TMainCashForm2.AppMsgHandler(var Msg: TMsg; var Handled: Boolean);
var msgStr: String;
begin
  Handled := (Msg.hwnd = Application.Handle) and (Msg.message = FM_SERVISE);
  if Handled and (Msg.wParam = 2) then
    case Msg.lParam of
      2: actSetCashSessionId.Execute;    // обновление кеш сесии

      3: begin
          SaveRealAll;    // попросили провести чеки
         end;

      9: begin
//           ShowMessage('запрос на выключение');
           MainCashForm2.Close;    // закрыть сервис
         end;
      10: begin    // остановить проведение чеков
            if not AllowedConduct then
              AllowedConduct := True;
          end;

      20: begin  // разрешить проведение чеков
            if AllowedConduct then
             AllowedConduct := False;
           end;

      30: begin // получен запрос на обновление всех данных
             actRefreshAllExecute(nil);
          end;

      40: begin // получен запрос на обновление только остатков
             actCashRemainsExecute(nil);
          end;

    end;

end;



procedure TMainCashForm2.actSetCashSessionIdExecute(Sender: TObject);
var myFile:  TextFile;
    text: string;
begin
 if FileExists('CashSessionId.ini') then
  begin
  AssignFile(myFile, 'CashSessionId.ini');
  Reset(myFile);
  ReadLn(myFile, text);
  FormParams.ParamByName('CashSessionId').Value:=Text;
  CloseFile(myFile);
  end
  else
  begin

   PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 2); // Запрос на сохранение CashSessionId в  CashSessionId.ini

  end;
end;




procedure TMainCashForm2.ChangeStatus(AStatus: String);
Begin
  tiServise.BalloonHint := AStatus;
End;

function TMainCashForm2.ExistNotCompletedCheck: boolean;
begin
  Result := false;
  WaitForSingleObject(MutexDBF, INFINITE);
  FLocalDataBaseHead.Active := True;
  try
    while not FLocalDataBaseHead.eof do
    Begin
      IF not FLocalDataBaseHead.Deleted and FLocalDataBaseHead.FieldByName('NEEDCOMPL').AsBoolean then
      begin
        Result := true;
        break;
      end;
      FLocalDataBaseHead.Next;
    End;
    FLocalDataBaseHead.Pack;
  finally
    FLocalDataBaseHead.Active := False;
    ReleaseMutex(MutexDBF);
  end;
end;

procedure TMainCashForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  AllowedConduct := True; // Просим досрочно прекратить проведения чеков
  WaitForSingleObject(MutexRefresh, INFINITE);
  if CanClose then
  Begin
    try
      if not gc_User.Local then
      Begin
        spDelete_CashSession.Execute;
      End
      else
      begin
        WaitForSingleObject(MutexRemains, INFINITE);
        SaveLocalData(RemainsCDS,remains_lcl);
        ReleaseMutex(MutexRemains);
        WaitForSingleObject(MutexAlternative, INFINITE);
        SaveLocalData(AlternativeCDS,Alternative_lcl);
        ReleaseMutex(MutexAlternative);
      end;
    Except
    end;

  End;
  ReleaseMutex(MutexRefresh);
end;


procedure TMainCashForm2.actCashRemainsExecute(Sender: TObject);
begin
  if ExistNotCompletedCheck then Exit; // нельзя получать, пока есть неотгруженные чеки
  WaitForSingleObject(MutexRemains, INFINITE);
  MainCashForm2.tiServise.IconIndex:=1;
  try
    try
      MainCashForm2.spSelect_CashRemains_Diff.Execute(False, False, False);
      DiffCDS.First;
      if DiffCDS.FieldCount>0 then
      begin
         WaitForSingleObject(MutexDBFDiff, INFINITE);
         FLocalDataBaseDiff.Open;
         while not DiffCDS.Eof  do
         begin
            FLocalDataBaseDiff.Append;
            FLocalDataBaseDiff.Fields[0].AsString:=DiffCDS.Fields[0].AsString;
            FLocalDataBaseDiff.Fields[1].AsString:=DiffCDS.Fields[1].AsString;
            FLocalDataBaseDiff.Fields[2].AsString:=DiffCDS.Fields[2].AsString;
            FLocalDataBaseDiff.Fields[3].AsString:=DiffCDS.Fields[3].AsString;
            FLocalDataBaseDiff.Fields[4].AsString:=DiffCDS.Fields[4].AsString;
            FLocalDataBaseDiff.Fields[5].AsString:=DiffCDS.Fields[5].AsString;
            FLocalDataBaseDiff.Fields[6].AsString:=DiffCDS.Fields[6].AsString;
            FLocalDataBaseDiff.Fields[7].AsString:=DiffCDS.Fields[7].AsString;
            FLocalDataBaseDiff.Post;
            DiffCDS.Next;
         end;
         FLocalDataBaseDiff.Close;
         ReleaseMutex(MutexDBFDiff);
         // Отправка сообщения приложению про надобность обновить остатки из файла
         PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 1);
        end;
    except
      if gc_User.Local then
       begin
         tiServise.BalloonHint:='Локальный режим';
         tiServise.ShowBalloonHint;
         Exit;
       end;
    end;
  finally
    ReleaseMutex(MutexRemains);
    MainCashForm2.tiServise.IconIndex:=0;
  end;

end;

procedure TMainCashForm2.actRefreshAllExecute(Sender: TObject);
begin   //yes
  if ExistNotCompletedCheck then Exit; // нельзя запускать, пока есть неотгруженные чеки
  // обновления данных с сервера
  WaitForSingleObject(MutexRemains, INFINITE);
  WaitForSingleObject(MutexAlternative, INFINITE);
  MainCashForm2.tiServise.IconIndex:=1;
  // посылаем сообщение о начале получения полных остатков
  PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 4);
  tiServise.Hint := 'Получение остатков';
  Application.ProcessMessages;
  try
    if not gc_User.Local  then
    Begin
      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        try
          //Получение остатков
          actRefresh.Execute;
          //Сохранение остатков в локальной базе
          SaveLocalData(RemainsCDS,Remains_lcl);
          SaveLocalData(AlternativeCDS,Alternative_lcl);
          //Получение ВИП чеков и сохранение в локальной базе
          SaveLocalVIP;
          PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 3);
          // Вывод уведомления сервиса
          tiServise.BalloonHint:='Остатки обновлены.';
          tiServise.ShowBalloonHint;
          FirstRemainsReceived := true;
        except
          if gc_User.Local then
          begin
            tiServise.BalloonHint:='Обрыв соединения';
            tiServise.ShowBalloonHint;
          end;
        end;
      finally
        RemainsCDS.EnableControls;
        AlternativeCDS.EnableControls;
      end;
    End;
  finally
    tiServise.Hint := '';
    PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 5);
    ReleaseMutex(MutexRemains);
    ReleaseMutex(MutexAlternative);
    ChangeStatus('Сохранили');
    MainCashForm2.tiServise.IconIndex:=0;
  end;
end;

function GenerateGUID: String;
var
  G: TGUID;
begin
  CreateGUID(G);
  Result := GUIDToString(G);
end;

procedure TMainCashForm2.FormCreate(Sender: TObject);
var
  F: String;
begin
  if ParamStr(1) = 'Админ' then  // показываем меню только для Админа
    tiServise.PopupMenu:=pmServise
  else tiServise.PopupMenu:=nil;

  Application.OnMessage := AppMsgHandler;
  // создаем мутексы если не созданы
  MutexDBF := CreateMutex(nil, false, 'farmacycashMutexDBF');
  LastErr := GetLastError;
  MutexDBFDiff := CreateMutex(nil, false, 'farmacycashMutexDBFDiff');
  LastErr := GetLastError;
  MutexVip := CreateMutex(nil, false, 'farmacycashMutexVip');
  LastErr := GetLastError;
  MutexRemains := CreateMutex(nil, false, 'farmacycashMutexRemains');
  LastErr := GetLastError;
  MutexAlternative := CreateMutex(nil, false, 'farmacycashMutexAlternative');
  LastErr := GetLastError;
  MutexRefresh := CreateMutex(nil, false, 'farmacycashMutexRefresh');
  LastErr := GetLastError;
  //сгенерили гуид для определения сессии
  ChangeStatus('Установка первоначальных параметров');

  FormParams.ParamByName('ClosedCheckId').Value := 0;
  FormParams.ParamByName('CheckId').Value := 0;

  if NOT GetIniFile(F) then
  Begin
    Application.Terminate;
    exit;
  End;

  ChangeStatus('Инициализация локального хранилища');

  if not InitLocalStorage then
  Begin
    Application.Terminate;
    exit;
  End;
  ChangeStatus('Инициализация локального хранилища - да');

  SaveRealAll; // Проводим чеки которые остались не проведенными раньше. Учитывается CountСhecksAtOnce = 7
               // проведутся первые 7 чеков и будут ждать или таймер или пока не пройдет первая покупка
  ChangeStatus('Получение остатков');
  FirstRemainsReceived := false;
  FormParams.ParamByName('CashSessionId').Value := iniLocalGUIDSave(GenerateGUID);
  //PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 2); // запрос кеш сесии у приложения
  TimerGetRemains.Enabled := true;
 //}
  ChangeStatus('Готово');
end;

// процедура обновляет параметры для введения нового чека
procedure TMainCashForm2.N1Click(Sender: TObject);
begin
  actRefreshAllExecute(nil);
end;

procedure TMainCashForm2.N2Click(Sender: TObject);
begin
TimerGetRemains.Enabled := not TimerGetRemains.Enabled;
N2.Checked := TimerGetRemains.Enabled;
end;

procedure TMainCashForm2.N3Click(Sender: TObject);
begin
SaveRealAll;
end;

procedure TMainCashForm2.N4Click(Sender: TObject);
begin
 MainCashForm2.Close;
end;

procedure TMainCashForm2.N5Click(Sender: TObject);
begin
try
 MainCashForm2.tiServise.IconIndex:=1;
  try
    spGet_User_IsAdmin.Execute;
    gc_User.Local := False;
    tiServise.BalloonHint:='Режим работы: В сети';
    tiServise.ShowBalloonHint;
  except
    Begin
      gc_User.Local := True;
      tiServise.BalloonHint:='Режим работы: Автономно';
      tiServise.ShowBalloonHint;
    End;
  end;
finally
 MainCashForm2.tiServise.IconIndex:=0;
end;
end;

procedure TMainCashForm2.N7Click(Sender: TObject);
begin
  TimerSaveReal.Enabled := not TimerSaveReal.Enabled;
  N7.Checked := TimerGetRemains.Enabled;
end;

function TMainCashForm2.InitLocalStorage: Boolean;
begin
  Result := False;

  WaitForSingleObject(MutexDBF, INFINITE);
  WaitForSingleObject(MutexDBFDiff, INFINITE);

  try
    Result := InitLocalDataBaseHead(Self, FLocalDataBaseHead) and
      InitLocalDataBaseBody(Self, FLocalDataBaseBody) and
      InitLocalDataBaseDiff(Self, FLocalDataBaseDiff);

    if Result then
    begin
      FLocalDataBaseHead.Active := False;
      FLocalDataBaseBody.Active := False;
      FLocalDataBaseDiff.Active := False;
    end;
  finally
    ReleaseMutex(MutexDBF);
    ReleaseMutex(MutexDBFDiff);
  end;
end;

procedure TMainCashForm2.SaveLocalVIP;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin  //+
  // pr вызывается из обновления остатков
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      sp.OutputType := otDataSet;
      sp.DataSet := ds;

      sp.StoredProcName := 'gpSelect_Object_Member';
      sp.Params.Clear;
      sp.Params.AddParam('inIsShowAll',ftBoolean,ptInput,False);
      sp.Execute(False,False);
      WaitForSingleObject(MutexVip, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
      SaveLocalData(ds,Member_lcl);
      ReleaseMutex(MutexVip);

      sp.StoredProcName := 'gpSelect_Movement_CheckVIP';
      sp.Params.Clear;
      sp.Params.AddParam('inIsErased',ftBoolean,ptInput,False);
      sp.Execute(False,False);
      WaitForSingleObject(MutexVip, INFINITE);
      SaveLocalData(ds,Vip_lcl);
      ReleaseMutex(MutexVip);

      sp.StoredProcName := 'gpSelect_MovementItem_CheckDeferred';
      sp.Params.Clear;
      sp.Execute(False,False);
      WaitForSingleObject(MutexVip, INFINITE);
      SaveLocalData(ds,VipList_lcl);
      ReleaseMutex(MutexVip);
    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.TimerSaveRealTimer(Sender: TObject);
begin
  TimerSaveReal.Enabled := False;

  try
    SaveRealAll;
  finally
    TimerSaveReal.Enabled := True;
  end;
end;

procedure TMainCashForm2.TimerGetRemainsTimer(Sender: TObject);
begin
  TimerGetRemains.Enabled := False;
  TimerGetRemains.Interval := 60000;
  try
    WaitForSingleObject(MutexRefresh, INFINITE);
    actRefreshAllExecute(nil);
  finally
    ReleaseMutex(MutexRefresh);
    TimerGetRemains.Enabled := not FirstRemainsReceived;
  end;
end;

{ TSaveRealThread }
procedure TMainCashForm2.SaveRealAll;
var
  J: Integer;
  UID: string;
  Head: THeadRecord;
  Body: TBodyArr;
  Find: Boolean;
  dsdSave: TdsdStoredProc;
  I: Integer;
  FNeedSaveVIP: Boolean;
  fError_isComplete: Boolean;
  FNeedGetDiff: Boolean;
begin
  try
    spGet_User_IsAdmin.Execute;
    if gc_User.Local then
    begin
      gc_User.Local := False;
      tiServise.BalloonHint := 'Связь востановлена';
      tiServise.ShowBalloonHint;
    end;
  except
    begin
      if not gc_User.Local then
      begin
        gc_User.Local := True;
        tiServise.BalloonHint := 'Локальный режим';
        tiServise.ShowBalloonHint;
      end;
      Exit;
    end;
  end;

  // Запускаем поиски чеков ели разрешено
  if AllowedConduct then
    Exit;

  MainCashForm2.tiServise.IconIndex := 1;
  WaitForSingleObject(MutexRefresh, INFINITE); // одновременно проведение и обновление всех остатков запрещено
  WaitForSingleObject(MutexAllowedConduct, INFINITE); // для отмены проведения из приложения при закрытии
  FNeedGetDiff := false;
  try
    tiServise.Hint := 'Проведение чеков';
    while True do
    Begin
      Application.ProcessMessages; // Нужно потестить отмену
      // Выходим из цикла при получении указания постоять или перехода в локальный режим
      if AllowedConduct or gc_User.Local then
      begin
        tiServise.BalloonHint := 'Останавливаем проведение чеков';
        tiServise.ShowBalloonHint;
        Exit;
      end;

      WaitForSingleObject(MutexDBF, INFINITE);
      FLocalDataBaseHead.Active := True;
      FLocalDataBaseBody.Active := True;
      try
        FLocalDataBaseHead.Pack;
        FLocalDataBaseBody.Pack;
        FLocalDataBaseHead.First;
        UID := '';
        while not FLocalDataBaseHead.eof do
        Begin
          if not FLocalDataBaseHead.Deleted then
          Begin
            UID := trim(FLocalDataBaseHead.FieldByName('UID').AsString);
            break;
          End;
          FLocalDataBaseHead.Next;
        End;
      finally
        FLocalDataBaseBody.Active := False;
        FLocalDataBaseHead.Active := False;
        ReleaseMutex(MutexDBF);
      end;

      // если чеков нет, выходим из цикла
      if UID = '' then
        break;

      if UID <> '' then
      Begin
        Find := False;
        WaitForSingleObject(MutexDBF, INFINITE);
        FLocalDataBaseHead.Active := True;
        FLocalDataBaseBody.Active := True;
        try
          if FLocalDataBaseHead.Locate('UID', UID, [loPartialKey]) AND not FLocalDataBaseHead.Deleted then
          Begin
            Find := True;
            With Head, FLocalDataBaseHead do
            Begin
              ID := FieldByName('ID').AsInteger;
              UID := FieldByName('UID').AsString;
              DATE := FieldByName('DATE').asCurrency;
              CASH := trim(FieldByName('CASH').AsString);
              PAIDTYPE := FieldByName('PAIDTYPE').AsInteger;
              MANAGER := FieldByName('MANAGER').AsInteger;
              BAYER := trim(FieldByName('BAYER').AsString);
              COMPL := FieldByName('COMPL').AsBoolean;
              NEEDCOMPL := FieldByName('NEEDCOMPL').AsBoolean;
              SAVE := FieldByName('SAVE').AsBoolean;
              FISCID := trim(FieldByName('FISCID').AsString);
              NOTMCS := FieldByName('NOTMCS').AsBoolean;
              // ***20.07.16
              DISCOUNTID := FieldByName('DISCOUNTID').AsInteger;
              DISCOUNTN := trim(FieldByName('DISCOUNTN').AsString);
              DISCOUNT := trim(FieldByName('DISCOUNT').AsString);
              // ***16.08.16
              BAYERPHONE := trim(FieldByName('BAYERPHONE').AsString);
              CONFIRMED := trim(FieldByName('CONFIRMED').AsString);
              NUMORDER := trim(FieldByName('NUMORDER').AsString);
              CONFIRMEDC := trim(FieldByName('CONFIRMEDC').AsString);
              // ***24.01.17
              USERSESION := trim(FieldByName('USERSESION').AsString);
              // ***08.04.17
              PMEDICALID := FieldByName('PMEDICALID').AsInteger;
              PMEDICALN := trim(FieldByName('PMEDICALN').AsString);
              AMBULANCE := trim(FieldByName('AMBULANCE').AsString);
              MEDICSP := trim(FieldByName('MEDICSP').AsString);
              INVNUMSP := trim(FieldByName('INVNUMSP').AsString);
              OPERDATESP := FieldByName('OPERDATESP').asCurrency;
              // ***15.06.17
              SPKINDID := FieldByName('SPKINDID').AsInteger;
              // ***05.02.18
              PROMOCODE := FieldByName('PROMOCODE').AsInteger;

              FNeedSaveVIP := (MANAGER <> 0);
            end;
            FLocalDataBaseBody.First;
            while not FLocalDataBaseBody.eof do
            Begin
              if (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = UID) AND not FLocalDataBaseBody.Deleted then
              Begin
                SetLength(Body, Length(Body) + 1);
                with Body[Length(Body) - 1], FLocalDataBaseBody do
                Begin
                  CH_UID := trim(FieldByName('CH_UID').AsString);
                  GOODSID := FieldByName('GOODSID').AsInteger;
                  GOODSCODE := FieldByName('GOODSCODE').AsInteger;
                  GOODSNAME := trim(FieldByName('GOODSNAME').AsString);
                  NDS := FieldByName('NDS').asCurrency;
                  AMOUNT := FieldByName('AMOUNT').asCurrency;
                  PRICE := FieldByName('PRICE').asCurrency;
                  // ***20.07.16
                  PRICESALE := FieldByName('PRICESALE').asCurrency;
                  CHPERCENT := FieldByName('CHPERCENT').asCurrency;
                  SUMMCH := FieldByName('SUMMCH').asCurrency;
                  // ***19.08.16
                  AMOUNTORD := FieldByName('AMOUNTORD').asCurrency;
                  // ***10.08.16
                  LIST_UID := trim(FieldByName('LIST_UID').AsString);
                End;
              End;
              FLocalDataBaseBody.Next;
            End;
          End;
        finally
          FLocalDataBaseHead.Active := False;
          FLocalDataBaseBody.Active := False;
          ReleaseMutex(MutexDBF);
        end; // Загрузили чек в head and body

        // т.е. чек можно потом удалить из ДБФ
        fError_isComplete := False; // 04.02.2017

        if Find AND NOT Head.SAVE then
        Begin
          dsdSave := TdsdStoredProc.Create(nil);
          try
            try
              // Проверить в каком состоянии документ.
              dsdSave.StoredProcName := 'gpGet_Movement_CheckState';
              dsdSave.OutputType := otResult;
              dsdSave.Params.Clear;
              dsdSave.Params.AddParam('inId', ftInteger, ptInput, Head.ID);
              dsdSave.Params.AddParam('outState', ftInteger, ptOutput, Null);
              dsdSave.Execute(False, False);
              if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2' then // проведен
              Begin
                Head.SAVE := True;
                Head.NEEDCOMPL := False;

                // т.е. чек НЕЛЬЗЯ потом удалить из ДБФ
                fError_isComplete := True; // 04.02.2017
              End
              else
              // Если не проведен
              Begin
                if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '3' then // Удален
                Begin
                  dsdSave.StoredProcName := 'gpUnComplete_Movement_Check';
                  dsdSave.OutputType := otResult;
                  dsdSave.Params.Clear;
                  dsdSave.Params.AddParam('inMovementId', ftInteger, ptInput, Head.ID);
                  dsdSave.Execute(False, False);
                end;
                // сохранил шапку
                dsdSave.StoredProcName := 'gpInsertUpdate_Movement_Check_ver2';
                dsdSave.OutputType := otResult;
                dsdSave.Params.Clear;
                dsdSave.Params.AddParam('ioId', ftInteger, ptInputOutput, Head.ID);
                dsdSave.Params.AddParam('inDate', ftDateTime, ptInput, Head.DATE);
                dsdSave.Params.AddParam('inCashRegister', ftString, ptInput, Head.CASH);
                dsdSave.Params.AddParam('inPaidType', ftInteger, ptInput, Head.PAIDTYPE);
                dsdSave.Params.AddParam('inManagerId', ftInteger, ptInput, Head.MANAGER);
                dsdSave.Params.AddParam('inBayer', ftString, ptInput, Head.BAYER);
                dsdSave.Params.AddParam('inFiscalCheckNumber', ftString, ptInput, Head.FISCID);
                dsdSave.Params.AddParam('inNotMCS', ftBoolean, ptInput, Head.NOTMCS);
                // ***20.07.16
                dsdSave.Params.AddParam('inDiscountExternalId', ftInteger, ptInput, Head.DISCOUNTID);
                dsdSave.Params.AddParam('inDiscountCardNumber', ftString, ptInput, Head.DISCOUNT);
                // ***16.08.16
                dsdSave.Params.AddParam('inBayerPhone', ftString, ptInput, Head.BAYERPHONE);
                dsdSave.Params.AddParam('inConfirmedKindName', ftString, ptInput, Head.CONFIRMED);
                dsdSave.Params.AddParam('inInvNumberOrder', ftString, ptInput, Head.NUMORDER);
                // ***08.04.17
                dsdSave.Params.AddParam('inPartnerMedicalId', ftInteger, ptInput, Head.PMEDICALID);
                dsdSave.Params.AddParam('inAmbulance', ftString, ptInput, Head.AMBULANCE);
                dsdSave.Params.AddParam('inMedicSP', ftString, ptInput, Head.MEDICSP);
                dsdSave.Params.AddParam('inInvNumberSP', ftString, ptInput, Head.INVNUMSP);
                dsdSave.Params.AddParam('inOperDateSP', ftDateTime, ptInput, Head.OPERDATESP);
                // ***15.06.17
                dsdSave.Params.AddParam('inSPKindId', ftInteger, ptInput, Head.SPKINDID);
                // ***05.02.18
                dsdSave.Params.AddParam('inPromoCodeId', ftInteger, ptInput, Head.PROMOCODE);
                // ***24.01.17
                dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                dsdSave.Execute(False, False);
                // сохранили в локальной базе полученный номер
                if Head.ID <> StrToInt(dsdSave.Params.ParamByName('ioID').AsString) then
                Begin
                  Head.ID := StrToInt(dsdSave.Params.ParamByName('ioID').AsString);
                  WaitForSingleObject(MutexDBF, INFINITE);
                  FLocalDataBaseHead.Active := True;
                  try
                    if FLocalDataBaseHead.Locate('UID', UID, [loPartialKey]) AND not FLocalDataBaseHead.Deleted then
                    Begin
                      FLocalDataBaseHead.Edit;
                      FLocalDataBaseHead.FieldByName('ID').AsInteger := Head.ID;
                      FLocalDataBaseHead.Post;
                    End;
                  finally
                    FLocalDataBaseHead.Active := False;
                    ReleaseMutex(MutexDBF);
                  end;
                end;

                // сохранил тело

                dsdSave.StoredProcName := 'gpInsertUpdate_MovementItem_Check_ver2';
                dsdSave.OutputType := otResult;
                dsdSave.Params.Clear;
                dsdSave.Params.AddParam('ioId', ftInteger, ptInputOutput, Null);
                dsdSave.Params.AddParam('inMovementId', ftInteger, ptInput, Head.ID);
                dsdSave.Params.AddParam('inGoodsId', ftInteger, ptInput, Null);
                dsdSave.Params.AddParam('inAmount', ftFloat, ptInput, Null);
                dsdSave.Params.AddParam('inPrice', ftFloat, ptInput, Null);
                // ***20.07.16
                dsdSave.Params.AddParam('inPriceSale', ftFloat, ptInput, Null);
                dsdSave.Params.AddParam('inChangePercent', ftFloat, ptInput, Null);
                dsdSave.Params.AddParam('inSummChangePercent', ftFloat, ptInput, Null);
                // ***19.08.16
                // dsdSave.Params.AddParam('inAmountOrder',ftFloat,ptInput,Null);
                // ***10.08.16
                dsdSave.Params.AddParam('inList_UID', ftString, ptInput, Null);
                //
                dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                for I := 0 to Length(Body) - 1 do
                Begin
                  dsdSave.ParamByName('ioId').Value := Body[I].ID;
                  dsdSave.ParamByName('inGoodsId').Value := Body[I].GOODSID;
                  dsdSave.ParamByName('inAmount').Value := Body[I].AMOUNT;
                  dsdSave.ParamByName('inPrice').Value := Body[I].PRICE;
                  // ***20.07.16
                  dsdSave.ParamByName('inPriceSale').Value := Body[I].PRICESALE;
                  dsdSave.ParamByName('inChangePercent').Value := Body[I].CHPERCENT;
                  dsdSave.ParamByName('inSummChangePercent').Value := Body[I].SUMMCH;
                  // ***19.08.16
                  // dsdSave.ParamByName('inAmountOrder').Value :=  Body[I].AMOUNTORD;
                  // ***10.08.16
                  dsdSave.ParamByName('inList_UID').Value := Body[I].LIST_UID;
                  //

                  dsdSave.Execute(False, False); // сохринили на сервере
                  if Body[I].ID <> StrToInt(dsdSave.ParamByName('ioId').AsString) then
                  Begin
                    Body[I].ID := StrToInt(dsdSave.ParamByName('ioId').AsString);
                    WaitForSingleObject(MutexDBF, INFINITE);
                    FLocalDataBaseBody.Active := True;
                    try
                      FLocalDataBaseBody.First;
                      while not FLocalDataBaseBody.eof do
                      Begin
                        if (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = UID) AND not FLocalDataBaseBody.Deleted AND
                          (FLocalDataBaseBody.FieldByName('GOODSID').AsInteger = Body[I].GOODSID) then
                        Begin
                          FLocalDataBaseBody.Edit;
                          FLocalDataBaseBody.FieldByName('ID').AsInteger := Body[I].ID;
                          FLocalDataBaseBody.Post; // сохранили в файле
                          break;
                        End;
                        FLocalDataBaseBody.Next;
                      End;
                    finally
                      FLocalDataBaseBody.Active := False;
                      ReleaseMutex(MutexDBF);
                    end;
                  End;
                End; // обработали все позиции товара в чеке
                Head.SAVE := True;
                WaitForSingleObject(MutexDBF, INFINITE);
                FLocalDataBaseHead.Active := True;
                try
                  if FLocalDataBaseHead.Locate('UID', UID, [loPartialKey]) AND not FLocalDataBaseHead.Deleted then
                  Begin
                    FLocalDataBaseHead.Edit;
                    FLocalDataBaseHead.FieldByName('SAVE').AsBoolean := True;
                    FLocalDataBaseHead.Post;
                  End;
                finally
                  FLocalDataBaseHead.Active := False;
                  ReleaseMutex(MutexDBF);

                end;
              End; // обработали чек с товарами
            except
              ON E: Exception do
              Begin
                if gc_User.Local then
                begin
                  tiServise.BalloonHint := 'Останавливаем проведение чеков';
                  tiServise.ShowBalloonHint;
                  Exit;
                end;
                // -nw               SendError(E.Message);
              End;
            end;
          finally
            freeAndNil(dsdSave);
          end;
        end;
        // если необходимо провести чек
        if Find AND Head.SAVE AND Head.NEEDCOMPL then
        Begin
          dsdSave := TdsdStoredProc.Create(nil);
          try
            DiffCDS := TClientDataSet.Create(nil);
            try
              dsdSave.StoredProcName := 'gpComplete_Movement_Check_ver2_NoDiff';
              dsdSave.OutputType := otResult;
              dsdSave.Params.Clear;
              dsdSave.Params.AddParam('inMovementId', ftInteger, ptInput, Head.ID);
              dsdSave.Params.AddParam('inPaidType', ftInteger, ptInput, Head.PAIDTYPE);
              dsdSave.Params.AddParam('inCashRegister', ftString, ptInput, Head.CASH);
              dsdSave.Params.AddParam('inCashSessionId', ftString, ptInput, FormParams.ParamByName('CashSessionId').Value);
              dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);
              try
                dsdSave.Execute(False, False);
                Head.COMPL := True;
              except
                on E: Exception do
                Begin
                  // -nw                 SendError(E.Message);
                  if gc_User.Local then
                  begin
                    tiServise.BalloonHint := 'Останавливаем проведение чеков';
                    tiServise.ShowBalloonHint;
                    Exit;
                  end;
                End;
              end;
            finally
              // DiffCDS.SaveToFile('diff.local'); // для тестирования
              DiffCDS.free;
            end;
          finally
            freeAndNil(dsdSave);
          end;
          // удаляем проведенный чек - если можно ... 04.02.2017
          if Head.COMPL { AND (fError_isComplete = FALSE) } // 04.07.17 - !!!временно убрал!!!
          then
          Begin
            WaitForSingleObject(MutexDBF, INFINITE);
            FLocalDataBaseHead.Active := True;
            FLocalDataBaseBody.Active := True;
            try
              if FLocalDataBaseHead.Locate('UID', UID, [loPartialKey]) AND not FLocalDataBaseHead.Deleted then
                FLocalDataBaseHead.DeleteRecord;
              FLocalDataBaseBody.First;
              while not FLocalDataBaseBody.eof do
              Begin
                IF (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = UID) AND not FLocalDataBaseBody.Deleted then
                  FLocalDataBaseBody.DeleteRecord;
                FLocalDataBaseBody.Next;
              End;
              FLocalDataBaseHead.Pack;
              FLocalDataBaseBody.Pack;
            finally
              FLocalDataBaseHead.Active := False;
              FLocalDataBaseBody.Active := False;
              ReleaseMutex(MutexDBF);
            end;
          End;
        end;
        // если проводить не нужно и если можно ... 04.02.2017

        WaitForSingleObject(MutexDBF, INFINITE);
        FLocalDataBaseHead.Active := True;
        FLocalDataBaseHead.First;
        FLocalDataBaseHead.Active := False;
        ReleaseMutex(MutexDBF);
      End;
    End;

    // получаем Diff
    if not ExistNotCompletedCheck and FirstRemainsReceived then
    begin
      tiServise.Hint := 'Получение разницы в остатках';
      Application.ProcessMessages;
      WaitForSingleObject(MutexRemains, INFINITE);
      try
        try
          MainCashForm2.spSelect_CashRemains_Diff.Execute(False, False, False);
          DiffCDS.First;
          if DiffCDS.FieldCount > 0 then
          begin
            WaitForSingleObject(MutexDBFDiff, INFINITE);
            FLocalDataBaseDiff.Open;
            while not DiffCDS.eof do
            begin
              FLocalDataBaseDiff.Append;
              FLocalDataBaseDiff.Fields[0].AsString := DiffCDS.Fields[0].AsString;
              FLocalDataBaseDiff.Fields[1].AsString := DiffCDS.Fields[1].AsString;
              FLocalDataBaseDiff.Fields[2].AsString := DiffCDS.Fields[2].AsString;
              FLocalDataBaseDiff.Fields[3].AsString := DiffCDS.Fields[3].AsString;
              FLocalDataBaseDiff.Fields[4].AsString := DiffCDS.Fields[4].AsString;
              FLocalDataBaseDiff.Fields[5].AsString := DiffCDS.Fields[5].AsString;
              FLocalDataBaseDiff.Fields[6].AsString := DiffCDS.Fields[6].AsString;
              FLocalDataBaseDiff.Fields[7].AsString := DiffCDS.Fields[7].AsString;
              FLocalDataBaseDiff.Post;
              DiffCDS.Next;
            end;
            FLocalDataBaseDiff.Close;
            ReleaseMutex(MutexDBFDiff);
            // Отправка сообщения приложению про надобность обновить остатки из файла
            PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 1);
          end;
        except
          if gc_User.Local then
          begin
            tiServise.BalloonHint := 'Останавливаем проведение чеков';
            tiServise.ShowBalloonHint;
            Exit;
          end;
        end;
      finally
        ReleaseMutex(MutexRemains);
      end;
      WaitForSingleObject(MutexRemains, INFINITE);
      SaveLocalData(MainCashForm2.RemainsCDS, Remains_lcl);
      ReleaseMutex(MutexRemains);
      WaitForSingleObject(MutexAlternative, INFINITE);
      SaveLocalData(MainCashForm2.AlternativeCDS, Alternative_lcl);
      ReleaseMutex(MutexAlternative);
      if FNeedSaveVIP then
      begin
        MainCashForm2.SaveLocalVIP;
      end;
    end;
  finally
    tiServise.Hint := '';
    ReleaseMutex(MutexAllowedConduct);
    ReleaseMutex(MutexRefresh);
    MainCashForm2.tiServise.IconIndex := 0;
  end;
end;

{ TRefreshDiffThread }
{ TSaveRealAllThread }

procedure TMainCashForm2.FormDestroy(Sender: TObject);
begin
 CloseHandle(MutexDBF);
 CloseHandle(MutexDBFDiff);
 CloseHandle(MutexVip);
 CloseHandle(MutexRemains);
 CloseHandle(MutexAlternative);
 CloseHandle(MutexRefresh);
end;


initialization
  RegisterClass(TMainCashForm2);
  FLocalDataBaseHead := TVKSmartDBF.Create(nil);
  FLocalDataBaseBody := TVKSmartDBF.Create(nil);
  FLocalDataBaseDiff := TVKSmartDBF.Create(nil);
  FM_SERVISE := RegisterWindowMessage('FarmacyCashMessage');
finalization
  FLocalDataBaseHead.Free;
  FLocalDataBaseBody.Free;
  FLocalDataBaseDiff.Free;
end.
