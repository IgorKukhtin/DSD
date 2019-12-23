-- Function: gpInsertUpdate_Movement_IlliquidUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IlliquidUnit(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат поставщику>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделение
    IN inDayCount            Integer   , -- Дней без продаж от
    IN inProcGoods           TFloat    , -- % продажи для вып. 
    IN inProcUnit            TFloat    , -- % вып. по аптеке. 
    IN inPenalty             TFloat    , -- Штраф за 1% невып. 
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)                               
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession; -- lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IlliquidUnit());
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_IlliquidUnit (ioId               := ioId
                                                 , inInvNumber        := inInvNumber
                                                 , inOperDate         := inOperDate
                                                 , inUnitId           := inUnitId
                                                 , inDayCount         := inDayCount
                                                 , inProcGoods        := inProcGoods
                                                 , inProcUnit         := inProcUnit
                                                 , inPenalty          := inPenalty
                                                 , inComment          := inComment
                                                 , inUserId           := vbUserId
                                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/