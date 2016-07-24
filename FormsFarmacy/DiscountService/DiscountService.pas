unit DiscountService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Soap.InvokeRegistry, Vcl.StdCtrls,
  Soap.Rio, Soap.SOAPHTTPClient, uCardService, dsdDB, Datasnap.DBClient;

type
  TDiscountServiceForm = class(TForm)
    HTTPRIO: THTTPRIO;
    spGet_BarCode: TdsdStoredProc;
    spGet_DiscountExternal: TdsdStoredProc;
  private
    { Private declarations }
  public
    // так криво будем хранить "текущие" параметры-Main
    gURL, gService, gPort, gUserName, gPassword, gCardNumber : String;
    gDiscountExternalId : Integer;
    // так криво будем хранить "текущие" параметры-Item
    gGoodsId : Integer;
    gPriceSale, gPrice, gChangePercent, gSummChangePercent : Currency;
    //
    // обнулим "нужные" параметры-Item
    procedure pSetParamItemNull;
    // попробуем обновить "нужные" параметры-Main
    procedure pGetDiscountExternal (lDiscountExternalId : Integer; lCardNumber : String);
    // проверка карты + сохраним "текущие" параметры-Main
    function fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string; lDiscountExternalId : Integer) :Boolean;
    // получили Дисконт + сохраним "текущие" параметры-Item
    function fGetSale (var lMsg : string; var lPrice, lChangePercent, lSummChangePercent : Currency;
                                        lCardNumber : string; lDiscountExternalId, lGoodsId : Integer; lQuantity, lPriceSale : Currency;
                                        lGoodsCode : Integer; lGoodsName  : string) :Boolean;
    // Commit Дисконт
    function fCommitSale (CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) :Boolean;
    //
    // update DataSet - еще раз по всем "обновим" Дисконт
    function fUpdateCDS_Item(CheckCDS : TClientDataSet; var lMsg : string; lCardNumber : string; lDiscountExternalId : Integer) : Boolean;
  end;

var
  DiscountServiceForm: TDiscountServiceForm;

implementation
{$R *.dfm}
uses Soap.XSBuiltIns
   , MainCash;

// update DataSet - еще раз по всем "обновим" Дисконт
function TDiscountServiceForm.fUpdateCDS_Item(CheckCDS : TClientDataSet; var lMsg : string; lCardNumber : string; lDiscountExternalId : Integer) : Boolean;
var
  GoodsId: Integer;
begin
  Result :=true;

  //Если пусто - ничего не делаем
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;

  //открючаем реакции
  GoodsId := CheckCDS.FieldByName('GoodsId').asInteger;

  try
    CheckCDS.First;
    while not CheckCDS.Eof do
    begin
       if (CheckCDS.FieldByName('Amount').AsFloat > 0)and(lDiscountExternalId>0)
       then begin
               // на всяк случай условие
               if CheckCDS.FieldByName('PriceSale').asFloat > 0
               then gPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
               else gPriceSale:= CheckCDS.FieldByName('Price').asFloat;
               //
               if not fGetSale (lMsg, gPrice, gChangePercent, gSummChangePercent
                              , lCardNumber, lDiscountExternalId
                              , CheckCDS.FieldByName('GoodsId').asInteger
                              , CheckCDS.FieldByName('Amount').asFloat
                              , gPriceSale
                              , CheckCDS.FieldByName('GoodsCode').asInteger
                              , CheckCDS.FieldByName('GoodsName').asString
                               )
               then Result := false; // если хоть одна продажа не пройдет
       end
       else begin
               // на всяк случай условие
               if CheckCDS.FieldByName('PriceSale').asFloat > 0
               then gPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
               else gPriceSale:= CheckCDS.FieldByName('Price').asFloat;
               //скидки не будет
               gPrice            := gPriceSale;
               gChangePercent    := 0;
               gSummChangePercent:= 0;
       end;

      CheckCDS.Edit;
      CheckCDS.FieldByName('Price').asCurrency             :=gPrice;
      CheckCDS.FieldByName('PriceSale').asCurrency         :=gPriceSale;
      CheckCDS.FieldByName('ChangePercent').asCurrency     :=gChangePercent;
      CheckCDS.FieldByName('SummChangePercent').asCurrency :=gSummChangePercent;
      CheckCDS.Post;
      //
      CheckCDS.Next;
    end;
  finally
    CheckCDS.Filtered := True;
    if GoodsId <> 0 then
      CheckCDS.Locate('GoodsId',GoodsId,[]);
    CheckCDS.EnableControls;
  end;

end;

// проверка карты + сохраним "текущие" параметры-Main
function TDiscountServiceForm.fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string; lDiscountExternalId : Integer) :Boolean;
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

  except
        Self.Cursor := crDefault;
        lMsg:='Error';
        ShowMessage ('Ошибка на сервере.' + #10+ #13
        + #10+ #13 + 'Для карты № <' + lCardNumber + '>.');
  end;
  //finally

     Self.Cursor := crDefault;

     // так криво обновим "текущие" параметры-Main
     if Result then
     begin
          // сохранили
          gDiscountExternalId:= lDiscountExternalId;
          gURL        := lURL;
          gService    := lService;
          gPort       := lPort;
          gUserName   := lUserName;
          gPassword   := lPassword;
          gCardNumber := lCardNumber;
     end
     else
     begin
          // сохранили
          gDiscountExternalId:= lDiscountExternalId;
          // обнулили
          gURL        := '';
          gService    := '';
          gPort       := '';
          gUserName   := '';
          gPassword   := '';
          gCardNumber := '';
     end;
end;

// попробуем обновить "нужные" параметры-Main
procedure TDiscountServiceForm.pGetDiscountExternal (lDiscountExternalId : Integer; lCardNumber : String);
begin
  if lDiscountExternalId > 0
  then
      with spGet_DiscountExternal do begin
         ParamByName('inId').Value := lDiscountExternalId;
         Execute;
         // сохраним "нужные" параметры-Main
         gDiscountExternalId:= lDiscountExternalId;
         gURL        := ParamByName('URL').Value;
         gService    := ParamByName('Service').Value;
         gPort       := ParamByName('Port').Value;
         gUserName   := ParamByName('UserName').Value;
         gPassword   := ParamByName('Password').Value;
         gCardNumber := lCardNumber;
      end
  else
     begin
          //обнулим параметры-Main
          gDiscountExternalId:= 0;
          gURL        := '';
          gService    := '';
          gPort       := '';
          gUserName   := '';
          gPassword   := '';
          gCardNumber := '';
     end;
end;

// Commit Дисконт
function TDiscountServiceForm.fCommitSale (CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) :Boolean;
var
  SendList_tmp : ArrayOfCardCheckItem;
  Item_tmp : CardCheckItem;
  ResList_tmp : ArrayOfCardCheckResultItem;
  ResItem_tmp : CardCheckResultItem;


  aSaleRequest : CardSaleRequest;

  SendList : ArrayOfCardSaleRequestItem;
  Item : CardSaleRequestItem; //
  ResList : CardSaleResult;
  ResItem : CardSaleResultItem;

  Price, Quantity, Amount : TXSDecimal;
  PriceSale, AmountSale : TXSDecimal;
  CheckDate : TXSDateTime;
  //
  BarCode_find : String;
  GoodsId : Integer;
  i : Integer;
begin
  Result:=false;
  lMsg:='';

  //Если пусто - ничего не делаем
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;

  //открючаем реакции
  GoodsId := CheckCDS.FieldByName('GoodsId').asInteger;

  try
{   aSaleRequest := CardSaleRequest.Create;
    Item         := CardSaleRequestItem.Create;
    ResList      := CardSaleResult.Create;
    ResItem      := CardSaleResultItem.Create;
    //
    //ИД операции в учетной системе
    aSaleRequest.CheckId := '1';
    //Номер чека
    aSaleRequest.CheckCode := '1';
    //Дата/время чека (дата продажи)
    CheckDate:= TXSDateTime.Create;
    CheckDate.XSToNative (DateTimeToStr(now));
    aSaleRequest.CheckDate :=CheckDate;

            //Код карточки
            aSaleRequest.MdmCode := lCardNumber;
            //Штрих код товара
            //aSaleRequest.ProductFormCode := BarCode_find;
            //Тип продажи (0 коммерческий\1 акционный)
            aSaleRequest.SaleType := '1'; // ???????

    //
    i := 1;
    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      //
      //Start
      //
      if lDiscountExternalId > 0
      then
        //поиск Штрих-код
        with spGet_BarCode do begin
           ParamByName('inObjectId').Value := lDiscountExternalId;
           ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
           Execute;
           BarCode_find := trim (ParamByName('outBarCode').Value);
        end
      else
          BarCode_find := '';

      //если Штрих-код нашелся
      if BarCode_find <> '' then
      begin

          PriceSale := TXSDecimal.Create;
          AmountSale := TXSDecimal.Create;
          Price := TXSDecimal.Create;
          Quantity := TXSDecimal.Create;
          Amount := TXSDecimal.Create;
          try
            //Штрих код товара
            aSaleRequest.ProductFormCode := BarCode_find;

            //ИД строки в учетной системе
            Item.ItemId:='1';
            //Код карточки
            Item.MdmCode := lCardNumber;
            //Штрих код товара
            Item.ProductFormCode := BarCode_find;
            //Тип продажи (0 коммерческий\1 акционный)
            Item.SaleType := '1'; // ???????

            //Цена без учета скидки
            PriceSale.XSToNative (FloatToStr (CheckCDS.FieldByName('PriceSale').AsFloat));
            Item.PrimaryPrice := PriceSale;
            //Сумма без учета скидки
            AmountSale.XSToNative(FloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('Price').AsFloat)));
            Item.RequestedAmount := AmountSale;

            //Цена товара (с учетом скидки)
            Price.XSToNative (FloatToStr (CheckCDS.FieldByName('Price').AsFloat));
            Item.RequestedPrice := Price;
            //Кол-во товара
            Quantity.XSToNative (FloatToStr (CheckCDS.FieldByName('Amount').AsFloat));
            Item.RequestedQuantity := Quantity;
            //Сумма за кол-во товара (с учетом скидки)
            Amount.XSToNative(FloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('Price').AsFloat)));
            Item.RequestedAmount := Amount;

            // Подготовили список для отправки
            SetLength(SendList, i);
            SendList[i-1] := Item;


            i := i + 1;

          except
                ShowMessage ('Ошибка на сервере.' + #10+ #13
                + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                //ошибка
                lMsg:='Error';
                Result := false;
          end;
          //finally
            FreeAndNil(PriceSale);
            FreeAndNil(AmountSale);
            FreeAndNil(Price);
            FreeAndNil(Quantity);
            FreeAndNil(Amount);

      end; // if BarCode_find <> ''
      //
      //Finish
      //
      CheckCDS.Next;

    end; // while

            aSaleRequest.Items := SendList;
            // Отправили запрос
            ResList := (HTTPRIO as CardServiceSoap).commitCardSale(aSaleRequest, gUserName, gPassword);
            // Получили результат
            ResItem := ResList.Items[0];

            //обработали результат
            lMsg:= ResItem.ResultDescription;
            Result:= LowerCase(lMsg) = LowerCase('Продажа доступна');

            if not Result
            then ShowMessage ('Ошибка.Карта № <' + lCardNumber + '>.' + #10+ #13 + lMsg);

            aSaleRequest := nil;
            SendList:= nil;
            Item := nil;
            ResItem := nil;
            FreeAndNil(CheckDate);}

  finally
    CheckCDS.Filtered := True;
    if GoodsId <> 0 then
      CheckCDS.Locate('GoodsId',GoodsId,[]);
    CheckCDS.EnableControls;
  end;

end;

// получили Дисконт + сохраним "текущие" параметры-Item
function TDiscountServiceForm.fGetSale (var lMsg : string; var lPrice, lChangePercent, lSummChangePercent : Currency;
                                        lCardNumber : string; lDiscountExternalId, lGoodsId : Integer; lQuantity, lPriceSale : Currency;
                                        lGoodsCode : Integer; lGoodsName  : string) :Boolean;
var
  SendList : ArrayOfCardCheckItem;
  Item : CardCheckItem;
  ResList : ArrayOfCardCheckResultItem;
  ResItem : CardCheckResultItem;
  Price, Quantity, Amount : TXSDecimal;
  //
  BarCode_find:String;
begin
  Result:=false;
  lMsg:='';
  //если будет exit, вернем БЕЗ скидки;
  lPrice := lPriceSale;
  //сохранили параметры-Item
  gGoodsId           := lGoodsId;
  gPriceSale         := lPriceSale;
  gPrice             := lPriceSale;
  gChangePercent     := 0;
  gSummChangePercent := 0;
  //поиск Штрих-код
  with spGet_BarCode do begin
     ParamByName('inObjectId').Value := lDiscountExternalId;
     ParamByName('inGoodsId').Value  := lGoodsId;
     Execute;
     BarCode_find := ParamByName('outBarCode').Value;
  end;
  //проверка что Штрих-код нашелся
  if BarCode_find = '' then
  begin
        ShowMessage ('Ошибка.Не найден штрих-код.'
        + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
        + #10+ #13 + 'Товар (' + IntToStr(lGoodsCode) + ')' + lGoodsName);
        //осознанно - не совсем ошибка, пусть сохранится в CheckCDS
        lMsg:='';
        //выход
        exit;
  end;
  //
  //
  Item := CardCheckItem.Create;
  ResItem := CardCheckResultItem.Create;
  Price := TXSDecimal.Create;
  Quantity := TXSDecimal.Create;
  Amount := TXSDecimal.Create;
  try
    //Код карточки
    Item.MdmCode := lCardNumber;
    //Штрих код товара
    Item.ProductFormCode := BarCode_find;
    //Тип продажи (0 коммерческий\1 акционный)
    Item.SaleType := '1'; // ???????
    //Предполагаемая цена товара
    Price.XSToNative(FloatToStr(lPriceSale));
    Item.RequestedPrice := Price;
    //Предполагаемое кол-во товара
    Quantity.XSToNative(FloatToStr(lQuantity));
    Item.RequestedQuantity := Quantity;
    //Предполагаемая сумма за кол-во товара
    Amount.XSToNative(FloatToStr( GetSumm(lQuantity, lPriceSale)));
    Item.RequestedAmount := Amount;

    // Подготовили список для отправки
    SetLength(SendList, 1);
    SendList[0] := Item;

    // Отправили запрос
    ResList := (HTTPRIO as CardServiceSoap).checkCardSale(SendList, gUserName, gPassword);
    // Получили результат
    ResItem := ResList[0];

    //обработали результат
    lMsg:= ResItem.ResultDescription;
    Result:= LowerCase(lMsg) = LowerCase('Продажа доступна');

    //вернули остальные значения
    if Result then
    begin
         //Рекомендованная скидка в виде % от цены
         lChangePercent     := ResItem.ResultDiscountPercent;
         //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
         lSummChangePercent := ResItem.ResultDiscountAmount;
         //проверка
         if lSummChangePercent >= GetSumm(lQuantity, lPriceSale) then
         begin
              ShowMessage ('Ошибка.Сумма скидки  <' + FloatToStr(lSummChangePercent) + '> не может быть больше чем <' + FloatToStr(GetSumm(lQuantity, lPriceSale)) + '>.'
              + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
              + #10+ #13 + 'Товар (' + IntToStr(lGoodsCode) + ')' + lGoodsName);
              //ошибка, НЕ сохранится в CheckCDS (хотя не всегда)
              lMsg:='Error';
              Result := false;
              //
              lPrice             := lPriceSale;
              lChangePercent     := 0;
              lSummChangePercent := 0;
         end
         else
             //!!! расчет Цена - уже со скидкой !!!
             if lSummChangePercent > 0
             then
                 // типа как для кол-ва = 1, может так правильно округлит?
                 lPrice:= GetSumm(1, (GetSumm(lQuantity, lPriceSale) - lSummChangePercent) / lQuantity)
             else begin
                 // тоже типа как для кол-ва = 1, может так правильно округлит?
                 lPrice:= GetSumm(1, lPriceSale * (1 - lChangePercent / 100));
                 // а еще досчитаем сумму скидки
                 lSummChangePercent := GetSumm(lQuantity, lPriceSale) - GetSumm(lQuantity, lPrice)
             end;
         //сохранили параметры-Item (только те что изменились)
         gPrice             := lPrice;
         gChangePercent     := lChangePercent;
         gSummChangePercent := lSummChangePercent;
    end
    else
        ShowMessage ('Ошибка.Карта № <' + gCardNumber + '>.' + #10+ #13 + lMsg);
  except
        ShowMessage ('Ошибка на сервере.' + #10+ #13
        + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
        + #10+ #13 + 'Товар (' + IntToStr(lGoodsCode) + ')' + lGoodsName);
        //ошибка, НЕ сохранится в CheckCDS (хотя не всегда)
        lMsg:='Error';
        Result := false;
  end;
  //finally
    FreeAndNil(Price);
    FreeAndNil(Quantity);
    FreeAndNil(Amount);
    Item := nil;
    ResItem := nil;
end;

// обнулим "нужные" параметры-Item
procedure TDiscountServiceForm.pSetParamItemNull;
begin
  //очистили
  gGoodsId           := 0;
  gPriceSale         := 0;
  gPrice             := 0;
  gChangePercent     := 0;
  gSummChangePercent := 0;
end;

end.
