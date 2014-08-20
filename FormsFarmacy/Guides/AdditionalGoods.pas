unit AdditionalGoods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorGuides, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxButtonEdit, cxSplitter,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, Vcl.Menus,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGrid, cxPC, cxPCdxBarPopupMenu, cxContainer, cxLabel, cxTextEdit, cxMaskEdit,
  dsdGuides, dsdActionOld, dsdStorageAction;

type
  TAdditionalGoodsForm = class(TAncestorGuidesForm)
    clObjectCode: TcxGridDBColumn;
    clValueData: TcxGridDBColumn;
    cxGrid1: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    clValueData1: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    cxGrid2: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    clValueData2: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    ClientDS: TDataSource;
    spAdditionalGoods: TdsdStoredProc;
    ClientCDS: TClientDataSet;
    ClientMasterDS: TDataSource;
    spAdditioanlGoodsClient: TdsdStoredProc;
    ClientMasterCDS: TClientDataSet;
    RetailGuides: TdsdGuides;
    AdditionalGoodsDBViewAddOn: TdsdDBViewAddOn;
    AdditionalGoodsClientDBViewAddOn: TdsdDBViewAddOn;
    actGoodsChoice: TOpenChoiceForm;
    actInsertUpdateLink: TdsdUpdateDataSet;
    spInsertUpdateGoodsLink: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TAdditionalGoodsForm);

end.
