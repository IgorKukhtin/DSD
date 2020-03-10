-- Function: gpInsertUpdate_Movement_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TechnicalRediscount (Integer, TVarChar, TDateTime, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TechnicalRediscount(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат поставщику>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделение
    IN inComment             TVarChar  , -- Примечание
    IN inisRedCheck          Boolean  ,  -- Красный чек
    IN inisAdjustment        Boolean  ,  -- Корректировка основного переучета
    IN inSession             TVarChar    -- сессия пользователя
)                               
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF COALESCE(ioId, 0) = 0
     THEN
        vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());
     ELSE
        vbUserId:= lpGetUserBySession (inSession);
     END IF;
     
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_TechnicalRediscount (ioId               := ioId
                                                        , inInvNumber        := inInvNumber
                                                        , inOperDate         := inOperDate
                                                        , inUnitId           := inUnitId
                                                        , inComment          := inComment
                                                        , inisRedCheck       := inisRedCheck
                                                        , inisAdjustment     := inisAdjustment
                                                        , inUserId           := vbUserId
                                                         );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_TechnicalRediscount (Integer, TVarChar, TDateTime, Integer, TVarChar, Boolean, Boolean, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
*/