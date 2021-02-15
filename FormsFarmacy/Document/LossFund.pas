unit LossFund;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loss, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxContainer,
  Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, dsdGuides,
  dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCheckBox;

type
  TLossFundForm = class(TLossForm)
    ceSummaFund: TcxCurrencyEdit;
    ceRetailFundResidue: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    spUpdate_SummaFund: TdsdStoredProc;
    actAmountDialog: TExecuteDialog;
    actRefreshGet: TdsdExecStoredProc;
    bbUpdate_SummaFund: TdxBarButton;
    ceRetailFundUsed: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    ceRetailFund: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    HeaderSaverFund: THeaderSaver;
    ceTotalSumm: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLossFundForm);

end.
