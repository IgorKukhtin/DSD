unit Report_OrderExternal_WeighingPartner;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon,
  cxImageComboBox;

type
  TReport_OrderExternal_WeighingPartnerForm = class(TAncestorDocumentForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint_Goods: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel5: TcxLabel;
    edInvNumberOrder: TcxTextEdit;
    cxLabel10: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    cxLabel4: TcxLabel;
    edFrom: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    cxLabel8: TcxLabel;
    edTo: TcxButtonEdit;
    GuidesTo: TdsdGuides;
    MeasureName: TcxGridDBColumn;
    spSavePrintState: TdsdStoredProc;
    GoodsGroupNameFull: TcxGridDBColumn;
    cxLabel19: TcxLabel;
    edOperDatePartner_sale: TcxDateEdit;
    WeighingNumber: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    bbPrintTotal: TdxBarButton;
    bbUpdateOperDatePartner: TdxBarButton;
    bbPrintOrder: TdxBarButton;
    ChangeGuidesStatuswms1: TChangeGuidesStatus;
    ChangeGuidesStatuswms2: TChangeGuidesStatus;
    ChangeGuidesStatuswms3: TChangeGuidesStatus;
    bbPrint_Account: TdxBarButton;
    cxLabel22: TcxLabel;
    edCarInfo_Date: TcxDateEdit;
    AmountPartner: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    actUpdateMIChild_Amount: TdsdExecStoredProc;
    macUpdateMIChild_Amount: TMultiAction;
    actUpdateMIChild_AmountSecond: TdsdExecStoredProc;
    macUpdateMIChild_AmountSecond: TMultiAction;
    bbUpdateMIChild_Amount: TdxBarButton;
    bbUpdateMIChild_AmountSecond: TdxBarButton;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    Amount_order: TcxGridDBColumn;
    GuidesCarInfo: TdsdGuides;
    actOpenFormWeighingPartner: TdsdOpenForm;
    bbOpenFormWeighingPartner: TdxBarButton;
    actOpenFormOrderExternalChildDetail: TdsdOpenForm;
    bbOpenFormOrderExternalChildDetail: TdxBarButton;
    actReport_GoodsMotion: TdsdOpenForm;
    bbReport_GoodsMotion: TdxBarButton;
    cxLabel25: TcxLabel;
    ceGoodsProperty: TcxButtonEdit;
    GuidesGoodsProperty: TdsdGuides;
    actOpenFormOrderExternalUnit: TdsdOpenForm;
    actOpenFormWeightPatner: TdsdOpenForm;
    getMovementForm: TdsdStoredProc;
    actMovementFormParent: TdsdExecStoredProc;
    actOpenFormParent: TdsdOpenForm;
    macOpenDocumentParent: TMultiAction;
    bbOpenFormOrderExternalUnit: TdxBarButton;
    bbOpenDocumentParent: TdxBarButton;
    MovementDescName_Parent: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    edSearchGoodsName: TcxTextEdit;
    cxLabel7: TcxLabel;
    edSearchWeighingNumber: TcxTextEdit;
    cxLabel9: TcxLabel;
    edSearchGoodsKind: TcxTextEdit;
    FieldFilter_Name: TdsdFieldFilter;
    GoodsName_choice: TcxGridDBColumn;
    actPrintGroupWeighingNumber: TdsdPrintAction;
    bbPrintGroupWeighingNumber: TdxBarButton;
    actPrintGroupGoods: TdsdPrintAction;
    mPrint: TdxBarSubItem;
    bbPrintGroupGoods: TdxBarButton;
    cxLabel21: TcxLabel;
    edPartner: TcxButtonEdit;
    edCarInfo: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel11: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    GuidesRetail: TdsdGuides;
    dxBarButton1: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    spSelectPrint_Weighing: TdsdStoredProc;
    actPrintWeighing: TdsdPrintAction;
    bbPrintWeighing: TdxBarButton;
    spSelectPrint_GoodsAll: TdsdStoredProc;
    actPrintGoodsAll: TdsdPrintAction;
    bbPrintGoodsAll: TdxBarButton;
    CodeSticker: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_OrderExternal_WeighingPartnerForm);

end.
