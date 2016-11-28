unit PersonalPosition_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm,
  DataModul, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCheckBox, dsdAddOn, dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, ChoicePeriod, dsdGuides,
  cxButtonEdit;

type
  TPersonalPosition_ObjectForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clMemberCode: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    clDateIn: TcxGridDBColumn;
    clDateOut: TcxGridDBColumn;
    clMemberName: TcxGridDBColumn;
    clPositionName: TcxGridDBColumn;
    clUnitName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    clErased: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    clPersonalGroupName: TcxGridDBColumn;
    clPositionLevelName: TcxGridDBColumn;
    clIsOfficial: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    dxBarControlContainerItem4: TdxBarControlContainerItem;
    clIsDateOut: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    clIsMain: TcxGridDBColumn;
    clDriverCertificate: TcxGridDBColumn;
    PersonalServiceListName: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    edPosition: TcxButtonEdit;
    PositionGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TPersonalPosition_ObjectForm);
end.
