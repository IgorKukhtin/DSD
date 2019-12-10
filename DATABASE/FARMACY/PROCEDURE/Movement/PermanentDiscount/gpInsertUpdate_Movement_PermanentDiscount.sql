-- Function: gpInsertUpdate_Movement_PermanentDiscount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PermanentDiscount (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PermanentDiscount(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Списания>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inRetailId            Integer   , -- Подразделение
    IN inStartPromo          TDateTime , -- Дата начала контракта
    IN inEndPromo            TDateTime , -- Дата окончания контракта
    IN inChangePercent       TFloat    , -- Процент скидки
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
     vbUserId := inSession;
 	 
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_PermanentDiscount (ioId               := ioId
                                                      , inInvNumber        := inInvNumber
                                                      , inOperDate         := inOperDate
                                                      , inRetailId         := inRetailId
                                                      , inStartPromo       := inStartPromo
                                                      , inEndPromo         := inEndPromo
                                                      , inChangePercent    := inChangePercent
                                                      , inComment          := inComment
                                                      , inUserId           := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_PermanentDiscount (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.12.19                                                       *
 */

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PermanentDiscount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inArticlePermanentDiscountId = 1, inComment = '', inSession:= '3')
