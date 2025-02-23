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
  cxBlobEdit, Document, cxEditRepositoryItems, cxSplitter, cxMemo;

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
    seisErased: TcxGridDBColumn;
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
    chCorrectAnswer: TcxGridDBColumn;
    Photo: TDocument;
    dxBarButton13: TdxBarButton;
    actLoadPhotoFile: TdsdSetDefaultParams;
    sePropertiesId: TcxGridDBColumn;
    erPossibleAnswer: TcxEditRepository;
    actPreparePictures: TdsdPreparePicturesAction;
    erCorrectAnswer: TcxEditRepository;
    erCorrectAnswerCheckBoxItem1: TcxEditRepositoryCheckBoxItem;
    erCorrectAnswerCheckBoxItem2: TcxEditRepositoryCheckBoxItem;
    cxSplitter1: TcxSplitter;
    erPossibleAnswerBlobItem1: TcxEditRepositoryMemoItem;
    erPossibleAnswerBlobItem2: TcxEditRepositoryImageItem;
    spUpdate_CorrectAnswer: TdsdStoredProc;
    actUpdate_CorrectAnswer: TdsdExecStoredProc;
    dxBarButton14: TdxBarButton;
    actExecuteDialogPossibleAnswerUpdate: TExecuteDialog;
    actUpdate_PossibleAnswer: TdsdExecStoredProc;
    spUpdate_PossibleAnswer: TdsdStoredProc;
    dxBarButton15: TdxBarButton;
    actLoadPhoto: TdsdExecStoredProc;
    spUpdate_PossibleAnswerPhoto: TdsdStoredProc;
    spInsertMISecondPhotoFalse: TdsdStoredProc;
    spInsertMISecondPhotoTrue: TdsdStoredProc;
    actInsertMISecondPhotoTrue: TdsdExecStoredProc;
    actInsertMISecondPhotoFalse: TdsdExecStoredProc;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    chisMandatoryQuestion: TcxGridDBColumn;
    actUpdate_MandatoryQuestion: TdsdExecStoredProc;
    spUpdate_MandatoryQuestion: TdsdStoredProc;
    dxBarButton18: TdxBarButton;
    maMandatoryQuestion: TcxGridDBColumn;
    meTestQuestionsStorekeeper: TcxGridDBColumn;
    edTimeTestStorekeeper: TcxTextEdit;
    edQuestionStorekeeper: TcxTextEdit;
    cxLabel6: TcxLabel;
    cxLabel8: TcxLabel;
    chisStorekeeper: TcxGridDBColumn;
    maQuestionStorekeeper: TcxGridDBColumn;
    spUpdate_Storekeeper: TdsdStoredProc;
    actUpdate_Storekeeper: TdsdExecStoredProc;
    dxBarButton19: TdxBarButton;
    actRefreshSmall: TdsdDataSetRefresh;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    edWrong└nswersStorekeeper: TcxTextEdit;
    edWrong└nswers: TcxTextEdit;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
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
