unit DiscountService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Soap.InvokeRegistry, Vcl.StdCtrls, System.Contnrs,
  Soap.Rio, Soap.SOAPHTTPClient, uCardService, dsdDB, Datasnap.DBClient, Data.DB,
  REST.Types, REST.Client, Data.Bind.Components, Soap.EncdDecd,
  Data.Bind.ObjectScope, Math, System.Net.URLClient, DateUtils;

type

  TDiscountServiceForm = class(TForm)
    HTTPRIO: THTTPRIO;
    spGet_BarCode: TdsdStoredProc;
    spGet_DiscountExternal: TdsdStoredProc;
    UnloadItemCDS: TClientDataSet;
    spSelectUnloadItem: TdsdStoredProc;
    UnloadMovementCDS: TClientDataSet;
    spSelectUnloadMovement: TdsdStoredProc;
    spUpdateUnload: TdsdStoredProc;
    RESTResponse: TRESTResponse;
    RESTRequest: TRESTRequest;
    RESTClient: TRESTClient;
    spGet_Goods_CodeRazom: TdsdStoredProc;
    spGet_DiscountCard_Goods_Amount: TdsdStoredProc;
    procedure FormCreate(Sender: TObject);
  private
    FIdCasual : string;
    FDiscont : Currency;
    FDiscontАbsolute : Currency;
    FBarCode_find : string;
    FSupplier : Integer;
    FSIdAlter : String;
    FInvoiceNumber : String;
    FInvoiceDate : TDateTime;
    FAmountPackages : Currency;

    function myFloatToStr(aValue: Double) : String;
    function myStrToFloat(aValue: String) : Double;
    function GetBeforeSale : boolean;
    function GetPrepared : boolean;
    procedure SetBeforeSale(Values: boolean);
  public
    // так криво будем хранить "текущие" параметры-Main
    gURL, gService, gPort, gUserName, gPassword, gCardNumber, gExternalUnit: string;
    gDiscountExternalId, gCode: Integer;
    gisOneSupplier, gisTwoPackages : Boolean;
    // обнулим "нужные" параметры-Item
    //procedure pSetParamItemNull;
    // попробуем обновить "нужные" параметры-Main
    procedure pGetDiscountExternal (lDiscountExternalId : Integer; lCardNumber : String);
    // проверка карты + сохраним "текущие" параметры-Main
    function fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string;
                         lisOneSupplier, lisTwoPackages : Boolean;
                         lDiscountExternalId : Integer) :Boolean;
    // получили Дисконт + сохраним "текущие" параметры-Item
    //function fGetSale (var lMsg : string; var lPrice, lChangePercent, lSummChangePercent : Currency;
    //                                    lCardNumber : string; lDiscountExternalId, lGoodsId : Integer; lQuantity, lPriceSale : Currency;
    //                                    lGoodsCode : Integer; lGoodsName  : string) :Boolean;
    // Update Дисконт в CDS - по всем "обновим" Дисконт
    function fUpdateCDS_Discount (CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string; bFixPrice : Boolean = False) :Boolean;
    // Commit Дисконт из CDS - по всем
    function fCommitCDS_Discount (fCheckNumber:String; CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer;
                                  lCardNumber : string; var AisDiscountCommit : Boolean; nHourOffset : Integer = 3; nDay : Integer = 0) :Boolean;
    //
    // update DataSet - еще раз по всем "обновим" Дисконт
    //function fUpdateCDS_Item(CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) : Boolean;
    //
    // Send All Movement - Income
    function fPfizer_Send (const nDiscountExternal : Integer; var lMsg : string) :Boolean;
    // Send Item - Income
    function fPfizer_SendItem (lMovementId: Integer;
                               lOperDate : TDateTime;
                               lInvNumber : String;
                               lFromOKPO, lFromName : String;
                               lToOKPO, lToName : String;
                               var lMsg : string) :Boolean;
    // Send Movement - Income
    function fPfizer_SendMovement (lURL : String;
                                   lService : String;
                                   lPort : String;
                                   lUserName : String;
                                   lPassword : String;
                                   lMovementId: Integer;
                                   lOperDate : TDateTime;
                                   lInvNumber : String;
                                   lFromOKPO, lFromName : String;
                                   lToOKPO, lToName : String;
                                   var lMsg : string) :Boolean;

    property isBeforeSale : boolean read GetBeforeSale write SetBeforeSale;
    property isPrepared : boolean read GetPrepared;

//    property Discont : Currency read FDiscont;
//    property DiscontАbsolute : Currency read FDiscontАbsolute;
  end;

var
  DiscountServiceForm: TDiscountServiceForm;

implementation
{$R *.dfm}
uses Soap.XSBuiltIns
   , MainCash2, UtilConvert
   , XMLIntf, XMLDoc, OPToSOAPDomConv, MessagesUnit;

function GenerateIdCasual: string;
  var GUID: TGUID;
begin
  CreateGUID(GUID);
  Result := LowerCase(IntToHex(GUID.D1) + IntToHex(GUID.D2) + IntToHex(GUID.D3) +
     IntToHex(GUID.D4[0]) + IntToHex(GUID.D4[1]) + IntToHex(GUID.D4[2]) + IntToHex(GUID.D4[3]) +
     IntToHex(GUID.D4[4]) + IntToHex(GUID.D4[5]) + IntToHex(GUID.D4[6]) + IntToHex(GUID.D4[7]));
end;

function CurrToStrXML(AValues : Currency) : string;
begin
  if AValues <> 0 then
     Result := StringReplace(CurrToStr(AValues), FormatSettings.DecimalSeparator, '.', [rfReplaceAll])
  else Result := '0';
end;

function TXSStrToDate(Value : String) : TDateTime;
begin
  with TXSDateTime.Create do
  try
    XSToNative(Value);
    result := AsDateTime;
  finally
    Free;
  end;
end;

//
function TDiscountServiceForm.myFloatToStr(aValue: Double) : String;
//var lValue:String;
begin
     Result:=  gfFloatToStr(aValue);
{
      lValue:= FloatToStr(aValue);
      if Pos(',',lValue)
      then Result:= ReplaceStr() lValue
      else Result:= lValue;}
end;
//
function TDiscountServiceForm.myStrToFloat(aValue: String) : Double;
begin
     Result:=  gfStrToFloat(aValue);
end;
// для Теста
procedure Add_DiscontLog_XML(AMessage: String);
var
  F: TextFile;
begin
  try
    AssignFile(F, ChangeFileExt(Application.ExeName, '_DiscontLog.xml'));
    if not fileExists(ChangeFileExt(Application.ExeName, '_DiscontLog.xml')) then
    begin
      Rewrite(F);
    end
    else
      Append(F);
    //
    try
      Writeln(F, DateTimeToStr(Now));
      Writeln(F, AMessage);
    finally
      CloseFile(F);
    end;
  except
  end;
end;
// для Теста
procedure SaveToXMLFile_CheckItem(Source : ArrayOfCardCheckItem);
var
  i : integer;
  Converter: IObjConverter;
  NodeObject: IXMLNode;
  NodeParent: IXMLNode;
  NodeRoot: IXMLNode;
  XML: IXMLDocument;
  XMLStr: InvString;
begin
  XML:= NewXMLDocument;
  NodeRoot:= XML.AddChild('Root');
  NodeParent:= NodeRoot.AddChild('Parent');
  Converter:= TSOAPDomConv.Create(NIL);
  for i := 0 to Length(Source) - 1 do
    NodeObject:= Source[i].ObjectToSOAP(NodeRoot, NodeParent, Converter, 'CopyObject', '', '', [ocoDontPrefixNode], XMLStr);

  if FileExists('d:\test.SaveToXML') then XML.SaveToFile('D:\11Item.xml');
end;
procedure SaveToXMLFile_CheckItemResult(Source : ArrayOfCardCheckResultItem);
var
  i : integer;
  Converter: IObjConverter;
  NodeObject: IXMLNode;
  NodeParent: IXMLNode;
  NodeRoot: IXMLNode;
  XML: IXMLDocument;
  XMLStr: InvString;
begin
  XML:= NewXMLDocument;
  NodeRoot:= XML.AddChild('Root');
  NodeParent:= NodeRoot.AddChild('Parent');
  Converter:= TSOAPDomConv.Create(NIL);
  for i := 0 to Length(Source) - 1 do
    NodeObject:= Source[i].ObjectToSOAP(NodeRoot, NodeParent, Converter, 'CopyObject', '', '', [ocoDontPrefixNode], XMLStr);

  if FileExists('d:\test.SaveToXML') then XML.SaveToFile('D:\12ItemRes.xml');
end;
procedure SaveToXMLFile_ItemCommit(Source : TRemotable);
var
      Converter: IObjConverter;
      NodeObject: IXMLNode;
      NodeParent: IXMLNode;
      NodeRoot: IXMLNode;
      XML: IXMLDocument;
      XMLStr: InvString;
begin
  try
      XML:= NewXMLDocument;
      NodeRoot:= XML.AddChild('Root');
      NodeParent:= NodeRoot.AddChild('Parent');
      Converter:= TSOAPDomConv.Create(NIL);
      NodeObject:= Source.ObjectToSOAP(NodeRoot, NodeParent, Converter, 'CopyObject', '', '', [ocoDontPrefixNode], XMLStr);
      Add_DiscontLog_XML(XML.XML.Text);
  except
  end;
//      XML.SaveToFile('D:\21ItemCommit.xml');
end;
procedure SaveToXMLFile_ItemCommitRes(Source : TRemotable);
var
      Converter: IObjConverter;
      NodeObject: IXMLNode;
      NodeParent: IXMLNode;
      NodeRoot: IXMLNode;
      XML: IXMLDocument;
      XMLStr: InvString;
begin
      XML:= NewXMLDocument;
      NodeRoot:= XML.AddChild('Root');
      NodeParent:= NodeRoot.AddChild('Parent');
      Converter:= TSOAPDomConv.Create(NIL);
      NodeObject:= Source.ObjectToSOAP(NodeRoot, NodeParent, Converter, 'CopyObject', '', '', [ocoDontPrefixNode], XMLStr);
      if FileExists('d:\test.SaveToXML') then XML.SaveToFile('D:\22ItemCommitRes.xml');
end;


// update DataSet - еще раз по всем "обновим" Дисконт
{function TDiscountServiceForm.fUpdateCDS_Item(CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) : Boolean;
var
  GoodsId: Integer;
begin
  Result :=true;
//  exit; //!!!для теста

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

end;}

// проверка карты + сохраним "текущие" параметры-Main
function TDiscountServiceForm.fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string;
                                          lisOneSupplier, lisTwoPackages : Boolean;
                                          lDiscountExternalId : Integer) :Boolean;
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
      if not Result then ShowMessage ('Ошибка <' + lService + '>.Карта № <' + lCardNumber + '>.' + #10+ #13 + lMsg);

  except
        Self.Cursor := crDefault;
        lMsg:='Error';
        ShowMessage ('Ошибка на сервере <' + lURL + '>.' + #10+ #13
        + #10+ #13 + 'Для карты № <' + lCardNumber + '>.');
  end;
  //finally

     Self.Cursor := crDefault;

     // так криво обновим "текущие" параметры-Main
     if Result then
     begin
          // сохранили
          gDiscountExternalId:= lDiscountExternalId;
          gURL           := lURL;
          gService       := lService;
          gPort          := lPort;
          gUserName      := lUserName;
          gPassword      := lPassword;
          gCardNumber    := lCardNumber;
          gisOneSupplier := lisOneSupplier;
          gisTwoPackages := lisTwoPackages;
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
          gisOneSupplier := False;
          gisTwoPackages := False;
     end;
end;

// попробуем обновить "нужные" параметры-Main
procedure TDiscountServiceForm.pGetDiscountExternal (lDiscountExternalId : Integer; lCardNumber : String);
var lCode : Integer;
begin
  if lDiscountExternalId > 0
  then
      with spGet_DiscountExternal do begin
         ParamByName('inId').Value := lDiscountExternalId;
         ParamByName('Code').Value := 0;
         Execute;
         // сохраним "нужные" параметры-Main
         gDiscountExternalId:= lDiscountExternalId;
         try
            lCode:= ParamByName('Code').Value;
         except
               lCode:= 0;
         end;
         gCode       := lCode;
         if lCode > 0 then
         begin
               gURL           := ParamByName('URL').Value;
               gService       := ParamByName('Service').Value;
               gPort          := ParamByName('Port').Value;
               gUserName      := ParamByName('UserName').Value;
               gPassword      := ParamByName('Password').Value;
               gCardNumber    := lCardNumber;
               gExternalUnit  := ParamByName('ExternalUnit').AsString;
               gisOneSupplier := ParamByName('isOneSupplier').Value;
               gisTwoPackages := ParamByName('isTwoPackages').Value;
         end
         else begin
               gURL           := '';
               gService       := '';
               gPort          := '';
               gUserName      := '';
               gPassword      := '';
               gCardNumber    := '';
               gExternalUnit  := '';
               gisOneSupplier := False;
               gisTwoPackages := False;
               ShowMessage ('Ошибка.Для аптеки не настроена работа с Проектами дисконтных карт.')
         end;
      end
  else
     begin
          //обнулим параметры-Main
          gDiscountExternalId:= 0;
          gCode          := 0;
          gURL           := '';
          gService       := '';
          gPort          := '';
          gUserName      := '';
          gPassword      := '';
          gCardNumber    := '';
          gExternalUnit  := '';
          gisOneSupplier := False;
          gisTwoPackages := False;
     end;
end;


// Commit Дисконт из CDS - по всем
function TDiscountServiceForm.fCommitCDS_Discount (fCheckNumber:String; CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer;
                                                   lCardNumber : string; var AisDiscountCommit : Boolean; nHourOffset : Integer = 3; nDay : Integer = 0) :Boolean;
var
  aSaleRequest : CardSaleRequest;
  SendList : ArrayOfCardSaleRequestItem;
  Item : CardSaleRequestItem;
  ResList : CardSaleResult;
  ResItem : CardSaleResultItem;
  //
  BarCode_find : String;
  GoodsId : Integer;
  i : Integer;
  llMsg : String;
  //
  CasualId: string;
  lQuantity, lPriceSale: Currency;
  //
  XML: IXMLDocument;
  XMLData: IXMLNode;
  XMLNode : IXMLNode;
  OperationResult : String;
  CodeRazom : Integer;
  cExchangeHistory : String;
begin
  Result:=false;
  lMsg:='';
  cExchangeHistory := '';
  AisDiscountCommit := False;
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
    if lDiscountExternalId > 0 then
      if gService = 'CardService' then
      begin
        aSaleRequest := CardSaleRequest.Create;
        //
        //ИД операции в учетной системе
        aSaleRequest.CheckId := '1';
        //Номер чека
        aSaleRequest.CheckCode := fCheckNumber;
        //Дата/время чека (дата продажи)
        aSaleRequest.CheckDate:= TXSDateTime.Create;
        aSaleRequest.CheckDate.AsDateTime:= now;
        aSaleRequest.CheckDate.HourOffset := nHourOffset;
        //Код карточки
        aSaleRequest.MdmCode := lCardNumber;
        //Тип продажи (0 коммерческий\1 акционный)
        aSaleRequest.SaleType := '1'; // Re: Иногда ставят и 0 - когда продажа без карты

        //
        i := 1;
        CheckCDS.First;
        while not CheckCDS.Eof do
        begin
          //
          //Start
          //
          if (lDiscountExternalId > 0) and (CheckCDS.FieldByName('Amount').AsFloat > 0)
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
              //получение номера и даты прихода
              with spGet_Goods_CodeRazom do begin
                 ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
                 ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
                 ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
                 Execute;
                 FInvoiceNumber := ParamByName('outInvoiceNumber').Value;
                 FInvoiceDate := ParamByName('outInvoiceDate').Value;
              end;

              try
                Item         := CardSaleRequestItem.Create;
                //ИД строки в учетной системе
                Item.ItemId:= CheckCDS.FieldByName('List_UID').AsString;
                //Код карточки
                Item.MdmCode := lCardNumber;
                //Штрих код товара
                Item.ProductFormCode := BarCode_find;
                //Тип продажи (0 коммерческий\1 акционный)
                Item.SaleType := '1'; // Re: Иногда ставят и 0 - когда продажа без карты

                //Цена без учета скидки
                Item.PrimaryPrice := TXSDecimal.Create;
                Item.PrimaryPrice.XSToNative (myFloatToStr (CheckCDS.FieldByName('PriceSale').AsFloat));
                //Сумма без учета скидки
//                Item.PrimaryAmount := TXSDecimal.Create;
//                Item.PrimaryAmount.XSToNative (myFloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('PriceSale').AsFloat, False)));

                //Цена товара (с учетом скидки)
                Item.RequestedPrice := TXSDecimal.Create;
                Item.RequestedPrice.XSToNative (myFloatToStr (CheckCDS.FieldByName('Price').AsFloat));
                //Кол-во товара
                Item.RequestedQuantity := TXSDecimal.Create;
                Item.RequestedQuantity.XSToNative (myFloatToStr (CheckCDS.FieldByName('Amount').AsFloat));
                //Сумма за кол-во товара (с учетом скидки)
//                Item.RequestedAmount := TXSDecimal.Create;
//                Item.RequestedAmount.XSToNative(myFloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('Price').AsFloat, False)));

                 //Номер прихода
                 Item.OrderCode := FInvoiceNumber;
                 //Дата прихода
                 Item.OrderDate:= TXSDateTime.Create;
                 Item.OrderDate.AsDateTime:= IncDay(FInvoiceDate, nDay);
                 Item.OrderDate.HourOffset := nHourOffset;

                // Подготовили список для отправки
                SetLength(SendList, i);
                SendList[i-1] := Item;

                // будет следующий
                i := i + 1;

              except
                    ShowMessage ('Ошибка при заполнении структуры SendList.' + #10+ #13
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                    lMsg:='Error';
                    exit;
              end;

          end; // if BarCode_find <> ''
          //
          CheckCDS.Next;

        end; // while


        //Второй цикл

        // если была хоть одна продажа со штрих-кодом
        if i > 1 then
        try
              //ResList      := CardSaleResult.Create;
              //ResItem      := CardSaleResultItem.Create;

              //эту инфу и будем отправлять
              aSaleRequest.Items := SendList;

              //!!!для теста!!!
              SaveToXMLFile_ItemCommit(aSaleRequest);
              //!!!для теста!!!

              // Отправили запрос
              ResList := (HTTPRIO as CardServiceSoap).commitCardSale(aSaleRequest, gUserName, gPassword);

              //ResList := CardSaleResult.Create;
              //!!!для теста!!!
              //***SaveToXMLFile_ItemCommitRes(ResList);
              SaveToXMLFile_ItemCommit(ResList);
              //!!!для теста!!!


              // Получили результат - если элементов в результате не будет
              if (Length(ResList.Items)) = 0 then
              begin
                //обработали результат
                llMsg:= ResList.ResultDescription;
                lMsg:= lMsg + llMsg;
                Result:= LowerCase(llMsg) = LowerCase('Продажа доступна');
                AisDiscountCommit := Result;
                //
                if not Result then
                begin
                  if nHourOffset = 3 then
                  begin
                    Result := fCommitCDS_Discount (fCheckNumber, CheckCDS, lMsg, lDiscountExternalId, lCardNumber, AisDiscountCommit, 2, nDay);
                    Exit;
                  end else if nDay = 0 then
                  begin
                    Result := fCommitCDS_Discount (fCheckNumber, CheckCDS, lMsg, lDiscountExternalId, lCardNumber, AisDiscountCommit, 3, - 1);
                    Exit;
                  end else ShowMessage ('Ошибка <' + gService + '>.Карта № <' + lCardNumber + '>.' + #10+ #13 + llMsg);
                end;
              end;

              // начало второго цикла - по результату каждого элемента
              for i := 0 to Length(ResList.Items) - 1 do
              begin

                // Получили результат - по элементу
                ResItem := ResList.Items[i];

                //обработали результат
                llMsg:= ResItem.ResultDescription;
                lMsg:= lMsg + llMsg;
                Result:= LowerCase(llMsg) = LowerCase('Продажа осуществлена');

                if not Result then
                begin
                  if nHourOffset = 3 then
                  begin
                    Result := fCommitCDS_Discount (fCheckNumber, CheckCDS, lMsg, lDiscountExternalId, lCardNumber, AisDiscountCommit, 2, nDay);
                    Exit;
                  end else if nDay = 0 then
                  begin
                    Result := fCommitCDS_Discount (fCheckNumber, CheckCDS, lMsg, lDiscountExternalId, lCardNumber, AisDiscountCommit, 3, - 1);
                    Exit;
                  end else ShowMessage ('Ошибка <' + gService + '>.Карта № <' + lCardNumber + '>.' + #10+ #13 + llMsg);
                end;

              end;

        except
            ShowMessage ('Ошибка на сервере <' + gURL + '>.' + #10+ #13
            + #10+ #13 + 'Для карты № <' + lCardNumber + '>.');
            //ошибка
            lMsg:='Error';
        end; // if i > 1 // если была хоть одна продажа со штрих-кодом

        // завершили - очистили
        aSaleRequest.Free;
        SendList:= nil;
        Item := nil;
        ResList := nil;
        ResItem := nil;
      end else

      if (gService = 'AbbottCard') and (gUserName <> '') then
      begin
        CheckCDS.First;
        while not CheckCDS.Eof do
        begin
          //
          //Start
          //
          if (lDiscountExternalId > 0) and (CheckCDS.FieldByName('Amount').AsFloat > 0)
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

          //получение кода дистрибьюторов
          with spGet_Goods_CodeRazom do begin
             ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
             ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
             ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
             ParamByName('outCodeRazom').Value := 0;
             Execute;
             CodeRazom := Trunc(ParamByName('outCodeRazom').AsFloat);
          end;

          //если Штрих-код нашелся
          if (BarCode_find <> '') and (CodeRazom <> 0) then
          begin
            try

              RESTClient.BaseURL := gURL;
              RESTClient.ContentType := 'application/x-www-form-urlencoded';

              RESTRequest.ClearBody;
              RESTRequest.Method := TRESTRequestMethod.rmPOST;
              RESTRequest.Resource := '';

              RESTRequest.Params.Clear;
              RESTRequest.AddParameter('token', gExternalUnit, TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('request_format', 'xml', TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('response_format', 'xml', TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('project_id', gPort, TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('data', '<?xml version="1.0"?>'+
                                               '<request><Operation>2</Operation>'+
                                                       '<PharmCard>' + gUserName + '</PharmCard>'+
                                                       '<PatientCard>' + gCardNumber + '</PatientCard>'+
                                                       '<DrugCode>' + BarCode_find + '</DrugCode>'+
                                                       '<Distributor>' + IntToStr(CodeRazom) + '</Distributor>'+
                                                       '<SessionId>42351</SessionId>'+
                                                       '<PharmPrice>' + StringReplace(CheckCDS.FieldByName('PriceSale').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])  + '</PharmPrice>'+
                                                       '<Amount>' + StringReplace(CheckCDS.FieldByName('Amount').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])  + '</Amount>'+
                                               '</request>', TRESTRequestParameterKind.pkGETorPOST);

              try
                RESTRequest.Execute;
              except  on E: Exception do
                begin
                  ShowMessage('Ошибка фиксации факта продажи : ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  exit;
                end;
              end;

              if RESTResponse.StatusCode = 200 then
              begin
                // 50239534
                XML := NewXMLDocument;
                XML.XML.Text := RESTResponse.Content;
                XML.Active := True;

                OperationResult := XML.DocumentElement.ChildNodes[0].ChildNodes[0].Text;
                if AnsiLowerCase(OperationResult) <> 'ok' then
                begin
                  if AnsiLowerCase(OperationResult) = 'pharm_not_active' then OperationResult := 'Аптека (карта аптеки) не активна.'
                  else if AnsiLowerCase(OperationResult) = 'no_pharm_card' then OperationResult := 'Нет такой карты аптеки.'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_card' then OperationResult := 'Нет такой карты пациента.'
                  else if AnsiLowerCase(OperationResult) = 'card_blocked' then OperationResult := 'Карта пациента заблокирована.'
                  else if AnsiLowerCase(OperationResult) = 'not_patient_card' then OperationResult := 'Указанная карта не является картой пациента.'
                  else if AnsiLowerCase(OperationResult) = 'drug_limit' then OperationResult := 'Превышен лимит покупок по карте.'
                  else if AnsiLowerCase(OperationResult) = 'no_today_price' then OperationResult := 'Не установлена цена на препарат в личном кабинете аптеки.'
                  else if AnsiLowerCase(OperationResult) = 'no_db_or_drug_link' then OperationResult := 'Дистрибьютор не назначен аптеке, либо препарат не назначен дистрибьютору. Продажа не возможна..';
                  ShowMessage ('Ошибка фиксации факта продажи.' + #10+ #13
                    + #10+ #13 + 'Ошибка <' + OperationResult + '>.'
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  Exit;
                end else Result:= True; //!!!все ОК и Чек можно сохранить!!!;
                AisDiscountCommit := Result;
              end else
              begin
                ShowMessage ('Ошибка фиксации факта продажи.' + #10+ #13
                  + #10+ #13 + 'Ошибка <' + IntToStr(RESTResponse.StatusCode) + ' - ' + RESTResponse.StatusText + '>.'
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              end;

            except
                  ShowMessage ('Ошибка фиксации факта продажи.' + #10+ #13
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //ошибка
                  lMsg:='Error';
                  exit;
            end;
            //finally

          end; // if BarCode_find <> ''
          //
          CheckCDS.Next;

        end; // while
      end else if gService = 'AbbottCard' then
      begin
        Result:= True //!!!все ОК и Чек можно сохранить!!!

      end
      else

      //если программа Medicard
      if gService = 'Medicard' then
      begin

        if (FIdCasual = '') or (FSupplier = 0) or (FBarCode_find = '') then
        begin
          ShowMessage('В текущем чеке не запрошена возможность продажи!');
          lMsg:='Error';
          exit;
        end;

        CheckCDS.First;
        while not CheckCDS.Eof do
        begin

          if (lDiscountExternalId > 0) and (CheckCDS.FieldByName('Amount').AsFloat > 0)
          then
            //поиск Штрих-код
            with spGet_BarCode do begin
               ParamByName('inObjectId').Value := lDiscountExternalId;
               ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
               Execute;
               BarCode_find := trim (ParamByName('outBarCode').Value);
               if FBarCode_find <> BarCode_find then
               begin
                 ShowMessage('Запрошенный товар отличаеться от текущего в чеке!');
                 lMsg:='Error';
                 exit;
               end;
            end
          else
              BarCode_find := '';

          if BarCode_find <> '' then
          begin

            if CheckCDS.FieldByName('Amount').AsInteger <> CheckCDS.FieldByName('Amount').AsCurrency then
            begin
                ShowMessage ('Количество должно быть целым.' + #10+ #13
                + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                 //ошибка
                lMsg:='Error';
                exit;
            end;

            if gisTwoPackages then
            begin
              FAmountPackages := 0;
              with spGet_DiscountCard_Goods_Amount do
              begin
                ParamByName('inDiscountCard').Value  := gCardNumber;
                ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
                ParamByName('outAmount').Value := 0;
                Execute;
                FAmountPackages := ParamByName('outAmount').AsFloat;
              end;

              if (FAmountPackages = 0) and (CheckCDS.FieldByName('Amount').AsCurrency = 1) then
              begin
                lMsg:='';
                Result:= True;
                exit;
              end else if (FAmountPackages + CheckCDS.FieldByName('Amount').AsCurrency) <> 2 then
              begin
                ShowMessage ('Ошибка По карте в целом должно быть отпущено 2 упаковки товара.' + #10+ #13
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                //ошибка
                lMsg:='Error';
                exit;
              end;
            end else FAmountPackages := 0;

            try

              RESTClient.BaseURL := gURL;
              RESTClient.ContentType := 'application/xml';

              RESTRequest.ClearBody;
              RESTRequest.Method := TRESTRequestMethod.rmPOST;
              RESTRequest.Resource := '';

              RESTRequest.Params.Clear;
              RESTRequest.AddParameter('medicard',
                EncodeString('<?xml version="1.0" encoding="UTF-8"?>'#13#10 +
                             '<data>'#13#10 +
                             '  <request_type>2</request_type>'#13#10 +
                             '  <id_casual>' + FIdCasual + '</id_casual>'#13#10 +
                             '  <inside_code>' + gExternalUnit + '</inside_code>'#13#10 +
                             '  <supplier>' + IntToStr(FSupplier) + '</supplier >'#13#10 +
                             '  <id_alter>' + fCheckNumber  + '</id_alter>'#13#10 +
                             '  <invoice_number>' + FInvoiceNumber   + '</invoice_number>'#13#10 +
                             '  <sale_status>1</sale_status>'#13#10 +
                             '  <card_code>' + gCardNumber + '</card_code>'#13#10 +
                             '  <product_code>' + FBarCode_find + '</product_code>'#13#10 +
                             '  <price>' + CurrToStrXML(CheckCDS.FieldByName('PriceSale').AsCurrency) + '</price>'#13#10 +
                             '  <qty>' + CurrToStrXML(CheckCDS.FieldByName('Amount').AsCurrency + FAmountPackages) + '</qty>'#13#10 +
                             '  <rezerv>' + CurrToStrXML(Max(0, CheckCDS.FieldByName('Remains').AsCurrency - CheckCDS.FieldByName('Amount').AsCurrency)) + '</rezerv>'#13#10 +
                             '  <discont_percent>' + CurrToStrXML(IfThen(gisTwoPackages and (FAmountPackages = 1), FDiscont / 2, FDiscont)) + '</discont_percent>'#13#10 +
                             '  <discont_value>' + CurrToStrXML(CheckCDS.FieldByName('SummChangePercent').AsCurrency) + '</discont_value>'#13#10 +
                             '  <sale_date>' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '</sale_date >'#13#10 +
                             '  <login>' + gUserName + '</login>'#13#10 +
                             '  <password>' + gPassword + '</password>'#13#10 +
                             '</data>'));
              try
                RESTRequest.Execute;
              except  on E: Exception do
                begin
                  ShowMessage('Ошибка подтверждения продажи: ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  exit;
                end;
              end;

              if (RESTResponse.StatusCode = 200) and (LowerCase(RESTResponse.StatusText) = 'ok') then
              begin
                XML := NewXMLDocument;
                XML.XML.Text := DecodeString(RESTResponse.Content);
                XML.Active := True;
                XMLData := XML.DocumentElement;

                XMLNode := XMLData.ChildNodes.FindNode('id_casual');
                if Assigned(XMLNode) then
                begin
                  if FIdCasual = XMLNode.Text then
                  begin

                    XMLNode := XMLData.ChildNodes.FindNode('error');
                    if Assigned(XMLNode) then
                    begin
                      if (XMLNode.Text = '200') then Result:= True
                      else FIdCasual := '';
                      AisDiscountCommit := Result;
                    end else FIdCasual := '';

                  end else FIdCasual := '';
                end else FIdCasual := '';

                XMLNode := XMLData.ChildNodes.FindNode('message');
                if Assigned(XMLNode) then
                begin
                  if FIdCasual <> '' then
                  begin
//                    ShowMessage ('Информация при подтверждении продажи.' + #10+ #13
//                      + #10+ #13 + 'Информация <' + XMLNode.Text + '>.'
//                      + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
//                      + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  end else
                  begin
                    ShowMessage ('Ошибка при подтверждении продажи.' + #10+ #13
                      + #10+ #13 + 'Ошибка <' + XMLNode.Text + '>.'
                      + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                      + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                      //ошибка
                    lMsg:='Error';
                    exit;
                  end;

                end else
                begin
                  ShowMessage ('Ошибка получения сообщения при подтверждении продажи.' + #10+ #13
                    + #10+ #13 + 'Ошибка <' + XMLNode.Text + '>.'
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  exit;
                end;
              end;

            except
                  ShowMessage ('Ошибка проверки возможности продажи.' + #10+ #13
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //ошибка
                  lMsg:='Error';
                  exit;
            end;
          end;

          CheckCDS.Next;

        end; // while
      end

      //если Штрих-код нашелся и программа Здоровье от Байер card
      else
      if (gService = 'ServiceXap') and (gUserName <> '') then
      begin
        CheckCDS.First;
        while not CheckCDS.Eof do
        begin
          //
          //Start
          //
          if (lDiscountExternalId > 0) and (CheckCDS.FieldByName('Amount').AsFloat > 0)
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

          //получение кода дистрибьюторов
          with spGet_Goods_CodeRazom do begin
             ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
             ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
             ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
             ParamByName('outCodeRazom').Value := 0;
             Execute;
             CodeRazom := Trunc(ParamByName('outCodeRazom').AsFloat);
          end;

          //если Штрих-код нашелся
          if (BarCode_find <> '') and (CodeRazom <> 0) then
          begin
            try

              RESTClient.BaseURL := gURL;
              RESTClient.ContentType := 'application/x-www-form-urlencoded';

              RESTRequest.ClearBody;
              RESTRequest.Method := TRESTRequestMethod.rmPOST;
              RESTRequest.Resource := '';

              RESTRequest.Params.Clear;
              RESTRequest.AddParameter('token', gExternalUnit, TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('request_format', 'xml', TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('response_format', 'xml', TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('project_id', gPort, TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('data', '<?xml version="1.0"?>'+
                                               '<request><Operation>2</Operation>'+
                                                       '<PharmCard>' + gUserName + '</PharmCard>'+
                                                       '<PatientCard>' + gCardNumber + '</PatientCard>'+
                                                       '<DrugCode>' + BarCode_find + '</DrugCode>'+
                                                       '<Distributor>' + IntToStr(CodeRazom) + '</Distributor>'+
                                                       '<SessionId>1</SessionId>'+
                                                       '<PharmPrice>' + StringReplace(CheckCDS.FieldByName('PriceSale').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])  + '</PharmPrice>'+
                                                       '<Amount>' + StringReplace(CheckCDS.FieldByName('Amount').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])  + '</Amount>'+
                                               '</request>', TRESTRequestParameterKind.pkGETorPOST);

              cExchangeHistory := 'URL' + gURL + #13#10 +
                                  'XML звпроса'#13#10 + RESTRequest.Params.ParameterByName('data').Value;
              try
                RESTRequest.Execute;
              except  on E: Exception do
                begin
                  ShowMessage('Ошибка фиксации факта продажи : ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  exit;
                end;
              end;

              cExchangeHistory := cExchangeHistory + #13#10 +
                                  'Ответ:'#13#10 + RESTResponse.Content;

              if RESTResponse.StatusCode = 200 then
              begin
                // 50239534
                XML := NewXMLDocument;
                XML.XML.Text := RESTResponse.Content;
                XML.Active := True;

                OperationResult := XML.DocumentElement.ChildNodes[0].ChildNodes[0].Text;
                if AnsiLowerCase(OperationResult) <> 'ok' then
                begin
                  if AnsiLowerCase(OperationResult) = 'pharm_not_active' then OperationResult := 'Аптека (карта аптеки) не активна.'
                  else if AnsiLowerCase(OperationResult) = 'no_pharm_card' then OperationResult := 'Нет такой карты аптеки.'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_card' then OperationResult := 'Нет такой карты пациента.'
                  else if AnsiLowerCase(OperationResult) = 'card_blocked' then OperationResult := 'Карта пациента заблокирована.'
                  else if AnsiLowerCase(OperationResult) = 'not_patient_card' then OperationResult := 'Указанная карта не является картой пациента.'
                  else if AnsiLowerCase(OperationResult) = 'drug_limit' then OperationResult := 'Превышен лимит покупок по карте.'
                  else if AnsiLowerCase(OperationResult) = 'no_today_price' then OperationResult := 'Не установлена цена на препарат в личном кабинете аптеки.'
                  else if AnsiLowerCase(OperationResult) = 'no_db_or_drug_link' then OperationResult := 'Дистрибьютор не назначен аптеке, либо препарат не назначен дистрибьютору. Продажа не возможна..';
                  ShowMessage ('Ошибка фиксации факта продажи.' + #10+ #13
                    + #10+ #13 + 'Ошибка <' + OperationResult + '>.'
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  Exit;
                end else Result:= True; //!!!все ОК и Чек можно сохранить!!!;
                AisDiscountCommit := Result;
              end else
              begin
                ShowMessage ('Ошибка фиксации факта продажи.' + #10+ #13
                  + #10+ #13 + 'Ошибка <' + IntToStr(RESTResponse.StatusCode) + ' - ' + RESTResponse.StatusText + '>.'
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              end;

            except
                  ShowMessage ('Ошибка фиксации факта продажи.' + #10+ #13
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //ошибка
                  lMsg:='Error';
                  exit;
            end;
            //finally

          end; // if BarCode_find <> ''
          //
          CheckCDS.Next;

        end; // while
      end else if gCode in [16] then
      begin

        if FSupplier = 0 then
        begin
          ShowMessage('В текущем чеке не запрошена возможность продажи!');
          lMsg:='Error';
          exit;
        end;

        Result:= True;

      end else if gService = 'ServiceXap' then

        Result:= True //!!!все ОК и Чек можно сохранить!!!
      ;
  finally
    CheckCDS.Filtered := True;
    if GoodsId <> 0 then
      CheckCDS.Locate('GoodsId',GoodsId,[]);
    CheckCDS.EnableControls;
//    if (lMsg <> '') and (cExchangeHistory <> '')  then
//       TMessagesForm.Create(nil).Execute('Результат обмена данными', cExchangeHistory, True);
  end;

end;

procedure TDiscountServiceForm.FormCreate(Sender: TObject);
begin
  FDiscont := 0;
  FDiscontАbsolute := 0;
  FIdCasual := '';
  FBarCode_find := '';
end;

// Send All Movement - Income
function TDiscountServiceForm.fPfizer_Send (const nDiscountExternal : Integer; var lMsg : string) :Boolean;
var llMsg : String;
begin
    try
      //Получили данные
      with spGet_DiscountExternal do
      begin
           ParamByName('URL').Value        := '';
           ParamByName('Service').Value    := '';
           ParamByName('Port').Value       := '';
           ParamByName('UserName').Value   := '';
           ParamByName('Password').Value   := '';
           ParamByName('inId').Value := nDiscountExternal; // захардкодил - ЗАРАДИ ЖИТТЯ
           Execute;
           // сохраним "нужные" параметры-Main
           gDiscountExternalId:= nDiscountExternal;
           gURL        := ParamByName('URL').Value;
           gService    := ParamByName('Service').Value;
           gPort       := ParamByName('Port').Value;
           gUserName   := ParamByName('UserName').Value;
           gPassword   := ParamByName('Password').Value;
      end;
    except
       Result:=false;
       lMsg:= 'Для аптеки программа <ЗАРАДИ ЖИТТЯ> НЕ подключена.';
       exit;
    end;

    if (gURL = '') or (gService = '') or (gPort = '') then
    begin
      Result:=false;
      lMsg:= 'Для аптеки программа <ЗАРАДИ ЖИТТЯ> НЕ подключена.';
      exit;
    end;

    //Инициализировали данными
    HTTPRIO.WSDLLocation := gURL;
    HTTPRIO.Service := gService;
    HTTPRIO.Port := gPort;
    //
    Application.ProcessMessages;
    Application.ProcessMessages;
    Application.ProcessMessages;
    //
    //Открыли данные - документы
    with spSelectUnloadMovement do begin
       ParamByName('inDiscountExternalId').Value := nDiscountExternal; // захардкодил - ЗАРАДИ ЖИТТЯ
       Execute;
    end;

    UnloadMovementCDS.First;
    while not UnloadMovementCDS.Eof do
    begin
         llMsg:= '';
         if not fPfizer_SendItem (UnloadMovementCDS.FieldByName('MovementId').AsInteger
                                , UnloadMovementCDS.FieldByName('OperDate').AsDateTime
                                , UnloadMovementCDS.FieldByName('InvNumber').AsString
                                , UnloadMovementCDS.FieldByName('FromOKPO').AsString
                                , UnloadMovementCDS.FieldByName('FromName').AsString
                                , UnloadMovementCDS.FieldByName('ToOKPO').AsString
                                , UnloadMovementCDS.FieldByName('ToName').AsString
                                , llMsg)
         then lMsg:= lMsg + llMsg;
         //
         Sleep(200);
         // идем дальше
         UnloadMovementCDS.Next;
    end;

    // вернули результат
    Result:= lMsg = '';

end;

// Send Movement - Income
function TDiscountServiceForm.fPfizer_SendMovement (lURL : String;
                                                    lService : String;
                                                    lPort : String;
                                                    lUserName : String;
                                                    lPassword : String;
                                                    lMovementId: Integer;
                                                    lOperDate : TDateTime;
                                                    lInvNumber : String;
                                                    lFromOKPO, lFromName : String;
                                                    lToOKPO, lToName : String;
                                                    var lMsg : string) :Boolean;
begin
   // сохраним "нужные" параметры-Main
   gURL        := lURL;
   gService    := lService;
   gPort       := lPort;
   gUserName   := lUserName;
   gPassword   := lPassword;

   //Инициализировали данными
   HTTPRIO.WSDLLocation := gURL;
   HTTPRIO.Service := gService;
   HTTPRIO.Port := gPort;

   //
   Application.ProcessMessages;
   //
   lMsg:= '';
   fPfizer_SendItem (lMovementId
                   , lOperDate
                   , lInvNumber
                   , lFromOKPO
                   , lFromName
                   , lToOKPO
                   , lToName
                   , lMsg);
   //
   Sleep(200);

   // вернули результат
   Result:= lMsg = '';
end;

// Send Item - Income
function TDiscountServiceForm.fPfizer_SendItem (lMovementId: Integer;
                                                lOperDate : TDateTime;
                                                lInvNumber : String;
                                                lFromOKPO, lFromName : String;
                                                lToOKPO, lToName : String;
                                                var lMsg : string) :Boolean;
var
  i : integer;

  aOrderRequest : OrderRequest;
  SendList : ArrayOfOrderRequestItem;
  Item : OrderRequestItem;
  Res : OrderResult;
begin
  Result:=false;

  //Открыли данные
  with spSelectUnloadItem do begin
     ParamByName('inMovementId').Value := lMovementId;
     Execute;
  end;

  //Еще раз определим, что б не отправлять повторно
  if (UnloadItemCDS.FieldByName('isRegistered').AsBoolean = TRUE) or (UnloadItemCDS.RecordCount = 0)
  then begin
    Result:= true;
    exit;
  end;


  //Первое - формирование

  try
    aOrderRequest := OrderRequest.Create;
    //
    //ИД накладной в учетной системе
    aOrderRequest.OrderId := IntToStr(lMovementId);
    //Номер накладной
    aOrderRequest.OrderCode := lInvNumber;
    //Дата/время накладной
    aOrderRequest.OrderDate:= TXSDateTime.Create;
    aOrderRequest.OrderDate.AsDateTime:= lOperDate;
    aOrderRequest.OrderDate.HourOffset := 3;
    //Тип накладной(1-Поставка\2-Возврат Дистрибьютору\3-Возврат Покупателя)
    aOrderRequest.OrderType := '1';
    //Код Орг-ции отправителя
    aOrderRequest.OrganizationFromCode := lFromOKPO;
    //Название Орг-ции отправителя
    aOrderRequest.OrganizationFromName := lFromName;
    //Код Орг-ции получателя
    aOrderRequest.OrganizationToCode := lToOKPO;
    //Название Орг-ции получателя
    aOrderRequest.OrganizationToName := lToName;

    i := 1;
    UnloadItemCDS.First;
    while not UnloadItemCDS.Eof do
    begin
          try
            Item         := OrderRequestItem.Create;
            //Штрих код товара
            Item.ProductFormCode:= UnloadItemCDS.FieldByName('BarCode').AsString;
            //Тип продукта (0 коммерческий\1 акционный)
            Item.SaleType := '1';
            //Кол-во
            Item.Quantity := TXSDecimal.Create;
            Item.Quantity.XSToNative (myFloatToStr (UnloadItemCDS.FieldByName('Amount').AsFloat));

            // Подготовили список для отправки
            SetLength(SendList, i);
            SendList[i-1] := Item;

            // будет следующий
            i := i + 1;

          except
                //ShowMessage ('Ошибка при заполнении структуры SendList.' + #10+ #13
                //+ #10+ #13 + 'Товар (' + UnloadItemCDS.FieldByName('GoodsCode').AsString + ')' + UnloadItemCDS.FieldByName('GoodsName').AsString);
                //ошибка
                lMsg:='Error';
                exit;
          end;

      // идем дальше
      UnloadItemCDS.Next;

    end; // while


    //Второе - отправка
    try

          //эту инфу и будем отправлять
          aOrderRequest.Items := SendList;

          //!!!для теста!!!
           SaveToXMLFile_ItemCommit(aOrderRequest);
          //***SaveToXMLFile_ItemOrder(aOrderRequest);
          //!!!для теста!!!

          // Отправили запрос
          Res := (HTTPRIO as CardServiceSoap).commitOrder(aOrderRequest, gUserName, gPassword);

          //!!!для теста!!!
           SaveToXMLFile_ItemCommit(Res);
          //***SaveToXMLFile_ItemCommitRes(ResList);
          //!!!для теста!!!


          //обработали результат
          lMsg:= Res.ResultDescription;
          Result:= (LowerCase(lMsg) = LowerCase('OK')) or (Pos('уже зарегистрирован', LowerCase(lMsg)) > 0);
          //
          if Result then
            //запишем в Документе - Загружена приходная накладная от дистрибьютора в медреестр Pfizer МДМ
               with spUpdateUnload do begin
                  ParamByName('inMovementId').Value := lMovementId;
                  Execute;
               end;

    except
        //ShowMessage ('Ошибка на сервере <' + gURL + '>.' + #10+ #13);
        //ошибка
        lMsg:='Error';
    end; // if i > 1 // если была хоть одна продажа со штрих-кодом

  finally
    // завершили - очистили
    aOrderRequest.Free;
    SendList:= nil;
    Item := nil;
  end;

end;


// Update Дисконт в CDS - по всем "обновим" Дисконт
function TDiscountServiceForm.fUpdateCDS_Discount (CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string; bFixPrice : Boolean = False) :Boolean;
var
  GoodsId : Integer;
  //
  SendList : ArrayOfCardCheckItem;
  Item : CardCheckItem;
  ResList : ArrayOfCardCheckResultItem;
  ResItem : CardCheckResultItem;
  //
  List_GoodsId : TStringList;
  List_BarCode : TStringList;
  BarCode_find : String;
  i, index : Integer;
  llMsg: String;
  lQuantity, lPriceSale, lPrice, lChangePercent, lSummChangePercent : Currency;

  MorionCode: Integer;
  CasualId: string;
  //
  XML: IXMLDocument;
  XMLData: IXMLNode;
  XMLNode : IXMLNode;
  OperationResult : String;
  CodeRazom : Integer;
  cExchangeHistory : String;
begin
  Result:= false;
  lMsg  := '';
  cExchangeHistory := '';
  FAmountPackages := 0;
  //Если пусто - ничего не делаем
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;

  List_GoodsId :=TStringList.Create;
  List_BarCode :=TStringList.Create;

  //открючаем реакции
  GoodsId := CheckCDS.FieldByName('GoodsId').asInteger;

  try
    i := 1;
    CheckCDS.First;
    //Первый цикл
    while not CheckCDS.Eof do
    begin
      // на всяк случай - с условием
      if CheckCDS.FieldByName('PriceSale').asFloat > 0
      then lPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
      else lPriceSale:= CheckCDS.FieldByName('Price').asFloat;
      //
      if (lDiscountExternalId > 0) and (CheckCDS.FieldByName('Amount').AsFloat > 0)
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

      // Проверим чтоб количество было целое
      if (BarCode_find <> '') and (CheckCDS.FieldByName('Amount').AsInteger <> CheckCDS.FieldByName('Amount').AsCurrency) then
      begin
          ShowMessage ('Количество должно быть целым.' + #10+ #13
          + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
          + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
           //ошибка
          lMsg:='Error';
          exit;
      end;


      //если Штрих-код нашелся и программа ЗАРАДИ ЖИТТЯ
      if (BarCode_find <> '') and (gService = 'CardService') then
      begin

          //получение номера и даты прихода
          with spGet_Goods_CodeRazom do begin
             ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
             ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
             ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
             Execute;
             FInvoiceNumber := ParamByName('outInvoiceNumber').Value;
             FInvoiceDate := ParamByName('outInvoiceDate').Value;
          end;

          try
            Item := CardCheckItem.Create;
            //Код карточки
            Item.MdmCode := lCardNumber;
            //Штрих код товара
            Item.ProductFormCode := BarCode_find;
            //Тип продажи (0 коммерческий\1 акционный)
            Item.SaleType := '1'; // Re: Иногда ставят и 0 - когда продажа без карты

            //Предполагаемая цена товара
            Item.RequestedPrice := TXSDecimal.Create;
            Item.RequestedPrice.XSToNative(myFloatToStr(lPriceSale));
            //Предполагаемое кол-во товара
            Item.RequestedQuantity := TXSDecimal.Create;
            Item.RequestedQuantity.XSToNative(myFloatToStr(CheckCDS.FieldByName('Amount').AsFloat));
            //Предполагаемая сумма за кол-во товара
            Item.RequestedAmount := TXSDecimal.Create;
            Item.RequestedAmount.XSToNative(myFloatToStr( GetSumm(CheckCDS.FieldByName('Amount').AsFloat, lPriceSale, False)));
            //Приход от поставщика
            Item.OrderCode := FInvoiceNumber;
            Item.OrderDate := TXSDateTime.Create;
            Item.OrderDate.AsDateTime := FInvoiceDate;
            Item.OrderDate.HourOffset := 3;

            // Подготовили список для отправки
            SetLength(SendList, i);
            SendList[i-1] := Item;
            // будет следующий
            i := i + 1;
            // сохраним в список
            List_GoodsId.Add(CheckCDS.FieldByName('GoodsId').AsString);
            List_BarCode.Add(BarCode_find);

          except
                ShowMessage ('Ошибка при заполнении структуры SendList.' + #10+ #13
                + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                //ошибка
                lMsg:='Error';
                exit;
          end;
          //finally

          //отсортировали, т.к. будем искать
          List_GoodsId.Sort;
          List_BarCode.Sort;


          //Второй цикл

          // если была хоть одна продажа со штрих-кодом
          if i > 1 then
          try
                //
                //ResItem := CardCheckResultItem.Create;

                //!!!для теста!!!
                //***SaveToXMLFile_CheckItem(SendList);
                //!!!для теста!!!

                // Отправили запрос на ВСЕ элементы
                ResList := (HTTPRIO as CardServiceSoap).checkCardSale(SendList, gUserName, gPassword);

                //!!!для теста!!!
                //***SaveToXMLFile_CheckItemResult(ResList);
                //!!!для теста!!!

                // начало второго цикла - по результату каждого элемента
                for i := 0 to Length(ResList) - 1 do
                begin

                // Получили результат - по элементу
                ResItem := ResList[i];

                //конечно такой код не найдется, но выходить не надо
                if ResItem.ProductFormCode = ''
                then // ничего не делаем, хотя надо будет обнулить ВСЕМ элементам скидку
                else
                //позиционируем checkCDS для Update
                if not List_BarCode.Find(ResItem.ProductFormCode,index)
                then begin ShowMessage('Не найден BarCode в списке - List_BarCode.Find(' + ResItem.ProductFormCode + ')');
                           lMsg:= 'Error';
                           exit;
                     end
                else
                if not checkCDS.Locate('GoodsId',List_GoodsId[index],[])
                then begin ShowMessage('Не найден GoodsId - checkCDS.Locate(List_GoodsId[index])');
                           lMsg:= 'Error';
                           exit;
                     end;

                //Предполагаемое кол-во товара
                lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                // на всяк случай - с условием
                if CheckCDS.FieldByName('PriceSale').asFloat > 0
                then lPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
                else lPriceSale:= CheckCDS.FieldByName('Price').asFloat;

                //обработали результат
                llMsg:= ResItem.ResultDescription;
                lMsg:= lMsg + llMsg;
                Result:= LowerCase(llMsg) = LowerCase('Продажа доступна');

                //получили остальные значения
                if Result then
                begin
                     //Рекомендованная скидка в виде % от цены
                     lChangePercent     := gfStrToFloat (ResItem.ResultDiscountPercent.DecimalString);
                     //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
                     lSummChangePercent := gfStrToFloat (ResItem.ResultDiscountAmount.DecimalString);

                     //!!! расчет Цена - уже со скидкой !!!
                     if lSummChangePercent > 0
                     then
                         // типа как для кол-ва = 1, может так правильно округлит?
                         lPrice:= GetSumm(1, (GetSumm(lQuantity, lPriceSale,False) - lSummChangePercent) / lQuantity, False)
                     else begin
                         // тоже типа как для кол-ва = 1, может так правильно округлит?
                         lPrice:= GetSumm(1, lPriceSale * (1 - lChangePercent / 100), False);
                         // а еще досчитаем сумму скидки
                         lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False)
                     end;

                     //проверка
                     if lSummChangePercent >= GetSumm(lQuantity, lPriceSale, False) then
                     begin
                          ShowMessage ('Ошибка.Сумма скидки  <' + myFloatToStr(lSummChangePercent) + '> не может быть больше чем <' + myFloatToStr(GetSumm(lQuantity, lPriceSale, False)) + '>.'
                          + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                          + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                          //ошибка
                          lMsg:=lMsg + 'Error';
                          //
                          lPrice             := lPriceSale;
                          lChangePercent     := 0;
                          lSummChangePercent := 0;
                     end;
                end
                else begin
                          lPrice             := lPriceSale;
                          lChangePercent     := 0;
                          lSummChangePercent := 0;
                          //
                          ShowMessage ('Ошибка <' + gService + '>.Карта № <' + gCardNumber + '>.' + #10+ #13 + llMsg);
                     end;


                 //Update
                 CheckCDS.Edit;
                 CheckCDS.FieldByName('Price').asCurrency             :=lPrice;
                 CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
                 //Рекомендованная скидка в виде % от цены
                 CheckCDS.FieldByName('ChangePercent').asCurrency     :=lChangePercent;
                 //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
                 CheckCDS.FieldByName('SummChangePercent').asCurrency :=lSummChangePercent;
                 CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
                 CheckCDS.Post;

                end; // for i := 0 to Length(ResList) - 1

          except
              ShowMessage ('Ошибка на сервере <' + gURL + '>.' + #10+ #13
              + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
              + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              //ошибка
              lMsg:='Error';
          end; // if i > 1 // если была хоть одна продажа со штрих-кодом


      end // if BarCode_find <> ''

      //если Штрих-код нашелся и программа Abbott card
      else if (BarCode_find <> '') and (gService = 'AbbottCard') then
      begin

          //получение кода дистрибьюторов
          with spGet_Goods_CodeRazom do begin
             ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
             ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
             ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
             ParamByName('outCodeRazom').Value := 0;
             Execute;
             CodeRazom := Trunc(ParamByName('outCodeRazom').AsFloat);
          end;

          if CodeRazom <> 0 then
          begin
            try

              RESTClient.BaseURL := gURL;
              RESTClient.ContentType := 'application/x-www-form-urlencoded';

              RESTRequest.ClearBody;
              RESTRequest.Method := TRESTRequestMethod.rmPOST;
              RESTRequest.Resource := '';

              RESTRequest.Params.Clear;
              RESTRequest.AddParameter('token', gExternalUnit, TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('request_format', 'xml', TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('response_format', 'xml', TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('project_id', gPort, TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('data', '<?xml version="1.0"?>'+
                                               '<request><Operation>1</Operation>'+
                                                       '<PharmCard>' + gUserName + '</PharmCard>'+
                                                       '<PatientCard>' + gCardNumber + '</PatientCard>'+
                                                       '<DrugCode>' + BarCode_find + '</DrugCode>'+
                                                       '<Distributor>' + IntToStr(CodeRazom) + '</Distributor>'+
                                                       '<SessionId>42351</SessionId>'+
                                                       '<PharmPrice>' + StringReplace(CheckCDS.FieldByName('PriceSale').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])  + '</PharmPrice>'+
                                                       '<Amount>' + StringReplace(CheckCDS.FieldByName('Amount').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])  + '</Amount>'+
                                               '</request>', TRESTRequestParameterKind.pkGETorPOST);

              try
                RESTRequest.Execute;
              except  on E: Exception do
                begin
                  ShowMessage('Ошибка получения цены товара: ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  exit;
                end;
              end;

              if RESTResponse.StatusCode = 200 then
              begin
                // 50239534
                XML := NewXMLDocument;
                XML.XML.Text := RESTResponse.Content;
                XML.Active := True;
                XMLNode := XML.DocumentElement.ChildNodes[0];


                OperationResult := XMLNode.ChildNodes.FindNode('OperationResult').Text;
                if (AnsiLowerCase(OperationResult) = 'ok') and Assigned (XMLNode.ChildNodes.FindNode('PatientPrice')) then
                begin
                  if TryStrToCurr(StringReplace(XMLNode.ChildNodes.FindNode('PatientPrice').Text, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]), lPrice) then
                  begin
                     // Сохранаем цену сайта
                     if bFixPrice then lPrice := CheckCDS.FieldByName('Price').asCurrency;

                     //Предполагаемое кол-во товара
                     lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                     lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False);
                     //Update
                     CheckCDS.Edit;
                     CheckCDS.FieldByName('Price').asCurrency             :=lPrice;
                     CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
                     //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
                     CheckCDS.FieldByName('SummChangePercent').asCurrency :=lSummChangePercent;
                     CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
                     CheckCDS.Post;
                  end else
                  begin
                    ShowMessage ('Ошибка получения цены.' + #10+ #13
                      + #10+ #13 + 'Цена <' + XMLNode.ChildNodes.FindNode('PatientPrice').Text + '>.'
                      + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                      + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                      //ошибка
                    lMsg:='Error';
                    exit;
                  end;
                end else
                begin
                  if AnsiLowerCase(OperationResult) = 'pharm_not_active' then OperationResult := 'Аптека (карта аптеки) не активна.'
                  else if AnsiLowerCase(OperationResult) = 'no_pharm_card' then OperationResult := 'Нет такой карты аптеки.'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_card' then OperationResult := 'Нет такой карты пациента.'
                  else if AnsiLowerCase(OperationResult) = 'card_blocked' then OperationResult := 'Карта пациента заблокирована.'
                  else if AnsiLowerCase(OperationResult) = 'not_patient_card' then OperationResult := 'Указанная карта не является картой пациента.'
                  else if AnsiLowerCase(OperationResult) = 'drug_limit' then OperationResult := 'Превышен лимит покупок по карте.'
                  else if AnsiLowerCase(OperationResult) = 'no_today_price' then OperationResult := 'Не установлена цена на препарат в личном кабинете аптеки.'
                  else if AnsiLowerCase(OperationResult) = 'no_db_or_drug_link' then OperationResult := 'Дистрибьютор не назначен аптеке, либо препарат не назначен дистрибьютору. Продажа не возможна..';
                  ShowMessage ('Ошибка проверки возможности продажи.' + #10+ #13
                    + #10+ #13 + 'Ошибка <' + OperationResult + '>.'
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  exit;
                end;
              end;

            except
                  ShowMessage ('Ошибка проверки возможности продажи.' + #10+ #13
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //ошибка
                  lMsg:='Error';
                  exit;
            end;
            //finally
          end else
          begin
              ShowMessage ('Ошибка не найден остаток по количеству одной партией нужного поставщика.' + #10+ #13
              + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
              + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
               //ошибка
              lMsg:='Error';
              exit;
          end;

      end // if BarCode_find <> ''

      //если Штрих-код нашелся и программа Medicard card
      else  if (BarCode_find <> '') and (gService = 'Medicard') then
      begin

          if FIdCasual <> '' then
          begin
            ShowMessage('В текущем чеке запрошена возможность продажи. Произведите продажу или очистите чек!');
            exit;
          end;

          //получение кода дистрибьюторов
          with spGet_Goods_CodeRazom do begin
             ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
             ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
             ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
             ParamByName('outCodeRazom').Value := 0;
             Execute;
             CodeRazom := Trunc(ParamByName('outCodeRazom').AsFloat);
             FSupplier := Trunc(ParamByName('outCodeRazom').AsFloat);
             FSIdAlter := '';
             FInvoiceNumber := ParamByName('outInvoiceNumber').Value;
          end;

          if gisTwoPackages then
          begin
            FAmountPackages := 0;
            with spGet_DiscountCard_Goods_Amount do
            begin
              ParamByName('inDiscountCard').Value  := gCardNumber;
              ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
              ParamByName('outAmount').Value := 0;
              Execute;
              FAmountPackages := ParamByName('outAmount').AsFloat;
            end;

            if (FAmountPackages = 0) and (CheckCDS.FieldByName('Amount').AsCurrency = 1) then
            begin
              FIdCasual := GenerateIdCasual;
              ShowMessage ('Информация. По карте первая продажа. Скидка будет при продаже второй упаковки.' + #10+ #13
                + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              FBarCode_find := BarCode_find;
              lMsg:='';
              Exit;
            end else if FAmountPackages > 1 then
            begin
              ShowMessage ('Ошибка По карте продажа уже осуществлена.' + #10+ #13
                + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              //ошибка
              lMsg:='Error';
              exit;
            end;

            if (FAmountPackages = 1) and (CheckCDS.FieldByName('Amount').AsCurrency <> 1) then
            begin
              ShowMessage ('Ошибка По карте продажа 1 упаковки уже осуществлена.' + #10+ #13
                + 'Можно отпустить только 1 вторую упаковку со скидкой.' + #10+ #13
                + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              //ошибка
              lMsg:='Error';
              exit;
            end;
          end;

          if CodeRazom <> 0 then
          begin
            try

              FDiscont := 0;
              FDiscontАbsolute := 0;
              FBarCode_find := '';
              FIdCasual := GenerateIdCasual;

              RESTClient.BaseURL := gURL;
              RESTClient.ContentType := 'application/xml';

              RESTRequest.ClearBody;
              RESTRequest.Method := TRESTRequestMethod.rmPOST;
              RESTRequest.Resource := '';

              RESTRequest.Params.Clear;
              RESTRequest.AddParameter('medicard',
                EncodeString('<?xml version="1.0" encoding="UTF-8"?>'#13#10 +
                             '<data>'#13#10 +
                             '  <request_type>1</request_type>'#13#10 +
                             '  <id_casual>' + FIdCasual + '</id_casual>'#13#10 +
                             '  <inside_code>' + gExternalUnit + '</inside_code>'#13#10 +
                             '  <supplier>' + IntToStr(FSupplier) + '</supplier >'#13#10 +
                             '  <card_code>' + gCardNumber + '</card_code>'#13#10 +
                             '  <product_code>' + BarCode_find + '</product_code>'#13#10 +
                             '  <price>' + CurrToStrXML(CheckCDS.FieldByName('PriceSale').AsCurrency) + '</price>'#13#10 +
                             '  <qty>' + CurrToStrXML(CheckCDS.FieldByName('Amount').AsCurrency + FAmountPackages) + '</qty>'#13#10 +
                             '  <login>' + gUserName + '</login>'#13#10 +
                             '  <password>' + gPassword + '</password>'#13#10 +
                             '</data>'));
              try
                RESTRequest.Execute;
              except  on E: Exception do
                begin
                  ShowMessage('Ошибка получения цены товара: ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  FIdCasual := '';
                  exit;
                end;
              end;

              if (RESTResponse.StatusCode = 200) and (LowerCase(RESTResponse.StatusText) = 'ok') then
              begin
                XML := NewXMLDocument;
                XML.XML.Text := DecodeString(RESTResponse.Content);
                XML.Active := True;
                XMLData := XML.DocumentElement;

                XMLNode := XMLData.ChildNodes.FindNode('id_casual');
                if Assigned(XMLNode) then
                begin
                  if FIdCasual = XMLNode.Text then
                  begin

                    XMLNode := XMLData.ChildNodes.FindNode('discont');
                    if Assigned(XMLNode) then
                    begin
                      FDiscont := XMLNode.NodeValue;
                      if gisTwoPackages and (FAmountPackages = 1) then FDiscont := FDiscont * 2;
                    end;

                    XMLNode := XMLData.ChildNodes.FindNode('discont_absolute');
                    if Assigned(XMLNode) then
                    begin
                      FDiscontАbsolute := XMLNode.NodeValue;
                     if gisTwoPackages and (FAmountPackages = 1) then FDiscontАbsolute := FDiscontАbsolute * 2;
                    end;

                    XMLNode := XMLData.ChildNodes.FindNode('error');
                    if Assigned(XMLNode) then
                    begin
                      if (XMLNode.Text <> '202') and (XMLNode.Text <> '202a') and (XMLNode.Text <> '202b') then FIdCasual := ''
                      else FBarCode_find := BarCode_find;
                    end else FIdCasual := '';

                    if (FDiscont > 0.0001) and (FIdCasual <> '') then
                    begin
                       //Update
                       CheckCDS.Edit;
                       CheckCDS.FieldByName('Price').asCurrency   := GetPrice(CheckCDS.FieldByName('PriceSale').asCurrency, FDiscont);
                       //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
                       CheckCDS.FieldByName('ChangePercent').asCurrency := FDiscont;
                       CheckCDS.FieldByName('Summ').asCurrency :=
                          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
                          CheckCDS.FieldByName('Price').asCurrency,
                          MainCashForm.FormParams.ParamByName('RoundingDown').Value);
                       CheckCDS.FieldByName('SummChangePercent').asCurrency :=
                          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
                          CheckCDS.FieldByName('PriceSale').asCurrency,
                          MainCashForm.FormParams.ParamByName('RoundingDown').Value) -
                          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
                          CheckCDS.FieldByName('Price').asCurrency,
                          MainCashForm.FormParams.ParamByName('RoundingDown').Value);
                       CheckCDS.Post;
                    end;

                  end else FIdCasual := '';
                end else FIdCasual := '';

                XMLNode := XMLData.ChildNodes.FindNode('message');
                if Assigned(XMLNode) then
                begin
                  if FIdCasual <> '' then
                  begin
                    ShowMessage ('Информация о продажи.' + #10+ #13
                      + #10+ #13 + 'Информация <' + XMLNode.Text + '>.'
                      + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                      + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  end else
                  begin
                    ShowMessage ('Ошибка проверки возможности продажи.' + #10+ #13
                      + #10+ #13 + 'Ошибка <' + XMLNode.Text + '>.'
                      + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                      + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                      //ошибка
                    lMsg:='Error';
                    exit;
                  end;

                end else FIdCasual := '';
              end else FIdCasual := '';

            except
                  ShowMessage ('Ошибка проверки возможности продажи.' + #10+ #13
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //ошибка
                  lMsg:='Error';
                  FIdCasual := '';
                  exit;
            end;
            //finally
          end else
          begin
              ShowMessage ('Ошибка не найден остаток по количеству одной партией нужного поставщика.' + #10+ #13
              + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
              + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
               //ошибка
              lMsg:='Error';
              exit;
          end;
      end

      //если Штрих-код нашелся и программа Здоровье от Байер card
      else if (BarCode_find <> '') and (gService = 'ServiceXap') and (gUserName <> '') then
      begin

          //получение кода дистрибьюторов
          with spGet_Goods_CodeRazom do begin
             ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
             ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
             ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
             ParamByName('outCodeRazom').Value := 0;
             Execute;
             CodeRazom := Trunc(ParamByName('outCodeRazom').AsFloat);
          end;

          if CodeRazom <> 0 then
          begin
            try

              RESTClient.BaseURL := gURL;
              RESTClient.ContentType := 'application/x-www-form-urlencoded';

              RESTRequest.ClearBody;
              RESTRequest.Method := TRESTRequestMethod.rmPOST;
              RESTRequest.Resource := '';

              RESTRequest.Params.Clear;
              RESTRequest.AddParameter('token', gExternalUnit, TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('request_format', 'xml', TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('response_format', 'xml', TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('project_id', gPort, TRESTRequestParameterKind.pkGETorPOST);
              RESTRequest.AddParameter('data', '<?xml version="1.0"?>'+
                                               '<request><Operation>1</Operation>'+
                                                       '<PharmCard>' + gUserName + '</PharmCard>'+
                                                       '<PatientCard>' + gCardNumber + '</PatientCard>'+
                                                       '<DrugCode>' + BarCode_find + '</DrugCode>'+
                                                       '<Distributor>' + IntToStr(CodeRazom) + '</Distributor>'+
                                                       '<SessionId>1</SessionId>'+
                                                       '<PharmPrice>' + StringReplace(CheckCDS.FieldByName('PriceSale').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])  + '</PharmPrice>'+
                                                       '<Amount>' + StringReplace(CheckCDS.FieldByName('Amount').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])  + '</Amount>'+
                                               '</request>', TRESTRequestParameterKind.pkGETorPOST);
              cExchangeHistory := 'URL' + gURL + #13#10 +
                                  'XML звпроса'#13#10 + RESTRequest.Params.ParameterByName('data').Value;

              try
                RESTRequest.Execute;
              except  on E: Exception do
                begin
                  ShowMessage('Ошибка получения цены товара: ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  exit;
                end;
              end;

              cExchangeHistory := cExchangeHistory + #13#10 +
                                  'Ответ:'#13#10 + RESTResponse.Content;

              if RESTResponse.StatusCode = 200 then
              begin
                // 00000003
                XML := NewXMLDocument;
                XML.XML.Text := RESTResponse.Content;
                XML.Active := True;

                OperationResult := XML.DocumentElement.ChildNodes[0].ChildNodes[0].Text;
                if AnsiLowerCase(OperationResult) = 'ok' then
                begin

                  if TryStrToCurr(StringReplace(XML.DocumentElement.ChildNodes[0].ChildNodes[2].Text, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]), lPrice) then
                  begin
                     //Предполагаемое кол-во товара
                     lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                     lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False);
                     //Update
                     CheckCDS.Edit;
                     CheckCDS.FieldByName('Price').asCurrency             :=lPrice;
                     CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
                     //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
                     CheckCDS.FieldByName('SummChangePercent').asCurrency :=lSummChangePercent;
                     CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
                     CheckCDS.Post;
                  end else
                  begin
                    ShowMessage ('Ошибка получения цены.' + #10+ #13
                      + #10+ #13 + 'Цена <' + XML.DocumentElement.ChildNodes[0].ChildNodes[2].Text + '>.'
                      + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                      + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                      //ошибка
                    lMsg:='Error';
                    exit;
                  end;
                end else
                begin
                  if AnsiLowerCase(OperationResult) = 'pharm_not_active' then OperationResult := 'Аптека (карта аптеки) не активна.'
                  else if AnsiLowerCase(OperationResult) = 'no_pharm_card' then OperationResult := 'Нет такой карты аптеки.'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_card' then OperationResult := 'Нет такой карты пациента.'
                  else if AnsiLowerCase(OperationResult) = 'card_blocked' then OperationResult := 'Карта пациента заблокирована.'
                  else if AnsiLowerCase(OperationResult) = 'not_patient_card' then OperationResult := 'Указанная карта не является картой пациента.'
                  else if AnsiLowerCase(OperationResult) = 'drug_limit' then OperationResult := 'Превышен лимит покупок по карте.'
                  else if AnsiLowerCase(OperationResult) = 'no_today_price' then OperationResult := 'Не установлена цена на препарат в личном кабинете аптеки.'
                  else if AnsiLowerCase(OperationResult) = 'no_db_or_drug_link' then OperationResult := 'Дистрибьютор не назначен аптеке, либо препарат не назначен дистрибьютору. Продажа не возможна..'
                  else if AnsiLowerCase(OperationResult) = 'patient_not_registered' then OperationResult := 'Пациент еще не зарегистрирован в программе..'
                  else if AnsiLowerCase(OperationResult) = 'high_price' then OperationResult := 'Превышен лимит по цене..'
                  else if AnsiLowerCase(OperationResult) = 'low_price' then OperationResult := 'Превышен лимит по цене..'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_drug' then OperationResult := 'Данный препарат не доступен этому пациенту..';
                  ShowMessage ('Ошибка проверки возможности продажи.' + #10+ #13
                    + #10+ #13 + 'Ошибка <' + OperationResult + '>.'
                    + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                    + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //ошибка
                  lMsg:='Error';
                  exit;
                end;
              end;

            except
                  ShowMessage ('Ошибка проверки возможности продажи.' + #10+ #13
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //ошибка
                  lMsg:='Error';
                  exit;
            end;
            //finally
          end;

      end else if (BarCode_find <> '') and (gCode in [16]) then
      begin

          // проверим карту
          if Copy(lCardNumber, 1, 5) <> '21016' then
          begin
            ShowMessage ('Ошибка проверки возможности продажи.' + #10+ #13
            + #10+ #13 + 'Карта № <' + lCardNumber + '> не пренадлешит проекту.');
            //ошибка
            lMsg:='Error';
            Exit;
          end;

          //получение кода дистрибьюторов
          with spGet_Goods_CodeRazom do begin
             ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
             ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
             ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
             ParamByName('outCodeRazom').Value := 0;
             ParamByName('outDiscountProcent').Value := 0;
             ParamByName('outDiscountSum').Value := 0;
             Execute;
             FSupplier := Trunc(ParamByName('outCodeRazom').AsFloat);
          end;

          if FSupplier <> 0 then
          begin
            try

               // на всяк случай - с условием
               if CheckCDS.FieldByName('PriceSale').asFloat > 0
               then lPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
               else lPriceSale:= CheckCDS.FieldByName('Price').asFloat;
               if spGet_Goods_CodeRazom.ParamByName('outDiscountProcent').Value > 0 then
               begin
                 lChangePercent := 10;
                 //Предполагаемое кол-во товара
                 lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                 // тоже типа как для кол-ва = 1, может так правильно округлит?
                 lPrice:= GetSumm(1, lPriceSale * (1 - lChangePercent / 100), False);
                 // а еще досчитаем сумму скидки
                 lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False);
               end else if spGet_Goods_CodeRazom.ParamByName('outDiscountSum').Value > 0 then
               begin
                 lChangePercent := 0;
                 //Предполагаемое кол-во товара
                 lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                 // тоже типа как для кол-ва = 1, может так правильно округлит?
                 lPrice:= GetSumm(1, lPriceSale - spGet_Goods_CodeRazom.ParamByName('outDiscountSum').Value, False);
                 // а еще досчитаем сумму скидки
                 lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False);
               end else
               begin
                 lChangePercent := 0;
                 //Предполагаемое кол-во товара
                 lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                 // тоже типа как для кол-ва = 1, может так правильно округлит?
                 lPrice:= lPriceSale;
                 // а еще досчитаем сумму скидки
                 lSummChangePercent := 0;
               end;
               //Update
               CheckCDS.Edit;
               CheckCDS.FieldByName('Price').asCurrency             :=lPrice;
               CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
               //Рекомендованная скидка в виде % от цены
               CheckCDS.FieldByName('ChangePercent').asCurrency     :=lChangePercent;
               //Общая сумма скидки за все кол-во товара
               CheckCDS.FieldByName('SummChangePercent').asCurrency :=lSummChangePercent;
               CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
               CheckCDS.Post;

            except
                  ShowMessage ('Ошибка проверки возможности продажи.' + #10+ #13
                  + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
                  + #10+ #13 + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //ошибка
                  lMsg:='Error';
                  exit;
            end;
            //finally
          end;

      end // if BarCode_find <> ''

        // иначе - обнуляем скидку
      else if (gService <> 'AbbottCard') or (gUserName <> '') then
      begin
               // на всяк случай - с условием
               if CheckCDS.FieldByName('PriceSale').asFloat > 0
               then lPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
               else lPriceSale:= CheckCDS.FieldByName('Price').asFloat;
               // Update
               CheckCDS.Edit;
               CheckCDS.FieldByName('Price').asCurrency             :=lPriceSale;
               CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
               //Рекомендованная скидка в виде % от цены
               CheckCDS.FieldByName('ChangePercent').asCurrency     :=0;
               //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
               CheckCDS.FieldByName('SummChangePercent').asCurrency :=0;
               CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency, lPriceSale, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
               CheckCDS.Post;
           end;
      //
      CheckCDS.Next;

    end; // while not CheckCDS.Eof

    // завершили - очистили
    SendList:= nil;
    Item := nil;
    ResList := nil;
    ResItem := nil;


  finally
    CheckCDS.Filtered := True;
    if GoodsId <> 0 then
      CheckCDS.Locate('GoodsId',GoodsId,[]);
    CheckCDS.EnableControls;
    //
    List_GoodsId.Free;
    List_BarCode.Free;

    // Вернули есть ли ошибка
    Result := lMsg = '';
//    if not Result and (cExchangeHistory <> '')  then
//       TMessagesForm.Create(nil).Execute('Результат обмена данными', cExchangeHistory, True);
  end;


end;

function TDiscountServiceForm.GetBeforeSale : boolean;
begin
  if (gService = 'Medicard') then
  begin
    Result := (FIdCasual <> '');
  end else if (gCode in [16])  then
  begin
    Result := (FSupplier <> 0);
  end else Result := True;
end;

function TDiscountServiceForm.GetPrepared : boolean;
begin
  if (gService = 'Medicard') then
  begin
    Result := (FIdCasual <> '');
  end else Result := False;
end;

procedure TDiscountServiceForm.SetBeforeSale(Values: boolean);
begin
  FDiscont := 0;
  FDiscontАbsolute := 0;
  FIdCasual := '';
  FBarCode_find := '';
  FSupplier := 0;
end;

end.
