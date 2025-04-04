﻿-- Function: gpSelect_Object_GoodsSize()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsSize (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsSize(
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean)
  AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsSize());


   -- результат
   RETURN QUERY
      SELECT Object.Id                          AS Id
           , Object.ObjectCode                  AS Code
           , Object.ValueData                   AS Name
           , Object.isErased                    AS isErased
       FROM Object
       WHERE Object.DescId = zc_Object_GoodsSize()
         AND (Object.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 19.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsSize (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
