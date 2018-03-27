unit Role;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn, dsdDB,
  dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore,
  Datasnap.DBClient, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxSplitter, Vcl.ExtCtrls,
  cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  TRoleForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    Erased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoice: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    actGridToExcel: TdsdGridToExcel;
    actChoiceGuides: TdsdChoiceGuides;
    dsdStoredProc: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    spErased: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLeftSplitter: TcxSplitter;
    ProcessDS: TDataSource;
    ProcessCDS: TClientDataSet;
    ProcessAddOn: TdsdDBViewAddOn;
    spAction: TdsdStoredProc;
    Panel1: TPanel;
    UserGrid: TcxGrid;
    UserView: TcxGridDBTableView;
    CodeUser: TcxGridDBColumn;
    NameUser: TcxGridDBColumn;
    UserLevel: TcxGridLevel;
    ActionDS: TDataSource;
    ActionCDS: TClientDataSet;
    ActionAddOn: TdsdDBViewAddOn;
    spProcess: TdsdStoredProc;
    ActionGrid: TcxGrid;
    ActionGridView: TcxGridDBTableView;
    cxGridDBColumn5: TcxGridDBColumn;
    ActionGridLevel: TcxGridLevel;
    ProcessGrid: TcxGrid;
    ProcessView: TcxGridDBTableView;
    cxGridDBColumn8: TcxGridDBColumn;
    ProcessLevel: TcxGridLevel;
    UserCDS: TClientDataSet;
    UserDS: TDataSource;
    spRoleUser: TdsdStoredProc;
    UserAddOn: TdsdDBViewAddOn;
    actUserChoiceForm: TOpenChoiceForm;
    spInsertUpdateUserRole: TdsdStoredProc;
    actUpdateDataSetUser: TdsdUpdateDataSet;
    cxSplitterTop: TcxSplitter;
    cxSplitterClient: TcxSplitter;
    spInsertUpdateRoleAction: TdsdStoredProc;
    actActionChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    actProcessChoiceForm: TOpenChoiceForm;
    actUpdateDataSetProcess: TdsdUpdateDataSet;
    spInsertUpdateRoleProcess: TdsdStoredProc;
    Process_EnumName: TcxGridDBColumn;
    ProcessAccessViewAddOn: TdsdDBViewAddOn;
    ProcessAccessCDS: TClientDataSet;
    ProcessAccessDS: TDataSource;
    spProcessAccess: TdsdStoredProc;
    spInsertUpdateProcessAccess: TdsdStoredProc;
    AccessGrid: TcxGrid;
    AccessGridDBTableView: TcxGridDBTableView;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    AccessGridLevel: TcxGridLevel;
    actProcessAccessChoiceForm: TOpenChoiceForm;
    actProcessAccessUpdateDataSet: TdsdUpdateDataSet;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    isErased: TcxGridDBColumn;
    actProtocol: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    actProtocolAction: TdsdOpenForm;
    actProtocolProcess: TdsdOpenForm;
    bbProtocolAction: TdxBarButton;
    bbProtocolProcess: TdxBarButton;
    actProtocolProcessAccess: TdsdOpenForm;
    bbProtocolProcessAccess: TdxBarButton;
    actProtocolUser: TdsdOpenForm;
    bbProtocolUser: TdxBarButton;
    spUnErased: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRoleForm);

end.
