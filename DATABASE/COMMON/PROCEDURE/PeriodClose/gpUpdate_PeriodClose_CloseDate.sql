-- Function: gpUpdate_PeriodClose_CloseDate (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_PeriodClose_all (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_PeriodClose_CloseDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_PeriodClose_CloseDate(
    IN inId	        Integer   ,     -- ключ объекта
    IN inCloseDate      TDateTime ,     -- Закрытый период
    IN inSession        TVarChar        -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

    --
    IF vbUserId = 9464 THEN vbUserId := 9464;
    ELSE
       -- проверка прав пользователя на вызов процедуры
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_User()); -- не ошибка, просто будем использовать этот процесс
    END IF;

   -- изменили элемент справочника по значению <Ключ объекта>
   UPDATE PeriodClose SET OperDate  = CURRENT_TIMESTAMP
                        , UserId    = vbUserId
                        , CloseDate = inCloseDate
                        , Period    = '0 DAY' :: INTERVAL
   WHERE Id = inId;
  
   -- Ведение протокола
   INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
      SELECT vbUserId, CURRENT_TIMESTAMP, vbUserId
           , '<XML>'
          || '<Field FieldName = "Период закрыт до" FieldValue = "' || zfConvert_DateToString (inCloseDate) || '"/>'
          || '</XML>' AS ProtocolData
           , TRUE AS isInsert
            ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.16                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_PeriodClose_CloseDate()
