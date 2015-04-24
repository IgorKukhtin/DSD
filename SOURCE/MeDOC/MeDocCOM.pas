unit MeDocCOM;

interface

uses MEDOC_TLB, dsdAction, DB, Classes, dsdDB, DBClient;

type
  TMedocCOM = class
  private
    pMedoc: IZApplication;
  public
    constructor Create;
    function GetDocumentList(CharCode: string; PeriodDate: TDateTime): IZDataset;
  end;

  TMedocComAction = class(TdsdCustomAction)
  private
    FPeriodDate: TdsdParam;
    FCharCode: TdsdParam;
    FspUpdate_IsElectronFromMedoc: TdsdStoredProc;
    FspInsertUpdate_MovementItem_TaxFromMedoc: TdsdStoredProc;
    FSelect_Movement_TaxAll: TdsdStoredProc;
    FTaxBill: TClientDataSet;
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

{function TMedocCOM.GetDocumentByCode(Code, FORM: integer): TParams;
var Doc: IZDocument;
    DocDataSet: IZDataset;
begin
  result := TParams.Create(nil);
  Doc := pMedoc.OpenDocumentByCode(Code, false);
  Doc.DisableScripts();

  result.CreateParam(ftVariant, 'FORM', ptInput).Value := FORM;

  DocDataSet := Doc.DataSets('', 0);
  if not DocDataSet.Eof then
  begin
     result.CreateParam(ftVariant, 'SEND_DPA', ptInput).Value := DocDataSet.Fields.Item['SEND_DPA'].Value;
     result.CreateParam(ftVariant, 'SEND_DPA_RN', ptInput).Value := DocDataSet.Fields.Item['SEND_DPA_RN'].Value;
     result.CreateParam(ftVariant, 'SEND_DPA_DATE', ptInput).Value := DocDataSet.Fields.Item['SEND_DPA_DATE'].Value;

     result.CreateParam(ftVariant, 'FIRM_INN', ptInput).Value := DocDataSet.Fields.Item['FIRM_INN'].Value;
     result.CreateParam(ftVariant, 'N4', ptInput).Value := DocDataSet.Fields.Item['N4'].Value;
     if (FORM = 11518) or (FORM = 11530) then
     begin
       result.CreateParam(ftVariant, 'InvNumber', ptInput).Value := DocDataSet.Fields.Item['N2_11'].Value;
       result.CreateParam(ftVariant, 'OperDate', ptInput).Value := DocDataSet.Fields.Item['N11'].Value;
       result.CreateParam(ftVariant, 'BranchNumber', ptInput).Value := DocDataSet.Fields.Item['N2_13'].Value;
       result.CreateParam(ftVariant, 'DocKind', ptInput).Value := 'Tax';
     end
     else
     begin
       result.CreateParam(ftVariant, 'InvNumber', ptInput).Value := DocDataSet.Fields.Item['N1_11'].Value;
       result.CreateParam(ftVariant, 'OperDate', ptInput).Value := DocDataSet.Fields.Item['N15'].Value;
       result.CreateParam(ftVariant, 'BranchNumber', ptInput).Value := DocDataSet.Fields.Item['N1_13'].Value;
       result.CreateParam(ftVariant, 'DocKind', ptInput).Value := 'TaxCorrective';
     end;
  end;
end; }

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
  with FspUpdate_IsElectronFromMedoc do begin
    FspUpdate_IsElectronFromMedoc.StoredProcName := 'gpUpdate_IsElectronFromMedoc';
    FspUpdate_IsElectronFromMedoc.OutputType := otResult;
    FspUpdate_IsElectronFromMedoc.Params.AddParam('outId', ftInteger, ptOutput, 0);
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inMedocCode', ftInteger, ptInput, '');
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inFromINN', ftString, ptInput, '');
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inToINN', ftString, ptInput, '');
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inInvNumber', ftString, ptInput, '');
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inOperDate', ftDateTime, ptInput, Date);
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inBranchNumber', ftString, ptInput, '');
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inInvNumberRegistered', ftString, ptInput, '');
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inDateRegistered', ftDateTime, ptInput, '');
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inDocKind', ftString, ptInput, '');
  end;

  FspInsertUpdate_MovementItem_TaxFromMedoc := TdsdStoredProc.Create(nil);
  with FspInsertUpdate_MovementItem_TaxFromMedoc do begin
     StoredProcName := 'gpInsertUpdate_MovementItem_TaxFromMedoc';
     OutputType := otResult;
     Params.AddParam('inMovementId', ftInteger, ptInput, 0);
     Params.AddParam('inGoodsName', ftString, ptInput, '');
     Params.AddParam('inMeasureName', ftString, ptInput, '');
     Params.AddParam('inAmount', ftFloat, ptInput, 0);
     Params.AddParam('inSumm', ftFloat, ptInput, 0);
  end;

  FTaxBill := TClientDataSet.Create(nil);

  FSelect_Movement_TaxAll := TdsdStoredProc.Create(nil);
  with FSelect_Movement_TaxAll do begin
     StoredProcName := 'gpSelect_Movement_TaxAll';
     OutputType := otDataSet;
     DataSet := FTaxBill;
     Params.AddParam('inPeriodDate', ftDateTime, ptInput, Date);
  end;
end;

destructor TMedocComAction.Destroy;
begin
  FreeAndNil(FPeriodDate);
  FreeAndNil(FCharCode);
  FreeAndNil(FspUpdate_IsElectronFromMedoc);
  FreeAndNil(FspInsertUpdate_MovementItem_TaxFromMedoc);
  FreeAndNil(FTaxBill);
  FreeAndNil(FSelect_Movement_TaxAll);
  inherited;
end;

function TMedocComAction.LocalExecute: boolean;
var DocumentList: IZDataset;
    s, SEND_DPA: string;
    i, MovementId, MedocCode, FormCode: integer;
    MedocDocument: IZDocument;
    HeaderDataSet: IZDataset;
    LineDataSet: IZDataset;
    DocKind, SEND_DPA_DATE: String;
begin
  with TMedocCOM.Create do
    try
      // Получили список документов Медок
      DocumentList := GetDocumentList(CharCode.Value, StartOfTheMonth(PeriodDate.Value));
      // Получили список документов из Project
      FSelect_Movement_TaxAll.ParamByName('inPeriodDate').Value := StartOfTheMonth(PeriodDate.Value);
      FSelect_Movement_TaxAll.Execute;
      FTaxBill.IndexFieldNames := 'MedocCode';
      with TGaugeFactory.GetGauge('Загрузка данных', 1, DocumentList.RecordCount) do begin
         Start;
         try
           while not DocumentList.Eof do begin
               MedocCode := DocumentList.Fields['CODE'].Value;
               //сначала проверяем, а не зарегистрировали мы ее УЖЕ
               if FTaxBill.Locate('MedocCode', MedocCode, []) then
                  if FTaxBill.FieldByName('InvNumberRegistered').AsString <> '' then begin
                     Application.ProcessMessages;
                     DocumentList.Next;
                     IncProgress;
                     Continue;
                  end;
               // Если НЕ зарегистрировали, только тогда открываем
               MedocDocument := pMedoc.OpenDocumentByCode(MedocCode, false);

               HeaderDataSet := MedocDocument.DataSets('', 0);
               SEND_DPA := HeaderDataSet.Fields['SEND_DPA'].Value;
               // Вставлена, но не зарегистрирована. Крутим цикл дальше
               if FTaxBill.Locate('MedocCode', MedocCode, []) and (SEND_DPA <> '12') then begin
                  Application.ProcessMessages;
                  DocumentList.Next;
                  IncProgress;
                  Continue;
               end;

               if (SEND_DPA = '12') or (SEND_DPA = '11') then begin
                  FormCode := DocumentList.Fields['FORM'].Value;
                  if (FormCode = 11518) or (FormCode = 11530) then
                     DocKind := 'Tax'
                  else
                     DocKind := 'TaxCorrective';
                  with FspUpdate_IsElectronFromMedoc do begin
                    ParamByName('inMedocCODE').Value := MedocCode;
                    ParamByName('inFromINN').Value := HeaderDataSet.Fields['FIRM_INN'].Value;
                    ParamByName('inToINN').Value := HeaderDataSet.Fields['N4'].Value;
                    if DocKind = 'Tax' then begin
                       ParamByName('inInvNumber').Value := HeaderDataSet.Fields['N2_11'].Value;
                       ParamByName('inOperDate').Value := VarToDateTime(HeaderDataSet.Fields['N11'].Value);
                       ParamByName('inBranchNumber').Value := HeaderDataSet.Fields['N2_13'].Value;
                    end
                    else begin
                       ParamByName('inInvNumber').Value := HeaderDataSet.Fields['N1_11'].Value;
                       ParamByName('inOperDate').Value := VarToDateTime(HeaderDataSet.Fields['N15'].Value);
                       ParamByName('inBranchNumber').Value := HeaderDataSet.Fields['N1_13'].Value;
                    end;
                    ParamByName('inInvNumberRegistered').Value := HeaderDataSet.Fields['SEND_DPA_RN'].Value;
                    SEND_DPA_DATE := HeaderDataSet.Fields['SEND_DPA_DATE'].Value;
                    if SEND_DPA_DATE <> '' then
                       ParamByName('inDateRegistered').Value := VarToDateTime(SEND_DPA_DATE)
                    else
                       ParamByName('inDateRegistered').Value := Date;
                    ParamByName('inDocKind').Value := DocKind;
                    Execute;
                  end;
                  if FspUpdate_IsElectronFromMedoc.ParamByName('outId').AsString <> '0' then begin
                     MovementId := FspUpdate_IsElectronFromMedoc.ParamByName('outId').Value;
                     LineDataSet := MedocDocument.DataSets('TAB1', 0);
                     while not LineDataSet.EOF do
                       with FspInsertUpdate_MovementItem_TaxFromMedoc do begin
                         ParamByName('inMovementId').Value := MovementId;
                         if DocKind = 'Tax' then begin
                            ParamByName('inGoodsName').Value := LineDataSet.Fields['TAB1_A13'].Value;
                            ParamByName('inMeasureName').Value := LineDataSet.Fields['TAB1_A14'].Value;
                            ParamByName('inAmount').Value := LineDataSet.Fields['TAB1_A15'].Value;
                            ParamByName('inSumm').Value := LineDataSet.Fields['TAB1_A17'].Value;
                         end
                         else begin
                            ParamByName('inGoodsName').Value := LineDataSet.Fields['TAB1_A3'].Value;
                            ParamByName('inMeasureName').Value := LineDataSet.Fields['TAB1_A4'].Value;
                            ParamByName('inAmount').Value := - LineDataSet.Fields['TAB1_A5'].Value;
                            ParamByName('inSumm').Value := - LineDataSet.Fields['TAB1_A9'].Value;
                         end;
                         Execute;
                         LineDataSet.Next;
                       end;
                  end;
               end;
               Application.ProcessMessages;
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
