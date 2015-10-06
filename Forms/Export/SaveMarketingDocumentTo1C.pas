unit SaveMarketingDocumentTo1C;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, Vcl.ActnList,
  dsdAction, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, ExternalSave, Data.DB,
  Datasnap.DBClient, cxLabel, ChoicePeriod, dsdGuides, cxButtonEdit,
  Vcl.Grids, Vcl.DBGrids, dxSkinsCore, dxSkinsDefaultPainters;

type
  TSaveMarketingDocumentTo1CForm = class(TAncestorDialogForm)
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    AccountExternal: TClientDataSet;
    ExternalSaveAction: TExternalSaveAction;
    actClose: TdsdFormClose;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    PeriodChoice: TPeriodChoice;
    spReport_AccountExternal: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TSaveMarketingDocumentTo1CForm);

end.
