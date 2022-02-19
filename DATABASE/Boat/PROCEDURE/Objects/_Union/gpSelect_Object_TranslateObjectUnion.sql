-- Function: gpSelect_Object_TranslateObjectUnion()

DROP FUNCTION IF EXISTS gpSelect_Object_TranslateObjectUnion (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_TranslateObjectUnion (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TranslateObjectUnion(
    IN inisShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DescName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY

       -- Результат
       --Комплектующие
       SELECT Object_Goods.Id           AS Id
            , Object_Goods.ObjectCode   AS Code
            , Object_Goods.ValueData    AS Name
            , ObjectDesc.ItemName       AS DescName
            , Object_Goods.isErased     AS isErased
       FROM Object AS Object_Goods
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
       WHERE Object_Goods.DescId = zc_Object_Goods()
         AND (Object_Goods.isErased = inisShowAll OR inisShowAll = TRUE) 
      UNION
              -- ед.изм
       SELECT Object_Measure.Id         AS Id
            , Object_Measure.ObjectCode AS Code
            , Object_Measure.ValueData  AS Name
            , ObjectDesc.ItemName       AS DescName
            , Object_Measure.isErased   AS isErased
       FROM Object AS Object_Measure
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Measure.DescId
       WHERE Object_Measure.DescId = zc_Object_Measure()
         AND (Object_Measure.isErased = inisShowAll OR inisShowAll = TRUE) 
      UNION
              -- сокр. ед.изм
       SELECT Object_MeasureCode.Id         AS Id
            , Object_MeasureCode.ObjectCode AS Code
            , Object_MeasureCode.ValueData  AS Name
            , ObjectDesc.ItemName       AS DescName
            , Object_MeasureCode.isErased   AS isErased
       FROM Object AS Object_MeasureCode
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MeasureCode.DescId
       WHERE Object_MeasureCode.DescId = zc_Object_MeasureCode()
         AND (Object_MeasureCode.isErased = inisShowAll OR inisShowAll = TRUE) 
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         *
*/

-- тест
--