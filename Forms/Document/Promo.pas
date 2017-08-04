unit Promo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxSplitter, dxSkinBlack,
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
  cxCheckBox;

type
  TPromoForm = class(TAncestorDocumentForm)
    PriceListGuides: TdsdGuides;
    edPriceList: TcxButtonEdit;
    cxLabel11: TcxLabel;
    PromoKindGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    edPromoKind: TcxButtonEdit;
    cxLabel5: TcxLabel;
    deStartPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEndPromo: TcxDateEdit;
    cxLabel7: TcxLabel;
    deStartSale: TcxDateEdit;
    cxLabel8: TcxLabel;
    deEndSale: TcxDateEdit;
    cxLabel9: TcxLabel;
    deOperDateStart: TcxDateEdit;
    cxLabel10: TcxLabel;
    deOperDateEnd: TcxDateEdit;
    edCostPromo: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edComment: TcxTextEdit;
    PersonalTradeGuides: TdsdGuides;
    cxLabel14: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    cxLabel16: TcxLabel;
    edPersonal: TcxButtonEdit;
    PersonalGuides: TdsdGuides;
    UnitGuides: TdsdGuides;
    edUnit: TcxButtonEdit;
    cxLabel17: TcxLabel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    PriceWithOutVAT: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    AmountReal: TcxGridDBColumn;
    AmountPlanMin: TcxGridDBColumn;
    AmountPlanMax: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    GoodsChoiceForm: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    GoodsKindChoiceForm: TOpenChoiceForm;
    dxBarButton1: TdxBarButton;
    cxGridPartner: TcxGrid;
    cxGridDBTableViewPartner: TcxGridDBTableView;
    isErased: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    PartnerDescName: TcxGridDBColumn;
    cxGridLevelPartner: TcxGridLevel;
    spSelect_Movement_PromoPartner: TdsdStoredProc;
    PartnerCDS: TClientDataSet;
    PartnerDS: TDataSource;
    InsertRecordPartner: TInsertRecord;
    ErasedPartner: TdsdUpdateErased;
    UnErasedPartner: TdsdUpdateErased;
    PromoPartnerChoiceForm: TOpenChoiceForm;
    spErasedMIPartner: TdsdStoredProc;
    spUnErasedMIPartner: TdsdStoredProc;
    spInsertUpdateMIPartner: TdsdStoredProc;
    dsdDBViewAddOnPartner: TdsdDBViewAddOn;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dsdUpdateDSPartner: TdsdUpdateDataSet;
    Panel1: TPanel;
    cxSplitter1: TcxSplitter;
    cxSplitter2: TcxSplitter;
    cxPageControl1: TcxPageControl;
    tsPartner: TcxTabSheet;
    cxPageControl2: TcxPageControl;
    tsConditionPromo: TcxTabSheet;
    cxGridConditionPromo: TcxGrid;
    grtvConditionPromo: TcxGridDBTableView;
    cp_isErased: TcxGridDBColumn;
    ConditionPromoName: TcxGridDBColumn;
    cp_Amount: TcxGridDBColumn;
    grlConditionPromo: TcxGridLevel;
    ConditionPromoDS: TDataSource;
    ConditionPromoCDS: TClientDataSet;
    spSelect_MovementItem_PromoCondition: TdsdStoredProc;
    spInsertUpdateMICondition: TdsdStoredProc;
    spUnErasedMICondition: TdsdStoredProc;
    spErasedMICondition: TdsdStoredProc;
    UpdateConditionDS: TdsdUpdateDataSet;
    InsertCondition: TInsertRecord;
    ErasedCondition: TdsdUpdateErased;
    UnErasedCondition: TdsdUpdateErased;
    ConditionPromoChoiceForm: TOpenChoiceForm;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dsdDBViewAddOnConditionPromo: TdsdDBViewAddOn;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    pmPartner: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    pmCondition: TPopupMenu;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    PrintHead: TClientDataSet;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    Juridical_Name: TcxGridDBColumn;
    Retail_Name: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    ContractChoiceForm: TOpenChoiceForm;
    cxLabel18: TcxLabel;
    edCommentMain: TcxTextEdit;
    AdvertisingCDS: TClientDataSet;
    AdvertisingDS: TDataSource;
    pmAdvertising: TPopupMenu;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    spErasedAdvertising: TdsdStoredProc;
    spUnErasedAdvertising: TdsdStoredProc;
    spInsertUpdateMIAdvertising: TdsdStoredProc;
    spSelect_Movement_PromoAdvertising: TdsdStoredProc;
    InsertRecordAdvertising: TInsertRecord;
    ErasedAdvertising: TdsdUpdateErased;
    unErasedAdvertising: TdsdUpdateErased;
    AdvertisingChoiceForm: TOpenChoiceForm;
    UpdateDSAdvertising: TdsdUpdateDataSet;
    cxPageControl3: TcxPageControl;
    tsAdvertising: TcxTabSheet;
    grAdvertising: TcxGrid;
    grtvAdvertising: TcxGridDBTableView;
    AdvertisingCode: TcxGridDBColumn;
    AdvertisingName: TcxGridDBColumn;
    CommentAdvertising: TcxGridDBColumn;
    grlAdvertising: TcxGridLevel;
    cxSplitter3: TcxSplitter;
    cp_Comment: TcxGridDBColumn;
    IsErasedAdvertising: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    GoodComment: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    TradeMark: TcxGridDBColumn;
    AmountRealWeight: TcxGridDBColumn;
    AmountPlanMinWeight: TcxGridDBColumn;
    AmountPlanMaxWeight: TcxGridDBColumn;
    AmountOrder: TcxGridDBColumn;
    AmountOrderWeight: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    AmountOutWeight: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountInWeight: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    spUpdate_Movement_Promo_Data: TdsdStoredProc;
    actUpdate_Movement_Promo_Data: TdsdExecStoredProc;
    mactUpdate_Movement_Promo_Data: TMultiAction;
    dxBarButton11: TdxBarButton;
    tsPromoPartnerList: TcxTabSheet;
    grPartnerList: TcxGrid;
    grtvPartnerList: TcxGridDBTableView;
    PartnerListRetailName: TcxGridDBColumn;
    PartnerListJuridicalName: TcxGridDBColumn;
    PartnerListCode: TcxGridDBColumn;
    PartnerListName: TcxGridDBColumn;
    PartnerListAreaName: TcxGridDBColumn;
    grlPartnerList: TcxGridLevel;
    PartnerListCDS: TClientDataSet;
    PartnerLisrDS: TDataSource;
    spSelect_MovementItem_PromoPartner: TdsdStoredProc;
    PartnerListContractCode: TcxGridDBColumn;
    PartnerListContractName: TcxGridDBColumn;
    PartnerListContractTagName: TcxGridDBColumn;
    PartnerListIsErased: TcxGridDBColumn;
    dsdDBViewAddOnPartnerList: TdsdDBViewAddOn;
    actPartnerListRefresh: TdsdDataSetRefresh;
    mactAddAllPartner: TMultiAction;
    actChoiceRetailForm: TOpenChoiceForm;
    actInsertUpdate_Movement_PromoPartnerFromRetail: TdsdExecStoredProc;
    spInsertUpdate_Movement_PromoPartnerFromRetail: TdsdStoredProc;
    dxBarButton12: TdxBarButton;
    deEndReturn: TcxDateEdit;
    cxLabel3: TcxLabel;
    actPartnerProtocolOpenForm: TdsdOpenForm;
    actConditionPromoProtocolOpenForm: TdsdOpenForm;
    bbPartnerProtocol: TdxBarButton;
    bbPartnerListProtocol: TdxBarButton;
    bbAdvertisingProtocol: TdxBarButton;
    actAdvertisingProtocolOpenForm: TdsdOpenForm;
    spInsertUpdate_MI_Param: TdsdStoredProc;
    actInsertUpdate_MI_Param: TdsdExecStoredProc;
    macInsertUpdate_MI_Param: TMultiAction;
    bbInsertUpdate_MI_Param: TdxBarButton;
    cbChecked: TcxCheckBox;
    cbPromo: TcxCheckBox;
    deMonthPromo: TcxDateEdit;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    deCheck: TcxDateEdit;
    RetailName_inf: TcxGridDBColumn;
    spInsertUpdateMISign_No: TdsdStoredProc;
    spInsertUpdateMISign: TdsdStoredProc;
    actInsertUpdateMISignNO: TdsdExecStoredProc;
    actInsertUpdateMISign: TdsdExecStoredProc;
    bbMISign: TdxBarButton;
    bbSignNO: TdxBarButton;
    cxLabel21: TcxLabel;
    edstrSign: TcxTextEdit;
    edstrSignNo: TcxTextEdit;
    cxLabel22: TcxLabel;
    actInsertUpdateMISign1: TMultiAction;
    actInsertUpdateMISignNO1: TMultiAction;
    actRefresh_Get: TdsdDataSetRefresh;
    SignCDS: TClientDataSet;
    SignDS: TDataSource;
    dsdDBViewAddOnSign: TdsdDBViewAddOn;
    spSelectMISign: TdsdStoredProc;
    CalcCDS: TClientDataSet;
    CalcDS: TDataSource;
    dsdDBViewAddOnCalc: TdsdDBViewAddOn;
    spSelectCalc: TdsdStoredProc;
    calcPromoCondition: TcxGridDBColumn;
    calcProfit: TcxGridDBColumn;
    Color_PriceIn: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoForm);

end.
