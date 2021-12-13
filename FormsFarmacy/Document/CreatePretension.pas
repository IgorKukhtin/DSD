unit CreatePretension;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxCurrencyEdit, dsdAddOn,
  dsdAction, cxCheckBox, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxBarBuiltInMenu, cxNavigator, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCalc,
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
  dxSkinXmas2008Blue, cxMemo;

type
  TCreatePretensionForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    AmountIncome: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    bbPrintTax: TdxBarButton;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    dxBarButton1: TdxBarButton;
    AmountManual: TcxGridDBColumn;
    AmountDiff: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    bbisDocument: TdxBarButton;
    bbPrintSticker_notPrice: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    dxBarButton5: TdxBarButton;
    cxmComment: TcxMemo;
    cxLabel5: TcxLabel;
    mactCreatePretension: TMultiAction;
    spInsertMIPretension: TdsdStoredProc;
    spInsertMovementPretension: TdsdStoredProc;
    actInsertMovementPretension: TdsdExecStoredProc;
    actInsertMIPretension: TdsdExecStoredProc;
    mactCreateMIPretension: TMultiAction;
    actOpenPretensionForm: TdsdOpenForm;
    Amount: TcxGridDBColumn;
    ReasonDifferencesName: TcxGridDBColumn;
    ChoiceReasonDifferences: TOpenChoiceForm;
    spChechPretension: TdsdStoredProc;
    actChechPretension: TdsdExecStoredProc;
    mactChechPretension: TMultiAction;
    MakerName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCreatePretensionForm);

end.
