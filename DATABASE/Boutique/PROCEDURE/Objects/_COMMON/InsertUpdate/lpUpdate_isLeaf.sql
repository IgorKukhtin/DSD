-- Function: lpUpdate_isLeaf() - ставит признак папки\листа 

-- DROP FUNCTION lpUpdate_isLeaf (IN inCode Integer, IN inDescId Integer, IN inEnumName TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_isLeaf(
    IN inObjectId            Integer   , 
    IN inObjectLinkDescId    Integer   
)
RETURNS VOID AS
$BODY$
BEGIN
   -- Есть ли записи для которых наш объект является родителем
   IF (SELECT Count(*) FROM ObjectLink WHERE DescId = inObjectLinkDescId AND ChildObjectId = inObjectId) > 0 THEN
      -- Установить свойство лист\папка 
      PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_isLeaf(), inObjectId, false);
   ELSE
      PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_isLeaf(), inObjectId, true);
   END IF;

END;$BODY$ LANGUAGE PLPGSQL;
ALTER FUNCTION lpUpdate_isLeaf (Integer, Integer) OWNER TO POSTGRES;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.13                          *

*/

-- тест
-- SELECT * FROM lpUpdate_Object_Enum_byCode (inCode:= 10100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10100');
