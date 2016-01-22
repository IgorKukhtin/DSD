-- Function: lfGet_Object_GoodsGroup_GoodsPlatformId (Integer)
-- находим ближайшую не пустую статью в группе

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_GoodsPlatformId (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_GoodsPlatformId (
 inObjectId               Integer    -- начальный эл-нт дерева
 
)
  RETURNS Integer
AS
$BODY$
DECLARE
  vbGoodsPlatformId TVarChar;
BEGIN
     vbGoodsPlatformId:= (SELECT CASE WHEN COALESCE (ObjectLink_GoodsGroup_GoodsPlatform.ChildObjectId,0) <> 0
                              THEN ObjectLink_GoodsGroup_GoodsPlatform.ChildObjectId
                            ELSE lfGet_Object_GoodsGroup_GoodsPlatformId (ObjectLink_GoodsGroup.ChildObjectId) 
                            END
                   FROM Object
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsPlatform
                                ON ObjectLink_GoodsGroup_GoodsPlatform.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup_GoodsPlatform.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                         ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                        AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                   WHERE Object.Id = inObjectId);


     --
     RETURN (vbGoodsPlatformId);

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
-- SELECT * FROM lfGet_Object_GoodsGroup_GoodsPlatformId (137023)
