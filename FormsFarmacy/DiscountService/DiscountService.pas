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
    // ��� ����� ����� ������� "�������" ���������-Main
    gURL, gService, gPort, gUserName, gPassword, gCardNumber : String;
    gDiscountExternalId : Integer;
    // ��� ����� ����� ������� "�������" ���������-Item
    gGoodsId : Integer;
    gPriceSale, gPrice, gChangePercent, gSummChangePercent : Currency;
    //
    // ������� "������" ���������-Item
    procedure pSetParamItemNull;
    // ��������� �������� "������" ���������-Main
    procedure pGetDiscountExternal (lDiscountExternalId : Integer; lCardNumber : String);
    // �������� ����� + �������� "�������" ���������-Main
    function fCheckCard (var lMsg : string; lURL, lService, lPort, lUserName, lPassword, lCardNumber : string; lDiscountExternalId : Integer) :Boolean;
    // �������� ������� + �������� "�������" ���������-Item
    function fGetSale (var lMsg : string; var lPrice, lChangePercent, lSummChangePercent : Currency;
                                        lCardNumber : string; lDiscountExternalId, lGoodsId : Integer; lQuantity, lPriceSale : Currency;
                                        lGoodsCode : Integer; lGoodsName  : string) :Boolean;
    // Commit �������
    function fCommitSale (CheckCDS : TClientDataSet; var lMsg : string; lDiscountExternalId : Integer; lCardNumber : string) :Boolean;
    //
    // update DataSet - ��� ��� �� ���� "�������" �������
    function fUpdateCDS_Item(CheckCDS : TClientDataSet; var lMsg : string; lCardNumber : string; lDiscountExternalId : Integer) : Boolean;
  end;

var
  DiscountServiceForm: TDiscountServiceForm;

implementation
{$R *.dfm}
uses Soap.XSBuiltIns
   , MainCash;

// update DataSet - ��� ��� �� ���� "�������" �������
function TDiscountServiceForm.fUpdateCDS_Item(CheckCDS : TClientDataSet; var lMsg : string; lCardNumber : string; lDiscountExternalId : Integer) : Boolean;
var
  GoodsId: Integer;
begin
  Result :=true;

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

end;

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
      if not Result then ShowMessage ('������.����� � <' + lCardNumber + '>.' + #10+ #13 + lMsg);

  except
        Self.Cursor := crDefault;
        lMsg:='Error';
        ShowMessage ('������ �� �������.' + #10+ #13
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
begin
  if lDiscountExternalId > 0
  then
      with spGet_DiscountExternal do begin
         ParamByName('inId').Value := lDiscountExternalId;
         Execute;
         // �������� "������" ���������-Main
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
          //������� ���������-Main
          gDiscountExternalId:= 0;
          gURL        := '';
          gService    := '';
          gPort       := '';
          gUserName   := '';
          gPassword   := '';
          gCardNumber := '';
     end;
end;

// Commit �������
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
{   aSaleRequest := CardSaleRequest.Create;
    Item         := CardSaleRequestItem.Create;
    ResList      := CardSaleResult.Create;
    ResItem      := CardSaleResultItem.Create;
    //
    //�� �������� � ������� �������
    aSaleRequest.CheckId := '1';
    //����� ����
    aSaleRequest.CheckCode := '1';
    //����/����� ���� (���� �������)
    CheckDate:= TXSDateTime.Create;
    CheckDate.XSToNative (DateTimeToStr(now));
    aSaleRequest.CheckDate :=CheckDate;

            //��� ��������
            aSaleRequest.MdmCode := lCardNumber;
            //����� ��� ������
            //aSaleRequest.ProductFormCode := BarCode_find;
            //��� ������� (0 ������������\1 ���������)
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

          PriceSale := TXSDecimal.Create;
          AmountSale := TXSDecimal.Create;
          Price := TXSDecimal.Create;
          Quantity := TXSDecimal.Create;
          Amount := TXSDecimal.Create;
          try
            //����� ��� ������
            aSaleRequest.ProductFormCode := BarCode_find;

            //�� ������ � ������� �������
            Item.ItemId:='1';
            //��� ��������
            Item.MdmCode := lCardNumber;
            //����� ��� ������
            Item.ProductFormCode := BarCode_find;
            //��� ������� (0 ������������\1 ���������)
            Item.SaleType := '1'; // ???????

            //���� ��� ����� ������
            PriceSale.XSToNative (FloatToStr (CheckCDS.FieldByName('PriceSale').AsFloat));
            Item.PrimaryPrice := PriceSale;
            //����� ��� ����� ������
            AmountSale.XSToNative(FloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('Price').AsFloat)));
            Item.RequestedAmount := AmountSale;

            //���� ������ (� ������ ������)
            Price.XSToNative (FloatToStr (CheckCDS.FieldByName('Price').AsFloat));
            Item.RequestedPrice := Price;
            //���-�� ������
            Quantity.XSToNative (FloatToStr (CheckCDS.FieldByName('Amount').AsFloat));
            Item.RequestedQuantity := Quantity;
            //����� �� ���-�� ������ (� ������ ������)
            Amount.XSToNative(FloatToStr( GetSumm (CheckCDS.FieldByName('Amount').AsFloat, CheckCDS.FieldByName('Price').AsFloat)));
            Item.RequestedAmount := Amount;

            // ����������� ������ ��� ��������
            SetLength(SendList, i);
            SendList[i-1] := Item;


            i := i + 1;

          except
                ShowMessage ('������ �� �������.' + #10+ #13
                + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
                + #10+ #13 + '����� (' + CheckCDS.FieldByName('GoodsCode').AsString + ')' + CheckCDS.FieldByName('GoodsName').AsString);
                //������
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
            // ��������� ������
            ResList := (HTTPRIO as CardServiceSoap).commitCardSale(aSaleRequest, gUserName, gPassword);
            // �������� ���������
            ResItem := ResList.Items[0];

            //���������� ���������
            lMsg:= ResItem.ResultDescription;
            Result:= LowerCase(lMsg) = LowerCase('������� ��������');

            if not Result
            then ShowMessage ('������.����� � <' + lCardNumber + '>.' + #10+ #13 + lMsg);

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

// �������� ������� + �������� "�������" ���������-Item
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
  Price := TXSDecimal.Create;
  Quantity := TXSDecimal.Create;
  Amount := TXSDecimal.Create;
  try
    //��� ��������
    Item.MdmCode := lCardNumber;
    //����� ��� ������
    Item.ProductFormCode := BarCode_find;
    //��� ������� (0 ������������\1 ���������)
    Item.SaleType := '1'; // ???????
    //�������������� ���� ������
    Price.XSToNative(FloatToStr(lPriceSale));
    Item.RequestedPrice := Price;
    //�������������� ���-�� ������
    Quantity.XSToNative(FloatToStr(lQuantity));
    Item.RequestedQuantity := Quantity;
    //�������������� ����� �� ���-�� ������
    Amount.XSToNative(FloatToStr( GetSumm(lQuantity, lPriceSale)));
    Item.RequestedAmount := Amount;

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
        ShowMessage ('������.����� � <' + gCardNumber + '>.' + #10+ #13 + lMsg);
  except
        ShowMessage ('������ �� �������.' + #10+ #13
        + #10+ #13 + '��� ����� � <' + lCardNumber + '>.'
        + #10+ #13 + '����� (' + IntToStr(lGoodsCode) + ')' + lGoodsName);
        //������, �� ���������� � CheckCDS (���� �� ������)
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

// ������� "������" ���������-Item
procedure TDiscountServiceForm.pSetParamItemNull;
begin
  //��������
  gGoodsId           := 0;
  gPriceSale         := 0;
  gPrice             := 0;
  gChangePercent     := 0;
  gSummChangePercent := 0;
end;

end.
