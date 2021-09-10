unit ReturnIn;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReturnInForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edUnit: TcxButtonEdit;
    lblJuridical: TcxLabel;
    edCashRegister: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesCashRegister: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    bbPrintCheck: TdxBarButton;
    SPKindGuides: TdsdGuides;
    bbGet_SP_Prior: TdxBarButton;
    cxLabel8: TcxLabel;
    NDS: TcxGridDBColumn;
    actInsertRecord: TInsertRecord;
    bb: TdxBarButton;
    actOpenChoiceForm: TOpenChoiceForm;
    edInvNumberCheck: TcxButtonEdit;
    GuidesInvNumberCheck: TdsdGuides;
    cxLabel9: TcxLabel;
    edPaidTypeCheck: TcxTextEdit;
    ceTotalSummCheck: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    edOperDateCheck: TcxDateEdit;
    cxLabel11: TcxLabel;
    ContainerId: TcxGridDBColumn;
    AmountCheck: TcxGridDBColumn;
    OperDateIncome: TcxGridDBColumn;
    InvnumberIncome: TcxGridDBColumn;
    FromNameIncome: TcxGridDBColumn;
    ExpirationDate: TcxGridDBColumn;
    PartionDateKindName: TcxGridDBColumn;
    actApplicationTemplate: TdsdDOCReportFormAction;
    bbApplicationTemplate: TdxBarButton;
    edPaidType: TcxTextEdit;
    cxLabel12: TcxLabel;
    ceTotalSumm: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    edTotalSummPayAdd: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edTotalSummPayAddCheck: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    edFiscalCheckNumber: TcxTextEdit;
    cxLabel6: TcxLabel;
    edZReport: TcxTextEdit;
    cxLabel32: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReturnInForm);

end.
