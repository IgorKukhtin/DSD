unit SendCashSUN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Send, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxButtonEdit, cxCheckBox,
  cxCurrencyEdit, cxCalc, cxCalendar, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, dsdGuides, dsdDB, Vcl.Menus,
  dxBar, dxBarExtItems, cxClasses, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxMaskEdit, cxDropDownEdit, cxLabel, cxTextEdit,
  Vcl.ExtCtrls, cxSplitter, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC;

type
  TSendCashSUNForm = class(TSendForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SendCashSUNForm: TSendCashSUNForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendCashSUNForm);

end.
