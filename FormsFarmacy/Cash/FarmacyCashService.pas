unit FarmacyCashService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.DateUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  DataModul,  Vcl.ActnList, dsdAction,
  System.IOUtils, Data.DB,  Vcl.ExtCtrls, dsdDB, Datasnap.DBClient,  Vcl.Menus,  Vcl.StdCtrls,
  IniFIles, dxmdaset,  ActiveX,  Math,  VKDBFDataSet, FormStorage, CommonData, ParentForm,
  LocalWorkUnit , IniUtils, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  cxButtons, Vcl.Grids, Vcl.DBGrids, AncestorBase, cxPropertiesStore, cxControls,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,  cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid,  cxSplitter, cxContainer,  cxTextEdit, cxCurrencyEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox,  cxCheckBox, cxNavigator, CashInterface,  cxImageComboBox , dsdAddOn,
  Vcl.ImgList, LocalStorage, IdFTPCommon, IdGlobal, IdFTP, IdSSLOpenSSL, IdExplicitTLSClientServerBase,
  UnilWin, System.ImageList, System.Actions;

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
    PROMOCODE   : Integer;       //Id промокода
    //***21.06.18
    MANUALDISC  : Integer;       //Ручная скидка
    //***02.11.18
    SUMMPAYADD  : Currency;       //Ручная скидка
    //***21.06.18
    MEMBERSPID  : Integer;       //ФИО пациента
    //***28.01.19
    SITEDISC    : boolean;       //Дисконт через сайт
    //***20.02.19
    BANKPOS     : integer;       //Банк POS терминала
    //***25.02.19
    JACKCHECK   : integer;       //Галка
    //***02.04.19
    ROUNDDOWN   : boolean;       //Округление в низ
    //***15.05.19
    PDKINDID    : integer;       //Тип срок/не срок
    CONFCODESP  : String[10];    //Код подтверждения рецепта
    //***07.11.19
    LOYALTYID   : integer;       //Регистрация промокода
    //***15.01.20
    LOYALTYSM   : integer;       //Программа лояльности накопительная
    LOYALSMSUM  : Currency;      //Сумма скидки по Программа лояльности накопительная
    //***15.01.20
    MEDICFS  : String[100];      //ФИО врача (на продажу)
    BUYERFS  : String[100];      //ФИО покупателя (на продажу)
    BUYERFSP : String[100];      //Телефон покупателя (на продажу)
    DISTPROMO : String[254];     //Раздача акционных материалов.

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
    //***03.06.19
    PDKINDID: Integer;      // Тип срок/не срок
    //***24.06.19
    PRICEPD: Currency;      // Отпускная цена согласно партии
    //***16.04.20
    NDSKINDId: Integer;     // Тип срок/не срок
    //***20.06.20
    DISCEXTID: Integer;     // Дисконтная программы
    //***20.06.20
    DIVPARTID: Integer;     // Разделение партий в кассе для продажи
    //***05.10.20
    ISPRESENT: Boolean;     // Подарок
    //***10.08.16
    LIST_UID: String[50]    // UID строки продажи
  end;
  TBodyArr = Array of TBodyRecord;


  TMainCashForm2 = class(TForm)
    FormParams: TdsdFormParams;
    spDelete_CashSession: TdsdStoredProc;
    gpUpdate_Log_CashRemains: TdsdStoredProc;

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
    ListDiffCDS: TClientDataSet;
    spSendListDiff: TdsdStoredProc;
    spLoadFTPParam: TdsdStoredProc;
    EmployeeWorkLogCDS: TClientDataSet;
    spEmployeeWorkLog: TdsdStoredProc;
    TimerNeedRemainsDiff: TTimer;
    EmployeeScheduleCDS: TClientDataSet;
    spEmployeeSchedule: TdsdStoredProc;
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
    procedure gpUpdate_Log_CashRemainsAfterExecute(Sender: TObject);
    procedure spSelectRemainsAfterExecute(Sender: TObject);
    procedure TimerNeedRemainsDiffTimer(Sender: TObject);
    procedure CashRemainsDiffExecute;

  private
    { Private declarations }
    procedure AppException(Sender: TObject; E: Exception);
    procedure AppMsgHandler(var Msg: TMsg; var Handled: Boolean);
  public
    { Public declarations }


    ThreadErrorMessage:String;

    FiscalNumber: String;
    FSaveRealAllRunning: boolean;
    FirstRemainsReceived: boolean;
    FHasError: boolean;

    function SetFarmacyNameByUser : boolean;

    function SaveCashRemains : Boolean;
    procedure SaveCashRemainsDif;
    procedure SaveLocalVIP;
    procedure SaveLocalGoods;
    procedure SaveLocalDiffKind;
    procedure SaveRealAll;
    procedure SaveListDiff;
    procedure SaveBankPOSTerminal;
    procedure SaveUnitConfig;
    procedure SaveUserHelsi;
    procedure SaveUserSettings;
    procedure SaveTaxUnitNight;
    procedure SaveGoodsExpirationDate;
    procedure SaveBuyer;
    procedure SaveDistributionPromo;
//    procedure SaveGoodsAnalog;

    procedure SendZReport;
    procedure SendEmployeeWorkLog;
    procedure SendEmployeeSchedule;
    procedure SecureUpdateVersion;
    procedure ChangeStatus(AStatus: String);
    function InitLocalStorage: Boolean;
    function ExistNotCompletedCheck: boolean;
    procedure Add_Log(AMessage: String);
    function GetTrayIcon: integer;
    function GetInterval_CashRemains_Diff: integer;
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

  FM_SERVISE: Integer;
    function GenerateGUID: String;
implementation

{$R *.dfm}

function TMainCashForm2.GetInterval_CashRemains_Diff: integer;
var dsdProc: TdsdStoredProc;
begin
  try
    dsdProc := TdsdStoredProc.Create(nil);
    try
      dsdProc.StoredProcName := 'zc_Interval_CashRemains_Diff';
      dsdProc.OutputType := otResult;
      dsdProc.Params.Clear;
      dsdProc.Params.AddParam('zc_Interval_CashRemains_Diff',ftInteger,ptOutput,Null);
      dsdProc.Execute(False,False);
      Result := dsdProc.Params.ParamByName('zc_Interval_CashRemains_Diff').Value;
    finally
      FreeAndNil(dsdProc);
    end;
  except
    Result := TimerSaveReal.Interval;
  end;
end;

procedure TMainCashForm2.AppMsgHandler(var Msg: TMsg; var Handled: Boolean);
var msgStr: String;
begin
  try
    Handled := (Msg.hwnd = Application.Handle) and (Msg.message = FM_SERVISE);
    if Handled and (Msg.wParam = 2) then
      case Msg.lParam of
        2: actSetCashSessionId.Execute;    // обновление кеш сесии

        3: begin
            if SetFarmacyNameByUser then SaveRealAll;    // попросили провести чеки
            tiServise.Hint := '';
           end;

        4: begin
             if SetFarmacyNameByUser then SaveListDiff;  // попросили отправить листы звквзов
             tiServise.Hint := '';
           end;

        5: begin
             if SetFarmacyNameByUser then SendZReport;  // попросили отправить Z отчеты
             tiServise.Hint := '';
           end;

        9: begin
  //           ShowMessage('запрос на выключение');
             if SetFarmacyNameByUser then SendEmployeeWorkLog;
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
               ChangeStatus('Обновление всего');
               Add_Log('Обновление всего');
               actRefreshAllExecute(nil);
            end;

        40: begin // получен запрос на обновление только остатков
               actCashRemainsExecute(nil);
            end;

      end;
  except on E: Exception do
    Add_Log('AppMsgHandler Exception: ' + E.Message);
  end;
end;

procedure TMainCashForm2.AppException(Sender: TObject; E: Exception);
begin
  Add_Log('Application Exception: ' + E.Message);
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
  Add_Log('Start MutexDBF 266');
  WaitForSingleObject(MutexDBF, INFINITE);
  try
    FLocalDataBaseHead.Active := True;
    FLocalDataBaseHead.First;
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
    Add_Log('End MutexDBF 266');
    ReleaseMutex(MutexDBF);
  end;
end;

procedure TMainCashForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  AllowedConduct := True; // Просим досрочно прекратить проведения чеков
  Add_Log('Start MutexRefresh 290');
  WaitForSingleObject(MutexRefresh, INFINITE);
  try
    if CanClose then
    Begin
      try
        if not gc_User.Local then
        Begin
          spDelete_CashSession.Execute;
        End
        else
        begin
          Add_Log('Start MutexRemains 302');
          WaitForSingleObject(MutexRemains, INFINITE);
          try
            SaveLocalData(RemainsCDS,remains_lcl);
          finally
            Add_Log('End MutexRemains 302');
            ReleaseMutex(MutexRemains);
          end;

//          Add_Log('Start MutexAlternative 311');
//          WaitForSingleObject(MutexAlternative, INFINITE);
//          try
//            SaveLocalData(AlternativeCDS,Alternative_lcl);
//          finally
//            Add_Log('End MutexAlternative 311');
//            ReleaseMutex(MutexAlternative);
//          end;
        end;
      Except
      end;

    End;
  finally
    Add_Log('End MutexRefresh 290');
    ReleaseMutex(MutexRefresh);
  end;
end;

procedure TMainCashForm2.CashRemainsDiffExecute;
begin

  try
    TimerNeedRemainsDiff.Enabled := False;
    MainCashForm2.tiServise.IconIndex:=1;
    Application.ProcessMessages;
    if SetFarmacyNameByUser then
    begin
      //Получение конфигурации аптеки
      SaveUnitConfig;
      //Получение Сотрудников и настроек
      SaveUserSettings;
      //Получение разницы остатков
      SaveCashRemainsDif;
      //Получение остатков по партиям
      if not gc_User.Local then SaveGoodsExpirationDate;
      //Получение справочника аналогов
//      if not gc_User.Local then SaveGoodsAnalog;
      // Отправка сообщения приложению про надобность обновить остатки из файла
      PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 1);
      // Меняем хинт
      if gc_User.Local then
      begin
        tiServise.BalloonHint:='Обрыв соединения';
      end else
      begin
        tiServise.BalloonHint:='Разница в остатках получена.';
      end;
      tiServise.Hint := 'Ожидание задания.';
      end else
    begin
      tiServise.BalloonHint:='Ошибка сохранения аптеки содруднику.';
    end;
  finally
    tiServise.Hint := '';
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    Application.ProcessMessages;
    TimerNeedRemainsDiff.Enabled := True;
  end;
end;


procedure TMainCashForm2.actCashRemainsExecute(Sender: TObject);
begin
  if FSaveRealAllRunning then Exit; // нельзя запускать, пока отгружаются чеки
  if ExistNotCompletedCheck then Exit; // нельзя получать, пока есть неотгруженные чеки

  if TimerNeedRemainsDiff.Enabled then CashRemainsDiffExecute;
end;

procedure TMainCashForm2.actRefreshAllExecute(Sender: TObject);
var bError: boolean;
begin   //yes
  if FSaveRealAllRunning then Exit; // нельзя запускать, пока отгружаются чеки
  if ExistNotCompletedCheck then Exit; // нельзя запускать, пока есть неотгруженные чеки
  // обновления данных с сервера
  Add_Log('Refresh all start');
  bError := false;
  try
    MainCashForm2.tiServise.IconIndex:=1;
    // посылаем сообщение о начале получения полных остатков
    PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 4);
    Application.ProcessMessages;

    if not gc_User.Local  then
    Begin
      if SetFarmacyNameByUser then
      begin

        //Получение конфигурации аптеки
        SaveUnitConfig;
        //Получение Сотрудников и настроек
        SaveUserSettings;
        //Получение Сотрудников для сайта Хелси
        SaveUserHelsi;
        //Получение остатков
        bError := SaveCashRemains;
        if bError then
        begin
         // посылаем сообщение о ошибке получения полных остатков
         PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 5);
        end;
        //Проверка обновления программ
        if not gc_User.Local then SecureUpdateVersion;
        //Получение ВИП чеков и сохранение в локальной базе
        if not gc_User.Local then SaveLocalVIP;
        //Получение товаров
        if not gc_User.Local then SaveLocalGoods;
        //Получение причин отказов
        if not gc_User.Local then SaveLocalDiffKind;
        //Получение POS терминалов
        if not gc_User.Local then SaveBankPOSTerminal;
        //Получение ночных скидок
        if not gc_User.Local then SaveTaxUnitNight;
        //Получение остатков по партиям
        if not gc_User.Local then SaveGoodsExpirationDate;
        //Получение покупателей
        if not gc_User.Local then SaveBuyer;
        //Получение Раздача акционных материалов
        if not gc_User.Local then SaveDistributionPromo;
        //Получение справочника аналогов
//        if not gc_User.Local then SaveGoodsAnalog;

        PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 3);
        // Вывод уведомления сервиса
        if gc_User.Local then
        begin
          tiServise.BalloonHint:='Обрыв соединения';
          tiServise.ShowBalloonHint;
        end else
        begin
          tiServise.BalloonHint:='Остатки обновлены.';
          tiServise.ShowBalloonHint;
          FirstRemainsReceived := true;
        end;
        tiServise.Hint := 'Ожидание задания.';
      end else
      begin
        tiServise.BalloonHint:='Ошибка сохранения аптеки содруднику.';
        tiServise.ShowBalloonHint;
      end;
    End;
  finally
    tiServise.Hint := '';
    if not bError then ChangeStatus('Сохранили');
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    Application.ProcessMessages;
    Add_Log('Refresh all end');
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
  Add_Log('== Start');
  if ParamStr(1) = 'Админ' then  // показываем меню только для Админа
    tiServise.PopupMenu:=pmServise
  else tiServise.PopupMenu:=nil;

  Application.OnMessage := AppMsgHandler;
  InitMutex;
  FHasError := false;
  //сгенерили гуид для определения сессии
  ChangeStatus('Установка первоначальных параметров');

  FormParams.ParamByName('ClosedCheckId').Value := 0;
  FormParams.ParamByName('CheckId').Value := 0;
  FormParams.ParamByName('CashSessionId').Value := iniLocalGUIDSave(GenerateGUID);

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
  FSaveRealAllRunning := false;
  TimerSaveReal.Enabled := false;
  if SetFarmacyNameByUser then
  begin
    SaveUnitConfig; // Обновляем конфигурацию
    SaveRealAll;  // Проводим чеки которые остались не проведенными раньше. Учитывается CountСhecksAtOnce = 7
                  // проведутся первые 7 чеков и будут ждать или таймер или пока не пройдет первая покупка
    SaveListDiff; // Отправляем листы отказов
    SendZReport;  // Отправляем Z отчеты
    SendEmployeeWorkLog;  // Отправляем лога работы сотрудников
    SendEmployeeSchedule;  // Отправляем времени работы сотрудников
    tiServise.Hint := '';
  end;
  if not FHasError then
    ChangeStatus('Получение остатков');
  FirstRemainsReceived := false;
  //PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 2); // запрос кеш сесии у приложения
  TimerGetRemains.Enabled := true;
 //}
  if not FHasError then
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
  if SetFarmacyNameByUser then SaveRealAll;
end;

procedure TMainCashForm2.N4Click(Sender: TObject);
begin
 MainCashForm2.Close;
end;

procedure TMainCashForm2.N5Click(Sender: TObject);
begin
  try
    MainCashForm2.tiServise.IconIndex:=1;
    Application.ProcessMessages;
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
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    Application.ProcessMessages;
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
  Add_Log('Start MutexDBF 563');
  WaitForSingleObject(MutexDBF, INFINITE);
  Add_Log('Start MutexDBFDiff 565');
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
    Add_Log('End MutexDBF 563');
    ReleaseMutex(MutexDBF);
    Add_Log('End MutexDBFDiff 565');
    ReleaseMutex(MutexDBFDiff);
  end;
end;

function TMainCashForm2.SaveCashRemains : boolean;
  var nRemainsFieldCount: integer;
begin
  Result := False;
  tiServise.Hint := 'Получение остатков';
  Add_Log('Start MutexRemains 390');
  WaitForSingleObject(MutexRemains, INFINITE);
  RemainsCDS.DisableControls;
  try
    try
      nRemainsFieldCount := -1;
      if RemainsCDS.Active then
        nRemainsFieldCount := RemainsCDS.Fields.Count;
      //Получение остатков
      actRefresh.Execute;
      //Проверка количества столбцов в новом наборе
      if (nRemainsFieldCount > RemainsCDS.Fields.Count) then
      begin
        tiServise.BalloonHint:='Ошибка при получении остатков - были получены неполные данные.';
        tiServise.ShowBalloonHint;
        Result := true;
        Add_Log('Ошибка при получении остатков');
        Add_Log('Remains: было столбцов: '+ IntToStr(nRemainsFieldCount) + ', получено: '+ IntToStr(RemainsCDS.Fields.Count));
        Exit;
      end;
      //Сохранение остатков в локальной базе
      SaveLocalData(RemainsCDS,Remains_lcl);
    Except ON E:Exception do
      Add_Log('Ошибка при получении остатков:' + E.Message);
    end;
  finally
    RemainsCDS.EnableControls;
    Add_Log('End MutexRemains 390');
    ReleaseMutex(MutexRemains);
  end;
end;

//function TMainCashForm2.SaveCashRemains : boolean;
//  var nRemainsFieldCount, nAlternativeFieldCount: integer;
//begin
//  Result := False;
//  tiServise.Hint := 'Получение остатков';
//  Add_Log('Start MutexRemains 390');
//  WaitForSingleObject(MutexRemains, INFINITE);
//  Add_Log('Start MutexAlternative 393');
//  WaitForSingleObject(MutexAlternative, INFINITE);
//  RemainsCDS.DisableControls;
//  AlternativeCDS.DisableControls;
//  try
//    try
//      nRemainsFieldCount := -1;
//      if RemainsCDS.Active then
//        nRemainsFieldCount := RemainsCDS.Fields.Count;
//      nAlternativeFieldCount := -1;
//      if AlternativeCDS.Active then
//        nAlternativeFieldCount := AlternativeCDS.Fields.Count;
//      //Получение остатков
//      actRefresh.Execute;
//      //Проверка количества столбцов в новом наборе
//      if (nRemainsFieldCount > RemainsCDS.Fields.Count)
//         or
//         (nAlternativeFieldCount > AlternativeCDS.Fields.Count) then
//      begin
//        tiServise.BalloonHint:='Ошибка при получении остатков - были получены неполные данные.';
//        tiServise.ShowBalloonHint;
//        Result := true;
//        Add_Log('Ошибка при получении остатков');
//        Add_Log('Remains: было столбцов: '+ IntToStr(nRemainsFieldCount) + ', получено: '+ IntToStr(RemainsCDS.Fields.Count));
//        Add_Log('Alternative: было столбцов: '+ IntToStr(nAlternativeFieldCount) + ', получено: '+ IntToStr(AlternativeCDS.Fields.Count));
//        Exit;
//      end;
//      //Сохранение остатков в локальной базе
//      SaveLocalData(RemainsCDS,Remains_lcl);
//      SaveLocalData(AlternativeCDS,Alternative_lcl);
//    Except ON E:Exception do
//      Add_Log('Ошибка при получении остатков:' + E.Message);
//    end;
//  finally
//    RemainsCDS.EnableControls;
//    AlternativeCDS.EnableControls;
//    Add_Log('End MutexRemains 390');
//    ReleaseMutex(MutexRemains);
//    Add_Log('End MutexAlternative 393');
//    ReleaseMutex(MutexAlternative);
//  end;
//end;

procedure TMainCashForm2.SaveCashRemainsDif;
  var I : integer;
begin
  tiServise.Hint := 'Получение разницы остатков';
  Add_Log('Start MutexRemains 335');
  WaitForSingleObject(MutexRemains, INFINITE);
  try
    try
      MainCashForm2.spSelect_CashRemains_Diff.Execute(False, False, False);
      DiffCDS.First;
      if DiffCDS.FieldCount > 0 then
      begin
        Add_Log('Start MutexDBFDiff 344');
        WaitForSingleObject(MutexDBFDiff, INFINITE);
        try
          FLocalDataBaseDiff.Open;
          while not DiffCDS.Eof  do
          begin
             FLocalDataBaseDiff.Append;
             for I := 0 to Min(FLocalDataBaseDiff.FieldCount, DiffCDS.FieldCount) - 1 do
               FLocalDataBaseDiff.Fields[I].AsVariant:=DiffCDS.Fields[I].AsVariant;
             FLocalDataBaseDiff.Post;
             DiffCDS.Next;
          end;
          FLocalDataBaseDiff.Close;
        finally
          Add_Log('End MutexDBFDiff 344');
          ReleaseMutex(MutexDBFDiff);
        end;
      end;
    except
      if gc_User.Local then
      begin
         tiServise.BalloonHint:='Локальный режим';
         tiServise.ShowBalloonHint;
      end;
    end;
  finally
    Add_Log('End MutexRemains 335');
    ReleaseMutex(MutexRemains);
//    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
  end;
end;

procedure TMainCashForm2.SaveLocalVIP;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin  //+
  // pr вызывается из обновления остатков
  tiServise.Hint := 'Получение информации о VIP чеках';
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Object_Member';
        sp.Params.Clear;
        sp.Params.AddParam('inIsShowAll',ftBoolean,ptInput,False);
        sp.Execute(False,False);
        Add_Log('Start MutexVip 604');
        WaitForSingleObject(MutexVip, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,Member_lcl);
        finally
          Add_Log('End MutexVip 604');
          ReleaseMutex(MutexVip);
        end;

        sp.StoredProcName := 'gpSelect_Movement_CheckVIP';
        sp.Params.Clear;
        sp.Params.AddParam('inIsErased',ftBoolean,ptInput,False);
        sp.Execute(False,False);
        Add_Log('Start MutexVip 617');
        WaitForSingleObject(MutexVip, INFINITE);
        try
          SaveLocalData(ds,Vip_lcl);
        finally
          Add_Log('End MutexVip 617');
          ReleaseMutex(MutexVip);
        end;

        sp.StoredProcName := 'gpSelect_MovementItem_CheckDeferred';
        sp.Params.Clear;
        sp.Execute(False,False);
        Add_Log('Start MutexVip 629');
        WaitForSingleObject(MutexVip, INFINITE);
        try
          SaveLocalData(ds,VipList_lcl);
        finally
          Add_Log('End MutexVip 629');
          ReleaseMutex(MutexVip);
        end;
      Except ON E:Exception do
        Add_Log('Ошибка отправки листа отказов:' + E.Message);
      end;
    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.SaveLocalGoods;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
  DateTime: TDateTimeInfoRec;
begin  //+
  // pr вызывается из обновления остатков
  // Проверяем обновляли ли сегодня

  if FileExists(Goods_lcl) and FileGetDateTimeInfo(Goods_lcl, DateTime) and
    (StartOfTheDay(DateTime.CreationTime) >= Date) then Exit;

  tiServise.Hint := 'Получение списка медикаментов';
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      sp.OutputType := otDataSet;
      sp.DataSet := ds;

      sp.StoredProcName := 'gpSelect_CashGoods';
      sp.Params.Clear;
      sp.Execute;
      Add_Log('Start MutexGoods');
      WaitForSingleObject(MutexGoods, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
      try
        SaveLocalData(ds,Goods_lcl);
      finally
        Add_Log('End MutexGoods');
        ReleaseMutex(MutexGoods);
      end;

    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
  end;

  // Очистка лисиа заказов
  if FileExists(ListDiff_lcl) then
  begin
    Add_Log('Start MutexDiffCDS');
    WaitForSingleObject(MutexDiffCDS, INFINITE);
    try
      try

        LoadLocalData(ListDiffCDS, ListDiff_lcl);
        if not ListDiffCDS.Active then ListDiffCDS.Open;

        ListDiffCDS.First;
        while not ListDiffCDS.Eof do
        begin
          if ListDiffCDS.FieldByName('IsSend').AsBoolean and
            (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) < IncDay(Date, - 1)) then
          begin
            ListDiffCDS.Delete;
            Continue;
          end;
          ListDiffCDS.Next;
        end;
        SaveLocalData(ListDiffCDS, ListDiff_lcl);

      Except ON E:Exception do
        Add_Log('Ошибка отправки листа отказов:' + E.Message);
      end;
    finally
      Add_Log('End MutexDiffCDS');
      ReleaseMutex(MutexDiffCDS);
    end;
  end;
end;

procedure TMainCashForm2.SaveLocalDiffKind;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
  DateTime: TDateTimeInfoRec;
begin  //+
  // pr вызывается из обновления остатков

  tiServise.Hint := 'Получение причин отказов';
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      sp.OutputType := otDataSet;
      sp.DataSet := ds;

      sp.StoredProcName := 'gpSelect_Object_DiffKindCash';
      sp.Params.Clear;
      sp.Execute;
      Add_Log('Start MutexDiffKind');
      WaitForSingleObject(MutexDiffKind, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
      try
        SaveLocalData(ds,DiffKind_lcl);
      finally
        Add_Log('End MutexDiffKind');
        ReleaseMutex(MutexDiffKind);
      end;

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
    if SetFarmacyNameByUser then
    begin
      SaveRealAll;
      SaveListDiff;
      SendZReport;
      SendEmployeeWorkLog;
      SendEmployeeSchedule;
    end;
  finally
    tiServise.Hint := '';
    TimerSaveReal.Enabled := True;
  end;
end;

procedure TMainCashForm2.TimerGetRemainsTimer(Sender: TObject);
begin
  TimerGetRemains.Enabled := False;
  TimerGetRemains.Interval := 60000;
  Add_Log('Start MutexRefresh 660');
  WaitForSingleObject(MutexRefresh, INFINITE);
  try
    actRefreshAllExecute(nil);
  finally
    Add_Log('End MutexRefresh 660');
    ReleaseMutex(MutexRefresh);
    TimerGetRemains.Enabled := not FirstRemainsReceived;
    TimerNeedRemainsDiff.Enabled := not TimerGetRemains.Enabled;
  end;
end;

procedure TMainCashForm2.TimerNeedRemainsDiffTimer(Sender: TObject);
  var dsdSave : TdsdStoredProc; bRun : boolean;
begin
  TimerNeedRemainsDiff.Enabled := False;
  TimerNeedRemainsDiff.Interval := 120000;
  try

    bRun := False;
    dsdSave := TdsdStoredProc.Create(nil);
    try
      dsdSave.StoredProcName := 'gpSelect_Cash_NeedRemainsDiff';
      dsdSave.OutputType := otResult;
      dsdSave.Params.Clear;
      dsdSave.Params.AddParam('inCashSessionId', ftString, ptInput, FormParams.ParamByName('CashSessionId').Value);
      dsdSave.Params.AddParam('outIsRemainsDiff', ftBoolean, ptOutput, False);
      try
        Add_Log('Start Execute gpSelect_Cash_NeedRemainsDiff');
        dsdSave.Execute(False, False);
        bRun := dsdSave.ParamByName('outIsRemainsDiff').Value;
      except
        on E: Exception do
        Begin
          Add_Log('Error gpSelect_Cash_NeedRemainsDiff: ' + E.Message);
        End;
      end;
    finally
      freeAndNil(dsdSave);
    end;

    if bRun then
    begin
      Add_Log('Start CashRemainsDiffExecute');
      CashRemainsDiffExecute;
      Add_Log('End CashRemainsDiffExecute');
    end;
  finally
    TimerNeedRemainsDiff.Enabled := True;
  end;
end;

function TMainCashForm2.SetFarmacyNameByUser : boolean;
var
  sp : TdsdStoredProc;
begin
  // pr Cохранения аптеки содруднику
  tiServise.Hint := 'Cохранения аптеки содруднику';
  Result := False;
  sp := TdsdStoredProc.Create(nil);
  try
    try
      sp.OutputType := otResult;
      sp.StoredProcName := 'gpGet_CheckFarmacyName_byUser';
      sp.Params.Clear;
      sp.Params.AddParam('outIsEnter', ftBoolean, ptOutput, Null);
      sp.Params.AddParam('outUnitId', ftInteger, ptOutput, Null);
      sp.Params.AddParam('inUnitName',ftString,ptInput, iniLocalUnitNameGet);
      if sp.Execute(False,False) = '' then
      begin
        Result := sp.Params.ParamByName('outIsEnter').Value;

        if gc_User.Local then
        begin
          gc_User.Local := False;
          Add_Log('-- Связь востановлена');
          tiServise.BalloonHint := 'Связь востановлена';
          tiServise.ShowBalloonHint;
          PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 6);
        end;
      end;

    Except ON E:Exception do
      begin
        Add_Log('Ошибка сохранения аптеки содруднику:' + E.Message);
        if not gc_User.Local then
        begin
          gc_User.Local := True;
          Add_Log('-- Нет связи с интернетом');
          tiServise.BalloonHint := 'Локальный режим';
          tiServise.ShowBalloonHint;
          PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 6);
        end;
        tiServise.Hint := 'Локальный режим';
        MainCashForm2.tiServise.IconIndex := GetTrayIcon;
        Application.ProcessMessages;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.spSelectRemainsAfterExecute(Sender: TObject);
begin

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
  FNEEDCOMPL, FSAVE: boolean;
  FSaveUID: string;
  FSaveTryCount: integer;
  bShowDisconnectMsg: boolean;
  BodySaved: boolean;

  function LocateUID(AUID: string; ASave: boolean): boolean;
  begin
    Result := false;
    FLocalDataBaseHead.First;
    while not FLocalDataBaseHead.Eof do
    begin
      if (Trim(FLocalDataBaseHead.FieldByName('UID').AsString) = AUID) and
         (FLocalDataBaseHead.FieldByName('SAVE').AsBoolean = ASAVE) then
      begin
        Result := true;
        break;
      end;
      FLocalDataBaseHead.Next;
    end;
  end;

begin
  if FSaveRealAllRunning then Exit;
  FSaveRealAllRunning := true;
  try
    Add_Log('SaveReal start');
    TimerSaveReal.Enabled := false;
    try
      MainCashForm2.tiServise.IconIndex := 4;
      Application.ProcessMessages;
      bShowDisconnectMsg := not gc_User.Local;
      spGet_User_IsAdmin.Execute;
      if gc_User.Local then
      begin
        gc_User.Local := False;
        Add_Log('-- Связь востановлена');
        tiServise.BalloonHint := 'Связь востановлена';
        tiServise.ShowBalloonHint;
        PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 6);
      end;
    except on E: Exception do
      begin
        Add_Log(E.Message);
        if bShowDisconnectMsg then
        begin
          gc_User.Local := True;
          Add_Log('-- Нет связи с интернетом');
          tiServise.BalloonHint := 'Локальный режим';
          tiServise.ShowBalloonHint;
          PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 6);
        end;
        Exit;
      end;
    end;

    // Запускаем поиски чеков если разрешено
    if AllowedConduct then
    begin
      Add_Log('SaveReal Allowed Conduct Exit');
      Exit;
    end;

    MainCashForm2.tiServise.IconIndex := 2;
    Application.ProcessMessages;
    Add_Log('Start MutexRefresh 732');
    WaitForSingleObject(MutexRefresh, INFINITE); // одновременно проведение и обновление всех остатков запрещено
    Add_Log('Start MutexAllowed 734');
    WaitForSingleObject(MutexAllowedConduct, INFINITE); // для отмены проведения из приложения при закрытии
    FNeedGetDiff := false;
    try
      tiServise.Hint := 'Проведение чеков';
      FSaveUID := '';
      FSaveTryCount := 0;
      FHasError := false;
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

        Add_Log('Start MutexDBF 754');
        WaitForSingleObject(MutexDBF, INFINITE);
        try
          FLocalDataBaseHead.Active := True;
          FLocalDataBaseBody.Active := True;
          FLocalDataBaseHead.Pack;
          FLocalDataBaseBody.Pack;
          FLocalDataBaseHead.First;
          UID := '';
          while not FLocalDataBaseHead.eof do
          Begin
            if not FLocalDataBaseHead.Deleted and
              (Trim(FLocalDataBaseHead.FieldByName('UID').AsString) <> '') and
              (FLocalDataBaseHead.FieldByName('NEEDCOMPL').AsBoolean
               or not FLocalDataBaseHead.FieldByName('SAVE').AsBoolean) then
            Begin
              UID := trim(FLocalDataBaseHead.FieldByName('UID').AsString);
              FNEEDCOMPL := FLocalDataBaseHead.FieldByName('NEEDCOMPL').AsBoolean;
              FSAVE := FLocalDataBaseHead.FieldByName('SAVE').AsBoolean;
              break;
            End;
            FLocalDataBaseHead.Next;
          End;
        finally
          FLocalDataBaseBody.Active := False;
          FLocalDataBaseHead.Active := False;
          Add_Log('End MutexDBF 754');
          ReleaseMutex(MutexDBF);
        end;

        // если чеков нет, выходим из цикла
        if UID = '' then
          break;

        if UID <> '' then
        Begin
          if (FSaveUID = UID) and (FSaveTryCount > 2) then
          begin
            Add_Log('Повторная попытка отгрузить чек ' + UID);
            tiServise.BalloonHint := 'Внимание! Повторная попытка отгрузить чек, дальнейшая выгрузка чеков в офис прекращена!';
            tiServise.ShowBalloonHint;
            FHasError := true;
            Exit;
          end;
          if FSaveUID = UID then
            inc(FSaveTryCount)
          else
            FSaveTryCount := 0;
          FSaveUID := UID;
          Find := False;
          Add_Log('Start MutexDBF 803');
          WaitForSingleObject(MutexDBF, INFINITE);
          try
            FLocalDataBaseHead.Active := True;
            FLocalDataBaseBody.Active := True;
            if LocateUID(UID, FSAVE) and not FLocalDataBaseHead.Deleted then
            Begin
              Find := True;

              if FLocalDataBaseHead.FieldByName('NEEDCOMPL').AsBoolean then
              begin
                tiServise.Hint := 'Проведение чеков';
                MainCashForm2.tiServise.IconIndex := 2;
              end else
              begin
                tiServise.Hint := 'Сохранение VIP чека';
                MainCashForm2.tiServise.IconIndex := 8;
              end;
              Application.ProcessMessages;

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
                // ***21.06.18
                MANUALDISC := FieldByName('MANUALDISC').AsInteger;
                // ***02.11.18
                SUMMPAYADD := FieldByName('SUMMPAYADD').AsCurrency;
                // ***14.01.19
                MEMBERSPID := FieldByName('MEMBERSPID').AsInteger;
                // ***28.01.19
                SITEDISC := FieldByName('SITEDISC').AsBoolean;
                // ***20.02.19
                BANKPOS := FieldByName('BANKPOS').AsInteger;
                // ***25.02.19
                JACKCHECK := FieldByName('JACKCHECK').AsInteger;
                // ***02.04.19
                ROUNDDOWN := FieldByName('ROUNDDOWN').AsBoolean;
                // ***15.05.19
                PDKINDID := FieldByName('PDKINDID').AsInteger;
                CONFCODESP := trim(FieldByName('CONFCODESP').AsString);
                // ***07.11.19
                LOYALTYID := FieldByName('LOYALTYID').AsInteger;
                // ***15.01.20
                LOYALTYSM := FieldByName('LOYALTYSM').AsInteger;
                LOYALSMSUM := FieldByName('LOYALSMSUM').AsCurrency;
                // ***11.10.20
                MEDICFS := FieldByName('MEDICFS').AsString;
                BUYERFS := FieldByName('BUYERFS').AsString;
                BUYERFSP := FieldByName('BUYERFSP').AsString;
                DISTPROMO := FieldByName('DISTPROMO').AsString;

                FNeedSaveVIP := (MANAGER <> 0);
              end;
              SetLength(Body, 0);
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
                    // ***03.06.19
                    PDKINDID := FieldByName('PDKINDID').AsInteger;
                    // ***24.06.19
                    PRICEPD := FieldByName('PRICEPD').AsCurrency;
                    // ***16.04.20
                    NDSKINDID := FieldByName('NDSKINDID').AsInteger;
                    // ***20.06.20
                    DISCEXTID := FieldByName('DISCEXTID').AsInteger;
                    // ***20.06.20
                    DIVPARTID := FieldByName('DIVPARTID').AsInteger;
                    // ***05.10.20
                    ISPRESENT := FieldByName('ISPRESENT').AsBoolean;
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
            Add_Log('End MutexDBF 803');
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
                if (Head.ID > 0) and (VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2') then // проведен
                Begin
                  Add_Log('CheckState: Чек '+ IntToStr(Head.ID) +'уже проведен');
                  Head.SAVE := True;
                  Head.NEEDCOMPL := False;

                  Add_Log('Start MutexDBF 906');
                  WaitForSingleObject(MutexDBF, INFINITE);
                  try
                    FLocalDataBaseHead.Active := True;
                    if FLocalDataBaseHead.Locate('ID', Head.ID, []) then
                    Begin
                      FLocalDataBaseHead.Edit;
                      FLocalDataBaseHead.FieldByName('NEEDCOMPL').AsBoolean := false;
                      FLocalDataBaseHead.FieldByName('SAVE').AsBoolean := true;
                      FLocalDataBaseHead.Post;
                      FNEEDCOMPL := false;
                      FSAVE := true;
                    End;
                  finally
                    FLocalDataBaseHead.Active := False;
                    Add_Log('End MutexDBF 906');
                    ReleaseMutex(MutexDBF);
                  end;

                  // т.е. чек НЕЛЬЗЯ потом удалить из ДБФ
                  fError_isComplete := True; // 04.02.2017
                End
                else
                // Если не проведен
                Begin
                  if (Head.ID > 0) and (VarToStr(dsdSave.Params.ParamByName('outState').Value) = '3') then // Удален
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
                  if Head.ID > 0 then dsdSave.Params.AddParam('ioId', ftInteger, ptInputOutput, Head.ID)
                  else dsdSave.Params.AddParam('ioId', ftInteger, ptInputOutput, 0);
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
                  // ***05.02.18
                  dsdSave.Params.AddParam('inManualDiscount', ftInteger, ptInput, Head.MANUALDISC);
                  // ***02.11.18
                  dsdSave.Params.AddParam('inSummPayAdd', ftFloat, ptInput, Head.SUMMPAYADD);
                  // ***14.01.19
                  dsdSave.Params.AddParam('inMemberSPID', ftInteger, ptInput, Head.MEMBERSPID);
                  // ***28.01.19
                  dsdSave.Params.AddParam('inSiteDiscount', ftBoolean, ptInput, Head.SITEDISC);
                  // ***20.02.19
                  dsdSave.Params.AddParam('inBankPOSTerminalId', ftInteger, ptInput, Head.BANKPOS);
                  // ***20.02.19
                  dsdSave.Params.AddParam('inJackdawsChecksCode', ftInteger, ptInput, Head.JACKCHECK);
                  // ***02.04.19
                  dsdSave.Params.AddParam('inRoundingDown', ftBoolean, ptInput, Head.ROUNDDOWN);
                  // ***15.05.19
                  dsdSave.Params.AddParam('inPartionDateKindID', ftInteger, ptInput, Head.PDKINDID);
                  dsdSave.Params.AddParam('inConfirmationCodeSP', ftString, ptInput, Head.CONFCODESP);
                  // ***07.11.19
                  dsdSave.Params.AddParam('inLoyaltySignID', ftInteger, ptInput, Head.LOYALTYID);
                  // ***15.01.20
                  dsdSave.Params.AddParam('inLoyaltySMID', ftInteger, ptInput, Head.LOYALTYSM);
                  dsdSave.Params.AddParam('inLoyaltySMDiscount', ftFloat, ptInput, Head.LOYALSMSUM);
                  // ***11.10.20
                  dsdSave.Params.AddParam('inMedicForSale', ftString, ptInput, Head.MEDICFS);
                  dsdSave.Params.AddParam('inBuyerForSale', ftString, ptInput, Head.BUYERFS);
                  dsdSave.Params.AddParam('inBuyerForSalePhone', ftString, ptInput, Head.BUYERFSP);
                  dsdSave.Params.AddParam('inDistributionPromoList', ftString, ptInput, Head.DISTPROMO);
                  // ***24.01.17
                  dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                  Add_Log('Start Execute gpInsertUpdate_Movement_Check_ver2');
                  Add_Log('      ' + Head.UID);
                  dsdSave.Execute(False, False);
                  Add_Log('End Execute gpInsertUpdate_Movement_Check_ver2'+
                          ' ID = '+ dsdSave.Params.ParamByName('ioID').AsString);
                  // сохранили в локальной базе полученный номер
                  if Head.ID <> StrToInt(dsdSave.Params.ParamByName('ioID').AsString) then
                  Begin
                    Head.ID := StrToInt(dsdSave.Params.ParamByName('ioID').AsString);
                    Add_Log('HEAD.ID - ' + IntToStr(Head.ID));
                    Add_Log('Start MutexDBF 976');
                    WaitForSingleObject(MutexDBF, INFINITE);
                    try
                      FLocalDataBaseHead.Active := True;
                      if LocateUID(UID, FSAVE) AND not FLocalDataBaseHead.Deleted then
                      Begin
                        FLocalDataBaseHead.Edit;
                        FLocalDataBaseHead.FieldByName('ID').AsInteger := Head.ID;
                        FLocalDataBaseHead.Post;
                      End;
                    finally
                      FLocalDataBaseHead.Active := False;
                      Add_Log('End MutexDBF 976');
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
                  // ***03.06.19
                  dsdSave.Params.AddParam('inPartionDateKindID', ftInteger, ptInput, Null);
                  // ***24.06.19
                  dsdSave.Params.AddParam('inPricePartionDate', ftFloat, ptInput, Null);
                  // ***16.04.20
                  dsdSave.Params.AddParam('inNDSKindId', ftInteger, ptInput, Null);
                  // ***20.06.20
                  dsdSave.Params.AddParam('inDiscountExternalID', ftInteger, ptInput, Null);
                  // ***16.08.20
                  dsdSave.Params.AddParam('inDivisionPartiesID', ftInteger, ptInput, Null);
                  // ***05.10.20
                  dsdSave.Params.AddParam('inPresent', ftBoolean, ptInput, Null);
                  // ***10.08.16
                  dsdSave.Params.AddParam('inList_UID', ftString, ptInput, Null);
                  //
                  dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                  BodySaved := true;

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
                    // ***03.06.19
                    dsdSave.ParamByName('inPartionDateKindID').Value := Body[I].PDKINDID;
                    // ***24.06.19
                    dsdSave.ParamByName('inPricePartionDate').Value := Body[I].PRICEPD;
                    // ***16.04.20
                    dsdSave.ParamByName('inNDSKindId').Value := Body[I].NDSKINDId;
                    // ***20.06.20
                    dsdSave.ParamByName('inDiscountExternalID').Value := Body[I].DISCEXTID;
                    // ***16.08.20
                    dsdSave.ParamByName('inDivisionPartiesID').Value := Body[I].DIVPARTID;
                    // ***05.10.20
                    dsdSave.ParamByName('inPresent').Value := Body[I].ISPRESENT;
                    // ***10.08.16
                    dsdSave.ParamByName('inList_UID').Value := Body[I].LIST_UID;
                    //

                    Add_Log('Start Execute gpInsertUpdate_MovementItem_Check_ver2');
                    Add_Log('      ChildId - ' + Body[I].CH_UID + ' GoodsId - ' + IntToStr(Body[I].GOODSID) + ' Amount - ' + CurrToStr(Body[I].AMOUNT) + ' PriceSale - ' + CurrToStr(Body[I].PRICESALE));
                    dsdSave.Execute(False, False); // сохринили на сервере
                    Add_Log('      ID - ' + dsdSave.ParamByName('ioId').AsString);
                    Add_Log('End Execute gpInsertUpdate_MovementItem_Check_ver2');
                    if Body[I].ID <> StrToInt(dsdSave.ParamByName('ioId').AsString) then
                    Begin
                      Body[I].ID := StrToInt(dsdSave.ParamByName('ioId').AsString);
                      Add_Log('Start MutexDBF 1034');
                      WaitForSingleObject(MutexDBF, INFINITE);
                      try
                        FLocalDataBaseBody.Active := True;
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
                        Add_Log('End MutexDBF 1034');
                        ReleaseMutex(MutexDBF);
                      end;
                    End;
                    if Body[I].ID = 0 then
                    begin
                      Add_Log('Body was not saved!');
                      BodySaved := false;
                    end;
                  End; // обработали все позиции товара в чеке
                  if (Head.ID <> 0) and BodySaved then
                  begin
                    Head.SAVE := True;
                    Add_Log('Start MutexDBF 1059');
                    WaitForSingleObject(MutexDBF, INFINITE);
                    try
                      FLocalDataBaseHead.Active := True;
                      if LocateUID(UID, FSAVE) AND not FLocalDataBaseHead.Deleted then
                      Begin
                        FLocalDataBaseHead.Edit;
                        FLocalDataBaseHead.FieldByName('SAVE').AsBoolean := True;
                        FLocalDataBaseHead.Post;
                        FSAVE := True;
                      End;
                    finally
                      FLocalDataBaseHead.Active := False;
                      Add_Log('End MutexDBF 1059');
                      ReleaseMutex(MutexDBF);
                    end;
                  end;
                End; // обработали чек с товарами
              except
                ON E: Exception do
                Begin
                  Add_Log('InsertUpdate Check: ' + E.Message);
                  FHasError := true;
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
              dsdSave.StoredProcName := 'gpComplete_Movement_Check_ver2_NoDiff';
              dsdSave.OutputType := otResult;
              dsdSave.Params.Clear;
              dsdSave.Params.AddParam('inMovementId', ftInteger, ptInput, Head.ID);
              dsdSave.Params.AddParam('inPaidType', ftInteger, ptInput, Head.PAIDTYPE);
              dsdSave.Params.AddParam('inCashRegister', ftString, ptInput, Head.CASH);
              dsdSave.Params.AddParam('inCashSessionId', ftString, ptInput, FormParams.ParamByName('CashSessionId').Value);
              dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);
              try
                Add_Log('Start Execute gpComplete_Movement_Check_ver2_NoDiff');
                Add_Log('      ' + Head.UID + ' ID - ' + IntToStr(Head.ID));
                dsdSave.Execute(False, False);
                Add_Log('Start Execute gpComplete_Movement_Check_ver2_NoDiff');
                Head.COMPL := True;
              except
                on E: Exception do
                Begin
                  Add_Log('Complete NoDIFF: ' + E.Message);
                  // -nw                 SendError(E.Message);
                  FHasError := true;
                  if gc_User.Local then
                  begin
                    tiServise.BalloonHint := 'Останавливаем проведение чеков';
                    tiServise.ShowBalloonHint;
                    Exit;
                  end;
                End;
              end;
            finally
              freeAndNil(dsdSave);
            end;
            // проверяем, что чек действительно проведен
            dsdSave := TdsdStoredProc.Create(nil);
            try
              //Проверить в каком состоянии документ.
              dsdSave.StoredProcName := 'gpGet_Movement_CheckState';
              dsdSave.OutputType := otResult;
              dsdSave.Params.Clear;
              dsdSave.Params.AddParam('inId',ftInteger,ptInput,Head.ID);
              dsdSave.Params.AddParam('outState',ftInteger,ptOutput,Null);
              dsdSave.Execute(False,False);
              if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2' then //проведен
                Add_Log('Movement_CheckState - проведен')
              else
              begin
                Add_Log('ERROR Movement_CheckState - непроведен ('+ VarToStr(dsdSave.Params.ParamByName('outState').Value)+ ')');
                Head.COMPL := false;
                Head.SAVE := false;
                // снимаем признак сохранен, чтобы повторно сохранить документ
                Add_Log('UnSAVE');
                WaitForSingleObject(MutexDBF, INFINITE);
                try
                  FLocalDataBaseHead.Active := True;
                  if LocateUID(UID, True) AND not FLocalDataBaseHead.Deleted then
                  Begin
                    FLocalDataBaseHead.Edit;
                    FLocalDataBaseHead.FieldByName('SAVE').AsBoolean := False;
                    FLocalDataBaseHead.Post;
                    Add_Log('UnSAVE Completed');
                  End;
                finally
                  FLocalDataBaseHead.Active := False;
                  ReleaseMutex(MutexDBF);
                end;
              end;
            finally
              freeAndNil(dsdSave);
            end;

            // удаляем проведенный чек - если можно ... 04.02.2017
            if Head.COMPL { AND (fError_isComplete = FALSE) } // 04.07.17 - !!!временно убрал!!!
            then
            Begin
              Add_Log('Start MutexDBF 1131');
              WaitForSingleObject(MutexDBF, INFINITE);
              try
                FLocalDataBaseHead.Active := True;
                FLocalDataBaseBody.Active := True;
                if LocateUID(UID, FSAVE) AND not FLocalDataBaseHead.Deleted then
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
                Add_Log('End MutexDBF 1131');
                ReleaseMutex(MutexDBF);
              end;
            End;
          end;
          // если проводить не нужно и если можно ... 04.02.2017

  //        WaitForSingleObject(MutexDBF, INFINITE);
  //        try
  //          FLocalDataBaseHead.Active := True;
  //          FLocalDataBaseHead.First;
  //          FLocalDataBaseHead.Active := False;
  //        finally
  //          ReleaseMutex(MutexDBF);
  //        end;
        End;
      End;

      // Получаем Diff
      actCashRemainsExecute(Nil);

//      if not ExistNotCompletedCheck and FirstRemainsReceived then
//      begin
//        MainCashForm2.tiServise.IconIndex := 3;
//        tiServise.Hint := 'Получение разницы в остатках';
//        Application.ProcessMessages;
//        Add_Log('Start MutexRemains 1173');
//        WaitForSingleObject(MutexRemains, INFINITE);
//        try
//          try
//            Add_Log('Receiving DIFF: Получаем разницу');
//            MainCashForm2.spSelect_CashRemains_Diff.Execute(False, False, False);
//            Add_Log('Receiving DIFF: Получили записей: '+ IntToStr(DiffCDS.RecordCount));
//            DiffCDS.First;
//            if DiffCDS.FieldCount > 0 then
//            begin
//              Add_Log('Start MutexDBFDiff 1184');
//              WaitForSingleObject(MutexDBFDiff, INFINITE);
//              try
//                Add_Log('Receiving DIFF: Заполняем DBFDiff');
//                FLocalDataBaseDiff.Open;
//                while not DiffCDS.eof do
//                begin
//                  FLocalDataBaseDiff.Append;
//                  FLocalDataBaseDiff.Fields[0].AsVariant:=DiffCDS.Fields[0].AsVariant;
//                  FLocalDataBaseDiff.Fields[1].AsVariant:=DiffCDS.Fields[1].AsVariant;
//                  FLocalDataBaseDiff.Fields[2].AsVariant:=DiffCDS.Fields[2].AsVariant;
//                  FLocalDataBaseDiff.Fields[3].AsVariant:=DiffCDS.Fields[3].AsVariant;
//                  FLocalDataBaseDiff.Fields[4].AsVariant:=DiffCDS.Fields[4].AsVariant;
//                  FLocalDataBaseDiff.Fields[5].AsVariant:=DiffCDS.Fields[5].AsVariant;
//                  FLocalDataBaseDiff.Fields[6].AsVariant:=DiffCDS.Fields[6].AsVariant;
//                  FLocalDataBaseDiff.Fields[7].AsVariant:=DiffCDS.Fields[7].AsVariant;
//                  FLocalDataBaseDiff.Fields[8].AsVariant:=DiffCDS.Fields[8].AsVariant;
//                  FLocalDataBaseDiff.Fields[9].AsVariant:=DiffCDS.Fields[9].AsVariant;
//                  FLocalDataBaseDiff.Fields[10].AsVariant:=DiffCDS.Fields[10].AsVariant;
//                  FLocalDataBaseDiff.Fields[11].AsVariant:=DiffCDS.Fields[11].AsVariant;
//                  FLocalDataBaseDiff.Fields[12].AsVariant:=DiffCDS.Fields[12].AsVariant;
//                  FLocalDataBaseDiff.Fields[13].AsVariant:=DiffCDS.Fields[13].AsVariant;
//                  FLocalDataBaseDiff.Post;
//                  DiffCDS.Next;
//                end;
//              finally
//                Add_Log('End MutexDBFDiff 1184');
//                FLocalDataBaseDiff.Close;
//                ReleaseMutex(MutexDBFDiff);
//              end;
//              // Отправка сообщения приложению про надобность обновить остатки из файла
//              PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 1);
//            end;
//          except on E: Exception do
//            begin
//              Add_Log('Receiving DIFF: ' + E.Message);
//              Add_Log(IntToStr(GetLastError) + ' - ' + SysErrorMessage(GetLastError));
//              FHasError := true;
//              if gc_User.Local then
//              begin
//                tiServise.BalloonHint := 'Останавливаем проведение чеков';
//                tiServise.ShowBalloonHint;
//                Exit;
//              end;
//            end;
//          end;
//        finally
//          Add_Log('End MutexRemains 1173');
//          ReleaseMutex(MutexRemains);
//        end;
//        Add_Log('Start MutexRemains 1228');
//        WaitForSingleObject(MutexRemains, INFINITE);
//        try
//          SaveLocalData(MainCashForm2.RemainsCDS, Remains_lcl);
//        finally
//          Add_Log('End MutexRemains 1228');
//          ReleaseMutex(MutexRemains);
//        end;
//        Add_Log('Start MutexRemains 1236');
//        WaitForSingleObject(MutexAlternative, INFINITE);
//        try
//          SaveLocalData(MainCashForm2.AlternativeCDS, Alternative_lcl);
//        finally
//          Add_Log('End MutexRemains 1236');
//          ReleaseMutex(MutexAlternative);
//        end;
//        if FNeedSaveVIP then
//        begin
//          MainCashForm2.SaveLocalVIP;
//        end;
//      end;
    finally
      tiServise.Hint := '';
      Add_Log('End MutexAllowed 734');
      ReleaseMutex(MutexAllowedConduct);
      Add_Log('End MutexRefresh 732');
      ReleaseMutex(MutexRefresh);
    end;
  finally
    FSaveRealAllRunning := false;
    if FHasError then
      MainCashForm2.tiServise.IconIndex := 6
    else
      MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    Add_Log('SaveReal end');
    TimerSaveReal.Interval := GetInterval_CashRemains_Diff;
    TimerSaveReal.Enabled := true;
    Application.ProcessMessages;
  end;
end;

procedure TMainCashForm2.SaveListDiff;
begin
  // Отправка листа отказов
  if FileExists(ListDiff_lcl) then
  begin
    Add_Log('Start MutexDiffCDS');
    WaitForSingleObject(MutexDiffCDS, INFINITE);
    try
      try

        LoadLocalData(ListDiffCDS, ListDiff_lcl);
        if not ListDiffCDS.Active then ListDiffCDS.Open;

        ListDiffCDS.First;
        while not ListDiffCDS.Eof do
        begin
          if not ListDiffCDS.FieldByName('IsSend').AsBoolean then
          begin
            spSendListDiff.Execute;
            ListDiffCDS.Edit;
            ListDiffCDS.FieldByName('IsSend').AsBoolean := True;
            ListDiffCDS.Post;
          end;
          ListDiffCDS.Next;
        end;
        SaveLocalData(ListDiffCDS, ListDiff_lcl);

      Except ON E:Exception do
        Add_Log('Ошибка отправки листа отказов:' + E.Message);
      end;
    finally
      Add_Log('End MutexDiffCDS');
      ReleaseMutex(MutexDiffCDS);
      ListDiffCDS.Close;
    end;
  end;
end;

procedure TMainCashForm2.SaveBankPOSTerminal;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := 'Получение банковских терминалов';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_BankPOSTerminal';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexBankPOSTerminal');
        WaitForSingleObject(MutexBankPOSTerminal, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,BankPOSTerminal_lcl);
        finally
          Add_Log('End MutexBankPOSTerminal');
          ReleaseMutex(MutexBankPOSTerminal);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveBankPOSTerminal Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.SaveUnitConfig;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := 'Получение конфигурации';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_UnitConfig';
        sp.Params.Clear;
        sp.Params.AddParam('inCashRegister', ftString, ptInput, iniLocalCashRegisterGet);
        sp.Execute;
        Add_Log('Start MutexUnitConfig');
        WaitForSingleObject(MutexUnitConfig, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,UnitConfig_lcl);
        finally
          Add_Log('End MutexUnitConfig');
          ReleaseMutex(MutexUnitConfig);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveUnitConfig Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.SaveBuyer;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := 'Получение покупателей';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_Buyer';
        sp.Execute;
        Add_Log('Start MutexBuyer');
        WaitForSingleObject(MutexBuyer, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,Buyer_lcl);
        finally
          Add_Log('End MutexBuyer');
          ReleaseMutex(MutexBuyer);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveBuyer Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.SaveDistributionPromo;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := 'Получение pаздач акционных материалов';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_DistributionPromo';
        sp.Execute;
        Add_Log('Start MutexDistributionPromo');
        WaitForSingleObject(MutexDistributionPromo, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,DistributionPromo_lcl);
        finally
          Add_Log('End MutexDistributionPromo');
          ReleaseMutex(MutexDistributionPromo);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveDistributionPromo Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.SaveUserHelsi;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := 'Получение Сотрудников для сайта Хелси';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_UserHelsi';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexUserHelsi');
        WaitForSingleObject(MutexUserHelsi, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,UserHelsi_lcl);
        finally
          Add_Log('End MutexUserHelsi');
          ReleaseMutex(MutexUserHelsi);
        end;

        if FileExists(ExtractFilePath(Application.ExeName) + 'users.local') then
          DeleteFile(ExtractFilePath(Application.ExeName) + 'users.local');
        if FileExists(ExtractFilePath(Application.ExeName) + 'users.backup') then
          DeleteFile(ExtractFilePath(Application.ExeName) + 'users.backup');
      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveUserHelsi Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.SaveUserSettings;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := 'Получение Сотрудников и настроек';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_UserSettings';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexUserSettings');
        WaitForSingleObject(MutexUserSettings, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,UserSettings_lcl);
        finally
          Add_Log('End MutexUserSettings');
          ReleaseMutex(MutexUserSettings);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveUserSettings Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.SaveTaxUnitNight;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := 'Получение ночных скидок';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_TaxUnitNight';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexTaxUnitNight');
        WaitForSingleObject(MutexTaxUnitNight, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,TaxUnitNight_lcl);
        finally
          Add_Log('End MutexTaxUnitNight');
          ReleaseMutex(MutexTaxUnitNight);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveTaxUnitNight Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

//Получение остатков по партиям
procedure TMainCashForm2.SaveGoodsExpirationDate;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := 'Получение остатков по партиям';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_CashGoodsToExpirationDate';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexGoodsExpirationDate');
        WaitForSingleObject(MutexGoodsExpirationDate, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,GoodsExpirationDate_lcl);
        finally
          Add_Log('End MutexGoodsExpirationDate');
          ReleaseMutex(MutexGoodsExpirationDate);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveGoodsExpirationDate Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

//Получение справочника аналогов
//procedure TMainCashForm2.SaveGoodsAnalog;
//var
//  sp : TdsdStoredProc;
//  ds : TClientDataSet;
//begin
//  tiServise.Hint := 'Получение аналогов товаров';
//  sp := TdsdStoredProc.Create(nil);
//  try
//    try
//      ds := TClientDataSet.Create(nil);
//      try
//        sp.OutputType := otDataSet;
//        sp.DataSet := ds;
//
//        sp.StoredProcName := 'gpSelect_Object_GoodsAnalog';
//        sp.Params.Clear;
//        sp.Execute;
//        Add_Log('Start MutexGoodsAnalog');
//        WaitForSingleObject(MutexGoodsAnalog, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
//        try
//          SaveLocalData(ds,GoodsAnalog_lcl);
//        finally
//          Add_Log('End MutexGoodsAnalog');
//          ReleaseMutex(MutexGoodsAnalog);
//        end;
//
//      finally
//        ds.free;
//      end;
//    except
//      on E: Exception do
//      begin
//        Add_Log('SaveGoodsAnalog Exception: ' + E.Message);
//        Exit;
//      end;
//    end;
//  finally
//    freeAndNil(sp);
//  end;
//end;

procedure TMainCashForm2.SendZReport;
  var IdFTP : Tidftp;
      s, p: string; sl : TStringList;  i : integer;

  function ChangeDirFTP(ADir : String; ACreate : Boolean = true) : Boolean;
    var S:string;
  Begin
    Result := false;
    if ADir[length(ADir)]<>'/' then ADir:=ADir+'/';
    IdFTP.ChangeDir('/');

    while ADir <> '' do
    Begin
      S:=Copy(ADir,1,pos('/',ADir)-1);
      try
        IdFTP.ChangeDir(S);
      except
        if ACreate then
        try
          IdFTP.MakeDir(S);
          IdFTP.ChangeDir(S);
        Except
          exit;
        end else Exit;
      end;
      Delete(ADir,1,pos('/',ADir));
    End;
    Result:=True;
  End;

  function GetFtpDIR : string;
  var
    ds : TClientDataSet;
  begin
    Result := '';

    if FileExists(UnitConfig_lcl) then
    try
      ds := TClientDataSet.Create(nil);
      try
        Add_Log('Start MutexUnitConfig');
        WaitForSingleObject(MutexUnitConfig, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          LoadLocalData(ds,UnitConfig_lcl);
          Result := ds.FieldByName('FtpDir').AsString;
          if Result <> '' then Result := Result + '/';

        finally
          Add_Log('End MutexUnitConfig');
          ReleaseMutex(MutexUnitConfig);
        end;

      except
        on E: Exception do
        begin
          Add_Log('SaveUnitConfig Exception: ' + E.Message);
          Exit;
        end;
      end
    finally
      ds.free;
    end;
  end;

begin

  tiServise.Hint := 'Отправка Z отчетов';

  try
    spLoadFTPParam.Execute;
  except
    on E: Exception do
    begin
      Add_Log('spLoadFTPParam Exception: ' + E.Message);
      Exit;
    end;
  end;

  p := ExtractFilePath(Application.ExeName) + 'ZRepot\';

  if not ForceDirectories(p + 'Send\') then
  begin
    Add_Log('Error crete path: ' + p + 'Send\');
    Exit;
  end;

  sl := TStringList.Create;
  for s in TDirectory.GetFiles(p, '*.txt') do sl.Add(TPath.GetFileName(s));

  if sl.Count = 0 then
  begin
    sl.Free;
    Exit;
  end;

  MainCashForm2.tiServise.IconIndex := 7;
  Application.ProcessMessages;
    // Отправка файла
  IdFTP := Tidftp.Create(nil);
  try
    try
      IdFTP.Passive := True;
      IdFTP.TransferType := ftBinary;
      IdFTP.UseExtensionDataPort := True;

      IdFTP.Host := spLoadFTPParam.ParamByName('outHost').Value;
      IdFTP.Port := spLoadFTPParam.ParamByName('outPort').Value;
      IdFTP.Username := spLoadFTPParam.ParamByName('outUsername').Value;
      IdFTP.Password := spLoadFTPParam.ParamByName('outPassword').Value;
//      IdFTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdFTP);
//      IdFTP.UseTLS := utUseExplicitTLS;
//      IdFTP.DataPortProtection := ftpdpsPrivate;
//      TIdSSLIOHandlerSocketOpenSSL(IdFTP.IOHandler).SSLOptions.Method := sslvTLSv1;
//      TIdSSLIOHandlerSocketOpenSSL(IdFTP.IOHandler).SSLOptions.Mode := sslmClient;
//      TIdSSLIOHandlerSocketOpenSSL(IdFTP.IOHandler).SSLOptions.CipherList := 'ALL';
      IdFTP.Connect;
      if IdFTP.Connected then
      try
        if Pos('/', iniLocalUnitNameGet) > 0 then
        begin
          if not ChangeDirFTP(GetFtpDIR + Copy(iniLocalUnitNameGet, 1, Pos('/', iniLocalUnitNameGet) - 1), True) then Exit;
        end else if not ChangeDirFTP(GetFtpDIR + iniLocalUnitNameGet, True) then Exit;
        for i := 0 to sl.Count - 1 do
        begin
          IdFTP.Put(p + sl.Strings[i], sl.Strings[i], False);
          TFile.Copy(p + sl.Strings[i], p + 'Send\' + sl.Strings[i], true);
          TFile.Delete(p + sl.Strings[i]);
        end;

          // Удаление старых файлов
//        sl.Clear;
//        for s in TDirectory.GetFiles(p + 'Send\', '*.txt') do sl.Add(s);
//        for i := 0 to sl.Count - 1 do if TFile.GetCreationTime(sl.Strings[i]) <
//          IncDay(Date, - spLoadFTPParam.ParamByName('outPort').Value) then
//          TFile.Delete(sl.Strings[i]);

        tiServise.BalloonHint := 'Z отчеты отправлены';
        tiServise.ShowBalloonHint;
      finally
        IdFTP.Disconnect;
      end;
    except
      on E: Exception do Add_Log('Send from FTP file Exception: ' + E.Message);
    end;
  finally
    IdFTP.Free;
    sl.Free;
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    Application.ProcessMessages;
  end;
end;

procedure TMainCashForm2.SendEmployeeWorkLog;
  var LocalVersionInfo, BaseVersionInfo: TVersionInfo;
      OldProgram, OldServise : Boolean;
begin
  // Отправка лога работы сотрудников
  if FileExists(EmployeeWorkLog_lcl) then
  begin

    tiServise.Hint := 'Отправка лога работы сотрудников';

    OldProgram := False;
    OldServise := False;

    Add_Log('Start MutexEmployeeWorkLog');
    WaitForSingleObject(MutexEmployeeWorkLog, INFINITE);
    try
      try

        BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion('FarmacyCash.exe', GetBinaryPlatfotmSuffics(ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe'));
        LocalVersionInfo := UnilWin.GetFileVersion(ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe');
        if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
           ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then OldProgram := True;

        BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)), GetBinaryPlatfotmSuffics(ParamStr(0)));
        LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
        if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
           ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then OldServise := True;

        LoadLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);
        if not EmployeeWorkLogCDS.Active then EmployeeWorkLogCDS.Open;

        EmployeeWorkLogCDS.First;
        while not EmployeeWorkLogCDS.Eof do
        begin
          if not EmployeeWorkLogCDS.FieldByName('IsSend').AsBoolean then
          begin
            if EmployeeWorkLogCDS.RecNo = EmployeeWorkLogCDS.RecordCount then
            begin
              spEmployeeWorkLog.ParamByName('inOldProgram').Value := OldProgram;
              spEmployeeWorkLog.ParamByName('inOldServise').Value := OldServise;
            end else
            begin
              spEmployeeWorkLog.ParamByName('inOldProgram').Value := False;
              spEmployeeWorkLog.ParamByName('inOldServise').Value := False;
            end;
            spEmployeeWorkLog.Execute;
            EmployeeWorkLogCDS.Edit;
            EmployeeWorkLogCDS.FieldByName('IsSend').AsBoolean := True;
            EmployeeWorkLogCDS.Post;
          end;
          EmployeeWorkLogCDS.Next;
        end;

        EmployeeWorkLogCDS.First;
        while not EmployeeWorkLogCDS.Eof do
        begin
          if EmployeeWorkLogCDS.FieldByName('IsSend').AsBoolean and
            (StartOfTheDay(EmployeeWorkLogCDS.FieldByName('DateLogIn').AsDateTime) < IncDay(Date, - 7)) then
          begin
            EmployeeWorkLogCDS.Delete;
            Continue;
          end;
          EmployeeWorkLogCDS.Next;
        end;

        SaveLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);

      Except ON E:Exception do
        Add_Log('Ошибка отправки лога работы сотрудников:' + E.Message);
      end;
    finally
      Add_Log('End MutexEmployeeWorkLog');
      ReleaseMutex(MutexEmployeeWorkLog);
      EmployeeWorkLogCDS.Close;
    end;
  end;
end;

procedure TMainCashForm2.SendEmployeeSchedule;
begin
  // Отправка времени работы сотрудников
  if FileExists(EmployeeSchedule_lcl) then
  begin

    tiServise.Hint := 'Отправка времени работы сотрудников';

    Add_Log('Start MutexEmployeeSchedule');
    WaitForSingleObject(MutexEmployeeSchedule, INFINITE);
    try
      try

        LoadLocalData(EmployeeScheduleCDS, EmployeeSchedule_lcl);
        if not EmployeeScheduleCDS.Active then EmployeeScheduleCDS.Open;

        EmployeeScheduleCDS.First;
        while not EmployeeScheduleCDS.Eof do
        begin
          if not EmployeeScheduleCDS.FieldByName('IsSend').AsBoolean then
          begin
            spEmployeeSchedule.Execute;
            EmployeeScheduleCDS.Edit;
            EmployeeScheduleCDS.FieldByName('IsSend').AsBoolean := True;
            EmployeeScheduleCDS.Post;
          end;
          EmployeeScheduleCDS.Next;
        end;

        EmployeeScheduleCDS.First;
        while not EmployeeScheduleCDS.Eof do
        begin
          if EmployeeScheduleCDS.FieldByName('IsSend').AsBoolean and
            (StartOfTheDay(EmployeeScheduleCDS.FieldByName('Date').AsDateTime) < IncDay(Date, - 7)) then
          begin
            EmployeeScheduleCDS.Delete;
            Continue;
          end;
          EmployeeScheduleCDS.Next;
        end;

        SaveLocalData(EmployeeScheduleCDS, EmployeeSchedule_lcl);

      Except ON E:Exception do
        Add_Log('Ошибка отправки времени работы сотрудников:' + E.Message);
      end;
    finally
      Add_Log('End MutexEmployeeSchedule');
      ReleaseMutex(MutexEmployeeSchedule);
      EmployeeScheduleCDS.Close;
    end;
  end;
end;

procedure TMainCashForm2.SecureUpdateVersion;
  var LocalVersionInfo, BaseVersionInfo: TVersionInfo;
      OldProgram, OldServise : Boolean;
begin
  tiServise.Hint := 'Сохранение информации об обновлении версии';
  OldProgram := False;
  OldServise := False;
  try
    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion('FarmacyCash.exe', GetBinaryPlatfotmSuffics(ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe'));
    LocalVersionInfo := UnilWin.GetFileVersion(ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe');
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then OldProgram := True;

    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)), GetBinaryPlatfotmSuffics(ParamStr(0)));
    LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then OldServise := True;

    if OldProgram or OldServise then
    begin
      gpUpdate_Log_CashRemains.Params.ParamByName('inOldProgram').Value := OldProgram;
      gpUpdate_Log_CashRemains.Params.ParamByName('inOldServise').Value := OldServise;
      gpUpdate_Log_CashRemains.Execute;
    end;
  except
    on E: Exception do Add_Log('SecureUpdateVersion Exception: ' + E.Message);
  end;

end;


function TMainCashForm2.GetTrayIcon: integer;
begin
  if gc_User.Local then
    Result := 5
  else
    Result := 0;
end;

procedure TMainCashForm2.gpUpdate_Log_CashRemainsAfterExecute(Sender: TObject);
begin

end;

// что б отловить ошибки - запишим в лог чек - во время пробития чека через ЭККА
procedure TMainCashForm2.Add_Log(AMessage: String);
var F: TextFile;
begin
  if Pos('zc_enum_globalconst_connectparam', AMessage) > 0 then Exit;
  if Pos('gpselect_object_reportexternal', AMessage) > 0 then Exit;
  if Pos('zc_enum_globalconst_connectparam', AMessage) > 0 then Exit;
  if Pos('Mutex', AMessage) > 0 then
    AMessage := '     ' + AMessage;
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'.log')) then
    begin
      Rewrite(F);
    end
    else
      Append(F);
    //
    try  Writeln(F,DateTimeToStr(Now) + ': ' + AMessage);
    finally CloseFile(F);
    end;
  except
  end;
end;

{ TRefreshDiffThread }
{ TSaveRealAllThread }

procedure TMainCashForm2.FormDestroy(Sender: TObject);
begin
 Add_Log('== Close');
 CloseMutex;
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
