unit DiscountService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Soap.InvokeRegistry, Vcl.StdCtrls, System.Contnrs,
  Soap.Rio, Soap.SOAPHTTPClient, uCardService, dsdDB, Datasnap.DBClient, Data.DB,
  MediCard.Intf, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TMorionCode = class
  private
    FGoodsId: Integer;
    FMorionCode: Integer;
    function GetGoodsId: Integer;
    function GetMorionCode: Integer;
  public
    constructor Create(AGoodsId, AMorionCode: Integer);
    property GoodsId: Integer read GetGoodsId;
    property MorionCode: Integer read GetMorionCode;
  end;

  TMorionList = class(TObjectList)
  private
    function GetMorionCode(Index: Integer): TMorionCode;
    procedure SetMorionCode(Index: Integer; const Value: TMorionCode);
  public
    function Find(AGoodsId: Integer): Integer;
    procedure Save(AGoodsId, AMorionCode: Integer);
    property Items[Index: Integer]: TMorionCode read GetMorionCode write SetMorionCode; default;
  end;

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
  private
    FMorionList: TMorionList;
    function GetMorionList: TMorionList;
    function myFloatToStr(aValue: Double) : String;
    function myStrToFloat(aValue: String) : Double;
  public
    // так криво будем хранить "текущие" параметры-Main
    gURL, gService, gPort, gUserName, gPassword, gCardNumber, gExternalUnit: string;
    gDiscountExternalId, gCode: Integer;
    // так криво будем хранить "текущие" параметры-Item
    //gGoodsId : Integer;
    //gPriceSale, gPrice, gChangePercent, gSummChangePercent : Currency;
    //
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    // обнулим "нужные" параметры-Item
    //procedure pSetParamItemNull;
    // попробуем обновить "нужные" параметры-Main
    procedure pGetDiscountExternal (lDiscountExternalId : Integer; lCardNumber : String);
    // проверка карты + сохраним "текущие" параметры-Main
    function fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string; lDiscountExternalId : Integer) :Boolean;
    // получили Дисконт + сохраним "текущие" параметры-Item
    //function fGetSale (var lMsg : string; var lPrice, lChangePercent, lSummChangePercent : Currency;
    //                                    lCardNumber : string; lDiscountExternalId, lGoodsId : Integer; lQuantity, lPriceSale : Currency;
    //                                    lGoodsCode : Integer; lGoodsName  : string) :Boolean;
    // Update Дисконт в CDS - по всем "обновим" Дисконт
    function fUpdateCDS_Discount (CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) :Boolean;
    // Commit Дисконт из CDS - по всем
    function fCommitCDS_Discount (fCheckNumber:String; CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) :Boolean;
    //
    // update DataSet - еще раз по всем "обновим" Дисконт
    //function fUpdateCDS_Item(CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) : Boolean;
    //
    // Send All Movement - Income
    function fPfizer_Send (var lMsg : string) :Boolean;
    // Send Item - Income
    function fPfizer_SendItem (lMovementId: Integer;
                               lOperDate : TDateTime;
                               lInvNumber : String;
                               lFromOKPO, lFromName : String;
                               lToOKPO, lToName : String;
                               var lMsg : string) :Boolean;

    function FindMorionCode(AGoodsId: Integer): Integer;
    procedure SaveMorionCode(AGoodsId, AMorionCode: Integer);
  end;

var
  DiscountServiceForm: TDiscountServiceForm;

implementation
{$R *.dfm}
uses Soap.XSBuiltIns
   , MainCash2, UtilConvert
   , XMLIntf, XMLDoc, OPToSOAPDomConv;

function TDiscountServiceForm.GetMorionList: TMorionList;
begin
  if not Assigned(FMorionList) then
    FMorionList := TMorionList.Create;
  Result := FMorionList;
end;

procedure TDiscountServiceForm.AfterConstruction;
begin
  inherited AfterConstruction;
  FMorionList := nil;
end;

procedure TDiscountServiceForm.BeforeDestruction;
begin
  if Assigned(FMorionList) then
    FreeAndNil(FMorionList);
  inherited BeforeDestruction;
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
      XML:= NewXMLDocument;
      NodeRoot:= XML.AddChild('Root');
      NodeParent:= NodeRoot.AddChild('Parent');
      Converter:= TSOAPDomConv.Create(NIL);
      NodeObject:= Source.ObjectToSOAP(NodeRoot, NodeParent, Converter, 'CopyObject', '', '', [ocoDontPrefixNode], XMLStr);
      XML.SaveToFile('D:\21ItemCommit.xml');
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
               gURL          := ParamByName('URL').Value;
               gService      := ParamByName('Service').Value;
               gPort         := ParamByName('Port').Value;
               gUserName     := ParamByName('UserName').Value;
               gPassword     := ParamByName('Password').Value;
               gCardNumber   := lCardNumber;
               gExternalUnit := ParamByName('ExternalUnit').AsString;
               // для проекта Медикард
               if lCode = 3 then
                 MCDesigner.URL := gURL;
         end
         else begin
               gURL          := '';
               gService      := '';
               gPort         := '';
               gUserName     := '';
               gPassword     := '';
               gCardNumber   := '';
               gExternalUnit := '';
               ShowMessage ('Ошибка.Для аптеки не настроена работа с Проектами дисконтных карт.')
         end;
      end
  else
     begin
          //обнулим параметры-Main
          gDiscountExternalId:= 0;
          gCode         := 0;
          gURL          := '';
          gService      := '';
          gPort         := '';
          gUserName     := '';
          gPassword     := '';
          gCardNumber   := '';
          gExternalUnit := '';
     end;
end;

procedure TDiscountServiceForm.SaveMorionCode(AGoodsId, AMorionCode: Integer);
begin
  GetMorionList.Save(AGoodsId, AMorionCode);
end;

// Commit Дисконт из CDS - по всем
function TDiscountServiceForm.fCommitCDS_Discount (fCheckNumber:String; CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) :Boolean;
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
  Session: IMCSession;
  CasualId: string;
  lQuantity, lPriceSale: Currency;
  //
  XML: IXMLDocument;
  OperationResult : String;
  CodeRazom : Integer;
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
    if lDiscountExternalId > 0 then
      if gCode = 1 then
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
                Item.PrimaryAmount := TXSDecimal.Create;
                Item.PrimaryAmount.XSToNative (myFloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('PriceSale').AsFloat, False)));

                //Цена товара (с учетом скидки)
                Item.RequestedPrice := TXSDecimal.Create;
                Item.RequestedPrice.XSToNative (myFloatToStr (CheckCDS.FieldByName('Price').AsFloat));
                //Кол-во товара
                Item.RequestedQuantity := TXSDecimal.Create;
                Item.RequestedQuantity.XSToNative (myFloatToStr (CheckCDS.FieldByName('Amount').AsFloat));
                //Сумма за кол-во товара (с учетом скидки)
                Item.RequestedAmount := TXSDecimal.Create;
                Item.RequestedAmount.XSToNative(myFloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('Price').AsFloat, False)));

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
              //***SaveToXMLFile_ItemCommit(aSaleRequest);
              //!!!для теста!!!

              // Отправили запрос
              ResList := (HTTPRIO as CardServiceSoap).commitCardSale(aSaleRequest, gUserName, gPassword);

              //!!!для теста!!!
              //***SaveToXMLFile_ItemCommitRes(ResList);
              //!!!для теста!!!


              // Получили результат - если элементов в результате не будет
              if (Length(ResList.Items)) = 0 then
              begin
                //обработали результат
                llMsg:= ResList.ResultDescription;
                lMsg:= lMsg + llMsg;
                Result:= LowerCase(llMsg) = LowerCase('Продажа доступна');
                //
                if not Result
                then ShowMessage ('Ошибка <' + gService + '>.Карта № <' + lCardNumber + '>.' + #10+ #13 + llMsg);
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

                if not Result
                then ShowMessage ('Ошибка <' + gService + '>.Карта № <' + lCardNumber + '>.' + #10+ #13 + llMsg);

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
      if (gCode = 2) and (gUserName <> '') then
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
              RESTRequest.AddParameter('project_id', '1', TRESTRequestParameterKind.pkGETorPOST);
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
                end else Result:= True //!!!все ОК и Чек можно сохранить!!!;
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
      end else if gCode = 2 then

        Result:= True //!!!все ОК и Чек можно сохранить!!!

      else
      if (gCode = 3) then
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
              RESTRequest.AddParameter('project_id', '3', TRESTRequestParameterKind.pkGETorPOST);
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
                end else Result:= True //!!!все ОК и Чек можно сохранить!!!;
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
      end else if gCode = 4 then

        Result:= True //!!!все ОК и Чек можно сохранить!!!
      ;
//       else if gCode = 3 then
//      begin
//        CheckCDS.First;
//
//        while not CheckCDS.Eof do
//        begin
//          if (CheckCDS.FieldByName('ChangePercent').asCurrency <> 0) or
//            (CheckCDS.FieldByName('SummChangePercent').asCurrency <> 0) then
//          begin
//            MCDesigner.CreateObject(IMCSessionSale).GetInterface(IMCSession, Session);
//
//            //Предполагаемое кол-во товара
//            lQuantity := CheckCDS.FieldByName('Amount').asFloat;
//            // на всяк случай - с условием
//            if CheckCDS.FieldByName('PriceSale').AsFloat > 0 then
//              lPriceSale := CheckCDS.FieldByName('PriceSale').AsFloat
//            else
//              lPriceSale := CheckCDS.FieldByName('Price').AsFloat;
//
//            CasualId := MCDesigner.CasualCache.Find(CheckCDS.FieldByName('GoodsId').AsInteger, lPriceSale);
//
//            if CasualId <> '' then
//            begin
//              with Session.Request.Params do
//              begin
//                ParamByName('id_casual').AsString := CasualId;
//                ParamByName('inside_code').AsString := gExternalUnit;
//                ParamByName('supplier').AsInteger := 0; // Здесь надо присваивать ИД поставщика из справочника медикард
//                ParamByName('id_alter').AsString := fCheckNumber;
//                ParamByName('sale_status').AsInteger := MC_SALE_COMPLETE;
//                ParamByName('card_code').AsString := lCardNumber;
//                ParamByName('product_code').AsInteger := FindMorionCode(CheckCDS.FieldByName('GoodsId').asInteger);
//                ParamByName('price').AsFloat := lPriceSale;
//                ParamByName('qty').AsFloat := lQuantity;
//                ParamByName('rezerv').AsFloat := lQuantity;
//                ParamByName('discont_percent').AsFloat := CheckCDS.FieldByName('ChangePercent').asCurrency;
//                ParamByName('discont_value').AsFloat := CheckCDS.FieldByName('SummChangePercent').asCurrency;
//                ParamByName('sale_date').AsString := FormatDateTime('yyy-mm-dd hh:mm:ss', Now);
//              end;
//
//              try
//                if Session.Post = 200 then
//                  with Session.Response.Params do
//                  begin
//                    Result := Pos('200', ParamByName('error').AsString) = 1;
//                    if not Result then
//                      ShowMessage ('Ошибка <' + gService + '>.Карта № <' + lCardNumber + '>.'
//                        + sLineBreak + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')'
//                        + CheckCDS.FieldByName('GoodsName').AsString
//                        + sLineBreak + Utf8ToAnsi(ParamByName('message').AsString));
//                  end;
//              except
//                ShowMessage ('Ошибка на сервере <' + gURL + '>.' + sLineBreak
//                  + sLineBreak + 'Для карты № <' + lCardNumber + '>.'
//                  + sLineBreak + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')'
//                  + CheckCDS.FieldByName('GoodsName').AsString);
//                //ошибка
//                lMsg:='Error';
//              end;
//            end;
//          end;
//
//          CheckCDS.Next;
//        end;
//      end;
  finally
    CheckCDS.Filtered := True;
    if GoodsId <> 0 then
      CheckCDS.Locate('GoodsId',GoodsId,[]);
    CheckCDS.EnableControls;
  end;

end;

function TDiscountServiceForm.FindMorionCode(AGoodsId: Integer): Integer;
begin
  Result := GetMorionList.Find(AGoodsId);
end;

// Send All Movement - Income
function TDiscountServiceForm.fPfizer_Send (var lMsg : string) :Boolean;
var llMsg : String;
begin
    try
      //Получили данные
      with spGet_DiscountExternal do
      begin
           ParamByName('inId').Value := 2807930; // захардкодил - ЗАРАДИ ЖИТТЯ
           Execute;
           // сохраним "нужные" параметры-Main
           gDiscountExternalId:= 2807930;
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
          //***SaveToXMLFile_ItemOrder(aOrderRequest);
          //!!!для теста!!!

          // Отправили запрос
          Res := (HTTPRIO as CardServiceSoap).commitOrder(aOrderRequest, gUserName, gPassword);

          //!!!для теста!!!
          //***SaveToXMLFile_ItemCommitRes(ResList);
          //!!!для теста!!!


          //обработали результат
          lMsg:= Res.ResultDescription;
          Result:= LowerCase(lMsg) = LowerCase('OK');
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
function TDiscountServiceForm.fUpdateCDS_Discount (CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) :Boolean;
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
  Session: IMCSession;
  //
  XML: IXMLDocument;
  OperationResult : String;
  CodeRazom : Integer;
begin
  Result:= false;
  lMsg  := '';
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
      if (lDiscountExternalId > 0) and ((gCode = 1) or (gCode = 2) and (gUserName <> '') or (gCode = 3) or (gCode = 4)) and
         (CheckCDS.FieldByName('Amount').AsFloat > 0)
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

      //если Штрих-код нашелся и программа ЗАРАДИ ЖИТТЯ
      if (BarCode_find <> '') and (gCode = 1) then
      begin
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

      end // if BarCode_find <> ''

      //если Штрих-код нашелся и программа Abbott card
      else if (BarCode_find <> '') and (gCode = 2) then
      begin

          //получение кода дистрибьюторов
          with spGet_Goods_CodeRazom do begin
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
              RESTRequest.AddParameter('project_id', '1', TRESTRequestParameterKind.pkGETorPOST);
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
          end;

      end // if BarCode_find <> ''
      else   if (BarCode_find <> '') and (gCode = 3) then
      begin

          //получение кода дистрибьюторов
          with spGet_Goods_CodeRazom do begin
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
              RESTRequest.AddParameter('project_id', '3', TRESTRequestParameterKind.pkGETorPOST);
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
          end;

      end else if (BarCode_find <> '') and (gCode = 4) then
      begin

      end else
        // иначе - обнуляем скидку
      if (gCode <> 2) or (gUserName <> '') then
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
               lChangePercent     := ResItem.ResultDiscountPercent;
               //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
               lSummChangePercent := ResItem.ResultDiscountAmount;

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

    // завершили - очистили
    SendList:= nil;
    Item := nil;
    ResList := nil;
    ResItem := nil;

//    if (lDiscountExternalId > 0) and (gCode = 3) then
//    begin
//      // запрос скидок у Медикард
//
//      CheckCDS.First;
//
//      while not CheckCDS.Eof do
//      begin
//        MorionCode := FindMorionCode(CheckCDS.FieldByName('GoodsId').AsInteger);
//
//        if (MorionCode <> -1) and (MorionCode <> 0) then
//        begin
//          //Предполагаемое кол-во товара
//          lQuantity := CheckCDS.FieldByName('Amount').asFloat;
//          // на всяк случай - с условием
//          if CheckCDS.FieldByName('PriceSale').AsFloat > 0 then
//            lPriceSale := CheckCDS.FieldByName('PriceSale').AsFloat
//          else
//            lPriceSale := CheckCDS.FieldByName('Price').AsFloat;
//
//          CasualId := MCDesigner.CasualCache.Find(CheckCDS.FieldByName('GoodsId').AsInteger, lPriceSale);
//
//          if (CasualId <> '') then
//          begin
//            MCDesigner.CreateObject(IMCSessionDiscount).GetInterface(IMCSession, Session);
//            // задаем параметры для запроса скидки
//            with Session.Request.Params do
//            begin
//              ParamByName('id_casual').AsString := CasualId;
//              ParamByName('inside_code').AsString := gExternalUnit;
//              ParamByName('card_code').AsString := lCardNumber;
//              ParamByName('product_code').AsInteger := MorionCode;
//              ParamByName('qty').AsFloat := lQuantity;
//              ParamByName('price').AsFloat := lPriceSale;
//            end;
//
//            try
//              // выполним запрос
//              if Session.Post = 200 then
//                with Session.Response.Params do
//                begin
//                  if Pos('202', ParamByName('error').AsString) = 1 then
//                  begin
//                    //Рекомендованная скидка в виде % от цены
//                    lChangePercent := ParamByName('discont').AsFloat;
//                    //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
//                    lSummChangePercent := ParamByName('discont_absolute').AsFloat;
//
//                    //!!! расчет Цена - уже со скидкой !!!
//                    if lSummChangePercent > 0 then
//                      // типа как для кол-ва = 1, может так правильно округлит?
//                      lPrice := GetSumm(1, (GetSumm(lQuantity, lPriceSale, False) - lSummChangePercent) / lQuantity, False)
//                    else
//                    begin
//                      // тоже типа как для кол-ва = 1, может так правильно округлит?
//                      lPrice:= GetSumm(1, lPriceSale * (1 - lChangePercent / 100), False);
//                      // а еще досчитаем сумму скидки
//                      lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False)
//                    end;
//
//                    //проверка
//                    if lSummChangePercent >= GetSumm(lQuantity, lPriceSale, False) then
//                    begin
//                      ShowMessage ('Ошибка.Сумма скидки  <' + myFloatToStr(lSummChangePercent)
//                        + '> не может быть больше чем <' + myFloatToStr(GetSumm(lQuantity, lPriceSale, False)) + '>.'
//                        + sLineBreak + 'Для карты № <' + lCardNumber + '>.'
//                        + sLineBreak + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')'
//                        + CheckCDS.FieldByName('GoodsName').AsString);
//                      //ошибка
//                      lMsg := 'Error';
//                      //
//                      lPrice             := lPriceSale;
//                      lChangePercent     := 0;
//                      lSummChangePercent := 0;
//                    end;
//                  end else
//                  begin
//                    lPrice             := lPriceSale;
//                    lChangePercent     := 0;
//                    lSummChangePercent := 0;
//                    //
//                    ShowMessage ('Ошибка <' + gService + '>.Карта № <' + gCardNumber + '>.'
//                      + sLineBreak + Utf8ToAnsi(ParamByName('message').AsString));
//                  end;
//
//                  //Update
//                  CheckCDS.Edit;
//                  CheckCDS.FieldByName('Price').asCurrency             := lPrice;
//                  CheckCDS.FieldByName('PriceSale').asCurrency         := lPriceSale;
//                  //Рекомендованная скидка в виде % от цены
//                  CheckCDS.FieldByName('ChangePercent').asCurrency     := lChangePercent;
//                  //Рекомендованная скидка в виде фиксированной суммы от общей цены за все кол-во товара (общая сумма скидки за все кол-во товара)
//                  CheckCDS.FieldByName('SummChangePercent').asCurrency := lSummChangePercent;
//                  CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
//                  CheckCDS.Post;
//                end;
//            except
//              ShowMessage ('Ошибка на сервере <' + gURL + '>.' + sLineBreak
//                + sLineBreak + 'Для карты № <' + lCardNumber + '>.'
//                + sLineBreak + 'Товар (' + CheckCDS.FieldByName('GoodsCode').AsString + ')'
//                + CheckCDS.FieldByName('GoodsName').AsString);
//              //ошибка
//              lMsg:='Error';
//            end;
//          end;
//        end;
//
//        CheckCDS.Next;
//      end;
//    end;

  finally
    CheckCDS.Filtered := True;
    if GoodsId <> 0 then
      CheckCDS.Locate('GoodsId',GoodsId,[]);
    CheckCDS.EnableControls;
    //
    List_GoodsId.Free;
    List_BarCode.Free;
  end;

  // Вернули есть ли ошибка
  Result := lMsg = '';

end;


// получили Дисконт + сохраним "текущие" параметры-Item
{function TDiscountServiceForm.fGetSale (var lMsg : string; var lPrice, lChangePercent, lSummChangePercent : Currency;
                                        lCardNumber : string; lDiscountExternalId, lGoodsId : Integer; lQuantity, lPriceSale : Currency;
                                        lGoodsCode : Integer; lGoodsName  : string) :Boolean;
var
  SendList : ArrayOfCardCheckItem;
  Item : CardCheckItem;
  ResList : ArrayOfCardCheckResultItem;
  ResItem : CardCheckResultItem;
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
  try
    //Код карточки
    Item.MdmCode := lCardNumber;
    //Штрих код товара
    Item.ProductFormCode := BarCode_find;
    //Тип продажи (0 коммерческий\1 акционный)
    Item.SaleType := '1'; // Re: Иногда ставят и 0 - когда продажа без карты
    //Предполагаемая цена товара
    Item.RequestedPrice := TXSDecimal.Create;
    Item.RequestedPrice.XSToNative(FloatToStr(lPriceSale));
    //Предполагаемое кол-во товара
    Item.RequestedQuantity := TXSDecimal.Create;
    Item.RequestedQuantity.XSToNative(FloatToStr(lQuantity));
    //Предполагаемая сумма за кол-во товара
    Item.RequestedAmount := TXSDecimal.Create;
    Item.RequestedAmount.XSToNative(FloatToStr( GetSumm(lQuantity, lPriceSale)));

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
        ShowMessage ('Ошибка <' + gService + '>.Карта № <' + gCardNumber + '>.' + #10+ #13 + lMsg);
  except
        ShowMessage ('Ошибка на сервере <' + gURL + '>.' + #10+ #13
        + #10+ #13 + 'Для карты № <' + lCardNumber + '>.'
        + #10+ #13 + 'Товар (' + IntToStr(lGoodsCode) + ')' + lGoodsName);
        //ошибка, НЕ сохранится в CheckCDS (хотя не всегда)
        lMsg:='Error';
        Result := false;
  end;
  //finally
    Item := nil;
    ResItem := nil;
end;}

// обнулим "нужные" параметры-Item
{procedure TDiscountServiceForm.pSetParamItemNull;
begin
  //очистили
  gGoodsId           := 0;
  gPriceSale         := 0;
  gPrice             := 0;
  gChangePercent     := 0;
  gSummChangePercent := 0;
end;}

{ TMorionCode }

constructor TMorionCode.Create(AGoodsId, AMorionCode: Integer);
begin
  inherited Create;
  FGoodsId := AGoodsId;
  FMorionCode := AMorionCode;
end;

function TMorionCode.GetGoodsId: Integer;
begin
  Result := FGoodsId;
end;

function TMorionCode.GetMorionCode: Integer;
begin
  Result := FMorionCode;
end;

{ TMorionList }

function TMorionList.Find(AGoodsId: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(Count) do
    if Items[I].GoodsId = AGoodsId then
    begin
      Result := Items[I].MorionCode;
      Break;
    end;
end;

function TMorionList.GetMorionCode(Index: Integer): TMorionCode;
begin
  Result := inherited GetItem(Index) as TMorionCode;
end;

procedure TMorionList.Save(AGoodsId, AMorionCode: Integer);
begin
  if Find(AGoodsId) = -1 then
    Add(TMorionCode.Create(AGoodsId, AMorionCode));
end;

procedure TMorionList.SetMorionCode(Index: Integer; const Value: TMorionCode);
begin
  inherited SetItem(Index, Value);
end;

end.
