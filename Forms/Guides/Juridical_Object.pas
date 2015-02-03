unit Juridical_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  dsdDB, Datasnap.DBClient, dsdAddOn, dsdAction,
  Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxCheckBox;

type
  TJuridical_ObjectForm = class(TParentForm)
    cxSplitter: TcxSplitter;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    ceCode: TcxGridDBColumn;
    ceName: TcxGridDBColumn;
    ceIsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbChoiceGuides: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel: TdsdGridToExcel;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    GridDS: TDataSource;
    MasterCDS: TClientDataSet;
    GridStoredProc: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    clInfoMoneyGroupCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationCode: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    clGLNCode: TcxGridDBColumn;
    clOKPO: TcxGridDBColumn;
    clIsCorporate: TcxGridDBColumn;
    clJuridicalGroupName: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TJuridical_ObjectForm);
end.
