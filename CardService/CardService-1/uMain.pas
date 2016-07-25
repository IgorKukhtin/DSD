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
    eBarCode: TEdit;
    Label4: TLabel;
    eResult: TEdit;
    eCardNumRes: TEdit;
    eResultChangePercent: TEdit;
    eResultSummChangePercent: TEdit;
    eResultRequestedPrice: TEdit;
    eResultRequestedQuantity: TEdit;
    lRequestedQuantity: TLabel;
    lRequestedPrice: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    bCommit: TButton;
    procedure bCheckCardClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bCheckSaleClick(Sender: TObject);
    procedure eCardNumChange(Sender: TObject);
    procedure bCommitClick(Sender: TObject);
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

    Price.XSToNative('1000');
    Item.RequestedPrice := Price;
    Quantity.XSToNative('1');
    Item.RequestedQuantity := Quantity;
    Amount.XSToNative('1');
    Item.RequestedAmount := Amount;

    SetLength(SendList, 1);
    SendList[0] := Item;

    ResList := (HTTPRIO1 as CardServiceSoap).checkCardSale(SendList, eLogin.Text, ePassword.Text);

    ResItem := ResList[0];
    eResult.Text:= ResItem.ResultDescription;
    eResultChangePercent.Text:= FloatToStr(ResItem.ResultDiscountPercent);
    eResultSummChangePercent.Text:= FloatToStr(ResItem.ResultDiscountAmount);

    eResultRequestedQuantity.Text:= ResItem.RequestedQuantity.DecimalString;
    eResultRequestedPrice.Text:= ResItem.RequestedPrice.DecimalString;
  finally
    FreeAndNil(Price);
    FreeAndNil(Quantity);
    FreeAndNil(Amount);
    Item := nil;
    ResItem := nil;
  end;
end;



procedure TfrmMain.bCommitClick(Sender: TObject);
var
  i : integer;
  aSaleRequest : CardSaleRequest;
  SendList : ArrayOfCardSaleRequestItem;
  Item : CardSaleRequestItem;
  SaleRes : CardSaleResult;
begin
  aSaleRequest := CardSaleRequest.Create;
  Item := CardSaleRequestItem.Create;

  SaleRes := CardSaleResult.Create;
  try
    aSaleRequest.CheckId := '1';
    aSaleRequest.CheckCode := '1';
    aSaleRequest.CheckDate := TXSDateTime.Create;
    aSaleRequest.CheckDate.AsDateTime := Now();
    aSaleRequest.MdmCode := eCardNum.Text;
    aSaleRequest.SaleType := '0';

    // products
    Item.ItemId := '1';
    Item.MdmCode := eCardNum.Text;
    Item.ProductFormCode := eBarCode.Text;
    Item.SaleType := '0';
    Item.PrimaryPrice := TXSDecimal.Create;
    Item.PrimaryPrice.XSToNative('100');
    Item.RequestedPrice := TXSDecimal.Create;
    Item.RequestedPrice.XSToNative(FloatToStr(100*(100-10)/100));

    Item.PrimaryAmount := TXSDecimal.Create;
    Item.PrimaryAmount.XSToNative('200');
    Item.RequestedAmount := TXSDecimal.Create;
    Item.RequestedAmount.XSToNative(FloatToStr(200 - 90));

    Item.RequestedQuantity := TXSDecimal.Create;
    Item.RequestedQuantity.XSToNative('2');

    SetLength(SendList, 1);
    SendList[0] := Item;

    aSaleRequest.Items := SendList;

    SaleRes := (HTTPRIO1 as CardServiceSoap).commitCardSale(aSaleRequest, eLogin.Text, ePassword.Text);
  finally
    FreeAndNil(aSaleRequest);
    FreeAndNil(SaleRes);
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
