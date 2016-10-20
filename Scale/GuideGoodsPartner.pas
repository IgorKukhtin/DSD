unit GuideGoodsPartner;

interface

uses
  GuideGoods, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, Data.DB, Datasnap.DBClient, dsdDB, cxTextEdit,
  cxCurrencyEdit, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxDBData, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, dsdAddOn,
  Vcl.ActnList
 ,UtilScale,DataModul;

type
  TGuideGoodsPartnerForm = class(TGuideGoodsForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GuideGoodsPartnerForm: TGuideGoodsPartnerForm;

implementation

{$R *.dfm}
{------------------------------------------------------------------------------}
procedure TGuideGoodsPartnerForm.FormCreate(Sender: TObject);
begin
  // Временно захардкодил
  Self.Tag:=-123;
  //
  inherited;

end;
{------------------------------------------------------------------------------}
end.
