-- Function: gpGet_Object_MemberReport(Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MemberReport(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_MemberReport(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberReport(
    IN inId                       Integer,       -- ключ объекта <> 
    IN inMaskId                   Integer,
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , MemberId Integer, MemberName TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , Comment TVarChar
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());


   IF COALESCE (inId, 0) = 0 AND COALESCE (inMaskId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , CAST (0 as Integer)     AS MemberId
           , CAST ('' as TVarChar)   AS MemberName
           , CAST (0 as Integer)     AS FromId
           , CAST ('' as TVarChar)   AS FromName
           , CAST (0 as Integer)     AS ToId
           , CAST ('' as TVarChar)   AS ToName
           , CAST ('' as TVarChar)   AS Comment
       ;

   ELSE
       RETURN QUERY 
       SELECT CASE WHEN inMaskId <> 0 THEN 0 ELSE Object_MemberReport.Id END :: Integer AS Id
            , Object_Member.Id           AS MemberId
            , Object_Member.ValueData    AS MemberName
            , Object_From.Id             AS FromId
            , Object_From.ValueData      AS FromName
            , Object_To.Id               AS ToId
            , Object_To.ValueData        AS ToName
            , ObjectString_Comment.ValueData AS Comment
       FROM Object AS Object_MemberReport   
           LEFT JOIN ObjectLink AS ObjectLink_From
                                ON ObjectLink_From.DescId = zc_ObjectLink_MemberReport_From()
                               AND ObjectLink_From.ObjectId = Object_MemberReport.Id
           LEFT JOIN Object AS Object_From ON Object_From.Id = ObjectLink_From.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_To
                                ON ObjectLink_To.DescId = zc_ObjectLink_MemberReport_To()
                               AND ObjectLink_To.ObjectId = Object_MemberReport.Id
           LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_To.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_Member
                                ON ObjectLink_Member.DescId = zc_ObjectLink_MemberReport_Member()
                               AND ObjectLink_Member.ObjectId = Object_MemberReport.Id
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Member.ChildObjectId

           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.DescId = zc_ObjectString_MemberReport_Comment()
                                 AND ObjectString_Comment.ObjectId = Object_MemberReport.Id
       WHERE Object_MemberReport.DescId = zc_Object_MemberReport()
         AND Object_MemberReport.Id = CASE WHEN COALESCE (inId, 0) = 0 THEN inMaskId ELSE inId END;
   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.22         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberReport(1,0,'2')