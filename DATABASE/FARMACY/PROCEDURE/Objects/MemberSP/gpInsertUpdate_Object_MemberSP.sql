-- Function: gpInsertUpdate_Object_MemberSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSP (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSP (Integer, Integer, TVarChar, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSP (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSP (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberSP(
 INOUT ioId	             Integer   ,    -- ключ объекта <Торговельна назва лікарського засобу (Соц. проект)> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта <>
    IN inPartnerMedicalId    Integer   ,    -- Мед. учрежд.
    IN inGroupMemberSPId     Integer   ,    -- категория пац.
--    IN inHappyDate           TDateTime ,    -- Дата рождения
    IN inHappyDate           TVarChar ,     -- Дата рождения
    IN inAddress             TVarChar ,     -- адрес
    IN inINN                 TVarChar ,     -- ИНН
    IN inPassport            TVarChar ,     -- Серия и номер паспорта
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
   DECLARE vbHappyDate TDateTime;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberSP());
   vbUserId := inSession;
   
    -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MemberSP());
   
   -- проверка заполнения мед.учрежд.
   IF COALESCE (inPartnerMedicalId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Медицинское учреждение> не установлено.';
   END IF;
   IF COALESCE (inGroupMemberSPId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Категория пациента> не установлено.';
   END IF;
   
   --проверка для Мед.центра № 5 должны быть заполнены Адрес, ИНН, серия и номер паспорта   
   IF inPartnerMedicalId = 3751525               ----3751525 - "Комунальний заклад "ДЦПМСД №5""
   THEN
       IF COALESCE (inAddress, '') = ''
       THEN
           RAISE EXCEPTION 'Ошибка.Значение <Адрес пациента> не установлено.';
       END IF;
       IF COALESCE (inINN, '') = ''
       THEN
           RAISE EXCEPTION 'Ошибка.Значение <ИНН пациента> не установлено.';
       END IF;
       IF COALESCE (inPassport, '') = ''
       THEN
           RAISE EXCEPTION 'Ошибка.Значение <Серия и Номер паспорта пациента> не установлено.';
       END IF;       
   END IF;
   
   -- проверка уникальности <Наименование>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_MemberSP(), inName);
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberSP
                   LEFT JOIN ObjectLink AS OL_PartnerMedical
                                        ON OL_PartnerMedical.ObjectId = Object_MemberSP.Id
                                       AND OL_PartnerMedical.DescId = zc_ObjectLink_MemberSP_PartnerMedical()
                   LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                                        ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = Object_MemberSP.Id
                                       AND ObjectLink_MemberSP_GroupMemberSP.DescId = zc_ObjectLink_MemberSP_GroupMemberSP()
              WHERE Object_MemberSP.DescId = zc_Object_MemberSP()
                AND Object_MemberSP.ValueData = TRIM(inName)
                AND OL_PartnerMedical.ChildObjectId = inPartnerMedicalId
                AND ObjectLink_MemberSP_GroupMemberSP.ChildObjectId = inGroupMemberSPId
                AND Object_MemberSP.Id <> ioId
              )
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <%> не уникально для справочника' , inName;
   END IF;
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MemberSP(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MemberSP(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MemberSP_PartnerMedical(), ioId, inPartnerMedicalId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MemberSP_GroupMemberSP(), ioId, inGroupMemberSPId);   

   -- сохранили свойство <>
   IF COALESCE (inHappyDate, '') <> ''
      THEN
          vbHappyDate := ('01.01.' || TRIM (inHappyDate)) :: TDatetime;   -- вносят только год рождения, поэтому для даты дополняем 01,01
          PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_MemberSP_HappyDate(), ioId, vbHappyDate);
   END IF;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberSP_Address(), ioId, inAddress);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberSP_INN(), ioId, inINN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberSP_Passport(), ioId, inPassport);
      
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.18         *
 18.01.18         *
 14.02.17         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MemberSP()
