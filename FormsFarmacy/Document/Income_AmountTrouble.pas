unit Income_AmountTrouble;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter, cxCalc,
  cxButtonEdit, dsdAction, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, dsdDB, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit;

type
  TIncome_AmountTroubleForm = class(TAncestorEnumForm)
    FormParams: TdsdFormParams;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    PartnerGoodsCode: TcxGridDBColumn;
    PartnerGoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountManual: TcxGridDBColumn;
    AmountDiff: TcxGridDBColumn;
    ReasonDifferencesName: TcxGridDBColumn;
    actReasonDifferences: TOpenChoiceForm;
    actSetEqual: TdsdExecStoredProc;
    spUpdate_MovementItem_Income_AmountManual: TdsdStoredProc;
    dsdUpdateDataSet1: TdsdUpdateDataSet;
    PretensionAmount: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  Registerclass(TIncome_AmountTroubleForm)
end.
