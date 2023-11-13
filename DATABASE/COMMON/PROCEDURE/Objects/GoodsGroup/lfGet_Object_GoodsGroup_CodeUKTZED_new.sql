-- Function: lfGet_Object_GoodsGroup_CodeUKTZED (Integer)
-- находим ближайший не пустой Код УКТ ЗЕД в группе

DROP FUNCTION IF EXISTS lfGet_Object_GoodsGroup_CodeUKTZED_new (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_GoodsGroup_CodeUKTZED_new (
 inObjectId    Integer
)
RETURNS TABLE (CodeUKTZED_new         TVarChar
             , DateUKTZED_new         TDateTime
              )
AS
$BODY$
BEGIN

     IF COALESCE (inObjectId, 0) = 0
     THEN
         RETURN QUERY
           SELECT ''   :: TVarChar  AS CodeUKTZED_new
                , NULL :: TDateTime AS DateUKTZED_new
                 ;

     ELSEIF EXISTS (SELECT 1
                    FROM ObjectString AS ObjectString_GoodsGroup_UKTZED_new
                    WHERE ObjectString_GoodsGroup_UKTZED_new.ObjectId  = inObjectId
                      AND ObjectString_GoodsGroup_UKTZED_new.DescId    = zc_ObjectString_GoodsGroup_UKTZED_new()
                      AND ObjectString_GoodsGroup_UKTZED_new.ValueData <> ''
                   )
     THEN
         --
         RETURN QUERY
           SELECT ObjectString_GoodsGroup_UKTZED_new.ValueData AS CodeUKTZED_new
                , ObjectDate_GoodsGroup_UKTZED_new.ValueData   AS DateUKTZED_new
           FROM Object
                LEFT JOIN ObjectString AS ObjectString_GoodsGroup_UKTZED_new
                                       ON ObjectString_GoodsGroup_UKTZED_new.ObjectId = Object.Id
                                      AND ObjectString_GoodsGroup_UKTZED_new.DescId = zc_ObjectString_GoodsGroup_UKTZED_new()
                LEFT JOIN ObjectDate AS ObjectDate_GoodsGroup_UKTZED_new
                                     ON ObjectDate_GoodsGroup_UKTZED_new.ObjectId = Object.Id
                                    AND ObjectDate_GoodsGroup_UKTZED_new.DescId = zc_ObjectDate_GoodsGroup_UKTZED_new()
           WHERE Object.Id = inObjectId
          ;
     ELSE 
         -- рекурсия
         RETURN QUERY
           SELECT lfGet.CodeUKTZED_new
                , lfGet.DateUKTZED_new
           FROM lfGet_Object_GoodsGroup_CodeUKTZED_new ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_GoodsGroup_Parent())
                                                       ) AS lfGet
          ;
     END IF;

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
