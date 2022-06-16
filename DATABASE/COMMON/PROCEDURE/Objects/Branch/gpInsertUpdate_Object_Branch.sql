-- Function: gpInsertUpdate_Object_Branch (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Branch (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Branch(
 INOUT ioId                     Integer,       -- ключ объекта <Филиал>
    IN inCode                   Integer,       -- Код объекта <Филиал> 
    IN inName                   TVarChar,      -- Название объекта <Филиал>
    IN inInvNumber              TVarChar,      -- Номер филиала в налоговой
    IN inIsMedoc                Boolean,       -- загрузка налоговых из медка
    IN inIsPartionDoc           Boolean,       -- Партионный учет долгов нал
    IN inUnitId                 Integer,       -- ссылка на Подразделение (основной склад) 
    IN inUnitReturnId           Integer,       -- ссылка на Подразделение (склад возвратов)
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Branch());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc := lfGet_ObjectCode (inCode, zc_Object_Branch());

   -- проверка прав уникальности для свойства <Наименование Филиала>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Branch(), inName);
   -- проверка прав уникальности для свойства <Код Филиала>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Branch(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Branch(), vbCode_calc, inName
                                , inAccessKeyId:= CASE WHEN vbCode_calc = 1 -- филиал Днепр
                                                            THEN zc_Enum_Process_AccessKey_TrasportDnepr()

                                                       WHEN vbCode_calc = 2 -- филиал Киев
                                                            THEN zc_Enum_Process_AccessKey_TrasportKiev()

                                                       WHEN vbCode_calc = 3 -- филиал Николаев (Херсон)
                                                            THEN zc_Enum_Process_AccessKey_TrasportNikolaev()

                                                       WHEN vbCode_calc = 4 -- филиал Одесса
                                                            THEN zc_Enum_Process_AccessKey_TrasportOdessa()

                                                       WHEN vbCode_calc = 5 -- филиал Черкассы ( Кировоград)
                                                            THEN zc_Enum_Process_AccessKey_TrasportCherkassi()

                                                       -- WHEN vbCode_calc = 6 -- филиал Крым
                                                       --      THEN zc_Enum_Process_AccessKey_()

                                                       WHEN vbCode_calc = 7 -- филиал Кр.Рог
                                                            THEN zc_Enum_Process_AccessKey_TrasportKrRog()

                                                       WHEN vbCode_calc = 8 -- филиал Донецк
                                                            THEN zc_Enum_Process_AccessKey_TrasportDoneck()

                                                       WHEN vbCode_calc = 9 -- филиал Харьков
                                                            THEN zc_Enum_Process_AccessKey_TrasportKharkov()

                                                       -- WHEN vbCode_calc = 10 -- филиал Никополь
                                                       --      THEN zc_Enum_Process_AccessKey_()
                                                       
                                                       WHEN vbCode_calc = 11 -- филиал Запорожье
                                                            THEN zc_Enum_Process_AccessKey_TrasportZaporozhye()

                                                       WHEN vbCode_calc = 12 -- филиал Lviv
                                                            THEN zc_Enum_Process_AccessKey_TrasportLviv()

                                                       WHEN vbCode_calc = 13 -- филиал Irna
                                                            THEN zc_Enum_Process_AccessKey_TrasportIrna()
                                                  END);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Branch_InvNumber(), ioId, inInvNumber);

   -- сохранили связь с <>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Branch_PersonalBookkeeper(), ioId, inPersonalBookkeeperId);

   -- сохранили связь с <Подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Branch_Unit(), ioId, inUnitId);
   -- сохранили связь с <Подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Branch_UnitReturn(), ioId, inUnitReturnId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Branch_Medoc(), ioId, inIsMedoc);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Branch_PartionDoc(), ioId, inIsPartionDoc);
                                                     
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Branch (Integer, Integer, TVarChar,  TVarChar, Integer, Boolean, Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.12.15         * add Unit, UnitReturn
 16.12.15         * del inPersonalBookkeeperId (перееносим в отдельную процку)
 28.04.15         * add PartionDoc
 17.04.15         * add IsMedoc
 18.03.15         * add InvNumber, PersonalBookkeeper                 
 14.12.13                                        * add inAccessKeyId
 10.05.13         *
 05.06.13          
 02.07.13                        * Убрал JuridicalId     
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Branch(1,1,'','')