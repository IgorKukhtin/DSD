-- Function: gpGet_Object_Quality (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Quality (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Quality(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NumberPrint Tfloat, MemberMain TVarChar, MemberTech TVarChar
             , Comment TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , RetailId Integer, RetailName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Quality());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Quality()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as TFloat)    AS NumberPrint

           , CAST ('' as TVarChar)  AS MemberMain
           , CAST ('' as TVarChar)  AS MemberTech

           , CAST ('' as TVarChar)  AS Comment

           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (0 as Integer)    AS RetailId
           , CAST ('' as TVarChar)  AS RetailName

           , CAST (0 as Integer)    AS TradeMarkId
           , CAST ('' as TVarChar)  AS TradeMarkName

           , CAST (NULL AS Boolean) AS isErased

       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Quality.Id              AS Id
           , Object_Quality.ObjectCode      AS Code
           , Object_Quality.ValueData       AS Name

           , ObjectFloat_NumberPrint.ValueData AS NumberPrint

           , ObjectString_MemberMain.ValueData AS MemberMain
           , ObjectString_MemberTech.ValueData AS MemberTech

           , ObjectString_Comment.ValueData AS Comment
         
           , Object_Juridical.Id            AS JuridicalId
           , Object_Juridical.ValueData     AS JuridicalName

           , Object_Retail.Id               AS RetailId
           , Object_Retail.ValueData        AS RetailName

           , Object_TradeMark.Id            AS TradeMarkId
           , Object_TradeMark.ValueData     AS TradeMarkName

           , Object_Quality.isErased        AS isErased
           
       FROM Object AS Object_Quality

            LEFT JOIN ObjectFloat AS ObjectFloat_NumberPrint
                                  ON ObjectFloat_NumberPrint.ObjectId = Object_Quality.Id 
                                 AND ObjectFloat_NumberPrint.DescId = zc_ObjectFloat_Quality_NumberPrint()    

            LEFT JOIN ObjectString AS ObjectString_MemberMain
                                  ON ObjectString_MemberMain.ObjectId = Object_Quality.Id 
                                 AND ObjectString_MemberMain.DescId = zc_ObjectString_Quality_MemberMain()    
            LEFT JOIN ObjectString AS ObjectString_MemberTech
                                  ON ObjectString_MemberTech.ObjectId = Object_Quality.Id 
                                 AND ObjectString_MemberTech.DescId = zc_ObjectString_Quality_MemberTech()  

            LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_Quality.Id 
                                 AND ObjectString_Comment.DescId = zc_ObjectString_Quality_Comment()
                                 
            LEFT JOIN ObjectLink AS ObjectLink_Quality_Juridical
                                 ON ObjectLink_Quality_Juridical.ObjectId = Object_Quality.Id
                                AND ObjectLink_Quality_Juridical.DescId = zc_ObjectLink_Quality_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Quality_Juridical.ChildObjectId
          
            LEFT JOIN ObjectLink AS ObjectLink_Quality_Retail
                                 ON ObjectLink_Quality_Retail.ObjectId = Object_Quality.Id
                                AND ObjectLink_Quality_Retail.DescId = zc_ObjectLink_Quality_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Quality_Retail.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Quality_TradeMark
                                 ON ObjectLink_Quality_TradeMark.ObjectId = Object_Quality.Id
                                AND ObjectLink_Quality_TradeMark.DescId = zc_ObjectLink_Quality_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Quality_TradeMark.ChildObjectId

       WHERE Object_Quality.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_Quality (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.15         * add
 05.02.15         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_Quality (348596, inSession := '5')
