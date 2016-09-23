-- Function: gpSelect_Object_MobileEmployee (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MobileEmployee2 (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MobileEmployee2(
    IN inShowAll     Boolean, 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , MobileLimit TFloat
             , DutyLimit TFloat
             , Navigator TFloat
             , Comment TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , MobileTariffId Integer, MobileTariffName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_MobileEmployee());
     vbUserId:= lpGetUserBySession (inSession);
    
     -- Результат
     RETURN QUERY 
       SELECT 
             Object_MobileEmployee.Id          AS Id
           , Object_MobileEmployee.ObjectCode  AS Code
           , Object_MobileEmployee.ValueData   AS Name
           
           , ObjectFloat_Limit.ValueData       AS MobileLimit
           , ObjectFloat_DutyLimit.ValueData   AS DutyLimit
           , ObjectFloat_Navigator.ValueData   AS Navigator

           , ObjectString_Comment.ValueData    AS Comment 
         
           , Object_Personal.Id                AS PersonalId
           , Object_Personal.ValueData         AS PersonalName 
           
           , Object_MobileTariff.Id            AS MobileTariffId
           , Object_MobileTariff.ValueData     AS MobileTariffName 

           , Object_MobileEmployee.isErased    AS isErased
           
       FROM Object AS Object_MobileEmployee
       
            LEFT JOIN ObjectFloat AS ObjectFloat_Limit
                                  ON ObjectFloat_Limit.ObjectId = Object_MobileEmployee.Id 
                                 AND ObjectFloat_Limit.DescId = zc_ObjectFloat_MobileEmployee_Limit()
            LEFT JOIN ObjectFloat AS ObjectFloat_DutyLimit
                                  ON ObjectFloat_DutyLimit.ObjectId = Object_MobileEmployee.Id 
                                 AND ObjectFloat_DutyLimit.DescId = zc_ObjectFloat_MobileEmployee_DutyLimit()
            LEFT JOIN ObjectFloat AS ObjectFloat_Navigator
                                  ON ObjectFloat_Navigator.ObjectId = Object_MobileEmployee.Id 
                                 AND ObjectFloat_Navigator.DescId = zc_ObjectFloat_MobileEmployee_Navigator()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_MobileEmployee.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_MobileEmployee_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_Personal
                                 ON ObjectLink_MobileEmployee_Personal.ObjectId = Object_MobileEmployee.Id 
                                AND ObjectLink_MobileEmployee_Personal.DescId = zc_ObjectLink_MobileEmployee_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_MobileEmployee_Personal.ChildObjectId                               

            LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_MobileTariff
                                 ON ObjectLink_MobileEmployee_MobileTariff.ObjectId = Object_MobileEmployee.Id 
                                AND ObjectLink_MobileEmployee_MobileTariff.DescId = zc_ObjectLink_MobileEmployee_MobileTariff()
            LEFT JOIN Object AS Object_MobileTariff ON Object_MobileTariff.Id = ObjectLink_MobileEmployee_MobileTariff.ChildObjectId                               

     WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
       AND (Object_MobileEmployee.isErased = inShowAll OR inShowAll = True)
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.16         *
*/

-- тест
--SELECT * FROM gpSelect_Object_MobileEmployee2 (TRUE,zfCalc_UserAdmin())
