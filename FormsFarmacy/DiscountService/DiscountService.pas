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
    // ��� ����� ����� ������� "�������" ���������-Main
    gURL, gService, gPort, gUserName, gPassword, gCardNumber, gExternalUnit: string;
    gDiscountExternalId, gCode: Integer;
    // ��� ����� ����� ������� "�������" ���������-Item
    //gGoodsId : Integer;
    //gPriceSale, gPrice, gChangePercent, gSummChangePercent : Currency;
    //
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    // ������� "������" ���������-Item
    //procedure pSetParamItemNull;
    // ��������� �������� "������" ���������-Main
    procedure pGetDiscountExternal (lDiscountExternalId : Integer; lCardNumber : String);
    // �������� ����� + �������� "�������" ���������-Main
    function fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string; lDiscountExternalId : Integer) :Boolean;
    // �������� ������� + �������� "�������" ���������-Item
    //function fGetSale (var lMsg : string; var lPrice, lChangePercent, lSummChangePercent : Currency;
    //                                    lCardNumber : string; lDiscountExternalId, lGoodsId : Integer; lQuantity, lPriceSale : Currency;
    //                                    lGoodsCode : Integer; lGoodsName  : string) :Boolean;
    // Update ������� � CDS - �� ���� "�������" �������
    function fUpdateCDS_Discount (CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) :Boolean;
    // Commit ������� �� CDS - �� ����
    function fCommitCDS_Discount (fCheckNumber:String; CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) :Boolean;
    //
    // update DataSet - ��� ��� �� ���� "�������" �������
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
// ��� �����
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


// update DataSet - ��� ��� �� ���� "�������" �������
{function TDiscountServiceForm.fUpdateCDS_Item(CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) : Boolean;
var
  GoodsId: Integer;
begin
  Result :=true;
//  exit; //!!!��� �����

  //���� ����� - ������ �� ������
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;

  //��������� �������
  GoodsId := CheckCDS.FieldByName('GoodsId').asInteger;

  try
    CheckCDS.First;
    while not CheckCDS.Eof do
    begin
       if (CheckCDS.FieldByName('Amount').AsFloat > 0)and(lDiscountExternalId>0)
       then begin
               // �� ���� ������ �������
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
               then Result := false; // ���� ���� ���� ������� �� �������
       end
       else begin
               // �� ���� ������ �������
               if CheckCDS.FieldByName('PriceSale').asFloat > 0
               then gPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
               else gPriceSale:= CheckCDS.FieldByName('Price').asFloat;
               //������ �� �����
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

// �������� ����� + �������� "�������" ���������-Main
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
      Result:= LowerCase(lMsg) = LowerCase('������� ��������');
      //
      if not Result then ShowMessage ('������ <' + lService + '>.����� � <' + lCardNumber + '>.' + #10+ #13 + lMsg);

  except
        Self.Cursor := crDefault;
        lMsg:='Error';
        ShowMessage ('������ �� ������� <' + lURL + '>.' + #10+ #13
        + #10+ #13 + '��� ����� � <' + lCardNumber + '>.');
  end;
  //finally

     Self.Cursor := crDefault;

     // ��� ����� ������� "�������" ���������-Main
     if Result then
     begin
          // ���������
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
          // ���������
          gDiscountExternalId:= lDiscountExternalId;
          // ��������
          gURL        := '';
          gService    := '';
          gPort       := '';
          gUserName   := '';
          gPassword   := '';
          gCardNumber := '';
     end;
end;

// ��������� �������� "������" ���������-Main
procedure TDiscountServiceForm.pGetDiscountExternal (lDiscountExternalId : Integer; lCardNumber : String);
var lCode : Integer;
begin
  if lDiscountExternalId > 0
  then
      with spGet_DiscountExternal do begin
         ParamByName('inId').Value := lDiscountExternalId;
         ParamByName('Code').Value := 0;
         Execute;
         // �������� "������" ���������-Main
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
               // ��� ������� ��������
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
               ShowMessage ('������.��� ������ �� ��������� ������ � ��������� ���������� ����.')
         end;
      end
  else
     begin
          //������� ���������-Main
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

// Commit ������� �� CDS - �� ����
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
  //���� ����� - ������ �� ������
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;

  //��������� �������
  GoodsId := CheckCDS.FieldByName('GoodsId').asInteger;

  try
    if lDiscountExternalId > 0 then
      if gCode = 1 then
      begin
        aSaleRequest := CardSaleRequest.Create;
        //
        //�� �������� � ������� �������
        aSaleRequest.CheckId := '1';
        //����� ����
        aSaleRequest.CheckCode := fCheckNumber;
        //����/����� ���� (���� �������)
        aSaleRequest.CheckDate:= TXSDateTime.Create;
        aSaleRequest.CheckDate.AsDateTime:= now;
        //��� ��������
        aSaleRequest.MdmCode := lCardNumber;
        //��� ������� (0 ������������\1 ���������)
        aSaleRequest.SaleType := '1'; // Re: ������ ������ � 0 - ����� ������� ��� �����

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
            //����� �����-���
            with spGet_BarCode do begin
               ParamByName('inObjectId').Value := lDiscountExternalId;
               ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
               Execute;
               BarCode_find := trim (ParamByName('outBarCode').Value);
            end
          else
              BarCode_find := '';

          //���� �����-��� �������
          if BarCode_find <> '' then
          begin
              try
                Item         := CardSaleRequestItem.Create;
                //�� ������ � ������� �������
                Item.ItemId:= CheckCDS.FieldByName('List_UID').AsString;
                //��� ��������
                Item.MdmCode := lCardNumber;
                //����� ��� ������
                Item.ProductFormCode := BarCode_find;
                //��� ������� (0 ������������\1 ���������)
                Item.SaleType := '1'; // Re: ������ ������ � 0 - ����� ������� ��� �����

                //���� ��� ����� ������
                Item.PrimaryPrice := TXSDecimal.Create;
                Item.PrimaryPrice.XSToNative (myFloatToStr (CheckCDS.FieldByName('PriceSale').AsFloat));
                //����� ��� ����� ������
                Item.PrimaryAmount := TXSDecimal.Create;
                Item.PrimaryAmount.XSToNative (myFloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('PriceSale').AsFloat, False)));

                //���� ������ (� ������ ������)
                Item.RequestedPrice := TXSDecimal.Create;
                Item.RequestedPrice.XSToNative (myFloatToStr (CheckCDS.FieldByName('Price').AsFloat));
                //���-�� ������
                Item.RequestedQuantity := TXSDecimal.Create;
                Item.RequestedQuantity.XSToNative (myFloatToStr (CheckCDS.FieldByName('Amount').AsFloat));
                //����� �� ���-�� ������ (� ������ ������)
                Item.RequestedAmount := TXSDecimal.Create;
                Item.RequestedAmount.XSToNative(myFloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('Price').AsFloat, False)));

                // ����������� ������ ��� ��������
                SetLength(SendList, i);
                SendList[i-1] := Item;

                // ����� ���������
                i := i + 1;

              except
                    ShowMessage ('������ ��� ���������� ��������� SendList.' + #10+ #13
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
                    lMsg:='Error';
                    exit;
              end;

          end; // if BarCode_find <> ''
          //
          CheckCDS.Next;

        end; // while


        //������ ����

        // ���� ���� ���� ���� ������� �� �����-�����
        if i > 1 then
        try
              //ResList      := CardSaleResult.Create;
              //ResItem      := CardSaleResultItem.Create;

              //��� ���� � ����� ����������
              aSaleRequest.Items := SendList;

              //!!!��� �����!!!
              //***SaveToXMLFile_ItemCommit(aSaleRequest);
              //!!!��� �����!!!

              // ��������� ������
              ResList := (HTTPRIO as CardServiceSoap).commitCardSale(aSaleRequest, gUserName, gPassword);

              //!!!��� �����!!!
              //***SaveToXMLFile_ItemCommitRes(ResList);
              //!!!��� �����!!!


              // �������� ��������� - ���� ��������� � ���������� �� �����
              if (Length(ResList.Items)) = 0 then
              begin
                //���������� ���������
                llMsg:= ResList.ResultDescription;
                lMsg:= lMsg + llMsg;
                Result:= LowerCase(llMsg) = LowerCase('������� ��������');
                //
                if not Result
                then ShowMessage ('������ <' + gService + '>.����� � <' + lCardNumber + '>.' + #10+ #13 + llMsg);
              end;

              // ������ ������� ����� - �� ���������� ������� ��������
              for i := 0 to Length(ResList.Items) - 1 do
              begin

                // �������� ��������� - �� ��������
                ResItem := ResList.Items[i];

                //���������� ���������
                llMsg:= ResItem.ResultDescription;
                lMsg:= lMsg + llMsg;
                Result:= LowerCase(llMsg) = LowerCase('������� ������������');

                if not Result
                then ShowMessage ('������ <' + gService + '>.����� � <' + lCardNumber + '>.' + #10+ #13 + llMsg);

              end;

        except
            ShowMessage ('������ �� ������� <' + gURL + '>.' + #10+ #13
            + #10+ #13 + '��� ����� � <' + lCardNumber + '>.');
            //������
            lMsg:='Error';
        end; // if i > 1 // ���� ���� ���� ���� ������� �� �����-�����

        // ��������� - ��������
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
            //����� �����-���
            with spGet_BarCode do begin
               ParamByName('inObjectId').Value := lDiscountExternalId;
               ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
               Execute;
               BarCode_find := trim (ParamByName('outBarCode').Value);
            end
          else
              BarCode_find := '';

          //��������� ���� ��������������
          with spGet_Goods_CodeRazom do begin
             ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
             ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
             ParamByName('outCodeRazom').Value := 0;
             Execute;
             CodeRazom := Trunc(ParamByName('outCodeRazom').AsFloat);
          end;

          //���� �����-��� �������
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
                  ShowMessage('������ �������� ����� ������� : ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
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
                  if AnsiLowerCase(OperationResult) = 'pharm_not_active' then OperationResult := '������ (����� ������) �� �������.'
                  else if AnsiLowerCase(OperationResult) = 'no_pharm_card' then OperationResult := '��� ����� ����� ������.'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_card' then OperationResult := '��� ����� ����� ��������.'
                  else if AnsiLowerCase(OperationResult) = 'card_blocked' then OperationResult := '����� �������� �������������.'
                  else if AnsiLowerCase(OperationResult) = 'not_patient_card' then OperationResult := '��������� ����� �� �������� ������ ��������.'
                  else if AnsiLowerCase(OperationResult) = 'drug_limit' then OperationResult := '�������� ����� ������� �� �����.'
                  else if AnsiLowerCase(OperationResult) = 'no_today_price' then OperationResult := '�� ����������� ���� �� �������� � ������ �������� ������.'
                  else if AnsiLowerCase(OperationResult) = 'no_db_or_drug_link' then OperationResult := '������������ �� �������� ������, ���� �������� �� �������� �������������. ������� �� ��������..';
                  ShowMessage ('������ �������� ����� �������.' + #10+ #13
                    + #10+ #13 + '������ <' + OperationResult + '>.'
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
                  lMsg:='Error';
                  Exit;
                end else Result:= True //!!!��� �� � ��� ����� ���������!!!;
              end else
              begin
                ShowMessage ('������ �������� ����� �������.' + #10+ #13
                  + #10+ #13 + '������ <' + IntToStr(RESTResponse.StatusCode) + ' - ' + RESTResponse.StatusText + '>.'
                  + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                  + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              end;

            except
                  ShowMessage ('������ �������� ����� �������.' + #10+ #13
                  + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                  + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //������
                  lMsg:='Error';
                  exit;
            end;
            //finally

          end; // if BarCode_find <> ''
          //
          CheckCDS.Next;

        end; // while
      end else if gCode = 2 then

        Result:= True //!!!��� �� � ��� ����� ���������!!!

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
            //����� �����-���
            with spGet_BarCode do begin
               ParamByName('inObjectId').Value := lDiscountExternalId;
               ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
               Execute;
               BarCode_find := trim (ParamByName('outBarCode').Value);
            end
          else
              BarCode_find := '';

          //��������� ���� ��������������
          with spGet_Goods_CodeRazom do begin
             ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
             ParamByName('inAmount').Value  := CheckCDS.FieldByName('Amount').AsCurrency;
             ParamByName('outCodeRazom').Value := 0;
             Execute;
             CodeRazom := Trunc(ParamByName('outCodeRazom').AsFloat);
          end;

          //���� �����-��� �������
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
                  ShowMessage('������ �������� ����� ������� : ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
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
                  if AnsiLowerCase(OperationResult) = 'pharm_not_active' then OperationResult := '������ (����� ������) �� �������.'
                  else if AnsiLowerCase(OperationResult) = 'no_pharm_card' then OperationResult := '��� ����� ����� ������.'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_card' then OperationResult := '��� ����� ����� ��������.'
                  else if AnsiLowerCase(OperationResult) = 'card_blocked' then OperationResult := '����� �������� �������������.'
                  else if AnsiLowerCase(OperationResult) = 'not_patient_card' then OperationResult := '��������� ����� �� �������� ������ ��������.'
                  else if AnsiLowerCase(OperationResult) = 'drug_limit' then OperationResult := '�������� ����� ������� �� �����.'
                  else if AnsiLowerCase(OperationResult) = 'no_today_price' then OperationResult := '�� ����������� ���� �� �������� � ������ �������� ������.'
                  else if AnsiLowerCase(OperationResult) = 'no_db_or_drug_link' then OperationResult := '������������ �� �������� ������, ���� �������� �� �������� �������������. ������� �� ��������..';
                  ShowMessage ('������ �������� ����� �������.' + #10+ #13
                    + #10+ #13 + '������ <' + OperationResult + '>.'
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
                  lMsg:='Error';
                  Exit;
                end else Result:= True //!!!��� �� � ��� ����� ���������!!!;
              end else
              begin
                ShowMessage ('������ �������� ����� �������.' + #10+ #13
                  + #10+ #13 + '������ <' + IntToStr(RESTResponse.StatusCode) + ' - ' + RESTResponse.StatusText + '>.'
                  + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                  + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              end;

            except
                  ShowMessage ('������ �������� ����� �������.' + #10+ #13
                  + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                  + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //������
                  lMsg:='Error';
                  exit;
            end;
            //finally

          end; // if BarCode_find <> ''
          //
          CheckCDS.Next;

        end; // while
      end else if gCode = 4 then

        Result:= True //!!!��� �� � ��� ����� ���������!!!
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
//            //�������������� ���-�� ������
//            lQuantity := CheckCDS.FieldByName('Amount').asFloat;
//            // �� ���� ������ - � ��������
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
//                ParamByName('supplier').AsInteger := 0; // ����� ���� ����������� �� ���������� �� ����������� ��������
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
//                      ShowMessage ('������ <' + gService + '>.����� � <' + lCardNumber + '>.'
//                        + sLineBreak + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')'
//                        + CheckCDS.FieldByName('GoodsName').AsString
//                        + sLineBreak + Utf8ToAnsi(ParamByName('message').AsString));
//                  end;
//              except
//                ShowMessage ('������ �� ������� <' + gURL + '>.' + sLineBreak
//                  + sLineBreak + '��� ����� � <' + lCardNumber + '>.'
//                  + sLineBreak + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')'
//                  + CheckCDS.FieldByName('GoodsName').AsString);
//                //������
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
      //�������� ������
      with spGet_DiscountExternal do
      begin
           ParamByName('inId').Value := 2807930; // ����������� - ������ �����
           Execute;
           // �������� "������" ���������-Main
           gDiscountExternalId:= 2807930;
           gURL        := ParamByName('URL').Value;
           gService    := ParamByName('Service').Value;
           gPort       := ParamByName('Port').Value;
           gUserName   := ParamByName('UserName').Value;
           gPassword   := ParamByName('Password').Value;
      end;
    except
       Result:=false;
       lMsg:= '��� ������ ��������� <������ �����> �� ����������.';
       exit;
    end;
    //���������������� �������
    HTTPRIO.WSDLLocation := gURL;
    HTTPRIO.Service := gService;
    HTTPRIO.Port := gPort;
    //
    Application.ProcessMessages;
    Application.ProcessMessages;
    Application.ProcessMessages;
    //
    //������� ������ - ���������
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
         // ���� ������
         UnloadMovementCDS.Next;
    end;

    // ������� ���������
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

  //������� ������
  with spSelectUnloadItem do begin
     ParamByName('inMovementId').Value := lMovementId;
     Execute;
  end;

  //��� ��� ���������, ��� � �� ���������� ��������
  if (UnloadItemCDS.FieldByName('isRegistered').AsBoolean = TRUE) or (UnloadItemCDS.RecordCount = 0)
  then begin
    Result:= true;
    exit;
  end;


  //������ - ������������

  try
    aOrderRequest := OrderRequest.Create;
    //
    //�� ��������� � ������� �������
    aOrderRequest.OrderId := IntToStr(lMovementId);
    //����� ���������
    aOrderRequest.OrderCode := lInvNumber;
    //����/����� ���������
    aOrderRequest.OrderDate:= TXSDateTime.Create;
    aOrderRequest.OrderDate.AsDateTime:= lOperDate;
    //��� ���������(1-��������\2-������� �������������\3-������� ����������)
    aOrderRequest.OrderType := '1';
    //��� ���-��� �����������
    aOrderRequest.OrganizationFromCode := lFromOKPO;
    //�������� ���-��� �����������
    aOrderRequest.OrganizationFromName := lFromName;
    //��� ���-��� ����������
    aOrderRequest.OrganizationToCode := lToOKPO;
    //�������� ���-��� ����������
    aOrderRequest.OrganizationToName := lToName;

    i := 1;
    UnloadItemCDS.First;
    while not UnloadItemCDS.Eof do
    begin
          try
            Item         := OrderRequestItem.Create;
            //����� ��� ������
            Item.ProductFormCode:= UnloadItemCDS.FieldByName('BarCode').AsString;
            //��� �������� (0 ������������\1 ���������)
            Item.SaleType := '1';
            //���-��
            Item.Quantity := TXSDecimal.Create;
            Item.Quantity.XSToNative (myFloatToStr (UnloadItemCDS.FieldByName('Amount').AsFloat));

            // ����������� ������ ��� ��������
            SetLength(SendList, i);
            SendList[i-1] := Item;

            // ����� ���������
            i := i + 1;

          except
                //ShowMessage ('������ ��� ���������� ��������� SendList.' + #10+ #13
                //+ #10+ #13 + '����� (' + UnloadItemCDS.FieldByName('GoodsCode').AsString + ')' + UnloadItemCDS.FieldByName('GoodsName').AsString);
                //������
                lMsg:='Error';
                exit;
          end;

      // ���� ������
      UnloadItemCDS.Next;

    end; // while


    //������ - ��������
    try

          //��� ���� � ����� ����������
          aOrderRequest.Items := SendList;

          //!!!��� �����!!!
          //***SaveToXMLFile_ItemOrder(aOrderRequest);
          //!!!��� �����!!!

          // ��������� ������
          Res := (HTTPRIO as CardServiceSoap).commitOrder(aOrderRequest, gUserName, gPassword);

          //!!!��� �����!!!
          //***SaveToXMLFile_ItemCommitRes(ResList);
          //!!!��� �����!!!


          //���������� ���������
          lMsg:= Res.ResultDescription;
          Result:= LowerCase(lMsg) = LowerCase('OK');
          //
          if Result then
            //������� � ��������� - ��������� ��������� ��������� �� ������������� � ��������� Pfizer ���
               with spUpdateUnload do begin
                  ParamByName('inMovementId').Value := lMovementId;
                  Execute;
               end;

    except
        //ShowMessage ('������ �� ������� <' + gURL + '>.' + #10+ #13);
        //������
        lMsg:='Error';
    end; // if i > 1 // ���� ���� ���� ���� ������� �� �����-�����

  finally
    // ��������� - ��������
    aOrderRequest.Free;
    SendList:= nil;
    Item := nil;
  end;

end;


// Update ������� � CDS - �� ���� "�������" �������
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
  //���� ����� - ������ �� ������
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

  //��������� �������
  GoodsId := CheckCDS.FieldByName('GoodsId').asInteger;

  try
    i := 1;
    CheckCDS.First;
    //������ ����
    while not CheckCDS.Eof do
    begin
      // �� ���� ������ - � ��������
      if CheckCDS.FieldByName('PriceSale').asFloat > 0
      then lPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
      else lPriceSale:= CheckCDS.FieldByName('Price').asFloat;
      //
      if (lDiscountExternalId > 0) and ((gCode = 1) or (gCode = 2) and (gUserName <> '') or (gCode = 3) or (gCode = 4)) and
         (CheckCDS.FieldByName('Amount').AsFloat > 0)
      then
        //����� �����-���
        with spGet_BarCode do begin
           ParamByName('inObjectId').Value := lDiscountExternalId;
           ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
           Execute;
           BarCode_find := trim (ParamByName('outBarCode').Value);
        end
      else
          BarCode_find := '';

      //���� �����-��� ������� � ��������� ������ �����
      if (BarCode_find <> '') and (gCode = 1) then
      begin
          try
            Item := CardCheckItem.Create;
            //��� ��������
            Item.MdmCode := lCardNumber;
            //����� ��� ������
            Item.ProductFormCode := BarCode_find;
            //��� ������� (0 ������������\1 ���������)
            Item.SaleType := '1'; // Re: ������ ������ � 0 - ����� ������� ��� �����

            //�������������� ���� ������
            Item.RequestedPrice := TXSDecimal.Create;
            Item.RequestedPrice.XSToNative(myFloatToStr(lPriceSale));
            //�������������� ���-�� ������
            Item.RequestedQuantity := TXSDecimal.Create;
            Item.RequestedQuantity.XSToNative(myFloatToStr(CheckCDS.FieldByName('Amount').AsFloat));
            //�������������� ����� �� ���-�� ������
            Item.RequestedAmount := TXSDecimal.Create;
            Item.RequestedAmount.XSToNative(myFloatToStr( GetSumm(CheckCDS.FieldByName('Amount').AsFloat, lPriceSale, False)));


            // ����������� ������ ��� ��������
            SetLength(SendList, i);
            SendList[i-1] := Item;
            // ����� ���������
            i := i + 1;
            // �������� � ������
            List_GoodsId.Add(CheckCDS.FieldByName('GoodsId').AsString);
            List_BarCode.Add(BarCode_find);

          except
                ShowMessage ('������ ��� ���������� ��������� SendList.' + #10+ #13
                + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                //������
                lMsg:='Error';
                exit;
          end;
          //finally

      end // if BarCode_find <> ''

      //���� �����-��� ������� � ��������� Abbott card
      else if (BarCode_find <> '') and (gCode = 2) then
      begin

          //��������� ���� ��������������
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
                  ShowMessage('������ ��������� ���� ������: ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
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
                     //�������������� ���-�� ������
                     lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                     lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False);
                     //Update
                     CheckCDS.Edit;
                     CheckCDS.FieldByName('Price').asCurrency             :=lPrice;
                     CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
                     //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
                     CheckCDS.FieldByName('SummChangePercent').asCurrency :=lSummChangePercent;
                     CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
                     CheckCDS.Post;
                  end else
                  begin
                    ShowMessage ('������ ��������� ����.' + #10+ #13
                      + #10+ #13 + '���� <' + XML.DocumentElement.ChildNodes[0].ChildNodes[2].Text + '>.'
                      + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                      + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                      //������
                    lMsg:='Error';
                    exit;
                  end;
                end else
                begin
                  if AnsiLowerCase(OperationResult) = 'pharm_not_active' then OperationResult := '������ (����� ������) �� �������.'
                  else if AnsiLowerCase(OperationResult) = 'no_pharm_card' then OperationResult := '��� ����� ����� ������.'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_card' then OperationResult := '��� ����� ����� ��������.'
                  else if AnsiLowerCase(OperationResult) = 'card_blocked' then OperationResult := '����� �������� �������������.'
                  else if AnsiLowerCase(OperationResult) = 'not_patient_card' then OperationResult := '��������� ����� �� �������� ������ ��������.'
                  else if AnsiLowerCase(OperationResult) = 'drug_limit' then OperationResult := '�������� ����� ������� �� �����.'
                  else if AnsiLowerCase(OperationResult) = 'no_today_price' then OperationResult := '�� ����������� ���� �� �������� � ������ �������� ������.'
                  else if AnsiLowerCase(OperationResult) = 'no_db_or_drug_link' then OperationResult := '������������ �� �������� ������, ���� �������� �� �������� �������������. ������� �� ��������..';
                  ShowMessage ('������ �������� ����������� �������.' + #10+ #13
                    + #10+ #13 + '������ <' + OperationResult + '>.'
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
                  lMsg:='Error';
                  exit;
                end;
              end;

            except
                  ShowMessage ('������ �������� ����������� �������.' + #10+ #13
                  + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                  + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //������
                  lMsg:='Error';
                  exit;
            end;
            //finally
          end;

      end // if BarCode_find <> ''
      else   if (BarCode_find <> '') and (gCode = 3) then
      begin

          //��������� ���� ��������������
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
                  ShowMessage('������ ��������� ���� ������: ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
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
                     //�������������� ���-�� ������
                     lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                     lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False);
                     //Update
                     CheckCDS.Edit;
                     CheckCDS.FieldByName('Price').asCurrency             :=lPrice;
                     CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
                     //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
                     CheckCDS.FieldByName('SummChangePercent').asCurrency :=lSummChangePercent;
                     CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
                     CheckCDS.Post;
                  end else
                  begin
                    ShowMessage ('������ ��������� ����.' + #10+ #13
                      + #10+ #13 + '���� <' + XML.DocumentElement.ChildNodes[0].ChildNodes[2].Text + '>.'
                      + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                      + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                      //������
                    lMsg:='Error';
                    exit;
                  end;
                end else
                begin
                  if AnsiLowerCase(OperationResult) = 'pharm_not_active' then OperationResult := '������ (����� ������) �� �������.'
                  else if AnsiLowerCase(OperationResult) = 'no_pharm_card' then OperationResult := '��� ����� ����� ������.'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_card' then OperationResult := '��� ����� ����� ��������.'
                  else if AnsiLowerCase(OperationResult) = 'card_blocked' then OperationResult := '����� �������� �������������.'
                  else if AnsiLowerCase(OperationResult) = 'not_patient_card' then OperationResult := '��������� ����� �� �������� ������ ��������.'
                  else if AnsiLowerCase(OperationResult) = 'drug_limit' then OperationResult := '�������� ����� ������� �� �����.'
                  else if AnsiLowerCase(OperationResult) = 'no_today_price' then OperationResult := '�� ����������� ���� �� �������� � ������ �������� ������.'
                  else if AnsiLowerCase(OperationResult) = 'no_db_or_drug_link' then OperationResult := '������������ �� �������� ������, ���� �������� �� �������� �������������. ������� �� ��������..';
                  ShowMessage ('������ �������� ����������� �������.' + #10+ #13
                    + #10+ #13 + '������ <' + OperationResult + '>.'
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
                  lMsg:='Error';
                  exit;
                end;
              end;

            except
                  ShowMessage ('������ �������� ����������� �������.' + #10+ #13
                  + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                  + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //������
                  lMsg:='Error';
                  exit;
            end;
            //finally
          end;

      end else if (BarCode_find <> '') and (gCode = 4) then
      begin

      end else
        // ����� - �������� ������
      if (gCode <> 2) or (gUserName <> '') then
      begin
               // �� ���� ������ - � ��������
               if CheckCDS.FieldByName('PriceSale').asFloat > 0
               then lPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
               else lPriceSale:= CheckCDS.FieldByName('Price').asFloat;
               // Update
               CheckCDS.Edit;
               CheckCDS.FieldByName('Price').asCurrency             :=lPriceSale;
               CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
               //��������������� ������ � ���� % �� ����
               CheckCDS.FieldByName('ChangePercent').asCurrency     :=0;
               //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
               CheckCDS.FieldByName('SummChangePercent').asCurrency :=0;
               CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency, lPriceSale, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
               CheckCDS.Post;
           end;
      //
      CheckCDS.Next;

    end; // while not CheckCDS.Eof

    //�������������, �.�. ����� ������
    List_GoodsId.Sort;
    List_BarCode.Sort;


    //������ ����

    // ���� ���� ���� ���� ������� �� �����-�����
    if i > 1 then
    try
          //
          //ResItem := CardCheckResultItem.Create;

          //!!!��� �����!!!
          //***SaveToXMLFile_CheckItem(SendList);
          //!!!��� �����!!!

          // ��������� ������ �� ��� ��������
          ResList := (HTTPRIO as CardServiceSoap).checkCardSale(SendList, gUserName, gPassword);

          //!!!��� �����!!!
          //***SaveToXMLFile_CheckItemResult(ResList);
          //!!!��� �����!!!

          // ������ ������� ����� - �� ���������� ������� ��������
          for i := 0 to Length(ResList) - 1 do
          begin

          // �������� ��������� - �� ��������
          ResItem := ResList[i];

          //������� ����� ��� �� ��������, �� �������� �� ����
          if ResItem.ProductFormCode = ''
          then // ������ �� ������, ���� ���� ����� �������� ���� ��������� ������
          else
          //������������� checkCDS ��� Update
          if not List_BarCode.Find(ResItem.ProductFormCode,index)
          then begin ShowMessage('�� ������ BarCode � ������ - List_BarCode.Find(' + ResItem.ProductFormCode + ')');
                     lMsg:= 'Error';
                     exit;
               end
          else
          if not checkCDS.Locate('GoodsId',List_GoodsId[index],[])
          then begin ShowMessage('�� ������ GoodsId - checkCDS.Locate(List_GoodsId[index])');
                     lMsg:= 'Error';
                     exit;
               end;

          //�������������� ���-�� ������
          lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
          // �� ���� ������ - � ��������
          if CheckCDS.FieldByName('PriceSale').asFloat > 0
          then lPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
          else lPriceSale:= CheckCDS.FieldByName('Price').asFloat;

          //���������� ���������
          llMsg:= ResItem.ResultDescription;
          lMsg:= lMsg + llMsg;
          Result:= LowerCase(llMsg) = LowerCase('������� ��������');

          //�������� ��������� ��������
          if Result then
          begin
               //��������������� ������ � ���� % �� ����
               lChangePercent     := ResItem.ResultDiscountPercent;
               //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
               lSummChangePercent := ResItem.ResultDiscountAmount;

               //!!! ������ ���� - ��� �� ������� !!!
               if lSummChangePercent > 0
               then
                   // ���� ��� ��� ���-�� = 1, ����� ��� ��������� ��������?
                   lPrice:= GetSumm(1, (GetSumm(lQuantity, lPriceSale,False) - lSummChangePercent) / lQuantity, False)
               else begin
                   // ���� ���� ��� ��� ���-�� = 1, ����� ��� ��������� ��������?
                   lPrice:= GetSumm(1, lPriceSale * (1 - lChangePercent / 100), False);
                   // � ��� ��������� ����� ������
                   lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False)
               end;

               //��������
               if lSummChangePercent >= GetSumm(lQuantity, lPriceSale, False) then
               begin
                    ShowMessage ('������.����� ������  <' + myFloatToStr(lSummChangePercent) + '> �� ����� ���� ������ ��� <' + myFloatToStr(GetSumm(lQuantity, lPriceSale, False)) + '>.'
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
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
                    ShowMessage ('������ <' + gService + '>.����� � <' + gCardNumber + '>.' + #10+ #13 + llMsg);
               end;


           //Update
           CheckCDS.Edit;
           CheckCDS.FieldByName('Price').asCurrency             :=lPrice;
           CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
           //��������������� ������ � ���� % �� ����
           CheckCDS.FieldByName('ChangePercent').asCurrency     :=lChangePercent;
           //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
           CheckCDS.FieldByName('SummChangePercent').asCurrency :=lSummChangePercent;
           CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
           CheckCDS.Post;

          end; // for i := 0 to Length(ResList) - 1

    except
        ShowMessage ('������ �� ������� <' + gURL + '>.' + #10+ #13
        + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
        + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
        //������
        lMsg:='Error';
    end; // if i > 1 // ���� ���� ���� ���� ������� �� �����-�����

    // ��������� - ��������
    SendList:= nil;
    Item := nil;
    ResList := nil;
    ResItem := nil;

//    if (lDiscountExternalId > 0) and (gCode = 3) then
//    begin
//      // ������ ������ � ��������
//
//      CheckCDS.First;
//
//      while not CheckCDS.Eof do
//      begin
//        MorionCode := FindMorionCode(CheckCDS.FieldByName('GoodsId').AsInteger);
//
//        if (MorionCode <> -1) and (MorionCode <> 0) then
//        begin
//          //�������������� ���-�� ������
//          lQuantity := CheckCDS.FieldByName('Amount').asFloat;
//          // �� ���� ������ - � ��������
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
//            // ������ ��������� ��� ������� ������
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
//              // �������� ������
//              if Session.Post = 200 then
//                with Session.Response.Params do
//                begin
//                  if Pos('202', ParamByName('error').AsString) = 1 then
//                  begin
//                    //��������������� ������ � ���� % �� ����
//                    lChangePercent := ParamByName('discont').AsFloat;
//                    //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
//                    lSummChangePercent := ParamByName('discont_absolute').AsFloat;
//
//                    //!!! ������ ���� - ��� �� ������� !!!
//                    if lSummChangePercent > 0 then
//                      // ���� ��� ��� ���-�� = 1, ����� ��� ��������� ��������?
//                      lPrice := GetSumm(1, (GetSumm(lQuantity, lPriceSale, False) - lSummChangePercent) / lQuantity, False)
//                    else
//                    begin
//                      // ���� ���� ��� ��� ���-�� = 1, ����� ��� ��������� ��������?
//                      lPrice:= GetSumm(1, lPriceSale * (1 - lChangePercent / 100), False);
//                      // � ��� ��������� ����� ������
//                      lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False)
//                    end;
//
//                    //��������
//                    if lSummChangePercent >= GetSumm(lQuantity, lPriceSale, False) then
//                    begin
//                      ShowMessage ('������.����� ������  <' + myFloatToStr(lSummChangePercent)
//                        + '> �� ����� ���� ������ ��� <' + myFloatToStr(GetSumm(lQuantity, lPriceSale, False)) + '>.'
//                        + sLineBreak + '��� ����� � <' + lCardNumber + '>.'
//                        + sLineBreak + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')'
//                        + CheckCDS.FieldByName('GoodsName').AsString);
//                      //������
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
//                    ShowMessage ('������ <' + gService + '>.����� � <' + gCardNumber + '>.'
//                      + sLineBreak + Utf8ToAnsi(ParamByName('message').AsString));
//                  end;
//
//                  //Update
//                  CheckCDS.Edit;
//                  CheckCDS.FieldByName('Price').asCurrency             := lPrice;
//                  CheckCDS.FieldByName('PriceSale').asCurrency         := lPriceSale;
//                  //��������������� ������ � ���� % �� ����
//                  CheckCDS.FieldByName('ChangePercent').asCurrency     := lChangePercent;
//                  //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
//                  CheckCDS.FieldByName('SummChangePercent').asCurrency := lSummChangePercent;
//                  CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
//                  CheckCDS.Post;
//                end;
//            except
//              ShowMessage ('������ �� ������� <' + gURL + '>.' + sLineBreak
//                + sLineBreak + '��� ����� � <' + lCardNumber + '>.'
//                + sLineBreak + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')'
//                + CheckCDS.FieldByName('GoodsName').AsString);
//              //������
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

  // ������� ���� �� ������
  Result := lMsg = '';

end;


// �������� ������� + �������� "�������" ���������-Item
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
  //���� ����� exit, ������ ��� ������;
  lPrice := lPriceSale;
  //��������� ���������-Item
  gGoodsId           := lGoodsId;
  gPriceSale         := lPriceSale;
  gPrice             := lPriceSale;
  gChangePercent     := 0;
  gSummChangePercent := 0;
  //����� �����-���
  with spGet_BarCode do begin
     ParamByName('inObjectId').Value := lDiscountExternalId;
     ParamByName('inGoodsId').Value  := lGoodsId;
     Execute;
     BarCode_find := ParamByName('outBarCode').Value;
  end;
  //�������� ��� �����-��� �������
  if BarCode_find = '' then
  begin
        ShowMessage ('������.�� ������ �����-���.'
        + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
        + #10+ #13 + '����� (' + IntToStr(lGoodsCode) + ')' + lGoodsName);
        //��������� - �� ������ ������, ����� ���������� � CheckCDS
        lMsg:='';
        //�����
        exit;
  end;
  //
  //
  Item := CardCheckItem.Create;
  ResItem := CardCheckResultItem.Create;
  try
    //��� ��������
    Item.MdmCode := lCardNumber;
    //����� ��� ������
    Item.ProductFormCode := BarCode_find;
    //��� ������� (0 ������������\1 ���������)
    Item.SaleType := '1'; // Re: ������ ������ � 0 - ����� ������� ��� �����
    //�������������� ���� ������
    Item.RequestedPrice := TXSDecimal.Create;
    Item.RequestedPrice.XSToNative(FloatToStr(lPriceSale));
    //�������������� ���-�� ������
    Item.RequestedQuantity := TXSDecimal.Create;
    Item.RequestedQuantity.XSToNative(FloatToStr(lQuantity));
    //�������������� ����� �� ���-�� ������
    Item.RequestedAmount := TXSDecimal.Create;
    Item.RequestedAmount.XSToNative(FloatToStr( GetSumm(lQuantity, lPriceSale)));

    // ����������� ������ ��� ��������
    SetLength(SendList, 1);
    SendList[0] := Item;

    // ��������� ������
    ResList := (HTTPRIO as CardServiceSoap).checkCardSale(SendList, gUserName, gPassword);
    // �������� ���������
    ResItem := ResList[0];

    //���������� ���������
    lMsg:= ResItem.ResultDescription;
    Result:= LowerCase(lMsg) = LowerCase('������� ��������');

    //������� ��������� ��������
    if Result then
    begin
         //��������������� ������ � ���� % �� ����
         lChangePercent     := ResItem.ResultDiscountPercent;
         //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
         lSummChangePercent := ResItem.ResultDiscountAmount;
         //��������
         if lSummChangePercent >= GetSumm(lQuantity, lPriceSale) then
         begin
              ShowMessage ('������.����� ������  <' + FloatToStr(lSummChangePercent) + '> �� ����� ���� ������ ��� <' + FloatToStr(GetSumm(lQuantity, lPriceSale)) + '>.'
              + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
              + #10+ #13 + '����� (' + IntToStr(lGoodsCode) + ')' + lGoodsName);
              //������, �� ���������� � CheckCDS (���� �� ������)
              lMsg:='Error';
              Result := false;
              //
              lPrice             := lPriceSale;
              lChangePercent     := 0;
              lSummChangePercent := 0;
         end
         else
             //!!! ������ ���� - ��� �� ������� !!!
             if lSummChangePercent > 0
             then
                 // ���� ��� ��� ���-�� = 1, ����� ��� ��������� ��������?
                 lPrice:= GetSumm(1, (GetSumm(lQuantity, lPriceSale) - lSummChangePercent) / lQuantity)
             else begin
                 // ���� ���� ��� ��� ���-�� = 1, ����� ��� ��������� ��������?
                 lPrice:= GetSumm(1, lPriceSale * (1 - lChangePercent / 100));
                 // � ��� ��������� ����� ������
                 lSummChangePercent := GetSumm(lQuantity, lPriceSale) - GetSumm(lQuantity, lPrice)
             end;
         //��������� ���������-Item (������ �� ��� ����������)
         gPrice             := lPrice;
         gChangePercent     := lChangePercent;
         gSummChangePercent := lSummChangePercent;
    end
    else
        ShowMessage ('������ <' + gService + '>.����� � <' + gCardNumber + '>.' + #10+ #13 + lMsg);
  except
        ShowMessage ('������ �� ������� <' + gURL + '>.' + #10+ #13
        + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
        + #10+ #13 + '����� (' + IntToStr(lGoodsCode) + ')' + lGoodsName);
        //������, �� ���������� � CheckCDS (���� �� ������)
        lMsg:='Error';
        Result := false;
  end;
  //finally
    Item := nil;
    ResItem := nil;
end;}

// ������� "������" ���������-Item
{procedure TDiscountServiceForm.pSetParamItemNull;
begin
  //��������
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
