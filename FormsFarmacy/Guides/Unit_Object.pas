unit Unit_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox,
  dsdAddOn, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxSplitter;

type
  TUnit_ObjectForm = class(TParentForm)
    cxSplitter1: TcxSplitter;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    ceCode: TcxGridDBColumn;
    ceName: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    ceIsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbChoice: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdChoiceGuides: TdsdChoiceGuides;
    GridDS: TDataSource;
    ClientDataSet: TClientDataSet;
    spGrid: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    clParentName: TcxGridDBColumn;
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
