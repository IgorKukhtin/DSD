-- Function: gpInsertUpdate_1CSaleLoad()

DROP FUNCTION IF EXISTS gpDelete_1CSale(TVarChar);
DROP FUNCTION IF EXISTS gpDelete_1CSale(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_1CSale(
    IN inStartDate           TDateTime  , -- Начальная дата переноса
    IN inEndDate             TDateTime  , -- Конечная дата переноса
    IN inBranchId            Integer    , -- Филиал
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbProtocolXML TBlob;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());
     vbUserId := lpGetUserBySession (inSession);

     DELETE FROM Sale1C 
            WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId);

     -- Подготавливаем XML для "стандартного" протокола
     SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>'
            INTO vbProtocolXML
     FROM
          (SELECT D.FieldXML
           FROM 
          (SELECT '<Field FieldName = "Начальная дата" FieldValue = "' || DATE (inStartDate) :: TVarChar || '"/>'
               || '<Field FieldName = "Конечная дата" FieldValue = "' || DATE (inEndDate) :: TVarChar || '"/>'
               || '<Field FieldName = "Филиал Id" FieldValue = "' || COALESCE (inBranchId :: TVarChar, 'NULL') :: TVarChar || '"/>'
               || '<Field FieldName = "Филиал" FieldValue = "' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inBranchId), 'NULL') :: TVarChar || '"/>'
                  AS FieldXML
          ) AS D
          ) AS D
         ;

     -- сохранили "стандартный" протокол
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
          SELECT zc_Enum_Process_LoadSaleFrom1C(), CURRENT_TIMESTAMP, vbUserId, vbProtocolXML, FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.05.15                                        * сохранили "стандартный" протокол
 30.01.14                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_1CSaleLoad (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
