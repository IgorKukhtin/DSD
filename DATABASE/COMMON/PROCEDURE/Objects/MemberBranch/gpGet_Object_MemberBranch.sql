-- Function: gpGet_Object_MemberBranch(integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MemberBranch (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberBranch(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               BranchId Integer, BranchCode Integer, BranchName TVarChar,
               MemberId Integer, MemberCode Integer, MemberName TVarChar,
               Comment TVarChar
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MemberBranch());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
         
           , CAST (0 as Integer)   AS BranchId
           , CAST (0 as Integer)   AS BranchCode
           , CAST ('' as TVarChar) AS BranchName

           , CAST (0 as Integer)   AS MemberId  
           , CAST (0 as Integer)   AS MemberCode
           , CAST ('' as TVarChar) AS MemberName

           , CAST ('' AS TVarChar) AS Comment
       ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_MemberBranch.Id   AS Id

         , Object_Branch.Id         AS BranchId
         , Object_Branch.ObjectCode AS BranchCode
         , Object_Branch.ValueData  AS BranchName

         , Object_Member.Id         AS MemberId
         , Object_Member.ObjectCode AS MemberCode
         , Object_Member.ValueData  AS MemberName
         
         , ObjectString_Comment.ValueData AS Comment

     FROM Object AS Object_MemberBranch

          LEFT JOIN ObjectLink AS ObjectLink_MemberBranch_Branch
                               ON ObjectLink_MemberBranch_Branch.ObjectId = Object_MemberBranch.Id
                              AND ObjectLink_MemberBranch_Branch.DescId = zc_ObjectLink_MemberBranch_Branch()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_MemberBranch_Branch.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_MemberBranch_Member
                               ON ObjectLink_MemberBranch_Member.ObjectId = Object_MemberBranch.Id
                              AND ObjectLink_MemberBranch_Member.DescId = zc_ObjectLink_MemberBranch_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_MemberBranch_Member.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_MemberBranch.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_MemberBranch_Comment()

     WHERE Object_MemberBranch.Id = inId;
     
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.18         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberBranch (100, '2')
