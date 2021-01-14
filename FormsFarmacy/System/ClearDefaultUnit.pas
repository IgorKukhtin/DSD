unit ClearDefaultUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorBase, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dsdAddOn, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters, dsdDB,
  Vcl.StdCtrls, cxButtons, cxControls, cxContainer, cxEdit, cxLabel;

type
  TClearDefaultUnitForm = class(TAncestorBaseForm)
    actFormClose: TdsdFormClose;
    cxButton2: TcxButton;
    cxButton1: TcxButton;
    actFormCloseAndClear: TdsdFormClose;
    spClearDefaultUnit: TdsdStoredProc;
    actClearDefaultUnit: TdsdExecStoredProc;
    cxLabel1: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClearDefaultUnitForm: TClearDefaultUnitForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TClearDefaultUnitForm);

end.
