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
  cxImageComboBox, cxNavigator, UnitLiki24,
  cxDataControllerConditionalFormattingRulesManagerDialog, ZStoredProcedure;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    BookingsBodyDS: TDataSource;
    Panel2: TPanel;
    btnSendTelegram: TButton;
    btnExport: TButton;
    btnSaveBookings: TButton;
    btnAll: TButton;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    grChatId: TcxGrid;
    grChatIdDBTableView: TcxGridDBTableView;
    productId: TcxGridDBColumn;
    quantity: TcxGridDBColumn;
    price: TcxGridDBColumn;
    itemId: TcxGridDBColumn;
    grChatIdLevel: TcxGridLevel;
    btnLoadBookings: TButton;
    grReport: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    isUrgently: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    Panel1: TPanel;
    cxGrid1: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    bookingId: TcxGridDBColumn;
    status: TcxGridDBColumn;
    pharmacyId: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    BookingsHeadDS: TDataSource;
    btnAddTest: TButton;
    spInsertMovement: TZStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnSaveBookingsClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadBookingsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddTestClick(Sender: TObject);
  private
    { Private declarations }

    APIUser: String;
    APIPassword: String;
    Liki24API : TLiki24API;

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
    btnExportClick(Nil);

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;


procedure TMainForm.btnAddTestClick(Sender: TObject);
  var GUID, GUIDI: TGUID;
begin

  if not Liki24API.BookingsHeadCDS.Active then Exit;

  CreateGUID(GUID);
  Liki24API.BookingsHeadCDS.Last;
  Liki24API.BookingsHeadCDS.Append;
  Liki24API.BookingsHeadCDS.FieldByName('bookingId').AsString := GUID.ToString;
  Liki24API.BookingsHeadCDS.FieldByName('status').AsString := 'Processing';
  Liki24API.BookingsHeadCDS.FieldByName('type').AsString := 'SelfService';
  Liki24API.BookingsHeadCDS.FieldByName('pharmacyId').AsInteger := 6128298;
  Liki24API.BookingsHeadCDS.FieldByName('orderId').AsString := 'bfb4b3dd-affe-11ea-a9f3-00163e3c1eb4';
  Liki24API.BookingsHeadCDS.FieldByName('orderNumber').AsInteger := 328202;
  Liki24API.BookingsHeadCDS.Post;

  CreateGUID(GUIDI);
  Liki24API.BookingsBodyCDS.Last;
  Liki24API.BookingsBodyCDS.Append;
  Liki24API.BookingsBodyCDS.FieldByName('bookingId').AsString := GUID.ToString;
  Liki24API.BookingsBodyCDS.FieldByName('itemId').AsString := GUIDI.ToString;
  Liki24API.BookingsBodyCDS.FieldByName('productId').AsInteger := 36085;
  Liki24API.BookingsBodyCDS.FieldByName('quantity').AsCurrency := 1;
  Liki24API.BookingsBodyCDS.FieldByName('price').AsCurrency := 36.30;
  Liki24API.BookingsBodyCDS.Post;

  CreateGUID(GUID);
  Liki24API.BookingsHeadCDS.Last;
  Liki24API.BookingsHeadCDS.Append;
  Liki24API.BookingsHeadCDS.FieldByName('bookingId').AsString := GUID.ToString;
  Liki24API.BookingsHeadCDS.FieldByName('status').AsString := 'Processing';
  Liki24API.BookingsHeadCDS.FieldByName('type').AsString := 'SelfService';
  Liki24API.BookingsHeadCDS.FieldByName('pharmacyId').AsInteger := 6128298;
  Liki24API.BookingsHeadCDS.FieldByName('orderId').AsString := 'bfb4b3dd-affe-11ea-a9f3-00163e3c1eb4';
  Liki24API.BookingsHeadCDS.FieldByName('orderNumber').AsInteger := 328202;
  Liki24API.BookingsHeadCDS.Post;

  CreateGUID(GUIDI);
  Liki24API.BookingsBodyCDS.Last;
  Liki24API.BookingsBodyCDS.Append;
  Liki24API.BookingsBodyCDS.FieldByName('bookingId').AsString := GUID.ToString;
  Liki24API.BookingsBodyCDS.FieldByName('itemId').AsString := GUIDI.ToString;
  Liki24API.BookingsBodyCDS.FieldByName('productId').AsInteger := 27292;
  Liki24API.BookingsBodyCDS.FieldByName('quantity').AsCurrency := 1;
  Liki24API.BookingsBodyCDS.FieldByName('price').AsCurrency := 13.4;
  Liki24API.BookingsBodyCDS.Post;

  CreateGUID(GUIDI);
  Liki24API.BookingsBodyCDS.Last;
  Liki24API.BookingsBodyCDS.Append;
  Liki24API.BookingsBodyCDS.FieldByName('bookingId').AsString := GUID.ToString;
  Liki24API.BookingsBodyCDS.FieldByName('itemId').AsString := GUIDI.ToString;
  Liki24API.BookingsBodyCDS.FieldByName('productId').AsInteger := 6317159;
  Liki24API.BookingsBodyCDS.FieldByName('quantity').AsCurrency := 2;
  Liki24API.BookingsBodyCDS.FieldByName('price').AsCurrency := 1.6;
  Liki24API.BookingsBodyCDS.Post;

  end;

procedure TMainForm.btnAllClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  try
   btnSaveBookingsClick(Nil);
    btnExportClick(Nil);

    if not qryReport_Upload.Active then Exit;
    if qryReport_Upload.IsEmpty then Exit;

    Application.ProcessMessages;

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnLoadBookingsClick(Sender: TObject);
begin
  if not Liki24API.LoadBookings then
  begin
     if Liki24API.ErrorsText = '' then Add_Log('Нет новых заказов.')
     else Add_Log(Liki24API.ErrorsText);
  end;
end;

procedure TMainForm.btnSaveBookingsClick(Sender: TObject);
  var APoint : TPoint;
begin
  if not Liki24API.BookingsHeadCDS.Active then Exit;
  if Liki24API.BookingsHeadCDS.IsEmpty then Exit;

  try
    Liki24API.BookingsHeadCDS.First;
    while not Liki24API.BookingsHeadCDS.Eof  do
    begin
      spInsertMovement.Params.ParamByName('ioId').Value := 0;
      spInsertMovement.Params.ParamByName('inUnitId').Value := Liki24API.BookingsHeadCDS.FieldByName('pharmacyId').AsInteger;
      spInsertMovement.Params.ParamByName('inDate').Value := Null;
      spInsertMovement.Params.ParamByName('inBookingId').Value := Liki24API.BookingsHeadCDS.FieldByName('bookingId').AsString;
      spInsertMovement.Params.ParamByName('inOrderId').Value := Liki24API.BookingsHeadCDS.FieldByName('orderId').AsString;
      spInsertMovement.Params.ParamByName('inSession').Value := 3;
      spInsertMovement.ExecSQL;

      Liki24API.BookingsBodyCDS.First;
      while not Liki24API.BookingsBodyCDS.Eof  do
      begin

        Liki24API.BookingsBodyCDS.Next;
      end;

      Liki24API.BookingsHeadCDS.Next;
    end;


  except
    on E: Exception do Add_Log(E.Message);
  end;
end;

procedure TMainForm.btnExportClick(Sender: TObject);
var
  Urgently : boolean;
begin
  if not qryReport_Upload.Active then Exit;
  if qryReport_Upload.IsEmpty then Exit;
//  if not qryDriver.Active then Exit;
//  if qryDriver.IsEmpty then Exit;
//  Add_Log('Начало выгрузки отчета');



end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BookingsForLiki24.ini');

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

  Liki24API := TLiki24API.Create(APIUser, APIPassword);
  if Liki24API.Token = '' then
  begin
    Add_Log(Liki24API.ErrorsText);
    Timer1.Enabled := true;
    Exit;
  end;

  BookingsHeadDS.DataSet := Liki24API.BookingsHeadCDS;
  BookingsBodyDS.DataSet := Liki24API.BookingsBodyCDS;
  Liki24API.BookingsBodyCDS.IndexFieldNames := 'bookingId';
  Liki24API.BookingsBodyCDS.MasterFields := 'bookingId';
  Liki24API.BookingsBodyCDS.MasterSource := BookingsHeadDS;


  if ZConnection1.Connected then
  begin

    if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) or
      (Pos('Farmacy.exe', Application.ExeName) <> 0)) then
    begin
      btnAll.Enabled := false;
      btnLoadBookings.Enabled := false;
      btnSaveBookings.Enabled := false;
      btnExport.Enabled := false;
      btnSendTelegram.Enabled := false;
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
  Liki24API.Free;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    if ZConnection1.Connected and (Liki24API.Token <> '') then btnAllClick(nil);
  finally
    Close;
  end;
end;

end.
