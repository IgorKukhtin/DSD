unit PromoTradeJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxImageComboBox,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdDB,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, dsdGuides, cxButtonEdit,
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
  dxSkinXmas2008Blue, dsdCommon;

type
  TPromoTradeJournalForm = class(TAncestorJournalForm)
    PromoKindName: TcxGridDBColumn;
    PriceListName: TcxGridDBColumn;
    StartPromo: TcxGridDBColumn;
    EndPromo: TcxGridDBColumn;
    CostPromo: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    spSelect_Movement_PromoTrade_Print: TdsdStoredProc;
    PrintHead: TClientDataSet;
    actPrint: TdsdPrintAction;
    ContractName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spInsertUpdateMISign_Yes: TdsdStoredProc;
    spInsertUpdateMISign_No: TdsdStoredProc;
    actInsertUpdateMISignYes: TdsdExecStoredProc;
    mactInsertUpdateMISignYes: TMultiAction;
    mactInsertUpdateMISignYesList: TMultiAction;
    actInsertUpdateMISignNo: TdsdExecStoredProc;
    mactInsertUpdateMISignNo: TMultiAction;
    mactInsertUpdateMISignNoList: TMultiAction;
    bbInsertUpdateMISignYesList: TdxBarButton;
    bbInsertUpdateMISignNoList: TdxBarButton;
    actAllPartner: TBooleanStoredProcAction;
    bbAllPartner: TdxBarButton;
    actRefreshPartner: TdsdDataSetRefresh;
    actInsertMaskMulti: TMultiAction;
    JuridicalName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    PromoTradeStateKindName: TcxGridDBColumn;
    Checked: TcxGridDBColumn;
    CheckDate: TcxGridDBColumn;
    PrintSignCDS: TClientDataSet;
    spGet_SignPrint: TdsdStoredProc;
    actGet_SignPrint: TdsdExecStoredProc;
    macPrint: TMultiAction;
    SignInternalName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoTradeJournalForm);

end.
