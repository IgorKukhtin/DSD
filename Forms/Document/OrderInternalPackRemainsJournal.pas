unit OrderInternalPackRemainsJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TOrderInternalPackRemainsJournalForm = class(TAncestorJournalForm)
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrintRemains: TdxBarButton;
    TotalCountKg: TcxGridDBColumn;
    TotalCountSh: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spSelectPrintRemains: TdsdStoredProc;
    actPrintRemains: TdsdPrintAction;
    actPrintDetail: TdsdPrintAction;
    actPrintDiff: TdsdPrintAction;
    bbPrintDetail: TdxBarButton;
    bbPrintDiff: TdxBarButton;
    spSelectPrintRemainsLess: TdsdStoredProc;
    actPrintRemainsLessUpak: TdsdPrintAction;
    actPrintRemainsLess: TdsdPrintAction;
    bbPrintRemainsLess: TdxBarButton;
    bbPrintRemainsLessUpak: TdxBarButton;
    actOrderInternalPackRemainsOpen: TdsdOpenForm;
    bbOrderInternalPackRemains: TdxBarButton;
    spSelectPrintRemains_fact2: TdsdStoredProc;
    actPrintRemains_fact2: TdsdPrintAction;
    bbPrintRemains_fact2: TdxBarButton;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintStickerTermo: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    Separator: TdxBarSeparator;
    bbPrintStickerTermo: TdxBarButton;
    spSelectPrintSticker1: TdsdStoredProc;
    spSelectPrintSticker2: TdsdStoredProc;
    spSelectPrintSticker3: TdsdStoredProc;
    spSelectPrintSticker4: TdsdStoredProc;
    spSelectPrintSticker5: TdsdStoredProc;
    spSelectPrintStickerAll: TdsdStoredProc;
    spSelectPrintStickerLast: TdsdStoredProc;
    spSelectPrintSticker10: TdsdStoredProc;
    spSelectPrintSticker9: TdsdStoredProc;
    spSelectPrintSticker8: TdsdStoredProc;
    spSelectPrintSticker7: TdsdStoredProc;
    spSelectPrintSticker6: TdsdStoredProc;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarSubItem3: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    dxBarButton13: TdxBarButton;
    dxBarButton14: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TOrderInternalPackRemainsJournalForm);
end.
