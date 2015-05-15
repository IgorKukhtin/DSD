unit GuideGoodsMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, DataModul, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GuideGoods, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, Data.DB, Datasnap.DBClient, dsdDB, cxTextEdit,
  cxCurrencyEdit, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxDBData, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, dsdAddOn;

type
  TGuideGoodsMovementForm = class(TGuideGoodsForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GuideGoodsMovementForm: TGuideGoodsMovementForm;

implementation

{$R *.dfm}

end.
