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
  cxGridDBTableView, cxGrid, dsdDB, Datasnap.DBClient;

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
    actExportExel: TAction;
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
    UnitName_Master: TcxGridDBBandedColumn;
    UnitName_Slave: TcxGridDBBandedColumn;
    GoodsCode: TcxGridDBBandedColumn;
    GoodsName: TcxGridDBBandedColumn;
    Amount: TcxGridDBBandedColumn;
    PercentSAUA: TcxGridDBBandedColumn;
    MCS: TcxGridDBBandedColumn;
    GoodsCategory: TcxGridDBBandedColumn;
    AmountSAUA: TcxGridDBBandedColumn;
    cxGridLevel: TcxGridLevel;
    GetUnitsList: TdsdStoredProc;
    UnitsCDS: TClientDataSet;
    ceThreshold: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    procedure ParentFormCreate(Sender: TObject);
    procedure ParentFormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

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
    CheckListBoxAssortment.Items.AddObject(UnitsCDS.FieldByName('UnitName').asString,TObject(UnitsCDS.FieldByName('Id').AsInteger));
    UnitsCDS.Next;
  end;

end;

initialization
  RegisterClass(TCalculation_SAUAForm);
end.
