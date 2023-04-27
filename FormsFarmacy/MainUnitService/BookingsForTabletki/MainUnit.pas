unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.ComObj, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, System.RegularExpressions,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxSpinEdit, Vcl.StdCtrls,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  cxImageComboBox, cxNavigator, UnitTabletki, System.JSON,
  cxDataControllerConditionalFormattingRulesManagerDialog, ZStoredProcedure,
  dxDateRanges;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    BookingsBodyDS: TDataSource;
    Panel2: TPanel;
    btnUpdateStaus: TButton;
    btnSaveBookings: TButton;
    btnAll: TButton;
    qryCheckHead: TZQuery;
    dsCheckHead: TDataSource;
    grBookingsBody: TcxGrid;
    grBookingsBodyDBTableView: TcxGridDBTableView;
    goodsCode: TcxGridDBColumn;
    qty: TcxGridDBColumn;
    price: TcxGridDBColumn;
    goodsName: TcxGridDBColumn;
    grBookingsBodyLevel: TcxGridLevel;
    btnLoadBookings: TButton;
    grCheckBody: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cbGoodsId: TcxGridDBColumn;
    cbGoodsName: TcxGridDBColumn;
    cbAmount: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    Panel1: TPanel;
    grBookingsHead: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    bookingId: TcxGridDBColumn;
    statusID: TcxGridDBColumn;
    customer: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    BookingsHeadDS: TDataSource;
    spInsertMovement: TZStoredProc;
    spInsertMovementItem: TZStoredProc;
    Panel3: TPanel;
    grCheckHead: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    chBookingId: TcxGridDBColumn;
    chInvNumber: TcxGridDBColumn;
    chBookingStatus: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    btnOpenBooking: TButton;
    chBookingStatusNew: TcxGridDBColumn;
    chOperDate: TcxGridDBColumn;
    cbPrice: TcxGridDBColumn;
    cbAmountOrder: TcxGridDBColumn;
    dsCheckBody: TDataSource;
    qryCheckBody: TZQuery;
    spUpdateMovementStatus: TZStoredProc;
    cxGrid1: TcxGrid;
    cxGridDBTableView4: TcxGridDBTableView;
    UnitId: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    UnitSerialNumber: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    dsUnit: TDataSource;
    qryUnit: TZQuery;
    code: TcxGridDBColumn;
    cbGoodsCode: TcxGridDBColumn;
    chCancelReason: TcxGridDBColumn;
    btnCancelledOrders: TButton;
    spSetErased: TZStoredProc;
    spSetErasetBooking: TZStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnSaveBookingsClick(Sender: TObject);
    procedure btnUpdateStausClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure btnLoadBookingsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOpenBookingClick(Sender: TObject);
    procedure btnCancelledOrdersClick(Sender: TObject);
    procedure SetData—ancelled;
  private
    { Private declarations }

    APIUser: String;
    APIPassword: String;
    TabletkiAPI : TTabletkiAPI;
    FData—ancelled : TDateTime;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
    procedure Add_LogSend(AMessage: String);

    procedure AllDriver;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Add_Log(AMessage: String);
var
  F: TextFile;

begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'.log')) then
      Rewrite(F)
    else
      Append(F);
  try
    Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

procedure TMainForm.Add_LogSend(AMessage: String);
var
  F: TextFile;

begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'_Send.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'_Send.log')) then
      Rewrite(F)
    else
      Append(F);
  try
    Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

procedure TMainForm.AllDriver;
begin
  try

    Add_Log('');
    Add_Log('-------------------');
    Add_Log('Õ‡˜‡ÎÓ Ó·‡·ÓÚÍË Á‡Í‡ÁÓ‚');

    btnSaveBookingsClick(Nil);
    btnUpdateStausClick(Nil);

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;


procedure TMainForm.btnAllClick(Sender: TObject);
begin
  Add_Log('—Ú‡Ú. ***************************');
  try
    if not qryUnit.Active then Exit;
    if qryUnit.IsEmpty then Exit;

    qryUnit.First;

    while not qryUnit.Eof do
    begin

      // œÓÎÛ˜‡ÂÏ Ë ÒÓı‡ÌˇÍÏ ÌÓ‚˚Â Á‡Í‡Á˚
      btnLoadBookingsClick(Nil);
      Application.ProcessMessages;
      btnSaveBookingsClick(Nil);
      Application.ProcessMessages;

      qryUnit.Next;
    end;

    // œÓÎÛ˜‡ÂÏ Á‡Í‡Á˚ ‰Îˇ ËÁÏÂÌÂÌËˇ ÒÚ‡ÚÛÒ‡
    btnOpenBookingClick(Nil);
    Application.ProcessMessages;

    // »ÁÏÂÌˇÂÏ ÒÚ‡ÚÛÒ˚
    btnUpdateStausClick(Nil);
    Application.ProcessMessages;

    if MinutesBetween(FData—ancelled, Now()) > 50 then
    begin

      qryUnit.First;
      while not qryUnit.Eof do
      begin

        // œÓÎÛ˜‡ÂÏ Ë ÒÓı‡ÌˇÍÏ ÌÓ‚˚Â Á‡Í‡Á˚
        btnCancelledOrdersClick(Nil);
        Application.ProcessMessages;

        qryUnit.Next;
      end;

      SetData—ancelled
    end;

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
  Add_Log('—ÚÓÔ. ***************************');
end;

procedure TMainForm.btnCancelledOrdersClick(Sender: TObject);
begin
  if not qryUnit.Active then Exit;
  if qryUnit.IsEmpty then Exit;
  Add_Log('¿ÔÚÂÍ‡: ' + qryUnit.FieldByName('Name').AsString);

  if not TabletkiAPI.Load—ancelledOrders(qryUnit.FieldByName('SerialNumber').AsInteger) then
  begin
     if TabletkiAPI.ErrorsText = '' then Add_Log('ÕÂÚ ÌÓ‚˚ı ÓÚÍ‡ÁÓ‚.')
     else Add_Log(TabletkiAPI.ErrorsText);
  end;

  if TabletkiAPI.BookingsHeadCDS.IsEmpty then Exit;
  Add_Log('¿ÔÚÂÍ‡: ' + qryUnit.FieldByName('Name').AsString);
  Add_Log('   ÓÚÍ‡ÁÓ‚: ' + IntToStr(TabletkiAPI.BookingsHeadCDS.RecordCount));

  try
    TabletkiAPI.BookingsHeadCDS.First;
    while not TabletkiAPI.BookingsHeadCDS.Eof  do
    begin
      spSetErasetBooking.Params.ParamByName('inBookingId').AsString := TabletkiAPI.BookingsHeadCDS.FieldByName('bookingId').AsString;
      spSetErasetBooking.Params.ParamByName('inComment').AsString := TabletkiAPI.BookingsHeadCDS.FieldByName('customerAdditionalInfo').AsString;
      spSetErasetBooking.Params.ParamByName('outisOk').AsBoolean := False;
      spSetErasetBooking.Params.ParamByName('inSession').AsString := '3';
      spSetErasetBooking.ExecProc;

      if spSetErasetBooking.Params.ParamByName('outisOk').AsBoolean then
        Add_Log('   ÓÚÍ‡Á: ' + TabletkiAPI.BookingsHeadCDS.FieldByName('bookingId').AsString);

      TabletkiAPI.BookingsHeadCDS.Next;
    end;

  except
    on E: Exception do Add_Log(E.Message);
  end;

end;

procedure TMainForm.btnLoadBookingsClick(Sender: TObject);
begin
  if not qryUnit.Active then Exit;
  if qryUnit.IsEmpty then Exit;

  if not TabletkiAPI.LoadBookings(qryUnit.FieldByName('SerialNumber').AsInteger) then
  begin
     if TabletkiAPI.ErrorsText = '' then Add_Log('ÕÂÚ ÌÓ‚˚ı Á‡Í‡ÁÓ‚.')
     else Add_Log(TabletkiAPI.ErrorsText);
  end;
end;

procedure TMainForm.btnOpenBookingClick(Sender: TObject);
begin
  try
    qryCheckHead.Close;
    qryCheckHead.ParamByName('UnitID').Value := 0;
    qryCheckHead.Open;

    qryCheckBody.Close;
    qryCheckBody.ParamByName('UnitID').Value := 0;
    qryCheckBody.Open;

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnSaveBookingsClick(Sender: TObject);
begin
  if not TabletkiAPI.BookingsHeadCDS.Active then Exit;
  if TabletkiAPI.BookingsHeadCDS.IsEmpty then Exit;
  Add_Log('¿ÔÚÂÍ‡: ' + qryUnit.FieldByName('Name').AsString);
  Add_Log('   Á‡Í‡ÁÓ‚: ' + IntToStr(TabletkiAPI.BookingsHeadCDS.RecordCount));

  try
    TabletkiAPI.BookingsHeadCDS.First;
    while not TabletkiAPI.BookingsHeadCDS.Eof  do
    begin
      Add_Log('   Á‡Í‡Á: ' + TabletkiAPI.BookingsHeadCDS.FieldByName('bookingId').AsString);

      spInsertMovement.Params.ParamByName('ioId').AsInteger := 0;
      spInsertMovement.Params.ParamByName('inUnitId').AsInteger := qryUnit.FieldByName('Id').AsInteger;
      spInsertMovement.Params.ParamByName('inDate').AsDateTime := TabletkiAPI.BookingsHeadCDS.FieldByName('dateTimeCreated').AsDateTime;
      spInsertMovement.Params.ParamByName('inBookingId').AsString := TabletkiAPI.BookingsHeadCDS.FieldByName('bookingId').AsString;
      spInsertMovement.Params.ParamByName('inBayer').AsString := TabletkiAPI.BookingsHeadCDS.FieldByName('customer').AsString;
      spInsertMovement.Params.ParamByName('inBayerPhone').AsString := TabletkiAPI.BookingsHeadCDS.FieldByName('customerPhone').AsString;
      spInsertMovement.Params.ParamByName('inCode').AsInteger := TabletkiAPI.BookingsHeadCDS.FieldByName('code').AsInteger;
      spInsertMovement.Params.ParamByName('inBookingStatus').AsString := TabletkiAPI.BookingsHeadCDS.FieldByName('statusID').AsString;
      spInsertMovement.Params.ParamByName('inSession').AsString := '3';
      spInsertMovement.ExecProc;

      TabletkiAPI.BookingsBodyCDS.First;
      while not TabletkiAPI.BookingsBodyCDS.Eof  do
      begin

        spInsertMovementItem.Params.ParamByName('ioId').AsInteger := 0;
        spInsertMovementItem.Params.ParamByName('inMovementId').AsInteger := spInsertMovement.Params.ParamByName('ioId').AsInteger;
        spInsertMovementItem.Params.ParamByName('inGoodsCode').AsInteger := TabletkiAPI.BookingsBodyCDS.FieldByName('goodsCode').AsInteger;
        spInsertMovementItem.Params.ParamByName('inAmount').AsCurrency := TabletkiAPI.BookingsBodyCDS.FieldByName('qty').AsCurrency;
        spInsertMovementItem.Params.ParamByName('inPrice').AsCurrency := TabletkiAPI.BookingsBodyCDS.FieldByName('price').AsCurrency;
        spInsertMovementItem.Params.ParamByName('inSession').AsString := '3';
        spInsertMovementItem.ExecProc;

        TabletkiAPI.BookingsBodyCDS.Next;
      end;

//      if Pos('000-0000', TabletkiAPI.BookingsHeadCDS.FieldByName('customerPhone').AsString) > 0 then
//      begin
//        Add_Log('   Û‰‡ÎÂÌËÂ ÚÂÒÚÓ‚Ó„Ó Á‡Í‡Á: ' + TabletkiAPI.BookingsHeadCDS.FieldByName('bookingId').AsString);
//        spSetErased.Params.ParamByName('inMovementId').AsInteger := spInsertMovement.Params.ParamByName('ioId').AsInteger;
//        spSetErased.ExecProc;
//      end;

      TabletkiAPI.BookingsHeadCDS.Next;
    end;


  except
    on E: Exception do Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnUpdateStausClick(Sender: TObject);
var
  Status : string;

  function GetJSONItems : TJSONArray;
    var  jsonItem: TJSONObject;
  begin
    Result := TJSONArray.Create;
    if (qryCheckHead.FieldByName('BookingStatusNew').AsString <> '4.0') and
       (qryCheckHead.FieldByName('BookingStatusNew').AsString <> '6.0') then Exit;

    qryCheckBody.First;
    while not qryCheckBody.Eof do
    begin
      jsonItem := TJSONObject.Create;
      jsonItem.AddPair('goodsCode', TJSONString.Create(qryCheckBody.FieldByName('GoodsCode').AsString));
      jsonItem.AddPair('goodsName', TJSONString.Create(qryCheckBody.FieldByName('GoodsName').AsString));
      jsonItem.AddPair('goodsProducer', TJSONString.Create(qryCheckBody.FieldByName('MakerName').AsString));
      jsonItem.AddPair('qty', TJSONNumber.Create(qryCheckBody.FieldByName('AmountOrder').AsCurrency));
      jsonItem.AddPair('price', TJSONNumber.Create(qryCheckBody.FieldByName('Price').AsCurrency));
      jsonItem.AddPair('qtyShip', TJSONNumber.Create(qryCheckBody.FieldByName('Amount').AsCurrency));
      jsonItem.AddPair('priceShip', TJSONNumber.Create(qryCheckBody.FieldByName('Price').AsCurrency));
      jsonItem.AddPair('needOrder', TJSONNumber.Create(0));
      Result.AddElement(jsonItem);
      qryCheckBody.Next;
    end;
  end;

  function GetJSONAItemsCancelReason : TJSONArray;
    var  jsonItem: TJSONObject;
  begin
    Result := TJSONArray.Create;

    qryCheckBody.First;
    while not qryCheckBody.Eof do
    begin
      if qryCheckBody.FieldByName('Amount').AsCurrency > 0 then
      begin
        jsonItem := TJSONObject.Create;
        jsonItem.AddPair('goodsCode', TJSONString.Create(qryCheckBody.FieldByName('GoodsCode').AsString));
        jsonItem.AddPair('qty', TJSONNumber.Create(qryCheckBody.FieldByName('Amount').AsCurrency));
        Result.AddElement(jsonItem);
      end;
      qryCheckBody.Next;
    end;
  end;

begin
  if not qryCheckHead.Active then Exit;
  if qryCheckHead.IsEmpty then Exit;

  Add_Log('Õ‡˜‡ÎÓ ËÁÏÂÌÂÌËˇ ÒÚ‡ÚÛÒÓ‚: ' + IntToStr(qryCheckHead.RecordCount));

  try
    qryCheckHead.First;
    while not qryCheckHead.Eof do
    begin

//      if qryCheckHead.FieldByName('CancelReasonID').AsInteger > 0 then
//      begin
//        if not TabletkiAPI.CancelReason(qryUnit.FieldByName('SerialNumber').AsInteger,
//                                        qryCheckHead.FieldByName('BookingId').AsString,
//                                        qryCheckHead.FieldByName('CancelReasonId').AsInteger,
//                                        GetJSONAItemsCancelReason) then
//        begin
//          Add_Log(TabletkiAPI.ErrorsText);
//        end else
//        begin
//          Add_LogSend(qryCheckHead.FieldByName('Id').AsString + ' cancelledOrders ' + qryCheckHead.FieldByName('CancelReasonId').AsString + ' ' + GetJSONAItemsCancelReason.ToString);
//        end;
//      end;

      if qryUnit.Locate('ID', qryCheckHead.FieldByName('UnitId').AsInteger, []) then
      begin

        Add_Log('   Á‡Í‡Á: ' + qryCheckHead.FieldByName('BookingId').AsString + ' ' +
                               qryCheckHead.FieldByName('BookingStatus').AsString + ' -> ' +
                               qryCheckHead.FieldByName('BookingStatusNew').AsString);

        Status := '';

        if Status = '7.0' then
        begin
          spUpdateMovementStatus.Params.ParamByName('inMovementId').AsInteger := qryCheckHead.FieldByName('Id').AsInteger;
          spUpdateMovementStatus.Params.ParamByName('inBookingStatus').AsString := Status;
          spUpdateMovementStatus.Params.ParamByName('inSession').AsString := '3';
          spUpdateMovementStatus.ExecProc;
        end else if Status <> qryCheckHead.FieldByName('BookingStatusNew').AsString then
        begin
          if TabletkiAPI.UpdateStaus(qryUnit.FieldByName('SerialNumber').AsInteger,
                                     qryCheckHead.FieldByName('BookingId').AsString,
                                     qryCheckHead.FieldByName('OrderId').AsString,
                                     qryCheckHead.FieldByName('BookingStatusNew').AsString,
                                     qryCheckHead.FieldByName('OrderId').AsString,
                                     qryCheckHead.FieldByName('Bayer').AsString,
                                     qryCheckHead.FieldByName('BayerPhone').AsString,
                                     qryCheckHead.FieldByName('CancelReason').AsString,
                                     qryCheckHead.FieldByName('OperDate').AsDateTime,
                                     GetJSONItems) then
          begin
            Add_LogSend(qryCheckHead.FieldByName('Id').AsString + ' ' + qryCheckHead.FieldByName('OrderId').AsString + ' UpdateStaus ' + qryCheckHead.FieldByName('BookingStatus').AsString +' Ì‡ ' + qryCheckHead.FieldByName('BookingStatusNew').AsString);
            spUpdateMovementStatus.Params.ParamByName('inMovementId').AsInteger := qryCheckHead.FieldByName('Id').AsInteger;
            spUpdateMovementStatus.Params.ParamByName('inBookingStatus').AsString := qryCheckHead.FieldByName('BookingStatusNew').AsString;
            spUpdateMovementStatus.Params.ParamByName('inSession').AsString := '3';
            spUpdateMovementStatus.ExecProc;
          end else
          begin
            Add_Log(TabletkiAPI.ErrorsText);
          end;
        end else if qryCheckHead.FieldByName('BookingStatus').AsString <> qryCheckHead.FieldByName('BookingStatusNew').AsString then
        begin
          spUpdateMovementStatus.Params.ParamByName('inMovementId').AsInteger := qryCheckHead.FieldByName('Id').AsInteger;
          spUpdateMovementStatus.Params.ParamByName('inBookingStatus').AsString := qryCheckHead.FieldByName('BookingStatusNew').AsString;
          spUpdateMovementStatus.Params.ParamByName('inSession').AsString := '3';
          spUpdateMovementStatus.ExecProc;
        end;
      end;

      qryCheckHead.Next;
    end;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;

end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BookingsForTabletki.ini');

  try

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '172.17.2.5');
    Ini.WriteString('Connect', 'HostName', ZConnection1.HostName);

    ZConnection1.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection1.User);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    APIUser := Ini.ReadString('API', 'APIUser', '');
    Ini.WriteString('API', 'APIUser', APIUser);

    APIPassword := Ini.ReadString('API', 'APIPassword', '');
    Ini.WriteString('API', 'APIPassword', APIPassword);

    FData—ancelled := Ini.ReadDateTime('Common', 'Data—ancelled', Date);
    Ini.WriteDateTime('Common', 'Data—ancelled', FData—ancelled);

  finally
    Ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
  except
    on E:Exception do
    begin
      Application.ShowMainForm := False;
      Add_Log(E.Message);
      Timer1.Enabled := true;
      Exit;
    end;
  end;

  TabletkiAPI := TTabletkiAPI.Create(APIUser, APIPassword);

  BookingsHeadDS.DataSet := TabletkiAPI.BookingsHeadCDS;
  BookingsBodyDS.DataSet := TabletkiAPI.BookingsBodyCDS;
  TabletkiAPI.BookingsBodyCDS.IndexFieldNames := 'bookingId';
  TabletkiAPI.BookingsBodyCDS.MasterFields := 'bookingId';
  TabletkiAPI.BookingsBodyCDS.MasterSource := BookingsHeadDS;

  if ZConnection1.Connected then
  begin
    qryUnit.Close;
    try
      qryUnit.Open;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        ZConnection1.Disconnect;
      end;
    end;
  end;

  if ZConnection1.Connected then
  begin

    if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
    begin
      Application.ShowMainForm := False;
      btnAll.Enabled := false;
      btnLoadBookings.Enabled := false;
      btnSaveBookings.Enabled := false;
      btnOpenBooking.Enabled := false;
      btnUpdateStaus.Enabled := false;
      Timer1.Enabled := true;
    end;
  end else
  begin
    Application.ShowMainForm := False;
    Timer1.Enabled := true;
    Exit;
  end;
end;

procedure TMainForm.SetData—ancelled;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BookingsForTabletki.ini');

  try

    Ini.WriteDateTime('Common', 'Data—ancelled', Now());

  finally
    Ini.free;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(TabletkiAPI) then TabletkiAPI.Free;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    if ZConnection1.Connected then btnAllClick(nil);
  finally
    Close;
  end;
end;

end.
