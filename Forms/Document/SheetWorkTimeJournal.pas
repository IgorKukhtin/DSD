unit SheetWorkTimeJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, ParentForm, dsdDB, dsdAction,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxImageComboBox, Vcl.Menus, dsdAddOn, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarExtItems, cxCurrencyEdit, ChoicePeriod, System.Contnrs, cxLabel,
  cxButtonEdit, dsdGuides, cxCheckBox, dsdCommon;

type
  TSheetWorkTimeJournalForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spSelect: TdsdStoredProc;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    OperDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel2: TcxLabel;
    cxLabel1: TcxLabel;
    UpdateAction: TdsdInsertUpdateAction;
    bbStatic: TdxBarStatic;
    bbEdit: TdxBarButton;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    OperDate_detail: TcxGridDBColumn;
    InvNumber_detail: TcxGridDBColumn;
    cbDetail: TcxCheckBox;
    spUpdate_CheckedHead: TdsdStoredProc;
    spUpdate_CheckedPersonal: TdsdStoredProc;
    macUpdateCheckedHead: TMultiAction;
    actUpdate_CheckedHead: TdsdExecStoredProc;
    actUpdate_CheckedPersonal: TdsdExecStoredProc;
    macUpdateCheckedPersonal: TMultiAction;
    bbUpdateCheckedHead: TdxBarButton;
    bbUpdateCheckedPersonal: TdxBarButton;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocolOpenForm: TdxBarButton;
    MovementProtocolOpenForm1: TdsdOpenForm;
    spPUSHMessage_1: TdsdStoredProc;
    actPUSHMessage: TdsdShowPUSHMessage;
    spPUSHMessage_2: TdsdStoredProc;
    spPUSHMessage_3: TdsdStoredProc;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSheetWorkTimeJournalForm);

end.
