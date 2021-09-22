-- Function: gpInsertUpdate_Object_MemberIC()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberIC (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberIC(
 INOUT ioId	              Integer   ,    -- ключ объекта
    IN inCode                 Integer   ,    -- код объекта 
    IN inName                 TVarChar  ,    -- Название объекта <ФИО покупателя (Страховой компании)>
    IN inInsuranceCompaniesId Integer   ,    -- Страховой компания
    IN inInsuranceCardNumber  TVarChar ,     -- Номер страховой карты	
    IN inSession              TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberIC());
   vbUserId := inSession;
   
    -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MemberIC());
   
   -- проверка заполнения Страховой компании
   IF COALESCE (inInsuranceCompaniesId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Страховой компания> не установлено.';
   END IF;
   
   IF COALESCE (TRIM(inInsuranceCardNumber)	, '') = ''
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Номер страховой карты> не установлено.';
   END IF;
   
   -- проверка уникальности <Наименование>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_MemberIC(), inName);
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberIC
                   LEFT JOIN ObjectString AS ObjectString_InsuranceCardNumber	
                                          ON ObjectString_InsuranceCardNumber.ObjectId = Object_MemberIC.Id
                                         AND ObjectString_InsuranceCardNumber.DescId = zc_ObjectString_MemberIC_InsuranceCardNumber	()

                   LEFT JOIN ObjectLink AS ObjectLink_MemberIC_InsuranceCompanies
                                        ON ObjectLink_MemberIC_InsuranceCompanies.ObjectId = Object_MemberIC.Id
                                       AND ObjectLink_MemberIC_InsuranceCompanies.DescId = zc_ObjectLink_MemberIC_InsuranceCompanies()
              WHERE Object_MemberIC.DescId = zc_Object_MemberIC()
                AND ObjectLink_MemberIC_InsuranceCompanies.ChildObjectId = inInsuranceCompaniesId
                AND ObjectString_InsuranceCardNumber.ValueData = TRIM(inInsuranceCardNumber)
                AND Object_MemberIC.Id <> ioId
              )
   THEN
       RAISE EXCEPTION 'Ошибка.Номер страховой карты <%> не уникально для справочника по страховой компании' , inInsuranceCardNumber;
   END IF;
   
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MemberIC(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MemberIC(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MemberIC_InsuranceCompanies(), ioId, inInsuranceCompaniesId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberIC_InsuranceCardNumber	(), ioId, inInsuranceCardNumber	);
      
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.09.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MemberIC()

