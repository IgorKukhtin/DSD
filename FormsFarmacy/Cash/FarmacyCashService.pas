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
  Vcl.ImgList
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
    // ��� ������� �������� ������� ����� ��� ������� ���� �������
    USERSESION: string[50]; // ��������������� �����
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
    Label1: TLabel;
    ShapeState: TShape;
    spDelete_CashSession: TdsdStoredProc;
    spGet_BlinkCheck: TdsdStoredProc;
    spGet_BlinkVIP: TdsdStoredProc;
    CheckDS: TDataSource;
    CheckCDS: TClientDataSet;
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
    Timer2: TTimer;
    ActionList: TActionList;
    actChoiceGoodsInRemainsGrid: TAction;
    actOpenCheckVIP_Error: TOpenChoiceForm;
    actRefreshAll: TAction;
    actSold: TAction;
    actCheck: TdsdOpenForm;
    actInsertUpdateCheckItems: TAction;
    actRefresh: TdsdDataSetRefresh;
    actPutCheckToCash: TAction;
    actSetVIP: TAction;
    actDeferrent: TAction;
    actChoiceGoodsFromRemains: TOpenChoiceForm;
    actOpenCheckVIP: TOpenChoiceForm;
    actLoadVIP: TMultiAction;
    actUpdateRemains: TAction;
    actCalcTotalSumm: TAction;
    actCashWork: TAction;
    actClearAll: TAction;
    actClearMoney: TAction;
    actGetMoneyInCash: TAction;
    actSpec: TAction;
    actRefreshLite: TdsdDataSetRefresh;
    actShowMessage: TShowMessageAction;
    actOpenMCSForm: TdsdOpenForm;
    actOpenMCS_LiteForm: TdsdOpenForm;
    actSetFocus: TAction;
    actRefreshRemains: TAction;
    actExecuteLoadVIP: TAction;
    actSelectCheck: TdsdExecStoredProc;
    actSelectLocalVIPCheck: TAction;
    actCheckConnection: TAction;
    actSetDiscountExternal: TAction;
    actSetConfirmedKind_UnComplete: TAction;
    actSetConfirmedKind_Complete: TAction;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actRefreshAllExecute(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure actSetCashSessionIdExecute(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);

  private
    { Private declarations }

    procedure AppMsgHandler(var Msg: TMsg; var Handled: Boolean);
  public
    { Public declarations }


   ThreadErrorMessage:String;
   SoldParallel: Boolean;
   FiscalNumber: String;


      //�������� ������� �������� ��������� �������
    procedure UpdateRemainsFromDiff(ADiffCDS : TClientDataSet);

       // ��������� ��������� ��������� ��� �������� ������ ����
    procedure NewCheck(ANeedRemainsRefresh: Boolean = True);
    procedure SaveLocalVIP;
    procedure RemainsCDSAfterScroll(DataSet: TDataSet);
    procedure SaveRealAll;
    procedure ChangeStatus(AStatus: String);
    function InitLocalStorage: Boolean;

  end;


const
  CMD_SETLABELTEXT = 1;

var

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

    end;

end;



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
  WaitForSingleObject(MutexRefresh, INFINITE);
  try
      for J := 0 to 6 do
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
              USERSESION := trim(FieldByName('USERSESION').AsString);
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
                //***20.07.16
                dsdSave.Params.AddParam('inDiscountExternalId',ftInteger,ptInputOutput,Head.DISCOUNTID);
                dsdSave.Params.AddParam('inDiscountCardNumber',ftString,ptInput,Head.DISCOUNT);
                //***16.08.16
                dsdSave.Params.AddParam('inBayerPhone',       ftString,ptInput,Head.BAYERPHONE);
                dsdSave.Params.AddParam('inConfirmedKindName',ftString,ptInput,Head.CONFIRMED);
                dsdSave.Params.AddParam('inInvNumberOrder',   ftString,ptInput,Head.NUMORDER);
                //
                dsdSave.Params.AddParam('inUserSesion', ftString, ptInput, Head.USERSESION);
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
                dsdSave.Params.AddParam('inUserSesion', ftString, ptInput, Head.USERSESION);

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
              dsdSave.Params.AddParam('inUserSesion', ftString,ptInput, Head.USERSESION);
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
          Application.ProcessMessages;
          //������� ����������� ���
          if Head.COMPL then
          Begin
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
        //���� ��������� �� �����
         ELSE
         if find and Head.SAVE then
         BEGIN
          if (Head.MANAGER <> 0) or (Head.BAYER <> '') then
          Begin
            WaitForSingleObject(MutexRemains, INFINITE);
            try
              try
                MainCashForm2.spSelect_CashRemains_Diff.Execute(False, False, False);
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
            //�������� ��   Synchronize(UpdateRemains);
              MainCashForm2.UpdateRemainsFromDiff(DiffCDS);
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
      ReleaseMutex(MutexRefresh);
      MainCashForm2.tiServise.IconIndex:=0;
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
 Label1.Caption := AStatus;
 Label1.Repaint;
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


procedure TMainCashForm2.actRefreshAllExecute(Sender: TObject);
begin   //yes
  ChangeStatus('������ ���������� ������ � �������');
  try
    if RemainsCDS.IsEmpty then
    begin
      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        if not FileExists(Remains_lcl) or
           not FileExists(Alternative_lcl) then
        Begin
          ShowMessage('��� ���������� ���������. ���������� ������ ����������!');
          Close;
        End;
        WaitForSingleObject(MutexRemains, INFINITE);
        LoadLocalData(RemainsCDS, Remains_lcl);
        ReleaseMutex(MutexRemains);
        WaitForSingleObject(MutexAlternative, INFINITE);
        LoadLocalData(AlternativeCDS, Alternative_lcl);
        ReleaseMutex(MutexAlternative);
      finally
        RemainsCDS.EnableControls;
        AlternativeCDS.EnableControls;
      end;
    end;

    if true  then
    Begin

      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        ChangeStatus('��������� ��������');
        actRefresh.Execute;

        ChangeStatus('���������� �������� � ��������� ����');
        WaitForSingleObject(MutexRemains, INFINITE);
        SaveLocalData(RemainsCDS,Remains_lcl);
        ReleaseMutex(MutexRemains);
        WaitForSingleObject(MutexAlternative, INFINITE);
        SaveLocalData(AlternativeCDS,Alternative_lcl);
        ReleaseMutex(MutexAlternative);

        ChangeStatus('��������� ��� �����');

        SaveLocalVIP;
        ChangeStatus('���������� ��� ����� � ��������� ����');
      finally
        ChangeStatus('������������ ������ � ���� ���������');
        RemainsCDS.EnableControls;
        AlternativeCDS.EnableControls;

      end;
    End;
  finally
    ChangeStatus(' ��������� ');
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
  ShapeState.Brush.Color := clGreen;
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
 //r SetWorkMode(gc_User.Local);
  SoldParallel:=iniSoldParallel;
  ChangeStatus('������');
end;

// ��������� ��������� ��������� ��� �������� ������ ����
procedure TMainCashForm2.N1Click(Sender: TObject);
begin
actRefreshAllExecute(nil);
end;

procedure TMainCashForm2.N2Click(Sender: TObject);
begin
Timer2.Enabled := not Timer2.Enabled;
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
end;

procedure TMainCashForm2.NewCheck(ANeedRemainsRefresh: Boolean = True);
begin
  FormParams.ParamByName('CheckId').Value := 0;
  FormParams.ParamByName('ManagerId').Value := 0;
  FormParams.ParamByName('ManagerName').Value := '';
  FormParams.ParamByName('BayerName').Value := '';
  //***20.07.16
  FormParams.ParamByName('DiscountExternalId').Value := 0;
  FormParams.ParamByName('DiscountExternalName').Value := '';
  FormParams.ParamByName('DiscountCardNumber').Value := '';
  //***16.08.16
  FormParams.ParamByName('BayerPhone').Value        := '';
  FormParams.ParamByName('ConfirmedKindName').Value := '';
  FormParams.ParamByName('InvNumberOrder').Value    := '';
  FormParams.ParamByName('ConfirmedKindClientName').Value := '';

  FiscalNumber := '';
  CheckCDS.DisableControls;
  try
    CheckCDS.EmptyDataSet;
  finally
    CheckCDS.EnableControls;
  end;

end;

function TMainCashForm2.InitLocalStorage: Boolean;
var fields11, fields12, fields13, fields14, fields15, fields16, fields17, fields18: TVKDBFFieldDefs;
    fields21, fields22, fields23, fields24, fields25: TVKDBFFieldDefs;
  procedure InitTable(DS: TVKSmartDBF; AFileName: String);
  Begin
    DS.DBFFileName := AnsiString(AFileName);
    DS.OEM := False;
    DS.AccessMode.OpenReadWrite := true;
  End;
begin
  result := False;
  WaitForSingleObject(MutexDBF, INFINITE);
  WaitForSingleObject(MutexDBFDiff, INFINITE);
  InitTable(FLocalDataBaseHead, iniLocalDataBaseHead);
  InitTable(FLocalDataBaseBody, iniLocalDataBaseBody);
  InitTable(FLocalDataBaseDiff, iniLocalDataBaseDiff);
   if (not FileExists(iniLocalDataBaseDiff)) then
  begin
    AddIntField(FLocalDataBaseDiff,'ID'); //id ������
    AddIntField(FLocalDataBaseDiff,'GOODSCODE'); //��� ������
    AddStrField(FLocalDataBaseDiff,'GOODSNAME',254); //������������ ������
    AddFloatField(FLocalDataBaseDiff,'PRICE'); //����
    AddFloatField(FLocalDataBaseDiff,'REMAINS'); // �������
    AddFloatField(FLocalDataBaseDiff,'MCSVALUE'); //
    AddFloatField(FLocalDataBaseDiff,'RESERVED'); //
    AddBoolField(FLocalDataBaseDiff,'NEWROW'); //

    try
      FLocalDataBaseDiff.CreateTable;
    except ON E: Exception do
      Begin
        Application.OnException(Application.MainForm,E);
//        ShowMessage('������ �������� ���������� ���������: '+E.Message);
        Exit;
      End;
    end;
  end;

  if (not FileExists(iniLocalDataBaseHead)) then
  begin
    AddIntField(FLocalDataBaseHead,'ID');//id ����
    AddStrField(FLocalDataBaseHead,'UID',50);//uid ����
    AddDateField(FLocalDataBaseHead,'DATE'); //����/����� ����
    AddIntField(FLocalDataBaseHead,'PAIDTYPE'); //��� ������
    AddStrField(FLocalDataBaseHead,'CASH',20); //�������� ��������
    AddIntField(FLocalDataBaseHead,'MANAGER'); //Id ��������� (VIP)
    AddStrField(FLocalDataBaseHead,'BAYER',254); //���������� (VIP)
    AddBoolField(FLocalDataBaseHead,'SAVE'); //���������� (VIP)
    AddBoolField(FLocalDataBaseHead,'COMPL'); //���������� (VIP)
    AddBoolField(FLocalDataBaseHead,'NEEDCOMPL'); //����� �������� ��������
    AddBoolField(FLocalDataBaseHead,'NOTMCS'); //�� ��������� � ������� ���
    AddStrField(FLocalDataBaseHead,'FISCID',50); //����� ����������� ����
    //***20.07.16
    AddIntField(FLocalDataBaseHead,'DISCOUNTID');    //Id ������� ���������� ����
    AddStrField(FLocalDataBaseHead,'DISCOUNTN',254); //�������� ������� ���������� ����
    AddStrField(FLocalDataBaseHead,'DISCOUNT',50);   //� ���������� �����
    //***16.08.16
    AddStrField(FLocalDataBaseHead,'BAYERPHONE',50); //���������� ������� (����������) - BayerPhone
    AddStrField(FLocalDataBaseHead,'CONFIRMED',50);  //������ ������ (��������� VIP-����) - ConfirmedKind
    AddStrField(FLocalDataBaseHead,'NUMORDER',50);   //����� ������ (� �����) - InvNumberOrder
    AddStrField(FLocalDataBaseHead,'CONFIRMEDC',50); //������ ������ (��������� VIP-����) - ConfirmedKindClient

      // ��� ������� �������� ������� ����� ��� ������� ���� ������� // ����� ��������������� �����
    AddStrField(FLocalDataBaseHead,'USERSESION',50);
    try
      FLocalDataBaseHead.CreateTable;
    except ON E: Exception do
      Begin
        Application.OnException(Application.MainForm,E);
//        ShowMessage('������ �������� ���������� ���������: '+E.Message);
        Exit;
      End;
    end;
     FLocalDataBaseHead.Close;
  end
  // !!!��������� ����� ����
  else begin
          FLocalDataBaseHead.Open;

          //
          if FLocalDataBaseHead.FindField('DISCOUNTID') = nil then
          begin
               fields11:=TVKDBFFieldDefs.Create(self);
               with fields11.Add as TVKDBFFieldDef do
               begin
                    Name := 'DISCOUNTID';
                    field_type := 'N';
                    len := 10;
               end;
               FLocalDataBaseHead.AddFields(fields11,1000);
           end;
          //
          if FLocalDataBaseHead.FindField('DISCOUNTN') = nil then
          begin
               fields12:=TVKDBFFieldDefs.Create(self);
               with fields12.Add as TVKDBFFieldDef do
               begin
                    Name := 'DISCOUNTN';
                    field_type := 'C';
                    len := 254;
               end;
               FLocalDataBaseHead.AddFields(fields12,1000);
           end;
          //
          if FLocalDataBaseHead.FindField('DISCOUNT') = nil then
          begin
               fields13:=TVKDBFFieldDefs.Create(self);
               with fields13.Add as TVKDBFFieldDef do
               begin
                    Name := 'DISCOUNT';
                    field_type := 'C';
                    len := 50;
               end;
               FLocalDataBaseHead.AddFields(fields13,1000);
           end;
          //***16.08.16
          if FLocalDataBaseHead.FindField('BAYERPHONE') = nil then
          begin
               fields14:=TVKDBFFieldDefs.Create(self);
               with fields14.Add as TVKDBFFieldDef do
               begin
                    Name := 'BAYERPHONE';
                    field_type := 'C';
                    len := 50;
               end;
               FLocalDataBaseHead.AddFields(fields14,1000);
           end;
          //***16.08.16
          if FLocalDataBaseHead.FindField('CONFIRMED') = nil then
          begin
               fields15:=TVKDBFFieldDefs.Create(self);
               with fields15.Add as TVKDBFFieldDef do
               begin
                    Name := 'CONFIRMED';
                    field_type := 'C';
                    len := 50;
               end;
               FLocalDataBaseHead.AddFields(fields15,1000);
           end;
          //***16.08.16
          if FLocalDataBaseHead.FindField('NUMORDER') = nil then
          begin
               fields16:=TVKDBFFieldDefs.Create(self);
               with fields16.Add as TVKDBFFieldDef do
               begin
                    Name := 'NUMORDER';
                    field_type := 'C';
                    len := 50;
               end;
               FLocalDataBaseHead.AddFields(fields16,1000);
           end;
          //***25.08.16
          if FLocalDataBaseHead.FindField('CONFIRMEDC') = nil then
          begin
               fields17:=TVKDBFFieldDefs.Create(self);
               with fields17.Add as TVKDBFFieldDef do
               begin
                    Name := 'CONFIRMEDC';
                    field_type := 'C';
                    len := 50;
               end;
               FLocalDataBaseHead.AddFields(fields17,1000);
           end;
           //
              if FLocalDataBaseHead.FindField('USERSESION') = nil then
          begin
               fields18:=TVKDBFFieldDefs.Create(self);
               with fields18.Add as TVKDBFFieldDef do
               begin
                    Name := 'USERSESION';
                    field_type := 'C';
                    len := 50;
               end;
               FLocalDataBaseHead.AddFields(fields18,1000);
           end;


           FLocalDataBaseHead.Close;
  end;// !!!��������� ����� ����


  if (not FileExists(iniLocalDataBaseBody)) then
  begin
    AddIntField(FLocalDataBaseBody,'ID'); //id ������
    AddStrField(FLocalDataBaseBody,'CH_UID',50); //uid ����
    AddIntField(FLocalDataBaseBody,'GOODSID'); //�� ������
    AddIntField(FLocalDataBaseBody,'GOODSCODE'); //��� ������
    AddStrField(FLocalDataBaseBody,'GOODSNAME',254); //������������ ������
    AddFloatField(FLocalDataBaseBody,'NDS'); //��� ������
    AddFloatField(FLocalDataBaseBody,'AMOUNT'); //���-��
    AddFloatField(FLocalDataBaseBody,'PRICE'); //����, � 20.07.16 ���� ���� ������ �� ������� ��������, ����� ����� ���� � ������ ������
    //***20.07.16
    AddFloatField(FLocalDataBaseBody,'PRICESALE'); //���� ��� ������
    AddFloatField(FLocalDataBaseBody,'CHPERCENT'); //% ������
    AddFloatField(FLocalDataBaseBody,'SUMMCH');    //����� ������
    //***19.08.16
    AddFloatField(FLocalDataBaseBody,'AMOUNTORD'); //���-�� ������
    //***10.08.16
    AddStrField(FLocalDataBaseBody,'LIST_UID',50); //UID ������ �������
    try
      FLocalDataBaseBody.CreateTable;
    except ON E: Exception do
      Begin
        Application.OnException(Application.MainForm,E);
//        ShowMessage('������ �������� ���������� ���������: '+E.Message);
        Exit;
      End;
    end;
  end
  // !!!��������� ����� ����
  else begin
          FLocalDataBaseBody.Open;
          //
          if FLocalDataBaseBody.FindField('PRICESALE') = nil then
          begin
               fields21:=TVKDBFFieldDefs.Create(self);
               with fields21.Add as TVKDBFFieldDef do
               begin
                    Name := 'PRICESALE';
                    field_type := 'N';
                    len := 10;
                    dec := 4;
               end;
               FLocalDataBaseBody.AddFields(fields21,1000);
           end;
          //
          if FLocalDataBaseBody.FindField('CHPERCENT') = nil then
          begin
               fields22:=TVKDBFFieldDefs.Create(self);
               with fields22.Add as TVKDBFFieldDef do
               begin
                    Name := 'CHPERCENT';
                    field_type := 'N';
                    len := 10;
                    dec := 4;
               end;
               FLocalDataBaseBody.AddFields(fields22,1000);
           end;
          //
          if FLocalDataBaseBody.FindField('SUMMCH') = nil then
          begin
               fields23:=TVKDBFFieldDefs.Create(self);
               with fields23.Add as TVKDBFFieldDef do
               begin
                    Name := 'SUMMCH';
                    field_type := 'N';
                    len := 10;
                    dec := 4;
               end;
               FLocalDataBaseBody.AddFields(fields23,1000);
          end;
          //***19.08.16
          if FLocalDataBaseBody.FindField('AMOUNTORD') = nil then
          begin
               fields24:=TVKDBFFieldDefs.Create(self);
               with fields24.Add as TVKDBFFieldDef do
               begin
                    Name := 'AMOUNTORD';
                    field_type := 'N';
                    len := 10;
                    dec := 4;
               end;
               FLocalDataBaseBody.AddFields(fields24,1000);
          end;
          //***10.08.16
          if FLocalDataBaseBody.FindField('LIST_UID') = nil then
          begin
               fields25:=TVKDBFFieldDefs.Create(self);
               with fields25.Add as TVKDBFFieldDef do
               begin
                    Name := 'LIST_UID';
                    field_type := 'C';
                    len := 50;
               end;
               FLocalDataBaseBody.AddFields(fields25,1000);
          end;
          //
          FLocalDataBaseBody.Close;
  end; // !!!��������� ����� ����

  try
    FLocalDataBaseHead.Open;
    FLocalDataBaseBody.Open;
    FLocalDataBaseDiff.Open;
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
     (FLocalDataBaseHead.FindField('FISCID') = nil) or
      //***20.07.16
     (FLocalDataBaseHead.FindField('DISCOUNTID') = nil) or
     (FLocalDataBaseHead.FindField('DISCOUNTN') = nil) or
     (FLocalDataBaseHead.FindField('DISCOUNT') = nil) or
      //***16.08.16
     (FLocalDataBaseHead.FindField('BAYERPHONE') = nil) or
     (FLocalDataBaseHead.FindField('CONFIRMED') = nil) or
     (FLocalDataBaseHead.FindField('NUMORDER') = nil) or
     (FLocalDataBaseHead.FindField('CONFIRMEDC') = nil) or
     (FLocalDataBaseHead.FindField('USERSESION') = nil)

  then begin
    ShowMessage('�������� ��������� ����� ���������� ��������� ('+FLocalDataBaseHead.DBFFileName+')');
    Exit;
  End;

  if (FLocalDataBaseBody.FindField('ID') = nil) or
     (FLocalDataBaseBody.FindField('CH_UID') = nil) or
     (FLocalDataBaseBody.FindField('GOODSID') = nil) or
     (FLocalDataBaseBody.FindField('GOODSCODE') = nil) or
     (FLocalDataBaseBody.FindField('GOODSNAME') = nil) or
     (FLocalDataBaseBody.FindField('NDS') = nil) or
     (FLocalDataBaseBody.FindField('AMOUNT') = nil) or
     (FLocalDataBaseBody.FindField('PRICE') = nil) or
      //***20.07.16
     (FLocalDataBaseBody.FindField('PRICESALE') = nil) or
     (FLocalDataBaseBody.FindField('CHPERCENT') = nil) or
     (FLocalDataBaseBody.FindField('SUMMCH') = nil) or
      //***19.08.16
     (FLocalDataBaseBody.FindField('AMOUNTORD') = nil) or
      //***10.08.16
     (FLocalDataBaseBody.FindField('LIST_UID') = nil)
  then begin
    ShowMessage('�������� ��������� ����� ���������� ��������� ('+FLocalDataBaseBody.DBFFileName+')');
    Exit;
  End;

  LocalDataBaseisBusy := 0;
  Result := FLocalDataBaseHead.Active AND FLocalDataBaseBody.Active and FLocalDataBaseDiff.Active;

  if Result then
  begin
   FLocalDataBaseHead.Active:=False;
   FLocalDataBaseBody.Active:=False;
   FLocalDataBaseDiff.Active:=False;
  end;
  ReleaseMutex(MutexDBF);
  ReleaseMutex(MutexDBFDiff);
end;

procedure TMainCashForm2.FormDestroy(Sender: TObject);
begin
 CloseHandle(MutexDBF);
 CloseHandle(MutexDBFDiff);
 CloseHandle(MutexVip);
 CloseHandle(MutexRemains);
 CloseHandle(MutexAlternative);
 CloseHandle(MutexRefresh);
end;

procedure TMainCashForm2.UpdateRemainsFromDiff(ADiffCDS : TClientDataSet);
var
  GoodsId: Integer;
  Amount_find: Currency;
  oldFilter:String;
  oldFiltered:Boolean;
begin

  //���� ��� ����������� - ������ �� ������
  if ADiffCDS = nil then
    ADiffCDS := DiffCDS;
  if ADIffCDS.IsEmpty then
    exit;
  //��������� �������
  if not RemainsCDS.Active then
    exit;

  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  if RemainsCDS.RecordCount>0 then
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.Filtered := False;
  ADIffCDS.DisableControls;
  CheckCDS.DisableControls;
  oldFilter:= CheckCDS.Filter;
  oldFiltered:= CheckCDS.Filtered;

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
          {12.10.2016 - ������ �� �������, �.�. � CheckCDS ������ ����� ����������� GoodsId
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;}
          RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency;

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
          {12.10.2016 - ������ �� �������, �.�. � CheckCDS ������ ����� ����������� GoodsId
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;}
          AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency;

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
  end;

end;

procedure TMainCashForm2.SaveLocalVIP;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin  
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
      SaveLocalData(ds,Member_lcl);

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
 Timer2.Enabled:=False;
 try
  WaitForSingleObject(MutexRefresh, INFINITE);
  actRefreshAllExecute(nil);
 finally
  ReleaseMutex(MutexRefresh);
  Timer2.Enabled:=True;
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
