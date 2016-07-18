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
    LabelResult: TLabel;
    eBarCode: TEdit;
    Label4: TLabel;
    eResult: TEdit;
    eCardNumRes: TEdit;
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
uses Soap.XSBuiltIns;
{$R *.dfm}

procedure TfrmMain.bCheckCardClick(Sender: TObject);
var
  res : string;
begin
   Self.Cursor := crHourGlass;
   Application.ProcessMessages;

   res := (HTTPRIO1 as CardServiceSoap).checkCard(eCardNum.Text, eLogin.Text, ePassword.Text);

   eCardNumRes.Text := res;

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
  ResItem : CardCheckResultItem;
  Price, Quantity, Amount : TXSDecimal;
begin
  Item := CardCheckItem.Create;
  ResItem := CardCheckResultItem.Create;
  Price := TXSDecimal.Create;
  Quantity := TXSDecimal.Create;
  Amount := TXSDecimal.Create;
  try
    Item.MdmCode := eCardNum.Text;
    Item.ProductFormCode := eBarCode.Text;
    Item.SaleType := '1';

    Price.XSToNative('100');
    Item.RequestedPrice := Price;
    Quantity.XSToNative('1');
    Item.RequestedQuantity := Quantity;
    Amount.XSToNative('1');
    Item.RequestedAmount := Amount;

    SetLength(SendList, 1);
    SendList[0] := Item;

    ResList := (HTTPRIO1 as CardServiceSoap).checkCardSale(SendList, eLogin.Text, ePassword.Text);

    ResItem := ResList[0];
    LabelResult.Caption:= FloatToStr(ResItem.ResultDiscountPercent);
    eResult.Text:= ResItem.ResultDescription;
  finally
    FreeAndNil(Price);
    FreeAndNil(Quantity);
    FreeAndNil(Amount);
    Item := nil;
    ResItem := nil;
  end;
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
