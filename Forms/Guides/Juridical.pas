unit Juridical;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox,
  dxSkinsdxBarPainter, dsdDB, Datasnap.DBClient, dsdAddOn, dsdAction,
  Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxSplitter, cxButtonEdit, cxCurrencyEdit, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxLabel, dsdCommon;

type
  TJuridicalForm = class(TParentForm)
    cxSplitter: TcxSplitter;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbChoiceGuides: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel: TdsdGridToExcel;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    GridDS: TDataSource;
    MasterCDS: TClientDataSet;
    spSelect: TdsdStoredProc;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    InfoMoneyGroupCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationCode: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    GLNCode: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    IsCorporate: TcxGridDBColumn;
    JuridicalGroupName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    PriceListName: TcxGridDBColumn;
    actChoicePriceListForm: TOpenChoiceForm;
    actChoicePriceListPromoForm: TOpenChoiceForm;
    PriceListPromoName: TcxGridDBColumn;
    StartPromo: TcxGridDBColumn;
    EndPromo: TcxGridDBColumn;
    GoodsPropertyName: TcxGridDBColumn;
    RetailReportName: TcxGridDBColumn;
    actChoiceRetailReportForm: TOpenChoiceForm;
    actChoiceJuridicalGroup: TOpenChoiceForm;
    RetailName: TcxGridDBColumn;
    actChoiceRetailForm: TOpenChoiceForm;
    InfoMoneyName_all: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    isTaxSummary: TcxGridDBColumn;
    PriceListName_Prior: TcxGridDBColumn;
    PriceListName_30103: TcxGridDBColumn;
    PriceListName_30201: TcxGridDBColumn;
    actChoicePriceList_Prior: TOpenChoiceForm;
    actChoicePriceList_30103: TOpenChoiceForm;
    actChoicePriceList_30201: TOpenChoiceForm;
    DayTaxSummary: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    isDiscountPrice: TcxGridDBColumn;
    isLongUKTZED: TcxGridDBColumn;
    isPriceWithVAT: TcxGridDBColumn;
    isGUID: TcxGridDBColumn;
    GUID: TcxGridDBColumn;
    INN: TcxGridDBColumn;
    spUpdate_IsOrderMin: TdsdStoredProc;
    actUpdate_IsOrderMin: TdsdExecStoredProc;
    bbUpdate_IsOrderMin: TdxBarButton;
    spUpdate_IsBranchAll: TdsdStoredProc;
    actUpdate_IsBranchAll: TdsdExecStoredProc;
    bbUpdate_IsBranchAll: TdxBarButton;
    spUpdate_VatPrice: TdsdStoredProc;
    actInsert_VatPrice: TdsdExecStoredProc;
    ExecuteVatPriceDialog: TExecuteDialog;
    macInsert_VatPrice: TMultiAction;
    bbInsert_VatPrice: TdxBarButton;
    FormParams: TdsdFormParams;
    SummOrderMin: TcxGridDBColumn;
    spUpdate_IsNotTare: TdsdStoredProc;
    actUpdate_IsNotTare: TdsdExecStoredProc;
    macUpdate_IsNotTare_list: TMultiAction;
    macUpdate_IsNotTare_Yes: TMultiAction;
    spUpdate_IsNotTare_Yes: TdsdStoredProc;
    actUpdate_IsNotTare_Yes: TdsdExecStoredProc;
    bbUpdate_IsNotTare: TdxBarButton;
    bbUpdate_IsNotTare_Yes: TdxBarButton;
    spInsertUpdate_BasisCode: TdsdStoredProc;
    actInsertUpdate_BasisCode: TdsdExecStoredProc;
    macInsertUpdate_BasisCode_list: TMultiAction;
    macInsertUpdate_BasisCode: TMultiAction;
    bbInsertUpdate_BasisCode: TdxBarButton;
    spUpdate_isIrna: TdsdStoredProc;
    actUpdate_isIrna: TdsdExecStoredProc;
    macUpdate_isIrna_list: TMultiAction;
    macUpdate_isIrna: TMultiAction;
    bbUpdate_isIrna: TdxBarButton;
    SectionName: TcxGridDBColumn;
    cxLabel2: TcxLabel;
    edShowDate: TcxDateEdit;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    JuridicalAddress: TcxGridDBColumn;
    JuridicalAddress_inf: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TJuridicalForm);
end.
