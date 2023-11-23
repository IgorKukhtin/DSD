unit Report_CollationByPartner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport_boat, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCurrencyEdit, DataModul, frxClass, frxDBSet, dsdGuides, cxButtonEdit,
  dxSkinsCore, cxImageComboBox, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TReport_CollationByPartnerForm = class(TAncestorReport_boatForm)
    ItemName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    Debet: TcxGridDBColumn;
    Kredit: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    actPrintOfficial: TdsdPrintAction;
    bbPrintOfficial: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actOpenForm: TdsdOpenForm;
    actGetForm: TdsdExecStoredProc;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    AccountName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyGroupCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationCode: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    spJuridicalBalance: TdsdStoredProc;
    cxLabel3: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel4: TcxLabel;
    edAccount: TcxButtonEdit;
    GuidesAccount: TdsdGuides;
    StartRemains: TcxGridDBColumn;
    EndRemains: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    actPrintTurnover: TdsdPrintAction;
    bbPrintTurnover: TdxBarButton;
    MovementSumm: TcxGridDBColumn;
    OperationSort: TcxGridDBColumn;
    actPrintCurrency: TdsdPrintAction;
    bbPrintCurrency: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    MovementComment: TcxGridDBColumn;
    macPrint: TMultiAction;
    actSPSaveObject: TdsdExecStoredProc;
    spSavePrintObject: TdsdStoredProc;
    bbIsInsert: TdxBarControlContainerItem;
    macPrintOfficial: TMultiAction;
    macPrintCurrency: TMultiAction;
    bbIsUpdate: TdxBarControlContainerItem;
    actOpenProtocol: TdsdOpenForm;
    bbOpenProtocol: TdxBarButton;
    PartnerName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_CollationByPartnerForm)

end.
