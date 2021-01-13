-- Function: gpInsertUpdate_Movement_OrderSale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderSale (Integer, TVarChar, TDateTime, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderSale(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPartnerId           Integer   , --
    IN inTotalCountKg        TFloat    , 
    IN inTotalSumm           TFloat    , 
    IN inComment             TVarChar   , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderSale());
     --vbUserId := inSession;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_OrderSale (ioId           := ioId
                                              , inInvNumber    := inInvNumber
                                              , inOperDate     := inOperDate
                                              , inPartnerId    := inPartnerId
                                              , inTotalCountKg := inTotalCountKg
                                              , inTotalSumm    := inTotalSumm
                                              , inComment      := inComment
                                              , inUserId       := vbUserId
                                               );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.21         *
*/

-- тест
--