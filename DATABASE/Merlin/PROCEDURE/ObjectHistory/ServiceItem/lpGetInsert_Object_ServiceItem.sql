-- Function: lpGetInsert_Object_ServiceItem(Integer,Integer,Integer)

DROP FUNCTION IF EXISTS lpGetInsert_Object_ServiceItem (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetInsert_Object_ServiceItem(
    IN inUnitId         Integer,      -- 
    IN inInfoMoneyId    Integer,      -- 
    IN inUserId         Integer
)
RETURNS Integer
AS
$BODY$
DECLARE vbId Integer;
BEGIN
   
   -- поиск
   vbId:= (SELECT ObjectLink_ServiceItem_InfoMoney.ObjectId
           FROM ObjectLink AS ObjectLink_ServiceItem_Unit
                INNER JOIN ObjectLink AS ObjectLink_ServiceItem_InfoMoney
                                     ON ObjectLink_ServiceItem_InfoMoney.ObjectId      = ObjectLink_ServiceItem_Unit.ObjectId
                                    AND ObjectLink_ServiceItem_InfoMoney.DescId        = zc_ObjectLink_ServiceItem_InfoMoney()
                                    AND ( COALESCE (ObjectLink_ServiceItem_InfoMoney.ChildObjectId,0) = COALESCE (inInfoMoneyId,0))
           WHERE ObjectLink_ServiceItem_Unit.DescId        = zc_ObjectLink_ServiceItem_Unit()
             AND ObjectLink_ServiceItem_Unit.ChildObjectId = inUnitId
             
          );

  -- поиск
  IF COALESCE (vbId, 0) = 0 THEN
     -- сохранили <Объект>
     vbId := lpInsertUpdate_Object(0, zc_Object_ServiceItem(), 0, '');

     --
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ServiceItem_Unit(), vbId, inUnitId);
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ServiceItem_InfoMoney(), vbId, inInfoMoneyId);

  END IF;

  -- вернули значение
  RETURN vbId;

END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.02.22         *
*/

-- тест
--