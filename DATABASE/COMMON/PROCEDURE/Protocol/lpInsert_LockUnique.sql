-- Такая "кривая" проверка уникальности, т.к. иногда транзакции не видят друг друга

DROP FUNCTION IF EXISTS lpInsert_LockUnique (TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsert_LockUnique(
    IN inKeyData      TVarChar,
    IN inUserId       Integer
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
         INSERT INTO LockUnique (KeyData, UserId, OperDate)
                         VALUES (inKeyData, inUserId, CURRENT_TIMESTAMP);
   
     END IF;

     EXCEPTION
              WHEN OTHERS THEN RAISE EXCEPTION 'Ошибка.Попытка сформировать повторные данные.Повторите действие через 1 мин.';
              
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.05.17                                        *
*/

-- тест
-- SELECT * FROM lpInsert_LockUnique (inKeyData:= '123', inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM LockUnique WHERE KeyData like '%DC899%' ORDER BY OperDate DESC
-- SELECT * FROM LockUnique WHERE query like '%FETCH ALL%' AND query_start < CURRENT_TIMESTAMP - INTERVAL '45 SEC' ORDER BY OperDate DESC
