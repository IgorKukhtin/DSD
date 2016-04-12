unit MainCash;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorBase, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Vcl.ExtCtrls, cxSplitter, dsdDB, Datasnap.DBClient, cxContainer,
  cxTextEdit, cxCurrencyEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, Vcl.Menus, cxCheckBox, Vcl.StdCtrls,
  cxButtons, cxNavigator, CashInterface, IniFIles, cxImageComboBox, dxmdaset,
  ActiveX, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, Math,
  VKDBFDataSet;

CONST
  UM_THREAD_EXCEPTION = WM_USER+101;
type
  THeadRecord = record
    ID: Integer;//id ����
    PAIDTYPE:Integer; //��� ������
    MANAGER:Integer; //�������� (VIP)
    NOTMCS:Boolean; //�� ��� ���
    COMPL:Boolean; //���������
    SAVE:Boolean; //��������
    NEEDCOMPL: Boolean; //���������� ����������
    DATE: TDateTime; //����/����� ����
    UID: String[50];//uid ����
    CASH: String[20]; //�������� ��������
    BAYER:String[254]; //���������� (VIP)
    FISCID:String[50]; //����� ����������� ����
  end;
  TBodyRecord = record
    ID: Integer; //�� ������
    GOODSID: Integer; //�� ������
    GOODSCODE: Integer; //��� ������
    NDS: Currency; //��� ������
    AMOUNT: Currency; //���-��
    PRICE: Currency; //����
    CH_UID: String[50]; //uid ����
    GOODSNAME: String[254]; //������������ ������
  end;
  TBodyArr = Array of TBodyRecord;

  TSaveRealThread = class(TThread)
    DiffCDS : TClientDataSet;
    FCheckUID: String;
    FShapeColor: TColor;
    procedure SetShapeState(AColor: TColor);
    procedure SyncShapeState;
    procedure UpdateRemains;
  protected
    procedure Execute; override;
  end;
  TSaveRealAllThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TRefreshDiffThread = class(TThread)
    FShapeColor: TColor;
    procedure SetShapeState(AColor: TColor);
    procedure SyncShapeState;
    procedure UpdateRemains;
  protected
    procedure Execute; override;
  end;

  TMainCashForm = class(TAncestorBaseForm)
    MainGridDBTableView: TcxGridDBTableView;
    MainGridLevel: TcxGridLevel;
    MainGrid: TcxGrid;
    BottomPanel: TPanel;
    CheckGridDBTableView: TcxGridDBTableView;
    CheckGridLevel: TcxGridLevel;
    CheckGrid: TcxGrid;
    AlternativeGridDBTableView: TcxGridDBTableView;
    AlternativeGridLevel: TcxGridLevel;
    AlternativeGrid: TcxGrid;
    cxSplitter1: TcxSplitter;
    SearchPanel: TPanel;
    cxSplitter2: TcxSplitter;
    MainPanel: TPanel;
    CheckGridColCode: TcxGridDBColumn;
    CheckGridColName: TcxGridDBColumn;
    CheckGridColPrice: TcxGridDBColumn;
    CheckGridColAmount: TcxGridDBColumn;
    CheckGridColSumm: TcxGridDBColumn;
    AlternativeGridColGoodsCode: TcxGridDBColumn;
    AlternativeGridColGoodsName: TcxGridDBColumn;
    MainColCode: TcxGridDBColumn;
    MainColName: TcxGridDBColumn;
    MainColRemains: TcxGridDBColumn;
    MainColPrice: TcxGridDBColumn;
    MainColReserved: TcxGridDBColumn;
    dsdDBViewAddOnMain: TdsdDBViewAddOn;
    spSelectRemains: TdsdStoredProc;
    RemainsDS: TDataSource;
    RemainsCDS: TClientDataSet;
    ceAmount: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    lcName: TcxLookupComboBox;
    actChoiceGoodsInRemainsGrid: TAction;
    actSold: TAction;
    PopupMenu: TPopupMenu;
    actSold1: TMenuItem;
    N1: TMenuItem;
    FormParams: TdsdFormParams;
    cbSpec: TcxCheckBox;
    actCheck: TdsdOpenForm;
    btnCheck: TcxButton;
    actInsertUpdateCheckItems: TAction;
    spSelectCheck: TdsdStoredProc;
    CheckDS: TDataSource;
    CheckCDS: TClientDataSet;
    MainColMCSValue: TcxGridDBColumn;
    cxLabel2: TcxLabel;
    lblTotalSumm: TcxLabel;
    dsdDBViewAddOnCheck: TdsdDBViewAddOn;
    actPutCheckToCash: TAction;
    AlternativeGridColLinkType: TcxGridDBColumn;
    AlternativeCDS: TClientDataSet;
    AlternativeDS: TDataSource;
    spSelect_Alternative: TdsdStoredProc;
    dsdDBViewAddOnAlternative: TdsdDBViewAddOn;
    actSetVIP: TAction;
    VIP1: TMenuItem;
    AlternativeGridColTypeColor: TcxGridDBColumn;
    AlternativeGridDColPrice: TcxGridDBColumn;
    AlternativeGridColRemains: TcxGridDBColumn;
    actDeferrent: TAction;
    N2: TMenuItem;
    btnVIP: TcxButton;
    actOpenCheckVIP: TOpenChoiceForm;
    actLoadVIP: TMultiAction;
    actUpdateRemains: TAction;
    actCalcTotalSumm: TAction;
    actCashWork: TAction;
    N3: TMenuItem;
    actClearAll: TAction;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    lblMoneyInCash: TcxLabel;
    actClearMoney: TAction;
    N7: TMenuItem;
    actGetMoneyInCash: TAction;
    N8: TMenuItem;
    spGetMoneyInCash: TdsdStoredProc;
    spGet_Password_MoneyInCash: TdsdStoredProc;
    actSpec: TAction;
    N9: TMenuItem;
    actRefreshLite: TdsdDataSetRefresh;
    actOpenMCSForm: TdsdOpenForm;
    btnOpenMCSForm: TcxButton;
    spGet_User_IsAdmin: TdsdStoredProc;
    actSetFocus: TAction;
    N10: TMenuItem;
    actRefreshRemains: TAction;
    spDelete_CashSession: TdsdStoredProc;
    DiffCDS: TClientDataSet;
    spSelect_CashRemains_Diff: TdsdStoredProc;
    actExecuteLoadVIP: TAction;
    actRefreshAll: TAction;
    ShapeState: TShape;
    actSelectCheck: TdsdExecStoredProc;
    TimerSaveAll: TTimer;
    pnlVIP: TPanel;
    Label1: TLabel;
    lblCashMember: TLabel;
    Label2: TLabel;
    lblBayer: TLabel;
    chbNotMCS: TcxCheckBox;
    mainColor_calc: TcxGridDBColumn;
    MaincolisFirst: TcxGridDBColumn;
    MaincolisSecond: TcxGridDBColumn;
    procedure WM_KEYDOWN(var Msg: TWMKEYDOWN);
    procedure FormCreate(Sender: TObject);
    procedure actChoiceGoodsInRemainsGridExecute(Sender: TObject);
    procedure lcNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actSoldExecute(Sender: TObject);
    procedure actInsertUpdateCheckItemsExecute(Sender: TObject);
    procedure ceAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ceAmountExit(Sender: TObject);
    procedure actPutCheckToCashExecute(Sender: TObject);           {********************}
    procedure ParentFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actSetVIPExecute(Sender: TObject);
    procedure RemainsCDSAfterScroll(DataSet: TDataSet);
    procedure actCalcTotalSummExecute(Sender: TObject);
    procedure MainColReservedGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure actCashWorkExecute(Sender: TObject);
    procedure actClearAllExecute(Sender: TObject);
    procedure actClearMoneyExecute(Sender: TObject);
    procedure actGetMoneyInCashExecute(Sender: TObject);
    procedure actSpecExecute(Sender: TObject);
    procedure ParentFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lcNameExit(Sender: TObject);
    procedure actUpdateRemainsExecute(Sender: TObject);
    procedure actSetFocusExecute(Sender: TObject);
    procedure actRefreshRemainsExecute(Sender: TObject);
    procedure actExecuteLoadVIPExecute(Sender: TObject);
    procedure actRefreshAllExecute(Sender: TObject);
    procedure MainGridDBTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure TimerSaveAllTimer(Sender: TObject);
    procedure lcNameEnter(Sender: TObject);
  private
    FSoldRegim: boolean;
    fShift: Boolean;
    FTotalSumm: Currency;
    Cash: ICash;
    SoldParallel: Boolean;
    SourceClientDataSet: TClientDataSet;
    ThreadErrorMessage:String;
    ASalerCash{,ASdacha}: Currency;
    PaidType: TPaidType;
    FiscalNumber: String;

    procedure SetSoldRegim(const Value: boolean);
    // ��������� ��������� ��������� ��� �������� ������ ����
    procedure NewCheck(ANeedRemainsRefresh: Boolean = True);
    // ��������� ���� ����
    procedure InsertUpdateBillCheckItems;
    //�������� ������� �������� ��������� �������
    procedure UpdateRemainsFromDiff(ADiffCDS : TClientDataSet);
    //���������� ����� � ������� ����
    procedure UpdateRemainsFromCheck(AGoodsId: Integer = 0; AAmount: Currency = 0);

    // ��������� ����� �� ����
    procedure CalcTotalSumm;
    // ��������� ��� ����� ����
    function PutCheckToCash(SalerCash: Currency; PaidType: TPaidType;
      out AFiscalNumber, ACheckNumber: String): boolean;
    //����������� � ��������� ���� ������
    function InitLocalStorage: Boolean;
    //���������� ���� � ��������� ����. ���������� ���
    function SaveLocal(ADS :TClientDataSet; AManagerId: integer;
      ABayerName: String; NeedComplete: Boolean; FiscalCheckNumber: String; out AUID: String): Boolean;
    //��������� ��� � �������� ����
    procedure SaveReal(AUID: String; ANeedComplete: boolean = False);

    //������������ �������
    procedure StartRefreshDiffThread;

    //������� � ��������� ���� � �������� �������
    procedure SaveRealAll;
    property SoldRegim: boolean read FSoldRegim write SetSoldRegim;
    procedure Thread_Exception(var Msg: TMessage); message UM_THREAD_EXCEPTION;
  public
    { Public declarations }
  end;

var
  MainCashForm: TMainCashForm;
  CountRRT: Integer = 0;
  CountSaveThread: Integer = 0;
  ActualRemainSession: Integer = 0;
  FLocalDataBaseHead : TVKSmartDBF;
  FLocalDataBaseBody : TVKSmartDBF;
  LocalDataBaseisBusy: Integer = 0;
  csCriticalSection,
  csCriticalSection_Save,
  csCriticalSection_All: TRTLCriticalSection;
implementation

{$R *.dfm}

uses CashFactory, IniUtils, CashCloseDialog, VIPDialog, CashWork, MessagesUnit;

function GetSumm(Amount,Price:currency): currency;
var
  A, P, RI: Cardinal;
  S1,S2:String;
begin
  if (Amount = 0) or (Price = 0) then
  Begin
    result := 0;
    exit;
  End;
  A := trunc(Amount * 1000);
  P := trunc(Price * 100);
  RI := A*P;
  S1 := IntToStr(RI);
  if Length(S1) < 4 then
    RI := 0
  else
    RI := StrToInt(Copy(S1,1,length(S1)-3));
  if (Length(S1)>=3) AND
     (StrToint(S1[length(S1)-2])>=5) then
    RI := RI + 1;
  Result := (RI / 100);
end;

procedure TMainCashForm.actCalcTotalSummExecute(Sender: TObject);
begin
  CalcTotalSumm;
end;

procedure TMainCashForm.actCashWorkExecute(Sender: TObject);
begin
  inherited;
  with TCashWorkForm.Create(Cash, RemainsCDS) do begin
    ShowModal;
    Free;
  end;
end;

procedure TMainCashForm.actChoiceGoodsInRemainsGridExecute(Sender: TObject);
begin
  if MainGrid.IsFocused then
  Begin
    if RemainsCDS.isempty then exit;
    if RemainsCDS.FieldByName('Remains').asCurrency>0 then begin
       SourceClientDataSet := RemainsCDS;
       SoldRegim := true;
       lcName.Text := RemainsCDS.FieldByName('GoodsName').asString;
       ceAmount.Enabled := true;
       ceAmount.Value := 1;
       ActiveControl := ceAmount;
    end
  end
  else
  if AlternativeGrid.IsFocused then
  Begin
    if AlternativeCDS.isempty then exit;
    if AlternativeCDS.FieldByName('Remains').asCurrency>0 then begin
       SourceClientDataSet := AlternativeCDS;
       SoldRegim := true;
       lcName.Text := AlternativeCDS.FieldByName('GoodsName').asString;
       ceAmount.Enabled := true;
       ceAmount.Value := 1;
       ActiveControl := ceAmount;
    end
  End
  else
  Begin
    if CheckCDS.isEmpty then exit;
    if CheckCDS.FieldByName('Amount').asCurrency>0 then begin
       SourceClientDataSet := CheckCDS;
       SoldRegim := False;
       lcName.Text := CheckCDS.FieldByName('GoodsName').asString;
       ceAmount.Enabled := true;
       ceAmount.Value := -1;
       ActiveControl := ceAmount;
    end;
  End;
end;

procedure TMainCashForm.actClearAllExecute(Sender: TObject);
begin
  //if CheckCDS.IsEmpty then exit;
  if MessageDlg('�������� ���?',mtConfirmation,mbYesNo,0)<>mrYes then exit;
  //������� ����� � ������� ����
  FormParams.ParamByName('CheckId').Value := 0;
  FormParams.ParamByName('ManagerId').Value := 0;
  FormParams.ParamByName('BayerName').Value := '';
  FiscalNumber := '';
  pnlVIP.Visible := False;
  lblCashMember.Caption := '';
  lblBayer.Caption := '';
  chbNotMCS.Checked := False;
  UpdateRemainsFromCheck;
  CheckCDS.EmptyDataSet;
  StartRefreshDiffThread;
end;

procedure TMainCashForm.actClearMoneyExecute(Sender: TObject);
begin
  lblMoneyInCash.Caption := '0.00';
end;

procedure TMainCashForm.actExecuteLoadVIPExecute(Sender: TObject);
begin
  inherited;
  if not CheckCDS.IsEmpty then
  Begin
    ShowMessage('������� ��� �� ������. ������� �������� ���!');
    exit;
  End;
  actLoadVIP.Execute;
  lblCashMember.Caption := FormParams.ParamByName('CashMember').AsString;
  lblBayer.Caption := FormParams.ParamByName('BayerName').AsString;
  pnlVIP.Visible := true;
end;

procedure TMainCashForm.actGetMoneyInCashExecute(Sender: TObject);
begin
  spGet_Password_MoneyInCash.Execute;
  if InputBox('������','������� ������:','') <> spGet_Password_MoneyInCash.ParamByName('outPassword').AsString then exit;
  spGetMoneyInCash.ParamByName('inDate').Value := Date;
  spGetMoneyInCash.Execute;
  lblMoneyInCash.Caption := FormatFloat(',0.00',spGetMoneyInCash.ParamByName('outTotalSumm').AsFloat);
end;

procedure TMainCashForm.actInsertUpdateCheckItemsExecute(Sender: TObject);
begin
  if ceAmount.Value <> 0 then begin //���� ��������� ���-�� 0 �� ������ ��������� � ���������� ����
    if not Assigned(SourceClientDataSet) then
      SourceClientDataSet := RemainsCDS;

    if SoldRegim AND (SourceClientDataSet.FieldByName('Price').asCurrency = 0) then begin
       ShowMessage('������ ������� ����� � 0 �����! ��������� � ����������');
       exit;
    end;
    InsertUpdateBillCheckItems;
  end;
  SoldRegim := true;
  ActiveControl := lcName;
end;

procedure TMainCashForm.actPutCheckToCashExecute(Sender: TObject);
var
  UID,CheckNumber: String;
begin
  if CheckCDS.RecordCount = 0 then exit;
  PaidType:=ptMoney;
  //�������� ����� � ��� ������
  if not fShift then
  begin// ���� � Shift, �� �������, ��� ���� ��� �����
    if not CashCloseDialogExecute(FTotalSumm,ASalerCash,PaidType) then
    Begin
      if Self.ActiveControl <> ceAmount then
        Self.ActiveControl := MainGrid;
      exit;
    End;
  end
  else
    ASalerCash:=FTotalSumm;
  //�������� ��� �������� ������
  ShapeState.Brush.Color := clYellow;
  ShapeState.Repaint;
  application.ProcessMessages;
  //������� �� ������
  try
    if PutCheckToCash(MainCashForm.ASalerCash, MainCashForm.PaidType, FiscalNumber, CheckNumber) then
    Begin
      ShapeState.Brush.Color := clRed;
      ShapeState.Repaint;
      if SaveLocal(CheckCDS,
                   FormParams.ParamByName('ManagerId').Value,
                   FormParams.ParamByName('BayerName').Value,
                   True,
                   CheckNumber,
                   UID) then
      Begin
        SaveReal(UID, True);
        NewCheck(false);
      End;
    End;
  finally
    ShapeState.Brush.Color := clGreen;
    ShapeState.Repaint;
  end;
end;

procedure TMainCashForm.actRefreshAllExecute(Sender: TObject);
begin
  InterlockedIncrement(ActualRemainSession); //��������� ������ ��������
  RemainsCDS.DisableControls;
  AlternativeCDS.DisableControls;
  try
    actRefresh.Execute;
  finally
    RemainsCDS.EnableControls;
    AlternativeCDS.EnableControls;
  end;
end;

procedure TMainCashForm.actRefreshRemainsExecute(Sender: TObject);
begin
  StartRefreshDiffThread;
end;

procedure TMainCashForm.actSetFocusExecute(Sender: TObject);
begin
  ActiveControl := lcName;
end;

procedure TMainCashForm.actSetVIPExecute(Sender: TObject);
var
  ManagerID:Integer;
  BayerName: String;
  UID: String;
begin
  If Not VIPDialogExecute(ManagerID,BayerName) then exit;
  FormParams.ParamByName('ManagerId').Value := ManagerId;
  FormParams.ParamByName('BayerName').Value := BayerName;
  if SaveLocal(CheckCDS,ManagerId,BayerName,False,'',UID) then
  begin
    NewCheck(False);
    SaveReal(UID);
  End;
end;

procedure TMainCashForm.actSoldExecute(Sender: TObject);
begin
  SoldRegim:= not SoldRegim;
  ceAmount.Enabled := false;
  lcName.Text := '';
  Activecontrol := lcName;
end;

procedure TMainCashForm.actSpecExecute(Sender: TObject);
begin
  if Assigned(Cash) then
    Cash.AlwaysSold := actSpec.Checked;
end;

procedure TMainCashForm.actUpdateRemainsExecute(Sender: TObject);
begin
  UpdateRemainsFromDiff(nil);
end;

procedure TMainCashForm.ceAmountExit(Sender: TObject);
begin
  ceAmount.Enabled := false;
  lcName.Text := '';
end;

procedure TMainCashForm.ceAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then
     actInsertUpdateCheckItems.Execute
end;

procedure TMainCashForm.FormCreate(Sender: TObject);
var
  F: String;
  CashSessionId: TGUID;
begin
  inherited;
  //��������� ���� ��� ����������� ������
  CreateGUID(CashSessionId);
  FormParams.ParamByName('CashSessionId').Value := GUIDToString(CashSessionId);
  FormParams.ParamByName('ClosedCheckId').Value := 0;
  FormParams.ParamByName('CheckId').Value := 0;
  ShapeState.Brush.Color := clGreen;
  if NOT GetIniFile(F) then
  Begin
    Application.Terminate;
    exit;
  End;
  UserSettingsStorageAddOn.LoadUserSettings;
  try
    Cash:=TCashFactory.GetCash(iniCashType);

    if (Cash <> nil) AND (Cash.FiscalNumber = '') then
    Begin
      MessageDlg('������ ������������� ��������� ��������. ���������� ������ ��������� ����������.' + #13#10 +
                 '��� ��������� ������� ���� "DATECS FP-320" ' + #13#10 +
                 '���������� ������ ��� �������� ����� � ���� ��������' + #13#10 +
                 '(������ [TSoldWithCompMainForm] �������� "FP320SERIAL")', mtError, [mbOK], 0);

      Application.Terminate;
      exit;
    End;

  except
    Begin
      ShowMessage('��������! ��������� �� ����� ������������ � ����������� ��������.'+#13+
                  '���������� ������ ��������� �������� ������ � ������������ ������!');
    End;
  end;

  if not InitLocalStorage then
  Begin
    Application.Terminate;
    exit;
  End;

  spGet_User_IsAdmin.Execute;
  if spGet_User_IsAdmin.ParamByName('gpGet_User_IsAdmin').Value = True then
    actCheck.FormNameParam.Value := 'TCheckJournalForm'
  Else
    actCheck.FormNameParam.Value := 'TCheckJournalUserForm';

  SoldParallel:=iniSoldParallel;
  CheckCDS.CreateDataSet;
  NewCheck;
  OnCLoseQuery := ParentFormCloseQuery;
  TimerSaveAll.Enabled := true;
end;

function TMainCashForm.InitLocalStorage: Boolean;
  Procedure AddIntField(ADataBase: TVKSmartDBF; AName:String);
  Begin
    with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
    begin
      Name := AName;
      field_type := 'N';
      len := 10;
    end;
  end;
  Procedure AddDateField(ADataBase: TVKSmartDBF;AName:String);
  Begin
    with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
    begin
      Name := AName;
      field_type := 'N';
      len := 18;
      dec := 10;
    end;
  end;
  Procedure AddStrField(ADataBase: TVKSmartDBF;AName:String; ALen:Integer);
  Begin
    with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
    begin
      Name := AName;
      field_type := 'C';
      len := ALen;
    end;
  end;
  Procedure AddFloatField(ADataBase: TVKSmartDBF;AName:String);
  Begin
    with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
    begin
      Name := AName;
      field_type := 'N';
      len := 10;
      dec := 4;
    end;
  end;
  Procedure AddBoolField(ADataBase: TVKSmartDBF;AName:String);
  Begin
    with ADataBase.DBFFieldDefs.Add as TVKDBFFieldDef do
    begin
      Name := AName;
      field_type := 'L';
    end;
  end;

begin
  result := False;
  FLocalDataBaseHead.DBFFileName := AnsiString(iniLocalDataBaseHead);
  FLocalDataBaseHead.OEM := False;
  FLocalDataBaseHead.AccessMode.OpenReadWrite := true;

  FLocalDataBaseBody.DBFFileName := AnsiString(iniLocalDataBaseBody);
  FLocalDataBaseBody.OEM := False;
  FLocalDataBaseBody.AccessMode.OpenReadWrite := true;
  if (not FileExists(iniLocalDataBaseHead)) then
  begin
    AddIntField(FLocalDataBaseHead,'ID');//id ����
    AddStrField(FLocalDataBaseHead,'UID',50);//uid ����
    AddDateField(FLocalDataBaseHead,'DATE'); //����/����� ����
    AddIntField(FLocalDataBaseHead,'PAIDTYPE'); //��� ������
    AddStrField(FLocalDataBaseHead,'CASH',20); //�������� ��������
    AddIntField(FLocalDataBaseHead,'MANAGER'); //�������� (VIP)
    AddStrField(FLocalDataBaseHead,'BAYER',254); //���������� (VIP)
    AddBoolField(FLocalDataBaseHead,'SAVE'); //���������� (VIP)
    AddBoolField(FLocalDataBaseHead,'COMPL'); //���������� (VIP)
    AddBoolField(FLocalDataBaseHead,'NEEDCOMPL'); //����� �������� ��������
    AddBoolField(FLocalDataBaseHead,'NOTMCS'); //�� ��������� � ������� ���
    AddStrField(FLocalDataBaseHead,'FISCID',50); //����� ����������� ����
    try
      FLocalDataBaseHead.CreateTable;
    except ON E: Exception do
      Begin
        Application.OnException(Application.MainForm,E);
//        ShowMessage('������ �������� ���������� ���������: '+E.Message);
        Exit;
      End;
    end;
  end;
  if (not FileExists(iniLocalDataBaseBody)) then
  begin
    AddIntField(FLocalDataBaseBody,'ID'); //id ������
    AddStrField(FLocalDataBaseBody,'CH_UID',50); //uid ����
    AddIntField(FLocalDataBaseBody,'GOODSID'); //�� ������
    AddIntField(FLocalDataBaseBody,'GOODSCODE'); //��� ������
    AddStrField(FLocalDataBaseBody,'GOODSNAME',254); //������������ ������
    AddFloatField(FLocalDataBaseBody,'NDS'); //��� ������
    AddFloatField(FLocalDataBaseBody,'AMOUNT'); //���-��
    AddFloatField(FLocalDataBaseBody,'PRICE'); //����

    try
      FLocalDataBaseBody.CreateTable;
    except ON E: Exception do
      Begin
        Application.OnException(Application.MainForm,E);
//        ShowMessage('������ �������� ���������� ���������: '+E.Message);
        Exit;
      End;
    end;
  end;

  try
    FLocalDataBaseHead.Open;
    FLocalDataBaseBody.Open;
  except ON E: Exception do
    Begin
        Application.OnException(Application.MainForm,E);
//      ShowMessage('������ �������� ���������� ���������: '+E.Message);
      Exit;
    End;
  end;
  //�������� ���������
  if (FLocalDataBaseHead.FindField('ID') = nil) or
     (FLocalDataBaseHead.FindField('UID') = nil) or
     (FLocalDataBaseHead.FindField('DATE') = nil) or
     (FLocalDataBaseHead.FindField('PAIDTYPE') = nil) or
     (FLocalDataBaseHead.FindField('CASH') = nil) or
     (FLocalDataBaseHead.FindField('MANAGER') = nil) or
     (FLocalDataBaseHead.FindField('BAYER') = nil) or
     (FLocalDataBaseHead.FindField('COMPL') = nil) or
     (FLocalDataBaseHead.FindField('SAVE') = nil) or
     (FLocalDataBaseHead.FindField('NEEDCOMPL') = nil) or
     (FLocalDataBaseHead.FindField('NOTMCS') = nil) or
     (FLocalDataBaseHead.FindField('FISCID') = nil) then
  Begin
    ShowMessage('�������� ��������� ����� ���������� ��������� ('+iniLocalDataBaseHead+')');
    Exit;
  End;

  if (FLocalDataBaseBody.FindField('ID') = nil) or
     (FLocalDataBaseBody.FindField('CH_UID') = nil) or
     (FLocalDataBaseBody.FindField('GOODSID') = nil) or
     (FLocalDataBaseBody.FindField('GOODSCODE') = nil) or
     (FLocalDataBaseBody.FindField('GOODSNAME') = nil) or
     (FLocalDataBaseBody.FindField('NDS') = nil) or
     (FLocalDataBaseBody.FindField('AMOUNT') = nil) or
     (FLocalDataBaseBody.FindField('PRICE') = nil) then
  Begin
    ShowMessage('�������� ��������� ����� ���������� ��������� ('+iniLocalDataBaseBody+')');
    Exit;
  End;

  LocalDataBaseisBusy := 0;
  Result := FLocalDataBaseHead.Active AND FLocalDataBaseBody.Active;
  if Result then
    SaveRealAll;
end;

procedure TMainCashForm.InsertUpdateBillCheckItems;
begin
  if ceAmount.Value = 0 then
     exit;
  if not assigned(SourceClientDataSet) then
    SourceClientDataSet := RemainsCDS;
  if SoldRegim AND
     (ceAmount.Value > 0) and
     (ceAmount.Value > SourceClientDataSet.FieldByName('Remains').asCurrency) then
  begin
    ShowMessage('�� ������� ���������� ��� �������!');
    exit;
  end;
  if not SoldRegim AND
     (ceAmount.Value < 0) and
     (abs(ceAmount.Value) > abs(CheckCDS.FieldByName('Amount').asCurrency)) then
  begin
    ShowMessage('�� ������� ���������� ��� ��������!');
    exit;
  end;

  if SoldRegim AND (ceAmount.Value > 0) then
  Begin
    CheckCDS.DisableControls;
    try
      CheckCDS.Filtered := False;
      if not checkCDS.Locate('GoodsId',SourceClientDataSet.FieldByName('Id').asInteger,[]) then
      Begin
        checkCDS.Append;
        checkCDS.FieldByName('Id').AsInteger:=0;
        checkCDS.FieldByName('ParentId').AsInteger:=0;
        checkCDS.FieldByName('GoodsId').AsInteger:=SourceClientDataSet.FieldByName('Id').asInteger;
        checkCDS.FieldByName('GoodsCode').AsInteger:=SourceClientDataSet.FieldByName('GoodsCode').asInteger;
        checkCDS.FieldByName('GoodsName').AsString:=SourceClientDataSet.FieldByName('GoodsName').AsString;
        checkCDS.FieldByName('Amount').asCurrency:=0;
        checkCDS.FieldByName('Price').asCurrency:=SourceClientDataSet.FieldByName('Price').asCurrency;
        checkCDS.FieldByName('Summ').asCurrency:=0;
        checkCDS.FieldByName('NDS').asCurrency:=SourceClientDataSet.FieldByName('NDS').asCurrency;
        checkCDS.FieldByName('isErased').AsBoolean:=False;
        checkCDS.Post;
      End;
    finally
      CheckCDS.Filtered := True;
      CheckCDS.EnableControls;
    end;
    UpdateRemainsFromCheck(SourceClientDataSet.FieldByName('Id').asInteger,ceAmount.Value);
    CalcTotalSumm;
  End
  else
  if not SoldRegim AND (ceAmount.Value < 0) then
  Begin
    UpdateRemainsFromCheck(CheckCDS.FieldByName('GoodsId').AsInteger,ceAmount.Value);
    CalcTotalSumm;
  End
  else
  if SoldRegim AND (ceAmount.Value < 0) then
    ShowMessage('��� ������� ����� ��������� ������ ���������� ������ 0!')
  else
  if not SoldRegim AND (ceAmount.Value > 0) then
    ShowMessage('��� �������� ����� ��������� ������ ���������� ������ 0!');
end;

{------------------------------------------------------------------------------}

procedure TMainCashForm.UpdateRemainsFromDiff(ADiffCDS : TClientDataSet);
var
  GoodsId: Integer;
begin
  //���� ��� ����������� - ������ �� ������
  if ADiffCDS = nil then
    ADiffCDS := DiffCDS;
  if ADIffCDS.IsEmpty then
    exit;
  //��������� �������

  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.Filtered := False;
  ADIffCDS.DisableControls;
  CheckCDS.DisableControls;
  try
    ADIffCDS.First;
    while not ADIffCDS.eof do
    begin
      if ADIffCDS.FieldByName('NewRow').AsBoolean then
      Begin
        RemainsCDS.Append;
        RemainsCDS.FieldByName('Id').AsInteger := ADIffCDS.FieldByName('Id').AsInteger;
        RemainsCDS.FieldByName('GoodsCode').AsInteger := ADIffCDS.FieldByName('GoodsCode').AsInteger;
        RemainsCDS.FieldByName('GoodsName').AsString := ADIffCDS.FieldByName('GoodsName').AsString;
        RemainsCDS.FieldByName('Price').asCurrency := ADIffCDS.FieldByName('Price').asCurrency;
        RemainsCDS.FieldByName('Remains').asCurrency := ADIffCDS.FieldByName('Remains').asCurrency;
        RemainsCDS.FieldByName('MCSValue').asCurrency := ADIffCDS.FieldByName('MCSValue').asCurrency;
        RemainsCDS.FieldByName('Reserved').asCurrency := ADIffCDS.FieldByName('Reserved').asCurrency;
        RemainsCDS.Post;
      End
      else
      Begin
        if RemainsCDS.Locate('Id',ADIffCDS.FieldByName('Id').AsInteger,[]) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Price').asCurrency := ADIffCDS.FieldByName('Price').asCurrency;
          RemainsCDS.FieldByName('Remains').asCurrency := ADIffCDS.FieldByName('Remains').asCurrency;
          RemainsCDS.FieldByName('MCSValue').asCurrency := ADIffCDS.FieldByName('MCSValue').asCurrency;
          RemainsCDS.FieldByName('Reserved').asCurrency := ADIffCDS.FieldByName('Reserved').asCurrency;
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;
          RemainsCDS.Post;
        End;
      End;
      ADIffCDS.Next;
    end;

    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      if ADIffCDS.locate('Id',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
      Begin
        if AlternativeCDS.FieldByName('Remains').asCurrency <> ADIffCDS.FieldByName('Remains').asCurrency then
        Begin
          AlternativeCDS.Edit;
          AlternativeCDS.FieldByName('Remains').asCurrency := ADIffCDS.FieldByName('Remains').asCurrency;
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;
          AlternativeCDS.Post;
        End;
      End;
      AlternativeCDS.Next;
    End;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id',GoodsId,[]);
    RemainsCDS.EnableControls;
    RemainsCDS.AfterScroll := RemainsCDSAfterScroll;
    AlternativeCDS.Filtered := true;
    RemainsCDSAfterScroll(RemainsCDS);
    AlternativeCDS.EnableControls;
    CheckCDS.EnableControls;
  end;
end;

procedure TMainCashForm.CalcTotalSumm;
var
  B:TBookmark;
Begin
  FTotalSumm := 0;
  WITH CheckCDS DO
  Begin
    B:= GetBookmark;
    DisableControls;
    try
      First;
      while Not Eof do
      Begin
        FTotalSumm := FTotalSumm + FieldByName('Summ').asCurrency;
        Next;
      End;
      GotoBookmark(B);
      FreeBookmark(B);
    finally
      EnableControls;
    end;
  End;
  lblTotalSumm.Caption := FormatFloat(',0.00',FTotalSumm);
End;

procedure TMainCashForm.WM_KEYDOWN(var Msg: TWMKEYDOWN);
begin
  if (Msg.charcode = VK_TAB) and (ActiveControl=lcName) then
     ActiveControl:=MainGrid;
end;

procedure TMainCashForm.lcNameEnter(Sender: TObject);
begin
  inherited;
  SourceClientDataSet := nil;
end;

procedure TMainCashForm.lcNameExit(Sender: TObject);
begin
  inherited;
  if (GetKeyState(VK_TAB)<0) and (GetKeyState(VK_CONTROL)<0) then begin
     ActiveControl:=CheckGrid;
     exit
  end;
  if GetKeyState(VK_TAB)<0 then
     ActiveControl:=MainGrid;
end;

procedure TMainCashForm.lcNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_Return)
     and
     (
       (
         SoldRegim
         AND
         (lcName.Text = RemainsCDS.FieldByName('GoodsName').AsString)
       )
       or
       (
         not SoldRegim
         AND
         (lcName.Text = CheckCDS.FieldByName('GoodsName').AsString)
       )
     ) then begin
     ceAmount.Enabled := true;
     if SoldRegim then
        ceAmount.Value := 1
     else
        ceAmount.Value := - 1;
     ActiveControl := ceAmount;
  end;
  if Key = VK_TAB then
    ActiveControl:=MainGrid;
end;

procedure TMainCashForm.MainColReservedGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if AText = '0' then
    AText := '';
end;

procedure TMainCashForm.MainGridDBTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
 Cnt: integer;
begin
  if MainGrid.IsFocused then exit;

  Cnt := Sender.ViewInfo.RecordsViewInfo.VisibleCount;
  Sender.Controller.TopRecordIndex := Sender.Controller.FocusedRecordIndex - Round((Cnt+1)/2);
end;

// ��������� ��������� ��������� ��� �������� ������ ����
procedure TMainCashForm.NewCheck(ANeedRemainsRefresh: Boolean = True);
begin
  FormParams.ParamByName('CheckId').Value := 0;
  FormParams.ParamByName('ManagerId').Value := 0;
  FormParams.ParamByName('BayerName').Value := '';
  FiscalNumber := '';
  pnlVIP.Visible := False;
  lblCashMember.Caption := '';
  lblBayer.Caption := '';
  CheckCDS.DisableControls;
  chbNotMCS.Checked := False;
  try
    CheckCDS.EmptyDataSet;
  finally
    CheckCDS.EnableControls;
  end;

  MainCashForm.SoldRegim := true;
  MainCashForm.actSpec.Checked := false;
  if Assigned(MainCashForm.Cash) AND MainCashForm.Cash.AlwaysSold then
    MainCashForm.Cash.AlwaysSold := False;

  if Self.Visible then
  Begin
    if ANeedRemainsRefresh then
      StartRefreshDiffThread;
  End
  else
  Begin
    MainGridDBTableView.BeginUpdate;
    try
      actRefresh.Execute;
    finally
      MainGridDBTableView.EndUpdate;
    end;
  End;
  CalcTotalSumm;
  ceAmount.Value := 0;
  ActiveControl := lcName;
end;

procedure TMainCashForm.ParentFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if not CheckCDS.IsEmpty then
  Begin
    CanClose := False;
    ShowMessage('������� �������� ���.');
  End
  else
    CanClose := MessageDlg('�� ������������� ������ �����?',mtConfirmation,[mbYes,mbCancel], 0) = mrYes;
  while CountRRT>0 do //���� ���� ��������� ��� ������
    Application.ProcessMessages;
  if CanClose then
  Begin
    try
      spDelete_CashSession.Execute;
    Except
    end;
  End;
end;

procedure TMainCashForm.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_Tab) and (CheckGrid.IsFocused) then ActiveControl:=lcName;
  if (Key = VK_ADD) or ((Key = VK_Return) AND (ssShift in Shift)) then
  Begin
    Key := 0;
    fShift := ssShift in Shift;
    actPutCheckToCashExecute(nil);
  End;
end;

function TMainCashForm.PutCheckToCash(SalerCash: Currency;
  PaidType: TPaidType; out AFiscalNumber, ACheckNumber: String): boolean;
{------------------------------------------------------------------------------}
  function PutOneRecordToCash: boolean; //������� ������ ������������
  begin
     // �������� ������ � ����� � ���� ��� OK, �� ������ ����� � �������
     if not Assigned(Cash) or Cash.AlwaysSold then
        result := true
     else
       if not SoldParallel then
         with CheckCDS do begin
            result := Cash.SoldFromPC(FieldByName('GoodsCode').asInteger,
                                      AnsiUpperCase(FieldByName('GoodsName').Text),
                                      FieldByName('Amount').asCurrency,
                                      FieldByName('Price').asCurrency,
                                      FieldByName('NDS').asCurrency)
         end
       else result:=true;
  end;
{------------------------------------------------------------------------------}
begin
  ACheckNumber := '';
  try
    if Assigned(Cash) AND NOT Cash.AlwaysSold then
      AFiscalNumber := Cash.FiscalNumber
    else
      AFiscalNumber := '';
    result := not Assigned(Cash) or Cash.AlwaysSold or Cash.OpenReceipt;
    with CheckCDS do
    begin
      First;
      while not EOF do
      begin
        if result then
           begin
             if CheckCDS.FieldByName('Amount').asCurrency >= 0.001 then
                result := PutOneRecordToCash;//������� ������ � �����
           end;
        Next;
      end;
      if Assigned(Cash) AND not Cash.AlwaysSold then
      begin
        Cash.SubTotal(true, true, 0, 0);
        Cash.TotalSumm(SalerCash, PaidType);
        result := Cash.CloseReceiptEx(ACheckNumber); //������� ���
      end;
    end;
  except
    result := false;
    raise;
  end;
end;

procedure TMainCashForm.RemainsCDSAfterScroll(DataSet: TDataSet);
begin
  if RemainsCDS.FieldByName('AlternativeGroupId').AsInteger = 0 then
    AlternativeCDS.Filter := 'Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString
  else
    AlternativeCDS.Filter := '(Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString +
      ') or (Remains > 0 AND AlternativeGroupId='+RemainsCDS.FieldByName('AlternativeGroupId').AsString+
           ' AND Id <> '+RemainsCDS.FieldByName('Id').AsString+')';
end;

procedure TMainCashForm.UpdateRemainsFromCheck(AGoodsId: Integer = 0; AAmount: Currency = 0);
var
  GoodsId: Integer;
begin
  //���� ����� - ������ �� ������
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;
  //��������� �������
  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.Filtered := False;
  try
    CheckCDS.First;
    while not CheckCDS.eof do
    begin
      if (AGoodsId = 0) or (CheckCDS.FieldByName('GoodsId').AsInteger = AGoodsId) then
      Begin
        if RemainsCDS.Locate('Id',CheckCDS.FieldByName('GoodsId').AsInteger,[]) then
        Begin
          RemainsCDS.Edit;
          if (AAmount = 0)
             or
             (
               (AAmount < 0)
               AND
               (ABS(AAmount) >= CheckCDS.FieldByName('Amount').asCurrency)
             ) then
            RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
              + CheckCDS.FieldByName('Amount').asCurrency
          else
            RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
              - AAmount;
          RemainsCDS.Post;
        End;
      End;
      CheckCDS.Next;
    end;

    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      if (AGoodsId = 0) or (AlternativeCDS.FieldByName('Id').AsInteger = AGoodsId) then
      Begin
        if CheckCDS.locate('GoodsId',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
        Begin
          AlternativeCDS.Edit;
          if (AAmount = 0) or
             (
               (AAmount < 0)
               AND
               (abs(AAmount) >= CheckCDS.FieldByName('Amount').asCurrency)
             ) then
            AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
              + CheckCDS.FieldByName('Amount').asCurrency
          else
            AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
              - AAmount;
          AlternativeCDS.Post;
        End;
      End;
      AlternativeCDS.Next;
    End;

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin
      if (AGoodsId = 0) or (CheckCDS.FieldByName('GoodsId').AsInteger = AGoodsId) then
      Begin
        CheckCDS.Edit;
        if (AAmount = 0) or
           (
             (AAmount < 0)
             AND
             (ABS(AAmount) >= CheckCDS.FieldByName('Amount').asCurrency)
           ) then
          CheckCDS.FieldByName('Amount').asCurrency := 0
        else
          CheckCDS.FieldByName('Amount').asCurrency := CheckCDS.FieldByName('Amount').asCurrency
            + AAmount;
        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('Price').asCurrency);
        CheckCDS.Post;
      End;
      CheckCDS.Next;
    end;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id',GoodsId,[]);
    RemainsCDS.EnableControls;
    RemainsCDS.AfterScroll := RemainsCDSAfterScroll;
    AlternativeCDS.Filtered := true;
    RemainsCDSAfterScroll(RemainsCDS);
    AlternativeCDS.EnableControls;
    CheckCDS.Filtered := True;
    if AGoodsId <> 0 then
      CheckCDS.Locate('GoodsId',AGoodsId,[]);
    CheckCDS.EnableControls;
  end;
end;

function TMainCashForm.SaveLocal(ADS: TClientDataSet; AManagerId: integer;
  ABayerName: String; NeedComplete: Boolean; FiscalCheckNumber: String; out AUID: String): Boolean;
var
  CheckUID: TGUID;
begin
  //������� ���� �������� ����
  while LocalDataBaseisBusy<>0 do
    application.ProcessMessages;
  //��������� ������ � �����
  InterlockedIncrement(LocalDataBaseisBusy);
  try
    //��������� ���� ��� ����
    CreateGUID(CheckUID);
    AUID := GUIDToString(CheckUID);
    Result := True;
    //��������� �����
    try
      FLocalDataBaseHead.AppendRecord([FormParams.ParamByName('CheckId').Value, //id ����
                                       AUID,                                    //uid ����
                                       Now,                                     //����/����� ����
                                       Integer(PaidType),                       //��� ������
                                       FiscalNumber,                            //�������� ��������
                                       AManagerId,                              //�������� (VIP)
                                       ABayerName,                              //���������� (VIP)
                                       False,                                   //���������� �� ���������� ������������
                                       False,                                   //�������� � �������� ���� ������
                                       NeedComplete,                            //���������� ����������
                                       chbNotMCS.Checked,                       //�� ��������� � ������� ���
                                       FiscalCheckNumber                             //����� ����������� ����
                                      ]);
    except ON E:Exception do
      Begin
        Application.OnException(Application.MainForm,E);
//        ShowMessage('������ ���������� ���������� ����: '+E.Message);
        result := False;
        exit;
      End;
    end;
    //��������� ����
    ADS.DisableControls;
    try
      try
        ADS.Filtered := False;
        ADS.First;
        while not ADS.Eof do
        Begin
          FLocalDataBaseBody.AppendRecord([ADS.FieldByName('Id').AsInteger,         //id ������
                                           AUID,                                    //uid ����
                                           ADS.FieldByName('GoodsId').AsInteger,    //�� ������
                                           ADS.FieldByName('GoodsCode').AsInteger,  //��� ������
                                           ADS.FieldByName('GoodsName').AsString,   //������������ ������
                                           ADS.FieldByName('NDS').asCurrency,          //��� ������
                                           ADS.FieldByName('Amount').asCurrency,       //���-��
                                           ADS.FieldByName('Price').asCurrency         //����
                                          ]);
        ADS.Next;
        End;
      Except ON E:Exception do
        Begin
        Application.OnException(Application.MainForm,E);
//          ShowMessage('������ ���������� ���������� ����������� ����: '+E.Message);
          result := False;
          exit;
        End;
      end;
    finally
      ADS.Filtered := true;
      ADS.EnableControls;
    end;
  finally
    InterlockedDecrement(LocalDataBaseisBusy);
  end;
end;

procedure TMainCashForm.SaveReal(AUID: String; ANeedComplete: boolean = False);
Begin
  With TSaveRealThread.Create(true) do
  Begin
    FreeOnTerminate := true;
    FCheckUID := AUID;
    Start;
  End;
End;

procedure TMainCashForm.SaveRealAll;
begin
  With TSaveRealAllThread.Create(true) do
  Begin
    FreeOnTerminate := true;
    Start;
  End;
end;

procedure TMainCashForm.StartRefreshDiffThread;
Begin
  With TRefreshDiffThread.Create(true) do
  Begin
    FreeOnTerminate := true;
    Start;
  End;
End;

procedure TMainCashForm.SetSoldRegim(const Value: boolean);
begin
  FSoldRegim := Value;
  if SoldRegim then begin
     actSold.Caption := '�������';
     ceAmount.Value := 1;
  end
  else begin
     actSold.Caption := '�������';
     ceAmount.Value := -1;
  end;
end;

procedure TMainCashForm.Thread_Exception(var Msg: TMessage);
var
  spUserProtocol : TdsdStoredProc;
begin
  spUserProtocol := TdsdStoredProc.Create(nil);
  try
    spUserProtocol.StoredProcName := 'gpInsert_UserProtocol';
    spUserProtocol.OutputType := otResult;
    spUserProtocol.Params.AddParam('inProtocolData', ftBlob, ptInput, ThreadErrorMessage);
    try
      spUserProtocol.Execute;
    except
    end;
  finally
    spUserProtocol.free;
  end;
//  ShowMessage('�� ����� ���������� ���� �������� ������:'+#13+
//              ThreadErrorMessage+#13#13+
//              '��������� ��������� ���� �, ��� �������������, ��������� ��� �������.');
end;

procedure TMainCashForm.TimerSaveAllTimer(Sender: TObject);
begin
  if not FLocalDataBaseHead.IsEmpty then
    SaveRealAll;
end;

{ TSaveRealThread }

procedure TSaveRealThread.Execute;
var
  Head: THeadRecord;
  Body: TBodyArr;
  Find: Boolean;
  dsdSave: TdsdStoredProc;
  I: Integer;
begin
  inherited;
  EnterCriticalSection(csCriticalSection_Save);
  try
    CoInitialize(nil);
    SetShapeState(clRed);
    try
      Find := False;
      InterlockedIncrement(CountRRT);
      InterlockedIncrement(CountSaveThread);
      try
        //���� ���� ����������� ������ � ��������� ����
        while LocalDataBaseisBusy <> 0 do
          sleep(10);
        //��������� ����
        InterlockedIncrement(LocalDataBaseisBusy);
        try
          if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
             not FLocalDataBaseHead.Deleted then
          Begin
            Find := True;
            With Head, FLocalDataBaseHead do
            Begin
              ID       := FieldByName('ID').AsInteger;
              UID      := FieldByName('UID').AsString;
              DATE     := FieldByName('DATE').asCurrency;
              CASH     := trim(FieldByName('CASH').AsString);
              PAIDTYPE := FieldByName('PAIDTYPE').AsInteger;
              MANAGER  := FieldByName('MANAGER').AsInteger;
              BAYER    := trim(FieldByName('BAYER').AsString);
              COMPL    := FieldByName('COMPL').AsBoolean;
              NEEDCOMPL:= FieldByName('NEEDCOMPL').AsBoolean;
              SAVE     := FieldByName('SAVE').AsBoolean;
              FISCID   := trim(FieldByName('FISCID').AsString);
              NOTMCS   := FieldByName('NOTMCS').AsBoolean;

            end;
            FLocalDataBaseBody.First;
            while not FLocalDataBaseBody.Eof do
            Begin
              if (Trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = FCheckUID) AND
                 not FLocalDataBaseBody.Deleted  then
              Begin
                SetLength(Body,Length(Body)+1);
                with Body[Length(Body)-1],FLocalDataBaseBody  do
                Begin
                  CH_UID    := trim(FieldByName('CH_UID').AsString);
                  GOODSID   := FieldByName('GOODSID').AsInteger;
                  GOODSCODE := FieldByName('GOODSCODE').AsInteger;
                  GOODSNAME := trim(FieldByName('GOODSNAME').AsString);
                  NDS       := FieldByName('NDS').asCurrency;
                  AMOUNT    := FieldByName('AMOUNT').asCurrency;
                  PRICE     := FieldByName('PRICE').asCurrency;
                End;
              End;
              FLocalDataBaseBody.Next;
            End;
          End;
        finally
          //��������� ��������� ����
          InterlockedDecrement(LocalDataBaseisBusy);
        end;
        if Find AND NOT HEAD.SAVE then
        Begin
          dsdSave := TdsdStoredProc.Create(nil);
          try
            try
              //��������� � ����� ��������� ��������.
              dsdSave.StoredProcName := 'gpGet_Movement_CheckState';
              dsdSave.OutputType := otResult;
              dsdSave.Params.Clear;
              dsdSave.Params.AddParam('inId',ftInteger,ptInput,Head.ID);
              dsdSave.Params.AddParam('outState',ftInteger,ptOutput,Null);
              dsdSave.Execute(False,False);
              if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2' then //��������
              Begin
                Head.SAVE := True;
                Head.NEEDCOMPL := False;
              End
              else
              //���� �� ��������
              Begin
                if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '3' then //������
                Begin
                  dsdSave.StoredProcName := 'gpUnComplete_Movement_Check';
                  dsdSave.OutputType := otResult;
                  dsdSave.Params.Clear;
                  dsdSave.Params.AddParam('inMovementId',ftInteger,ptInput,Head.ID);
                  dsdSave.Execute(False,False);
                end;
                //�������� �����
                dsdSave.StoredProcName := 'gpInsertUpdate_Movement_Check_ver2';
                dsdSave.OutputType := otResult;
                dsdSave.Params.Clear;
                dsdSave.Params.AddParam('ioId',ftInteger,ptInputOutput,Head.ID);
                dsdSave.Params.AddParam('inDate',ftDateTime,ptInput,Head.DATE);
                dsdSave.Params.AddParam('inCashRegister',ftString,ptInput,Head.CASH);
                dsdSave.Params.AddParam('inPaidType',ftInteger,ptInput,Head.PAIDTYPE);
                dsdSave.Params.AddParam('inManagerId',ftInteger,ptInput,Head.MANAGER);
                dsdSave.Params.AddParam('inBayer',ftString,ptInput,Head.BAYER);
                dsdSave.Params.AddParam('inFiscalCheckNumber',ftString,ptInput,Head.FISCID);
                dsdSave.Params.AddParam('inNotMCS',ftBoolean,ptInput,Head.NOTMCS);
                dsdSave.Execute(False,False);
                SetShapeState(clBlack);
                //��������� � ��������� ���� ���������� �����
                if Head.ID <> StrToInt(dsdSave.Params.ParamByName('ioID').AsString) then
                Begin
                  Head.ID := StrToInt(dsdSave.Params.ParamByName('ioID').AsString);
                  //���� ���� ����������� ������ � ��������� ����
                  while LocalDataBaseisBusy <> 0 do
                    sleep(10);
                  //��������� ����
                  InterlockedIncrement(LocalDataBaseisBusy);
                  try
                    if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
                       not FLocalDataBaseHead.Deleted then
                    Begin
                      FLocalDataBaseHead.Edit;
                      FLocalDataBaseHead.FieldByname('ID').AsInteger := Head.ID;
                      FLocalDataBaseHead.Post;
                    End;
                  finally
                    //��������� ��������� ����
                    InterlockedDecrement(LocalDataBaseisBusy);
                  end;
                end;

                //�������� ����
                dsdSave.StoredProcName := 'gpInsertUpdate_MovementItem_Check_ver2';
                dsdSave.OutputType := otResult;
                dsdSave.Params.Clear;
                dsdSave.Params.AddParam('ioId',ftInteger,ptInputOutput,Null);
                dsdSave.Params.AddParam('inMovementId',ftInteger,ptInput,Head.ID);
                dsdSave.Params.AddParam('inGoodsId',ftInteger,ptInput,Null);
                dsdSave.Params.AddParam('inAmount',ftFloat,ptInput,Null);
                dsdSave.Params.AddParam('inPrice',ftFloat,ptInput,Null);

                for I := 0 to Length(Body)-1 do
                Begin
                  dsdSave.ParamByName('ioId').Value := Body[I].ID;
                  dsdSave.ParamByName('inGoodsId').Value := Body[I].GOODSID;
                  dsdSave.ParamByName('inAmount').Value := Body[I].AMOUNT;
                  dsdSave.ParamByName('inPrice').Value :=  Body[I].PRICE;
                  dsdSave.Execute(False,False);
                  if Body[I].ID <> StrToInt(dsdSave.ParamByName('ioId').AsString) then
                  Begin
                    Body[I].ID := StrToInt(dsdSave.ParamByName('ioId').AsString);
                    //���� ���� ����������� ������ � ��������� ����
                    while LocalDataBaseisBusy <> 0 do
                      sleep(10);
                    //��������� ����
                    InterlockedIncrement(LocalDataBaseisBusy);
                    try
                      FLocalDataBaseBody.First;
                      while not FLocalDataBaseBody.eof do
                      Begin
                        if (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = FCheckUID)
                           AND
                           not FLocalDataBaseBody.Deleted
                           AND
                           (FLocalDataBaseBody.FieldByName('GOODSID').AsInteger = Body[I].GOODSID) then
                        Begin
                          FLocalDataBaseBody.Edit;
                          FLocalDataBaseBody.FieldByname('ID').AsInteger := Body[I].ID;
                          FLocalDataBaseBody.Post;
                          break;
                        End;
                        FLocalDataBaseBody.Next;
                      End;
                    finally
                      //��������� ��������� ����
                      InterlockedDecrement(LocalDataBaseisBusy);
                    end;
                  End;
                End;
                SetShapeState(clBlue);
                Head.SAVE := True;
                //���� ���� ����������� ������ � ��������� ����
                while LocalDataBaseisBusy <> 0 do
                  sleep(10);
                //��������� ����
                InterlockedIncrement(LocalDataBaseisBusy);
                try
                  if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
                     not FLocalDataBaseHead.Deleted then
                  Begin
                    FLocalDataBaseHead.Edit;
                    FLocalDataBaseHead.FieldByname('SAVE').AsBoolean := True;
                    FLocalDataBaseHead.Post;
                  End;
                finally
                  //��������� ��������� ����
                  InterlockedDecrement(LocalDataBaseisBusy);
                end;
              End;
            except ON E: Exception do
              Begin
                MainCashForm.ThreadErrorMessage:=E.Message;
                PostMessage(MainCashForm.Handle,UM_THREAD_EXCEPTION,0,0);
              End;
            end;
          finally
            freeAndNil(dsdSave);
          end;
        end;
        //���� ���������� �������� ���
        if find AND Head.SAVE AND Head.NEEDCOMPL then
        Begin
          dsdSave := TdsdStoredProc.Create(nil);
          try
            DiffCDS := TClientDataSet.Create(nil);
            try
              dsdSave.StoredProcName := 'gpComplete_Movement_Check_ver2';
              dsdSave.OutputType := otDataSet;
              dsdSave.DataSet := DiffCDS;
              dsdSave.Params.Clear;
              dsdSave.Params.AddParam('inMovementId',ftInteger,ptInput,Head.ID);
              dsdSave.Params.AddParam('inPaidType',ftInteger,ptInput,Head.PAIDTYPE);
              dsdSave.Params.AddParam('inCashRegister',ftString,ptInput,Head.CASH);
              dsdSave.Params.AddParam('inCashSessionId',ftString,ptInput,MainCashForm.FormParams.ParamByName('CashSessionId').Value);
              try
                dsdSave.Execute(False,False);
                Head.COMPL := True;
              except on E: Exception do
                Begin
                  MainCashForm.ThreadErrorMessage:=E.Message;
                  PostMessage(MainCashForm.Handle,UM_THREAD_EXCEPTION,0,0);
                End;
              end;
              SetShapeState(clYellow);
              Synchronize(UpdateRemains);
              SetShapeState(clWhite);
            finally
              DiffCDS.free;
            end;
          finally
            freeAndNil(dsdSave);
          end;
          //������� ����������� ���
          if Head.COMPL then
          Begin
            //���� ���� ����������� ������ � ��������� ����
            while LocalDataBaseisBusy <> 0 do
              sleep(10);
            //��������� ����
            InterlockedIncrement(LocalDataBaseisBusy);
            try
              if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
                 not FLocalDataBaseHead.Deleted then
                FLocalDataBaseHead.DeleteRecord;
              FLocalDataBaseBody.First;
              while not FLocalDataBaseBody.eof do
              Begin
                IF (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = FCheckUID) AND
                    not FLocalDataBaseBody.Deleted then
                  FLocalDataBaseBody.DeleteRecord;
                FLocalDataBaseBody.Next;
              End;
              FLocalDataBaseHead.Pack;
              FLocalDataBaseBody.Pack;
            finally
              //��������� ��������� ����
              InterlockedDecrement(LocalDataBaseisBusy);
            end;
          End;
        end
        //���� ��������� �� �����
        ELSE
        if find and Head.SAVE then
        BEGIN
          if (Head.MANAGER <> 0) or (Head.BAYER <> '') then
          Begin
            With TRefreshDiffThread.Create(true) do
            Begin
              FreeOnTerminate := true;
              Start;
            End;
          end;
          //���� ���� ����������� ������ � ��������� ����
          while LocalDataBaseisBusy <> 0 do
            sleep(10);
          //��������� ����
          InterlockedIncrement(LocalDataBaseisBusy);
          try
            if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
               not FLocalDataBaseHead.Deleted then
              FLocalDataBaseHead.DeleteRecord;
            FLocalDataBaseBody.First;
            while not FLocalDataBaseBody.eof do
            Begin
              IF (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = FCheckUID) AND
                  not FLocalDataBaseBody.Deleted then
                FLocalDataBaseBody.DeleteRecord;
              FLocalDataBaseBody.Next;
            End;
            FLocalDataBaseHead.Pack;
            FLocalDataBaseBody.Pack;
          finally
            //��������� ��������� ����
            InterlockedDecrement(LocalDataBaseisBusy);
          end;
        End;
      finally
        InterlockedDecrement(CountRRT);
        InterlockedDecrement(CountSaveThread);
      end;
    finally
      CoUninitialize;
    end;
  finally
    LeaveCriticalSection(csCriticalSection_Save);
  end;
end;

procedure TSaveRealThread.SetShapeState(AColor: TColor);
begin
  FShapeColor := AColor;
//  Queue(SyncShapeState);
  Synchronize(SyncShapeState);
end;

procedure TSaveRealThread.SyncShapeState;
begin
  MainCashForm.ShapeState.Pen.Color := FShapeColor;
end;

procedure TSaveRealThread.UpdateRemains;
begin
  MainCashForm.UpdateRemainsFromDiff(DiffCDS);
end;

{ TRefreshDiffThread }

procedure TRefreshDiffThread.Execute;
begin
  inherited;
  CoInitialize(nil);
  try
    InterlockedIncrement(CountRRT);
    try
      EnterCriticalSection(csCriticalSection);
      try
        SetShapeState(clRed);
        MainCashForm.spSelect_CashRemains_Diff.Execute(False,False);
        SetShapeState(clBlue);
        Synchronize(UpdateRemains);
        SetShapeState(clWhite);
      finally
        LeaveCriticalSection(csCriticalSection);
      end;
    finally
      InterlockedDecrement(CountRRT);
    end;
  finally
    CoUninitialize;
  end;
end;

procedure TRefreshDiffThread.SetShapeState(AColor: TColor);
begin
  FShapeColor := AColor;
  Synchronize(SyncShapeState);
end;

procedure TRefreshDiffThread.SyncShapeState;
begin
  MainCashForm.ShapeState.Pen.Color := FShapeColor;
end;

procedure TRefreshDiffThread.UpdateRemains;
begin
  MainCashForm.UpdateRemainsFromDiff(nil);
end;

{ TSaveRealAllThread }

procedure TSaveRealAllThread.Execute;
var
  I: Integer;
  UID: String;
  T:TSaveRealThread;
begin
  inherited;
  if CountSaveThread > 0 then exit;
  
  InterlockedIncrement(CountRRT);
  try
    EnterCriticalSection(csCriticalSection_All);
    try
      for I := 0 to 5 do
      Begin
        //���� ���� ����������� ������ � ��������� ����
        while LocalDataBaseisBusy <> 0 do
          sleep(10);
        //��������� ����
        InterlockedIncrement(LocalDataBaseisBusy);
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
          //��������� ��������� ����
          InterlockedDecrement(LocalDataBaseisBusy);
        end;
        if UID <> '' then
        Begin
          T := TSaveRealThread.create(true);
          try
            T.FCheckUID := UID;
            T.Execute;
          finally
            T.Free;
            FLocalDataBaseHead.First;
          end;
        End;
      End;
    finally
      LeaveCriticalSection(csCriticalSection_All);
    end;
  finally
    InterlockedDecrement(CountRRT);
  end;
end;

initialization
  RegisterClass(TMainCashForm);
  FLocalDataBaseHead := TVKSmartDBF.Create(nil);
  FLocalDataBaseBody := TVKSmartDBF.Create(nil);
  InitializeCriticalSection(csCriticalSection);
  InitializeCriticalSection(csCriticalSection_Save);
  InitializeCriticalSection(csCriticalSection_All);
finalization
  FLocalDataBaseHead.Free;
  FLocalDataBaseBody.Free;
  DeleteCriticalSection(csCriticalSection);
  DeleteCriticalSection(csCriticalSection_Save);
  DeleteCriticalSection(csCriticalSection_All);
end.
