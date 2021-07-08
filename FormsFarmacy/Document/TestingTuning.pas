unit TestingTuning;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxBlobEdit;

type
  TTestingTuningForm = class(TAncestorDocumentForm)
    chOrders: TcxGridDBColumn;
    chQuestion: TcxGridDBColumn;
    chReplies: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    bbComplete: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    actComplete: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    edComment: TcxTextEdit;
    cxLabel7: TcxLabel;
    dxBarButton3: TdxBarButton;
    bbUpdateSummaFund: TdxBarButton;
    dxBarButton4: TdxBarButton;
    spUpdate_ConfirmedMarketing: TdsdStoredProc;
    dxBarButton5: TdxBarButton;
    cxTopicsTestingTuning: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    maTopicsTestingTuningName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    edTotalCount: TcxTextEdit;
    cxLabel3: TcxLabel;
    edQuestion: TcxTextEdit;
    cxLabel4: TcxLabel;
    edTimeTest: TcxTextEdit;
    cxLabel5: TcxLabel;
    spSelectChild: TdsdStoredProc;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    maQuestion: TcxGridDBColumn;
    maTestQuestions: TcxGridDBColumn;
    DBViewAddOnChild: TdsdDBViewAddOn;
    spInsertUpdateMIChild: TdsdStoredProc;
    actUpdateChildDS: TdsdUpdateDataSet;
    cxGridSecond: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    seOrders: TcxGridDBColumn;
    seisCorrectAnswer: TcxGridDBColumn;
    sePossibleAnswer: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    spInsertUpdateMISecond: TdsdStoredProc;
    DBViewAddOnSecond: TdsdDBViewAddOn;
    SecondDS: TDataSource;
    SecondCDS: TClientDataSet;
    spSelectSecond: TdsdStoredProc;
    actUpdateSecondDS: TdsdUpdateDataSet;
    spUnErasedMIChild: TdsdStoredProc;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMISecond: TdsdStoredProc;
    spErasedMISecond: TdsdStoredProc;
    actMISetErasedChild: TdsdUpdateErased;
    actMISetUnErasedChild: TdsdUpdateErased;
    actMISetErasedSecond: TdsdUpdateErased;
    actMISetUnErasedSecond: TdsdUpdateErased;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    actExecuteDialogQuestion: TExecuteDialog;
    actAddQuestion: TdsdExecStoredProc;
    dxBarButton10: TdxBarButton;
    spInsertMIChild: TdsdStoredProc;
    spInsertMISecondTrue: TdsdStoredProc;
    spInsertMISecondFalse: TdsdStoredProc;
    actExecuteDialogPossibleAnswerTrue: TExecuteDialog;
    actInsertMISecondTrue: TdsdExecStoredProc;
    actExecuteDialogPossibleAnswerFalse: TExecuteDialog;
    actInsertMISecondFalse: TdsdExecStoredProc;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTestingTuningForm);

end.
