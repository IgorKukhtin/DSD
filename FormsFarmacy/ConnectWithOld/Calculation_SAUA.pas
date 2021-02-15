unit Calculation_SAUA;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxBarPainter,
  Vcl.StdCtrls, Vcl.CheckLst, dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar,
  cxClasses, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, Data.DB,
  cxDBData, cxCurrencyEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGridCustomView,
  cxGridDBTableView, cxGrid, dsdDB, Datasnap.DBClient, cxCheckBox;

type
  TCalculation_SAUAForm = class(TForm)
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbToExcel: TdxBarButton;
    bbStaticText: TdxBarButton;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bb: TdxBarControlContainerItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    PeriodChoice: TPeriodChoice;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    CheckListBoxRecipient: TCheckListBox;
    CheckListBoxAssortment: TCheckListBox;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    UnitName: TcxGridDBBandedColumn;
    GoodsCode: TcxGridDBBandedColumn;
    GoodsName: TcxGridDBBandedColumn;
    Remains: TcxGridDBBandedColumn;
    Need: TcxGridDBBandedColumn;
    Assortment: TcxGridDBBandedColumn;
    AmountCheck: TcxGridDBBandedColumn;
    CountUnit: TcxGridDBBandedColumn;
    cxGridLevel: TcxGridLevel;
    GetUnitsList: TdsdStoredProc;
    UnitsCDS: TClientDataSet;
    ceThreshold: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    actCalculation: TAction;
    dsResult: TDataSource;
    cdsResult: TClientDataSet;
    spCalculation: TdsdStoredProc;
    actGridToExcel: TdsdGridToExcel;
    ceDaysStock: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    ceCountPharmacies: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cbGoodsClose: TcxCheckBox;
    cbMCSIsClose: TcxCheckBox;
    cbNotCheckNoMCS: TcxCheckBox;
    ceResolutionParameter: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    actScheduleNearestSUN1: TMultiAction;
    actExecactScheduleNearestSUN1: TdsdExecStoredProc;
    bbScheduleNearestSUN1: TdxBarButton;
    dxBarButton6: TdxBarButton;
    spScheduleNearestSUN1: TdsdStoredProc;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    procedure ParentFormCreate(Sender: TObject);
    procedure ParentFormClose(Sender: TObject; var Action: TCloseAction);
    procedure actCalculationExecute(Sender: TObject);
    procedure CheckListBoxRecipientClickCheck(Sender: TObject);
    procedure CheckListBoxAssortmentClickCheck(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TCalculation_SAUAForm.actCalculationExecute(Sender: TObject);
  var i, j : integer; cRecipient, cAssortment : string;
begin

   cRecipient := ''; cAssortment := '';  j := 0;
   for i := 0 to CheckListBoxRecipient.Items.Count - 1 do
    Begin
      Application.ProcessMessages;
      if CheckListBoxRecipient.Checked[i] then
      begin
        if cRecipient <> '' then cRecipient := cRecipient + ',';
        cRecipient := cRecipient + IntToStr(Integer(CheckListBoxRecipient.Items.Objects[I]));
      end;
    End;

   for i := 0 to CheckListBoxAssortment.Items.Count - 1 do
    Begin
      Application.ProcessMessages;
      if CheckListBoxAssortment.Checked[i] then
      begin
        if cAssortment <> '' then cAssortment := cAssortment + ',';
        cAssortment := cAssortment + IntToStr(Integer(CheckListBoxAssortment.Items.Objects[I]));
        Inc(J);
      end;
    End;

   if cRecipient = '' then
   begin
     ShowMessage('Не выбраны Аптеки получатели.');
     Exit;
   end;

   if ceCountPharmacies.Value <= 1 then
   begin
     ShowMessage('Не указано "Минимальное количество аптек ассортимента из выбранных"');
     ceCountPharmacies.SetFocus;
     Exit;
   end;

   if j < ceCountPharmacies.Value then
   begin
     ShowMessage('Аптек ассортимента должно быть более или равно ' + ceCountPharmacies.Text);
     Exit;
   end;

   spCalculation.ParamByName('inRecipientList').Value := cRecipient;
   spCalculation.ParamByName('inAssortmentList').Value := cAssortment;
   spCalculation.Execute;
end;

procedure TCalculation_SAUAForm.CheckListBoxAssortmentClickCheck(
  Sender: TObject);
var i, nCount : integer;
begin
   nCount := 0;
  for i := 0 to CheckListBoxAssortment.Items.Count - 1 do
    if CheckListBoxAssortment.Checked[i] then Inc(nCount);

  cxLabel10.Caption := 'Выбрано ' + IntToStr(nCount);
end;

procedure TCalculation_SAUAForm.CheckListBoxRecipientClickCheck(
  Sender: TObject);
var i, nCount : integer;
begin
   nCount := 0;
  for i := 0 to CheckListBoxRecipient.Items.Count - 1 do
    if CheckListBoxRecipient.Checked[i] then Inc(nCount);

  cxLabel9.Caption := 'Выбрано ' + IntToStr(nCount);
end;

procedure TCalculation_SAUAForm.ParentFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  UserSettingsStorageAddOn.SaveUserSettings;
  Action:=caFree;
end;

procedure TCalculation_SAUAForm.ParentFormCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;

  GetUnitsList.Execute;
  UnitsCDS.First;
  while not UnitsCDS.Eof do
  begin
    CheckListBoxRecipient.Items.AddObject(UnitsCDS.FieldByName('UnitName').asString,TObject(UnitsCDS.FieldByName('Id').AsInteger));
    if UnitsCDS.FieldByName('UnitCalculationId').AsInteger <> 0 then
      CheckListBoxAssortment.Items.AddObject(UnitsCDS.FieldByName('UnitName').asString,TObject(UnitsCDS.FieldByName('Id').AsInteger));
    UnitsCDS.Next;
  end;

end;

initialization
  RegisterClass(TCalculation_SAUAForm);
end.
