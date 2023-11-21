-- Function: lfGet_Object_GoodsGroup_CodeUKTZED_onDate (Integer)
-- находим ближайший не пустой Код УКТ ЗЕД в группе

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_CodeUKTZED_onDate (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_CodeUKTZED_onDate (
 IN inObjectId               Integer,   -- начальный эл-нт дерева
 IN inOperDate               TDateTime
 
)
  RETURNS TVarChar
AS
$BODY$
DECLARE
  vbCodeUKTZED TVarChar;
BEGIN
     vbCodeUKTZED:= (SELECT CASE WHEN ObjectDate_GoodsGroup_UKTZED_new.ValueData <= inOperDate AND ObjectString_GoodsGroup_UKTZED_new.ValueData <> ''
                                 THEN ObjectString_GoodsGroup_UKTZED_new.ValueData

                                 WHEN ObjectString_GoodsGroup_UKTZED.ValueData <> ''
                                 THEN ObjectString_GoodsGroup_UKTZED.ValueData

                            ELSE lfGet_Object_GoodsGroup_CodeUKTZED_onDate (ObjectLink_GoodsGroup.ChildObjectId, inOperDate)
                            END

                   FROM Object
                        LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED
                                               ON ObjectString_GoodsGroup_UKTZED.ObjectId = Object.Id 
                                              AND ObjectString_GoodsGroup_UKTZED.DescId = zc_ObjectString_GoodsGroup_UKTZED()
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                             ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                            AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED_new
                                               ON ObjectString_GoodsGroup_UKTZED_new.ObjectId = Object.Id 
                                              AND ObjectString_GoodsGroup_UKTZED_new.DescId = zc_ObjectString_GoodsGroup_UKTZED_new()
                        LEFT JOIN ObjectDate AS ObjectDate_GoodsGroup_UKTZED_new
                                             ON ObjectDate_GoodsGroup_UKTZED_new.ObjectId = Object.Id 
                                            AND ObjectDate_GoodsGroup_UKTZED_new.DescId = zc_ObjectDate_GoodsGroup_UKTZED_new()
                   WHERE Object.Id = inObjectId);


     --
     RETURN (vbCodeUKTZED);

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
-- SELECT * FROM lfGet_Object_GoodsGroup_CodeUKTZED_onDate (1947, CURRENT_DATE)
