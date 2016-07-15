unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Soap.InvokeRegistry, Vcl.StdCtrls,
  Soap.Rio, Soap.SOAPHTTPClient, uCardService;

const
  cURL = 'http://exim.demo.mdmworld.com/CardService.asmx?WSDL';
  cService = 'CardService';
  cPort = 'CardServiceSoap';

type
  TfrmMain = class(TForm)
    HTTPRIO1: THTTPRIO;
    bCheckCard: TButton;
    eLogin: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ePassword: TEdit;
    Label3: TLabel;
    eCardNum: TEdit;
    bCheckSale: TButton;
    procedure bCheckCardClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bCheckSaleClick(Sender: TObject);
    procedure eCardNumChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.bCheckCardClick(Sender: TObject);
var
  res : string;
begin
   Self.Cursor := crHourGlass;
   Application.ProcessMessages;

   res := (HTTPRIO1 as CardServiceSoap).checkCard(eCardNum.Text, eLogin.Text, ePassword.Text);

   if res = 'Продажа доступна' then
     bCheckSale.Enabled := true
   else
     bCheckSale.Enabled := false;

   Self.Cursor := crDefault;
end;

procedure TfrmMain.bCheckSaleClick(Sender: TObject);
var
  SendList : ArrayOfCardCheckItem;
  ResList : ArrayOfCardCheckResultItem;
  Item : CardCheckItem;
begin
  Item := CardCheckItem.Create;

  ResList := (HTTPRIO1 as CardServiceSoap).checkCardSale(SendList, eLogin.Text, ePassword.Text);
end;

procedure TfrmMain.eCardNumChange(Sender: TObject);
begin
  bCheckSale.Enabled := false;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  HTTPRIO1.WSDLLocation := cURL;
  HTTPRIO1.Service := cService;
  HTTPRIO1.Port := cPort;

  bCheckSale.Enabled := false;
end;

end.
