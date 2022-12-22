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
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ;

type
  TMainForm = class(TForm)
    ZConnection: TZConnection;
    Timer1: TTimer;
    qryMaker: TZQuery;
    dsMaker: TDataSource;
    qryMailParam: TZQuery;
    Panel2: TPanel;
    btnAll: TButton;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    qrySetDateSend: TZQuery;
    Memo: TMemo;
    ZQuery: TZQuery;
    ZQueryTable: TZQuery;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
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
    Memo.Lines.Add(FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;


procedure TMainForm.btnAllClick(Sender: TObject);

  function lVACUUM (lStr : String): Boolean;
  begin
     try
       Application.ProcessMessages;
       ZQuery.Sql.Clear;;
       ZQuery.Sql.Add (lStr);
       ZQuery.ExecSql;
       Add_Log(lStr);
       Application.ProcessMessages;
       Sleep(500);
     except
       on E: Exception do
         Add_Log(E.Message);
     end;
  end;
begin
  try
    try

       if not ((CompareText(ParamStr(1), 'analyze') = 0) or (CompareText(ParamStr(2), 'analyze') = 0) or (CompareText(ParamStr(3), 'analyze') = 0)) then
       begin
         //
         Add_Log('start all VACUUM');
         //
         // Container
//         lVACUUM ('VACUUM FULL Container');
//         lVACUUM ('VACUUM ANALYZE Container');
         // CashSessionSnapShot - !!! 180 MIN !!!
         lVACUUM ('delete from CashSessionSnapShot WHERE CashSessionId IN (select Id from CashSession WHERE lastConnect < CURRENT_TIMESTAMP - INTERVAL ' + chr(39) + '180 MIN' + chr(39) + ')');
         lVACUUM ('delete from CashSession WHERE Id NOT IN (SELECT DISTINCT CashSessionId FROM CashSessionSnapShot) AND lastConnect < CURRENT_TIMESTAMP - INTERVAL ' + chr(39) + '180 MIN' + chr(39));
//         lVACUUM ('VACUUM FULL CashSession');
//         lVACUUM ('VACUUM ANALYZE CashSession');
//         lVACUUM ('VACUUM FULL CashSessionSnapShot');
//         lVACUUM ('VACUUM ANALYZE CashSessionSnapShot');
         // LoadPriceList + LoadPriceListItem
//         lVACUUM ('VACUUM FULL LoadPriceList');
//         lVACUUM ('VACUUM ANALYZE LoadPriceList');
//         lVACUUM ('VACUUM FULL LoadPriceListItem');
//         lVACUUM ('VACUUM ANALYZE LoadPriceListItem');
         // System - FULL
//         lVACUUM ('VACUUM FULL pg_catalog.pg_statistic');
//         lVACUUM ('VACUUM FULL pg_catalog.pg_attribute');
//         lVACUUM ('VACUUM FULL pg_catalog.pg_class');
//         lVACUUM ('VACUUM FULL pg_catalog.pg_type');
//         lVACUUM ('VACUUM FULL pg_catalog.pg_depend');
//         lVACUUM ('VACUUM FULL pg_catalog.pg_shdepend');
//         lVACUUM ('VACUUM FULL pg_catalog.pg_index');
//         lVACUUM ('VACUUM FULL pg_catalog.pg_attrdef');
//         lVACUUM ('VACUUM FULL pg_catalog.pg_proc');
         // System - ANALYZE
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_statistic');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_attribute');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_class');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_type');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_depend');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_shdepend');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_index');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_attrdef');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_proc');
         //
         // !!!main!!!
         try
           ZQueryTable.Open;
           ZQueryTable.First;
           while not ZQueryTable.Eof do
           begin
              lVACUUM ('VACUUM ANALYZE ' + ZQueryTable.FieldByName('table_name').AsString);
              ZQueryTable.Next;
              if HourOf(Now) >= 7 then Exit;
           end;

         finally
           //
           //
           Add_Log('end all VACUUM');
         end;
       end else
       begin

         if HourOf(Now) < 7 then Exit;

         //
         Add_Log('start all ANALYZE');
         //

         // System - ANALYZE
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_statistic');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_attribute');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_class');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_type');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_depend');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_shdepend');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_index');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_attrdef');
         lVACUUM ('VACUUM ANALYZE pg_catalog.pg_proc');

         ZQueryTable.Open;
         ZQueryTable.First;
         while not ZQueryTable.Eof do
         begin
            lVACUUM ('ANALYZE ' + ZQueryTable.FieldByName('table_name').AsString);
            ZQueryTable.Next;
         end;

         //
         //
         Add_Log('end all ANALYZE');
       end;

    except
      on E: Exception do
        Add_Log(E.Message);
    end;
  finally
        ZConnection.Connected := false;
        ZQuery.Free;
        ZConnection.Free;
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
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExecuteVACUM.ini');

  try

    ZConnection.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection.Database);

    ZConnection.HostName := Ini.ReadString('Connect', 'HostName', '172.17.2.5');
    Ini.WriteString('Connect', 'HostName', ZConnection.HostName);

    ZConnection.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection.User);

    ZConnection.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection.Password);

  finally
    Ini.free;
  end;

  ZConnection.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection.Connect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      ZConnection.Disconnect;
      Timer1.Enabled := true;
      Exit;
    end;
  end;

  if ZConnection.Connected then
  begin
    if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
    begin
      btnAll.Enabled := false;
      Timer1.Enabled := true;
    end;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    if ZConnection.Connected then btnAllClick(nil);
  finally
    Close;
  end;
end;


end.
