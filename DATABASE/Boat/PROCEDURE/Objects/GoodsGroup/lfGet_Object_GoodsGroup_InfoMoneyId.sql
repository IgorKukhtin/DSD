-- Function: lfGet_Object_GoodsGroup_InfoMoneyId (Integer)
-- находим ближайшую не пустую статью в группе

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_InfoMoneyId (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_InfoMoneyId (
 inObjectId       Integer    -- начальный эл-нт дерева
 
)
  RETURNS Integer
AS
$BODY$
DECLARE
  vbInfoMoneyId TVarChar;
BEGIN
     vbInfoMoneyId:= (SELECT CASE WHEN ObjectLink_GoodsGroup_InfoMoney.ChildObjectId <> 0
                                  -- если есть значение у этой группы
                                  THEN ObjectLink_GoodsGroup_InfoMoney.ChildObjectId
                                  -- рекурсивно ищем у группы выше
                                  ELSE lfGet_Object_GoodsGroup_InfoMoneyId (ObjectLink_GoodsGroup.ChildObjectId) 
                             END
                      FROM Object
                         LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
                         LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE Object.Id = inObjectId
                     );

     --
     RETURN (vbInfoMoneyId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.06.17         *
*/

-- тест
-- SELECT * FROM lfGet_Object_GoodsGroup_InfoMoneyId (0)
