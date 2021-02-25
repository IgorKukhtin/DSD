-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut(Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , --
    IN inChangePercent       TFloat    , --
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inPaidKindId          Integer   , -- ФО
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOldContractId Integer;
   DECLARE vbDeferment Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());
    vbUserId := lpGetUserBySession (inSession);

    --    
    ioId := lpInsertUpdate_Movement_ReturnOut(ioId, inInvNumber
                                         , inOperDate, inOperDatePartner
                                         , inPriceWithVAT
                                         , inVATPercent, inChangePercent
                                         , inFromId, inToId
                                         , inPaidKindId
                                         , inComment
                                         , vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.21         *
*/

-- тест
--