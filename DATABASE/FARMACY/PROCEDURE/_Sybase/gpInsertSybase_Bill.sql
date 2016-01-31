-- Function: gpInsertSybase_Bill()

DROP FUNCTION IF EXISTS gpInsertSybase_Bill (Integer, TDateTime, TVarChar, Integer, TFloat, Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertSybase_Bill(
    IN inID             Integer,
    IN inBillDate       TDateTime,
    IN inBillNumber     TVarChar,
    IN inBillKind       Integer,
    IN inBillSumm       TFloat,
    IN inFromId         Integer,
    IN inToId           Integer,
    IN inisNDS          Integer,
    IN inNds            TFloat,
    IN inisBlocking     Integer,
    IN inisDistribution Integer,
    IN inParentId       Integer,
    IN inisMark         Integer,
    IN inIncomeCheck    Integer,
    IN inReturnTypeId   Integer,
    IN inContragentSumm TFloat,
    IN inRepriceClosed  Integer,
    IN inClientDate     TDateTime,
    IN inClientNumber   TVarChar,
    IN inManagerId      Integer,
    IN inDateNULL       TDateTime,
    IN inIntNULL        Integer,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_());
   
    INSERT INTO _Bill (ID,BillDate,BillNumber,BillKind,BillSumm,FromID,ToID,IsNds,Nds,isBlocking,isDistribution,ParentId,isMark,IncomeCheck,ReturnTypeId,ContragentSumm,RepriceClosed,ClientDate,ClientNumber,ManagerId)
    SELECT inID
         , inBillDate
         , inBillNumber
         , inBillKind
         , inBillSumm
         , inFromID
         , inToID
         , inIsNds
         , inNds
         , inisBlocking
         , case when inisDistribution = inIntNULL then NULL else inisDistribution end
         , inParentId
         , case when inisMark = inIntNULL then NULL else inisMark end
         , case when inIncomeCheck = inIntNULL then NULL else inIncomeCheck end
         , inReturnTypeId
         , inContragentSumm
         , case when inRepriceClosed = inIntNULL then NULL else inRepriceClosed end
         , case when inClientDate = inDateNULL then NULL else inClientDate end
         , inClientNumber
         , inManagerId
    WHERE NOT EXISTS (SELECT Id FROM _Bill WHERE Id = inID);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.01.16                                        *
*/

-- тест
-- SELECT * FROM gpInsertSybase_Bill (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
