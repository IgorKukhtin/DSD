-- Function: gpGet_Object_Juridical()

--DROP FUNCTION gpGet_Object_Juridical();

CREATE OR REPLACE FUNCTION gpGet_Object_Juridical(
    IN inId          Integer,       -- Касса 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, GLNCode TVarChar,
               isCorporate Boolean, JuridicalGroupName TVarChar, JuridicalGroupId Integer, 
               GoodsPropertyName TVarChar, GoodsPropertyId Integer) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());
     
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST ('' as TVarChar)  AS GLNCode
           , CAST ('' as TVarChar)  AS isCorporate
           , CAST ('' as TVarChar)  AS JuridicalGroupName
           , CAST (0 as Integer)    AS JuridicalGroupId
           , CAST ('' as TVarChar)  AS GoodsPropertyName
           , CAST (0 as Integer)    AS GoodsPropertyId          
       FROM Object 
       WHERE Object.DescId = zc_Object_Juridical();
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id                       AS Id
           , Object.ObjectCode               AS Code
           , Object.ValueData                AS Name
           , Object.isErased                 AS isErased
           , Juridical_GLNCode.ValueData     AS GLNCode
           , Juridical_isCorporate.ValueData AS isCorporate
           , JuridicalGroup.ValueData        AS JuridicalGroupName
           , JuridicalGroup.Id               AS JuridicalGroupId
           , GoodsProperty.ValueData         AS GoodsPropertyName
           , GoodsProperty.Id                AS GoodsPropertyId
       FROM Object
  LEFT JOIN ObjectString AS Juridical_GLNCode 
         ON Juridical_GLNCode.ObjectId = Object.Id AND Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
  LEFT JOIN ObjectBoolean AS Juridical_isCorporate
         ON Juridical_isCorporate.ObjectId = Object.Id AND Juridical_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
  LEFT JOIN ObjectLink AS Juridical_JuridicalGroup
         ON Juridical_JuridicalGroup.ObjectId = Object.Id AND Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
  LEFT JOIN Object AS JuridicalGroup
         ON JuridicalGroup.Id = Juridical_JuridicalGroup.ChildObjectId
  LEFT JOIN ObjectLink AS Juridical_GoodsProperty
         ON Juridical_GoodsProperty.ObjectId = Object.Id AND Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
  LEFT JOIN Object AS GoodsProperty
         ON GoodsProperty.Id = Juridical_GoodsProperty.ChildObjectId
       WHERE Object.Id = inId;
   END IF;      
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Juridical(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.13          *
 14.05.13                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Juridical('2')