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
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxSplitter;

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
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colPriceWithOutVAT: TcxGridDBColumn;
    colPriceWithVAT: TcxGridDBColumn;
    colAmountReal: TcxGridDBColumn;
    colAmountPlanMin: TcxGridDBColumn;
    colAmountPlanMax: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    GoodsChoiceForm: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    GoodsKindChoiceForm: TOpenChoiceForm;
    dxBarButton1: TdxBarButton;
    cxGridPartner: TcxGrid;
    cxGridDBTableViewPartner: TcxGridDBTableView;
    colp_isErased: TcxGridDBColumn;
    colp_PartnerCode: TcxGridDBColumn;
    colp_PartnerName: TcxGridDBColumn;
    colp_PartnerDescName: TcxGridDBColumn;
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
    colcp_isErased: TcxGridDBColumn;
    colcp_ConditionPromoName: TcxGridDBColumn;
    colcp_Amount: TcxGridDBColumn;
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
    colJuridical_Name: TcxGridDBColumn;
    colRetail_Name: TcxGridDBColumn;
    colContractCode: TcxGridDBColumn;
    colContractName: TcxGridDBColumn;
    colContractTagName: TcxGridDBColumn;
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
    colAdvertisingCode: TcxGridDBColumn;
    colAdvertisingName: TcxGridDBColumn;
    colCommentAdvertising: TcxGridDBColumn;
    grlAdvertising: TcxGridLevel;
    cxSplitter3: TcxSplitter;
    colcp_Comment: TcxGridDBColumn;
    colIsErasedAdvertising: TcxGridDBColumn;
    colp_Comment: TcxGridDBColumn;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    colGoodComment: TcxGridDBColumn;
    colPriceSale: TcxGridDBColumn;
    colMeasureName: TcxGridDBColumn;
    colTradeMark: TcxGridDBColumn;
    colAmountRealWeight: TcxGridDBColumn;
    colAmountPlanMinWeight: TcxGridDBColumn;
    colAmountPlanMaxWeight: TcxGridDBColumn;
    colAmountOrder: TcxGridDBColumn;
    colAmountOrderWeight: TcxGridDBColumn;
    colAmountOut: TcxGridDBColumn;
    colAmountOutWeight: TcxGridDBColumn;
    colAmountIn: TcxGridDBColumn;
    colAmountInWeight: TcxGridDBColumn;
    colp_Area: TcxGridDBColumn;
    spUpdate_Movement_Promo_Data: TdsdStoredProc;
    actUpdate_Movement_Promo_Data: TdsdExecStoredProc;
    mactUpdate_Movement_Promo_Data: TMultiAction;
    dxBarButton11: TdxBarButton;
    tsPromoPartnerList: TcxTabSheet;
    grPartnerList: TcxGrid;
    grtvPartnerList: TcxGridDBTableView;
    colPartnerListRetailName: TcxGridDBColumn;
    colPartnerListJuridicalName: TcxGridDBColumn;
    colPartnerListCode: TcxGridDBColumn;
    colPartnerListName: TcxGridDBColumn;
    colPartnerListAreaName: TcxGridDBColumn;
    grlPartnerList: TcxGridLevel;
    PartnerListCDS: TClientDataSet;
    PartnerLisrDS: TDataSource;
    spSelect_MovementItem_PromoPartner: TdsdStoredProc;
    colPartnerListContractCode: TcxGridDBColumn;
    colPartnerListContractName: TcxGridDBColumn;
    colPartnerListContractTagName: TcxGridDBColumn;
    colPartnerListIsErased: TcxGridDBColumn;
    dsdDBViewAddOnPartnerList: TdsdDBViewAddOn;
    actPartnerListRefresh: TdsdDataSetRefresh;
    mactAddAllPartner: TMultiAction;
    actChoiceRetailForm: TOpenChoiceForm;
    actInsertUpdate_Movement_PromoPartnerFromRetail: TdsdExecStoredProc;
    spInsertUpdate_Movement_PromoPartnerFromRetail: TdsdStoredProc;
    dxBarButton12: TdxBarButton;
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
