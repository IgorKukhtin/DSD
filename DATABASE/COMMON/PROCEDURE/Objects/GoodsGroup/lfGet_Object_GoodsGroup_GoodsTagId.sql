-- Function: lfGet_Object_GoodsGroup_GoodsTagId (Integer)
-- находим ближайшую не пустую статью в группе

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_GoodsTagId (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_GoodsTagId (
 inObjectId               Integer    -- начальный эл-нт дерева
 
)
  RETURNS Integer
AS
$BODY$
DECLARE
  vbGoodsTagId TVarChar;
BEGIN
     vbGoodsTagId:= (SELECT CASE WHEN COALESCE (ObjectLink_GoodsGroup_GoodsTag.ChildObjectId,0) <> 0
                              THEN ObjectLink_GoodsGroup_GoodsTag.ChildObjectId
                            ELSE lfGet_Object_GoodsGroup_GoodsTagId (ObjectLink_GoodsGroup.ChildObjectId) 
                            END
                   FROM Object
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_GoodsTag
                                ON ObjectLink_GoodsGroup_GoodsTag.ObjectId = Object.Id
                               AND ObjectLink_GoodsGroup_GoodsTag.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                         ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                        AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                   WHERE Object.Id = inObjectId);


     --
     RETURN (vbGoodsTagId);

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
-- SELECT * FROM lfGet_Object_GoodsGroup_GoodsTagId (137023)
