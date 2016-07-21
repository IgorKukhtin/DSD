unit DiscountService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Soap.InvokeRegistry, Vcl.StdCtrls,
  Soap.Rio, Soap.SOAPHTTPClient, uCardService;

type
  TDiscountServiceForm = class(TForm)
    HTTPRIO: THTTPRIO;
  private
    { Private declarations }
  public
    gURL, gService, gPort, gUserName, gPassword, gCardNumber : String; // так криво сохраним "текущие параметры"
    function fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string) :Boolean;
    function fGetSale (var lMsg : string; var lChangePercent, lSummChangePercent : Double;
                       lBarCode : string; lPrice, lQuantity, lAmount : Double) :Boolean;
  end;

var
  DiscountServiceForm: TDiscountServiceForm;

implementation
{$R *.dfm}
uses Soap.XSBuiltIns;

function TDiscountServiceForm.fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string) :Boolean;
begin
  Result:=false;
  lMsg:='';
  //
  try
      Self.Cursor := crHourGlass;
      Application.ProcessMessages;
      //
      HTTPRIO.WSDLLocation := lURL;
      HTTPRIO.Service := lService;
      HTTPRIO.Port := lPort;
      //
      Application.ProcessMessages;
      //
      lMsg := (HTTPRIO as CardServiceSoap).checkCard(lCardNumber, lUserName, lPassword);
      Result:= LowerCase(lMsg) = LowerCase('Продажа доступна');
      //
      if not Result then ShowMessage ('Ошибка.Карта № <' + lCardNumber + '>.' + #10+ #13 + lMsg);

  finally
     Self.Cursor := crDefault;
     // так криво сохраним "текущие" параметры
     if Result then
     begin
          gURL        := lURL;
          gService    := lService;
          gPort       := lPort;
          gUserName   := lUserName;
          gPassword   := lPassword;
          gCardNumber := lCardNumber;
     end
     else
     begin
          gURL        := '';
          gService    := '';
          gPort       := '';
          gUserName   := '';
          gPassword   := '';
          gCardNumber := '';
     end;

  end;
end;

function TDiscountServiceForm.fGetSale (var lMsg : string; var lChangePercent, lSummChangePercent : Double;
                                        lBarCode : string; lPrice, lQuantity, lAmount : Double) :Boolean;
var
  SendList : ArrayOfCardCheckItem;
  ResList : ArrayOfCardCheckResultItem;
  Item : CardCheckItem;
  ResItem : CardCheckResultItem;
  Price, Quantity, Amount : TXSDecimal;
begin
  Result:=false;
  lMsg:='';
  //
  Item := CardCheckItem.Create;
  ResItem := CardCheckResultItem.Create;
  Price := TXSDecimal.Create;
  Quantity := TXSDecimal.Create;
  Amount := TXSDecimal.Create;
  try
    Item.MdmCode := gCardNumber;
    Item.ProductFormCode := lBarCode;
    Item.SaleType := '1'; // ???????

    Price.XSToNative(FloatToStr(lPrice));
    Item.RequestedPrice := Price;

    Quantity.XSToNative(FloatToStr(lQuantity));
    Item.RequestedQuantity := Quantity;

    Amount.XSToNative(FloatToStr(lAmount));
    Item.RequestedAmount := Amount;

    SetLength(SendList, 1);
    SendList[0] := Item;

    ResList := (HTTPRIO as CardServiceSoap).checkCardSale(SendList, gUserName, gPassword);

    ResItem := ResList[0];

    lMsg:= ResItem.ResultDescription;
    Result:= LowerCase(lMsg) = LowerCase('Продажа доступна');
    //
    if Result then
    begin
         lChangePercent:= ResItem.ResultDiscountPercent;
         lSummChangePercent:= ResItem.ResultDiscountAmount;

         //lQuantityRes:= ResItem.RequestedQuantity.DecimalString;
         //lPriceRes:= ResItem.RequestedPrice.DecimalString;
    end
    else
        ShowMessage ('Ошибка.Карта № <' + gCardNumber + '>.' + #10+ #13 + lMsg);

  finally
    FreeAndNil(Price);
    FreeAndNil(Quantity);
    FreeAndNil(Amount);
    Item := nil;
    ResItem := nil;
  end;
end;

end.
