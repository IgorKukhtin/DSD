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

    // ������ ����� � ����
    FURL : String;
    // � ����� ������ ��������
    FResource : String;
    // ������ �������
    FAccess_Token : String;
    //������ �����
    FVer : Integer;
    // ��� ����������
    FDevice_Name : String;

    // ���������� �����
    FPF_Text : String;
    // ����� ������
    FPF_Error : String;
    // ���/������������� ����������� ���������
    FDocCode : String;
    // ��������� ����� ����������� ���������
    FDocNo : String;

    // **** ������ ����������� ****
    // ����� ����
    FFisId : String;
    // ��� ��� ����� ���������� ������ ����� �����.
    FShift_Link : Integer;
    // ������ �����
    FShift_Status : Integer;
    // ������ ����������� ��������
    FisFis : Integer;
    // ������ �����
    FOnline_Status : Integer;
    // ������ ���
    FSign_Status : Integer;
    // ����� ������� � ����� (���������� �����)
    FSafe : Currency;

    // ������� ��������� �������� ������� ����� ...
    FLast_Receipt_No : Integer;
    FLast_Back_No : Integer;
    FLast_Z_No : Integer;
    FVacant_Off_Nums : Integer;

    // ************************
    // ������ �� ����
    // ************************

    // ��� ������
    FOpen : Boolean;
    // ������� ����������� ����
    FReturn : Boolean;
    // ���������� ����
    FRows: TCollection;
    FSumPays: TCollection;
    // ����� ����
    FSumma: Currency;
    // ����� ������
    FSummaPay: Currency;
    // ����� ������ �.�. ���
    FSummaPayNal: Currency;

  protected
    function PostData(var jsonFiscal : TJSONObject; AType : Integer = 1) : boolean;
    procedure SetPF_Error(Value : String);
  public
    constructor Create; virtual;
    destructor Destroy; override;

      // ������������� ��������
    function Init(AVer : Integer; ABatchMode : boolean; AURL, ADevice_Name, AAccess_Token : String) : boolean;

      // 0 - �������� �����
    function OpenWorkShift : boolean;


      // �������� ����
    function OpenReceipt(const isReturn: boolean = False) : boolean;
      // �������� ����
    function CloseReceip(var CheckId: String) : boolean;
      // ������������ ����
    function AlwaysSold : boolean;

      // �������� ������
    function SoldFrom(const GoodsCode: integer; const GoodsName: string; const Amount, Price, NDS: double) : boolean;
      // �������� ������ � ������
    function DiscountGoods(ADisc : Currency) : boolean;
      // �������� ����� � ���������� ���
    function PrintFiscalText(AText : String) : boolean;
      // �������� ������
    function TotalSumm(ASumPays : Currency; APaidType : Integer) : boolean;

      // 3 - ��������� ���� �����
    function ServiceFee(ASUM : Currency) : boolean;
      // 4 - ��������� ����� �����
    function ServiceTakeaway(ASUM : Currency) : boolean;

      // 10 - X-�����
    function XReport : boolean;
      // 11 - Z-�����
    function ZReport : boolean;

      // 18 - ������ �����������
    function GetStatus : boolean;
      // 20 - ������� ������ ����������� ��������
    function FiscalNumber : String;
      // 21 - ������� ��������� �������� ������� ���������� � ����������� �����
    function LastNumbers : String;
      // 22 - ������ (����������) ���������� ��������� ���������
    function RepeatReceipt : Boolean;

    // ����� ������
    property PF_Error : String read FPF_Error;
    // ������� ����� ��� ������
    property PF_Text : String read FPF_Text;
  end;



implementation

uses RegularExpressions, System.Generics.Collections, System.NetEncoding,
     DBClient, LocalWorkUnit, CommonData, IdGlobal, IdCoderMIME;

type

  TRowsItem = class(TCollectionItem)
  private
    FCode : Integer;
    FCode1 : Integer;
    FCode2 : Integer;
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

function DelDoubleQuote(AStr : string) : string;
begin
  Result := StringReplace(AStr, '"', '', [rfReplaceAll]);
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
  FPF_Text := '';
  FPF_Error := '';
  FOpen := False;
  FReturn := False;
  FSumma := 0;
  FSummaPay := 0;
  FSummaPayNal := 0;
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
  task : Integer;
  S : String;
  FS: TFileStream;
begin
  Result := False;
  FPF_Text := '';
  FPF_Error := '';
  if not TryStrToInt(jsonFiscal.FindValue('task').ToString, task) then
  begin
    SetPF_Error('�� �������: "��� ����������� �������"');
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
           SetPF_Error('������ ��������� � ������� "������-�����":'#13#10 + E.Message);
           Exit;
         End;
  end;

  if FRESTResponse.StatusCode = 200 then
  begin
    jValue := FRESTResponse.JSONValue ;
    if (jValue.FindValue('errortxt') <> Nil) and (DelDoubleQuote(jValue.FindValue('errortxt').ToString) <> '') then
    begin
       SetPF_Error(DelDoubleQuote(jValue.FindValue('errortxt').ToString));
       Exit;
    end;

    if (jValue.FindValue('info') <> Nil) then
    begin
      jInfo := jValue.FindValue('info');

      if (jInfo.FindValue('fisid') <> Nil) then
        FFisId := DelDoubleQuote(jInfo.FindValue('fisid').ToString);
      if (jInfo.FindValue('shift_link') <> Nil) then
        if not TryStrToInt(DelDoubleQuote(jInfo.FindValue('shift_link').ToString), FShift_Link) then FShift_Link := 0;
      if (jInfo.FindValue('doccode') <> Nil) then
        FDocCode := DelDoubleQuote(jInfo.FindValue('doccode').ToString);
      if (jInfo.FindValue('docno') <> Nil) then
        FDocNo := DelDoubleQuote(jInfo.FindValue('docno').ToString);
      if (jInfo.FindValue('shift_status') <> Nil) then
        if not TryStrToInt(DelDoubleQuote(jInfo.FindValue('shift_status').ToString), FShift_Status) then FShift_Status := -1;

      if (jInfo.FindValue('isFis') <> Nil) then
        if not TryStrToInt(DelDoubleQuote(jInfo.FindValue('isFis').ToString), FisFis) then FisFis := -1;
      if (jInfo.FindValue('online_status') <> Nil) then
        if not TryStrToInt(DelDoubleQuote(jInfo.FindValue('online_status').ToString), FOnline_Status) then FOnline_Status := -1;
      if (jInfo.FindValue('sign_status') <> Nil) then
        if not TryStrToInt(DelDoubleQuote(jInfo.FindValue('sign_status').ToString), FSign_Status) then FSign_Status := -1;
      if (jInfo.FindValue('safe') <> Nil) then
        if not TryStrToCurr(DelDoubleQuote(jInfo.FindValue('safe').ToString), FSafe) then FSafe := -1;

      if (jInfo.FindValue('last_receipt_no') <> Nil) then
        if not TryStrToInt(DelDoubleQuote(jInfo.FindValue('last_receipt_no').ToString), FLast_Receipt_No) then FLast_Receipt_No := 0;
      if (jInfo.FindValue('last_back_no') <> Nil) then
        if not TryStrToInt(DelDoubleQuote(jInfo.FindValue('last_back_no').ToString), FLast_Back_No) then FLast_Back_No := 0;
      if (jInfo.FindValue('last_z_no') <> Nil) then
        if not TryStrToInt(DelDoubleQuote(jInfo.FindValue('last_z_no').ToString), FLast_Z_No) then FLast_Z_No := 0;
      if (jInfo.FindValue('vacant_off_nums') <> Nil) then
        if not TryStrToInt(DelDoubleQuote(jInfo.FindValue('vacant_off_nums').ToString), FVacant_Off_Nums) then FVacant_Off_Nums := 0;
    end;


    if (jValue.FindValue('pf_text') <> Nil) and (DelDoubleQuote(jValue.FindValue('pf_text').ToString) <> '') then
    begin
      try
        S := DelDoubleQuote(jValue.FindValue('pf_text').ToString);
        S := StringsReplace(COPY(S, POS('base64', S) + 7, Length(S)), ['\/'], ['/']);
        FPF_Text := TIdDecoderMIME.DecodeString(S, IndyTextEncoding('windows-1251'));
      except
      end;
    end;

    if (jValue.FindValue('pf_pdf') <> Nil) and (DelDoubleQuote(jValue.FindValue('pf_pdf').ToString) <> '') then
    begin
      try
        S := DelDoubleQuote(jValue.FindValue('pf_pdf').ToString);
        S := StringsReplace(COPY(S, POS('base64', S) + 7, Length(S)), ['\/'], ['/']);
        FS := TFileStream.Create('111.pdf', fmCreate);
        try
          TIdDecoderMIME.DecodeStream(S, FS);
        finally
          FS.Free;
        end;

      except
      end;
    end;

    if (jValue.FindValue('pf_image') <> Nil) and (DelDoubleQuote(jValue.FindValue('pf_image').ToString) <> '') then
    begin
      try
        S := DelDoubleQuote(jValue.FindValue('pf_image').ToString);
        S := StringsReplace(COPY(S, POS('base64', S) + 7, Length(S)), ['\/'], ['/']);
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
      if (jValue.FindValue('errortxt') <> Nil) and (DelDoubleQuote(jValue.FindValue('errortxt').ToString) <> '') then
         SetPF_Error(DelDoubleQuote(jValue.FindValue('errortxt').ToString))
      else SetPF_Error(DelDoubleQuote(jValue.ToString));
    end else SetPF_Error(FRESTResponse.StatusText);
  end;
end;

  // ������������� ��������
function TVchasnoKasaAPI.Init(AVer : Integer; ABatchMode : boolean; AURL, ADevice_Name, AAccess_Token : String) : boolean;
begin
  Result := True;

  FVer := AVer;
  FURL := AURL;
  if ABatchMode then FResource := 'execute-pkg'
  else FResource := 'execute';
  FDevice_Name := ADevice_Name;
  FAccess_Token := AAccess_Token;
end;


  // 0 - �������� �����
function TVchasnoKasaAPI.OpenWorkShift : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('������ ���������� ���. ���������� �������� ���������.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(0));

  Result := PostData(jsonFiscal);
end;

  // �������� ����
function TVchasnoKasaAPI.OpenReceipt(const isReturn: boolean = False) : boolean;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('���������� ��� ��� ������.');
    Exit;
  end;
  FOpen := True;
  FReturn := isReturn;
  FRows.Clear;
  FSumPays.Clear;
  FSumma := 0;
  FSummaPay := 0;
  FSummaPayNal := 0;

  Result := True;
end;

  // 1, 2 - �������� ����
function TVchasnoKasaAPI.CloseReceip(var CheckId: String) : boolean;
var
  jsonFiscal: TJSONObject;
  jsonReceipt: TJSONObject;
  jsonRows: TJSONArray;
  jsonRowsItem: TJSONObject;
  jsonPays: TJSONArray;
  jsonPaysItem: TJSONObject;
  I : Integer; nSum, nPay, nPayNal : Currency;
begin
  Result := False; nSum := 0; nPay := 0; nPayNal := 0;

  if not FOpen then
  begin
    SetPF_Error('���������� ��� �� ������.');
    Exit;
  end;

  if FSumma > FSummaPay then
  begin
    SetPF_Error('����� ������ ������������ ��� ������ ����.');
    Exit;
  end;

  if FSumma < (FSummaPay - FSummaPayNal) then
  begin
    SetPF_Error('����� ������ �������� ����� ����.');
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
    jsonReceipt.AddPair('round', TJSONNumber.Create(0));
    jsonReceipt.AddPair('comment_up', TJSONString.Create(''));
    jsonReceipt.AddPair('comment_down', TJSONString.Create(''));

    jsonRows := TJSONArray.Create;
    for I := 0 to FRows.Count - 1 do
    begin
      jsonRowsItem := TJSONObject.Create;
      with TRowsItem(FRows.Items[I]) do
      begin
        jsonRowsItem.AddPair('code', TJSONNumber.Create(FCode));
//        jsonRowsItem.AddPair('code1', TJSONNumber.Create(FCode1));
//        jsonRowsItem.AddPair('code2', TJSONNumber.Create(FCode2));
        jsonRowsItem.AddPair('name', TJSONString.Create(FName));
        jsonRowsItem.AddPair('cnt', TJSONNumber.Create(FCnt));
        jsonRowsItem.AddPair('price', TJSONNumber.Create(FPrice));
        jsonRowsItem.AddPair('disc', TJSONNumber.Create(FDisc));
        jsonRowsItem.AddPair('cost', TJSONNumber.Create(FCost));
        jsonRowsItem.AddPair('taxgrp', TJSONNumber.Create(FTaxGrp));
        jsonRowsItem.AddPair('comment', TJSONString.Create(FComment));

        nSum := nSum + FCost - FDisc;
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
        nPay := nPay + FSum;
        if FType = 0 then nPayNal := nPayNal + FSum;
      end;
      jsonPays.Add(jsonPaysItem);
    end;
    jsonReceipt.AddPair('pays', jsonPays);

    jsonFiscal.AddPair('receipt', jsonReceipt);

    if (FSumma <> nSum) or (FSummaPay <> nPay) or (FSummaPayNal <> nPayNal) then
    begin
      SetPF_Error('������ ����������� ����.');
      jsonFiscal.Free;
      Exit;
    end;

    Result := PostData(jsonFiscal);
    CheckId := FDocNo;
  finally
    FOpen := False;
    FReturn := False;
    FRows.Clear;
    FSumPays.Clear;
    FSumma := 0;
    FSummaPay := 0;
    FSummaPayNal := 0;
  end;
end;

  // ������������ ����
function TVchasnoKasaAPI.AlwaysSold : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('���������� ��� �� ������.');
    Exit;
  end;

  FOpen := False;
  FReturn := False;
  FRows.Clear;
  FSumPays.Clear;
  FSumma := 0;
  Result := True;
end;

  // �������� ������
function TVchasnoKasaAPI.SoldFrom(const GoodsCode: integer; const GoodsName: string; const Amount, Price, NDS: double) : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('���������� ��� �� ������.');
    Exit;
  end;

  with TRowsItem(FRows.Add) do
  begin
    FCode    := GoodsCode;
    FCode1   := 0;
    FCode2   := 0;
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
      SetPF_Error('����������� ������ ���.');
      Exit;
    end;
    FComment := '';

   FSumma :=FSumma + FCost;
  end;
  Result := True;
end;

  // �������� ������ � ������
function TVchasnoKasaAPI.DiscountGoods(ADisc : Currency) : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('���������� ��� �� ������.');
    Exit;
  end;

  if FRows.Count > 0 then
  begin
    with TRowsItem(FRows.Items[FRows.Count - 1]) do
    begin
      FSumma := FSumma + FDisc;
      FDisc    := RoundTo(ADisc, - 2);
      FSumma := FSumma - FDisc;
    end;

    Result := True;
  end else
  begin
    SetPF_Error('��� ������ �� ������� ��������� ������.');
    Exit;
  end;
end;

  // �������� ����� � ���������� ���
function TVchasnoKasaAPI.PrintFiscalText(AText : String) : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('���������� ��� �� ������.');
    Exit;
  end;

end;

  // �������� ������
function TVchasnoKasaAPI.TotalSumm(ASumPays : Currency; APaidType : Integer) : boolean;
begin
  Result := False;

  if not FOpen then
  begin
    SetPF_Error('���������� ��� �� ������.');
    Exit;
  end;

  if  RoundTo(ASumPays, - 2) <> ASumPays then
  begin
    SetPF_Error('����� ������ ������ ���� ������� �������.');
    Exit;
  end;

  with TSumPaysItem(FSumPays.Add) do
  begin
    FType := APaidType;
    FSum := RoundTo(ASumPays, - 2);
    FSummaPay := FSummaPay + FSum;
    if FType = 0 then FSummaPayNal := FSummaPayNal + FSum;
  end;
end;

  // 3 - ��������� ���� �����
function TVchasnoKasaAPI.ServiceFee(ASUM : Currency) : boolean;
var
  jsonFiscal: TJSONObject;
  jsonCash: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('������ ���������� ���. ���������� �������� ���������.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(3));

  jsonCash := TJSONObject.Create;
  jsonCash.AddPair('type', TJSONNumber.Create(0));
  jsonCash.AddPair('sum', TJSONNumber.Create(ASUM));

  jsonFiscal.AddPair('cash', jsonCash);

  Result := PostData(jsonFiscal);
end;

  // 4 - ��������� ����� �����
function TVchasnoKasaAPI.ServiceTakeaway(ASUM : Currency) : boolean;
var
  jsonFiscal: TJSONObject;
  jsonCash: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('������ ���������� ���. ���������� �������� ���������.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(4));

  jsonCash := TJSONObject.Create;
  jsonCash.AddPair('type', TJSONNumber.Create(0));
  jsonCash.AddPair('sum', TJSONNumber.Create(ASUM));

  jsonFiscal.AddPair('cash', jsonCash);

  Result := PostData(jsonFiscal);
end;

  // 10 - X-�����
function TVchasnoKasaAPI.XReport : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('������ ���������� ���. ���������� �������� ���������.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(10));

  Result := PostData(jsonFiscal);
end;

  // 11 - Z-�����
function TVchasnoKasaAPI.ZReport : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if FOpen then
  begin
    SetPF_Error('������ ���������� ���. ���������� �������� ���������.');
    Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(11));

  Result := PostData(jsonFiscal);
end;

  // 18 - ������ �����������
function TVchasnoKasaAPI.GetStatus : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(18));

  Result := PostData(jsonFiscal);
end;

  // 20 - ������� ������ ����������� ��������
function TVchasnoKasaAPI.FiscalNumber : String;
var
  jsonFiscal: TJSONObject;
begin
  Result := '';

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(20));

  if PostData(jsonFiscal) then Result := FFisId;
end;

  // 21 - ������� ��������� �������� ������� ���������� � ����������� �����
function TVchasnoKasaAPI.LastNumbers : String;
var
  jsonFiscal: TJSONObject;
begin
  Result := '';

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(21));

  if PostData(jsonFiscal) then Result := FDocNo;
end;

  // 22 - ������ (����������) ���������� ��������� ���������
function TVchasnoKasaAPI.RepeatReceipt : Boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(22));

  Result := PostData(jsonFiscal);
end;


end.
