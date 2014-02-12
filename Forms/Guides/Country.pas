unit Country;

interface

uses
  AncestorDBGrid, DataModul, AncestorData, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxBarPainter, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, Vcl.Controls, cxGrid, dxBarExtItems, dxBar,
  dsdDB, Datasnap.DBClient, System.Classes, Vcl.ActnList, dsdAction,
  cxPropertiesStore;

type
  TCountryForm = class(TAncestorDataForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    dsdStoredProc: TdsdStoredProc;
    spErasedUnErased: TdsdStoredProc;
    cxGridDBTableView: TcxGridDBTableView;
    clCode: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    clErased: TcxGridDBColumn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    spInsertUpdateObject: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCountryForm);

end.
