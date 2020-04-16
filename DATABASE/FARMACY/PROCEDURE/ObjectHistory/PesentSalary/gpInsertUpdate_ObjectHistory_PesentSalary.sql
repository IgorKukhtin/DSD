-- Function: gpInsertUpdate_ObjectHistory_PesentSalary ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PesentSalary (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PesentSalary(
 INOUT ioId                 Integer,    -- ключ объекта <Элемент истории % фонда зп>
    IN inRetailId           Integer,    -- торговя сеть
    IN inOperDate           TDateTime,  -- Дата действия %
    IN inPesentSalary       TFloat,     -- % фонда зп
    IN inSession            TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- проверка
   IF COALESCE (inRetailId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлена <торговая сеть>.';
   END IF;


   -- Вставляем или меняем объект историю
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PesentSalary(), inRetailId, inOperDate, vbUserId);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PesentSalary_Value(), ioId, inPesentSalary);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 16.04.20         *
*/
