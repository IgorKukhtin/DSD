-- Function: gpSelect_MovementItem_WagesVIP()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WagesVIP (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WagesVIP(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UserID Integer
             , MemberCode Integer, MemberName TVarChar
             , AmountAccrued TFloat
             , HoursWork TFloat

             , isIssuedBy Boolean, DateIssuedBy TDateTime
             , isErased Boolean
             , Color_Calc Integer
              )
AS
$BODY$
    DECLARE vbUserId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY

            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID

                 , Object_Member.ObjectCode           AS MemberCode
                 , Object_Member.ValueData            AS MemberName

                 , MovementItem.Amount                AS AmountAccrued
                 
                 , MIFloat_HoursWork.ValueData        AS HoursWork

                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                 , MIDate_IssuedBy.ValueData                                AS DateIssuedBy

                 , MovementItem.isErased              AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  MovementItem


                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId


                  LEFT JOIN MovementItemFloat AS MIFloat_HoursWork
                                              ON MIFloat_HoursWork.MovementItemId = MovementItem.Id
                                             AND MIFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                             ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                            AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                                                  
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
            UNION ALL
            SELECT 0                                  AS Id
                 , ObjectUser.Id                      AS UserId 

                 , Object_Member.ObjectCode           AS MemberCode
                 , Object_Member.ValueData            AS MemberName

                 , 0::TFloat                          AS AmountAccrued
                 
                 , 0::TFloat                          AS HoursWork

                 , False                              AS isIssuedBy
                 , Null::TDateTime                    AS DateIssuedBy

                 , False                              AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM ObjectLink AS ObjectLink_UserRole_Role
                         
                 INNER JOIN ObjectLink AS ObjectLink_UserRole_User 
                                       ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                                      AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()

                 INNER JOIN Object AS ObjectUser 
                                   ON ObjectUser.Id = ObjectLink_UserRole_User.ChildObjectId
                                  AND ObjectUser.isErased = False

                 LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                      ON ObjectLink_User_Member.ObjectId = ObjectUser.Id
                                     AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                 LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

            WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
              AND ObjectLink_UserRole_Role.ChildObjectId = zc_Enum_Role_VIPManager()
              AND ObjectUser.Id NOT IN (SELECT MovementItem.ObjectId FROM MovementItem
                                        WHERE MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId = zc_MI_Master())
	    ;
    ELSE
        -- Результат другой
        RETURN QUERY

            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID

                 , Object_Member.ObjectCode           AS MemberCode
                 , Object_Member.ValueData            AS MemberName

                 , MovementItem.Amount                AS AmountAccrued
                 
                 , MIFloat_HoursWork.ValueData        AS HoursWork

                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                 , MIDate_IssuedBy.ValueData                                AS DateIssuedBy

                 , MovementItem.isErased              AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  MovementItem


                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId


                  LEFT JOIN MovementItemFloat AS MIFloat_HoursWork
                                              ON MIFloat_HoursWork.MovementItemId = MovementItem.Id
                                             AND MIFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                             ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                            AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                                                  
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
            ;

     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.09.21                                                        *
*/
-- 
select * from gpSelect_MovementItem_WagesVIP(inMovementId := 24892120 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');