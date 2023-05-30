-- Function: lfGet_Object_GoodsGroup_isAsset (Integer)
-- находим ближайшее не пустое значение в группах

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_isAsset (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_isAsset (
 inObjectId               Integer    -- начальный эл-нт дерева
)
RETURNS Boolean
AS
$BODY$
DECLARE
  vbIsAsset Boolean;
BEGIN
     vbIsAsset:= (SELECT CASE WHEN OB_isAsset.ValueData = TRUE
                              THEN OB_isAsset.ValueData
                         ELSE lfGet_Object_GoodsGroup_isAsset (ObjectLink_GoodsGroup.ChildObjectId)
                         END
                  FROM Object
                       LEFT JOIN ObjectBoolean AS OB_isAsset
                                               ON OB_isAsset.ObjectId = Object.Id
                                              AND OB_isAsset.DescId   = zc_ObjectBoolean_GoodsGroup_Asset()
                       -- следующий верхний уровень
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                            ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                           AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                  WHERE Object.Id = inObjectId
                 );


     --
     RETURN (COALESCE (vbIsAsset, FALSE));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.05.23                                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_GoodsGroup_isAsset (2894774)
-- SELECT * FROM lfGet_Object_GoodsGroup_isAsset (9438334)
