unit Report_GoodsRemainsCashDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Report_RemainGoodsDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, dsdDB, dsdAction, Vcl.ActnList, dsdGuides, cxPropertiesStore,
  dsdAddOn, ChoicePeriod, cxCheckBox, cxLabel, cxButtonEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.StdCtrls, cxButtons;

type
  TReport_GoodsRemainsCashDialogForm = class(TReport_GoodsRemainsDialogForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_GoodsRemainsCashDialogForm);

end.
