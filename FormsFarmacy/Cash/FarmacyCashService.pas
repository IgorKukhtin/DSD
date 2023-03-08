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
  UnilWin, System.ImageList, System.Actions, System.Zip, System.RegularExpressions, UnitMyIP,
  Storage, StorageSQLite, UtilTelegram;

type
 THeadRecord = record
    ID: Integer;//id ����
    PAIDTYPE:Integer; //��� ������
    MANAGER:Integer; //Id ��������� (VIP)
    NOTMCS:Boolean; //�� ��� ���
    COMPL:Boolean; //���������
    SAVE:Boolean; //��������
    NEEDCOMPL: Boolean; //���������� ����������
    DATE: TDateTime; //����/����� ����
    UID: String[50];//uid ����
    CASH: String[20]; //�������� ��������
    BAYER:String[254]; //���������� (VIP)
    FISCID:String[50]; //����� ����������� ����
    //***20.07.16
    DISCOUNTID : Integer;     //Id ������� ���������� ����
    DISCOUNTN  : String[254]; //�������� ������� ���������� ����
    DISCOUNT   : String[50];  //� ���������� �����
    //***16.08.16
    BAYERPHONE  : String[50];  //���������� ������� (����������) - BayerPhone
    CONFIRMED   : String[50];  //������ ������ (��������� VIP-����) - ConfirmedKind
    NUMORDER    : String[50];  //����� ������ (� �����) - InvNumberOrder
    CONFIRMEDC  : String[50];  //������ ������ (��������� VIP-����) - ConfirmedKindClient
    //***24.01.17
    USERSESION: string[50]; //��� ������� - �������� ����� ��� �������
    //***08.04.17
    PMEDICALID  : Integer;       //Id ����������� ����������(���. ������)
    PMEDICALN   : String[254];   //�������� ����������� ����������(���. ������)
    AMBULANCE   : String[50];    //� ����������� (���. ������)
    MEDICSP     : String[254];   //��� ����� (���. ������)
    INVNUMSP    : String[50];    //����� ������� (���. ������)
    OPERDATESP  : TDateTime;     //���� ������� (���. ������)
    //***15.06.17
    SPKINDID    : Integer;       //Id ��� ��
    //***05.02.18
    PROMOCODE   : Integer;       //Id ���������
    //***21.06.18
    MANUALDISC  : Integer;       //������ ������
    //***02.11.18
    SUMMPAYADD  : Currency;       //������ ������
    //***21.06.18
    MEMBERSPID  : Integer;       //��� ��������
    //***28.01.19
    SITEDISC    : boolean;       //������� ����� ����
    //***20.02.19
    BANKPOS     : integer;       //���� POS ���������
    //***25.02.19
    JACKCHECK   : integer;       //�����
    //***02.04.19
    ROUNDDOWN   : boolean;       //���������� � ���
    //***15.05.19
    PDKINDID    : integer;       //��� ����/�� ����
    CONFCODESP  : String[10];    //��� ������������� �������
    //***07.11.19
    LOYALTYID   : integer;       //����������� ���������
    //***15.01.20
    LOYALTYSM   : integer;       //��������� ���������� �������������
    LOYALSMSUM  : Currency;      //����� ������ �� ��������� ���������� �������������
    //***15.01.20
    MEDICFS  : String[100];      //��� ����� (�� �������)
    BUYERFS  : String[100];      //��� ���������� (�� �������)
    BUYERFSP : String[100];      //������� ���������� (�� �������)
    DISTPROMO : String[254];     //������� ��������� ����������.
    //***15.01.20
    MEDICKID   : integer;        //��� ����� (��� �������)
    MEMBERKID   : integer;       //��� �������� (��� �������)
    //***19.03.21
    ISCORRMARK  : boolean;       //������������� ����� ��������� � �� �� �������������
    ISCORRIA  : boolean;       //������������� ����� ���������� � �� �� �������������
    //***15.08.21
    ISDOCTORS  : boolean;       //�����
    //***25.08.21
    ISDISCCOM  : boolean;       //������� �������� �� �����
    //***01.09.21
    ZREPORT  : integer;         //��� ����� (��� �������)
    //***04.10.21
    MEDPRSPID  : integer;         //����������� ��������� ���. ��������
    //***26.10.21
    ISMANUAL  : boolean;       //������ ����� �����������
    //***27.10.21
    CAT1303ID  : integer;         //��������� 1303
    //***14.12.21
    ISERRORRO  : boolean;       //��� ��� �� ������ ���
    //***15.03.22
    ISPAPERRSP  : boolean;       //�������� ������ �� ��
    //***19.02.23
    USERKEYID  : integer;         //��� �������� ���� ������������� ��� �������� ����.

  end;
  TBodyRecord = record
    ID: Integer;            //�� ������
    GOODSID: Integer;       //�� ������
    GOODSCODE: Integer;     //��� ������
    NDS: Currency;          //��� ������
    AMOUNT: Currency;       //���-��
    PRICE: Currency;        //����, � 20.07.16 ���� ���� ������ �� ������� ��������, ����� ����� ���� � ������ ������
    CH_UID: String[50];     //uid ����
    GOODSNAME: String[254]; //������������ ������
    //***20.07.16
    PRICESALE: Currency;    // ���� ��� ������
    CHPERCENT: Currency;    // % ������
    SUMMCH: Currency;       // ����� ������
    //***19.08.16
    AMOUNTORD: Currency;    // ���-�� ������
    //***03.06.19
    PDKINDID: Integer;      // ��� ����/�� ����
    //***24.06.19
    PRICEPD: Currency;      // ��������� ���� �������� ������
    //***16.04.20
    NDSKINDId: Integer;     // ��� ����/�� ����
    //***20.06.20
    DISCEXTID: Integer;     // ���������� ���������
    //***20.06.20
    DIVPARTID: Integer;     // ���������� ������ � ����� ��� �������
    //***20.09.21
    ISPRESENT: Boolean;     // �������
    // ***20.09.21
    JURIDID: Integer;       // ��������� ����� ����������
    // ***10.09.22
    GOODSPR: Integer;       // ��������� �����
    ISGOODSPR: Boolean;     // ��������� �������
    //***10.08.16
    LIST_UID: String[50]    // UID ������ �������
  end;
  TBodyArr = Array of TBodyRecord;

  TMainCashForm2 = class(TForm)
    FormParams: TdsdFormParams;
    spDelete_CashSession: TdsdStoredProc;
    spUpdate_Log_CashRemains: TdsdStoredProc;
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
    actRefreshLite: TdsdDataSetRefresh;
    actShowMessage: TShowMessageAction;
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
    spPauseUpdateRemains: TdsdStoredProc;
    spPauseUpdateCheck: TdsdStoredProc;
    ZReportLogCDS: TClientDataSet;
    spSendZReportLog: TdsdStoredProc;
    spLoadPickUpLogsAndDBF: TdsdStoredProc;
    spUpdate_PickUpLogsAndDBF: TdsdStoredProc;
    UnitConfigCDS: TClientDataSet;
    TimerTrayIconPUSH: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actRefreshAllExecute(Sender: TObject); //+
    procedure TimerGetRemainsTimer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure TimerSaveRealTimer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure actCashRemainsExecute(Sender: TObject);
    procedure TimerNeedRemainsDiffTimer(Sender: TObject);
    procedure CashRemainsDiffExecute;
    procedure spCheck_RemainsErrorAfterExecute(Sender: TObject);
    procedure TimerTrayIconPUSHTimer(Sender: TObject);

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
    FisShowPlanEmployeeUser: boolean;

    FSaveLocalVIP: Integer;
    TrayIconPUSHList: TStringList;

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
    procedure SaveUserLikiDnipro;
    procedure SaveUserSettings;
    procedure SaveFormData;
    procedure SaveTaxUnitNight;
    procedure SaveGoodsExpirationDate;
    procedure SaveBuyer;
    procedure SaveDistributionPromo;
    procedure SaveImplementationPlanEmployee;
    procedure SaveZReportLog;
    procedure SaveImplementationPlanEmployeeUser;
    procedure SaveSalePromoGoods;
    procedure SaveAsinoPharmaSP;
    procedure SaveGoodsAllSP;

//    procedure SaveGoodsAnalog;

    procedure SendZReport;
    procedure SendEmployeeWorkLog;
    procedure SendEmployeeSchedule;
    procedure SendPickUpLogsAndDBF;
    procedure SecureUpdateVersion;
    procedure ChangeStatus(AStatus: String);
    function InitLocalStorage: Boolean;
    function ExistNotCompletedCheck: boolean;
    procedure Add_Log(AMessage: String);
    procedure Add_LogStatus(AMessage: String);
    procedure SendTelegramBotMessage(AMessage: String);
    function GetTrayIcon: integer;
    function GetInterval_CashRemains_Diff: integer;

    // ����� �� ��������
    procedure PauseUpdateCheck;
    procedure PauseUpdateRemains;

  end;


const
  CMD_SETLABELTEXT = 1;

var
  Count�hecksAtOnce : Integer = 7; // ����������� ���������� ����� �� ���.
  MainCashForm2: TMainCashForm2;
  FLocalDataBaseHead : TVKSmartDBF;
  FLocalDataBaseBody : TVKSmartDBF;
  FLocalDataBaseDiff : TVKSmartDBF;
  LocalDataBaseisBusy: Integer = 0;
  csCriticalSection,
  csCriticalSection_Save,
  csCriticalSection_All: TRTLCriticalSection;
  AllowedConduct : Boolean = false;
  TelegramBot: TTelegramBot;

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

        3: begin
            if SetFarmacyNameByUser then  // ��������� �������� ����
            begin
              SaveRealAll;
              SendEmployeeSchedule;  // ���������� ������� ������ �����������
            end;
            tiServise.Hint := '';
           end;

        4: begin
             if SetFarmacyNameByUser then SaveListDiff;  // ��������� ��������� ����� �������
             tiServise.Hint := '';
           end;

        5: begin
             if SetFarmacyNameByUser then SendZReport;  // ��������� ��������� Z ������
             tiServise.Hint := '';
           end;

        6: begin
             if SetFarmacyNameByUser then SaveZReportLog;  // ��������� ��������� Z ������
             tiServise.Hint := '';
           end;

        9: begin
  //           ShowMessage('������ �� ����������');
             if SetFarmacyNameByUser then
             begin
               SendEmployeeWorkLog;
               SendEmployeeSchedule;  // ���������� ������� ������ �����������
             end;
             MainCashForm2.Close;    // ������� ������
           end;
        10: begin    // ���������� ���������� �����
              if not AllowedConduct then
                AllowedConduct := True;
            end;

        20: begin  // ��������� ���������� �����
              if AllowedConduct then
               AllowedConduct := False;
             end;

        30: begin // ������� ������ �� ���������� ���� ������
               ChangeStatus('���������� �����');
               Add_Log('���������� �����');
               actRefreshAllExecute(nil);
            end;

        40: begin // ������� ������ �� ���������� ������ ��������
               actCashRemainsExecute(nil);
            end;

        50: begin
            if SetFarmacyNameByUser then
            begin
              SendEmployeeSchedule;  // ���������� ������� ������ �����������
            end;
            tiServise.Hint := '';
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

procedure TMainCashForm2.ChangeStatus(AStatus: String);
Begin
  if AStatus <> '' then
  begin
    TrayIconPUSHList.Add(AStatus);
    if not TimerTrayIconPUSH.Enabled then TimerTrayIconPUSH.Enabled := True
  end;
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
  AllowedConduct := True; // ������ �������� ���������� ���������� �����
  Add_Log('Start MutexRefresh 290');
  try
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
          end;
        Except
        end;

      End;
    finally
      Add_Log('End MutexRefresh 290');
      ReleaseMutex(MutexRefresh);
    end;
  except on E: Exception do
    Add_Log('FormCloseQuery Exception: ' + E.Message);
  end;
end;

procedure TMainCashForm2.CashRemainsDiffExecute;
begin

  try
    TimerNeedRemainsDiff.Enabled := False;
    if SetFarmacyNameByUser then
    begin
      MainCashForm2.tiServise.IconIndex:=1;
      Application.ProcessMessages;

      //��������� ������������ ������
      if not gc_User.Local then SaveUnitConfig;
      //��������� ����������� � ��������
      if not gc_User.Local then SaveUserSettings;
      //��������� ������� ��������
      if not gc_User.Local then SaveCashRemainsDif;
      //��������� �������� �� �������
      if not gc_User.Local then SaveGoodsExpirationDate;
      //��������� ���������� ����� ������ �� ����������
      if not gc_User.Local then SaveImplementationPlanEmployee;
      //��������� ���������� ����� ������ �� ���������� �����
      if not gc_User.Local then SaveImplementationPlanEmployeeUser;
      //��������� ��������� �������
      if not gc_User.Local then SaveSalePromoGoods;
      // ���������� ����
      if not gc_User.Local then SendPickUpLogsAndDBF;
      // �������� ��������� ���������� ��� ���������� �������� ������� �� �����
      PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 1);
      // ������ ����
      if gc_User.Local then
      begin
        ChangeStatus('����� ����������');
      end else
      begin
        tiServise.Hint := '������� � �������� ��������.';
      end;
      end else
    begin
      tiServise.Hint := '������ ����� � ��������.';
      TimerNeedRemainsDiff.Interval := 10000;
    end;
  finally
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    if not gc_User.Local then tiServise.Hint := '�������� �������.'
    else tiServise.Hint := '��������� �����';
    Application.ProcessMessages;
    TimerNeedRemainsDiff.Enabled := True;
  end;
end;


procedure TMainCashForm2.actCashRemainsExecute(Sender: TObject);
begin
  if FSaveRealAllRunning then Exit; // ������ ���������, ���� ����������� ����
  if ExistNotCompletedCheck then Exit; // ������ ��������, ���� ���� ������������� ����

  if TimerNeedRemainsDiff.Enabled then CashRemainsDiffExecute;
end;

procedure TMainCashForm2.actRefreshAllExecute(Sender: TObject);
var bError: boolean;
begin   //yes
  if FSaveRealAllRunning then Exit; // ������ ���������, ���� ����������� ����
  if ExistNotCompletedCheck then Exit; // ������ ���������, ���� ���� ������������� ����
  // ���������� ������ � �������
  Add_Log('Refresh all start');
  bError := True;
  try

    // ��������� � ����������
    SQLiteChechAndArc;

    if SetFarmacyNameByUser then
    begin

      MainCashForm2.tiServise.IconIndex:=1;
      // �������� ��������� � ������ ��������� ������ ��������
      PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 4);
      Application.ProcessMessages;

      //��������� ������������ ������
      if not gc_User.Local then SaveUnitConfig;
      //��������� ����������� � ��������
      if not gc_User.Local then SaveUserSettings;
      //��������� ������ ��� �������� ����
      if not gc_User.Local then SaveFormData;
      //��������� ����������� ��� ����� �����
      if not gc_User.Local then SaveUserHelsi;
      //��������� ����������� ��� ����� ������
      if not gc_User.Local then SaveUserLikiDnipro;
      //��������� ��������
      if not gc_User.Local then
      begin
        bError := SaveCashRemains;
        if bError then
        begin
         // �������� ��������� � ������ ��������� ������ ��������
         PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 5);
        end;
      end;
      //�������� ���������� ��������
      if not gc_User.Local then SecureUpdateVersion;
      //��������� ��� ����� � ���������� � ��������� ����
      if not gc_User.Local then SaveLocalVIP;
      //��������� �������
      if not gc_User.Local then SaveLocalGoods;
      //��������� ������ �������
      if not gc_User.Local then SaveLocalDiffKind;
      //��������� POS ����������
      if not gc_User.Local then SaveBankPOSTerminal;
      //��������� ������ ������
      if not gc_User.Local then SaveTaxUnitNight;
      //��������� �������� �� �������
      if not gc_User.Local then SaveGoodsExpirationDate;
      //��������� �����������
      if not gc_User.Local then SaveBuyer;
      //��������� ������� ��������� ����������
      if not gc_User.Local then SaveDistributionPromo;
      //��������� ���������� ����� ������ �� ����������
      if not gc_User.Local then SaveImplementationPlanEmployee;
      //��������� ���������� ����� ������ �� ���������� �����
      if not gc_User.Local then SaveImplementationPlanEmployeeUser;
      //��������� ��������� �������
      if not gc_User.Local then SaveSalePromoGoods;
      //��������� ������� ���������� ��������� ����� ����� �����
      if not gc_User.Local then SaveAsinoPharmaSP;
      //��������� ������� �� ��� ����������� ��������
      if not gc_User.Local then SaveGoodsAllSP;


      if not bError then PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 3);
      // ����� ����������� �������
      if gc_User.Local then
      begin
        ChangeStatus('����� ����������');
      end else
      begin
        ChangeStatus('������� ���������.');
        FirstRemainsReceived := true;
      end;
    end else
    begin
      tiServise.Hint := '������ ����� � ��������.';
      TimerGetRemains.Interval := 10000;
    end;
  finally
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    // if not bError then ChangeStatus('���������');
    if not gc_User.Local then tiServise.Hint := '�������� �������.'
    else tiServise.Hint := '��������� �����';
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
  TimerSaveReal.Enabled := false;
  TrayIconPUSHList := TStringList.Create;

  try
    spGet_User_IsAdmin.Execute;
    if spGet_User_IsAdmin.ParamByName('gpGet_User_IsAdmin').Value then  // ���������� ���� ������ ��� ������
      tiServise.PopupMenu:=pmServise
    else tiServise.PopupMenu:=nil;
  except on E: Exception do
    if (ParamStr(1) = '�����') or (gc_User.Login = '�����') then  // ���������� ���� ������ ��� ������
      tiServise.PopupMenu:=pmServise
    else tiServise.PopupMenu:=nil;
  end;

  Add_Log('Start MutexUnitConfig');
  WaitForSingleObject(MutexUnitConfig, INFINITE); // �������� ������
  try
    LoadLocalData(UnitConfigCDS, UnitConfig_lcl);
  finally
    Add_Log('End MutexUnitConfig');
    ReleaseMutex(MutexUnitConfig);
  end;

  FSaveLocalVIP := 0;

  Application.OnMessage := AppMsgHandler;
  InitMutex;
  FHasError := false;
  //��������� ���� ��� ����������� ������
  tiServise.Hint := '��������� �������������� ����������';

  FormParams.ParamByName('CashSessionId').Value := iniLocalGUIDSave(GenerateGUID);
  FormParams.ParamByName('CashRegister').Value := iniCashRegister;

  if NOT GetIniFile(F) then
  Begin
    Application.Terminate;
    exit;
  End;

  tiServise.Hint := '������������� ���������� ���������';

  if not InitLocalStorage then
  Begin
    Application.Terminate;
    exit;
  End;

  tiServise.Hint := '������������� ���������� ��������� - ��';
  FSaveRealAllRunning := false;
  TimerSaveReal.Enabled := false;
  if SetFarmacyNameByUser then
  begin
    SaveUnitConfig; // ��������� ������������
    SaveRealAll;  // �������� ���� ������� �������� �� ������������ ������. ����������� Count�hecksAtOnce = 7
                  // ���������� ������ 7 ����� � ����� ����� ��� ������ ��� ���� �� ������� ������ �������
    SaveListDiff; // ���������� ����� �������
    SendZReport;  // ���������� Z ������
    SaveZReportLog;  // ���������� ������ �� Z �������
    SendEmployeeWorkLog;  // ���������� ���� ������ �����������
    SendEmployeeSchedule;  // ���������� ������� ������ �����������
    SendPickUpLogsAndDBF;  // ���������� ����
  end;
  if not FHasError then tiServise.Hint := '��������� ��������';
  FirstRemainsReceived := false;
  //PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 2); // ������ ��� ����� � ����������
  TimerGetRemains.Enabled := true;
 //}
  if not FHasError then tiServise.Hint := '������';
end;

// ��������� ��������� ��������� ��� �������� ������ ����
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
      ChangeStatus('����� ������: � ����');
    except
      Begin
        gc_User.Local := True;
        ChangeStatus('����� ������: ���������');
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
  tiServise.Hint := '��������� ��������';

  // ���� ������
  PauseUpdateRemains;

  Add_Log('Start MutexRemains 390');
  WaitForSingleObject(MutexRemains, INFINITE);
  RemainsCDS.DisableControls;
  try
    try
      nRemainsFieldCount := -1;
      if RemainsCDS.Active then
        nRemainsFieldCount := RemainsCDS.Fields.Count;
      //��������� ��������
      actRefresh.Execute;
      //�������� ���������� �������� � ����� ������
      if (nRemainsFieldCount > RemainsCDS.Fields.Count) then
      begin
        Result := true;
        ChangeStatus('������ ��� ��������� �������� - ���� �������� �������� ������.');
        Add_Log('������ ��� ��������� ��������');
        Add_Log('Remains: ���� ��������: '+ IntToStr(nRemainsFieldCount) + ', ��������: '+ IntToStr(RemainsCDS.Fields.Count));
        Exit;
      end;
      //���������� �������� � ��������� ����
      SaveLocalData(RemainsCDS,Remains_lcl);
    Except ON E:Exception do
      begin
        Result := true;
        Add_Log('������ ��� ��������� ��������:' + E.Message);
      end;
    end;
  finally
    RemainsCDS.EnableControls;
    Add_Log('End MutexRemains 390');
    ReleaseMutex(MutexRemains);
    tiServise.Hint := ' �������� �������.';
  end;
end;


procedure TMainCashForm2.SaveCashRemainsDif;
  var I : integer;
begin
  tiServise.Hint := '��������� ������� ��������';

  // ���� ������
  PauseUpdateRemains;

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
      tiServise.Hint := '�������� �������.';
    except
      if gc_User.Local then
      begin
         ChangeStatus('��������� �����');
         tiServise.Hint := '��������� �����';
      end;
    end;
  finally
    Add_Log('End MutexRemains 335');
    ReleaseMutex(MutexRemains);
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
  end;
end;

procedure TMainCashForm2.SaveLocalVIP;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
  dsl : TClientDataSet;
begin  //+
  // pr ���������� �� ���������� ��������
  tiServise.Hint := '��������� ���������� � VIP �����';
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    dsl := TClientDataSet.Create(nil);
    try
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Object_Member';
        sp.Params.Clear;
        sp.Params.AddParam('inIsShowAll',ftBoolean,ptInput,False);
        sp.Execute(False,False);
        Add_Log('Start MutexVip 604');
        WaitForSingleObject(MutexVip, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,Member_lcl);
        finally
          Add_Log('End MutexVip 604');
          ReleaseMutex(MutexVip);
        end;

        sp.OutputType := otMultiDataSet;
        sp.DataSets.Add.DataSet := dsl;
        sp.StoredProcName := 'gpSelect_Movement_CheckCashDeferred';
        sp.Params.Clear;
        sp.Params.AddParam('inType',ftInteger,ptInput,0);

        sp.Execute(False,False);

        Add_Log('Start MutexVip 617');
        WaitForSingleObject(MutexVip, INFINITE);
        try
          SaveLocalData(ds,Vip_lcl);
        finally
          Add_Log('End MutexVip 617');
          ReleaseMutex(MutexVip);
        end;

        Add_Log('Start MutexVip 629');
        WaitForSingleObject(MutexVip, INFINITE);
        try
          SaveLocalData(dsl,VipList_lcl);
        finally
          Add_Log('End MutexVip 629');
          ReleaseMutex(MutexVip);
        end;
      Except ON E:Exception do
        Add_Log('������ ��������� ���������� �����:' + E.Message);
      end;
    finally
      dsl.free;
      ds.free;
    end;
  finally
    freeAndNil(sp);
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveLocalGoods;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin  //+
  // pr ���������� �� ���������� ��������
  // ��������� ��������� �� �������

  tiServise.Hint := '��������� ������ ������������';

  // ���� ������
  PauseUpdateRemains;

  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_CashGoods';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexGoods');
        WaitForSingleObject(MutexGoods, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,Goods_lcl);
          iniLocalListGoodsDateSave;
        finally
          Add_Log('End MutexGoods');
          ReleaseMutex(MutexGoods);
        end;

      Except ON E:Exception do
        Add_Log('������ ��������� ������ ������������:' + E.Message);
      end;
    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
  end;

  // ������� ����� �������
  Add_Log('Start MutexDiffCDS');
  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    try

      LoadLocalData(ListDiffCDS, ListDiff_lcl);
      if ListDiffCDS.Active then
      begin

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
      end;

    Except ON E:Exception do
      Add_Log('������ �������� ����� �������:' + E.Message);
    end;
  finally
    Add_Log('End MutexDiffCDS');
    ReleaseMutex(MutexDiffCDS);
  end;
  tiServise.Hint := '�������� �������.';
end;

procedure TMainCashForm2.SaveLocalDiffKind;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
  DateTime: TDateTimeInfoRec;
begin  //+
  // pr ���������� �� ���������� ��������

  tiServise.Hint := '��������� ������ �������';
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Object_DiffKindCash';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexDiffKind');
        WaitForSingleObject(MutexDiffKind, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,DiffKind_lcl);
        finally
          Add_Log('End MutexDiffKind');
          ReleaseMutex(MutexDiffKind);
        end;

        sp.StoredProcName := 'gpSelect_Cash_DiffKindPrice';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexDiffKind');
        WaitForSingleObject(MutexDiffKind, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,DiffKindPrice_lcl);
        finally
          Add_Log('End MutexDiffKind');
          ReleaseMutex(MutexDiffKind);
        end;

      Except ON E:Exception do
        Add_Log('������ ��������� ������ �������:' + E.Message);
      end;
    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.TimerSaveRealTimer(Sender: TObject);
begin
  TimerSaveReal.Enabled := False;

  try
    if SetFarmacyNameByUser then
    begin
      if not gc_User.Local then SaveRealAll;
      if not gc_User.Local then SaveListDiff;
      if not gc_User.Local then SendZReport;
      if not gc_User.Local then SaveZReportLog;
      if not gc_User.Local then SendEmployeeWorkLog;
      if not gc_User.Local then SendEmployeeSchedule;
      if not gc_User.Local then SendPickUpLogsAndDBF;
    end;
  finally
    if not gc_User.Local then tiServise.Hint := '�������� �������.'
    else tiServise.Hint := '��������� �����';
    TimerSaveReal.Enabled := True;
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    Application.ProcessMessages;
  end;
end;

procedure TMainCashForm2.TimerTrayIconPUSHTimer(Sender: TObject);
begin
  try
    if TrayIconPUSHList.Count > 0 then
    begin
      tiServise.BalloonHint := TrayIconPUSHList.Strings[0];
      TrayIconPUSHList.Delete(0);
    end else tiServise.BalloonHint := '';
    tiServise.ShowBalloonHint;
  finally
    TimerTrayIconPUSH.Enabled := tiServise.BalloonHint <> '';
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
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    Application.ProcessMessages;
  end;
end;

procedure TMainCashForm2.TimerNeedRemainsDiffTimer(Sender: TObject);
  var dsdSave : TdsdStoredProc; bRun : boolean;
begin
  TimerNeedRemainsDiff.Enabled := False;
  TimerNeedRemainsDiff.Interval := 120000;
  Inc(FSaveLocalVIP);

  try
    if SetFarmacyNameByUser then
    begin

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

      if FSaveLocalVIP > 2 then
      begin
        Add_Log('Start SaveLocalVIP');
        if not gc_User.Local then SaveLocalVIP;
        Add_Log('End SaveLocalVIP');
        FSaveLocalVIP := 0;
      end;

    end else
    begin
      tiServise.Hint := '������ ����� � ��������.';
    end;
  finally
    if gc_User.Local then TimerNeedRemainsDiff.Interval := 10000;
    TimerNeedRemainsDiff.Enabled := not TimerGetRemains.Enabled;
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    if not gc_User.Local then tiServise.Hint := '�������� �������.'
    else tiServise.Hint := '��������� �����';
    Application.ProcessMessages;
  end;
end;

function TMainCashForm2.SetFarmacyNameByUser : boolean;
var
  sp : TdsdStoredProc;
begin
  // pr C��������� ������ ����������
  tiServise.Hint := 'C��������� ������ ����������';
  Result := False;
  sp := TdsdStoredProc.Create(nil);
  try
    try
      sp.OutputType := otResult;
      sp.StoredProcName := 'gpGet_CheckFarmacyName_byUser';
      sp.Params.Clear;
      sp.Params.AddParam('outIsEnter', ftBoolean, ptOutput, Null);
      sp.Params.AddParam('outUnitId', ftInteger, ptOutput, Null);
      sp.Params.AddParam('outUnitCode', ftInteger, ptOutput, Null);
      sp.Params.AddParam('outUnitName', ftString, ptOutput, Null);
      sp.Params.AddParam('inUnitCode',ftInteger,ptInput, iniLocalUnitCodeGet);
      sp.Params.AddParam('inUnitName',ftString,ptInput, iniLocalUnitNameGet);
      if sp.Execute(False,False) = '' then
      begin
        Result := sp.Params.ParamByName('outIsEnter').Value;

        if Result then
        begin
          if iniLocalUnitCodeGet = 0 then iniLocalUnitCodeSave(sp.ParamByName('outUnitCode').Value);
          if iniLocalUnitNameGet <> sp.ParamByName('outUnitName').Value then
            iniLocalUnitNameSave(sp.ParamByName('outUnitName').Value)
        end;

        if gc_User.Local then
        begin
          gc_User.Local := False;
          Add_Log('-- ����� ������������');
          MainCashForm2.tiServise.IconIndex := GetTrayIcon;
          ChangeStatus('����� ������������');
          PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 6);
        end;
      end;

      tiServise.Hint := '�������� �������.';
    Except ON E:Exception do
      begin
        Add_Log('������ ���������� ������ ����������:' + E.Message);
        if not gc_User.Local then
        begin
          gc_User.Local := True;
          Add_Log('-- ��� ����� � ����������');
          ChangeStatus('��������� �����');
          PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 6);
        end;
        tiServise.Hint := '��������� �����';
        MainCashForm2.tiServise.IconIndex := GetTrayIcon;
        Application.ProcessMessages;
      end;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.spCheck_RemainsErrorAfterExecute(Sender: TObject);
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
  �HasError: string;

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
        Add_Log('-- ����� ������������');
        MainCashForm2.tiServise.IconIndex := GetTrayIcon;
        ChangeStatus('����� ������������');
        PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 6);
      end;
    except on E: Exception do
      begin
        Add_Log(E.Message);
        if bShowDisconnectMsg then
        begin
          gc_User.Local := True;
          Add_Log('-- ��� ����� � ����������');
          ChangeStatus('��������� �����');
          PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 6);
        end;
        Exit;
      end;
    end;

    // ��������� ������ ����� ���� ���������
    if AllowedConduct then
    begin
      Add_Log('SaveReal Allowed Conduct Exit');
      Exit;
    end;


    MainCashForm2.tiServise.IconIndex := 2;
    Application.ProcessMessages;
    Add_Log('Start MutexRefresh 732');
    WaitForSingleObject(MutexRefresh, INFINITE); // ������������ ���������� � ���������� ���� �������� ���������
    Add_Log('Start MutexAllowed 734');
    WaitForSingleObject(MutexAllowedConduct, INFINITE); // ��� ������ ���������� �� ���������� ��� ��������
    FNeedGetDiff := false;
    try
      tiServise.Hint := '���������� �����';
      FSaveUID := '';
      FSaveTryCount := 0;
      FHasError := false;
      while True do
      Begin
        Application.ProcessMessages; // ����� ��������� ������
        // ������� �� ����� ��� ��������� �������� �������� ��� �������� � ��������� �����
        if AllowedConduct or gc_User.Local then
        begin
          ChangeStatus('������������� ���������� �����');
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

        // ���� ����� ���, ������� �� �����
        if UID = '' then
          break;

        // ���� ������
        PauseUpdateCheck;

        if UID <> '' then
        Begin
          if (FSaveUID = UID) and (FSaveTryCount > 2) then
          begin
            Add_Log('��������� ������� ' + �HasError + ' ��� ' + UID);
            ChangeStatus('��������! ��������� ������� ' + �HasError + ', ���������� �������� ����� � ���� ����������!');
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
                tiServise.Hint := '���������� �����';
                MainCashForm2.tiServise.IconIndex := 2;
              end else
              begin
                tiServise.Hint := '���������� VIP ����';
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
                MEDICFS := trim(FieldByName('MEDICFS').AsString);
                BUYERFS := trim(FieldByName('BUYERFS').AsString);
                BUYERFSP := trim(FieldByName('BUYERFSP').AsString);
                DISTPROMO := trim(FieldByName('DISTPROMO').AsString);
                // ***05.03.21
                MEDICKID := FieldByName('MEDICKID').AsInteger;
                MEMBERKID := FieldByName('MEMBERKID').AsInteger;
                //***19.03.21
                ISCORRMARK := FieldByName('ISCORRMARK').AsBoolean;
                ISCORRIA := FieldByName('ISCORRIA').AsBoolean;
                //***15.08.21
                ISDOCTORS := FieldByName('ISDOCTORS').AsBoolean;
                //***15.08.21
                ISDISCCOM := FieldByName('ISDISCCOM').AsBoolean;
                //***01.09.21
                ZREPORT := FieldByName('ZREPORT').AsInteger;
                //***04.10.21
                MEDPRSPID := FieldByName('MEDPRSPID').AsInteger;
                //***26.10.21
                ISMANUAL := FieldByName('ISMANUAL').AsBoolean;
                //***27.10.21
                CAT1303ID := FieldByName('CAT1303ID').AsInteger;
                //***14.12.21
                ISERRORRO := FieldByName('ISERRORRO').AsBoolean;
                //***15.03.22
                ISPAPERRSP := FieldByName('ISPAPERRSP').AsBoolean;
                //***19.02.23
                USERKEYID := FieldByName('USERKEYID').AsInteger;

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
                    if Head.Id <> 0 then ID := FieldByName('ID').AsInteger;
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
                    // ***20.09.21
                    JURIDID := FieldByName('JURIDID').AsInteger;
                    // ***10.09.22
                    GOODSPR := FieldByName('GOODSPR').AsInteger;
                    ISGOODSPR := FieldByName('ISGOODSPR').AsBoolean;
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
          end; // ��������� ��� � head and body

          // �.�. ��� ����� ����� ������� �� ���
          fError_isComplete := False; // 04.02.2017

          if Find AND NOT Head.SAVE then
          Begin
            dsdSave := TdsdStoredProc.Create(nil);
            try
              try
                // ��������� � ����� ��������� ��������.
                dsdSave.StoredProcName := 'gpGet_Movement_CheckState';
                dsdSave.OutputType := otResult;
                dsdSave.Params.Clear;
                dsdSave.Params.AddParam('inId', ftInteger, ptInput, Head.ID);
                dsdSave.Params.AddParam('outState', ftInteger, ptOutput, Null);
                dsdSave.Execute(False, False);
                if (Head.ID > 0) and (VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2') then // ��������
                Begin
                  Add_Log('CheckState: ��� '+ IntToStr(Head.ID) +'��� ��������');
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

                  // �.�. ��� ������ ����� ������� �� ���
                  fError_isComplete := True; // 04.02.2017
                End
                else
                // ���� �� ��������
                Begin
                  if (Head.ID > 0) and (VarToStr(dsdSave.Params.ParamByName('outState').Value) = '3') then // ������
                  Begin
                    dsdSave.StoredProcName := 'gpUnComplete_Movement_Check';
                    dsdSave.OutputType := otResult;
                    dsdSave.Params.Clear;
                    dsdSave.Params.AddParam('inMovementId', ftInteger, ptInput, Head.ID);
                    dsdSave.Execute(False, False);
                  end;
                  // �������� �����
                  dsdSave.StoredProcName := 'gpInsertUpdate_Movement_Check_ver2';
                  dsdSave.OutputType := otResult;
                  dsdSave.Params.Clear;
                  if Head.ID > 0 then dsdSave.Params.AddParam('ioId', ftInteger, ptInputOutput, Head.ID)
                  else dsdSave.Params.AddParam('ioId', ftInteger, ptInputOutput, 0);
                  dsdSave.Params.AddParam('inUID', ftString, ptInput, Head.UID);
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
                  // ***15.01.20
                  dsdSave.Params.AddParam('inMedicKashtanID', ftInteger, ptInput, Head.MEDICKID);
                  dsdSave.Params.AddParam('inMemberKashtanID', ftInteger, ptInput, Head.MEMBERKID);
                  //***19.03.21
                  dsdSave.Params.AddParam('inisCorrectMarketing', ftBoolean, ptInput, Head.ISCORRMARK);
                  dsdSave.Params.AddParam('inisCorrectIlliquidMarketing', ftBoolean, ptInput, Head.ISCORRIA);
                  //***15.08.21
                  dsdSave.Params.AddParam('inisDoctors', ftBoolean, ptInput, Head.ISDOCTORS);
                  //***15.08.21
                  dsdSave.Params.AddParam('inisDiscountCommit', ftBoolean, ptInput, Head.ISDISCCOM);
                  //***01.09.21
                  dsdSave.Params.AddParam('inZReport', ftInteger, ptInput, Head.ZREPORT);
                  //***04.10.21
                  dsdSave.Params.AddParam('inMedicalProgramSP', ftInteger, ptInput, Head.MEDPRSPID);
                  //***26.10.21
                  dsdSave.Params.AddParam('inisManual', ftBoolean, ptInput, Head.ISMANUAL);
                  //***27.10.21
                  dsdSave.Params.AddParam('inCategory1303Id', ftInteger, ptInput, Head.CAT1303ID);
                  //***14.12.21
                  dsdSave.Params.AddParam('inisErrorRRO', ftBoolean, ptInput, Head.ISERRORRO);
                  //***14.12.21
                  dsdSave.Params.AddParam('inisPaperRecipeSP', ftBoolean, ptInput, Head.ISPAPERRSP);
                  //***19.02.23
                  dsdSave.Params.AddParam('inUserKeyId', ftInteger, ptInput, Head.USERKEYID);

                  // ***24.01.17
                  dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                  Add_Log('Start Execute gpInsertUpdate_Movement_Check_ver2');
                  Add_Log('      ' + String(Head.UID));
                  dsdSave.Execute(False, False);
                  Add_Log('End Execute gpInsertUpdate_Movement_Check_ver2'+
                          ' ID = '+ dsdSave.Params.ParamByName('ioID').AsString);
                  // ��������� � ��������� ���� ���������� �����
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

                  // �������� ����
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
                  // ***20.09.21
                  dsdSave.Params.AddParam('inJuridicalID', ftInteger, ptInput, Null);
                  // ***10.09.22
                  dsdSave.Params.AddParam('inGoodsPresentId', ftInteger, ptInput, Null);
                  dsdSave.Params.AddParam('inisGoodsPresent', ftBoolean, ptInput, Null);
                  // ***10.08.16
                  dsdSave.Params.AddParam('inList_UID', ftString, ptInput, Null);
                  //
                  dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                  BodySaved := true;

                  for I := 0 to Length(Body) - 1 do
                  Begin

                    // ���� ������
                    PauseUpdateCheck;

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
                    // ***20.09.21
                    dsdSave.ParamByName('inJuridicalID').Value := Body[I].JURIDID;
                    // ***20.09.21
                    dsdSave.ParamByName('inGoodsPresentId').Value := Body[I].GOODSPR;
                    dsdSave.ParamByName('inisGoodsPresent').Value := Body[I].ISGOODSPR;
                    // ***10.08.16
                    dsdSave.ParamByName('inList_UID').Value := Body[I].LIST_UID;
                    //

                    Add_Log('Start Execute gpInsertUpdate_MovementItem_Check_ver2');
                    Add_Log('      ChildId - ' + Body[I].CH_UID + ' GoodsId - ' + IntToStr(Body[I].GOODSID) + ' Amount - ' + CurrToStr(Body[I].AMOUNT) + ' PriceSale - ' + CurrToStr(Body[I].PRICESALE));
                    dsdSave.Execute(False, False); // ��������� �� �������
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
                          if (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = UID) AND
                            not FLocalDataBaseBody.Deleted AND
                            (FLocalDataBaseBody.FieldByName('GOODSID').AsInteger = Body[I].GOODSID) AND
                            (trim(FLocalDataBaseBody.FieldByName('LIST_UID').AsString) = Body[I].LIST_UID) then
                          Begin
                            FLocalDataBaseBody.Edit;
                            FLocalDataBaseBody.FieldByName('ID').AsInteger := Body[I].ID;
                            FLocalDataBaseBody.Post; // ��������� � �����
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
                  End; // ���������� ��� ������� ������ � ����
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
                End; // ���������� ��� � ��������
              except
                ON E: Exception do
                Begin
                  Add_Log('InsertUpdate Check: ' + E.Message);
                  if FSaveTryCount > 2 then SendTelegramBotMessage(E.Message);
                  FHasError := true;
                  �HasError := '���������� ����';
                  if gc_User.Local then
                  begin
                    ChangeStatus('������������� ���������� �����');
                    Exit;
                  end;
                  // -nw               SendError(E.Message);
                End;
              end;
            finally
              freeAndNil(dsdSave);
            end;
          end;

          // ���� ������
          PauseUpdateCheck;

          // ���� ���������� �������� ���
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
                Add_Log('      ' + String(Head.UID) + ' ID - ' + IntToStr(Head.ID));
                dsdSave.Execute(False, False);
                Add_Log('Start Execute gpComplete_Movement_Check_ver2_NoDiff');
                Head.COMPL := True;
              except
                on E: Exception do
                Begin
                  Add_Log('Complete NoDIFF: ' + E.Message);
                  if FSaveTryCount > 2 then SendTelegramBotMessage(E.Message);
                  // -nw                 SendError(E.Message);
                  FHasError := true;
                  �HasError := '���������� ���� (������� ���)';
                  if gc_User.Local then
                  begin
                    ChangeStatus('������������� ���������� �����');
                    Exit;
                  end;
                End;
              end;
            finally
              freeAndNil(dsdSave);
            end;
            // ���������, ��� ��� ������������� ��������
            dsdSave := TdsdStoredProc.Create(nil);
            try
              //��������� � ����� ��������� ��������.
              dsdSave.StoredProcName := 'gpGet_Movement_CheckState';
              dsdSave.OutputType := otResult;
              dsdSave.Params.Clear;
              dsdSave.Params.AddParam('inId',ftInteger,ptInput,Head.ID);
              dsdSave.Params.AddParam('outState',ftInteger,ptOutput,Null);
              dsdSave.Execute(False,False);
              if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2' then //��������
                Add_Log('Movement_CheckState - ��������')
              else
              begin
                Add_Log('ERROR Movement_CheckState - ���������� ('+ VarToStr(dsdSave.Params.ParamByName('outState').Value)+ ')');
                Head.COMPL := false;
                Head.SAVE := false;
                // ������� ������� ��������, ����� �������� ��������� ��������
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

            // ������� ����������� ��� - ���� ����� ... 04.02.2017
            if Head.COMPL { AND (fError_isComplete = FALSE) } // 04.07.17 - !!!�������� �����!!!
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
        End;
      End;

      // �������� Diff
      actCashRemainsExecute(Nil);

    finally
      tiServise.Hint := '�������� �������.';
      Add_Log('End MutexAllowed 734');
      ReleaseMutex(MutexAllowedConduct);
      Add_Log('End MutexRefresh 732');
      ReleaseMutex(MutexRefresh);
    end;
  finally
    FSaveRealAllRunning := false;
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
    Add_Log('SaveReal end');
    TimerSaveReal.Interval := GetInterval_CashRemains_Diff;
    TimerSaveReal.Enabled := true;
    Application.ProcessMessages;
  end;
end;

procedure TMainCashForm2.SaveListDiff;
begin
  // �������� ����� �������
  Add_Log('Start MutexDiffCDS');
  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    try

      LoadLocalData(ListDiffCDS, ListDiff_lcl, False);
      if not ListDiffCDS.Active then Exit;

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
      Add_Log('������ �������� ����� �������:' + E.Message);
    end;
  finally
    Add_Log('End MutexDiffCDS');
    ReleaseMutex(MutexDiffCDS);
    ListDiffCDS.Close;
  end;
end;

procedure TMainCashForm2.SaveBankPOSTerminal;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ���������� ����������';
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
        WaitForSingleObject(MutexBankPOSTerminal, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveUnitConfig;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ������������';
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
        Add_Log('Start MutexImplementationPlanEmployeeUser');
        WaitForSingleObject(MutexImplementationPlanEmployeeUser, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,UnitConfig_lcl);
          FisShowPlanEmployeeUser := ds.FieldByName('isShowPlanEmployeeUser').AsBoolean;
          LoadLocalData(UnitConfigCDS,UnitConfig_lcl);
        finally
          Add_Log('End MutexImplementationPlanEmployeeUser');
          ReleaseMutex(MutexImplementationPlanEmployeeUser);
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
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveBuyer;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� �����������';
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
        WaitForSingleObject(MutexBuyer, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveDistributionPromo;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� p����� ��������� ����������';
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
        WaitForSingleObject(MutexDistributionPromo, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveImplementationPlanEmployee;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ���������� ����� ������ �� ����������';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_GetImplementationPlanEmployeeCash';
        sp.Execute;
        Add_Log('Start MutexImplementationPlanEmployee');
        WaitForSingleObject(MutexImplementationPlanEmployee, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try


          SaveLocalData(ds,ImplementationPlanEmployee_lcl);

        finally
          Add_Log('End MutexImplementationPlanEmployee');
          ReleaseMutex(MutexImplementationPlanEmployee);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveImplementationPlanEmployee Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveZReportLog;
begin
  // �������� ������ �� Z �������
  Add_Log('Start MutexZReportLog');
  WaitForSingleObject(MutexZReportLog, INFINITE);
  try
    try

      LoadLocalData(ZReportLogCDS, ZReportLog_lcl, False);
      if not ZReportLogCDS.Active then Exit;

      ZReportLogCDS.First;
      while not ZReportLogCDS.Eof do
      begin
        if not ZReportLogCDS.FieldByName('IsSend').AsBoolean then
        begin
          spSendZReportLog.Execute;
          ZReportLogCDS.Edit;
          ZReportLogCDS.FieldByName('IsSend').AsBoolean := True;
          ZReportLogCDS.Post;
        end;
        ZReportLogCDS.Next;
      end;
      SaveLocalData(ZReportLogCDS, ZReportLog_lcl);

      ZReportLogCDS.First;
      while not ZReportLogCDS.Eof do
      begin
        if ZReportLogCDS.FieldByName('IsSend').AsBoolean then
        begin
          ZReportLogCDS.Delete;
          Continue;
        end;
        ZReportLogCDS.Next;
      end;
      SaveLocalData(ZReportLogCDS, ZReportLog_lcl);

    Except ON E:Exception do
      Add_Log('������ �������� ������ �� Z �������:' + E.Message);
    end;
  finally
    Add_Log('End ZReportLogCDS');
    ReleaseMutex(MutexZReportLog);
    ZReportLogCDS.Close;
  end;
end;

procedure TMainCashForm2.SaveUserLikiDnipro;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ����������� ��� ����� �����';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_UserLikiDnipro';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexUserLikiDnipro');
        WaitForSingleObject(MutexUserLikiDnipro, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,UserLikiDnipro_lcl);
        finally
          Add_Log('End MutexUserLikiDnipro');
          ReleaseMutex(MutexUserLikiDnipro);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveUserLikiDnipro Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveUserHelsi;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ����������� ��� ����� �����';
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
        WaitForSingleObject(MutexUserHelsi, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,UserHelsi_lcl);
        finally
          Add_Log('End MutexUserHelsi');
          ReleaseMutex(MutexUserHelsi);
        end;
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
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveUserSettings;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ����������� � ��������';
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
        WaitForSingleObject(MutexUserSettings, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveFormData;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ������ ��� �������� ����';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_Object_Form';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexUserSettings');
        WaitForSingleObject(MutexUserSettings, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,FormData_lcl);
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
        Add_Log('SaveFormData Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveTaxUnitNight;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ������ ������';
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
        WaitForSingleObject(MutexTaxUnitNight, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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
    tiServise.Hint := '�������� �������.';
  end;
end;

//��������� �������� �� �������
procedure TMainCashForm2.SaveGoodsExpirationDate;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� �������� �� �������';

  // ���� ������
  PauseUpdateRemains;

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
        WaitForSingleObject(MutexGoodsExpirationDate, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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
    tiServise.Hint := '�������� �������.';
  end;
end;

//��������� ����������� ��������
//procedure TMainCashForm2.SaveGoodsAnalog;
//var
//  sp : TdsdStoredProc;
//  ds : TClientDataSet;
//begin
//  tiServise.Hint := '��������� �������� �������';
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
//        WaitForSingleObject(MutexGoodsAnalog, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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

procedure TMainCashForm2.SaveImplementationPlanEmployeeUser;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  if not FisShowPlanEmployeeUser then Exit;

  tiServise.Hint := '��������� ���������� ����� ������';
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpReport_ImplementationPlanEmployeeUser';
        sp.Params.Clear;
        sp.Params.AddParam('inStartDate',ftDateTime,ptInput,Date);
        sp.Execute;
        Add_Log('Start MutexImplementationPlanEmployeeUser');
        WaitForSingleObject(MutexImplementationPlanEmployeeUser, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,ImplementationPlanEmployeeUser_lcl);
        finally
          Add_Log('End MutexImplementationPlanEmployeeUser');
          ReleaseMutex(MutexImplementationPlanEmployeeUser);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveImplementationPlanEmployeeUser Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
    tiServise.Hint := '�������� �������.';
  end;
end;

// ��������� ��������� �������
procedure TMainCashForm2.SaveSalePromoGoods;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ��������� �������';

  // ���� ������
  PauseUpdateRemains;

  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_SalePromoGoods_Cash';
        sp.Params.Clear;
        sp.Execute;
        Add_Log('Start MutexSalePromoGoods');
        WaitForSingleObject(MutexSalePromoGoods, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          SaveLocalData(ds,SalePromoGoods_lcl);
        finally
          Add_Log('End MutexSalePromoGoods');
          ReleaseMutex(MutexSalePromoGoods);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveSalePromoGoods Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveAsinoPharmaSP;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ������� ���������� ��������� ����� ����� �����';

  // ���� ������
  PauseUpdateRemains;

  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_AsinoPharmaSP_Cash';
        sp.Params.Clear;
        sp.Execute;
        SaveLocalData(ds, 'AsinoPharmaSP', False);

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveAsinoPharmaSP Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SaveGoodsAllSP;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  tiServise.Hint := '��������� ������� �� ��� ����������� ��������';

  // ���� ������
  PauseUpdateRemains;

  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_GoodsAllSP_Cash';
        sp.Params.Clear;
        sp.Execute;
        SaveLocalData(ds, 'GoodsAllSP', False);

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveSalePromoGoods Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
    tiServise.Hint := '�������� �������.';
  end;
end;


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

    try
      ds := TClientDataSet.Create(nil);
      try
        Add_Log('Start MutexUnitConfig');
        WaitForSingleObject(MutexUnitConfig, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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

  tiServise.Hint := '�������� Z �������';
  try

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
      // �������� �����
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
          if not ChangeDirFTP(GetFtpDIR + StringReplace(iniLocalUnitNameGet, '/', '-', [rfReplaceAll, rfIgnoreCase]), True) then Exit;
          for i := 0 to sl.Count - 1 do
          begin
            IdFTP.Put(p + sl.Strings[i], sl.Strings[i], False);
            TFile.Copy(p + sl.Strings[i], p + 'Send\' + sl.Strings[i], true);
            TFile.Delete(p + sl.Strings[i]);
            Add_Log('Send ZReport file: ' + p + sl.Strings[i]);
          end;

            // �������� ������ ������
  //        sl.Clear;
  //        for s in TDirectory.GetFiles(p + 'Send\', '*.txt') do sl.Add(s);
  //        for i := 0 to sl.Count - 1 do if TFile.GetCreationTime(sl.Strings[i]) <
  //          IncDay(Date, - spLoadFTPParam.ParamByName('outPort').Value) then
  //          TFile.Delete(sl.Strings[i]);

          ChangeStatus('Z ������ ����������');
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
  finally
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SendEmployeeWorkLog;
  var LocalVersionInfo, BaseVersionInfo: TVersionInfo;
      OldProgram, OldServise : Boolean;
begin
  // �������� ���� ������ �����������
  tiServise.Hint := '�������� ���� ������ �����������';

  OldProgram := False;
  OldServise := False;

  Add_Log('Start MutexEmployeeWorkLog');
  WaitForSingleObject(MutexEmployeeWorkLog, INFINITE);
  try
    try

      BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion('FarmacyCash.exe', GetBinaryPlatfotmSuffics(ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe', ''));
      LocalVersionInfo := UnilWin.GetFileVersion(ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe');
      if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
         ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then OldProgram := True;

      BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)), GetBinaryPlatfotmSuffics(ParamStr(0), ''));
      LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
      if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
         ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then OldServise := True;

      LoadLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl, False);
      if not EmployeeWorkLogCDS.Active then Exit;

      EmployeeWorkLogCDS.First;
      while not EmployeeWorkLogCDS.Eof do
      begin
        if not EmployeeWorkLogCDS.FieldByName('IsSend').AsBoolean then
        begin
          spEmployeeWorkLog.ParamByName('inIP').Value := GetMyIP_Day;
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
      Add_Log('������ �������� ���� ������ �����������:' + E.Message);
    end;
  finally
    Add_Log('End MutexEmployeeWorkLog');
    ReleaseMutex(MutexEmployeeWorkLog);
    EmployeeWorkLogCDS.Close;
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SendEmployeeSchedule;
begin
  // �������� ������� ������ �����������

  tiServise.Hint := '�������� ������� ������ �����������';

  Add_Log('Start MutexEmployeeSchedule');
  WaitForSingleObject(MutexEmployeeSchedule, INFINITE);
  try
    try

      LoadLocalData(EmployeeScheduleCDS, EmployeeSchedule_lcl, False);
      if not EmployeeScheduleCDS.Active then Exit;

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
      Add_Log('������ �������� ������� ������ �����������:' + E.Message);
    end;
  finally
    Add_Log('End MutexEmployeeSchedule');
    ReleaseMutex(MutexEmployeeSchedule);
    EmployeeScheduleCDS.Close;
    tiServise.Hint := '�������� �������.';
  end;
end;

procedure TMainCashForm2.SecureUpdateVersion;
  var LocalVersionInfo, BaseVersionInfo: TVersionInfo;
      OldProgram, OldServise : Boolean;
begin
  tiServise.Hint := '���������� ���������� �� ���������� ������';
  OldProgram := False;
  OldServise := False;
  try
    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion('FarmacyCash.exe', GetBinaryPlatfotmSuffics(ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe', ''));
    LocalVersionInfo := UnilWin.GetFileVersion(ExtractFileDir(ParamStr(0)) + '\FarmacyCash.exe');
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then OldProgram := True;

    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)), GetBinaryPlatfotmSuffics(ParamStr(0), ''));
    LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then OldServise := True;

    if OldProgram or OldServise then
    begin
      spUpdate_Log_CashRemains.Params.ParamByName('inOldProgram').Value := OldProgram;
      spUpdate_Log_CashRemains.Params.ParamByName('inOldServise').Value := OldServise;
      spUpdate_Log_CashRemains.Execute;
    end;
  except
    on E: Exception do Add_Log('SecureUpdateVersion Exception: ' + E.Message);
  end;
  tiServise.Hint := '�������� �������.';
end;


function TMainCashForm2.GetTrayIcon: integer;
begin
  if FHasError then
    Result := 6
  else if gc_User.Local then
    Result := 5
  else
    Result := 0;
end;

// ��� � �������� ������ - ������� � ��� ��� - �� ����� �������� ���� ����� ����
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

// ��� � �������� ������ - ������� � ��� ��� - �� ����� �������� ���� ����� ����
procedure TMainCashForm2.Add_LogStatus(AMessage: String);
var F: TextFile;
begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'_Status.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'_Status.log')) then
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
 TrayIconPUSHList.Free;
 Add_Log('== Close');
 CloseMutex;
end;

procedure TMainCashForm2.PauseUpdateCheck;
begin
//  while True do
//  begin
//    spPauseUpdateCheck.Execute;
//    if not spPauseUpdateCheck.ParamByName('outisPause').Value then Exit;
//    sleep(10000);
//  end;
end;

procedure TMainCashForm2.PauseUpdateRemains;
begin
//  while True do
//  begin
//    spPauseUpdateRemains.Execute;
//    if not spPauseUpdateRemains.ParamByName('outisPause').Value then Exit;
//    sleep(10000);
//  end;
end;

procedure TMainCashForm2.SendPickUpLogsAndDBF;
  var IdFTP : Tidftp; ZipFile: TZipFile; sl : TStringList;
      s, p, f: string; i : integer;  Res : TArray<string>;
begin

  try

    try
      spLoadPickUpLogsAndDBF.ParamByName('inCashSessionId').Value := iniLocalGUIDSave(GenerateGUID);
      spLoadPickUpLogsAndDBF.ParamByName('outSend').Value := False;
      spLoadPickUpLogsAndDBF.ParamByName('outisGetArchive').Value := False;
      spLoadPickUpLogsAndDBF.Execute;
      if not spLoadPickUpLogsAndDBF.ParamByName('outSend').Value then Exit;

    except
      on E: Exception do
      begin
        Add_Log('spLoadPickUpLogsAndDBF Exception: ' + E.Message);
        Exit;
      end;
    end;

    p := ExtractFilePath(Application.ExeName) + '\';
    s := iniLocalGUIDSave(GenerateGUID) + '_Log.zip';

      // ������������� ������
    try
      Res := TRegEx.Split(spLoadPickUpLogsAndDBF.ParamByName('outFileList').Value, ';');
      ZipFile := TZipFile.Create;

      try
        ZipFile.Open(p + s, zmWrite);

        Add_Log('Start MutexDBF LOG');
        WaitForSingleObject(MutexDBF, INFINITE);
        WaitForSingleObject(MutexDBFDiff, INFINITE);
        WaitForSingleObject(MutexLog, INFINITE);
        try
          for I := 0 to High(Res) do if FileExists(p + Res[I]) then ZipFile.Add(p + Res[I]);
        finally
          Add_Log('End MutexDBF LOG');
          ReleaseMutex(MutexLog);
          ReleaseMutex(MutexDBFDiff);
          ReleaseMutex(MutexDBF);
        end;

        if spLoadPickUpLogsAndDBF.ParamByName('outisGetArchive').Value and DirectoryExists(p + 'LogArchive\') then
        begin
          sl := TStringList.Create;
          try
            for f in TDirectory.GetFiles(p + 'LogArchive\', '*.*') do sl.Add(TPath.GetFileName(f));

            for i := 0 to sl.Count - 1 do ZipFile.Add(p + 'LogArchive\' + sl.Strings[i], 'LogArchive\' + sl.Strings[i]);

          finally
            sl.Free;
          end;
        end;

        ZipFile.Close;
      finally
        ZipFile.Free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('PickUpLogsAndDBF Exception: ' + E.Message);
        exit;
      end;
    end;

      // �������� �����
    IdFTP := Tidftp.Create(nil);
    try
      try
        IdFTP.Passive := True;
        IdFTP.TransferType := ftBinary;
        IdFTP.UseExtensionDataPort := True;

        IdFTP.Host := spLoadPickUpLogsAndDBF.ParamByName('outHost').Value;
        IdFTP.Port := spLoadPickUpLogsAndDBF.ParamByName('outPort').Value;
        IdFTP.Username := spLoadPickUpLogsAndDBF.ParamByName('outUsername').Value;
        IdFTP.Password := spLoadPickUpLogsAndDBF.ParamByName('outPassword').Value;
        IdFTP.Connect;
        if IdFTP.Connected then
        try
          IdFTP.Put(p + s, s, False);
          TFile.Delete(p + s);
        finally
          IdFTP.Disconnect;
        end;

      except
        on E: Exception do Add_Log('Send from FTP file Exception: ' + E.Message);
      end;

      try
        spUpdate_PickUpLogsAndDBF.ParamByName('inCashSessionId').Value := iniLocalGUIDSave(GenerateGUID);
        spUpdate_PickUpLogsAndDBF.Execute;

      except
        on E: Exception do
        begin
          Add_Log('spUpdate_PickUpLogsAndDBF Exception: ' + E.Message);
          Exit;
        end;
      end;

    finally
      IdFTP.Free;
    end;
  finally
  end;
end;

procedure TMainCashForm2.SendTelegramBotMessage(AMessage: String);
  var I : Integer; Res : TArray<string>;
begin
  if gc_User.Local then Exit;
  if gc_User.Session = '3' then Exit;
  if not UnitConfigCDS.Active then Exit;
  try
    if not UnitConfigCDS.FieldByName('isSendErrorTelegramBot').AsBoolean or
      (Trim(UnitConfigCDS.FieldByName('TelegramBotToken').AsString) = '')or
      (Trim(UnitConfigCDS.FieldByName('SendCashErrorTelId').AsString) = '') then Exit;

    if not Assigned(TelegramBot) then TelegramBot := TTelegramBot.Create(Trim(UnitConfigCDS.FieldByName('TelegramBotToken').AsString));

    if Pos('CONTEXT', AMessage) > 0 then AMessage := Copy(AMessage, 1, Pos('CONTEXT', AMessage) - 1);

    Res := TRegEx.Split(Trim(UnitConfigCDS.FieldByName('SendCashErrorTelId').AsString), ',');
    for I := 0 to High(Res) do TelegramBot.SendMessage(Res[I], '������ ���������� �����'#13#10 +
      iniLocalUnitNameGet + #13#10 + '����� ' + iniCashRegister + #13#10 + AMessage);

  except
    on E: Exception do Add_Log('������ �������� � �������� ���: ' + E.Message);
  end;
end;

initialization
  RegisterClass(TMainCashForm2);
  FLocalDataBaseHead := TVKSmartDBF.Create(nil);
  FLocalDataBaseBody := TVKSmartDBF.Create(nil);
  FLocalDataBaseDiff := TVKSmartDBF.Create(nil);
  FM_SERVISE := RegisterWindowMessage('FarmacyCashMessage');
  TelegramBot:= Nil;
finalization
  if Assigned(TelegramBot) then TelegramBot.Free;
  FLocalDataBaseHead.Free;
  FLocalDataBaseBody.Free;
  FLocalDataBaseDiff.Free;
end.
