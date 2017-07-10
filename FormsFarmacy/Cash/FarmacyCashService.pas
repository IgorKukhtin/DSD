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
    spGet_User_IsAdmin: TdsdStoredProc; //+
    Timer2: TTimer;
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
    Timer1: TTimer;
    tiServise: TTrayIcon;
    N4: TMenuItem;
    ilIcons: TImageList;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    actCashRemains: TAction;
    N8: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actRefreshAllExecute(Sender: TObject); //+
    procedure Timer2Timer(Sender: TObject);
    procedure actSetCashSessionIdExecute(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure actCashRemainsExecute(Sender: TObject);

  private
    { Private declarations }

    procedure AppMsgHandler(var Msg: TMsg; var Handled: Boolean);
  public
    { Public declarations }


   ThreadErrorMessage:String;

   FiscalNumber: String;

    procedure SaveLocalVIP;
    procedure RemainsCDSAfterScroll(DataSet: TDataSet);
    procedure SaveRealAll;
    procedure ChangeStatus(AStatus: String);
    function InitLocalStorage: Boolean;

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
      2: actSetCashSessionId.Execute;    // ���������� ��� �����

      3: begin
          SaveRealAll;    // ��������� �������� ����
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
             actRefreshAllExecute(nil);
          end;

      40: begin // ������� ������ �� ���������� ������ ��������
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

   PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 2); // ������ �� ���������� CashSessionId �  CashSessionId.ini

  end;
end;




procedure TMainCashForm2.ChangeStatus(AStatus: String);
Begin
  tiServise.BalloonHint := AStatus;
End;

procedure TMainCashForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  AllowedConduct := True; // ������ �������� ���������� ���������� �����
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
    ReleaseMutex(MutexRemains);
    MainCashForm2.tiServise.IconIndex:=0;
  end;

end;

procedure TMainCashForm2.actRefreshAllExecute(Sender: TObject);
begin   //yes
  // ���������� ������ � �������
  WaitForSingleObject(MutexRemains, INFINITE);
  WaitForSingleObject(MutexAlternative, INFINITE);
  MainCashForm2.tiServise.IconIndex:=1;
  try
    if RemainsCDS.IsEmpty then
    begin
      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        if FileExists(Remains_lcl) then
          LoadLocalData(RemainsCDS, Remains_lcl);
        if FileExists(Alternative_lcl) then
          LoadLocalData(AlternativeCDS, Alternative_lcl);
      finally
        RemainsCDS.EnableControls;
        AlternativeCDS.EnableControls;
      end;
    end;

    if not gc_User.Local  then
    Begin
      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        try
          //��������� ��������
          actRefresh.Execute;
          //���������� �������� � ��������� ����
          SaveLocalData(RemainsCDS,Remains_lcl);
          SaveLocalData(AlternativeCDS,Alternative_lcl);
          //��������� ��� ����� � ���������� � ��������� ����
          SaveLocalVIP;
          PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 3);
          // ����� ����������� �������
          tiServise.BalloonHint:='������� ���������.';
          tiServise.ShowBalloonHint;
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
    ReleaseMutex(MutexRemains);
    ReleaseMutex(MutexAlternative);
    ChangeStatus('���������');
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
  //��������� ���� ��� ����������� ������
  ChangeStatus('��������� �������������� ����������');

  FormParams.ParamByName('CashSessionId').Value := GenerateGUID;
  PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 2); // ������ ��� ����� � ����������

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
 //}

  ChangeStatus('������');

  SaveRealAll; // �������� ���� ������� �������� �� ������������ ������. ����������� Count�hecksAtOnce = 7
               // ���������� ������ 7 ����� � ����� ����� ��� ������ ��� ���� �� ������� ������ �������

end;

// ��������� ��������� ��������� ��� �������� ������ ����
procedure TMainCashForm2.N1Click(Sender: TObject);
begin
  actRefreshAllExecute(nil);
end;

procedure TMainCashForm2.N2Click(Sender: TObject);
begin
Timer2.Enabled := not Timer2.Enabled;
N2.Checked := Timer2.Enabled;
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
 MainCashForm2.tiServise.IconIndex:=0;
end;
end;

procedure TMainCashForm2.N6Click(Sender: TObject);
begin
 try
   Count�hecksAtOnce:= StrToInt(InputBox('���������� ���������� ����� �� ���', '������� ���������� �� ������ 50', '7'));
   if Count�hecksAtOnce > 50  then Count�hecksAtOnce := 50;
   tiServise.BalloonHint:='���������� ���������� ����� �� ��� �������� �� ' + inttostr(Count�hecksAtOnce);
   tiServise.ShowBalloonHint;
   n6.Caption:= '���������� ���������� ����� �� ��� ' + inttostr(Count�hecksAtOnce)
 except
   tiServise.BalloonHint:='�������� ����';
   tiServise.ShowBalloonHint;
 end;
end;

procedure TMainCashForm2.N7Click(Sender: TObject);
begin
  Timer1.Enabled := not Timer1.Enabled;
  N7.Checked := Timer2.Enabled;
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
      WaitForSingleObject(MutexVip, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
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
procedure TMainCashForm2.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=False;
 try
  SaveRealAll;
 finally
  Timer1.Enabled:=True;
 end;
end;

procedure TMainCashForm2.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := False;

  try
    WaitForSingleObject(MutexRefresh, INFINITE);
    actRefreshAllExecute(nil);
  finally
    ReleaseMutex(MutexRefresh);
    Timer2.Enabled := True;
  end;
end;

procedure TMainCashForm2.RemainsCDSAfterScroll(DataSet: TDataSet);
begin
  if RemainsCDS.FieldByName('AlternativeGroupId').AsInteger = 0 then
    AlternativeCDS.Filter := 'Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString
  else
    AlternativeCDS.Filter := '(Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString +
      ') or (Remains > 0 AND AlternativeGroupId='+RemainsCDS.FieldByName('AlternativeGroupId').AsString+
           ' AND Id <> '+RemainsCDS.FieldByName('Id').AsString+')';
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
begin
   try
    spGet_User_IsAdmin.Execute;
    if gc_User.Local then
     begin
       gc_User.Local := False;
       tiServise.BalloonHint:='����� ������������';
       tiServise.ShowBalloonHint;
     end;
  except
    Begin
      gc_User.Local := True;
      tiServise.BalloonHint:='��������� �����';
      tiServise.ShowBalloonHint;
      Exit;
    End;
  end;

 // ��������� ������ ����� ��� ��������� 
  if  AllowedConduct then Exit;

  MainCashForm2.tiServise.IconIndex:=1;
  WaitForSingleObject(MutexRefresh, INFINITE);   // ������������ ���������� � ���������� ���� �������� ���������
  WaitForSingleObject(MutexAllowedConduct, INFINITE); // ��� ������ ���������� �� ���������� ��� ��������
  try
      for J := 1 to Count�hecksAtOnce do
      Begin
       Application.ProcessMessages;   // ����� ��������� ������
       // ������� �� ����� ��� ��������� �������� �������� ��� �������� � ��������� �����
       if  AllowedConduct or gc_User.Local then
       begin
        tiServise.BalloonHint:='������������� ���������� �����';
        tiServise.ShowBalloonHint;
       Exit;
       end;

       WaitForSingleObject(MutexDBF, INFINITE);
       FLocalDataBaseHead.Active:=True;
       FLocalDataBaseBody.Active:=True;
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
         FLocalDataBaseBody.Active:=False;
         FLocalDataBaseHead.Active:=False;
         ReleaseMutex(MutexDBF);

        end;
        if UID <> '' then
         Begin
          Find := False;
          WaitForSingleObject(MutexDBF, INFINITE);
          FLocalDataBaseHead.Active:=True;
          FLocalDataBaseBody.Active:=True;
         try
          if FLocalDataBaseHead.Locate('UID',UID,[loPartialKey]) AND
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
              //***20.07.16
              DISCOUNTID := FieldByName('DISCOUNTID').AsInteger;
              DISCOUNTN  := trim(FieldByName('DISCOUNTN').AsString);
              DISCOUNT   := trim(FieldByName('DISCOUNT').AsString);
              //***16.08.16
              BAYERPHONE := trim(FieldByName('BAYERPHONE').AsString);
              CONFIRMED  := trim(FieldByName('CONFIRMED').AsString);
              NUMORDER   := trim(FieldByName('NUMORDER').AsString);
              CONFIRMEDC := trim(FieldByName('CONFIRMEDC').AsString);
              //***24.01.17
              USERSESION := trim(FieldByName('USERSESION').AsString);
              //***08.04.17
              PMEDICALID := FieldByName('PMEDICALID').AsInteger;
              PMEDICALN  := trim(FieldByName('PMEDICALN').AsString);
              AMBULANCE  := trim(FieldByName('AMBULANCE').AsString);
              MEDICSP    := trim(FieldByName('MEDICSP').AsString);
              INVNUMSP   := trim(FieldByName('INVNUMSP').AsString);
              OPERDATESP := FieldByName('OPERDATESP').asCurrency;
              //***15.06.17
              SPKINDID := FieldByName('SPKINDID').AsInteger;

              FNeedSaveVIP := (MANAGER <> 0);
            end;
            FLocalDataBaseBody.First;
            while not FLocalDataBaseBody.Eof do
            Begin
              if (Trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = UID) AND
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
                  //***20.07.16
                  PRICESALE := FieldByName('PRICESALE').asCurrency;
                  CHPERCENT := FieldByName('CHPERCENT').asCurrency;
                  SUMMCH    := FieldByName('SUMMCH').asCurrency;
                  //***19.08.16
                  AMOUNTORD := FieldByName('AMOUNTORD').asCurrency;
                  //***10.08.16
                  LIST_UID  := trim(FieldByName('LIST_UID').asString);
                End;
              End;
              FLocalDataBaseBody.Next;
            End;
          End;
         finally
          FLocalDataBaseHead.Active:=False;
          FLocalDataBaseBody.Active:=False;
          ReleaseMutex(MutexDBF);

        end; // ��������� ��� � head and body

        //�.�. ��� ����� ����� ������� �� ���
        fError_isComplete:= FALSE; // 04.02.2017

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

                //�.�. ��� ������ ����� ������� �� ���
                fError_isComplete:= TRUE; // 04.02.2017
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
                //***20.07.16
                dsdSave.Params.AddParam('inDiscountExternalId',ftInteger,ptInput,Head.DISCOUNTID);
                dsdSave.Params.AddParam('inDiscountCardNumber',ftString,ptInput,Head.DISCOUNT);
                //***16.08.16
                dsdSave.Params.AddParam('inBayerPhone',       ftString,ptInput,Head.BAYERPHONE);
                dsdSave.Params.AddParam('inConfirmedKindName',ftString,ptInput,Head.CONFIRMED);
                dsdSave.Params.AddParam('inInvNumberOrder',   ftString,ptInput,Head.NUMORDER);
                //***08.04.17
                dsdSave.Params.AddParam('inPartnerMedicalId',ftInteger,ptInput,Head.PMEDICALID);
                dsdSave.Params.AddParam('inAmbulance', ftString, ptInput, Head.AMBULANCE);
                dsdSave.Params.AddParam('inMedicSP', ftString, ptInput, Head.MEDICSP);
                dsdSave.Params.AddParam('inInvNumberSP', ftString, ptInput, Head.INVNUMSP);
                dsdSave.Params.AddParam('inOperDateSP', ftDateTime, ptInput, Head.OPERDATESP);
                //***15.06.17
                dsdSave.Params.AddParam('inSPKindId',ftInteger,ptInput,Head.SPKINDID);
                //***24.01.17
                dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                dsdSave.Execute(False,False);
                //��������� � ��������� ���� ���������� �����
                if Head.ID <> StrToInt(dsdSave.Params.ParamByName('ioID').AsString) then
                Begin
                  Head.ID := StrToInt(dsdSave.Params.ParamByName('ioID').AsString);
                  WaitForSingleObject(MutexDBF, INFINITE);
                  FLocalDataBaseHead.Active:=True;
                  try
                    if FLocalDataBaseHead.Locate('UID',UID,[loPartialKey]) AND
                       not FLocalDataBaseHead.Deleted then
                    Begin
                      FLocalDataBaseHead.Edit;
                      FLocalDataBaseHead.FieldByname('ID').AsInteger := Head.ID;
                      FLocalDataBaseHead.Post;
                    End;
                  finally
                   FLocalDataBaseHead.Active:=False;
                   ReleaseMutex(MutexDBF);
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
                //***20.07.16
                dsdSave.Params.AddParam('inPriceSale',ftFloat,ptInput,Null);
                dsdSave.Params.AddParam('inChangePercent',ftFloat,ptInput,Null);
                dsdSave.Params.AddParam('inSummChangePercent',ftFloat,ptInput,Null);
                //***19.08.16
                //dsdSave.Params.AddParam('inAmountOrder',ftFloat,ptInput,Null);
                //***10.08.16
                dsdSave.Params.AddParam('inList_UID',ftString,ptInput,Null);
                //
                dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                for I := 0 to Length(Body)-1 do
                Begin
                  dsdSave.ParamByName('ioId').Value := Body[I].ID;
                  dsdSave.ParamByName('inGoodsId').Value := Body[I].GOODSID;
                  dsdSave.ParamByName('inAmount').Value := Body[I].AMOUNT;
                  dsdSave.ParamByName('inPrice').Value :=  Body[I].PRICE;
                  //***20.07.16
                  dsdSave.ParamByName('inPriceSale').Value :=  Body[I].PRICESALE;
                  dsdSave.ParamByName('inChangePercent').Value :=  Body[I].CHPERCENT;
                  dsdSave.ParamByName('inSummChangePercent').Value :=  Body[I].SUMMCH;
                  //***19.08.16
                  //dsdSave.ParamByName('inAmountOrder').Value :=  Body[I].AMOUNTORD;
                  //***10.08.16
                  dsdSave.ParamByName('inList_UID').Value :=  Body[I].LIST_UID;
                  //

                  dsdSave.Execute(False,False);  // ��������� �� �������
                  if Body[I].ID <> StrToInt(dsdSave.ParamByName('ioId').AsString) then
                  Begin
                    Body[I].ID := StrToInt(dsdSave.ParamByName('ioId').AsString);
                     WaitForSingleObject(MutexDBF, INFINITE);
                     FLocalDataBaseBody.Active:=True;
                    try
                      FLocalDataBaseBody.First;
                      while not FLocalDataBaseBody.eof do
                      Begin
                        if (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = UID)
                           AND
                           not FLocalDataBaseBody.Deleted
                           AND
                           (FLocalDataBaseBody.FieldByName('GOODSID').AsInteger = Body[I].GOODSID) then
                        Begin
                          FLocalDataBaseBody.Edit;
                          FLocalDataBaseBody.FieldByname('ID').AsInteger := Body[I].ID;
                          FLocalDataBaseBody.Post;  // ��������� � �����
                          break;
                        End;
                        FLocalDataBaseBody.Next;
                      End;
                    finally
                     FLocalDataBaseBody.Active:=False;
                     ReleaseMutex(MutexDBF);
                    end;
                  End;
                End; // ���������� ��� ������� ������ � ����
                Head.SAVE := True;
                WaitForSingleObject(MutexDBF, INFINITE);
                FLocalDataBaseHead.Active:=True;
                try
                  if FLocalDataBaseHead.Locate('UID',UID,[loPartialKey]) AND
                     not FLocalDataBaseHead.Deleted then
                  Begin
                    FLocalDataBaseHead.Edit;
                    FLocalDataBaseHead.FieldByname('SAVE').AsBoolean := True;
                    FLocalDataBaseHead.Post;
                  End;
                finally
                  FLocalDataBaseHead.Active:=False;
                  ReleaseMutex(MutexDBF);

                end;
              End; // ���������� ��� � ��������
            except ON E: Exception do
              Begin
                if gc_User.Local then
                  begin
                     tiServise.BalloonHint:='������������� ���������� �����';
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
              dsdSave.Params.AddParam('inCashSessionId',ftString,ptInput,MainCashForm2.FormParams.ParamByName('CashSessionId').Value);
              dsdSave.Params.AddParam('inUserSession', ftString,ptInput, Head.USERSESION);
              try
                dsdSave.Execute(False,False);
                Head.COMPL := True;
              except on E: Exception do
                Begin
// -nw                 SendError(E.Message);
                  if gc_User.Local then
                   begin
                    tiServise.BalloonHint:='������������� ���������� �����';
                    tiServise.ShowBalloonHint;
                   Exit;
                   end;
                End;
              end;
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
               // �������� ��������� ���������� ��� ���������� �������� ������� �� �����
               PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 1);
              end;

            finally
             //  DiffCDS.SaveToFile('diff.local'); // ��� ������������
              DiffCDS.free;
            end;
          finally
            freeAndNil(dsdSave);
          end;
           //������� ����������� ��� - ���� ����� ... 04.02.2017
          if Head.COMPL {AND (fError_isComplete = FALSE)} // 04.07.17 - !!!�������� �����!!!
          then Begin
            WaitForSingleObject(MutexDBF, INFINITE);
            FLocalDataBaseHead.Active:=True;
            FLocalDataBaseBody.Active:=True;
            try
              if FLocalDataBaseHead.Locate('UID',UID,[loPartialKey]) AND
                 not FLocalDataBaseHead.Deleted then
                FLocalDataBaseHead.DeleteRecord;
              FLocalDataBaseBody.First;
              while not FLocalDataBaseBody.eof do
              Begin
                IF (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = UID) AND
                    not FLocalDataBaseBody.Deleted then
                  FLocalDataBaseBody.DeleteRecord;
                FLocalDataBaseBody.Next;
              End;
              FLocalDataBaseHead.Pack;
              FLocalDataBaseBody.Pack;
            finally
             FLocalDataBaseHead.Active:=False;
             FLocalDataBaseBody.Active:=False;
             ReleaseMutex(MutexDBF);
            end;
          End;
        end
        //���� ��������� �� ����� � ���� ����� ... 04.02.2017
        ELSE
        if find and Head.SAVE {and (fError_isComplete = FALSE)} // 04.07.17 - !!!�������� �����!!!
        then BEGIN
          if (Head.MANAGER <> 0) or (Head.BAYER <> '') then
          Begin
            WaitForSingleObject(MutexRemains, INFINITE);
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
                   // �������� ��������� ���������� ��� ���������� �������� ������� �� �����
                   PostMessage(HWND_BROADCAST, FM_SERVISE, 1, 1);
                  end;
              except
                if gc_User.Local then
                 begin
                   tiServise.BalloonHint:='������������� ���������� �����';
                   tiServise.ShowBalloonHint;
                   Exit;
                 end;

              end;
            finally
              ReleaseMutex(MutexRemains);
            end;
               WaitForSingleObject(MutexRemains, INFINITE);
              SaveLocalData(MainCashForm2.RemainsCDS,Remains_lcl);
               ReleaseMutex(MutexRemains);
               WaitForSingleObject(MutexAlternative, INFINITE);
              SaveLocalData(MainCashForm2.AlternativeCDS,Alternative_lcl);
               ReleaseMutex(MutexAlternative);
              if FNeedSaveVIP then
               begin
                MainCashForm2.SaveLocalVIP;
               end;
            //
          end;
            WaitForSingleObject(MutexDBF, INFINITE);
            FLocalDataBaseHead.Active:=True;
            FLocalDataBaseBody.Active:=True;
          try
            if FLocalDataBaseHead.Locate('UID',UID,[loPartialKey]) AND
               not FLocalDataBaseHead.Deleted then
              FLocalDataBaseHead.DeleteRecord;
            FLocalDataBaseBody.First;
            while not FLocalDataBaseBody.eof do
            Begin
              IF (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = UID) AND
                  not FLocalDataBaseBody.Deleted then
                FLocalDataBaseBody.DeleteRecord;
              FLocalDataBaseBody.Next;
            End;
            FLocalDataBaseHead.Pack;
            FLocalDataBaseBody.Pack;
          finally
           FLocalDataBaseHead.Active:=False;
           FLocalDataBaseBody.Active:=False;
           ReleaseMutex(MutexDBF);
          end;
         End;
          WaitForSingleObject(MutexDBF, INFINITE);
          FLocalDataBaseHead.Active := True;
          FLocalDataBaseHead.First;
          FLocalDataBaseHead.Active := False;
          ReleaseMutex(MutexDBF);
        End;
      End;
  finally
    ReleaseMutex(MutexAllowedConduct);
    ReleaseMutex(MutexRefresh);
    MainCashForm2.tiServise.IconIndex:=0;
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
