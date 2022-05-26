-- Function: gpDelete_ObjectHistory()

DROP FUNCTION IF EXISTS gpDelete_ObjectHistoryLast (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_ObjectHistoryLast(
    IN inId                  Integer   ,  -- ключ объекта 
    IN inSession             TVarChar     -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

     
   --проверка если не последний элемент  то  ошибка 
   IF NOT EXISTS (SELECT ObjectHistory.Id
                  FROM ObjectHistory
                  WHERE ObjectHistory.Id = inId
                    AND ObjectHistory.DescId = zc_ObjectHistory_ServiceItem()
                    AND ObjectHistory.EndDate = zc_DateEnd() ) 
   THEN 
         RAISE EXCEPTION 'Ошибка.Удалять разрешено только последнее значение.';
   END IF;
   
           -- сохранили свойство <Дата корректировки>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ObjectHistory.ObjectId, CURRENT_TIMESTAMP)
           -- сохранили свойство <Пользователь (корректировка)>
         , lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ObjectHistory.ObjectId, vbUserId)
   FROM ObjectHistory
   WHERE ObjectHistory.Id = inId;

   -- 
   PERFORM lpDelete_ObjectHistory (inId	      := inId
                                 , inUserId   := vbUserId
                                  );

   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.22         *
*/

