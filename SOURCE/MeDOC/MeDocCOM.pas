unit MeDocCOM;

{$I ..\dsdVer.inc}

interface

uses MEDOC_TLB, dsdAction, DB, Classes, dsdDB, DBClient
     {$IFDEF DELPHI103RIO}, Actions {$ENDIF};

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
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inContract', ftString, ptInput, '');
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inTotalSumm', ftFloat, ptInput, 0);
    FspUpdate_IsElectronFromMedoc.Params.AddParam('inMedocCharCode', ftString, ptInput, 0);
  end;

  FspInsertUpdate_MovementItem_TaxFromMedoc := TdsdStoredProc.Create(nil);
  with FspInsertUpdate_MovementItem_TaxFromMedoc do begin
     StoredProcName := 'gpInsertUpdate_MovementItem_TaxFromMedoc';
     OutputType := otResult;
     Params.AddParam('inMovementId', ftInteger, ptInput, 0);
     Params.AddParam('inGoodsName', ftString, ptInput, '');
     Params.AddParam('inMeasureName', ftString, ptInput, '');
     Params.AddParam('inAmount', ftFloat, ptInput, 0);
     Params.AddParam('inPrice', ftFloat, ptInput, 0);
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
          procedure AddToLog(S: string);
          var
            LogStr: string;
            LogFileName: string;
            LogFile: TextFile;
          begin
              Application.ProcessMessages;
              LogStr := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + S;
              LogFileName := ChangeFileExt(Application.ExeName, '') + '_' + FormatDateTime('yyyymmdd', Date) + '.log';

              AssignFile(LogFile, LogFileName);

              if FileExists(LogFileName) then
                Append(LogFile)
              else
                Rewrite(LogFile);

              Writeln(LogFile, LogStr);
              CloseFile(LogFile);
              Application.ProcessMessages;
          end;

var DocumentList: IZDataset;
    s_err, SEND_DPA: string;
    ii, ii_date, MovementId, MedocCode, FormCode: integer;
    MedocDocument: IZDocument;
    HeaderDataSet: IZDataset;
    LineDataSet: IZDataset;
    str1, DocKind, SEND_DPA_DATE: String;
begin
  with TMedocCOM.Create do
    try
      //if ParamStr(0) = '/log'
      //then
      //ShowMessage(' start ' + CharCode.Value);
      //
      // Получили список документов Медок
      DocumentList := GetDocumentList(CharCode.Value, StartOfTheMonth(PeriodDate.Value));
      //
      //AddToLog('------------');
      //AddToLog('CharCode.Value: ' + CharCode.Value);
      // Получили список документов из Project
      FSelect_Movement_TaxAll.ParamByName('inPeriodDate').Value := StartOfTheMonth(PeriodDate.Value);
      FSelect_Movement_TaxAll.Execute;
      FTaxBill.IndexFieldNames := 'MedocCode';
      with TGaugeFactory.GetGauge('Загрузка данных', 1, DocumentList.RecordCount) do begin
         Start;
         try
           while not DocumentList.Eof do begin
               MedocCode := DocumentList.Fields['CODE'].Value;
               //AddToLog('------------');
               //AddToLog('MedocCode: ' + IntToStr(MedocCode));
               //сначала проверяем, а не зарегистрировали мы ее УЖЕ
               if FTaxBill.Locate('MedocCode', MedocCode, []) then
                  if (FTaxBill.FieldByName('InvNumberRegistered').AsString <> '') then begin
                     Application.ProcessMessages;
                     //AddToLog('inInvNumberRegistered: ' + FTaxBill.FieldByName('InvNumberRegistered').AsString);
                     //AddToLog(' !!! next 1');
                     DocumentList.Next;
                     IncProgress;
                     Continue;
                  end;
               // Если НЕ зарегистрировали, только тогда открываем
               MedocDocument := pMedoc.OpenDocumentByCode(MedocCode, false);

               HeaderDataSet := MedocDocument.DataSets('', 0);
               SEND_DPA := HeaderDataSet.Fields['SEND_DPA'].Value;
               //
               //log
               {try
                 FormCode := DocumentList.Fields['FORM'].Value;
                 if  (FormCode <> 12943)
                   //and (FormCode <> 14025)
                   and (FormCode <> 14027)
                 then
                     //
                     if (FormCode = 11518) or (FormCode = 11530) or (FormCode = 12860) or (FormCode = 14025) or (FormCode = 16271) or (FormCode = 16325) or (FormCode = 19580) or (FormCode = 19583) or (FormCode = 20097) or (FormCode = 20100) or (FormCode = 21343) or (FormCode = 21340)
                     then
                       DocKind := 'Tax'
                     else
                       DocKind := 'TaxCorrective'
                  else DocKind := '???';
                 //
                 AddToLog('Open: SEND_DPA : ' + SEND_DPA);
                 AddToLog('FormCode : ' + IntToStr(FormCode) + ' - ' + DocKind);
                 AddToLog('inInvNumberRegistered - SEND_DPA_RN: ' + HeaderDataSet.Fields['SEND_DPA_RN'].Value);
                 AddToLog('inFromINN - FIRM_INN : ' + HeaderDataSet.Fields['FIRM_INN'].Value);
                 AddToLog('inToINN - N4 : ' + HeaderDataSet.Fields['N4'].Value);
                 if DocKind = 'Tax' then begin
for ii := 0 to HeaderDataSet.Fields.Count-1 do
   if HeaderDataSet.Fields[ii].Name = 'N11'
   then break;
ii_date:= ii;
                     AddToLog('inInvNumber - N2_11 : ' + HeaderDataSet.Fields['N2_11'].Value);
//                    AddToLog('inOperDate - N11 : ' + DateToStr(VarToDateTime(HeaderDataSet.Fields['N11'].Value)));
//                    AddToLog(IntToStr(ii_date));
//                    AddToLog(HeaderDataSet.Fields[ii].Name);
//                    AddToLog(HeaderDataSet.Fields[ii].Value);
                     AddToLog('inOperDate - <'+HeaderDataSet.Fields[ii_date].Name+'> : ' + DateToStr(VarToDateTime(HeaderDataSet.Fields[ii_date].Value)));
                     AddToLog('inBranchNumber - N2_13 : ' + HeaderDataSet.Fields['N2_13'].Value);
                     AddToLog('inContract - N81 : ' + HeaderDataSet.Fields['N81'].Value);
                     AddToLog('inTotalSumm - A7_11 :' + FloatToStr(HeaderDataSet.Fields['A7_11'].Value));
                 end
                 else
                 if DocKind = 'TaxCorrective'
                 then begin
for ii := 0 to HeaderDataSet.Fields.Count-1 do
   if HeaderDataSet.Fields[ii].Name = 'N15'
   then break;
ii_date:= ii;
                     AddToLog('inInvNumber - N1_11 : ' + HeaderDataSet.Fields['N1_11'].Value);
                   //AddToLog('inOperDate - N15 : <' + DateToStr(VarToDateTime(HeaderDataSet.Fields['N15'].Value)));
                     AddToLog('inOperDate - <'+HeaderDataSet.Fields[ii_date].Name+'> : <' + DateToStr(VarToDateTime(HeaderDataSet.Fields[ii_date].Value)));
                     AddToLog('inBranchNumber - N1_13 : ' + HeaderDataSet.Fields['N1_13'].Value);
                     AddToLog('inContract - N2_3 : ' + HeaderDataSet.Fields['N2_3'].Value);
                     AddToLog('inTotalSumm - A2_92 :' + FloatToStr(HeaderDataSet.Fields['A2_92'].Value));
                 end;
               except
                 on E: Exception do
                   AddToLog(' !!! err AddToLog : ' + E.Message);
               end;}
               //
               // Вставлена, но не зарегистрирована. Крутим цикл дальше
               if FTaxBill.Locate('MedocCode', MedocCode, []) and (SEND_DPA <> '12') then begin
                  Application.ProcessMessages;
                  //AddToLog(' !!! next 2');
                  DocumentList.Next;
                  IncProgress;
                  Continue;
               end;

str1:='';
for ii := 0 to HeaderDataSet.Fields.Count-1 do
begin
   if VarToStr(HeaderDataSet.Fields[ii].Value) = ''
   then str1:= str1 + HeaderDataSet.Fields[ii].Name
          + ' *** ' + 'NULL' + #10 + #13
   else str1:= str1 + HeaderDataSet.Fields[ii].Name
         + ' *** ' + VarToStr(HeaderDataSet.Fields[ii].Value)
         + #10 + #13;
end;

s_err:='';

if ParamStr(1) = 'FormCode' then
begin if (ParamStr(2) <> '')and (ParamStr(2) = HeaderDataSet.Fields['SEND_DPA_RN'].Value) then showMessage('(FormCode = ' + IntToStr(FormCode) + ') ' + HeaderDataSet.Fields['SEND_DPA_RN'].Value + ' : ' + str1)
      else if ParamStr(2) = '' then showMessage('(FormCode = ' + IntToStr(FormCode) + ') all : ' + str1);
end;

               if ((SEND_DPA = '12') or (SEND_DPA = '11')) then
               try
                  try s_err:='FormCode - FORM'; FormCode := DocumentList.Fields['FORM'].Value;s_err:=''; except raise end;
                  if  (FormCode <> 12943)
                   //and (FormCode <> 14025)
                   and (FormCode <> 14027)
                   //and (FormCode <> 21340)
                  then begin
                     //
                      if (FormCode = 11518) or (FormCode = 11530) or (FormCode = 12860) or (FormCode = 14025) or (FormCode = 16271) or (FormCode = 16325) or (FormCode = 19580) or (FormCode = 19583) or (FormCode = 20097) or (FormCode = 20100) or (FormCode = 21343) or (FormCode = 21340)
                         //01.04.2023
                       or (FormCode = 23005)or (FormCode = 23011)
                         //01.08.2023
                       or (FormCode = 23811) or (FormCode = 23814)
                         //01.10.2024
                       or (FormCode = 24868) or (FormCode = 24871)

                     then
                       DocKind := 'Tax'
                     else
                       DocKind := 'TaxCorrective';

                    with FspUpdate_IsElectronFromMedoc do begin

                      try s_err:='inMedocCODE - MedocCode'; ParamByName('inMedocCODE').Value := MedocCode; s_err:=''; except raise end;
                      try s_err:='inFromINN - FIRM_INN'; ParamByName('inFromINN').Value := HeaderDataSet.Fields['FIRM_INN'].Value; s_err:=''; except raise end;
                      try s_err:='inToINN - N4'; ParamByName('inToINN').Value := HeaderDataSet.Fields['N4'].Value; s_err:=''; except raise end;

                      if DocKind = 'Tax' then begin
for ii := 0 to HeaderDataSet.Fields.Count-1 do
   if HeaderDataSet.Fields[ii].Name = 'N11'
   then break;
ii_date:= ii;
                         try s_err:='inInvNumber - N2_11'; ParamByName('inInvNumber').Value := HeaderDataSet.Fields['N2_11'].Value; s_err:=''; except raise end;
                         try s_err:='inOperDate - '+HeaderDataSet.Fields[ii_date].Name + '('+IntToStr(ii_date)+')';
                             s_err:=s_err + ' (0) ';
                             s_err:=s_err + ' (1) ' + VarToStr(HeaderDataSet.Fields[ii_date].Value);
                             s_err:=s_err + ' (2) ' + DateToStr(VarToDateTime(HeaderDataSet.Fields[ii_date].Value));
                             ParamByName('inOperDate').Value := VarToDateTime(HeaderDataSet.Fields[ii_date].Value);
                             s_err:=''; except raise end;
                         try s_err:='inBranchNumber - N2_13'; ParamByName('inBranchNumber').Value := HeaderDataSet.Fields['N2_13'].Value; s_err:=''; except raise end;
                         try s_err:='inContract - N81'; ParamByName('inContract').Value := HeaderDataSet.Fields['N81'].Value; s_err:=''; except raise end;
                         try s_err:='inTotalSumm - A7_11'; ParamByName('inTotalSumm').Value := HeaderDataSet.Fields['A7_11'].Value; s_err:=''; except raise end;
                                                            {HeaderDataSet.Fields['A7_7'].Value +
                                                             HeaderDataSet.Fields['A7_8'].Value +
                                                             HeaderDataSet.Fields['A7_9'].Value;}
                      end
                      else begin
for ii := 0 to HeaderDataSet.Fields.Count-1 do
   if HeaderDataSet.Fields[ii].Name = 'N15'
   then break;
ii_date:= ii;
                         try s_err:='inInvNumber - N1_11'; ParamByName('inInvNumber').Value := HeaderDataSet.Fields['N1_11'].Value; s_err:=''; except raise end;
                         try s_err:='inOperDate - '+HeaderDataSet.Fields[ii_date].Name + '('+IntToStr(ii_date)+')'; ParamByName('inOperDate').Value := VarToDateTime(HeaderDataSet.Fields[ii_date].Value); s_err:=''; except raise end;
                         try s_err:='inBranchNumber - N1_13'; ParamByName('inBranchNumber').Value := HeaderDataSet.Fields['N1_13'].Value; s_err:=''; except raise end;
                         try s_err:='inContract - N2_3'; ParamByName('inContract').Value := HeaderDataSet.Fields['N2_3'].Value; s_err:=''; except raise end;
                         try s_err:='inTotalSumm - A2_92 + A1_9'; ParamByName('inTotalSumm').Value := HeaderDataSet.Fields['A2_92'].Value +
                                                                                                    + HeaderDataSet.Fields['A1_9'].Value; s_err:=''; except raise end;
                                                             {HeaderDataSet.Fields['A1_9'].Value +
                                                             HeaderDataSet.Fields['A1_10'].Value +
                                                             HeaderDataSet.Fields['A1_11'].Value +
                                                             HeaderDataSet.Fields['A2_9'].Value;}
                      end;

                      try s_err:='inInvNumberRegistered - SEND_DPA_RN'; ParamByName('inInvNumberRegistered').Value := HeaderDataSet.Fields['SEND_DPA_RN'].Value; s_err:=''; except raise end;
                      try s_err:='SEND_DPA_DATE - SEND_DPA_DATE'; SEND_DPA_DATE := HeaderDataSet.Fields['SEND_DPA_DATE'].Value; s_err:=''; except raise end;
                      if SEND_DPA_DATE <> '' then
                         try s_err:='inDateRegistered:= '+ SEND_DPA_DATE; ParamByName('inDateRegistered').Value := VarToDateTime(SEND_DPA_DATE); s_err:=''; except raise end
                      else
                         ParamByName('inDateRegistered').Value := Date;
                      ParamByName('inDocKind').Value := DocKind;
                      ParamByName('inMedocCharCode').Value := CharCode.Value;

                      //try s_err:='Execute'; Execute; s_err:=''; except raise;end;

                      try s_err:='Execute ';
                          Execute;
                          s_err:='';
                      except ON E:Exception do
                      Begin
                           s_err:=s_err + E.Message;
                           raise;
                      end;
                      end;

                    end;

                    if FspUpdate_IsElectronFromMedoc.ParamByName('outId').AsString <> '0' then
                    begin
                       MovementId := FspUpdate_IsElectronFromMedoc.ParamByName('outId').Value;
                       try s_err:='LineDataSet - TAB1'; LineDataSet := MedocDocument.DataSets('TAB1', 0); s_err:=''; except raise end;
                       while not LineDataSet.EOF do
                         with FspInsertUpdate_MovementItem_TaxFromMedoc do begin
                           ParamByName('inMovementId').Value := MovementId;
                           if DocKind = 'Tax' then begin
                              try s_err:='inGoodsName - TAB1_A13'; ParamByName('inGoodsName').Value := LineDataSet.Fields['TAB1_A13'].Value; s_err:=''; except raise end;
                              try s_err:='inMeasureName - TAB1_A14'; ParamByName('inMeasureName').Value := LineDataSet.Fields['TAB1_A14'].Value; s_err:=''; except raise end;
                              try s_err:='inAmount - TAB1_A15'; ParamByName('inAmount').Value := LineDataSet.Fields['TAB1_A15'].Value; s_err:=''; except raise end;
                              try s_err:='inPrice - TAB1_A16'; ParamByName('inPrice').Value := LineDataSet.Fields['TAB1_A16'].Value; s_err:=''; except raise end;
                           end
                           else begin
                              try s_err:='inGoodsName - TAB1_A3'; ParamByName('inGoodsName').Value := LineDataSet.Fields['TAB1_A3'].Value; s_err:=''; except raise end;
                              try s_err:='inMeasureName - TAB1_A4'; ParamByName('inMeasureName').Value := LineDataSet.Fields['TAB1_A4'].Value; s_err:=''; except raise end;
                              try s_err:='inAmount - TAB1_A5'; ParamByName('inAmount').Value := - (LineDataSet.Fields['TAB1_A5'].Value + LineDataSet.Fields['TAB1_A8'].Value); s_err:=''; except raise end;
                              try s_err:='inPrice - TAB1_A6'; ParamByName('inPrice').Value := (LineDataSet.Fields['TAB1_A6'].Value + LineDataSet.Fields['TAB1_A7'].Value); s_err:=''; except raise end;
                           end;
                           try s_err:='Execute - 2'; Execute; s_err:=''; except raise end;
                           try s_err:='LineDataSet.Next'; LineDataSet.Next; s_err:=''; except raise end;
                         end;
                    end;
                  end; // if FormCode <> 0
               except
                     raise Exception.Create('FormCode  ' + IntToStr(FormCode) + #10 + #13 + 's_err  ' + s_err + #10 + #13 + str1);
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
    //
    ShowMessage(' end ' + CharCode.Value);

end;

initialization

  RegisterClass(TMedocComAction);

end.
