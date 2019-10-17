-- Function: gpGet_Object_LabMark()

DROP FUNCTION IF EXISTS gpGet_Object_LabMark (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_LabMark(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , LabProductId Integer, LabProductName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_LabMark());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_LabMark()) AS Code
           , CAST ('' AS TVarChar)  AS Name
           , 0                      AS LabProductId
           , CAST ('' AS TVarChar)  AS LabProductName
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_LabMark.Id           AS Id
           , Object_LabMark.ObjectCode   AS Code
           , Object_LabMark.ValueData    AS Name
           , Object_LabProduct.Id        AS LabProductId
           , Object_LabProduct.ValueData AS LabProductName
           , Object_LabMark.isErased     AS isErased
       FROM Object AS Object_LabMark
            LEFT JOIN ObjectLink AS ObjectLink_LabMark_LabProduct
                                 ON ObjectLink_LabMark_LabProduct.ObjectId = Object_LabMark.Id
                                AND ObjectLink_LabMark_LabProduct.DescId = zc_ObjectLink_LabMark_LabProduct()
            LEFT JOIN Object AS Object_LabProduct ON Object_LabProduct.Id = ObjectLink_LabMark_LabProduct.ChildObjectId
       WHERE Object_LabMark.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.19         *
*/

-- тест
-- SELECT * FROM gpGet_Object_LabMark (0, '2')