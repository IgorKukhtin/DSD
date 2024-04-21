unit RoleUnion;

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
  dxSkinXmas2008Blue, cxCurrencyEdit;

type
  TRoleUnionForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clCode: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    clErased: TcxGridDBColumn;
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
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    actGridToExcel: TdsdGridToExcel;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdStoredProc: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    spErasedUnErased: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLeftSplitter: TcxSplitter;
    spAction: TdsdStoredProc;
    ActionDS: TDataSource;
    ActionCDS: TClientDataSet;
    ActionAddOn: TdsdDBViewAddOn;
    UserChoiceForm: TOpenChoiceForm;
    UserUpdateDataSet: TdsdUpdateDataSet;
    spInsertUpdateRoleAction: TdsdStoredProc;
    ActionChoiceForm: TOpenChoiceForm;
    ActionUpdateDataSet: TdsdUpdateDataSet;
    ProcessChoiceForm: TOpenChoiceForm;
    ProcessUpdateDataSet: TdsdUpdateDataSet;
    ProcessAccessChoiceForm: TOpenChoiceForm;
    ProcessAccessUpdateDataSet: TdsdUpdateDataSet;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    colProcess_EnumName: TcxGridDBColumn;
    Panel1: TPanel;
    RoleGrid: TcxGrid;
    RoleGridView: TcxGridDBTableView;
    cxGridDBColumn5: TcxGridDBColumn;
    RoleGridLevel: TcxGridLevel;
    cldescName: TcxGridDBColumn;
    UserDS: TDataSource;
    UserCDS: TClientDataSet;
    cxGridUser: TcxGrid;
    cxGridDBTableViewUser: TcxGridDBTableView;
    Code_ch3: TcxGridDBColumn;
    Name_ch3: TcxGridDBColumn;
    MemberName_ch3: TcxGridDBColumn;
    BranchCode_ch3: TcxGridDBColumn;
    BranchName_ch3: TcxGridDBColumn;
    UnitCode_ch3: TcxGridDBColumn;
    UnitName_ch3: TcxGridDBColumn;
    PositionName_ch3: TcxGridDBColumn;
    isErased_ch3: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    spSelectUser: TdsdStoredProc;
    dsdDBViewAddOnUser: TdsdDBViewAddOn;
    RoleName: TcxGridDBColumn;
    actGridToExcel_User: TdsdGridToExcel;
    actGridToExcel_Role: TdsdGridToExcel;
    bbGridToExcel_Role: TdxBarButton;
    bbGridToExcel_User: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRoleUnionForm);

end.
