unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBar, cxClasses, Vcl.ActnList,
  Vcl.StdActns, Vcl.StdCtrls, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  dsdActionUnit, cxLocalization;

type
  TMainForm = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    bbExit: TdxBarButton;
    bbGoodsGuides: TdxBarButton;
    bbDocuments: TdxBarSubItem;
    bbGuides: TdxBarSubItem;
    ActionList: TActionList;
    actExit: TFileExit;
    actMeasure: TdsdOpenForm;
    bbMeasure: TdxBarButton;
    cxLocalizer: TcxLocalizer;
    actJuridicalGroup: TdsdOpenForm;
    bbJuridicalGroup: TdxBarButton;
    actGoodsProperty: TdsdOpenForm;
    bbGoodsProperty: TdxBarButton;
    bbJuridical: TdxBarButton;
    actJuridical: TdsdOpenForm;
    actBusiness: TdsdOpenForm;
    bbBusiness: TdxBarButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses FormUnit, dsdDataSetWrapperUnit, StorageUnit, CommonDataUnit;

{$R DevExpressRus.res}

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Локализуем сообщения DevExpress
  cxLocalizer.Active:= True;
  cxLocalizer.Locale:= 1049;
end;

end.
