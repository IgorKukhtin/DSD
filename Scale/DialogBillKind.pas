unit DialogBillKind;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TDialogBillKindForm = class(TForm)
    gbPartnerAll: TGroupBox;
    PanelPartner: TPanel;
    LabelPartner: TLabel;
    gbPartnerCode: TGroupBox;
    EditPartnerCode: TEdit;
    gbPartnerName: TGroupBox;
    PanelPartnerName: TPanel;
    PanelRouteUnit: TPanel;
    LabelRouteUnit: TLabel;
    gbRouteUnitCode: TGroupBox;
    EditRouteUnitCode: TEdit;
    gbRouteUnitName: TGroupBox;
    PanelRouteUnitName: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DialogBillKindForm: TDialogBillKindForm;

implementation

{$R *.dfm}

end.
