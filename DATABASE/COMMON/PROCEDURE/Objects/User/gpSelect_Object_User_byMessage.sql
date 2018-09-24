-- Function: gpSelect_Object_User_byMessage (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_User_byMessage (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User_byMessage(
    IN inMovementId  Integer ,
    IN inIsQuestion  Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , MemberId Integer, MemberName TVarChar
             , BranchCode Integer
             , BranchName TVarChar
             , UnitCode Integer
             , UnitName TVarChar
             , PositionName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- Результат
   IF inIsQuestion = FALSE
   THEN
       RETURN QUERY 
       WITH tmpPersonal AS (SELECT View_Personal.MemberId
                                 , MAX (View_Personal.UnitId) AS UnitId
                                 , MAX (View_Personal.PositionId) AS PositionId
                            FROM Object_Personal_View AS View_Personal
                            WHERE View_Personal.isErased = FALSE
                            GROUP BY View_Personal.MemberId
                           )
       SELECT 
             Object_User.Id
           , Object_User.ObjectCode
           , Object_User.ValueData
           , Object_User.isErased
           , Object_Member.Id AS MemberId
           , Object_Member.ValueData AS MemberName
    
           , Object_Branch.ObjectCode  AS BranchCode
           , Object_Branch.ValueData   AS BranchName
           , Object_Unit.ObjectCode    AS UnitCode
           , Object_Unit.ValueData     AS UnitName
           , Object_Position.ValueData AS PositionName
    
       FROM Object AS Object_User
            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
    
            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
    
       WHERE Object_User.DescId = zc_Object_User();
   ELSE
       RETURN QUERY 
       WITH tmpPersonal AS (SELECT View_Personal.MemberId
                                 , MAX (View_Personal.UnitId) AS UnitId
                                 , MAX (View_Personal.PositionId) AS PositionId
                            FROM Object_Personal_View AS View_Personal
                            WHERE View_Personal.isErased = FALSE
                            GROUP BY View_Personal.MemberId
                           )
          , tmpUser AS (SELECT DISTINCT MILO_Insert.ObjectId AS UserId
                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                              ON MILO_Insert.MovementItemId = MovementItem.Id
                                                             AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Message()
                          AND MovementItem.Amount     IN (1,3)     --все кто завадал вопрос
                        )
       SELECT 
             Object_User.Id
           , Object_User.ObjectCode
           , Object_User.ValueData
           , Object_User.isErased
           , Object_Member.Id AS MemberId
           , Object_Member.ValueData AS MemberName

           , Object_Branch.ObjectCode  AS BranchCode
           , Object_Branch.ValueData   AS BranchName
           , Object_Unit.ObjectCode    AS UnitCode
           , Object_Unit.ValueData     AS UnitName
           , Object_Position.ValueData AS PositionName
    
       FROM tmpUser
            LEFT JOIN Object AS Object_User ON Object_User.Id = tmpUser.UserId

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
    
            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
           ;

   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.18         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_User_byMessage (5285316, TRUE, '5'::TVarChar)
-- SELECT * FROM gpSelect_Object_User_byMessage (5285316, FALSE, '5'::TVarChar)