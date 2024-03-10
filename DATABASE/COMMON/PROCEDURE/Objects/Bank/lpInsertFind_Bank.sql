DROP FUNCTION IF EXISTS lpInsertFind_Bank(TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Bank(
    IN inBankMFO             TVarChar,      -- <MFO>
    IN inBankName            TVarChar,      -- Название банка
    IN inUserId              Integer
)
RETURNS Integer AS
$BODY$
   DECLARE vbBankId Integer;
   DECLARE vbBankName TVarChar;
   DECLARE vbCode Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());

   -- Ищем Банк по МФО. Если не находим, то добавляем
   SELECT Object_Bank_View.Id, Object_Bank_View.BankName INTO vbBankId, vbBankName
   FROM (SELECT *
         FROM Object_Bank_View
         WHERE Object_Bank_View.MFO ILIKE TRIM (inBankMFO)
           AND Object_Bank_View.isErased = FALSE
         ORDER BY Object_Bank_View.Id DESC
         LIMIT 1
        ) AS Object_Bank_View;


   IF COALESCE (vbBankId, 0) = 0
   THEN
      -- Если код не установлен, определяем его каи последний+1
      vbCode := lfGet_ObjectCode (0, zc_Object_Bank());

      -- проверка прав уникальности для свойства <МФО>
      -- PERFORM lpCheckUnique_ObjectString_ValueData (vbBankId, zc_Object_Bank(), inBankMFO);

      IF TRIM (COALESCE (inBankName, '')) = '' AND 1=1
      THEN
          RAISE EXCEPTION 'Ошибка.Значение Банк пусто для MFO = <%>.'
                        , inBankMFO
                         ;

      END IF;

      -- сохранили <Объект>
      vbBankId := lpInsertUpdate_Object (vbBankId, zc_Object_Bank(), vbCode, TRIM (inBankName));

      PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_MFO(), vbBankId, TRIM (inBankMFO));

      -- сохранили протокол
      PERFORM lpInsert_ObjectProtocol (vbBankId, inUserId);

   END IF;

   IF TRIM (COALESCE(vbBankName, '')) = '' AND TRIM (inBankName) <>''
   THEN
      UPDATE Object SET ValueData = TRIM (inBankName) WHERE Id = vbBankId;
      -- сохранили протокол
      PERFORM lpInsert_ObjectProtocol (vbBankId, inUserId);
   END IF;


   -- Результат
   RETURN vbBankId;


END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.06.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')
