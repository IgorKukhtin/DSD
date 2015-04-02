unit MeDocCOM;

interface

uses MEDOC_TLB, dsdAction, DB, Classes, dsdDB;

type
  TMedocCOM = class
  private
    pMedoc: IZApplication;
  public
    constructor Create;
    function GetDocumentList(CharCode: string; PeriodDate: TDateTime): IZDataset;
    function GetDocumentByCode(Code: integer): TParams;
  end;

  TMedocComAction = class(TdsdCustomAction)
  private
    FPeriodDate: TdsdParam;
    FCharCode: TdsdParam;
    FspUpdate_IsElectronFromMedoc: TdsdStoredProc;
  protected
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property PeriodDate: TdsdParam read FPeriodDate write FPeriodDate;
    property CharCode: TdsdParam read FCharCode write FCharCode;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
  end;

  procedure Register;


implementation
uses VCL.ActnList, ComObj, SysUtils, SimpleGauge, Variants, DateUtils, Log,
     Dialogs, Forms;

{ TMedocCOM }

procedure Register;
begin
  RegisterActions('TaxLib', [TMedocComAction], TMedocComAction);
end;

constructor TMedocCOM.Create;
begin
  try
    pMedoc := CreateOleObject('MEDOC.ZApplication') AS IZApplication;
  except
    on E: EOleSysError do begin
       if Pos('MEDOC.ZApplication', E.Message) > 0 then
          raise Exception.Create('Необходимо войти в программу M.E.DOC')
       else
          raise E;
    end;
    on E: Exception do
       raise E;
  end;
end;

function TMedocCOM.GetDocumentByCode(Code: integer): TParams;
var Doc: IZDocument;
    DocDataSet: IZDataset;
    FORM: integer;
begin
  result := TParams.Create(nil);
  Doc := pMedoc.OpenDocumentByCode(Code, false);
  DocDataSet := Doc.Card;
  if not DocDataSet.Eof then begin
     FORM := DocDataSet.Fields.Item['FORM'].Value;
     result.CreateParam(ftVariant, 'FORM', ptInput).Value := FORM;

  end;

  DocDataSet := Doc.DataSets('', 0);
  if not DocDataSet.Eof then
  begin
     result.CreateParam(ftVariant, 'SEND_DPA', ptInput).Value := DocDataSet.Fields.Item['SEND_DPA'].Value;
     result.CreateParam(ftVariant, 'SEND_DPA_RN', ptInput).Value := DocDataSet.Fields.Item['SEND_DPA_RN'].Value;

     result.CreateParam(ftVariant, 'FIRM_INN', ptInput).Value := DocDataSet.Fields.Item['FIRM_INN'].Value;
     result.CreateParam(ftVariant, 'N4', ptInput).Value := DocDataSet.Fields.Item['N4'].Value;
     if (FORM = 11518) or (FORM = 11530) then
     begin
       result.CreateParam(ftVariant, 'N2_11', ptInput).Value := DocDataSet.Fields.Item['N2_11'].Value;
       result.CreateParam(ftVariant, 'N11', ptInput).Value := DocDataSet.Fields.Item['N11'].Value;
     end
     else
     begin
       result.CreateParam(ftVariant, 'N1_11', ptInput).Value := DocDataSet.Fields.Item['N1_11'].Value;
       result.CreateParam(ftVariant, 'N15', ptInput).Value := DocDataSet.Fields.Item['N15'].Value;
     end;
  end;
end;

function TMedocCOM.GetDocumentList(CharCode: string; PeriodDate: TDateTime): IZDataset;
begin
  result := pMedoc.DocumentsDataSet('PERDATE=''' + DateToStr(PeriodDate) +  '''' + ' AND CHARCODE=''' + CharCode + '''', false);
end;

{ TMedocComAction }

constructor TMedocComAction.Create(AOwner: TComponent);
begin
  inherited;
  FPeriodDate := TdsdParam.Create(nil);
  FCharCode := TdsdParam.Create(nil);
  FspUpdate_IsElectronFromMedoc := TdsdStoredProc.Create(nil);
  FspUpdate_IsElectronFromMedoc.StoredProcName := 'gpUpdate_IsElectronFromMedoc';
  FspUpdate_IsElectronFromMedoc.OutputType := otResult;
  FspUpdate_IsElectronFromMedoc.Params.AddParam('inFromINN', ftString, ptInput, '');
  FspUpdate_IsElectronFromMedoc.Params.AddParam('inToINN', ftString, ptInput, '');
  FspUpdate_IsElectronFromMedoc.Params.AddParam('inInvNumber', ftString, ptInput, '');
  FspUpdate_IsElectronFromMedoc.Params.AddParam('inOperDate', ftDateTime, ptInput, Date);
  FspUpdate_IsElectronFromMedoc.Params.AddParam('inDocKind', ftString, ptInput, '');
end;

destructor TMedocComAction.Destroy;
begin
  FreeAndNil(FPeriodDate);
  FreeAndNil(FCharCode);
  FreeAndNil(FspUpdate_IsElectronFromMedoc);
  inherited;
end;

function TMedocComAction.LocalExecute: boolean;
var DocumentList: IZDataset;
    DocumentParam: TParams;
    s: string;
    i: integer;
begin
  with TMedocCOM.Create do
    try
      // Получили список документов
      DocumentList := GetDocumentList(CharCode.Value, StartOfTheMonth(PeriodDate.Value));
      with TGaugeFactory.GetGauge('Загрузка данных', 1, DocumentList.RecordCount) do begin
         Start;
         try
           while not DocumentList.Eof do begin
             DocumentParam := GetDocumentByCode(DocumentList.Fields.Item['CODE'].Value);
             s := '';
             for I := 0 to DocumentParam.Count - 1 do
                  s := s + DocumentParam[i].Name + ' = ' + DocumentParam[i].AsString + ';';
             Logger.AddToLog(s);
//             showMessage(s);
             try
               if (DocumentParam.ParamByName('SEND_DPA').asString = '12') and (DocumentParam.ParamByName('SEND_DPA_RN').asString <> '') then begin

                  FspUpdate_IsElectronFromMedoc.ParamByName('inFromINN').Value := DocumentParam.ParamByName('FIRM_INN').asString;
                  FspUpdate_IsElectronFromMedoc.ParamByName('inToINN').Value := DocumentParam.ParamByName('N4').asString;

                  if (DocumentParam.ParamByName('FORM').asString = '11530') or (DocumentParam.ParamByName('FORM').asString = '11518') then
                  begin
                     FspUpdate_IsElectronFromMedoc.ParamByName('inInvNumber').Value := DocumentParam.ParamByName('N2_11').asString;
                     FspUpdate_IsElectronFromMedoc.ParamByName('inOperDate').Value := VarToDateTime(DocumentParam.ParamByName('N11').asString);
                     FspUpdate_IsElectronFromMedoc.ParamByName('inDocKind').Value := 'Tax';
                  end
                  else
                  begin
                     FspUpdate_IsElectronFromMedoc.ParamByName('inInvNumber').Value := DocumentParam.ParamByName('N1_11').asString;
                     FspUpdate_IsElectronFromMedoc.ParamByName('inOperDate').Value := VarToDateTime(DocumentParam.ParamByName('N15').asString);
                     FspUpdate_IsElectronFromMedoc.ParamByName('inDocKind').Value := 'TaxCorrective';
                  end;

                  FspUpdate_IsElectronFromMedoc.Execute;
                  Application.ProcessMessages;
               end;
             finally
               FreeAndNil(DocumentParam);
             end;
             DocumentList.Next;
             IncProgress;
           end;
           result := true;
         finally
           Finish
         end;
      end;
    finally
      Free;
    end;
end;

initialization

  RegisterClass(TMedocComAction);

end.
