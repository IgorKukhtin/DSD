unit MarginCategory_Movement2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad, cxCheckBox,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TMarginCategory_Movement2Form = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountAnalys: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    MarginCategoryName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    clAmount: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    spUpdateMIChild: TdsdStoredProc;
    edStartSale: TcxDateEdit;
    cxLabel3: TcxLabel;
    edEndSale: TcxDateEdit;
    cxLabel6: TcxLabel;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    actMISetErasedChild: TdsdUpdateErased;
    actMISetUnErasedChild: TdsdUpdateErased;
    bbMISetErasedChild: TdxBarButton;
    bbMISetUnErasedChild: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
    MarginCategoryChoiceForm: TOpenChoiceForm;
    actDoLoad: TExecuteImportSettingsAction;
    actInsertUpdate_MovementItem_Promo_Set_Zero: TdsdExecStoredProc;
    actGetImportSettingId: TdsdExecStoredProc;
    actStartLoad: TMultiAction;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    cxLabel8: TcxLabel;
    edAmount: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    InsertRecordChild: TInsertRecord;
    bbInsertRecordChild: TdxBarButton;
    PartnerChoiceForm: TOpenChoiceForm;
    actInsertPromoPartner: TdsdExecStoredProc;
    macInsertPromoPartner: TMultiAction;
    bbLoad_SAMP: TdxBarButton;
    cxLabel4: TcxLabel;
    edOperDateStart: TcxDateEdit;
    edOperDateEnd: TcxDateEdit;
    cxLabel5: TcxLabel;
    cxLabel10: TcxLabel;
    edInsertName: TcxButtonEdit;
    GuidesInsert: TdsdGuides;
    GuidesUpdate: TdsdGuides;
    edUpdateName: TcxButtonEdit;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    edInsertdate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edUpdateDate: TcxDateEdit;
    clAmountDiff: TcxGridDBColumn;
    spLoad_SAMP: TdsdStoredProc;
    actLoad_SAMP: TdsdExecStoredProc;
    macLoad_SAMP: TMultiAction;
    cxLabel14: TcxLabel;
    edDayCount: TcxCurrencyEdit;
    PersentMin: TcxGridDBColumn;
    PersentMax: TcxGridDBColumn;
    MinPrice: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    edPriceMin: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edPriceMax: TcxCurrencyEdit;
    MarginPercent: TcxGridDBColumn;
    cPrice: TcxGridDBColumn;
    isChecked: TcxGridDBColumn;
    spUpdate_isChecked_Yes: TdsdStoredProc;
    spUpdate_isChecked_No: TdsdStoredProc;
    spUpdateisCheckedNo: TdsdExecStoredProc;
    spUpdateisCheckedYes: TdsdExecStoredProc;
    macUpdateisCheckedNo: TMultiAction;
    macUpdateisCheckedYes: TMultiAction;
    bbUpdateisCheckedYes: TdxBarButton;
    bbUpdateisCheckedNo: TdxBarButton;
    isReport: TcxGridDBColumn;
    gpUpdate_isReport_Yes: TdsdStoredProc;
    gpUpdate_isReport_No: TdsdStoredProc;
    spUpdateisReportNo: TdsdExecStoredProc;
    spUpdateisReportYes: TdsdExecStoredProc;
    macUpdateisReportNo: TMultiAction;
    macUpdateisReportYes: TMultiAction;
    bbUpdateisReportNo: TdxBarButton;
    bbUpdateisReportYes: TdxBarButton;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReport: TdxBarButton;
    actOpenReportSimple: TdsdOpenForm;
    bbOpenReportSimple: TdxBarButton;
    gpUpdate_isReport: TdsdStoredProc;
    actUpdateisReport: TdsdExecStoredProc;
    actShowMessage: TShowMessageAction;
    UnitrDCS: TClientDataSet;
    UnitDS: TDataSource;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    cxSplitter3: TcxSplitter;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    ObjectCode: TcxGridDBColumn;
    ObjectName: TcxGridDBColumn;
    clIsErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    spInsertMarginCategoryUnit: TdsdStoredProc;
    spSelectMarginCategoryUnit: TdsdStoredProc;
    spInsertUpdateMarginCategoryUnit: TdsdStoredProc;
    spSetErasedMarginCategoryUnit: TdsdStoredProc;
    spUnCompleteMarginCategoryUnit: TdsdStoredProc;
    actInsertRecordUnit: TInsertRecord;
    Juridical_UnitChoiceForm: TOpenChoiceForm;
    actSetErasedMarginCategoryUnit: TdsdUpdateErased;
    actSetUnErasedMarginCategoryUnit: TdsdUpdateErased;
    bbSetErasedMarginCategoryUnit: TdxBarButton;
    bbSetUnErasedMarginCategoryUnit: TdxBarButton;
    bbInsertRecordUnit: TdxBarButton;
    dsdUpdateUnitDS: TdsdUpdateDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMarginCategory_Movement2Form);

end.
