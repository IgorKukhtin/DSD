-- Function: gpInsertUpdate_ObjectHistory_Price ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_MarginCategoryItem (Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_MarginCategoryItem(
 INOUT ioId                        Integer,    -- ключ объекта <Элемент истории>
    IN inMarginCategoryItemId      Integer,    -- 
    IN inOperDate                  TDateTime,  -- Дата действия
    IN inPrice                     TFloat,     -- 
    IN inValue                     TFloat,     -- 
    IN inSession                   TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- проверка
   IF COALESCE (inMarginCategoryItemId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлена <категория наценки>.';
   END IF;
   -- Вставляем или меняем объект историю
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_MarginCategoryItem(), inMarginCategoryItemId, inOperDate, vbUserId);
   -- Минимальная цена
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_MarginCategoryItem_Price(), ioId, inPrice);
   -- % наценки
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_MarginCategoryItem_Value(), ioId, inValue);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.02.17         *
*/
