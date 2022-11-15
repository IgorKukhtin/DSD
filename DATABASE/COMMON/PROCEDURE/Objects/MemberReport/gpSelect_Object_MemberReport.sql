-- Function: gpSelect_Object_MemberReport()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberReport (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberReport (
    IN inisShowAll            Boolean,
    IN inisErased             Boolean,  
    IN inSession              TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MemberReport());

   IF inisShowAll THEN
    
   RETURN QUERY 
   WITH
    tmpMember AS (SELECT *
                  FROM Object AS Object_Member
                  WHERE Object_Member.DescId = zc_Object_Member()
                     AND (Object_Member.isErased = inisErased OR inisErased = TRUE)
                 )
  , tmpMemberReport AS (SELECT Object_MemberReport.Id
                             , Object_MemberReport.isErased
                             , ObjectLink_From.ChildObjectId     AS FromId
                             , ObjectLink_To.ChildObjectId       AS ToId
                             , ObjectLink_Member.ChildObjectId   AS MemberId
                        FROM Object AS Object_MemberReport   
                            LEFT JOIN ObjectLink AS ObjectLink_From
                                                 ON ObjectLink_From.DescId = zc_ObjectLink_MemberReport_From()
                                                AND ObjectLink_From.ObjectId = Object_MemberReport.Id
                            LEFT JOIN ObjectLink AS ObjectLink_To
                                                 ON ObjectLink_To.DescId = zc_ObjectLink_MemberReport_To()
                                                AND ObjectLink_To.ObjectId = Object_MemberReport.Id
                            LEFT JOIN ObjectLink AS ObjectLink_Member
                                                 ON ObjectLink_Member.DescId = zc_ObjectLink_MemberReport_Member()
                                                AND ObjectLink_Member.ObjectId = Object_MemberReport.Id
                        WHERE Object_MemberReport.DescId = zc_Object_MemberReport()
                          AND (Object_MemberReport.isErased = inisErased OR inisErased = TRUE)
                        )

    SELECT Object_MemberReport.Id     AS Id

         , Object_Member.Id           AS MemberId
         , Object_Member.ObjectCode   AS MemberCode
         , Object_Member.ValueData    AS MemberName
         , Object_From.Id             AS FromId
         , Object_From.ObjectCode     AS FromCode
         , Object_From.ValueData      AS FromName
         , Object_To.Id               AS ToId
         , Object_To.ObjectCode       AS ToCode
         , Object_To.ValueData        AS ToName
         , ObjectString_Comment.ValueData AS Comment
         , Object_MemberReport.isErased AS isErased
        
    FROM tmpMemberReport AS Object_MemberReport
        
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = Object_MemberReport.MemberId
         LEFT JOIN Object AS Object_From ON Object_From.Id = Object_MemberReport.FromId
         LEFT JOIN Object AS Object_To ON Object_To.Id = Object_MemberReport.ToId 

         LEFT JOIN ObjectString AS ObjectString_Comment
                                ON ObjectString_Comment.DescId = zc_ObjectString_MemberReport_Comment()
                               AND ObjectString_Comment.ObjectId = Object_MemberReport.Id
   UNION
    SELECT 0                 AS Id

         , Object_Member.Id           AS MemberId
         , Object_Member.ObjectCode   AS MemberCode
         , Object_Member.ValueData    AS MemberName
         , 0                 AS FromId
         , 0                 AS FromCode
         , ''::TVarChar      AS FromName
         , 0                 AS ToId
         , 0                 AS ToCode
         , ''::TVarChar      AS ToName
         , ''::TVarChar      AS Comment
         , FALSE AS isErased
    FROM tmpMember AS Object_Member
         LEFT JOIN tmpMemberReport ON tmpMemberReport.MemberId = Object_Member.Id
    WHERE tmpMemberReport.MemberId IS NULL;


   ELSE
   -- Результат другой
   RETURN QUERY
    SELECT Object_MemberReport.Id     AS Id

         , Object_Member.Id           AS MemberId
         , Object_Member.ObjectCode   AS MemberCode
         , Object_Member.ValueData    AS MemberName
         , Object_From.Id             AS FromId
         , Object_From.ObjectCode     AS FromCode
         , Object_From.ValueData      AS FromName
         , Object_To.Id               AS ToId
         , Object_To.ObjectCode       AS ToCode
         , Object_To.ValueData        AS ToName
         , ObjectString_Comment.ValueData AS Comment
         , Object_MemberReport.isErased AS isErased
    FROM Object AS Object_MemberReport   
        LEFT JOIN ObjectLink AS ObjectLink_From
                             ON ObjectLink_From.DescId = zc_ObjectLink_MemberReport_From()
                            AND ObjectLink_From.ObjectId = Object_MemberReport.Id
        LEFT JOIN Object AS Object_From ON Object_From.Id = ObjectLink_From.ObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_To
                             ON ObjectLink_To.DescId = zc_ObjectLink_MemberReport_To()
                            AND ObjectLink_To.ObjectId = Object_MemberReport.Id
        LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_To.ObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Member
                             ON ObjectLink_Member.DescId = zc_ObjectLink_MemberReport_Member()
                            AND ObjectLink_Member.ObjectId = Object_MemberReport.Id
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Member.ObjectId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.DescId = zc_ObjectString_MemberReport_Comment()
                              AND ObjectString_Comment.ObjectId = Object_MemberReport.Id
    WHERE Object_MemberReport.DescId = zc_Object_MemberReport()
      AND (Object_MemberReport.isErased = inisErased OR inisErased = TRUE);
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.22         *
*/

-- тест
--SELECT * FROM gpSelect_Object_MemberReport (true, true, '2'::TVarChar)

