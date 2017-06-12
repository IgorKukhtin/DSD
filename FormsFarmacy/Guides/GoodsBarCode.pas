unit GoodsBarCode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  DataModul, dxSkinsdxBarPainter, dxBar, cxPropertiesStore, Datasnap.DBClient, dxBarExtItems,
  dsdAddOn, dsdDB, ExternalLoad, dsdAction, Vcl.ActnList;

type
  TGoodsBarCodeForm = class(TParentForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    ActionList: TActionList;
    actGetImportSetting: TdsdExecStoredProc;
    actRefresh: TdsdDataSetRefresh;
    dsdGridToExcel: TdsdGridToExcel;
    actUpdateDataSet: TdsdUpdateDataSet;
    actStartLoad: TMultiAction;
    actDoLoad: TExecuteImportSettingsAction;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dxBarButtonRefresh: TdxBarButton;
    dxBarManagerBar1: TdxBar;
    dxBarButtonGridToExcel: TdxBarButton;
    spInsertUpdate: TdsdStoredProc;
    Id: TcxGridDBColumn;
    GoodsId: TcxGridDBColumn;
    GoodsMainId: TcxGridDBColumn;
    GoodsBarCodeId: TcxGridDBColumn;
    GoodsJuridicalId: TcxGridDBColumn;
    JuridicalId: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    ProducerName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    BarCode: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    spGetImportSettingId: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spInsertUpdateLoad: TdsdStoredProc;
    dxBarButtonLoad: TdxBarButton;
    ErrorText: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsBarCodeForm);
end.
