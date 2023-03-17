unit CheckHelsiSign;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  Vcl.ComCtrls, cxCheckBox, cxBlobEdit, dxSkinsdxBarPainter, dxBarExtItems,
  dxBar, dxCore, cxDateUtils, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxDropDownEdit,
  cxGridBandedTableView, cxGridDBBandedTableView, cxLabel, cxCalendar,
  System.Actions, dxDateRanges;

type
  TCheckHelsiSignForm = class(TAncestorBaseForm)
    BarManager: TdxBarManager;
    Bar: TdxBar;
    bbRefresh: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbGridToExcel: TdxBarButton;
    bbOpen: TdxBarButton;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxCheckHelsiSignGrid: TcxGrid;
    cxCheckHelsiSignGridDBBandedTableView1: TcxGridDBBandedTableView;
    colInvNumber: TcxGridDBBandedColumn;
    colGoodsCode: TcxGridDBBandedColumn;
    colGoodsName: TcxGridDBBandedColumn;
    colTotalSumm: TcxGridDBBandedColumn;
    colAmount: TcxGridDBBandedColumn;
    colPrice: TcxGridDBBandedColumn;
    colSumm: TcxGridDBBandedColumn;
    colBonusAmountTab: TcxGridDBBandedColumn;
    colColor_calc: TcxGridDBBandedColumn;
    cxCheckHelsiSignGridLevel1: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    ExecuteDialog: TExecuteDialog;
    dxBarButton1: TdxBarButton;
    dsdStoredProc: TdsdStoredProc;
    actOpen: TMultiAction;
    colInvNumberSP: TcxGridDBBandedColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actLoadState: TAction;
    dxBarButton2: TdxBarButton;
    actLoadStateCurr: TAction;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    actSign: TAction;
    colOrd: TcxGridDBBandedColumn;
    dxBarButton5: TdxBarButton;
    actGridToExcel: TdsdGridToExcel;
    spGet_MedicalProgram: TdsdStoredProc;
    procedure ParentFormCreate(Sender: TObject);
    procedure ParentFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actLoadStateExecute(Sender: TObject);
    procedure actLoadStateCurrExecute(Sender: TObject);
    procedure actSignExecute(Sender: TObject);
  private
    { Private declarations }
    FIniError : Boolean;
  public
  end;

implementation

{$R *.dfm}

uses Helsi, MainCash2, Math;



procedure TCheckHelsiSignForm.actLoadStateCurrExecute(Sender: TObject);
  var cState, cMedicalProgramId, cProgramIdSP : string; nColor : Integer;
begin
  if ClientDataSet.IsEmpty then Exit;

  if not FIniError then
  begin
    if GetHelsiReceiptState(ClientDataSet.FieldByName('InvNumberSP').AsString, cState, cMedicalProgramId, FIniError) then
    else if not FIniError and GetHelsiReceiptState(ClientDataSet.FieldByName('InvNumberSP').AsString, cState, cMedicalProgramId, FIniError) then
    else cState := 'Ош. получения';
  end else cState := 'Ош. получения';
  nColor := clYellow;

  if cState = 'ACTIVE' then
  begin
    cState := 'Не погашен';
    nColor := $00DFBFFF;
  end else if cState = 'EXPIRED' then
  begin
    cState := 'Просрочен';
    nColor := $00DFBFFF;
  end else if cState = 'COMPLETED' then
  begin
    cState := 'Погашен';
    nColor := clWindow;
  end else if cState <> 'Ош. получения' then
  begin
    cState := 'Неизв. статус';
  end;

  cProgramIdSP := ClientDataSet.FieldByName('ProgramIdSP').AsString;
  if ClientDataSet.FieldByName('MedicalProgramId').AsString <> cMedicalProgramId then
  begin
    try
      spGet_MedicalProgram.ParamByName('inGoodsId').Value := ClientDataSet.FieldByName('GoodsId').AsInteger;
      spGet_MedicalProgram.ParamByName('inMedicalProgramId').Value := cMedicalProgramId;
      spGet_MedicalProgram.ParamByName('outProgramIdSP').Value := '';
      spGet_MedicalProgram.Execute;
      cProgramIdSP := spGet_MedicalProgram.ParamByName('outProgramIdSP').Value;
    except
    end;
  end;

  ClientDataSet.Edit;
  ClientDataSet.FieldByName('MedicalProgramId').AsString := cMedicalProgramId;
  ClientDataSet.FieldByName('ProgramIdSP').AsString := cProgramIdSP;
  ClientDataSet.FieldByName('State').AsString := cState;
  ClientDataSet.FieldByName('Color_calc').AsInteger := nColor;
  ClientDataSet.Post;
end;

procedure TCheckHelsiSignForm.actLoadStateExecute(Sender: TObject);
  var cState : string;
begin
  try
    ClientDataSet.DisableControls;
    ClientDataSet.First;
    while not ClientDataSet.Eof do
    begin
      actLoadStateCurrExecute(Sender);
      ClientDataSet.Next;
    end;
  finally
    ClientDataSet.First;
    ClientDataSet.EnableControls;
  end;

end;

procedure TCheckHelsiSignForm.actSignExecute(Sender: TObject);
  var HelsiError : boolean; OperDateSP : TDateTime;
      HelsiID, HelsiIDList, HelsiName, HelsiDenUnit, ConfirmationCode, ProgramId, ProgramName :
      string; HelsiQty : currency; PartialPrescription, SkipDispenseSign : Boolean;
begin
  HelsiError := True;
  try

    if not GetHelsiReceipt(ClientDataSet.FieldByName('InvNumberSP').AsString, HelsiID, HelsiIDList, HelsiName, HelsiDenUnit, HelsiQty, OperDateSP, ProgramId, ProgramName, PartialPrescription, SkipDispenseSign) then
    begin
      Exit;
    end;

    ConfirmationCode := ClientDataSet.FieldByName('ConfirmationCodeSP').AsString;
    if ConfirmationCode = '' then
      if not InputQuery('Введите код подтверждения рецепта', 'Код подтверждения: ', ConfirmationCode) then Exit;


    if not CreateNewDispense(ClientDataSet.FieldByName('IdSP').AsString,
                             ClientDataSet.FieldByName('ProgramIdSP').AsString,
                             ClientDataSet.FieldByName('CountSP').AsCurrency * ClientDataSet.FieldByName('Amount').AsCurrency,
                             ClientDataSet.FieldByName('PriceSale').asCurrency,
                             RoundTo(ClientDataSet.FieldByName('Amount').asCurrency * ClientDataSet.FieldByName('PriceSale').asCurrency, -2),
                             RoundTo(ClientDataSet.FieldByName('Amount').asCurrency * ClientDataSet.FieldByName('PriceRetSP').asCurrency, -2) -
                               RoundTo(ClientDataSet.FieldByName('Amount').asCurrency * ClientDataSet.FieldByName('PaymentSP').asCurrency, -2),
                             ClientDataSet.FieldByName('TotalSumm').asCurrency, ConfirmationCode) then
    begin
      Exit;
    end;

    HelsiError := not SetPayment(ClientDataSet.FieldByName('FiscalCheckNumber').AsString, ClientDataSet.FieldByName('TotalSumm').asCurrency);
    if not HelsiError then HelsiError := not IntegrationClientSign;
    if not HelsiError then HelsiError := not ProcessSignedDispense;

    if HelsiError then RejectDispense;
  finally
    actLoadStateCurrExecute(Sender);
  end;
end;

procedure TCheckHelsiSignForm.ParentFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  UserSettingsStorageAddOn.SaveUserSettings;
end;

procedure TCheckHelsiSignForm.ParentFormCreate(Sender: TObject);
begin
  FormClassName := Self.ClassName;
  UserSettingsStorageAddOn.LoadUserSettings;
  deStart.Date := Date;
  FIniError := False;
  actOpen.Execute;
end;

End.
