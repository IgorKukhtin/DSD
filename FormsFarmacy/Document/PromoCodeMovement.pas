unit PromoCodeMovement;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad, cxCheckBox;

type
  TPromoCodeMovementForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edPromoCode: TcxButtonEdit;
    GuidesPromoCode: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    JuridicalName: TcxGridDBColumn;
    chComment: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MovementItem_PromoCodeChild: TdsdStoredProc;
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
    cxLabel9: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    InsertRecordChild: TInsertRecord;
    bbInsertRecordChild: TdxBarButton;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    clBayerName: TcxGridDBColumn;
    clIsErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    SignDCS: TClientDataSet;
    SignDS: TDataSource;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    spSelectPromoCodeSign: TdsdStoredProc;
    clComment: TcxGridDBColumn;
    PartnerChoiceForm: TOpenChoiceForm;
    InsertRecordSign: TInsertRecord;
    bbInsertRecordPartner: TdxBarButton;
    spInsertUpdatePromoCodeSign: TdsdStoredProc;
    dsdUpdateSignDS: TdsdUpdateDataSet;
    spUpErasedMISign: TdsdStoredProc;
    actSetErasedPromoCodeSign: TdsdUpdateErased;
    actSetUnErasedPromoCodeSign: TdsdUpdateErased;
    bbSetErasedPromoPartner: TdxBarButton;
    bbSetUnErasedPromoPartner: TdxBarButton;
    actInsertPromoCodeSign: TdsdExecStoredProc;
    macInsertPromoCodeSign: TMultiAction;
    actRefreshPromoCodeSign: TdsdDataSetRefresh;
    bbInsertPromoCodeSign: TdxBarButton;
    actOpenReportMinPriceForm: TdsdOpenForm;
    bbReportMinPriceForm: TdxBarButton;
    actOpenReportMinPrice_All: TdsdOpenForm;
    bbOpenReportMinPrice_All: TdxBarButton;
    cbisElectron: TcxCheckBox;
    cbisOne: TcxCheckBox;
    cxLabel10: TcxLabel;
    edInsertName: TcxButtonEdit;
    GuidesInsert: TdsdGuides;
    cxLabel11: TcxLabel;
    edUpdateName: TcxButtonEdit;
    GuidesUpdate: TdsdGuides;
    cxLabel12: TcxLabel;
    edInsertdate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edUpdateDate: TcxDateEdit;
    DescName: TcxGridDBColumn;
    spErasedMISign: TdsdStoredProc;
    BayerPhone: TcxGridDBColumn;
    BayerEmail: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    cxSplitter2: TcxSplitter;
    GUID: TcxGridDBColumn;
    spInsertPromoCodeSign: TdsdStoredProc;
    ExecuteDialogPromoCodeSign: TExecuteDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoCodeMovementForm);

end.
