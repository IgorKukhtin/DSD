-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inInvNumberPartner    TVarChar  , -- Номер документа
    --IN inOperDatePartner     TDateTime , -- Дата документа поставщика -- сохраняется в отдельной процедуре
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inNDSKindId           Integer   , -- Типы НДС
    IN inParentId            Integer   , -- Приходная накладная
    IN inReturnTypeId        Integer   , -- Тип возврата
    IN inLegalAddressId      Integer   , -- Юридический адрес поставщика
    IN inActualAddressId     Integer   , -- Фактический адрес поставщика
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());
     vbUserId := inSession;

     ioId := lpInsertUpdate_Movement_ReturnOut(ioId
                                             , inInvNumber
                                             , inOperDate
                                             , inInvNumberPartner
--                                             , inOperDatePartner
                                             , inPriceWithVAT
                                             , inFromId
                                             , inToId
                                             , inNDSKindId
                                             , inParentId
                                             , inReturnTypeId
                                             , inLegalAddressId
                                             , inActualAddressId
                                             , vbUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 28.05.18                                                                     * 
 15.09.16         *
 06.02.15                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ReturnOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
