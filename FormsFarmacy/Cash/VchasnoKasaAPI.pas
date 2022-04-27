unit VchasnoKasaAPI;

interface

uses
  Windows, System.SysUtils, System.Variants, System.Classes, System.JSON,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter,
  Vcl.Forms, ShellApi, IdHTTP, IdSSLOpenSSL, Math;

type

  TVchasnoKasaAPI = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    // Адреса компа с ПРРО
    FURL : String;
    // В каком режиме работать
    FResource : String;
    FBatchMode : Boolean;
    // Токены доступа
    FAccess_Token : String;
    //Версия схемы
    FVer : Integer;
    // Имя устройства
    FDevice_Name : String;

    // Печататная форма
    FPF_Text : String;
    // Текст ошибки
    FPF_Error : String;
    // код/идентификатор фискального документа
    FDocCode : String;
    // локальный номер фискального документа
    FDocNo : String;

    // **** Статус фискальника ****
    // Номер ПРРО
    FFisId : String;
    // Код для связи документов внутри одной смены.
    FShift_Link : Integer;
    // Статус смены
    FShift_Status : Integer;
    // Статус фискального принтера
    FisFis : Integer;
    // Статус связи
    FOnline_Status : Integer;
    // Статус ЭЦП
    FSign_Status : Integer;
    // Сумма остатка в сейфе (фискальной кассе)
    FSafe : Currency;

    // Название юрлица
    FName : String;
    // Название структурного подразделения (магазина)
    FShopName : String;
    // Адрес структурного подразделения (магазина)
    DShopAd : String;
    // Код плательщика НДС
    FVat_Code : String;
    // Код ЕДРПОУ
    FFis_Code : String;

    // Возврат последних успешных номеров чеков ...
    FLast_Receipt_No : Integer;
    FLast_Back_No : Integer;
    FLast_Z_No : Integer;
    FVacant_Off_Nums : Integer;

    // ************************
    // Данные по чеку
    // ************************

    // Чек открыт
    FOpen : Boolean;
    // Признак возвратного чека
    FReturn : Boolean;
    // Содержимое чека
    FRows: TCollection;
    // Массив оплат
    FSumPays: TCollection;
    // Сумма чека
    FSumma: Currency;
    // Сумма оплаты
    FSummaPay: Currency;
    // Сумма оплаты в.ч. нал
    FSummaPayNal: Currency;
    // Коммент внизу чека
    FComment_Fown : String;


    // Обороты продажа
    FSummaCash : Currency;
    // Обороты возвраты
    FSummaCard  : Currency;
    // Чеков продажа
    FReceiptsSales : Integer;
    // Чеков возвраты
    FReceiptsReturn : Integer;


  protected
    function PostData(var jsonFiscal : TJSONObject; AType : Integer = 1) : boolean;
    procedure SetPF_Error(Value : String);
  public
    constructor Create; virtual;
    destructor Destroy; override;

      // Инициализация настроек
    function Init(AVer : Integer; ABatchMode : boolean; AURL, ADevice_Name, AAccess_Token : String) : boolean;

      // 0 - открытие смены
    function OpenWorkShift : boolean;


      // открытие чека
    function OpenReceipt(const isReturn: boolean = False) : boolean;
      // закрытие чека
    function CloseReceip(var CheckId: String) : boolean;
      // анулирование чека
    function AlwaysSold : boolean;

      // Добавить строку
    function SoldFrom(const GoodsCode: integer; const GoodsName, ABarCode, AUKTZED, AComment: string; const Amount, Price, NDS: double) : boolean;
      // Добавить скидку в строку
    function DiscountGoods(ADisc : Currency) : boolean;
      // Добавить текст в фискальный чек
    function PrintFiscalText(AText : String) : boolean;
      // Добавить оплату
    function TotalSumm(ASumPays : Currency; APaidType : Integer) : boolean;

      // 3 - служебный внос денег
    function ServiceFee(ASUM : Currency) : boolean;
      // 4 - служебный вынос денег
    function ServiceTakeaway(ASUM : Currency) : boolean;

      // 10 - X-отчет
    function XReport : boolean;
      // 11 - Z-отчет
    function ZReport : boolean;
      // 12 - Сводный Z-отчет по интервалу номеров Z-отчетов
    function ZReportInterval(const AТ_From , AТ_Еo : Integer) : boolean;

      // 18 - Статус фискальника
    function GetStatus : boolean;
      // 20 - Возврат номера фискального аппарата
    function FiscalNumber : String;
      // 21 - Возврат последних успешных номеров продажного и возвратного чеков
    function LastNumbers : Boolean;
      // 22 - Повтор (распечатка) последнего успешного документа
    function RepeatReceipt : Boolean;

    // Возврат номер последнего фискального чека
    function GetLastNumbersReceipt : Integer;
    // Возврат номер текущего Z отчета
    function GetZReport : Integer;

    // Обороты продажа
    function GetSummaCash : Currency;
    // Обороты возвраты
    function GetSummaCard  : Currency;
    // Чеков продажа
    function GetReceiptsSales : Integer;
    // Чеков возвраты
    function GetReceiptsReturn : Integer;

    // Название юрлица
    function GetName : String;

    // Последний Z отчет
    function GetLastZReport : String;

    // Пакетный режим
    property BatchMode : boolean read FBatchMode;
    // Текст ошибки
    property PF_Error : String read FPF_Error;
    // Возврат текст для печати
    property PF_Text : String read FPF_Text;
    // Сумма чека
    property Summa: Currency read FSumma;
    // Сумма оплаты
    property SummaPay: Currency read FSummaPay;
  end;



implementation

uses RegularExpressions, System.Generics.Collections, System.NetEncoding,
     DBClient, LocalWorkUnit, CommonData, IdGlobal, IdCoderMIME;

type

  TRowsItem = class(TCollectionItem)
  private
    FCode : Integer;
    FCode1 : String;
    FCode2 : String;
    FName : String;
    FCnt : Currency;
    FPrice : Currency;
    FDisc : Currency;
    FCost : Currency;
    FTaxGrp : Integer;
    FComment : String;
  public
  published
  end;

  TSumPaysItem = class(TCollectionItem)
  private
    FType : Integer;
    FSum : Currency;
  public
  published
  end;

  { TVchasnoKasaAPI }
constructor TVchasnoKasaAPI.Create;
begin
  FRESTClient := TRESTClient.Create('');
  FRESTResponse := TRESTResponse.Create(Nil);
  FRESTRequest := TRESTRequest.Create(Nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRows := TCollection.Create(TRowsItem);
  FSumPays := TCollection.Create(TSumPaysItem);

  FVer := 6;
  FAccess_Token := '';
  FDevice_Name := '';
  FShift_Status := -1;
  FPF_Text := '';
  FPF_Error := '';
  FName := '';
  FShopName := '';
  DShopAd := '';
  FVat_Code := '';
  FFis_Code := '';

  FOpen := False;
  FReturn := False;
  FSumma := 0;
  FSummaPay := 0;
  FSummaPayNal := 0;
  FComment_Fown := '';
end;

destructor TVchasnoKasaAPI.Destroy;
begin
  FSumPays.Free;
  FRows.Free;
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

procedure TVchasnoKasaAPI.SetPF_Error(Value : String);
begin
  FPF_Error := Value;
  if FPF_Error <> '' then ShowMessage(FPF_Error);
end;

function TVchasnoKasaAPI.PostData(var jsonFiscal : TJSONObject; AType : Integer = 1) : boolean;
var
  jsonData : TJSONObject;
  jValue : TJSONValue;
  jInfo : TJSONValue;
  jPair : TJSONValue;
  jArray : TJSONArray;
  task, I : Integer;
  S : String;
  FS: TFileStream;
  nSum : Currency;
begin
  Result := False;
  FPF_Error := '';
  if not TryStrToInt(jsonFiscal.FindValue('task').ToString, task) then
  begin
    SetPF_Error('Не передан: "Тип фискального задания"');
    jsonFiscal.Destroy;
    Exit;
  end;

  FRESTClient.BaseURL := FURL;
  FRESTClient.ContentType := 'application/json';

  FRESTRequest.ClearBody;
  FRESTRequest.Params.Clear;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := FResource;

  jsonData := TJSONObject.Create;
  try
    jsonData := TJSONObject.Create;
    jsonData.AddPair('ver', TJSONNumber.Create(FVer));
    jsonData.AddPair('token', TJSONString.Create(FAccess_Token));
    jsonData.AddPair('source', TJSONString.Create('ERP1'));
    jsonData.AddPair('device', TJSONString.Create(FDevice_Name));
    jsonData.AddPair('tag', TJSONString.Create(''));
    jsonData.AddPair('dt', TJSONString.Create(FormatDateTime('YYYYMMDDHHNNSSZZZ', NOW)));
    jsonData.AddPair('type', TJSONNumber.Create(AType));
    jsonData.AddPair('need_pf_txt', TJSONNumber.Create(2));
//    jsonData.AddPair('need_pf_pdf', TJSONNumber.Create(2));
//    jsonData.AddPair('need_pf_img', TJSONNumber.Create(2));

    jsonData.AddPair('fiscal', jsonFiscal);

    FRESTRequest.Body.Add(jsonData.ToString, TRESTContentType.ctAPPLICATION_JSON);
  finally
    jsonData.Destroy;
  end;

  try
    FRESTRequest.Execute;
  except on E: Exception do
         Begin
           SetPF_Error('Ошибка обращения к серверу "Вчасно-касса":'#13#10 + E.Message);
           Exit;
         End;
  end;

  if FRESTResponse.StatusCode = 200 then
  begin
    jValue := FRESTResponse.JSONValue ;
    if (jValue.FindValue('errortxt') <> Nil) and (jValue.FindValue('errortxt').Value <> '') then
    begin
       SetPF_Error(jValue.FindValue('errortxt').Value);
       Exit;
    end;

    if (jValue.FindValue('info') <> Nil) then
    begin
      jInfo := jValue.FindValue('info');

      if (jInfo.FindValue('fisid') <> Nil) then FFisId := jInfo.FindValue('fisid').Value;
      if (jInfo.FindValue('shift_link') <> Nil) then
        if not TryStrToInt(jInfo.FindValue('shift_link').Value, FShift_Link) then FShift_Link := 0;
      if (jInfo.FindValue('doccode') <> Nil) then FDocCode := jInfo.FindValue('doccode').Value;
      if (jInfo.FindValue('docno') <> Nil) then FDocNo := jInfo.FindValue('docno').Value;
      if (jInfo.FindValue('shift_status') <> Nil) then
        if not TryStrToInt(jInfo.FindValue('shift_status').Value, FShift_Status) then FShift_Status := -1;

      if (jInfo.FindValue('isFis') <> Nil) then
        if not TryStrToInt(jInfo.FindValue('isFis').Value, FisFis) then FisFis := -1;
      if (jInfo.FindValue('online_status') <> Nil) then
        if not TryStrToInt(jInfo.FindValue('online_status').Value, FOnline_Status) then FOnline_Status := -1;
      if (jInfo.FindValue('sign_status') <> Nil) then
        if not TryStrToInt(jInfo.FindValue('sign_status').Value, FSign_Status) then FSign_Status := -1;
      if (jInfo.FindValue('safe') <> Nil) then
        if not TryStrToCurr(jInfo.FindValue('safe').Value, FSafe) then FSafe := -1;

      if (jInfo.FindValue('last_receipt_no') <> Nil) then
        if not TryStrToInt(jInfo.FindValue('last_receipt_no').Value, FLast_Receipt_No) then FLast_Receipt_No := 0;
      if (jInfo.FindValue('last_back_no') <> Nil) then
        if not TryStrToInt(jInfo.FindValue('last_back_no').Value, FLast_Back_No) then FLast_Back_No := 0;
      if (jInfo.FindValue('last_z_no') <> Nil) then
        if not TryStrToInt(jInfo.FindValue('last_z_no').Value, FLast_Z_No) then FLast_Z_No := 0;
      if (jInfo.FindValue('vacant_off_nums') <> Nil) then
        if not TryStrToInt(jInfo.FindValue('vacant_off_nums').Value, FVacant_Off_Nums) then FVacant_Off_Nums := 0;

      if (jInfo.FindValue('printheader') <> Nil) then
      begin
        jPair := jInfo.FindValue('printheader');

        if (jPair.FindValue('name') <> Nil) then
          FName := jPair.FindValue('name').Value;
        if (jPair.FindValue('shopname') <> Nil) then
          FShopName := jPair.FindValue('shopname').Value;
        if (jPair.FindValue('shopad') <> Nil) then
          DShopAd := jPair.FindValue('shopad').Value;
        if (jPair.FindValue('vat_code') <> Nil) then
          FVat_Code := jPair.FindValue('vat_code').Value;
        if (jPair.FindValue('fis_code') <> Nil) then
          FFis_Code := jPair.FindValue('fis_code').Value;
      end;

      if (jInfo.FindValue('receipt') <> Nil) then
      begin
        jPair := jInfo.FindValue('receipt');

        if (jPair.FindValue('count_p') <> Nil) then
          if not TryStrToInt(jPair.FindValue('count_p').Value, FReceiptsSales) then FReceiptsSales := 0;
        if (jPair.FindValue('count_m') <> Nil) then
          if not TryStrToInt(jPair.FindValue('count_m').Value, FReceiptsReturn) then FReceiptsReturn := 0;
      end;

      if (jInfo.FindValue('pays') <> Nil) then
      begin
        jArray := TJSONArray(jInfo.FindValue('pays'));
        FSummaCash := 0;
        FSummaCard := 0;

        for I := 0 to jArray.Count - 1 do
        begin
          jPair := jArray.Items[I];
          if (jPair.FindValue('type') <> Nil) then
          begin
            if jPair.FindValue('type').Value = '0' then
            begin
              if (jPair.FindValue('sum_p') <> Nil) then
                if not TryStrToCurr(jPair.FindValue('sum_p').Value, nSum) then nSum := 0;
              FSummaCash := FSummaCash + nSum;
              if (jPair.FindValue('sum_m') <> Nil) then
                if not TryStrToCurr(jPair.FindValue('sum_m').Value, nSum) then nSum := 0;
              FSummaCash := FSummaCash - nSum;
            end else if jPair.FindValue('type').Value = '2' then
            begin
              if (jPair.FindValue('sum_p') <> Nil) then
                if not TryStrToCurr(jPair.FindValue('sum_p').Value, nSum) then nSum := 0;
              FSummaCard := FSummaCard + nSum;
              if (jPair.FindValue('sum_m') <> Nil) then
                if not TryStrToCurr(jPair.FindValue('sum_m').Value, nSum) then nSum := 0;
              FSummaCard := FSummaCard - nSum;
            end;
          end;
        end;

      end;

    end;


    if (jValue.FindValue('pf_text') <> Nil) and (jValue.FindValue('pf_text').Value <> '') then
    begin
      try
        S := jValue.FindValue('pf_text').Value;
        S := COPY(S, POS('base64', S) + 7, Length(S));
        FPF_Text := TIdDecoderMIME.DecodeString(S, IndyTextEncoding('windows-1251'));
      except
      end;
    end;

    if (jValue.FindValue('pf_pdf') <> Nil) and (jValue.FindValue('pf_pdf').Value <> '') then
    begin
      try
        S := jValue.FindValue('pf_pdf').Value;
        S := COPY(S, POS('base64', S) + 7, Length(S));
        FS := TFileStream.Create('111.pdf', fmCreate);
        try
          TIdDecoderMIME.DecodeStream(S, FS);
        finally
          FS.Free;
        end;

      except
      end;
    end;

    if (jValue.FindValue('pf_image') <> Nil) and (jValue.FindValue('pf_image').Value <> '') then
    begin
      try
        S := jValue.FindValue('pf_image').Value;
        S := COPY(S, POS('base64', S) + 7, Length(S));
        FS := TFileStream.Create('111.png', fmCreate);
        try
          TIdDecoderMIME.DecodeStream(S, FS);
        finally
          FS.Free;
        end;

      except
      end;
    end;

    Result := True;
  end else
  begin
    if FRESTResponse.JSONValue <> Nil then
    begin
      jValue := FRESTResponse.JSONValue;
      if (jValue.FindValue('errortxt') <> Nil) and (jValue.FindValue('errortxt').Value <> '') then
         SetPF_Error(jValue.FindValue('errortxt').Value)
      else SetPF_Error(jValue.ToString);
    end else SetPF_Error(FRESTResponse.StatusText);
  end;
end;

  // Инициализация настроек
function TVchasnoKasaAPI.Init(AVer : Integer; ABatchMode : boolean; AURL, ADevice_Name, AAccess_Token : String) : boolean;
begin
  Result := True;

  FVer := AVer;
  FURL := AURL;
  FBatchMode := ABatchMode;
  if ABatchMode then FResource := 'execute-pkg'
  else FResource := 'execute';
  FDevice_Name := ADevice_Name;
  FAccess_Token := AAccess_Token;

  if FShift_Status <> 1 then GetStatus;
end;


  // 0 - открытие смены
function TVchasnoKasaAPI.OpenWorkShift : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('Открыт фискальный чек. Выполнение операции запрещено.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(0));

  Result := PostData(jsonFiscal);
  GetStatus;
end;

  // открытие чека
function TVchasnoKasaAPI.OpenReceipt(const isReturn: boolean = False) : boolean;
begin
  Result := False;

  if FShift_Status <> 1 then
  begin
    if not OpenWorkShift or (FShift_Status <> 1) then
    begin
      SetPF_Error('Ошибка открытия рабочей смены.');
      Exit;
    end;
  end;

  if FOpen then
  begin
    SetPF_Error('Фискальный чек уже открыт.');
    Exit;
  end;
  FOpen := True;
  FReturn := isReturn;
  FRows.Clear;
  FSumPays.Clear;
  FSumma := 0;
  FSummaPay := 0;
  FSummaPayNal := 0;
  FComment_Fown := '';

  Result := True;
end;

  // 1, 2 - закрытие чека
function TVchasnoKasaAPI.CloseReceip(var CheckId: String) : boolean;
var
  jsonFiscal: TJSONObject;
  jsonReceipt: TJSONObject;
  jsonRows: TJSONArray;
  jsonRowsItem: TJSONObject;
  jsonPays: TJSONArray;
  jsonPaysItem: TJSONObject;
  I : Integer; nSum, nPay, nPayNal, nChange : Currency;
begin
  Result := False; nSum := 0; nPay := 0; nPayNal := 0;
  nChange := FSummaPay - FSumma;

  if not FOpen then
  begin
    SetPF_Error('Фискальный чек не открыт.');
    Exit;
  end;

  if FSumma > FSummaPay then
  begin
    SetPF_Error('Сумма оплаты недостаточна для оптаты чека.');
    Exit;
  end;

  if FSumma < (FSummaPay - FSummaPayNal) then
  begin
    SetPF_Error('Сумма оплаты превисит сумму чека.');
    Exit;
  end;

  try

    jsonFiscal := TJSONObject.Create;
    jsonFiscal.AddPair('fisid', TJSONString.Create(''));
    if FReturn then
      jsonFiscal.AddPair('task', TJSONNumber.Create(2))
    else jsonFiscal.AddPair('task', TJSONNumber.Create(1));

    jsonReceipt := TJSONObject.Create;
    jsonReceipt.AddPair('sum', TJSONNumber.Create(FSumma));
    //jsonReceipt.AddPair('round', TJSONNumber.Create(0));
    //jsonReceipt.AddPair('comment_up', TJSONString.Create(''));
    if FComment_Fown <> '' then
      jsonReceipt.AddPair('comment_down', TJSONString.Create(FComment_Fown));

    jsonRows := TJSONArray.Create;
    for I := 0 to FRows.Count - 1 do
    begin
      jsonRowsItem := TJSONObject.Create;
      with TRowsItem(FRows.Items[I]) do
      begin
        jsonRowsItem.AddPair('code', TJSONNumber.Create(FCode));
        if FCode1 <> '' then
          jsonRowsItem.AddPair('code1', TJSONString.Create(FCode1));
        if FCode2 <> '' then
          jsonRowsItem.AddPair('code2', TJSONString.Create(FCode2));
        jsonRowsItem.AddPair('name', TJSONString.Create(FName));
        jsonRowsItem.AddPair('cnt', TJSONNumber.Create(FCnt));
        jsonRowsItem.AddPair('price', TJSONNumber.Create(FPrice));
        jsonRowsItem.AddPair('disc', TJSONNumber.Create(-FDisc));
        jsonRowsItem.AddPair('cost', TJSONNumber.Create(FCost));
        jsonRowsItem.AddPair('taxgrp', TJSONNumber.Create(FTaxGrp));
        if FComment <> '' then
          jsonRowsItem.AddPair('comment', TJSONString.Create(FComment));

        nSum := nSum + FCost + FDisc;
      end;
      jsonRows.Add(jsonRowsItem);
    end;
    jsonReceipt.AddPair('rows', jsonRows);

    jsonPays := TJSONArray.Create;
    for I := 0 to FSumPays.Count - 1 do
    begin
      jsonPaysItem := TJSONObject.Create;
      with TSumPaysItem(FSumPays.Items[I]) do
      begin
        jsonPaysItem.AddPair('type', TJSONNumber.Create(FType));
        jsonPaysItem.AddPair('sum', TJSONNumber.Create(FSum));
        if (FType = 0) and (nChange <> 0) then
        begin
          jsonPaysItem.AddPair('sum', TJSONNumber.Create(FSum - nChange));
          jsonPaysItem.AddPair('change', TJSONNumber.Create(nChange));
        end else jsonPaysItem.AddPair('sum', TJSONNumber.Create(FSum));

        nPay := nPay + FSum;
        if FType = 0 then nPayNal := nPayNal + FSum;
      end;
      jsonPays.Add(jsonPaysItem);
    end;
    jsonReceipt.AddPair('pays', jsonPays);

    jsonFiscal.AddPair('receipt', jsonReceipt);

    if (FSumma <> nSum) or (FSummaPay <> nPay) or (FSummaPayNal <> nPayNal) then
    begin
      SetPF_Error('Ошибка накопленных сумм.');
      jsonFiscal.Free;
      Exit;
    end;

    Result := PostData(jsonFiscal);
    CheckId := FDocNo;
    GetStatus;
  finally
    FOpen := False;
    FReturn := False;
    FRows.Clear;
    FSumPays.Clear;
    FSumma := 0;
    FSummaPay := 0;
    FSummaPayNal := 0;
    FComment_Fown := '';
  end;
end;

  // анулирование чека
function TVchasnoKasaAPI.AlwaysSold : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('Фискальный чек не открыт.');
    Exit;
  end;

  FOpen := False;
  FReturn := False;
  FRows.Clear;
  FSumPays.Clear;
  FSumma := 0;
  FSummaPay := 0;
  FSummaPayNal := 0;
  FComment_Fown := '';
  Result := True;
end;

  // Добавить строку
function TVchasnoKasaAPI.SoldFrom(const GoodsCode: integer; const GoodsName, ABarCode, AUKTZED, AComment : string; const Amount, Price, NDS: double) : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('Фискальный чек не открыт.');
    Exit;
  end;

  with TRowsItem(FRows.Add) do
  begin
    FCode    := GoodsCode;
    FCode1   := ABarCode;
    FCode2   := AUKTZED;
    FName    := GoodsName;
    FCnt     := RoundTo(Amount, - 3);
    FPrice   := RoundTo(Price, - 2);
    FDisc    := 0;
    FCost    := RoundTo(RoundTo(Amount, - 3) * RoundTo(Price, - 2), - 2);
    if NDS = 20 then FTaxGrp  := 1
    else if NDS = 7 then FTaxGrp  := 4
    else if NDS = 0 then FTaxGrp  := 5
    else
    begin
      SetPF_Error('Неизвестная ставка НДС.');
      Exit;
    end;
    FComment := AComment;

   FSumma :=FSumma + FCost;
  end;
  Result := True;
end;

  // Добавить скидку в строку
function TVchasnoKasaAPI.DiscountGoods(ADisc : Currency) : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('Фискальный чек не открыт.');
    Exit;
  end;

  if FRows.Count > 0 then
  begin
    with TRowsItem(FRows.Items[FRows.Count - 1]) do
    begin
      FSumma := FSumma - FDisc;
      FDisc    := RoundTo(ADisc, - 2);
      FSumma := FSumma + FDisc;
    end;

    Result := True;
  end else
  begin
    SetPF_Error('Нет товара на который применить скидку.');
    Exit;
  end;
end;

  // Добавить текст в фискальный чек
function TVchasnoKasaAPI.PrintFiscalText(AText : String) : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('Фискальный чек не открыт.');
    Exit;
  end;

  if Trim(AText) = '' then Exit;

  if FComment_Fown <> '' then  FComment_Fown := FComment_Fown + '\n';
  FComment_Fown := FComment_Fown + Trim(AText);
end;

  // Добавить оплату
function TVchasnoKasaAPI.TotalSumm(ASumPays : Currency; APaidType : Integer) : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('Фискальный чек не открыт.');
    Exit;
  end;

  ASumPays := RoundTo(ASumPays, - 2);

  with TSumPaysItem(FSumPays.Add) do
  begin
    FType := APaidType;
    FSum := ASumPays;
    FSummaPay := FSummaPay + FSum;
    if FType = 0 then FSummaPayNal := FSummaPayNal + FSum;
  end;
  Result := True;
end;

  // 3 - служебный внос денег
function TVchasnoKasaAPI.ServiceFee(ASUM : Currency) : boolean;
var
  jsonFiscal: TJSONObject;
  jsonCash: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('Открыт фискальный чек. Выполнение операции запрещено.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(3));

  jsonCash := TJSONObject.Create;
  jsonCash.AddPair('type', TJSONNumber.Create(0));
  jsonCash.AddPair('sum', TJSONNumber.Create(ASUM));

  jsonFiscal.AddPair('cash', jsonCash);

  Result := PostData(jsonFiscal);
  GetStatus;
end;

  // 4 - служебный вынос денег
function TVchasnoKasaAPI.ServiceTakeaway(ASUM : Currency) : boolean;
var
  jsonFiscal: TJSONObject;
  jsonCash: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('Открыт фискальный чек. Выполнение операции запрещено.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(4));

  jsonCash := TJSONObject.Create;
  jsonCash.AddPair('type', TJSONNumber.Create(0));
  jsonCash.AddPair('sum', TJSONNumber.Create(ASUM));

  jsonFiscal.AddPair('cash', jsonCash);

  Result := PostData(jsonFiscal);
  GetStatus;
end;

  // 10 - X-отчет
function TVchasnoKasaAPI.XReport : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('Открыт фискальный чек. Выполнение операции запрещено.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(10));

  Result := PostData(jsonFiscal);
  GetStatus;
end;

  // 11 - Z-отчет
function TVchasnoKasaAPI.ZReport : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('Открыт фискальный чек. Выполнение операции запрещено.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(11));

  Result := PostData(jsonFiscal);
  GetStatus;
end;

  // 12 - Сводный Z-отчет по интервалу номеров Z-отчетов
function TVchasnoKasaAPI.ZReportInterval(const AТ_From , AТ_Еo : Integer) : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('Открыт фискальный чек. Выполнение операции запрещено.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(12));
  jsonFiscal.AddPair('n_from', TJSONNumber.Create(AТ_From));
  jsonFiscal.AddPair('n_to', TJSONNumber.Create(AТ_Еo));

  Result := PostData(jsonFiscal);
end;


  // 18 - Статус фискальника
function TVchasnoKasaAPI.GetStatus : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(18));

  Result := PostData(jsonFiscal);
end;

  // 20 - Возврат номера фискального аппарата
function TVchasnoKasaAPI.FiscalNumber : String;
var
  jsonFiscal: TJSONObject;
begin
  Result := '';

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(20));

  if PostData(jsonFiscal) then Result := FFisId;
end;

  // 21 - Возврат последних успешных номеров продажного и возвратного чеков
function TVchasnoKasaAPI.LastNumbers : Boolean;
var
  jsonFiscal: TJSONObject;
begin
  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(21));

  Result := PostData(jsonFiscal);
end;

  // 22 - Повтор (распечатка) последнего успешного документа
function TVchasnoKasaAPI.RepeatReceipt : Boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(22));

  Result := PostData(jsonFiscal);
end;

  // Возврат номер последнего фискального чека
function TVchasnoKasaAPI.GetLastNumbersReceipt : Integer;
begin
  if LastNumbers and (FLast_Receipt_No > 0) then
    Result := FLast_Receipt_No
  else Result := -1;
end;

// Возврат номер текущего Z отчета
function TVchasnoKasaAPI.GetZReport : Integer;
begin
  if LastNumbers and (FLast_Z_No > 0) then
  begin
    if FShift_Status = 1 then Result := FLast_Z_No + 1
    else Result := FLast_Z_No;
  end else Result := -1;
end;


// Обороты продажа
function TVchasnoKasaAPI.GetSummaCash : Currency;
begin
  if XReport then Result := FSummaCash
  else Result := 0;
end;

// Обороты возвраты
function TVchasnoKasaAPI.GetSummaCard  : Currency;
begin
  if XReport then Result := FSummaCard
  else Result := 0;
end;


// Чеков продажа
function TVchasnoKasaAPI.GetReceiptsSales : Integer;
begin
  if XReport then Result := FReceiptsSales
  else Result := 0;
end;

// Чеков продажа
function TVchasnoKasaAPI.GetReceiptsReturn : Integer;
begin
  if XReport then Result := FReceiptsReturn
  else Result := 0;
end;

// Название юрлица
function TVchasnoKasaAPI.GetName : String;
begin
  if XReport then Result := FName
  else Result := '';
end;

// Последний Z отчет
function TVchasnoKasaAPI.GetLastZReport : String;
begin
  if FShift_Status = 1 then
  begin
    if XReport then Result := StringReplace(FPF_Text, 'X-ЗВІТ', 'Z-ЗВІТ', [rfIgnoreCase]);
  end else Result := FPF_Text;
end;

end.
