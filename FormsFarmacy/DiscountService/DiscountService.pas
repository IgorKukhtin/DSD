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
    FDiscont�bsolute : Currency;
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
    // ��� ����� ����� ������� "�������" ���������-Main
    gURL, gService, gPort, gUserName, gPassword, gCardNumber, gExternalUnit: string;
    gDiscountExternalId, gCode: Integer;
    gisOneSupplier, gisTwoPackages : Boolean;
    // ������� "������" ���������-Item
    //procedure pSetParamItemNull;
    // ��������� �������� "������" ���������-Main
    procedure pGetDiscountExternal (lDiscountExternalId : Integer; lCardNumber : String);
    // �������� ����� + �������� "�������" ���������-Main
    function fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string;
                         lisOneSupplier, lisTwoPackages : Boolean;
                         lDiscountExternalId : Integer) :Boolean;
    // �������� ������� + �������� "�������" ���������-Item
    //function fGetSale (var lMsg : string; var lPrice, lChangePercent, lSummChangePercent : Currency;
    //                                    lCardNumber : string; lDiscountExternalId, lGoodsId : Integer; lQuantity, lPriceSale : Currency;
    //                                    lGoodsCode : Integer; lGoodsName  : string) :Boolean;
    // Update ������� � CDS - �� ���� "�������" �������
    function fUpdateCDS_Discount (CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string; bFixPrice : Boolean = False) :Boolean;
    // Commit ������� �� CDS - �� ����
    function fCommitCDS_Discount (fCheckNumber:String; CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer;
                                  lCardNumber : string; var AisDiscountCommit : Boolean; nHourOffset : Integer = 3; nDay : Integer = 0) :Boolean;
    //
    // update DataSet - ��� ��� �� ���� "�������" �������
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
//    property Discont�bsolute : Currency read FDiscont�bsolute;
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
// ��� �����
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
          // ���������
          gDiscountExternalId:= lDiscountExternalId;
          // ��������
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
               ShowMessage ('������.��� ������ �� ��������� ������ � ��������� ���������� ����.')
         end;
      end
  else
     begin
          //������� ���������-Main
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


// Commit ������� �� CDS - �� ����
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
      if gService = 'CardService' then
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
        aSaleRequest.CheckDate.HourOffset := nHourOffset;
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
              //��������� ������ � ���� �������
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
//                Item.PrimaryAmount := TXSDecimal.Create;
//                Item.PrimaryAmount.XSToNative (myFloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('PriceSale').AsFloat, False)));

                //���� ������ (� ������ ������)
                Item.RequestedPrice := TXSDecimal.Create;
                Item.RequestedPrice.XSToNative (myFloatToStr (CheckCDS.FieldByName('Price').AsFloat));
                //���-�� ������
                Item.RequestedQuantity := TXSDecimal.Create;
                Item.RequestedQuantity.XSToNative (myFloatToStr (CheckCDS.FieldByName('Amount').AsFloat));
                //����� �� ���-�� ������ (� ������ ������)
//                Item.RequestedAmount := TXSDecimal.Create;
//                Item.RequestedAmount.XSToNative(myFloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('Price').AsFloat, False)));

                 //����� �������
                 Item.OrderCode := FInvoiceNumber;
                 //���� �������
                 Item.OrderDate:= TXSDateTime.Create;
                 Item.OrderDate.AsDateTime:= IncDay(FInvoiceDate, nDay);
                 Item.OrderDate.HourOffset := nHourOffset;

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
              SaveToXMLFile_ItemCommit(aSaleRequest);
              //!!!��� �����!!!

              // ��������� ������
              ResList := (HTTPRIO as CardServiceSoap).commitCardSale(aSaleRequest, gUserName, gPassword);

              //ResList := CardSaleResult.Create;
              //!!!��� �����!!!
              //***SaveToXMLFile_ItemCommitRes(ResList);
              SaveToXMLFile_ItemCommit(ResList);
              //!!!��� �����!!!


              // �������� ��������� - ���� ��������� � ���������� �� �����
              if (Length(ResList.Items)) = 0 then
              begin
                //���������� ���������
                llMsg:= ResList.ResultDescription;
                lMsg:= lMsg + llMsg;
                Result:= LowerCase(llMsg) = LowerCase('������� ��������');
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
                  end else ShowMessage ('������ <' + gService + '>.����� � <' + lCardNumber + '>.' + #10+ #13 + llMsg);
                end;
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
                  end else ShowMessage ('������ <' + gService + '>.����� � <' + lCardNumber + '>.' + #10+ #13 + llMsg);
                end;

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
             ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
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
                end else Result:= True; //!!!��� �� � ��� ����� ���������!!!;
                AisDiscountCommit := Result;
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
      end else if gService = 'AbbottCard' then
      begin
        Result:= True //!!!��� �� � ��� ����� ���������!!!

      end
      else

      //���� ��������� Medicard
      if gService = 'Medicard' then
      begin

        if (FIdCasual = '') or (FSupplier = 0) or (FBarCode_find = '') then
        begin
          ShowMessage('� ������� ���� �� ��������� ����������� �������!');
          lMsg:='Error';
          exit;
        end;

        CheckCDS.First;
        while not CheckCDS.Eof do
        begin

          if (lDiscountExternalId > 0) and (CheckCDS.FieldByName('Amount').AsFloat > 0)
          then
            //����� �����-���
            with spGet_BarCode do begin
               ParamByName('inObjectId').Value := lDiscountExternalId;
               ParamByName('inGoodsId').Value  := CheckCDS.FieldByName('GoodsId').AsInteger;
               Execute;
               BarCode_find := trim (ParamByName('outBarCode').Value);
               if FBarCode_find <> BarCode_find then
               begin
                 ShowMessage('����������� ����� ����������� �� �������� � ����!');
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
                ShowMessage ('���������� ������ ���� �����.' + #10+ #13
                + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                 //������
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
                ShowMessage ('������ �� ����� � ����� ������ ���� �������� 2 �������� ������.' + #10+ #13
                  + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                  + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                //������
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
                  ShowMessage('������ ������������� �������: ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
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
//                    ShowMessage ('���������� ��� ������������� �������.' + #10+ #13
//                      + #10+ #13 + '���������� <' + XMLNode.Text + '>.'
//                      + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
//                      + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  end else
                  begin
                    ShowMessage ('������ ��� ������������� �������.' + #10+ #13
                      + #10+ #13 + '������ <' + XMLNode.Text + '>.'
                      + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                      + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                      //������
                    lMsg:='Error';
                    exit;
                  end;

                end else
                begin
                  ShowMessage ('������ ��������� ��������� ��� ������������� �������.' + #10+ #13
                    + #10+ #13 + '������ <' + XMLNode.Text + '>.'
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
          end;

          CheckCDS.Next;

        end; // while
      end

      //���� �����-��� ������� � ��������� �������� �� ����� card
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
             ParamByName('inDiscountExternal').Value  := lDiscountExternalId;
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
                                  'XML �������'#13#10 + RESTRequest.Params.ParameterByName('data').Value;
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

              cExchangeHistory := cExchangeHistory + #13#10 +
                                  '�����:'#13#10 + RESTResponse.Content;

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
                end else Result:= True; //!!!��� �� � ��� ����� ���������!!!;
                AisDiscountCommit := Result;
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
      end else if gCode in [16] then
      begin

        if FSupplier = 0 then
        begin
          ShowMessage('� ������� ���� �� ��������� ����������� �������!');
          lMsg:='Error';
          exit;
        end;

        Result:= True;

      end else if gService = 'ServiceXap' then

        Result:= True //!!!��� �� � ��� ����� ���������!!!
      ;
  finally
    CheckCDS.Filtered := True;
    if GoodsId <> 0 then
      CheckCDS.Locate('GoodsId',GoodsId,[]);
    CheckCDS.EnableControls;
//    if (lMsg <> '') and (cExchangeHistory <> '')  then
//       TMessagesForm.Create(nil).Execute('��������� ������ �������', cExchangeHistory, True);
  end;

end;

procedure TDiscountServiceForm.FormCreate(Sender: TObject);
begin
  FDiscont := 0;
  FDiscont�bsolute := 0;
  FIdCasual := '';
  FBarCode_find := '';
end;

// Send All Movement - Income
function TDiscountServiceForm.fPfizer_Send (const nDiscountExternal : Integer; var lMsg : string) :Boolean;
var llMsg : String;
begin
    try
      //�������� ������
      with spGet_DiscountExternal do
      begin
           ParamByName('URL').Value        := '';
           ParamByName('Service').Value    := '';
           ParamByName('Port').Value       := '';
           ParamByName('UserName').Value   := '';
           ParamByName('Password').Value   := '';
           ParamByName('inId').Value := nDiscountExternal; // ����������� - ������ �����
           Execute;
           // �������� "������" ���������-Main
           gDiscountExternalId:= nDiscountExternal;
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

    if (gURL = '') or (gService = '') or (gPort = '') then
    begin
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
       ParamByName('inDiscountExternalId').Value := nDiscountExternal; // ����������� - ������ �����
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
   // �������� "������" ���������-Main
   gURL        := lURL;
   gService    := lService;
   gPort       := lPort;
   gUserName   := lUserName;
   gPassword   := lPassword;

   //���������������� �������
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
    aOrderRequest.OrderDate.HourOffset := 3;
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
           SaveToXMLFile_ItemCommit(aOrderRequest);
          //***SaveToXMLFile_ItemOrder(aOrderRequest);
          //!!!��� �����!!!

          // ��������� ������
          Res := (HTTPRIO as CardServiceSoap).commitOrder(aOrderRequest, gUserName, gPassword);

          //!!!��� �����!!!
           SaveToXMLFile_ItemCommit(Res);
          //***SaveToXMLFile_ItemCommitRes(ResList);
          //!!!��� �����!!!


          //���������� ���������
          lMsg:= Res.ResultDescription;
          Result:= (LowerCase(lMsg) = LowerCase('OK')) or (Pos('��� ���������������', LowerCase(lMsg)) > 0);
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

      // �������� ���� ���������� ���� �����
      if (BarCode_find <> '') and (CheckCDS.FieldByName('Amount').AsInteger <> CheckCDS.FieldByName('Amount').AsCurrency) then
      begin
          ShowMessage ('���������� ������ ���� �����.' + #10+ #13
          + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
          + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
           //������
          lMsg:='Error';
          exit;
      end;


      //���� �����-��� ������� � ��������� ������ �����
      if (BarCode_find <> '') and (gService = 'CardService') then
      begin

          //��������� ������ � ���� �������
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
            //������ �� ����������
            Item.OrderCode := FInvoiceNumber;
            Item.OrderDate := TXSDateTime.Create;
            Item.OrderDate.AsDateTime := FInvoiceDate;
            Item.OrderDate.HourOffset := 3;

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
                     lChangePercent     := gfStrToFloat (ResItem.ResultDiscountPercent.DecimalString);
                     //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
                     lSummChangePercent := gfStrToFloat (ResItem.ResultDiscountAmount.DecimalString);

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


      end // if BarCode_find <> ''

      //���� �����-��� ������� � ��������� Abbott card
      else if (BarCode_find <> '') and (gService = 'AbbottCard') then
      begin

          //��������� ���� ��������������
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
                XMLNode := XML.DocumentElement.ChildNodes[0];


                OperationResult := XMLNode.ChildNodes.FindNode('OperationResult').Text;
                if (AnsiLowerCase(OperationResult) = 'ok') and Assigned (XMLNode.ChildNodes.FindNode('PatientPrice')) then
                begin
                  if TryStrToCurr(StringReplace(XMLNode.ChildNodes.FindNode('PatientPrice').Text, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]), lPrice) then
                  begin
                     // ��������� ���� �����
                     if bFixPrice then lPrice := CheckCDS.FieldByName('Price').asCurrency;

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
                      + #10+ #13 + '���� <' + XMLNode.ChildNodes.FindNode('PatientPrice').Text + '>.'
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
          end else
          begin
              ShowMessage ('������ �� ������ ������� �� ���������� ����� ������� ������� ����������.' + #10+ #13
              + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
              + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
               //������
              lMsg:='Error';
              exit;
          end;

      end // if BarCode_find <> ''

      //���� �����-��� ������� � ��������� Medicard card
      else  if (BarCode_find <> '') and (gService = 'Medicard') then
      begin

          if FIdCasual <> '' then
          begin
            ShowMessage('� ������� ���� ��������� ����������� �������. ����������� ������� ��� �������� ���!');
            exit;
          end;

          //��������� ���� ��������������
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
              ShowMessage ('����������. �� ����� ������ �������. ������ ����� ��� ������� ������ ��������.' + #10+ #13
                + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              FBarCode_find := BarCode_find;
              lMsg:='';
              Exit;
            end else if FAmountPackages > 1 then
            begin
              ShowMessage ('������ �� ����� ������� ��� ������������.' + #10+ #13
                + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              //������
              lMsg:='Error';
              exit;
            end;

            if (FAmountPackages = 1) and (CheckCDS.FieldByName('Amount').AsCurrency <> 1) then
            begin
              ShowMessage ('������ �� ����� ������� 1 �������� ��� ������������.' + #10+ #13
                + '����� ��������� ������ 1 ������ �������� �� �������.' + #10+ #13
                + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
              //������
              lMsg:='Error';
              exit;
            end;
          end;

          if CodeRazom <> 0 then
          begin
            try

              FDiscont := 0;
              FDiscont�bsolute := 0;
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
                  ShowMessage('������ ��������� ���� ������: ' + #13#10 + E.Message + #10+ #13
                    + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                    + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                    //������
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
                      FDiscont�bsolute := XMLNode.NodeValue;
                     if gisTwoPackages and (FAmountPackages = 1) then FDiscont�bsolute := FDiscont�bsolute * 2;
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
                       //��������������� ������ � ���� ������������� ����� �� ����� ���� �� ��� ���-�� ������ (����� ����� ������ �� ��� ���-�� ������)
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
                    ShowMessage ('���������� � �������.' + #10+ #13
                      + #10+ #13 + '���������� <' + XMLNode.Text + '>.'
                      + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                      + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  end else
                  begin
                    ShowMessage ('������ �������� ����������� �������.' + #10+ #13
                      + #10+ #13 + '������ <' + XMLNode.Text + '>.'
                      + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                      + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                      //������
                    lMsg:='Error';
                    exit;
                  end;

                end else FIdCasual := '';
              end else FIdCasual := '';

            except
                  ShowMessage ('������ �������� ����������� �������.' + #10+ #13
                  + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                  + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                  //������
                  lMsg:='Error';
                  FIdCasual := '';
                  exit;
            end;
            //finally
          end else
          begin
              ShowMessage ('������ �� ������ ������� �� ���������� ����� ������� ������� ����������.' + #10+ #13
              + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
              + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
               //������
              lMsg:='Error';
              exit;
          end;
      end

      //���� �����-��� ������� � ��������� �������� �� ����� card
      else if (BarCode_find <> '') and (gService = 'ServiceXap') and (gUserName <> '') then
      begin

          //��������� ���� ��������������
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
                                  'XML �������'#13#10 + RESTRequest.Params.ParameterByName('data').Value;

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

              cExchangeHistory := cExchangeHistory + #13#10 +
                                  '�����:'#13#10 + RESTResponse.Content;

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
                  else if AnsiLowerCase(OperationResult) = 'no_db_or_drug_link' then OperationResult := '������������ �� �������� ������, ���� �������� �� �������� �������������. ������� �� ��������..'
                  else if AnsiLowerCase(OperationResult) = 'patient_not_registered' then OperationResult := '������� ��� �� ��������������� � ���������..'
                  else if AnsiLowerCase(OperationResult) = 'high_price' then OperationResult := '�������� ����� �� ����..'
                  else if AnsiLowerCase(OperationResult) = 'low_price' then OperationResult := '�������� ����� �� ����..'
                  else if AnsiLowerCase(OperationResult) = 'no_patient_drug' then OperationResult := '������ �������� �� �������� ����� ��������..';
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

      end else if (BarCode_find <> '') and (gCode in [16]) then
      begin

          // �������� �����
          if Copy(lCardNumber, 1, 5) <> '21016' then
          begin
            ShowMessage ('������ �������� ����������� �������.' + #10+ #13
            + #10+ #13 + '����� � <' + lCardNumber + '> �� ����������� �������.');
            //������
            lMsg:='Error';
            Exit;
          end;

          //��������� ���� ��������������
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

               // �� ���� ������ - � ��������
               if CheckCDS.FieldByName('PriceSale').asFloat > 0
               then lPriceSale:= CheckCDS.FieldByName('PriceSale').asFloat
               else lPriceSale:= CheckCDS.FieldByName('Price').asFloat;
               if spGet_Goods_CodeRazom.ParamByName('outDiscountProcent').Value > 0 then
               begin
                 lChangePercent := 10;
                 //�������������� ���-�� ������
                 lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                 // ���� ���� ��� ��� ���-�� = 1, ����� ��� ��������� ��������?
                 lPrice:= GetSumm(1, lPriceSale * (1 - lChangePercent / 100), False);
                 // � ��� ��������� ����� ������
                 lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False);
               end else if spGet_Goods_CodeRazom.ParamByName('outDiscountSum').Value > 0 then
               begin
                 lChangePercent := 0;
                 //�������������� ���-�� ������
                 lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                 // ���� ���� ��� ��� ���-�� = 1, ����� ��� ��������� ��������?
                 lPrice:= GetSumm(1, lPriceSale - spGet_Goods_CodeRazom.ParamByName('outDiscountSum').Value, False);
                 // � ��� ��������� ����� ������
                 lSummChangePercent := GetSumm(lQuantity, lPriceSale, False) - GetSumm(lQuantity, lPrice, False);
               end else
               begin
                 lChangePercent := 0;
                 //�������������� ���-�� ������
                 lQuantity          := CheckCDS.FieldByName('Amount').asFloat;
                 // ���� ���� ��� ��� ���-�� = 1, ����� ��� ��������� ��������?
                 lPrice:= lPriceSale;
                 // � ��� ��������� ����� ������
                 lSummChangePercent := 0;
               end;
               //Update
               CheckCDS.Edit;
               CheckCDS.FieldByName('Price').asCurrency             :=lPrice;
               CheckCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
               //��������������� ������ � ���� % �� ����
               CheckCDS.FieldByName('ChangePercent').asCurrency     :=lChangePercent;
               //����� ����� ������ �� ��� ���-�� ������
               CheckCDS.FieldByName('SummChangePercent').asCurrency :=lSummChangePercent;
               CheckCDS.FieldByName('Summ').asCurrency := GetSumm(lQuantity, lPrice, MainCashForm.FormParams.ParamByName('RoundingDown').Value);
               CheckCDS.Post;

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

        // ����� - �������� ������
      else if (gService <> 'AbbottCard') or (gUserName <> '') then
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

    // ��������� - ��������
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

    // ������� ���� �� ������
    Result := lMsg = '';
//    if not Result and (cExchangeHistory <> '')  then
//       TMessagesForm.Create(nil).Execute('��������� ������ �������', cExchangeHistory, True);
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
  FDiscont�bsolute := 0;
  FIdCasual := '';
  FBarCode_find := '';
  FSupplier := 0;
end;

end.
