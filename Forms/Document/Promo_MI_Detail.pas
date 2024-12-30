unit Promo_MI_Detail;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TPromo_MI_DetailForm = class(TAncestorDocumentForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    MeasureName: TcxGridDBColumn;
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
    AmountIn: TcxGridDBColumn;
    actUpdateMIChild_Amount: TdsdExecStoredProc;
    macUpdateMIChild_Amount: TMultiAction;
    actUpdateMIChild_AmountSecond: TdsdExecStoredProc;
    macUpdateMIChild_AmountSecond: TMultiAction;
    bbUpdateMIChild_Amount: TdxBarButton;
    bbUpdateMIChild_AmountSecond: TdxBarButton;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    TradeMarkName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    actOpenFormSend: TdsdOpenForm;
    bbOpenFormSend: TdxBarButton;
    actOpenFormOrderExternalChildDetail: TdsdOpenForm;
    bbOpenFormOrderExternalChildDetail: TdxBarButton;
    actReport_GoodsMotion: TdsdOpenForm;
    bbReport_GoodsMotion: TdxBarButton;
    cxLabel5: TcxLabel;
    deStartPromo: TcxDateEdit;
    cxLabel7: TcxLabel;
    deStartSale: TcxDateEdit;
    deEndPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    cxLabel3: TcxLabel;
    deEndSale: TcxDateEdit;
    cxLabel9: TcxLabel;
    cxLabel27: TcxLabel;
    edPaidKind: TcxButtonEdit;
    edPromoKind: TcxButtonEdit;
    cxLabel10: TcxLabel;
    deOperDateStart: TcxDateEdit;
    deOperDateEnd: TcxDateEdit;
    cxLabel11: TcxLabel;
    cxLabel20: TcxLabel;
    cbPromo: TcxCheckBox;
    cbCost: TcxCheckBox;
    cbChecked: TcxCheckBox;
    deCheck: TcxDateEdit;
    cxLabel19: TcxLabel;
    deMonthPromo: TcxDateEdit;
    cxLabel23: TcxLabel;
    edPromoStateKind: TcxButtonEdit;
    GuidesPromoStateKind: TdsdGuides;
    GuidesPaidKind: TdsdGuides;
    GuidesPromoKind: TdsdGuides;
    spInsertUpdate_MI_Promo_Detail: TdsdStoredProc;
    actInsertUpdate_MI_Promo_Detail: TdsdExecStoredProc;
    bbInsertUpdate_MI_Promo_Detail: TdxBarButton;
    DateStart_pr: TcxGridDBColumn;
    DateEnd_pr: TcxGridDBColumn;
    AmountDays: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromo_MI_DetailForm);

end.
