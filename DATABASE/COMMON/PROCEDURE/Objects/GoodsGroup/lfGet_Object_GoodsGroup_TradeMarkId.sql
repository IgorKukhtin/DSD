-- Function: lfGet_Object_GoodsGroup_TradeMarkId (Integer)
-- находим ближайшую не пустую статью в группе

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_TradeMarkId (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_TradeMarkId (
 inObjectId               Integer    -- начальный эл-нт дерева
 
)
  RETURNS Integer
AS
$BODY$
DECLARE
  vbTradeMarkId TVarChar;
BEGIN
     vbTradeMarkId:= (SELECT CASE WHEN COALESCE (ObjectLink_GoodsGroup_TradeMark.ChildObjectId,0) <> 0
                              THEN ObjectLink_GoodsGroup_TradeMark.ChildObjectId
                            ELSE lfGet_Object_GoodsGroup_TradeMarkId (ObjectLink_GoodsGroup.ChildObjectId) 
                            END
                   FROM Object
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_TradeMark
                                ON ObjectLink_GoodsGroup_TradeMark.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup_TradeMark.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                         ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                        AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                   WHERE Object.Id = inObjectId);


     --
     RETURN (vbTradeMarkId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.16                                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_GoodsGroup_TradeMarkId (137023)
