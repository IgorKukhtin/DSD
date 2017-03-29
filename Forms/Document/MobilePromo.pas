unit MobilePromo;

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
  TMobilePromoForm = class(TAncestorDocumentForm)
    cxLabel5: TcxLabel;
    deStartPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEndPromo: TcxDateEdit;
    cxLabel7: TcxLabel;
    deStartSale: TcxDateEdit;
    cxLabel8: TcxLabel;
    deEndSale: TcxDateEdit;
    PersonalTradeGuides: TdsdGuides;
    cxLabel14: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    cxLabel16: TcxLabel;
    edPersonal: TcxButtonEdit;
    PersonalGuides: TdsdGuides;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colPriceWithOutVAT: TcxGridDBColumn;
    colPriceWithVAT: TcxGridDBColumn;
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
    cxSplitter2: TcxSplitter;
    cxPageControl1: TcxPageControl;
    tsPartner: TcxTabSheet;
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
    PrintHead: TClientDataSet;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    colJuridicalName: TcxGridDBColumn;
    colRetail_Name: TcxGridDBColumn;
    colContractCode: TcxGridDBColumn;
    colContractName: TcxGridDBColumn;
    colContractTagName: TcxGridDBColumn;
    ContractChoiceForm: TOpenChoiceForm;
    cxLabel18: TcxLabel;
    edCommentMain: TcxTextEdit;
    InsertRecordAdvertising: TInsertRecord;
    ErasedAdvertising: TdsdUpdateErased;
    unErasedAdvertising: TdsdUpdateErased;
    AdvertisingChoiceForm: TOpenChoiceForm;
    UpdateDSAdvertising: TdsdUpdateDataSet;
    colp_Comment: TcxGridDBColumn;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    colTaxPromo: TcxGridDBColumn;
    colMeasureName: TcxGridDBColumn;
    colTradeMark: TcxGridDBColumn;
    colp_Area: TcxGridDBColumn;
    spUpdate_Movement_Promo_Data: TdsdStoredProc;
    actUpdate_Movement_Promo_Data: TdsdExecStoredProc;
    mactUpdate_Movement_Promo_Data: TMultiAction;
    dxBarButton11: TdxBarButton;
    PartnerListCDS: TClientDataSet;
    PartnerLisrDS: TDataSource;
    spSelect_MovementItem_PromoPartner: TdsdStoredProc;
    dsdDBViewAddOnPartnerList: TdsdDBViewAddOn;
    actPartnerListRefresh: TdsdDataSetRefresh;
    mactAddAllPartner: TMultiAction;
    actChoiceRetailForm: TOpenChoiceForm;
    actInsertUpdate_Movement_PromoPartnerFromRetail: TdsdExecStoredProc;
    spInsertUpdate_Movement_PromoPartnerFromRetail: TdsdStoredProc;
    dxBarButton12: TdxBarButton;
    deEndReturn: TcxDateEdit;
    cxLabel3: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMobilePromoForm);

end.
