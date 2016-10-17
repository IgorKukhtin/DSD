unit Inventory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TInventoryForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colPartionGoods: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    colCount: TcxGridDBColumn;
    colHeadCount: TcxGridDBColumn;
    colAssetName: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colSumm: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colStorageName: TcxGridDBColumn;
    actUnitChoice: TOpenChoiceForm;
    actStorageChoice: TOpenChoiceForm;
    actAssetChoice: TOpenChoiceForm;
    colPartionGoodsDate: TcxGridDBColumn;
    clGoodsGroupNameFull: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    spInsertUpdateMIAmount: TdsdStoredProc;
    actInsertUpdateMIAmount: TdsdExecStoredProc;
    bbInsertUpdateMIAmount: TdxBarButton;
    actPrint1: TdsdPrintAction;
    mactUpdate_Summ: TMultiAction;
    spUpdateMIMaster_Summ: TdsdStoredProc;
    actUpdate_Summ: TdsdExecStoredProc;
    bbUpdate_Summ: TdxBarButton;
    mactUpdate_SummAll: TMultiAction;
    GoodsKindName_Complete: TcxGridDBColumn;
    actGoodsKindCompleteChoiceMaster: TOpenChoiceForm;
    ContainerId: TcxGridDBColumn;
    actSendOpenForm: TOpenChoiceForm;
    bb: TdxBarButton;
    spInsert_MI_Inventory_bySend: TdsdStoredProc;
    actInsert_bySend: TdsdExecStoredProc;
    macInsert_bySend: TMultiAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TInventoryForm);

end.
