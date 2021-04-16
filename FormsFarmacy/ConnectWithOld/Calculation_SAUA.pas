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
    GetUnitsRecipientList: TdsdStoredProc;
    UnitsRecipientCDS: TClientDataSet;
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
    actScheduleNearestSUN1: TMultiAction;
    actExecactScheduleNearestSUN1: TdsdExecStoredProc;
    bbScheduleNearestSUN1: TdxBarButton;
    dxBarButton6: TdxBarButton;
    spScheduleNearestSUN1: TdsdStoredProc;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    FormParams: TdsdFormParams;
    spInsert_FinalSUAProtocol: TdsdStoredProc;
    actInsert_FinalSUAProtocol: TdsdExecStoredProc;
    actFinalSUAProtocol: TdsdOpenForm;
    bbFinalSUAProtocol: TdxBarButton;
    cbNeedRound: TcxCheckBox;
    cbAssortmentRound: TcxCheckBox;
    ceThresholdMCS: TcxCurrencyEdit;
    ceThresholdRemains: TcxCurrencyEdit;
    FieldFilterRecipient: TdsdFieldFilter;
    FieldFilterAssortment: TdsdFieldFilter;
    cbMCSValue: TcxCheckBox;
    cbRemains: TcxCheckBox;
    ceThresholdRemainsLarge: TcxCurrencyEdit;
    ceThresholdMCSLarge: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cxLabel11: TcxLabel;
    UnitAssortmentCDS: TClientDataSet;
    GetUnitsAssortmentList: TdsdStoredProc;
    cxTextEdit1: TcxTextEdit;
    cxGridRecipient: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    risChecked: TcxGridDBColumn;
    rUnitName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxTextEdit2: TcxTextEdit;
    cxGridAssortment: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    aisChecked: TcxGridDBColumn;
    aUnitName: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    UnitsRecipientDS: TDataSource;
    UnitAssortmentDS: TDataSource;
    procedure ParentFormCreate(Sender: TObject);
    procedure ParentFormClose(Sender: TObject; var Action: TCloseAction);
    procedure actCalculationExecute(Sender: TObject);
    procedure UnitsRecipientCDSAfterPost(DataSet: TDataSet);
    procedure UnitAssortmentCDSAfterPost(DataSet: TDataSet);
    procedure risCheckedPropertiesEditValueChanged(Sender: TObject);
    procedure aisCheckedPropertiesEditValueChanged(Sender: TObject);
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
   try
     UnitsRecipientCDS.DisableControls;
     i := UnitsRecipientCDS.RecNo;
     UnitsRecipientCDS.First;
     while not UnitsRecipientCDS.Eof do
      Begin
        Application.ProcessMessages;
        if UnitsRecipientCDS.FieldByName('isChecked').AsBoolean then
        begin
          if cRecipient <> '' then cRecipient := cRecipient + ',';
          cRecipient := cRecipient + UnitsRecipientCDS.FieldByName('Id').AsString;
        end;
        UnitsRecipientCDS.Next;
      End;
   finally
     UnitsRecipientCDS.RecNo := i;
     UnitsRecipientCDS.EnableControls;
   end;

   try
     UnitAssortmentCDS.DisableControls;
     i := UnitAssortmentCDS.RecNo;
     UnitAssortmentCDS.First;
     while not UnitAssortmentCDS.Eof do
      Begin
        Application.ProcessMessages;
        if UnitAssortmentCDS.FieldByName('isChecked').AsBoolean then
        begin
          if cAssortment <> '' then cAssortment := cAssortment + ',';
          cAssortment := cAssortment + UnitAssortmentCDS.FieldByName('Id').AsString;
          Inc(J);
        end;
        UnitAssortmentCDS.Next;
      End;
   finally
     UnitAssortmentCDS.RecNo := i;
     UnitAssortmentCDS.EnableControls;
   end;

   if cRecipient = '' then
   begin
     ShowMessage('Не выбраны Аптеки получатели.');
     Exit;
   end;

   if ceCountPharmacies.Value < 1 then
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

   FormParams.ParamByName('RecipientList').Value := cRecipient;
   FormParams.ParamByName('AssortmentList').Value := cAssortment;
   spCalculation.Execute;
end;

procedure TCalculation_SAUAForm.aisCheckedPropertiesEditValueChanged(
  Sender: TObject);
begin
  UnitAssortmentCDS.Post;
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

  GetUnitsRecipientList.Execute;
  GetUnitsAssortmentList.Execute;

end;

procedure TCalculation_SAUAForm.risCheckedPropertiesEditValueChanged(
  Sender: TObject);
begin
  UnitsRecipientCDS.Post;
end;

procedure TCalculation_SAUAForm.UnitAssortmentCDSAfterPost(DataSet: TDataSet);
var nCount, i : integer;
begin
  nCount := 0;

  try
    DataSet.DisableControls;
    i := UnitsRecipientCDS.RecNo;
    DataSet.First;
    while not DataSet.Eof do
    begin
      if DataSet['isChecked'] then  Inc(nCount);
      DataSet.Next;
    end;
  finally
     DataSet.RecNo := i;
     DataSet.EnableControls;
  end;

  cxLabel10.Caption := 'Выбрано ' + IntToStr(nCount);
end;

procedure TCalculation_SAUAForm.UnitsRecipientCDSAfterPost(DataSet: TDataSet);
var nCount, i : integer;
begin
  nCount := 0;

  try
    DataSet.DisableControls;
    i := UnitsRecipientCDS.RecNo;
    DataSet.First;
    while not DataSet.Eof do
    begin
      if DataSet['isChecked'] then  Inc(nCount);
      DataSet.Next;
    end;
  finally
     DataSet.RecNo := i;
     DataSet.EnableControls;
  end;

  cxLabel9.Caption := 'Выбрано ' + IntToStr(nCount);
end;

initialization
  RegisterClass(TCalculation_SAUAForm);
end.
