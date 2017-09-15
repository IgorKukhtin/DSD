unit Unit_Object;

interface

uses
  Winapi.Windows, AncestorEnum, DataModul, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn, dsdDB,
  Datasnap.DBClient, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, Vcl.Controls, cxGrid,
  cxPCdxBarPopupMenu, Vcl.Menus, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit, dxSkinBlack,
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
  cxButtonEdit, cxCalendar;

type
  TUnit_ObjectForm = class(TAncestorEnumForm)
    JuridicalName: TcxGridDBColumn;
    ParentName: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    spUpdate_Unit_isOver: TdsdStoredProc;
    isOver: TcxGridDBColumn;
    actUpdateisOver: TdsdExecStoredProc;
    bbUpdateisOver: TdxBarButton;
    spUpdateisOverYes: TdsdExecStoredProc;
    macUpdateisOverYes: TMultiAction;
    bbUpdateisOverList: TdxBarButton;
    spUpdate_Unit_isOver_Yes: TdsdStoredProc;
    spUpdate_Unit_isOver_No: TdsdStoredProc;
    spUpdateisOverNo: TdsdExecStoredProc;
    macUpdateisOverNo: TMultiAction;
    bbUpdateisOverNoList: TdxBarButton;
    isUploadBadm: TcxGridDBColumn;
    spUpdate_Unit_isUploadBadm: TdsdStoredProc;
    actUpdateisUploadBadm: TdsdExecStoredProc;
    bbUpdateisUploadBadm: TdxBarButton;
    isMarginCategory: TcxGridDBColumn;
    spUpdate_Unit_isMarginCategory: TdsdStoredProc;
    actUpdateisMarginCategory: TdsdExecStoredProc;
    bbisMarginCategory: TdxBarButton;
    spUpdate_Unit_isReport: TdsdStoredProc;
    actUpdateisReport: TdsdExecStoredProc;
    bbUpdateisReport: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    bb: TdxBarButton;
    Address: TcxGridDBColumn;
    CreateDate: TcxGridDBColumn;
    CloseDate: TcxGridDBColumn;
    UserManagerName: TcxGridDBColumn;
    actOpenUserForm: TOpenChoiceForm;
    spUpdate_Unit_Params: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TUnit_ObjectForm);
end.
