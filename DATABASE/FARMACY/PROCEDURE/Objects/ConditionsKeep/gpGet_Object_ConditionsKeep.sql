-- Function: gpGet_Object_ConditionsKeep (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ConditionsKeep (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ConditionsKeep(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             , RelatedProductId Integer, RelatedProductName TVarChar) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ConditionsKeep());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ConditionsKeep()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)    AS RelatedProductId
           , CAST ('' as TVarChar)  AS RelatedProductName;
   ELSE
       RETURN QUERY 
       SELECT Object_ConditionsKeep.Id          AS Id
            , Object_ConditionsKeep.ObjectCode  AS Code
            , Object_ConditionsKeep.ValueData   AS Name
            , Object_ConditionsKeep.isErased    AS isErased
            , ObjectFloat_RelatedProduct.ValueData::Integer  AS RelatedProductId
            , MS_RelatedProduct_Comment.ValueData            AS RelatedProductName 
       FROM Object AS Object_ConditionsKeep
       
            LEFT JOIN ObjectFloat AS ObjectFloat_RelatedProduct
                                  ON ObjectFloat_RelatedProduct.ObjectId = Object_ConditionsKeep.Id
                                 AND ObjectFloat_RelatedProduct.DescId = zc_ObjectFloat_ConditionsKeep_RelatedProduct()
            LEFT JOIN MovementString AS MS_RelatedProduct_Comment
                                     ON MS_RelatedProduct_Comment.MovementId = ObjectFloat_RelatedProduct.ValueData
                                    AND MS_RelatedProduct_Comment.DescId = zc_MovementString_Comment()

       WHERE Object_ConditionsKeep.Id = inId;
   END IF;
   
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 14.10.18                                                      *
 07.01.17         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_ConditionsKeep(0,'2')