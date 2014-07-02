-- Function: gpGet_Object_JuridicalGoodsCode()

DROP FUNCTION IF EXISTS gpGet_Object_JuridicalGoodsCode(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_JuridicalGoodsCode(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               GoodsMainId Integer, GoodsMainName TVarChar,
               ObjectId Integer, ObjectName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_JuridicalGoodsCode());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_JuridicalGoodsCode()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS GoodsMainId
           , CAST ('' as TVarChar) AS GoodsMainName 
           
           , CAST (0 as Integer)   AS ObjectId
           , CAST ('' as TVarChar) AS ObjectName
      
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_JuridicalGoodsCode.Id           AS Id
           , Object_JuridicalGoodsCode.ObjectCode   AS Code
           , Object_JuridicalGoodsCode.ValueData    AS Name
         
           , Object_GoodsMain.Id         AS GoodsMainId
           , Object_GoodsMain.ValueData  AS GoodsMainName 

           , Object_Object.Id         AS ObjectId
           , Object_Object.ValueData  AS ObjectName          
           
           , Object_JuridicalGoodsCode.isErased       AS isErased
           
       FROM Object AS Object_JuridicalGoodsCode
           LEFT JOIN ObjectLink AS ObjectLink_JuridicalGoodsCode_GoodsMain
                                ON ObjectLink_JuridicalGoodsCode_GoodsMain.ObjectId = Object_JuridicalGoodsCode.Id
                               AND ObjectLink_JuridicalGoodsCode_GoodsMain.DescId = zc_ObjectLink_JuridicalGoodsCode_GoodsMain()
           LEFT JOIN Object AS Object_GoodsMain ON Object_GoodsMain.Id = ObjectLink_JuridicalGoodsCode_GoodsMain.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_JuridicalGoodsCode_Object
                                ON ObjectLink_JuridicalGoodsCode_Object.ObjectId = Object_JuridicalGoodsCode.Id
                               AND ObjectLink_JuridicalGoodsCode_Object.DescId = zc_ObjectLink_JuridicalGoodsCode_Object()
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_JuridicalGoodsCode_Object.ChildObjectId  

      WHERE Object_JuridicalGoodsCode.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_JuridicalGoodsCode (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_JuridicalGoodsCode(0,'2')