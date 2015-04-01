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
    {FspUpdate_IsElectronFromMedoc

    CREATE OR REPLACE FUNCTION gpUpdate_IsElectronFromMedoc(
    IN inOurOKPO             TVarChar   , -- наш ОКПО
    IN inFirmOKPO            TVarChar   , -- их ОКПО
    IN inInvNumber           TVarChar   , -- Номер
    IN inOperDate            TDateTime  , -- Дата
    IN inDocKind             TVarChar   , -- Тип документа
    IN inSession             TVarChar     -- Пользователь
)    }

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

implementation
uses ComObj, SysUtils, SimpleGauge;

{ TMedocCOM }

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
    i: integer;
begin
  result := TParams.Create(nil);
  Doc := pMedoc.OpenDocumentByCode(Code, false);
  DocDataSet := Doc.Card;
  if not DocDataSet.Eof then
     for I := 0 to DocDataSet.Fields.Count - 1 do
         result.CreateParam(ftVariant, DocDataSet.Fields.Item[i].Name, ptInput).Value := DocDataSet.Fields.Item[i].Value;

  DocDataSet := Doc.DataSets('', 0);
  if not DocDataSet.Eof then
     for I := 0 to DocDataSet.Fields.Count - 1 do
         result.CreateParam(ftVariant, DocDataSet.Fields.Item[i].Name, ptInput).Value := DocDataSet.Fields.Item[i].Value;
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
end;

destructor TMedocComAction.Destroy;
begin
  FreeAndNil(FPeriodDate);
  FreeAndNil(FCharCode);
  inherited;
end;

function TMedocComAction.LocalExecute: boolean;
var DocumentList: IZDataset;
    DocumentParam: TParams;
begin
  with TMedocCOM.Create do
    try
      // Получили список документов
      DocumentList := GetDocumentList(CharCode.Value, PeriodDate.Value);
      with TGaugeFactory.GetGauge('Загрузка данных', 1, DocumentList.RecordCount) do begin
         Start;
         try
           while not DocumentList.Eof do begin
             DocumentParam := GetDocumentByCode(DocumentList.Fields.Item['CODE'].Value);
             try
               if DocumentParam.ParamByName('REGDATE').asString <> '' then begin
                   // TAX
                  //FIRM_EDRPOU = Наш ОКПО
                  //EDR_POK = Их ОКПО
                  // N2_1 - номер документа
                  //N11 - дата документа
                  // FORM = 11530

                  // TAXCorrective
                  //FIRM_EDRPOU = Наш ОКПО
                  //EDR_POK = Их ОКПО
                  //N1_11 = 5555 номер документа
                  //N15 = Дата доумента
                  //FORM = 11531

               end;
             (*CODE = 299513;IDORG = 779;PERTYPE = 0;PERDATE = 01.03.2015;
             FORM = 11530;NUM = 0;CARDYEAR = 2015;ACTCD = 0;FORMVER = 0;
             CHKDATE = ;STATUS = 2;UM = 1;CTRLSUM = 2134138811;PRINTED = 0;
             CRTDATE = 30.03.2015 16:21:13;CRTUSER = 0;
             IMPDATE = ;IMPUSER = 0;IMPINS = 0;
             MODDATE = 30.03.2015 16:22:42;
             MODUSER = 0;FLAGS = 0;REGDATE = ;
             DELETED = 0;CONSOLED = 0;
             PACKRCD = 0;DOUBTLEV = 0;
             DOCID = 1B420A2E-CFD8-498C-A3DA-5DAA6727AC22;
             IDREPCODE = 0;ISSUM = 0;
             DATEEND = 01.03.2015;
             DATEBEG = 01.03.2015;NINPER = 0;
             NINPERU = 0;DPACD = ;EDRPOU = 5678566677;
             DOCRNS = ;
             DOCNAME = Податкова накладна  №5656567 від 30.03.2015;
             OLDPARAM = 0;FLAGTRANSM = 0;SENDSTATUS = 0;
             NCTRLSUM = 3260831787;ZSTATUS = 0;ZPIDSTAVA = ;
             DOCRNN = 0;DATECHANGED = 30.03.2015 16:21:13;
             CARDINFO = ;CHECKACTNUM = ;CHECKACTDATE = ;
             DATETIMECHANGED = ;IMPDATETIME = ;MODDATETIME = ;CHKDATETIME = ;
             CRTDATETIME = ;PRMMODUSER = 0;DUMMY_CODE = 0;DOCNUM = ;
             NONCMPL = 0;SENDSTT = 12;CARDCOMMENT = ;XMLVALS = ;IDPARENT = 0;
             FLOWSTT = 32767;MOVETYPE = 0;PACKPRNT = 0;NOTES = 2651;
             INTRASHDATE = ;DOC_OUTID = ;PRNQRYSTT = 0;GRPID = ;PDFEXPSTT = 0;
             A110 = 0;A111 = 0;A17 = 0;A18 = 0;A19 = 0;A2_10 = 0;A2_11 = 0;
             A2_4 = ;A2_5 = 0;A2_6 = 0;A2_7 = 0;A2_8 = 0;A2_9 = 0;A3_11 = 0;
             A4_10 = 0;A4_101 = 0;A4_11 = 0;A4_111 = 0;A4_4 = ;A4_41 = ;A4_5 = ;
             A4_51 = ;A4_6 = 0;A4_61 = 0;A4_7 = 0;A4_71 = 0;A4_8 = 0;A4_81 = 0;
             A4_9 = 0;A4_91 = 0;A5_10 = 0;A5_11 = 160;A5_7 = 160;A5_71 = 0;
             A5_8 = 0;A5_9 = 0;A6_10 = ;A6_11 = 32;A6_7 = 32;A6_71 = 0;A6_8 = 0;
             A6_9 = 0;A7_10 = 0;A7_11 = 192;A7_7 = 192;A7_71 = 0;A7_8 = 0;
             A7_9 = 0;CARDCODE = 299513;CODE = 299513;DEPT_POK = ;
             EDR_POK = 65856657;FIRM_ADR = Ленина, М.КИЇВ обл., 00000;
             FIRM_CITYCD = ;FIRM_EDRPOU = 5678566677;FIRM_INN = 65785786;
             FIRM_NAME = Кухтин;FIRM_PHON = ;FIRM_SRPNDS = ;FIRM_STFOND = 0;
             FIRM_TELORG = ;GETDOCPRINT = ;GOVQRYCODE = 0;IDORG = 779;N1 = ;
             N10 = Кухтин;N11 = 30.03.2015;N12 = 0;N13 = 0;N14 = ;N15 = ;
             N16 = ;N17 = 0;N18 = 0;N19 = 1;N2 = ;N20 = 0;N21 = 0;
             N2_1 = 5656567;N2_11 = 5656567;N2_12 = 0;N2_13 = ;
             N2_1I = 5656567;N2_2 = ;N3 = ООО ПЕД;N4 = 123456789;N5 = ;
             N6 = ;N7 = 89958905;N8 = ;N81 = ;N811 = ;N812 = ;N82 = ;N9 = ;
             NAKL_TYPE = 1;PHON = ;PKRED = 0;PZOB = 0;RECNO = 0;REP_KS = 3260831787;
             RSTCODE = 0;RSTTYPE = 0;SENDER = ;SEND_DPA = 0;SEND_DPA_DATE = ;
             SEND_DPA_RN = ;SEND_PERSON = 0;SEND_PERSON_DATE = ;SIGNERINFO = ;
             SN = №5656567;STYPE = ;Z1_5 = 0;Z1_6 = 0;Z2_5 = 0;Z2_6 = 0;
             Z3_5 = 0;Z4_5 = 0;Z5_5 = 0;Z5_6 = 0;Z6_5 = 0;Z6_6 = 0;Z7_5 = 0;
             Z7_6 = 0;ZT = ;*)
               //if DocumentParam then
(*

GetOneTaxCorrectiveMedocDocument: ETestFailure
at  $01363014
CODE = 299514;IDORG = 779;PERTYPE = 0;PERDATE = 01.03.2015;FORM = 11531;NUM = 0;
CARDYEAR = 2015;ACTCD = 0;FORMVER = 0;CHKDATE = ;STATUS = 2;UM = 1;CTRLSUM = 1740530526;
PRINTED = 0;CRTDATE = 31.03.2015 16:56:05;CRTUSER = 0;IMPDATE = ;IMPUSER = 0;IMPINS = 0;
MODDATE = 31.03.2015 16:57:55;MODUSER = 0;FLAGS = 0;REGDATE = ;DELETED = 0;CONSOLED = 0;
PACKRCD = 0;DOUBTLEV = 0;DOCID = C5EE2235-A192-43AC-AA27-E1620080F6F7;IDREPCODE = 0;
ISSUM = 0;DATEEND = 01.03.2015;DATEBEG = 01.03.2015;NINPER = 0;NINPERU = 0;DPACD = ;
EDRPOU = 999999999;DOCRNS = ;DOCNAME = Додаток №2 № 5555 від 25.03.2015;OLDPARAM = 0;
FLAGTRANSM = 0;SENDSTATUS = 0;NCTRLSUM = 2377740527;ZSTATUS = 0;ZPIDSTAVA = ;DOCRNN = 0;
DATECHANGED = 31.03.2015 16:56:05;CARDINFO = ;CHECKACTNUM = ;CHECKACTDATE = ;
DATETIMECHANGED = ;IMPDATETIME = ;MODDATETIME = ;CHKDATETIME = ;CRTDATETIME = ;
PRMMODUSER = 0;DUMMY_CODE = 0;DOCNUM = ;NONCMPL = 0;SENDSTT = 0;CARDCOMMENT = ;
XMLVALS = ;IDPARENT = 0;FLOWSTT = 32767;MOVETYPE = 0;PACKPRNT = 0;NOTES = 2651;
INTRASHDATE = ;DOC_OUTID = ;PRNQRYSTT = 0;GRPID = ;PDFEXPSTT = 0;A1_10 = 0;A1_11 = 0;
A1_12 = 0;A1_14 = 0;A1_9 = 0;A1_91 = 0;A2_4 = ;A2_5 = ;A2_9 = 0;A2_91 = 0;
CARDCODE = 299514;CODE = 299514;DEPT_POK = ;EDR_POK = 65856657;
FIRM_ADR = Ленина, М.КИЇВ обл., 00000;FIRM_CITYCD = ;FIRM_EDRPOU = 999999999;
FIRM_INN = 56565656;FIRM_NAME = Кухтин;FIRM_PHON = ;FIRM_SRPNDS = ;FIRM_TELORG = ;
GETDOCPRINT = ;GOVQRYCODE = 0;IDORG = 779;K1 = ;K2 = ;K3 = ;N1 = 5555;
N10 = Кухтин;N11 = ;N12 = ;N13 = ;N14 = 1;N15 = 25.03.2015;N16 = 0;N17 = 0;
N18 = ;N19 = 0;N1I = 5555;N1_11 = 5555;N1_12 = 0;N1_13 = ;N2 = 21.03.2015;N20 = 0;
N21 = 0;N22 = 0;N23 = 0;N2_1 = 5656567;N2_11 = 5656567;N2_12 = 0;N2_13 = ;N2_2 = ;
N2_3 = ;N3 = ООО ПЕД;N4 = 123456789;N5 = ;N6 = ;N7 = 89958905;N8 = ;N81 = ;N811 = ;
N812 = ;N82 = ;N9 = ;NAKL_TYPE = 1;PHON = ;PKRED = 0;PZOB = 0;RATE = ;RECNO = 0;
REP_KS = 2377740527;RSTCODE = 0;RSTTYPE = 0;SENDER = ;SEND_DPA = 0;SEND_DPA_DATE = ;
SEND_DPA_RN = ;SEND_PERSON = 0;SEND_PERSON_DATE = ;SIGNERINFO = ;*)
             finally
               FreeAndNil(DocumentParam);
             end;
             DocumentList.Next;
             IncProgress;
           end;
         finally
           Finish
         end;
      end;
    finally
      Free;
    end;
  //
  //
end;

end.
