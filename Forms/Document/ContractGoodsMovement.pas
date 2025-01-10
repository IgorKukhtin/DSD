unit ContractGoodsMovement;

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
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxSplitter, ExternalLoad, dsdCommon;

type
  TContractGoodsMovementForm = class(TAncestorDocumentForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    isSave: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshMI: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    actUnitChoiceForm: TOpenChoiceForm;
    actStorageChoiceForm: TOpenChoiceForm;
    actGoods_ObjectChoiceForm: TOpenChoiceForm;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    actGoodsKindCompleteChoice: TOpenChoiceForm;
    cxLabel22: TcxLabel;
    ceComment: TcxTextEdit;
    actPrintNoGroup: TdsdPrintAction;
    bbPrintNoGroup: TdxBarButton;
    cxLabel8: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel7: TcxLabel;
    edInsertName: TcxButtonEdit;
    cxLabel27: TcxLabel;
    edContract: TcxButtonEdit;
    GuidesContract: TdsdGuides;
    actPrintSaleOrder: TdsdPrintAction;
    actPrintSaleOrderTax: TdsdPrintAction;
    bbPrintSaleOrder: TdxBarButton;
    bbPrintSaleOrderTax: TdxBarButton;
    bbUpdate_MI_ContractGoods_Save_No: TdxBarButton;
    actUpdate_MI_ContractGoods_Save_No: TdsdExecStoredProc;
    macUpdate_MI_Save_No_List: TMultiAction;
    cxLabel5: TcxLabel;
    edEndBeginDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    isSale: TcxGridDBColumn;
    macUpdate_MI_ContractGoods_Save_No: TMultiAction;
    actUpdate_MI_ContractGoods_Save_Yes: TdsdExecStoredProc;
    macUpdate_MI_Save_Yes_List: TMultiAction;
    macUpdate_MI_ContractGoods_Save_Yes: TMultiAction;
    spUpdate_MI_ContractGoods_Save_No: TdsdStoredProc;
    spUpdate_MI_ContractGoods_Save_Yes: TdsdStoredProc;
    bbUpdate_MI_ContractGoods_Save_Yes: TdxBarButton;
    edContractTag: TcxButtonEdit;
    cxLabel21: TcxLabel;
    GuidesContractTag: TdsdGuides;
    cxLabel4: TcxLabel;
    edStartDate_contract: TcxDateEdit;
    edEndDate_contract: TcxDateEdit;
    cxLabel6: TcxLabel;
    cxLabel11: TcxLabel;
    edContractCode: TcxCurrencyEdit;
    GuidesContractStateKind: TdsdGuides;
    cxLabel9: TcxLabel;
    edContractStateKind: TcxButtonEdit;
    InsertRecord1: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    cxLabel14: TcxLabel;
    edCurrency: TcxButtonEdit;
    GuidesCurrency: TdsdGuides;
    cxLabel12: TcxLabel;
    edDiffPrice: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    edRoundPrice: TcxCurrencyEdit;
    CountForAmount: TcxGridDBColumn;
    edPriceWithVAT: TcxCheckBox;
    spGetImportSetting: TdsdStoredProc;
    actGetImportSetting: TdsdExecStoredProc;
    actLoadExcel: TMultiAction;
    bbLoadExcel: TdxBarButton;
    actDoLoad: TExecuteImportSettingsAction;
    cbMultWithVAT: TcxCheckBox;
    cxLabel13: TcxLabel;
    edSiteTag: TcxButtonEdit;
    GuidesSiteTag: TdsdGuides;
    cxLabel16: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TContractGoodsMovementForm);

end.
