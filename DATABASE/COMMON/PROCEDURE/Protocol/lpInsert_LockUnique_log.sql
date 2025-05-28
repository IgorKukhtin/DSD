-- Такая "кривая" проверка уникальности, т.к. иногда транзакции не видят друг друга

DROP FUNCTION IF EXISTS lpInsert_LockUnique_log (TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsert_LockUnique_log(
    IN inKeyData      TVarChar,
    IN inUserId       Integer,
    IN inComment      TVarChar
)
RETURNS VOID
AS
$BODY$
BEGIN

     -- Проверка
     IF TRIM (COALESCE (inKeyData, '' )) = ''
     THEN 
         RAISE EXCEPTION 'Ошибка.Значение КЛЮЧ в проверке УНИКАЛЬНОСТИ - ПУСТОЙ. <%>', inKeyData;
     END IF;

 
     -- Удаление того что вчера
     DELETE FROM LockUnique WHERE OperDate < CURRENT_DATE; -- - INTERVAL '1 DAY';

     IF 1=0 --AND inUserId = 5 AND EXISTS (SELECT 1 FROM LockUnique WHERE KeyData ILIKE inKeyData)
     THEN
         RAISE EXCEPTION 'Ошибка.Попытка сформировать повторные данные.<%> <%>', inKeyData, inUserId;
     ELSE
         -- Если запись вставится - значит Уникальность соблюдается
         INSERT INTO LockUnique (KeyData, UserId, OperDate, Comment)
                         VALUES (inKeyData, inUserId, CURRENT_TIMESTAMP, inComment);
   
     END IF;

     EXCEPTION
              WHEN OTHERS THEN RAISE EXCEPTION 'Ошибка.Попытка сформировать повторные данные.Повторите действие через 1 мин.';
              
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.05.25                                        *
*/

-- тест
-- SELECT * FROM LockUnique WHERE KeyData like '%DC899%' ORDER BY OperDate DESC LIMIT 10
