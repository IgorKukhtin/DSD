-- Function: gpSelect_Object_LabMark()

DROP FUNCTION IF EXISTS gpSelect_Object_LabMark(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_LabMark(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , LabProductId Integer, LabProductCode Integer, LabProductName TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_LabMark());

   RETURN QUERY 
   SELECT 
     Object_LabMark.Id            AS Id 
   , Object_LabMark.ObjectCode    AS Code
   , Object_LabMark.ValueData     AS Name
   , Object_LabProduct.Id         AS LabProductId
   , Object_LabProduct.ObjectCode AS LabProductCode
   , Object_LabProduct.ValueData  AS LabProductName
   , Object_LabMark.isErased      AS isErased
   FROM Object AS Object_LabMark
        LEFT JOIN ObjectLink AS ObjectLink_LabMark_LabProduct
                             ON ObjectLink_LabMark_LabProduct.ObjectId = Object_LabMark.Id
                            AND ObjectLink_LabMark_LabProduct.DescId = zc_ObjectLink_LabMark_LabProduct()
        LEFT JOIN Object AS Object_LabProduct ON Object_LabProduct.Id = ObjectLink_LabMark_LabProduct.ChildObjectId
   WHERE Object_LabMark.DescId = zc_Object_LabMark();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_LabMark(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.19          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_LabMark('2')