-- Function: gpSelect_Object_Quality_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Quality (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Quality(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NumberPrint Tfloat, MemberMain TVarChar, MemberTech TVarChar
             , Comment TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , RetailId Integer, RetailName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , isErased boolean
     
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Quality());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Quality.Id              AS Id
           , Object_Quality.ObjectCode      AS Code
           , Object_Quality.ValueData       AS Name
           
           , ObjectFloat_NumberPrint.ValueData AS NumberPrint

           , ObjectString_MemberMain.ValueData AS MemberMain
           , ObjectString_MemberTech.ValueData AS MemberTech
           , ObjectString_Comment.ValueData    AS Comment
          
           , Object_Juridical.Id            AS JuridicalId
           , Object_Juridical.ObjectCode    AS JuridicalCode
           , Object_Juridical.ValueData     AS JuridicalName

           , Object_Retail.Id               AS RetailId
           , Object_Retail.ValueData        AS RetailName

           , Object_TradeMark.Id            AS TradeMarkId
           , Object_TradeMark.ValueData     AS TradeMarkName

           , Object_Quality.isErased        AS isErased

    FROM Object AS Object_Quality
           -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_Quality.AccessKeyId
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
             
     WHERE Object_Quality.DescId = zc_Object_Quality()
       --AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Quality (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.15         * add
 09.02.15         * 
        
*/

-- тест
--SELECT * FROM gpSelect_Object_Quality (zfCalc_UserAdmin())

