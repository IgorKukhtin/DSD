unit Promo;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad, DataModul;

type
  TPromoForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edMaker: TcxButtonEdit;
    lblJuridical: TcxLabel;
    edPersonal: TcxButtonEdit;
    GuidesMaker: TdsdGuides;
    GuidesPersonal: TdsdGuides;
    cxLabel4: TcxLabel;
    edTotalSumm: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edTotalCount: TcxCurrencyEdit;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    JuridicalName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MovementItem_PromoChild: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    JuridicalCode: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    spInsertUpdateMIChild: TdsdStoredProc;
    edStartPromo: TcxDateEdit;
    cxLabel3: TcxLabel;
    edEndPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    actMISetErasedChild: TdsdUpdateErased;
    actMISetUnErasedChild: TdsdUpdateErased;
    bbMISetErasedChild: TdxBarButton;
    bbMISetUnErasedChild: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    actDoLoad: TExecuteImportSettingsAction;
    actInsertUpdate_MovementItem_Promo_Set_Zero: TdsdExecStoredProc;
    actGetImportSettingId: TdsdExecStoredProc;
    actStartLoad: TMultiAction;
    spInsertUpdate_MovementItem_Promo_Set_Zero: TdsdStoredProc;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    cxLabel8: TcxLabel;
    edAmount: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    InsertRecordChild: TInsertRecord;
    bbInsertRecordChild: TdxBarButton;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    cxSplitter2: TcxSplitter;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    clJuridicalCode: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clIsErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    PartnerDCS: TClientDataSet;
    PartnerDS: TDataSource;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    spSelectPromoPartner: TdsdStoredProc;
    clComment: TcxGridDBColumn;
    PartnerChoiceForm: TOpenChoiceForm;
    InsertRecordPartner: TInsertRecord;
    bbInsertRecordPartner: TdxBarButton;
    spInsertUpdatePromoPartner: TdsdStoredProc;
    dsdUpdatePartnerDS: TdsdUpdateDataSet;
    spSetErasedPromoPartner: TdsdStoredProc;
    spUnCompletePromoPartner: TdsdStoredProc;
    actSetErasedPromoPartner: TdsdUpdateErased;
    actSetUnErasedPromoPartner: TdsdUpdateErased;
    bbSetErasedPromoPartner: TdxBarButton;
    bbSetUnErasedPromoPartner: TdxBarButton;
    spInsertPromoPartner: TdsdStoredProc;
    actInsertPromoPartner: TdsdExecStoredProc;
    macInsertPromoPartner: TMultiAction;
    actRefreshPromoPartner: TdsdDataSetRefresh;
    bbInsertPromoPartner: TdxBarButton;
    actOpenReportMinPriceForm: TdsdOpenForm;
    bbReportMinPriceForm: TdxBarButton;
    actOpenReportMinPrice_All: TdsdOpenForm;
    bbOpenReportMinPrice_All: TdxBarButton;
    actUpdateMovementItemContainer: TdsdExecStoredProc;
    spUpdate_MovementItemContainer: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    edPrescribe: TcxTextEdit;
    cxLabel10: TcxLabel;
    isChecked: TcxGridDBColumn;
    isReport: TcxGridDBColumn;
    spUpdate_Checked_Yes: TdsdStoredProc;
    spUpdate_Checked_No: TdsdStoredProc;
    actUpdate_Checked_Yes: TdsdExecStoredProc;
    actUpdate_Checked_No: TdsdExecStoredProc;
    macUpdate_Checked_Yes_List: TMultiAction;
    macUpdate_Checked_Yes: TMultiAction;
    actRefreshMI: TdsdDataSetRefresh;
    macUpdate_Checked_No_List: TMultiAction;
    macUpdate_Checked_No: TMultiAction;
    bbUpdate_Checked_Yes: TdxBarButton;
    bbUpdate_Checked_No: TdxBarButton;
    GoodsGroupPromoName: TcxGridDBColumn;
    actOpenChoiceGoodsGroupPromo: TOpenChoiceForm;
    spUpdate_GoodsGroupPromo: TdsdStoredProc;
    actGoodsGroupPromo: TMultiAction;
    actExecUpdate_GoodsGroupPromo: TdsdExecStoredProc;
    spLoad_From_Object: TdsdStoredProc;
    actLoad_From_Object: TdsdExecStoredProc;
    actPartnerChoice: TOpenChoiceForm;
    dxBarButton2: TdxBarButton;
    edRelatedProduct: TcxButtonEdit;
    cxLabel11: TcxLabel;
    actUpdate_RelatedProduct: TdsdExecStoredProc;
    actChoiceRelatedProduct: TOpenChoiceForm;
    spUpdate_RelatedProduct: TdsdStoredProc;
    actClearRelatedProduct: TdsdSetDefaultParams;
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
