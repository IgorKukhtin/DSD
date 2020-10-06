-- Function: gpSelect_Object_MemberBranch()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberBranch ( Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberBranch(
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               BranchId Integer, BranchCode Integer, BranchName TVarChar,
               MemberId Integer, MemberCode Integer, MemberName TVarChar,
               Comment TVarChar,
               isErased Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberBranch());

   RETURN QUERY 
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

     SELECT Object_MemberBranch.Id        AS Id
     
          , Object_Branch.Id              AS BranchId
          , Object_Branch.ObjectCode      AS BranchCode
          , Object_Branch.ValueData       AS BranchName

          , Object_Member.Id              AS MemberId
          , Object_Member.ObjectCode      AS MemberCode
          , Object_Member.ValueData       AS MemberName
 
          , ObjectString_Comment.ValueData  AS Comment
          , Object_MemberBranch.isErased    AS isErased

     FROM Object AS Object_MemberBranch
          INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_MemberBranch.isErased

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_MemberBranch.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_MemberBranch_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_MemberBranch_Member
                               ON ObjectLink_MemberBranch_Member.ObjectId = Object_MemberBranch.Id
                              AND ObjectLink_MemberBranch_Member.DescId = zc_ObjectLink_MemberBranch_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_MemberBranch_Member.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_MemberBranch_Branch
                               ON ObjectLink_MemberBranch_Branch.ObjectId = Object_MemberBranch.Id
                              AND ObjectLink_MemberBranch_Branch.DescId = zc_ObjectLink_MemberBranch_Branch()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_MemberBranch_Branch.ChildObjectId
              
     WHERE Object_MemberBranch.DescId = zc_Object_MemberBranch()
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberBranch (FALSE, '2') 
