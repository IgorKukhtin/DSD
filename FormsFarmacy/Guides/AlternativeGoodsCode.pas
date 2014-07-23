unit AlternativeGoodsCode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorGuides, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxButtonEdit, cxSplitter,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, Vcl.Menus,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGrid, cxPC;

type
  TAlternativeGoodsCodeForm = class(TAncestorGuidesForm)
    cxGridDBTableView1: TcxGridDBTableView;
    clIName: TcxGridDBColumn;
    clImportTypeItemsName: TcxGridDBColumn;
    clIisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    clObjectCode: TcxGridDBColumn;
    clValueData: TcxGridDBColumn;
    cxGrid1: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    clValueData1: TcxGridDBColumn;
    clObjectCode1: TcxGridDBColumn;
    clisErased1: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    cxGrid2: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    clObjectCode2: TcxGridDBColumn;
    clValueData2: TcxGridDBColumn;
    clisErased2: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    clGoodsMain: TcxGridDBColumn;
    clGoods: TcxGridDBColumn;
    clRetail: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlternativeGoodsCodeForm: TAlternativeGoodsCodeForm;

implementation

{$R *.dfm}

end.
