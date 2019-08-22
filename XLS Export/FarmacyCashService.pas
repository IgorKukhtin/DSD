unit FarmacyCashService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.DateUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  DataModul,  Vcl.ActnList, dsdAction,
  Data.DB,  Vcl.ExtCtrls, dsdDB, Datasnap.DBClient,  Vcl.Menus,  Vcl.StdCtrls,
  IniFIles, dxmdaset,  ActiveX,  Math,  VKDBFDataSet, FormStorage, CommonData, ParentForm,
  LocalWorkUnit , IniUtils, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  cxButtons, Vcl.Grids, Vcl.DBGrids, AncestorBase, cxPropertiesStore, cxControls,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,  cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid,  cxSplitter, cxContainer,  cxTextEdit, cxCurrencyEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox,  cxCheckBox, cxNavigator, CashInterface,  cxImageComboBox , dsdAddOn,
  Vcl.ImgList, LocalStorage, uExportToXLS, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter;

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
    //***10.08.16
    LIST_UID: String[50]    // UID ������ �������
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
    tiServise: TTrayIcon;
    N4: TMenuItem;
    ilIcons: TImageList;
    N5: TMenuItem;
    N7: TMenuItem;
    actCashRemains: TAction;
    N8: TMenuItem;
    ListDiffCDS: TClientDataSet;
    spSendListDiff: TdsdStoredProc;
    dsdPrintAction1: TdsdPrintAction;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actRefreshAllExecute(Sender: TObject); //+
    procedure TimerGetRemainsTimer(Sender: TObject);
    procedure actSetCashSessionIdExecute(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure actCashRemainsExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);

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
    procedure SaveLocalVIP;
    procedure SaveLocalGoods;
    procedure SaveLocalDiffKind;
    procedure SaveRealAll;
    procedure SaveListDiff;
    procedure SendZReport;
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
  MutexDBF, MutexDBFDiff,  MutexVip, MutexRemains, MutexAlternative, MutexRefresh,
  MutexAllowedConduct, MutexGoods, MutexDiffCDS, MutexDiffKind: THandle;
  LastErr: Integer;

  FM_SERVISE: Integer;
    function GenerateGUID: String;
implementation

{$R *.dfm}

function TMainCashForm2.GetInterval_CashRemains_Diff: integer;
begin
end;

procedure TMainCashForm2.AppMsgHandler(var Msg: TMsg; var Handled: Boolean);
var msgStr: String;
begin
  try
    Handled := (Msg.hwnd = Application.Handle) and (Msg.message = FM_SERVISE);
    if Handled and (Msg.wParam = 2) then
      case Msg.lParam of
        2: actSetCashSessionId.Execute;    // ���������� ��� �����

        3: begin
            SaveRealAll;    // ��������� �������� ����
           end;

        4: begin
             SaveListDiff;  // ��������� ��������� ����� ��������
           end;

        5: begin
             SendZReport;  // ��������� ��������� Z ������
           end;

        9: begin
  //           ShowMessage('������ �� ����������');
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

      end;
  except on E: Exception do
    Add_Log('AppMsgHandler Exception: ' + E.Message);
  end;
end;

procedure TMainCashForm2.Button1Click(Sender: TObject);
  var EX : TdsdExportToXLSAction;
begin
  spSelectPrint.Execute;
//  ShowMessage(IntToStr(PrintItemsCDS.RecordCount));

  EX := TdsdExportToXLSAction.Create(ActionList);
  try
    EX.Title := '������������ ����������� �� ���� ����� "�� �����!" ��� ';
    EX.TitleHeight := 2.5;
    EX.ItemsDataSet := PrintItemsCDS;
    EX.TitleDataSet := PrintHeaderCDS;

    EX.TitleFont.Size := 12;
    EX.TitleFont.Style := [fsBold];
    EX.HeaderFont.Style := [fsBold];

    with EX.ColumnParams.Add do
    begin
      Caption := '���';
      FieldName := 'NDSKindName';
      DataType := ftString;
      DecimalPlace := 0;
      Width := 5;

    end;

    with EX.ColumnParams.Add do
    begin
      Caption := '���';
      FieldName := 'GoodsCode';
      DataType := ftInteger;
      DecimalPlace := 0;
      Width := 7;

    end;

    with EX.ColumnParams.Add do
    begin
      Caption := '������������';
      FieldName := 'GoodsName';
      DataType := ftString;
      DecimalPlace := 0;
      Width := 46;
      WrapText := True;
      Kind := skText;
      KindText := '�����:';
    end;

    with EX.ColumnParams.Add do
    begin
      Caption := '���-��';
      FieldName := 'Amount';
      DataType := ftFloat;
      DecimalPlace := 3;
      Width := 7;
      Kind := skSumma;
    end;

    with EX.ColumnParams.Add do
    begin
      Caption := '����';
      FieldName := 'Price';
      DataType := ftFloat;
      DecimalPlace := 2;
      Width := 9;
//      Kind := skAverage;

    end;

    with EX.ColumnParams.Add do
    begin
      Caption := '�����';
      FieldName := '';
      DataType := ftFloat;
      DecimalPlace := 2;
      Width := 9;
      CalcColumn := ccMultiplication;
      Kind := skSumma;
      CalcColumnLists.Add.FieldName := 'Amount';
      CalcColumnLists.Add.FieldName := 'Price';
    end;

    EX.Execute;
  finally
    EX.Free;
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

   PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 2); // ������ �� ���������� CashSessionId �  CashSessionId.ini

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

          Add_Log('Start MutexAlternative 311');
          WaitForSingleObject(MutexAlternative, INFINITE);
          try
            SaveLocalData(AlternativeCDS,Alternative_lcl);
          finally
            Add_Log('End MutexAlternative 311');
            ReleaseMutex(MutexAlternative);
          end;
        end;
      Except
      end;

    End;
  finally
    Add_Log('End MutexRefresh 290');
    ReleaseMutex(MutexRefresh);
  end;
end;


procedure TMainCashForm2.actCashRemainsExecute(Sender: TObject);
begin
  if FSaveRealAllRunning then Exit; // ������ ���������, ���� ����������� ����
  if ExistNotCompletedCheck then Exit; // ������ ��������, ���� ���� ������������� ����
  Add_Log('Start MutexRemains 335');
  WaitForSingleObject(MutexRemains, INFINITE);
  try
    MainCashForm2.tiServise.IconIndex:=1;
    try
      MainCashForm2.spSelect_CashRemains_Diff.Execute(False, False, False);
      DiffCDS.First;
      if DiffCDS.FieldCount>0 then
      begin
         Add_Log('Start MutexDBFDiff 344');
         WaitForSingleObject(MutexDBFDiff, INFINITE);
         try
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
              FLocalDataBaseDiff.Fields[8].AsString:=DiffCDS.Fields[8].AsString;
              FLocalDataBaseDiff.Fields[9].AsString:=DiffCDS.Fields[9].AsString;
              FLocalDataBaseDiff.Post;
              DiffCDS.Next;
           end;
           FLocalDataBaseDiff.Close;
         finally
           Add_Log('End MutexDBFDiff 344');
           ReleaseMutex(MutexDBFDiff);
         end;
         // �������� ��������� ���������� ��� ���������� �������� ������� �� �����
         PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 1);
        end;
    except
      if gc_User.Local then
       begin
         tiServise.BalloonHint:='��������� �����';
         tiServise.ShowBalloonHint;
         Exit;
       end;
    end;
  finally
    Add_Log('End MutexRemains 335');
    ReleaseMutex(MutexRemains);
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
  end;

end;

procedure TMainCashForm2.actRefreshAllExecute(Sender: TObject);
var nRemainsFieldCount, nAlternativeFieldCount: integer;
    bError: boolean;
begin   //yes
  if FSaveRealAllRunning then Exit; // ������ ���������, ���� ����������� ����
  if ExistNotCompletedCheck then Exit; // ������ ���������, ���� ���� ������������� ����
  // ���������� ������ � �������
  Add_Log('Refresh all start');
  Add_Log('Start MutexRemains 390');
  WaitForSingleObject(MutexRemains, INFINITE);
  Add_Log('Start MutexAlternative 393');
  WaitForSingleObject(MutexAlternative, INFINITE);
  bError := false;
  try
    MainCashForm2.tiServise.IconIndex:=1;
    // �������� ��������� � ������ ��������� ������ ��������
    PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 4);
    tiServise.Hint := '��������� ��������';
    Application.ProcessMessages;

    if not gc_User.Local  then
    Begin
      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        try
          nRemainsFieldCount := -1;
          if RemainsCDS.Active then
            nRemainsFieldCount := RemainsCDS.Fields.Count;
          nAlternativeFieldCount := -1;
          if AlternativeCDS.Active then
            nAlternativeFieldCount := AlternativeCDS.Fields.Count;
          //��������� ��������
          actRefresh.Execute;
          //�������� ���������� �������� � ����� ������
          if (nRemainsFieldCount > RemainsCDS.Fields.Count)
             or
             (nAlternativeFieldCount > AlternativeCDS.Fields.Count) then
          begin
            tiServise.BalloonHint:='������ ��� ��������� �������� - ���� �������� �������� ������.';
            tiServise.ShowBalloonHint;
            bError := true;
            Add_Log('������ ��� ��������� ��������');
            Add_Log('Remains: ���� ��������: '+ IntToStr(nRemainsFieldCount) + ', ��������: '+ IntToStr(RemainsCDS.Fields.Count));
            Add_Log('Alternative: ���� ��������: '+ IntToStr(nAlternativeFieldCount) + ', ��������: '+ IntToStr(AlternativeCDS.Fields.Count));
            Exit;
          end;
          //���������� �������� � ��������� ����
          SaveLocalData(RemainsCDS,Remains_lcl);
          SaveLocalData(AlternativeCDS,Alternative_lcl);
          //��������� ��� ����� � ���������� � ��������� ����
          SaveLocalVIP;
          //��������� �������
          SaveLocalGoods;
          //��������� ������ �������
          SaveLocalDiffKind;
          PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 3);
          // ����� ����������� �������
          tiServise.BalloonHint:='������� ���������.';
          tiServise.ShowBalloonHint;
          FirstRemainsReceived := true;
        except
          if gc_User.Local then
          begin
            tiServise.BalloonHint:='����� ����������';
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
    Add_Log('End MutexRemains 390');
    ReleaseMutex(MutexRemains);
    Add_Log('End MutexAlternative 393');
    ReleaseMutex(MutexAlternative);
    if not bError then
      ChangeStatus('���������');
    MainCashForm2.tiServise.IconIndex := GetTrayIcon;
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
  if ParamStr(1) = '�����' then  // ���������� ���� ������ ��� ������
    tiServise.PopupMenu:=pmServise
  else tiServise.PopupMenu:=nil;

  Application.OnMessage := AppMsgHandler;
  // ������� ������� ���� �� �������
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
  FHasError := false;
  //��������� ���� ��� ����������� ������
  ChangeStatus('��������� �������������� ����������');

  FormParams.ParamByName('ClosedCheckId').Value := 0;
  FormParams.ParamByName('CheckId').Value := 0;

  if NOT GetIniFile(F) then
  Begin
    Application.Terminate;
    exit;
  End;

  ChangeStatus('������������� ���������� ���������');

  if not InitLocalStorage then
  Begin
    Application.Terminate;
    exit;
  End;
  ChangeStatus('������������� ���������� ��������� - ��');
  FSaveRealAllRunning := false;
  FormParams.ParamByName('CashSessionId').Value := iniLocalGUIDSave(GenerateGUID);
  //PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 2); // ������ ��� ����� � ����������
  if not FHasError then
    ChangeStatus('������');
end;

// ��������� ��������� ��������� ��� �������� ������ ����
procedure TMainCashForm2.N1Click(Sender: TObject);
begin
  actRefreshAllExecute(nil);
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
    tiServise.BalloonHint:='����� ������: � ����';
    tiServise.ShowBalloonHint;
  except
    Begin
      gc_User.Local := True;
      tiServise.BalloonHint:='����� ������: ���������';
      tiServise.ShowBalloonHint;
    End;
  end;
finally
 MainCashForm2.tiServise.IconIndex := GetTrayIcon;
end;
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

procedure TMainCashForm2.SaveLocalVIP;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin  //+
  // pr ���������� �� ���������� ��������
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
      Add_Log('Start MutexVip 604');
      WaitForSingleObject(MutexVip, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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
  // pr ���������� �� ���������� ��������
  // ��������� ��������� �� �������

  if FileExists(Goods_lcl) and FileGetDateTimeInfo(Goods_lcl, DateTime) and
    (StartOfTheDay(DateTime.CreationTime) >= Date) then Exit;

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
      WaitForSingleObject(MutexGoods, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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

  // ������� ����� �������
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
        Add_Log('������ �������� ����� �������:' + E.Message);
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
  // pr ���������� �� ���������� ��������

  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      sp.OutputType := otDataSet;
      sp.DataSet := ds;

      sp.StoredProcName := 'gpSelect_Object_DiffKindCash';
      sp.Params.Clear;
      sp.Execute;
      Add_Log('Start DiffKind');
      WaitForSingleObject(MutexDiffKind, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
      try
        SaveLocalData(ds,DiffKind_lcl);
      finally
        Add_Log('End DiffKind');
        ReleaseMutex(MutexDiffKind);
      end;

    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.TimerGetRemainsTimer(Sender: TObject);
begin
end;

{ TSaveRealThread }
procedure TMainCashForm2.SaveRealAll;
begin
end;

procedure TMainCashForm2.SaveListDiff;
begin
  // �������� ����� �������
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
        Add_Log('������ �������� ����� �������:' + E.Message);
      end;
    finally
      Add_Log('End MutexDiffCDS');
      ReleaseMutex(MutexDiffCDS);
    end;
  end;
end;

procedure TMainCashForm2.SendZReport;
begin

end;

function TMainCashForm2.GetTrayIcon: integer;
begin
  if gc_User.Local then
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

{ TRefreshDiffThread }
{ TSaveRealAllThread }

procedure TMainCashForm2.FormDestroy(Sender: TObject);
begin
 Add_Log('== Close');
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
