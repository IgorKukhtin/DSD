unit ExternalLoad;

interface

uses dsdAction, dsdDb, Classes, DB, ExternalData, ADODB;

type

  TDataSetType = (dtDBF, dtXLS, dtMMO, dtODBC);

  TExternalLoad = class(TExternalData)
  protected
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  public
    property Active: boolean read FActive;
  end;

  TFileExternalLoad = class(TExternalLoad)
  private
    FInitializeDirectory: string;
    FDataSetType: TDataSetType;
    FAdoConnection: TADOConnection;
    FFileExtension: string;
    FFileFilter: string;
    FExtendedProperties: string;
    FStartRecord: integer;
    // ������� ��� ��������� mmo ������
    procedure CreateMMODataSet(FileName: string);
  protected
    procedure First; override;
  public
    constructor Create(DataSetType: TDataSetType = dtDBF; StartRecord: integer = 1; ExtendedProperties: string = '');
    destructor Destroy; override;
    procedure Open(FileName: string);
    procedure Activate; override;
    procedure Close; override;
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
  end;

  TODBCExternalLoad = class(TExternalLoad)
  private
    FAdoConnection: TADOConnection;
  protected
    procedure First; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Open(AConnection, ASQL: string);
    procedure Activate; override;
    procedure Close; override;
  end;

  TExternalLoadAction = class(TdsdCustomAction)
  private
    FInitializeDirectory: string;
    FFileName: string;
  protected
    function GetStoredProc: TdsdStoredProc; virtual; abstract;
    function GetExternalLoad: TExternalLoad; virtual; abstract;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AStoredProc: TdsdStoredProc); virtual; abstract;
  public
    property FileName: string read FFileName write FFileName;
    constructor Create(Owner: TComponent); override;
    function Execute: boolean; override;
  published
    // ���������� ��������. ������� published ��� �� ��������� ������ �� ����������� �����
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
  end;

  TImportSettingsItems = class (TCollectionItem)
  public
    ItemName: string;
    Param: TdsdParam;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  end;

  TImportSettings = class (TCollection)
  public
    JuridicalId: Integer;
    ContractId: Integer;
    FileType: TDataSetType;
    StoredProc: TdsdStoredProc;
    StartRow: integer;
    HDR: boolean;
    Directory: string;
    Query: string;
    constructor Create(ItemClass: TCollectionItemClass);
    destructor Destroy; override;
  end;

  TImportSettingsFactory = class
  private
    class function GetDefaultByFieldType(FieldType: TFieldType): OleVariant;
    class function CreateImportSettings(Id: integer): TImportSettings;
  public
    class function GetImportSettings(Id: integer): TImportSettings;
  end;

  TExecuteProcedureFromExternalDataSet = class
  private
    FExternalLoad: TExternalLoad;
    FImportSettings: TImportSettings;
    function GetFieldName(AFieldName: AnsiString; AImportSettings: TImportSettings): string;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AImportSettings: TImportSettings);
  public
    constructor Create(FileType: TDataSetType; FileName: string; ImportSettings: TImportSettings); overload;
    constructor Create(ConnectionString, SQL: string; ImportSettings: TImportSettings); overload;
    destructor Destroy; override;
    procedure Load;
  end;

  TExecuteImportSettings = class
    class procedure Execute(ImportSettings: TImportSettings);
  end;

  TExecuteImportSettingsAction = class(TdsdCustomAction)
  private
    FImportSettingsId: TdsdParam;
  protected
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ImportSettingsId: TdsdParam read FImportSettingsId write FImportSettingsId;
  end;

  procedure Register;

implementation

uses VCL.ActnList, SysUtils, Dialogs, SimpleGauge, VKDBFDataSet, UnilWin,
     DBClient, TypInfo, Variants, UtilConvert, WinApi.Windows, StrUtils,
     System.Types;

const cArchive = 'Archive';

procedure Register;
begin
  RegisterActions('dsdImportExport', [TExecuteImportSettingsAction], TExecuteImportSettingsAction);
end;

function GetFileType(FileTypeName: string): TDataSetType;
begin
  if FileTypeName = 'ODBC' then
     result := dtODBC
  else
    if FileTypeName = 'DBF' then
       result := dtDBF
    else
      if FileTypeName = 'Excel' then
         result := dtXLS
      else
        if FileTypeName = 'MMO' then
           result := dtMMO
        else
          raise Exception.Create('��� ����� "' + FileTypeName + '" �� ��������� � ���������');
end;

{ TFileExternalLoad }

procedure TFileExternalLoad.Activate;
begin
  with {File}TOpenDialog.Create(nil) do
  try
    InitialDir := InitializeDirectory;
    DefaultExt := FFileExtension;
    Filter := FFileFilter;
    if Execute then begin
       InitializeDirectory := ExtractFilePath(FileName);
       Self.Open(FileName);
    end;
  finally
    Free;
  end;
end;

constructor TExternalLoadAction.Create(Owner: TComponent);
begin
  FileName := '';
  inherited;
end;

function TExternalLoadAction.Execute: boolean;
var
   FExternalLoad: TFileExternalLoad;
   FStoredProc: TdsdStoredProc;
begin
  result := false;
  FExternalLoad := TFileExternalLoad(GetExternalLoad);
  try
    FExternalLoad.InitializeDirectory := InitializeDirectory;
    if FileName <> '' then
       FExternalLoad.Open(FileName)
    else
       FExternalLoad.Activate;
    if FExternalLoad.Active then begin
       InitializeDirectory := FExternalLoad.InitializeDirectory;
       FStoredProc := GetStoredProc;
       try
         if  FExternalLoad.RecordCount > 0 then
             with TGaugeFactory.GetGauge('�������� ������', 1, FExternalLoad.RecordCount) do begin
               Start;
               try
                 while not FExternalLoad.EOF do begin
                   ProcessingOneRow(FExternalLoad, FStoredProc);
                   IncProgress;
                   FExternalLoad.Next;
                 end;
               finally
                 Finish
               end;
               result := true
             end;
       finally
         FStoredProc.Free
       end;
    end;
  finally
    FExternalLoad.Free;
  end;
end;

procedure TFileExternalLoad.Close;
begin
  FDataSet.Close;
  if Assigned(FAdoConnection) then
     FAdoConnection.Connected := false;
end;

constructor TFileExternalLoad.Create(DataSetType: TDataSetType; StartRecord: integer; ExtendedProperties: string);
begin
  inherited Create;
  FOEM := true;
  FDataSetType := DataSetType;
  FExtendedProperties := ExtendedProperties;
  FStartRecord := StartRecord;
  case FDataSetType of
    dtDBF: begin
             FFileExtension := '*.dbf';
             FFileFilter := '����� DBF (*.dbf)|*.dbf|';
           end;
    dtXLS: begin
             FFileExtension := '*.xls';
             FFileFilter := '����� �������� Excel|*.xls;*.xlsx|';
           end;
  end;
end;

procedure TFileExternalLoad.CreateMMODataSet(FileName: string);
var
  StringList: TStringList;
  OkpoFrom, OkpoTo, InvNumber, InvTaxNumber,
  Remark: string;
  OperDate, PaymentDate, ExpirationDate: TDateTime;
  PriceWithVAT: boolean;
  SyncCode: Integer;
  ElementList: TStringDynArray;
  i: integer;
  Price: Currency;
begin
  FDataSet := TClientDataSet.Create(nil);
  FDataSet.FieldDefs.Add('OKPOFrom', ftString, 255);
  FDataSet.FieldDefs.Add('OKPOTo', ftString, 255);
  FDataSet.FieldDefs.Add('InvNumber', ftString, 255);
  FDataSet.FieldDefs.Add('OperDate', ftDateTime);
  FDataSet.FieldDefs.Add('InvTaxNumber', ftString, 255);
  FDataSet.FieldDefs.Add('PaymentDate', ftDateTime);
  FDataSet.FieldDefs.Add('PriceWithVAT', ftBoolean);
  FDataSet.FieldDefs.Add('SyncCode', ftInteger);
  FDataSet.FieldDefs.Add('Remark', ftString, 255);

  FDataSet.FieldDefs.Add('GoodsCode', ftString, 255);
  FDataSet.FieldDefs.Add('GoodsName', ftString, 255);
  FDataSet.FieldDefs.Add('MakerCode', ftString, 255);
  FDataSet.FieldDefs.Add('MakerName', ftString, 255);
  FDataSet.FieldDefs.Add('CommonCode', ftString, 255);
  FDataSet.FieldDefs.Add('VAT', ftInteger);
  FDataSet.FieldDefs.Add('PartitionGoods', ftString, 255); // ����� �����
  FDataSet.FieldDefs.Add('ExpirationDate', ftDateTime);    // ���� ��������
  FDataSet.FieldDefs.Add('FEA', ftString, 255); //
  FDataSet.FieldDefs.Add('MeasureName', ftString, 255); //

  FDataSet.FieldDefs.Add('Amount', ftFloat);    // ����������
  FDataSet.FieldDefs.Add('Price', ftFloat);     // ���� ��������� (��� ������ ��� ����������)

  TClientDataSet(FDataSet).CreateDataSet;
  // ��������� ����
  StringList := TStringList.Create;
  try
    StringList.LoadFromFile(FileName);
    // �������� ���������. 3 ������
    ElementList := SplitString(StringList[0], #9);
    OkpoFrom := ElementList[1];
    OkpoTo := ElementList[2];
    ElementList := SplitString(StringList[1], #9);
    InvNumber := ElementList[0];
    OperDate := VarToDateTime(trim(ElementList[1]));
    InvTaxNumber := ElementList[2];
    if ElementList[13] = '' then
       PaymentDate := OperDate
    else
       PaymentDate := VarToDateTime(ElementList[13]);

    PriceWithVAT := ElementList[14] = '1';
    SyncCode := StrToIntDef(ElementList[15], 0);

    Remark := '';
    ElementList := SplitString(StringList[2], #9);
    for I := Low(ElementList) to High(ElementList) do
        if ElementList[i] <> '' then begin
           Remark := ElementList[i];
           break;
        end;
    for I := 3 to StringList.Count - 1 do
        // ��������� ������
        with FDataSet do begin
          ElementList := SplitString(StringList[i], #9);
          Price := gfStrToFloat(ElementList[20]) / gfStrToFloat(ElementList[15]);
          ElementList[13] := trim(ElementList[13]);
          if (ElementList[13] = '') or (ElementList[13] = '.  .') then
             ExpirationDate := OperDate + 365
          else
             ExpirationDate := VarToDateTime(ElementList[13]);    // ���� ��������
          // ��������� ���������� �������
          if Locate('GoodsCode;PartitionGoods;ExpirationDate;Price',
                      VarArrayOf([ElementList[0], ElementList[10], ExpirationDate, Price]), []) then begin
             Edit;
             FieldByName('Amount').AsFloat := FieldByName('Amount').AsFloat + gfStrToFloat(ElementList[15]);    // ����������
             Post
          end
          else begin
            Append;
            FieldByName('OKPOFrom').AsString := OkpoFrom;
            FieldByName('OKPOTo').AsString := OkpoTo;
            FieldByName('InvNumber').AsString := InvNumber;
            FieldByName('OperDate').AsDateTime := OperDate;
            FieldByName('InvTaxNumber').AsString := InvTaxNumber;
            FieldByName('PaymentDate').AsDateTime := PaymentDate;
            FieldByName('PriceWithVAT').AsBoolean := PriceWithVAT;
            FieldByName('SyncCode').AsInteger := SyncCode;
            FieldByName('Remark').AsString := Remark;

            FieldByName('GoodsCode').AsString := ElementList[0];
            FieldByName('GoodsName').AsString := ElementList[1];
            FieldByName('MakerCode').AsString := ElementList[2];
            FieldByName('MakerName').AsString := ElementList[3];
            FieldByName('CommonCode').AsString := ElementList[4];
            FieldByName('VAT').AsInteger := round(gfStrToFloat(ElementList[8]));
            FieldByName('PartitionGoods').AsString := ElementList[10]; // ����� �����
            FieldByName('ExpirationDate').AsDateTime := ExpirationDate;    // ���� ��������
            if High(ElementList) < 21 then
               FieldByName('FEA').AsString := '' // ����
            else
               FieldByName('FEA').AsString := ElementList[21]; // ����
            FieldByName('MeasureName').AsString := ElementList[14]; // �� ���
            FieldByName('Amount').AsFloat := gfStrToFloat(ElementList[15]);    // ����������
            FieldByName('Price').AsFloat  := Price;    // ���� ��������� (��� ������ ��� ����������)
            Post;
          end;
        end;
  finally
    StringList.Free;
  end;
end;

destructor TFileExternalLoad.Destroy;
begin
  if Assigned(FDataSet) then
     FreeAndNil(FDataSet);
  if Assigned(FAdoConnection) then
     FreeAndNil(FAdoConnection);
  inherited;
end;

procedure TFileExternalLoad.First;
begin
  inherited;
  FDataSet.First
end;

procedure TFileExternalLoad.Open(FileName: string);
var strConn :  widestring;
    List: TStringList;
    ListName: string;
begin
  case FDataSetType of
    dtMMO: CreateMMODataSet(FileName);
    dtDBF: begin
        FDataSet := TVKSmartDBF.Create(nil);
        TVKSmartDBF(FDataSet).DBFFileName := AnsiString(FileName);
        TVKSmartDBF(FDataSet).OEM := FOEM;
        try
          FDataSet.Open;
        except
          on E: Exception do begin
             if Pos('TVKSmartDBF.InternalOpen: Open error', E.Message) > -1 then
                raise Exception.Create('����' + copy (E.Message, length('TVKSmartDBF.InternalOpen: Open error') + 1, MaxInt) + ' ������ ������ ����������. �������� �� � ���������� ��� ���!')
             else
                raise Exception.Create(E.Message);
          end;
        end;
    end;
    dtXLS: begin
      strConn:='Provider=Microsoft.Jet.OLEDB.4.0;' +
               'Data Source=' + FileName + ';' +
               'Extended Properties="Excel 8.0' + FExtendedProperties + ';IMEX=1;"';
      if not Assigned(FAdoConnection) then begin
         FAdoConnection := TAdoConnection.Create(nil);
         FAdoConnection.LoginPrompt := false;
         FDataSet := TADOQuery.Create(nil);
         TADOQuery(FDataSet).Connection := FAdoConnection;
      end;
      FAdoConnection.Connected := False;
      FAdoConnection.ConnectionString := strConn;
      FAdoConnection.Open;
      List := TStringList.Create;
      try
        FAdoConnection.GetTableNames(List, True);
        TADOQuery(FDataSet).ParamCheck := false;
        ListName := '';//List[0];
        if Copy(ListName, 1, 1) = chr(39) then
           ListName := Copy(List[0], 2, length(List[0])-2);
        TADOQuery(FDataSet).SQL.Text := 'SELECT * FROM [' + ListName + 'A' + IntToStr(FStartRecord)+ ':AZ60000]';
        TADOQuery(FDataSet).Open;
      finally
        FreeAndNil(List);
      end;
    end;
  end;
  First;
  FActive := FDataSet.Active;
end;

{ TExecuteProcedureFromFile }

constructor TExecuteProcedureFromExternalDataSet.Create(FileType: TDataSetType; FileName: string; ImportSettings: TImportSettings);
var ExtendedProperties: string;
begin
  if ImportSettings.HDR then
     ExtendedProperties := '; HDR=Yes'
  else
     ExtendedProperties := '; HDR=No';
  FImportSettings := ImportSettings;
  FExternalLoad := TFileExternalLoad.Create(FileType, ImportSettings.StartRow, ExtendedProperties);
  TFileExternalLoad(FExternalLoad).Open(FileName);
end;

constructor TExecuteProcedureFromExternalDataSet.Create(ConnectionString,
  SQL: string; ImportSettings: TImportSettings);
begin
  FImportSettings := ImportSettings;
  FExternalLoad := TODBCExternalLoad.Create;
  TODBCExternalLoad(FExternalLoad).Open(ConnectionString, SQL);
  TODBCExternalLoad(FExternalLoad).Activate;
end;

destructor TExecuteProcedureFromExternalDataSet.Destroy;
begin
  FreeAndNil(FExternalLoad);
  inherited;
end;

function TExecuteProcedureFromExternalDataSet.GetFieldName(AFieldName: AnsiString;
  AImportSettings: TImportSettings): string;
var
  c, c1: char;
begin
  result := AFieldName;
  if (AImportSettings.FileType = dtXLS) and (not AImportSettings.HDR) then begin
     if (length(AFieldName) = 1) then begin
        c := lowercase(AFieldName)[1];
        if c in ['a'..'z'] then
           result := 'F' + IntToStr(byte(c) - byte('a') + 1);
     end;
     if (length(AFieldName) = 2) then begin
        c  := lowercase(AFieldName)[1];
        c1 := lowercase(AFieldName)[2];
        if (c in ['a'..'z']) and (c1 in ['a'..'z']) then
           result := 'F' + IntToStr((byte(c) - byte('a') + 1) *26 + byte(c1) - byte('a') + 1);
     end;
  end;
end;

procedure TExecuteProcedureFromExternalDataSet.Load;
begin
  with TGaugeFactory.GetGauge('�������� ������', 1, FExternalLoad.RecordCount) do begin
    Start;
    try
      while not FExternalLoad.EOF do begin
        ProcessingOneRow(FExternalLoad, FImportSettings);
        IncProgress;
        FExternalLoad.Next;
      end;
      FImportSettings.StoredProc.Execute(true);
      FExternalLoad.Close;
    finally
     Finish
    end;
  end;
end;

procedure TExecuteProcedureFromExternalDataSet.ProcessingOneRow(AExternalLoad: TExternalLoad;
  AImportSettings: TImportSettings);
var i: integer;
    D: TDateTime;
    Value: OleVariant;
    Ft: double;
    vbFieldName: string;
begin
  with AImportSettings do begin
    for i := 0 to Count - 1 do begin
        if TImportSettingsItems(Items[i]).ItemName = '%OBJECT%' then
           StoredProc.Params.Items[i].Value := AImportSettings.JuridicalId
        else
           if TImportSettingsItems(Items[i]).ItemName = '%CONTRACT%' then
              StoredProc.Params.Items[i].Value := AImportSettings.ContractId
           else
             if TImportSettingsItems(Items[i]).ItemName = '%LASTRECORD%' then
                StoredProc.Params.Items[i].Value := AExternalLoad.isLastRecord
             else begin
               if TImportSettingsItems(Items[i]).ItemName <> '' then begin
                  vbFieldName := GetFieldName(TImportSettingsItems(Items[i]).ItemName, AImportSettings);
                  case StoredProc.Params[i].DataType of
                    ftDateTime: begin
                       try
                         Value := AExternalLoad.FDataSet.FieldByName(vbFieldName).Value;
                         D := VarToDateTime(Value);
                         StoredProc.Params.Items[i].Value := D;
                       except
                         on E: EVariantTypeCastError do
                            StoredProc.Params.Items[i].Value := Date;
                         on E: Exception do
                            raise E;
                       end;
                    end;
                    ftFloat: begin
                       try
                         Value := AExternalLoad.FDataSet.FieldByName(vbFieldName).Value;
                         Ft := gfStrToFloat(Value);
                         StoredProc.Params.Items[i].Value := Ft;
                       except
                         on E: EVariantTypeCastError do
                            StoredProc.Params.Items[i].Value := 0;
                         on E: Exception do
                            raise E;
                       end;
                    end
                    else
                      if VarIsNULL(AExternalLoad.FDataSet.FieldByName(vbFieldName).Value) then
                         StoredProc.Params.Items[i].Value := ''
                      else
                         StoredProc.Params.Items[i].Value := trim(AExternalLoad.FDataSet.FieldByName(vbFieldName).Value);
                  end;
               end;
          end;
    end;
    StoredProc.Execute;
  end;
end;

{ TExecuteImportSettings }

class procedure TExecuteImportSettings.Execute(ImportSettings: TImportSettings);
var iFilesCount: Integer;
    saFound: TStrings;
    i: integer;
begin
  case ImportSettings.FileType of
    dtXLS, dtDBF, dtMMO: begin
        saFound := TStringList.Create;
        try
          // ���� ���������� ���, �� ����� ������������ ��������.
          if ImportSettings.Directory = '' then begin
             with {File}TOpenDialog.Create(nil) do
             try
               //InitialDir := InitializeDirectory;
               //DefaultExt := FFileExtension;
               if ImportSettings.FileType = dtXLS then
                  Filter := '*.xls';
               if Execute then begin
                  saFound.Add(FileName);
                  //InitializeDirectory := ExtractFilePath(FileName);
                  //Self.Open(FileName);
               end;
             finally
               Free;
             end;
          end
          else begin
            case ImportSettings.FileType of
               dtXLS: FilesInDir('*.xls', ImportSettings.Directory, iFilesCount, saFound, false);
               dtMMO: FilesInDir('*.mmo', ImportSettings.Directory, iFilesCount, saFound, false);
               dtDBF: FilesInDir('*.dbf', ImportSettings.Directory, iFilesCount, saFound, false);
            end;
          end;
          TStringList(saFound).Sort;
          for I := 0 to saFound.Count - 1 do
              with TExecuteProcedureFromExternalDataSet.Create(ImportSettings.FileType, saFound[i], ImportSettings) do
                try
                  // ���������
                  Load;
                  // ��������� � Archive
                  ForceDirectories(ExtractFilePath(saFound[i]) + cArchive);
                  RenameFile(saFound[i], ExtractFilePath(saFound[i]) + cArchive + '\' + FormatDateTime('yyyy_mm_dd_', Date) + ExtractFileName(saFound[i]));
                  if FileExists(saFound[i]) then
                     SysUtils.DeleteFile(saFound[i]);
                finally
                  Free;
                end;
        finally
          saFound.Free
        end;
    end;
    dtODBC: begin
              with TExecuteProcedureFromExternalDataSet.Create(ImportSettings.Directory, ImportSettings.Query, ImportSettings) do
                try
                  // ���������
                  Load;
                finally
                  Free;
                end;
    end;
  end;
end;

{ TImportSettings }

constructor TImportSettings.Create(ItemClass: TCollectionItemClass);
begin
  inherited;
  StoredProc := TdsdStoredProc.Create(nil);
end;

destructor TImportSettings.Destroy;
begin
  FreeAndNil(StoredProc);
  inherited;
end;

{ TImportSettingsFactory }

class function TImportSettingsFactory.CreateImportSettings(
  Id: integer): TImportSettings;
var
  GetStoredProc: TdsdStoredProc;
  FieldType: TFieldType;
begin
  GetStoredProc := TdsdStoredProc.Create(nil);
  GetStoredProc.OutputType := otResult;
  GetStoredProc.StoredProcName := 'gpGet_Object_ImportSettings';
  GetStoredProc.Params.AddParam('inId', ftInteger, ptInput, Id);

  GetStoredProc.Params.AddParam('StartRow', ftInteger, ptOutput, 0);
  GetStoredProc.Params.AddParam('HDR', ftBoolean, ptOutput, true);
  GetStoredProc.Params.AddParam('ContractId', ftInteger, ptOutput, 0);
  GetStoredProc.Params.AddParam('JuridicalId', ftInteger, ptOutput, 0);
  GetStoredProc.Params.AddParam('FileTypeName', ftString, ptOutput, '');
  GetStoredProc.Params.AddParam('ImportTypeName', ftString, ptOutput, '');
  GetStoredProc.Params.AddParam('Directory', ftString, ptOutput, '');
  GetStoredProc.Params.AddParam('ProcedureName', ftString, ptOutput, '');
  GetStoredProc.Params.AddParam('Query', ftString, ptOutput, '');

  GetStoredProc.Execute;
  {��������� ����������� ���������}
  Result := TImportSettings.Create(TImportSettingsItems);
  Result.StartRow := GetStoredProc.Params.ParamByName('StartRow').Value;
  Result.Directory := GetStoredProc.Params.ParamByName('Directory').Value;
  Result.FileType := GetFileType(GetStoredProc.Params.ParamByName('FileTypeName').Value);
  Result.JuridicalId := StrToIntDef(GetStoredProc.Params.ParamByName('JuridicalId').AsString, 0);
  Result.ContractId := StrToIntDef(GetStoredProc.Params.ParamByName('ContractId').AsString, 0);
  Result.HDR := GetStoredProc.Params.ParamByName('HDR').Value;
  Result.Query := GetStoredProc.Params.ParamByName('Query').Value;

  if Result.Directory = '' then begin
     Result.StoredProc.OutputType := otResult;
     Result.StoredProc.PackSize := 1;
  end
  else begin
     Result.StoredProc.OutputType := otMultiExecute;
     Result.StoredProc.PackSize := 100;
  end;

  Result.StoredProc.StoredProcName := GetStoredProc.Params.ParamByName('ProcedureName').Value;

  GetStoredProc.Params.Clear;
  {��������� ����������� ��������� ���������}
  GetStoredProc.StoredProcName := 'gpSelect_Object_ImportSettingsItems';
  GetStoredProc.Params.AddParam('inId', ftInteger, ptInput, Id);
  GetStoredProc.OutputType := otDataSet;
  GetStoredProc.DataSet := TClientDataSet.Create(nil);
  TClientDataSet(GetStoredProc.DataSet).IndexFieldNames := 'ParamNumber';
  GetStoredProc.Execute;

  with GetStoredProc.DataSet do begin
    Filtered := true;
    Filter := 'isErased <> true';
    while not EOF do begin
      FieldType := TFieldType(GetEnumValue(TypeInfo(TFieldType), FieldByName('ParamType').asString));
      with TImportSettingsItems(Result.Add) do begin
        ItemName := FieldByName('ParamValue').asString;
        if FieldByName('DefaultValue').AsString = '' then
           Param.Value := GetDefaultByFieldType(FieldType)
        else
           Param.Value := FieldByName('DefaultValue').AsString;
        Result.StoredProc.Params.AddParam(FieldByName('ParamName').asString, FieldType, ptInput, Param.Value);
      end;
      Next;
    end;
  end;

end;

class function TImportSettingsFactory.GetDefaultByFieldType(
  FieldType: TFieldType): OleVariant;
begin
  case FieldType of
    ftString: result := '';
    ftInteger, ftFloat: result := 0;
    ftBoolean: result := true;
    ftDateTime: result := Date;
  end;
end;

class function TImportSettingsFactory.GetImportSettings(
  Id: integer): TImportSettings;
begin
  result := CreateImportSettings(Id);
end;

{ TExecuteImportSettingsAction }

constructor TExecuteImportSettingsAction.Create(AOwner: TComponent);
begin
  inherited;
  FImportSettingsId := TdsdParam.Create(nil);
end;

destructor TExecuteImportSettingsAction.Destroy;
begin
  FreeAndNil(FImportSettingsId);
  inherited;
end;

function TExecuteImportSettingsAction.LocalExecute: boolean;
begin
  TExecuteImportSettings.Execute(TImportSettingsFactory.CreateImportSettings(ImportSettingsId.Value));
  result := true;
end;

{ TImportSettingsItems }

constructor TImportSettingsItems.Create(Collection: TCollection);
begin
  inherited;
  Param := TdsdParam.Create(nil);
end;

destructor TImportSettingsItems.Destroy;
begin
  FreeAndNil(Param);
  inherited;
end;

{ TODBCExternalLoad }

procedure TODBCExternalLoad.Activate;
begin
  inherited;
  FDataSet.Open;
end;

procedure TODBCExternalLoad.Close;
begin
  FDataSet.Close;
end;

constructor TODBCExternalLoad.Create;
begin
  FAdoConnection := TADOConnection.Create(nil);
end;

destructor TODBCExternalLoad.Destroy;
begin
  FreeAndNil(FAdoConnection);
  inherited;
end;

procedure TODBCExternalLoad.First;
begin
  inherited;
  FDataSet.First;
end;

procedure TODBCExternalLoad.Open(AConnection, ASQL: string);
begin
  FAdoConnection.ConnectionString := AConnection;
  FAdoConnection.LoginPrompt := false;
  FAdoConnection.Connected := true;
  FDataSet := TADOQuery.Create(nil);
  with FDataSet as TADOQuery do begin
    Connection := FAdoConnection;
    SQL.Text := ASQL;
  end;
end;

end.
