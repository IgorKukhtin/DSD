-- Function: gpInsertSybase_CashOperation()

DROP FUNCTION IF EXISTS gpInsertSybase_CashOperation (Integer, Integer, TDateTime, Integer, Integer, TFloat, Integer, TVarChar, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertSybase_CashOperation(
    IN inID             Integer,
    IN inCashID         Integer,
    IN inOperDate       TDateTime,
    IN inClientID       Integer,
    IN inSpendingID     Integer,
    IN inOperSumm       TFloat,
    IN inDocumentID     Integer,
    IN inRemark         TVarChar,
    IN inisPlat         Integer,
    IN inPlatNumber     Integer,
    IN inContragentSumm TFloat,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_());
   
    INSERT INTO _CashOperation (ID,CashID,OperDate,ClientID,SpendingID,OperSumm,DocumentID,Remark,isPlat,PlatNumber,ContragentSumm)
    SELECT inID
         , inCashID
         , inOperDate
         , inClientID
         , inSpendingID
         , inOperSumm
         , inDocumentID
         , inRemark
         , inisPlat
         , inPlatNumber
         , inContragentSumm
    WHERE NOT EXISTS (SELECT Id FROM _CashOperation WHERE Id = inID);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.01.16                                        *
*/

-- тест
-- SELECT * FROM gpInsertSybase_CashOperation (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
