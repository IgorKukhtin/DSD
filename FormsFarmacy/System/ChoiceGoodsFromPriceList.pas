unit ChoiceGoodsFromPriceList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AncestorEnum, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPC, cxContainer, cxTextEdit,
  cxLabel, cxCurrencyEdit, cxButtonEdit, Vcl.DBActns, cxMaskEdit, Vcl.ExtCtrls,
  dxBarBuiltInMenu, cxNavigator;

type
  TChoiceGoodsFromPriceListForm = class(TAncestorEnumForm)
    edGoodsSearch: TcxTextEdit;
    cxLabel1: TcxLabel;
    colCommonCode: TcxGridDBColumn;
    colBarCode: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colProducerName: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    ChoiceGoodsForm: TOpenChoiceForm;
    UpdateDataSet: TdsdUpdateDataSet;
    spSetPriceListLink: TdsdStoredProc;
    spGoodsPriceListLink: TdsdStoredProc;
    actSetGoodsLink: TdsdExecStoredProc;
    bbGoodsPriceListLink: TdxBarButton;
    mactChoiceGoodsForm: TMultiAction;
    colContractName: TcxGridDBColumn;
    colExpirationDate: TcxGridDBColumn;
    colMinimumLot: TcxGridDBColumn;
    colNDS: TcxGridDBColumn;
    colGoodsNDS: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    Panel1: TPanel;
    actDeleteLink: TdsdExecStoredProc;
    spDeleteLink: TdsdStoredProc;
    colMargin: TcxGridDBColumn;
    colCashPrice: TcxGridDBColumn;
    edProducerSearch: TcxTextEdit;
    cxLabel2: TcxLabel;
    actRefreshSearch2: TdsdExecStoredProc;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TChoiceGoodsFromPriceListForm);

end.
