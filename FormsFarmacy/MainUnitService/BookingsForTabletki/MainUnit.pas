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
  cxDataControllerConditionalFormattingRulesManagerDialog, ZStoredProcedure;

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
    productId: TcxGridDBColumn;
    quantity: TcxGridDBColumn;
    price: TcxGridDBColumn;
    itemId: TcxGridDBColumn;
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
    status: TcxGridDBColumn;
    pharmacyId: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    BookingsHeadDS: TDataSource;
    btnAddTest: TButton;
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
    cbItemId: TcxGridDBColumn;
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
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnSaveBookingsClick(Sender: TObject);
    procedure btnUpdateStausClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadBookingsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddTestClick(Sender: TObject);
    procedure btnOpenBookingClick(Sender: TObject);
  private
    { Private declarations }

    APIUser: String;
    APIPassword: String;
    TabletkiAPI : TTabletkiAPI;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);

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

procedure TMainForm.AllDriver;
begin
  try

    Add_Log('');
    Add_Log('-------------------');
    Add_Log('Начало обработки заказов');

    btnSaveBookingsClick(Nil);
    btnUpdateStausClick(Nil);

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;


procedure TMainForm.btnAddTestClick(Sender: TObject);
  var GUID, GUIDI: TGUID;
begin

  if not TabletkiAPI.BookingsHeadCDS.Active then Exit;

  TabletkiAPI.BookingsHeadCDS.Last;
  TabletkiAPI.BookingsHeadCDS.Append;
  TabletkiAPI.BookingsHeadCDS.FieldByName('bookingId').AsString := 'ea611433-bfc6-435b-80cf-16b457607dc3';
  TabletkiAPI.BookingsHeadCDS.FieldByName('status').AsString := 'Processing';
  TabletkiAPI.BookingsHeadCDS.FieldByName('type').AsString := 'SelfService';
  TabletkiAPI.BookingsHeadCDS.FieldByName('pharmacyId').AsInteger := 6128298;
  TabletkiAPI.BookingsHeadCDS.FieldByName('orderId').AsString := 'bfb4b3dd-affe-11ea-a9f3-00163e3c1eb4';
  TabletkiAPI.BookingsHeadCDS.FieldByName('orderNumber').AsInteger := 328202;
  TabletkiAPI.BookingsHeadCDS.Post;

  TabletkiAPI.BookingsBodyCDS.Last;
  TabletkiAPI.BookingsBodyCDS.Append;
  TabletkiAPI.BookingsBodyCDS.FieldByName('bookingId').AsString := 'ea611433-bfc6-435b-80cf-16b457607dc3';
  TabletkiAPI.BookingsBodyCDS.FieldByName('itemId').AsString := '69c6e5e1-0981-4945-48d0-08d811ef7799';
  TabletkiAPI.BookingsBodyCDS.FieldByName('productId').AsInteger := 36085;
  TabletkiAPI.BookingsBodyCDS.FieldByName('quantity').AsCurrency := 1;
  TabletkiAPI.BookingsBodyCDS.FieldByName('price').AsCurrency := 36.30;
  TabletkiAPI.BookingsBodyCDS.Post;

//  CreateGUID(GUID);
//  TabletkiAPI.BookingsHeadCDS.Last;
//  TabletkiAPI.BookingsHeadCDS.Append;
//  TabletkiAPI.BookingsHeadCDS.FieldByName('bookingId').AsString := GUID.ToString;
//  TabletkiAPI.BookingsHeadCDS.FieldByName('status').AsString := 'Processing';
//  TabletkiAPI.BookingsHeadCDS.FieldByName('type').AsString := 'SelfService';
//  TabletkiAPI.BookingsHeadCDS.FieldByName('pharmacyId').AsInteger := 6128298;
//  TabletkiAPI.BookingsHeadCDS.FieldByName('orderId').AsString := 'bfb4b3dd-affe-11ea-a9f3-00163e3c1eb4';
//  TabletkiAPI.BookingsHeadCDS.FieldByName('orderNumber').AsInteger := 328202;
//  TabletkiAPI.BookingsHeadCDS.Post;
//
//  CreateGUID(GUIDI);
//  TabletkiAPI.BookingsBodyCDS.Last;
//  TabletkiAPI.BookingsBodyCDS.Append;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('bookingId').AsString := GUID.ToString;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('itemId').AsString := GUIDI.ToString;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('productId').AsInteger := 27292;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('quantity').AsCurrency := 1;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('price').AsCurrency := 13.4;
//  TabletkiAPI.BookingsBodyCDS.Post;
//
//  CreateGUID(GUIDI);
//  TabletkiAPI.BookingsBodyCDS.Last;
//  TabletkiAPI.BookingsBodyCDS.Append;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('bookingId').AsString := GUID.ToString;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('itemId').AsString := GUIDI.ToString;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('productId').AsInteger := 6317159;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('quantity').AsCurrency := 2;
//  TabletkiAPI.BookingsBodyCDS.FieldByName('price').AsCurrency := 1.6;
//  TabletkiAPI.BookingsBodyCDS.Post;

end;

procedure TMainForm.btnAllClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  try
    // Получаем и сохранякм новые заказы
    btnLoadBookingsClick(Nil);
    Application.ProcessMessages;
    btnSaveBookingsClick(Nil);
    Application.ProcessMessages;

    // Получаем заказы для изменения статуса
    btnOpenBookingClick(Nil);
    Application.ProcessMessages;
    if not qryCheckHead.Active then Exit;
    if qryCheckHead.IsEmpty then Exit;

    // Изменяем статусы
    btnUpdateStausClick(Nil);
    Application.ProcessMessages;

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnLoadBookingsClick(Sender: TObject);
begin
  if not TabletkiAPI.LoadBookings(0) then
  begin
     if TabletkiAPI.ErrorsText = '' then Add_Log('Нет новых заказов.')
     else Add_Log(TabletkiAPI.ErrorsText);
  end;
end;

procedure TMainForm.btnOpenBookingClick(Sender: TObject);
begin
  try
    qryCheckHead.Close;
    qryCheckHead.Open;

    qryCheckBody.Close;
    qryCheckBody.Open;

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnSaveBookingsClick(Sender: TObject);
  var APoint : TPoint;
begin
  if not TabletkiAPI.BookingsHeadCDS.Active then Exit;
  if TabletkiAPI.BookingsHeadCDS.IsEmpty then Exit;

  try
    TabletkiAPI.BookingsHeadCDS.First;
    while not TabletkiAPI.BookingsHeadCDS.Eof  do
    begin
      spInsertMovement.Params.ParamByName('ioId').AsInteger := 0;
      spInsertMovement.Params.ParamByName('inUnitId').AsInteger := TabletkiAPI.BookingsHeadCDS.FieldByName('pharmacyId').AsInteger;
      spInsertMovement.Params.ParamByName('inDate').Value := Null;
      spInsertMovement.Params.ParamByName('inBookingId').AsString := TabletkiAPI.BookingsHeadCDS.FieldByName('bookingId').AsString;
      spInsertMovement.Params.ParamByName('inOrderId').AsString := TabletkiAPI.BookingsHeadCDS.FieldByName('orderId').AsString;
      spInsertMovement.Params.ParamByName('inBookingStatus').AsString := TabletkiAPI.BookingsHeadCDS.FieldByName('status').AsString;
      spInsertMovement.Params.ParamByName('inSession').AsString := '3';
      spInsertMovement.ExecProc;

      TabletkiAPI.BookingsBodyCDS.First;
      while not TabletkiAPI.BookingsBodyCDS.Eof  do
      begin

        spInsertMovementItem.Params.ParamByName('ioId').AsInteger := 0;
        spInsertMovementItem.Params.ParamByName('inMovementId').AsInteger := spInsertMovement.Params.ParamByName('ioId').AsInteger;
        spInsertMovementItem.Params.ParamByName('inItemId').AsString := TabletkiAPI.BookingsBodyCDS.FieldByName('itemId').AsString;
        spInsertMovementItem.Params.ParamByName('inGoodsId').AsInteger := TabletkiAPI.BookingsBodyCDS.FieldByName('productId').AsInteger;
        spInsertMovementItem.Params.ParamByName('inAmount').AsCurrency := TabletkiAPI.BookingsBodyCDS.FieldByName('quantity').AsCurrency;
        spInsertMovementItem.Params.ParamByName('inPrice').AsCurrency := TabletkiAPI.BookingsBodyCDS.FieldByName('price').AsCurrency;
        spInsertMovementItem.Params.ParamByName('inSession').AsString := '3';
        spInsertMovementItem.ExecProc;

        TabletkiAPI.BookingsBodyCDS.Next;
      end;

      TabletkiAPI.BookingsHeadCDS.Next;
    end;


  except
    on E: Exception do Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnUpdateStausClick(Sender: TObject);
var
  Urgently : boolean;
  Status : string;

  function GetJSONAItems : TJSONArray;
    var  jsonItem: TJSONObject;
  begin
    Result := TJSONArray.Create;
    qryCheckBody.First;
    while not qryCheckBody.Eof do
    begin
      jsonItem := TJSONObject.Create;
      jsonItem.AddPair('productId', TJSONString.Create(qryCheckBody.FieldByName('GoodsId').AsString));
      jsonItem.AddPair('quantity', TJSONNumber.Create(qryCheckBody.FieldByName('Amount').AsCurrency));
      jsonItem.AddPair('price', TJSONNumber.Create(qryCheckBody.FieldByName('Price').AsCurrency));
      Result.AddElement(jsonItem);
      qryCheckBody.Next;
    end;
  end;

begin
  if not qryCheckHead.Active then Exit;
  if qryCheckHead.IsEmpty then Exit;

  Add_Log('Начало изменения статусов');

  try
    qryCheckHead.First;
    while not qryCheckHead.Eof do
    begin

//      if TabletkiAPI.GetStaus(qryCheckHead.FieldByName('BookingId').AsString, Status) then
//      begin
//        if Status = 'Cancelled' then
//        begin
//          spUpdateMovementStatus.Params.ParamByName('inMovementId').AsInteger := qryCheckHead.FieldByName('Id').AsInteger;
//          spUpdateMovementStatus.Params.ParamByName('inBookingStatus').AsString := Status;
//          spUpdateMovementStatus.Params.ParamByName('inSession').AsString := '3';
//          spUpdateMovementStatus.ExecProc;
//        end else if Status <> qryCheckHead.FieldByName('BookingStatusNew').AsString then
//        begin
//          if TabletkiAPI.UpdateStaus(qryCheckHead.FieldByName('BookingId').AsString,
//                                   qryCheckHead.FieldByName('Id').AsString,
//                                   qryCheckHead.FieldByName('BookingStatusNew').AsString,
//                                   qryCheckHead.FieldByName('InvNumber').AsString, GetJSONAItems) then
//          begin
//            spUpdateMovementStatus.Params.ParamByName('inMovementId').AsInteger := qryCheckHead.FieldByName('Id').AsInteger;
//            spUpdateMovementStatus.Params.ParamByName('inBookingStatus').AsString := qryCheckHead.FieldByName('BookingStatusNew').AsString;
//            spUpdateMovementStatus.Params.ParamByName('inSession').AsString := '3';
//            spUpdateMovementStatus.ExecProc;
//          end;
//        end else if qryCheckHead.FieldByName('BookingStatus').AsString <> qryCheckHead.FieldByName('BookingStatusNew').AsString then
//        begin
//          spUpdateMovementStatus.Params.ParamByName('inMovementId').AsInteger := qryCheckHead.FieldByName('Id').AsInteger;
//          spUpdateMovementStatus.Params.ParamByName('inBookingStatus').AsString := qryCheckHead.FieldByName('BookingStatusNew').AsString;
//          spUpdateMovementStatus.Params.ParamByName('inSession').AsString := '3';
//          spUpdateMovementStatus.ExecProc;
//        end;
//      end else
//      begin
//        Add_Log('Ошибка получения статуса: ' + TabletkiAPI.ErrorsText);
//      end;

      qryCheckHead.Next;
    end;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
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

  finally
    Ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
  except
    on E:Exception do
    begin
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
      btnAll.Enabled := false;
      btnLoadBookings.Enabled := false;
      btnSaveBookings.Enabled := false;
      btnOpenBooking.Enabled := false;
      btnUpdateStaus.Enabled := false;
      Timer1.Enabled := true;
    end;
  end else
  begin
    Timer1.Enabled := true;
    Exit;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  TabletkiAPI.Free;
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
