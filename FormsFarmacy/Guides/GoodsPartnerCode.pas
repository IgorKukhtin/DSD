unit GoodsPartnerCode;

interface

uses
  DataModul, Winapi.Windows, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  dsdAddOn, dsdDB, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  Vcl.Controls, cxGrid, AncestorGuides, cxPCdxBarPopupMenu, Vcl.Menus, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, cxContainer, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLabel, dsdGuides, cxSplitter, Vcl.DBActns, dxBarBuiltInMenu,
  cxNavigator, ExternalLoad;

type
  TGoodsPartnerCodeForm = class(TAncestorGuidesForm)
    clCodeInt: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    edPartnerCode: TcxButtonEdit;
    cxLabel1: TcxLabel;
    PartnerCodeGuides: TdsdGuides;
    clCode: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    mactDelete: TMultiAction;
    colGoodsMainName: TcxGridDBColumn;
    colGoodsMainCode: TcxGridDBColumn;
    clMakerName: TcxGridDBColumn;
    spDeleteLink: TdsdStoredProc;
    actDeleteLink: TdsdExecStoredProc;
    DataSetPost: TDataSetPost;
    mactSetLink: TMultiAction;
    DataSetEdit: TDataSetEdit;
    OpenChoiceForm: TOpenChoiceForm;
    spInserUpdateGoodsLink: TdsdStoredProc;
    actSetLink: TdsdExecStoredProc;
    bbSetLink: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    dsdUpdateDataSet: TdsdUpdateDataSet;
    clMinimumLot: TcxGridDBColumn;
    spUpdate_Goods_MinimumLot: TdsdStoredProc;
    spDelete_ObjectFloat_Goods_MinimumLot: TdsdStoredProc;
    actStartLoad: TMultiAction;
    actDelete_ObjectFloat_Goods_MinimumLot: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    spGetImportSetting_Goods_MinimumLot: TdsdStoredProc;
    actGetImportSetting_Goods_MinimumLot: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsPartnerCodeForm);

end.
