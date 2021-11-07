
unit IncomePharmacyJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCurrencyEdit, dsdAction, dsdDB, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, ExternalSave,
  dxBarBuiltInMenu, cxNavigator, cxCheckBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxButtonEdit, dxSkinsdxBarPainter,
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
  TIncomePharmacyJournalForm = class(TAncestorJournalForm)
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    bbTax: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    spGetDataForSend: TdsdStoredProc;
    NDS: TcxGridDBColumn;
    spGetDataForSendNew: TdsdStoredProc;
    SaleSumm: TcxGridDBColumn;
    actPrintForManager: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    JuridicalName: TcxGridDBColumn;
    spInsertUpdateMovement: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    mactFarmacyShow: TMultiAction;
    actGet_Movement_ManualAmountTrouble: TdsdExecStoredProc;
    actaOpen_Income_AmountTroubleForm: TdsdOpenForm;
    spGet_Movement_ManualAmountTrouble: TdsdStoredProc;
    Button: TcxGridDBColumn;
    spisDocument: TdsdStoredProc;
    actisDocument: TdsdExecStoredProc;
    bbisDocument: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    bbPrintSticker_notPrice: TdxBarButton;
    actPrintSticker_notPrice: TdsdPrintAction;
    TotalSumm: TcxGridDBColumn;
    actSetVisible: TdsdSetVisibleAction;
    spSetVisible: TdsdStoredProc;
    actExecStoredSetVisible: TdsdExecStoredProc;
    isConduct: TcxGridDBColumn;
    DateConduct: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TIncomePharmacyJournalForm);
end.
