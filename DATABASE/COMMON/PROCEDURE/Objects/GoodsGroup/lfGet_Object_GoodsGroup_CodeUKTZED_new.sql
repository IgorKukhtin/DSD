a-- Function: lfGet_Object_GoodsGroup_CodeUKTZED (Integer)
-- находим ближайший не пустой Код УКТ ЗЕД в группе

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_CodeUKTZED_new (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_CodeUKTZED_new (
 inObjectId               Integer    -- начальный эл-нт дерева 
)
  RETURNS TABLE (CodeUKTZED_new         TVarChar,
                 DateUKTZED_new         TDateTime
          )
AS
$BODY$
DECLARE
  vbCodeUKTZED_new TVarChar;
  vbDateUKTZED_new TDateTime;
BEGIN
     vbCodeUKTZED_new:= (SELECT CASE WHEN ObjectString_GoodsGroup_UKTZED_new.ValueData <> ''
                                     THEN ObjectString_GoodsGroup_UKTZED_new.ValueData
                                   ELSE (SELECT tmp.CodeUKTZED_new FROM lfGet_Object_GoodsGroup_CodeUKTZED_new (ObjectLink_GoodsGroup.ChildObjectId) AS tmp)
                                   END
                          FROM Object
                             LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED_new
                                                    ON ObjectString_GoodsGroup_UKTZED_new.ObjectId = Object.Id 
                                                   AND ObjectString_GoodsGroup_UKTZED_new.DescId = zc_ObjectString_GoodsGroup_UKTZED_new()
                             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                                  ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                                 AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                          WHERE Object.Id = inObjectId);

     vbDateUKTZED_new:= (SELECT CASE WHEN ObjectDate_GoodsGroup_UKTZED_new.ValueData IS NOT NULL
                                     THEN ObjectDate_GoodsGroup_UKTZED_new.ValueData
                                   ELSE (SELECT tmp.DateUKTZED_new FROM lfGet_Object_GoodsGroup_CodeUKTZED_new (ObjectLink_GoodsGroup.ChildObjectId) AS tmp)
                                   END
                          FROM Object
                             LEFT JOIN ObjectDate AS ObjectDate_GoodsGroup_UKTZED_new
                                                  ON ObjectDate_GoodsGroup_UKTZED_new.ObjectId = Object.Id 
                                                 AND ObjectDate_GoodsGroup_UKTZED_new.DescId = zc_ObjectDate_GoodsGroup_UKTZED_new()
                             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                                  ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                                 AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                          WHERE Object.Id = inObjectId);
  
   RETURN QUERY                                                       
   SELECT vbCodeUKTZED_new ::TVarChar   AS CodeUKTZED_new
        , vbDateUKTZED_new ::TDateTime  AS DateUKTZED_new
    ;
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
--   SELECT * FROM lfGet_Object_GoodsGroup_CodeUKTZED_new (137023)
