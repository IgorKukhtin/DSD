-- Function: gpGet_Object_MobileEmployee (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MobileEmployee2 (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Object_MobileEmployee2(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , MobileLimit TFloat
             , DutyLimit TFloat
             , Navigator TFloat
             , Comment TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , MobileTariffId Integer, MobileTariffName TVarChar
             , RegionId Integer, RegionName TVarChar
             , MobilePackId Integer, MobilePackName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MobileEmployee());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MobileEmployee()) AS Code
        
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as TFloat)     AS MobileLimit
           , CAST (0 as TFloat)     AS DutyLimit
           , CAST (0 as TFloat)     AS Navigator
          
           , CAST ('' as TVarChar)  AS Comment
    
           , CAST (0 as Integer)    AS PersonalId
           , CAST ('' as TVarChar)  AS PersonalName

           , CAST (0 as Integer)    AS MobileTariffId
           , CAST ('' as TVarChar)  AS MobileTariffName

           , CAST (0 as Integer)    AS RegionId
           , CAST ('' as TVarChar)  AS RegionName

           , CAST (0 as Integer)    AS MobilePackId
           , CAST ('' as TVarChar)  AS MobilePackName 

           , CAST (NULL AS Boolean) AS isErased
;
   ELSE
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

           , Object_Region.Id                  AS RegionId
           , Object_Region.ValueData           AS RegionName 

           , Object_MobilePack.Id              AS MobilePackId
           , Object_MobilePack.ValueData       AS MobilePackName 

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

            LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_Region
                                 ON ObjectLink_MobileEmployee_Region.ObjectId = Object_MobileEmployee.Id 
                                AND ObjectLink_MobileEmployee_Region.DescId = zc_ObjectLink_MobileEmployee_Region()
            LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_MobileEmployee_Region.ChildObjectId   

            LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_MobilePack
                                 ON ObjectLink_MobileEmployee_MobilePack.ObjectId = Object_MobileEmployee.Id 
                                AND ObjectLink_MobileEmployee_MobilePack.DescId = zc_ObjectLink_MobileEmployee_MobilePack()
            LEFT JOIN Object AS Object_MobilePack ON Object_MobilePack.Id = ObjectLink_MobileEmployee_MobilePack.ChildObjectId  

       WHERE Object_MobileEmployee.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.16         * parce
 23.09.16         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MobileEmployee2 (0, inSession := '5')
