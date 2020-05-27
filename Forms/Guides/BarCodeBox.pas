unit BarCodeBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, ParentForm, dsdDB, dsdAction, dsdAddOn, dxBarExtItems,
  cxGridBandedTableView, cxGridDBBandedTableView, cxCheckBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCurrencyEdit;

type
  TBarCodeBoxForm = class(TParentForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    dsdStoredProc: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    dsdGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    spErasedUnErased: TdsdStoredProc;
    bbChoice: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    clCode: TcxGridDBColumn;
    clErased: TcxGridDBColumn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actShowAll: TBooleanStoredProcAction;
    actUpdateDataSet: TdsdUpdateDataSet;
    actUpdate_Print: TdsdStoredProc;
    FormParams: TdsdFormParams;
    bbShowAll: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    spInsert_BarCodeBox: TdsdStoredProc;
    actInsert_BarCodeBox: TdsdExecStoredProc;
    ExecuteBarCodeBoxDialog: TExecuteDialog;
    macInsert_BarCodeBox: TMultiAction;
    ProtocolOpenForm: TdsdOpenForm;
    actPrint_2: TdsdPrintAction;
    actPrint: TdsdPrintAction;
    bbInsert_BarCodeBox: TdxBarButton;
    bbProtocol: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    spInsert_Object_Print: TdsdStoredProc;
    actInsert_Object_Print: TdsdExecStoredProc;
    spDelete_Object_Print: TdsdStoredProc;
    actDelete_Object_Print: TdsdExecStoredProc;
    spSelectPrintByGrid: TdsdStoredProc;
    actPrint_Grid: TdsdPrintAction;
    macInsert_Object_Print_list: TMultiAction;
    macInsert_Object_PrintGrid: TMultiAction;
    bbInsert_Object_PrintGrid: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBarCodeBoxForm);

end.
