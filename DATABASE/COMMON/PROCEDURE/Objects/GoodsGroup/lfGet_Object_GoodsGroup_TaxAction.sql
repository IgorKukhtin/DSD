-- Function: lfGet_Object_GoodsGroup_TaxAction (Integer)
-- находим ближайший не пустой Код УКТ ЗЕД в группе

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_TaxAction (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_TaxAction (
 inObjectId               Integer    -- начальный эл-нт дерева
)
  RETURNS TVarChar
AS
$BODY$
DECLARE
  vbTaxAction TVarChar;
BEGIN
     vbTaxAction:= (SELECT CASE WHEN ObjectString_GoodsGroup_TaxAction.ValueData <> ''
                              THEN ObjectString_GoodsGroup_TaxAction.ValueData
                            ELSE lfGet_Object_GoodsGroup_TaxAction (ObjectLink_GoodsGroup.ChildObjectId) 
                           END
                    FROM Object
                         LEFT JOIN ObjectString AS ObjectString_GoodsGroup_TaxAction
                                                ON ObjectString_GoodsGroup_TaxAction.ObjectId = Object.Id 
                                               AND ObjectString_GoodsGroup_TaxAction.DescId = zc_ObjectString_GoodsGroup_TaxAction()
                         LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                              ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                             AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                    WHERE Object.Id = inObjectId);

     --
     RETURN (vbTaxAction);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.03.17         *                              *
*/

-- тест
-- SELECT * FROM lfGet_Object_GoodsGroup_TaxAction (137023)
