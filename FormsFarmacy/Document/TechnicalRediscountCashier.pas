unit TechnicalRediscountCashier;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics, DataModul,
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
  TTechnicalRediscountCashierForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    DiffSumm: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxSplitter1: TcxSplitter;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    GuidesUnit: TdsdGuides;
    edUnitName: TcxButtonEdit;
    dxBarButton1: TdxBarButton;
    Remains_Amount: TcxGridDBColumn;
    Proficit: TcxGridDBColumn;
    Deficit: TcxGridDBColumn;
    Remains_Summ: TcxGridDBColumn;
    DeficitSumm: TcxGridDBColumn;
    ProficitSumm: TcxGridDBColumn;
    Remains_FactAmount: TcxGridDBColumn;
    Remains_FactSumm: TcxGridDBColumn;
    cbisRedCheck: TcxCheckBox;
    CommentTRName: TcxGridDBColumn;
    Explanation: TcxGridDBColumn;
    actChoiceCommentTR: TOpenChoiceForm;
    actChoiceGoods: TOpenChoiceForm;
    dxBarButton2: TdxBarButton;
    ExpirationDate: TcxGridDBColumn;
    cbAdjustment: TcxCheckBox;
    Comment: TcxGridDBColumn;
    actPUSH: TdsdShowPUSHMessage;
    spPUSH: TdsdStoredProc;
    OperDateSend: TcxGridDBColumn;
    InvNumberSend: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    cbCorrectionSUN: TcxCheckBox;
    isDeferred: TcxGridDBColumn;
    msctUpdate_Deferred: TMultiAction;
    actUpdate_Deferred: TdsdExecStoredProc;
    spUpdate_Deferred: TdsdStoredProc;
    bbUpdate_Deferred: TdxBarButton;
    spPUSHComplete: TdsdStoredProc;
    actPUSHComplete: TdsdShowPUSHMessage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTechnicalRediscountCashierForm);

end.
