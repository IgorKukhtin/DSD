-- Function: gpInsertUpdate_Object_Fiscal  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CreditLimitJuridical (Integer,Integer,Integer,Integer,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CreditLimitJuridical(
 INOUT ioId                       Integer   ,    -- ключ объекта <> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inProviderId               Integer   ,    --
    IN inJuridicalId              Integer   ,    --
    IN inCreditLimit              TFloat    ,    --
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession;
   
   IF COALESCE(inProviderId, 0) = 0 OR  COALESCE(inJuridicalId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Не выбрано юр.лицо поставщик или наше';
   END IF;
   
   IF EXISTS(SELECT  1
             FROM Object AS Object_CreditLimitJuridical
                                                                                 
                  INNER JOIN ObjectLink AS ObjectLink_CreditLimitJuridical_Provider
                                        ON ObjectLink_CreditLimitJuridical_Provider.ObjectId = Object_CreditLimitJuridical.Id 
                                       AND ObjectLink_CreditLimitJuridical_Provider.DescId = zc_ObjectLink_CreditLimitJuridical_Provider()
                                       AND ObjectLink_CreditLimitJuridical_Provider.ChildObjectId = inProviderId

                  INNER JOIN ObjectLink AS ObjectLink_CreditLimitJuridical_Juridical
                                        ON ObjectLink_CreditLimitJuridical_Juridical.ObjectId = Object_CreditLimitJuridical.Id 
                                       AND ObjectLink_CreditLimitJuridical_Juridical.DescId = zc_ObjectLink_CreditLimitJuridical_Juridical()
                                       AND ObjectLink_CreditLimitJuridical_Juridical.ChildObjectId = inJuridicalId

             WHERE Object_CreditLimitJuridical.DescId = zc_Object_CreditLimitJuridical()
               AND (COALESCE (ioId, 0) = 0) OR Object_CreditLimitJuridical.ID <> ioId)
   THEN
     RAISE EXCEPTION 'Ошибка. Дублирование записей поставщик + наше юр. лицо запрещено ';   
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CreditLimitJuridical()); 
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CreditLimitJuridical(), vbCode_calc, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CreditLimitJuridical_Provider(), ioId, inProviderId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CreditLimitJuridical_Juridical(), ioId, inJuridicalId);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CreditLimitJuridical_CreditLimit(), ioId, inCreditLimit);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.06.19                                                       *
*/

-- тест
-- 