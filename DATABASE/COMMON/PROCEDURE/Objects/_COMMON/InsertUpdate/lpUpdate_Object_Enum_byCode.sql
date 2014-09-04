-- Function: lpUpdate_Object_Enum_byCode() - делает то то ....

-- DROP FUNCTION lpUpdate_Object_Enum_byCode (IN inCode Integer, IN inDescId Integer, IN inEnumName TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Enum_byCode(
    IN inCode         Integer   , 
    IN inDescId       Integer   , 
    IN inEnumName     TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbCodeDesc TVarChar;
BEGIN

   -- !!! ОБЯЗАТЕЛЬНО СДЕЛАТЬ ПРОВЕРКУ УНИКАЛЬНОСТИ !!!
   -- Проверка уникальности inEnumName


   -- Определили по коду <Объект>
   SELECT Id INTO vbId FROM Object WHERE ObjectCode = inCode AND DescId = inDescId;

   IF COALESCE (vbId, 0) = 0
   THEN
       -- return;
       SELECT Code INTO vbCodeDesc FROM ObjectDesc WHERE Id = inDescId;
       RAISE EXCEPTION 'Не найден Id в lpUpdate_Object_Enum_byCode inCode = "%" для inEnumName = "%" в справочнике "%" inDescId = "%"', inCode, inEnumName, vbCodeDesc, inDescId;
   END IF;

   -- сохранили свойство <Enum>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbId, inEnumName);

END;$BODY$ LANGUAGE PLPGSQL;
ALTER FUNCTION lpUpdate_Object_Enum_byCode (Integer, Integer, TVarChar) OWNER TO POSTGRES;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.13                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_Enum_byCode (inCode:= 10100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10100');
