unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBar, cxClasses, Vcl.ActnList,
  Vcl.StdActns, Vcl.StdCtrls, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  dsdAction, cxLocalization;

type
  TMainForm = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    bbExit: TdxBarButton;
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
    actBranch: TdsdOpenForm;
    bbBranch: TdxBarButton;
    actPartner: TdsdOpenForm;
    actIncome: TdsdOpenForm;
    bbIncome: TdxBarButton;
    bbPartner: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    actPaidKind: TdsdOpenForm;
    actContractKind: TdsdOpenForm;
    actUnitGroup: TdsdOpenForm;
    actUnit: TdsdOpenForm;
    actGoodsGroup: TdsdOpenForm;
    actGoods: TdsdOpenForm;
    actGoodsKind: TdsdOpenForm;
    bbPaidKind: TdxBarButton;
    bbContractKind: TdxBarButton;
    bbUnitGroup: TdxBarButton;
    bbUnit: TdxBarButton;
    bbGoodsGroup: TdxBarButton;
    bbGoods: TdxBarButton;
    actBank: TdsdOpenForm;
    actBankAccount: TdsdOpenForm;
    actCash: TdsdOpenForm;
    actCurrency: TdsdOpenForm;
    bbGoodsKind: TdxBarButton;
    actBalance: TdsdOpenForm;
    bbBalance: TdxBarButton;
    bbReports: TdxBarSubItem;
    bbBank: TdxBarButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation

uses ParentForm, dsdDB, Storage, CommonData;

{$R DevExpressRus.res}

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Локализуем сообщения DevExpress
  cxLocalizer.Active:= True;
  cxLocalizer.Locale:= 1049;
end;

end.
