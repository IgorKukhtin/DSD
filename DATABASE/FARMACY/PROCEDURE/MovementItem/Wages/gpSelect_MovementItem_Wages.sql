-- Function: gpSelect_MovementItem_Wages()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Wages (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Wages(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UserID Integer, AmountAccrued TFloat
             , HolidaysHospital TFloat, Marketing TFloat, MarketingRepayment TFloat, Director TFloat, IlliquidAssets TFloat
             , IlliquidAssetsRepayment TFloat, PenaltySUN TFloat, PenaltyExam TFloat, ApplicationAward TFloat
             , AmountCard TFloat, AmountHand TFloat
             , MemberCode Integer, MemberName TVarChar, PositionName TVarChar
             , isManagerPharmacy boolean
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , TestingStatus TVarChar,  TestingDate TDateTime, TestingAttempts Integer
             , isIssuedBy Boolean, DateIssuedBy TDateTime
             , isErased Boolean
             , Color_Calc Integer
             , Color_Testing Integer
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
            WITH
                tmpPersonal_View AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Personal_View.IsErased) AS Ord
                                          , Object_User.Id                      AS UserID
                                          , Object_Personal_View.MemberId       AS MemberId
                                          , Object_Personal_View.PositionName   AS PositionName
                                          , Object_Personal_View.UnitId         AS UnitId
                                     FROM Object AS Object_User

                                          INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                          LEFT JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                                     WHERE Object_User.DescId = zc_Object_User()),
                tmpMember AS (SELECT
                                       Object_Member.Id                   AS MemberId
                                     , ObjectLink_User_Member.ObjectId    AS UserID
                                     , Object_Member.isErased             AS isErased
                                FROM Object AS Object_Member

                                     INNER JOIN ObjectLink AS ObjectLink_Member_Unit
                                                           ON ObjectLink_Member_Unit.ObjectId = Object_Member.Id
                                                          AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()
                                                          AND COALESCE(ObjectLink_Member_Unit.ChildObjectId, 0) <> 0

                                     INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                         ON ObjectLink_User_Member.ChildObjectId = Object_Member.Id
                                                         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                                         AND ObjectLink_User_Member.ObjectId  NOT IN (SELECT MovementItem.ObjectId FROM  MovementItem  WHERE MovementItem.MovementId = inMovementId)

                                WHERE Object_Member.DescId = zc_Object_Member()
                                  AND Object_Member.isErased = FALSE),
                tmpAdditionalExpenses AS (SELECT MovementItem.Id                                          AS ID
                                               , MovementItem.ObjectId                                    AS UnitID
                                               , MovementItem.Amount                                      AS SummaTotal
                                               , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                                               , MIDate_IssuedBy.ValueData                                AS DateIssuedBy

                                               , MovementItem.isErased                                    AS isErased
                                          FROM  MovementItem

                                                LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                                              ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                                                             AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                                                LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                                                           ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                                                          AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                                          WHERE MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId = zc_MI_Sign()
                                            AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                            AND MovementItem.Amount <> 0),
                tmpTestingUser AS (SELECT * FROM gpReport_TestingUser ((SELECT Movement.OperDate FROM Movement WHERE  Movement.Id = inMovementId), inSession))

            SELECT 0                                  AS Id
                 , tmpMember.UserID                   AS UserID
                 , NULL::TFloat                       AS Amount

                 , Null::TFloat                       AS HolidaysHospital
                 , Null::TFloat                       AS Marketing
                 , Null::TFloat                       AS MarketingRepayment
                 , Null::TFloat                       AS Director
                 , Null::TFloat                       AS IlliquidAssets
                 , Null::TFloat                       AS IlliquidAssetsRepayment
                 , Null::TFloat                       AS PenaltySUN
                 , Null::TFloat                       AS PenaltyExam
                 , Null::TFloat                       AS ApplicationAward
                 , NULL::TFloat                       AS AmountCard
                 , NULL::TFloat                       AS AmountHand

                 , Object_Member.ObjectCode           AS MemberCode
                 , COALESCE (ObjectString_NameUkr.ValueData, Object_Member.ValueData) AS MemberName
                 , Personal_View.PositionName         AS PositionName
                 , COALESCE (ObjectBoolean_ManagerPharmacy.ValueData, False)  AS isManagerPharmacy
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , NULL::TVarChar                     AS TestingStatus
                 , NULL::TDateTime                    AS TestingDate
                 , NULL::Integer                      AS TestingAttempts

                 , False                              AS isIssuedBy
                 , NULL::TDateTime                    AS DateIssuedBy
                 , tmpMember.isErased                 AS isErased
                 , zc_Color_Black()                   AS Color_Calc
                 , zc_Color_White()                   AS Color_Testing
            FROM  tmpMember
                  INNER JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = tmpMember.UserID
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  INNER JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                  LEFT JOIN ObjectString AS ObjectString_NameUkr
                                         ON ObjectString_NameUkr.ObjectId = Object_Member.Id
                                        AND ObjectString_NameUkr.DescId = zc_ObjectString_Member_NameUkr()

                  LEFT JOIN tmpPersonal_View AS Personal_View
                                             ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId
                                            AND Personal_View.Ord = 1

                  LEFT JOIN ObjectBoolean AS ObjectBoolean_ManagerPharmacy
                                          ON ObjectBoolean_ManagerPharmacy.ObjectId = ObjectLink_User_Member.ChildObjectId
                                         AND ObjectBoolean_ManagerPharmacy.DescId = zc_ObjectBoolean_Member_ManagerPharmacy()

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Personal_View.UnitID

                  LEFT JOIN tmpAdditionalExpenses AS AdditionalExpenses
                                                  ON AdditionalExpenses.UnitID = Object_Unit.ID
            UNION ALL
            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , MovementItem.Amount                AS AmountAccrued

                 , MIFloat_HolidaysHospital.ValueData AS HolidaysHospital
                 , MIFloat_Marketing.ValueData        AS Marketing
                 , CASE WHEN COALESCE(MIFloat_Marketing.ValueData, 0) > 0 THEN 0
                        WHEN COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0) > 0
                        THEN - MIFloat_Marketing.ValueData ELSE MIFloat_MarketingRepayment.ValueData END::TFloat      AS MarketingRepayment
                 , MIFloat_Director.ValueData         AS Director
                 , MIFloat_IlliquidAssets.ValueData   AS IlliquidAssets
                 , CASE WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) > 0 THEN 0
                        WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0) > 0
                        THEN - MIFloat_IlliquidAssets.ValueData ELSE MIFloat_IlliquidAssetsRepayment.ValueData END::TFloat      AS IlliquidAssetsRepayment
                 , MIFloat_PenaltySUN.ValueData       AS PenaltySUN
                 , MIFloat_PenaltyExam.ValueData      AS PenaltyExam
                 , MIFloat_ApplicationAward.ValueData AS ApplicationAward
                 , MIF_AmountCard.ValueData           AS AmountCard
                 , (MovementItem.Amount +
                    COALESCE (MIFloat_HolidaysHospital.ValueData, 0) +
                    CASE WHEN COALESCE(MIFloat_Marketing.ValueData, 0) > 0 THEN COALESCE(MIFloat_Marketing.ValueData, 0)
                         WHEN COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0) > 0
                         THEN 0 ELSE COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0)  END +
                    COALESCE (MIFloat_Director.ValueData, 0) +
                    CASE WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) > 0 THEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0)
                         WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0) > 0
                         THEN 0 ELSE COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0)  END +
                    COALESCE (MIFloat_PenaltySUN.ValueData, 0) +
                    COALESCE (MIFloat_PenaltyExam.ValueData, 0) +
                    COALESCE (MIFloat_ApplicationAward.ValueData, 0) -
                    COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand

                 , Object_Member.ObjectCode           AS MemberCode
                 , COALESCE (ObjectString_NameUkr.ValueData, Object_Member.ValueData) AS MemberName
                 , Object_Position.ValueData          AS PositionName
                 , COALESCE (ObjectBoolean_ManagerPharmacy.ValueData, False)  AS isManagerPharmacy
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , CASE WHEN MIBoolean_isTestingUser.ValueData IS NULL 
                        THEN TestingUser.Status      
                        ELSE CASE WHEN MIBoolean_isTestingUser.ValueData = TRUE THEN 'Сдан' ELSE 'Не сдан' END END::TVarChar AS TestingStatus
                 , date_trunc('day', TestingUser.DateTimeTest)::TDateTime   AS TestingDate
                 , TestingUser.Attempts                                     AS TestingAttempts

                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                 , MIDate_IssuedBy.ValueData                                AS DateIssuedBy

                 , MovementItem.isErased              AS isErased
                 , zc_Color_Black()                   AS Color_Calc
                 ,  CASE WHEN MIBoolean_isTestingUser.ValueData IS NULL 
                        THEN zc_Color_White() ELSE zc_Color_Yelow() END     AS Color_Testing
            FROM  MovementItem

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId
                  LEFT JOIN ObjectString AS ObjectString_NameUkr
                                         ON ObjectString_NameUkr.ObjectId = Object_Member.Id
                                        AND ObjectString_NameUkr.DescId = zc_ObjectString_Member_NameUkr()

                  LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                       ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                      AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()

                  LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                       ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                      AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

                  LEFT JOIN tmpPersonal_View AS Personal_View
                                             ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId
                                            AND COALESCE (Personal_View.UserID, MovementItem.ObjectId) =  MovementItem.ObjectId
                                            AND Personal_View.Ord = 1

                  LEFT JOIN ObjectBoolean AS ObjectBoolean_ManagerPharmacy
                                          ON ObjectBoolean_ManagerPharmacy.ObjectId = ObjectLink_User_Member.ChildObjectId
                                         AND ObjectBoolean_ManagerPharmacy.DescId = zc_ObjectBoolean_Member_ManagerPharmacy()

                  LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId, Personal_View.UnitID)

                  LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                              ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                             AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

                  LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                              ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                             AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

                  LEFT JOIN MovementItemFloat AS MIFloat_MarketingRepayment
                                              ON MIFloat_MarketingRepayment.MovementItemId = MovementItem.Id
                                             AND MIFloat_MarketingRepayment.DescId = zc_MIFloat_MarketingRepayment()

                  LEFT JOIN MovementItemFloat AS MIFloat_Director
                                              ON MIFloat_Director.MovementItemId = MovementItem.Id
                                             AND MIFloat_Director.DescId = zc_MIFloat_Director()
                                             
                  LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssets
                                              ON MIFloat_IlliquidAssets.MovementItemId = MovementItem.Id
                                             AND MIFloat_IlliquidAssets.DescId = zc_MIFloat_SummaIlliquidAssets()

                  LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssetsRepayment
                                              ON MIFloat_IlliquidAssetsRepayment.MovementItemId = MovementItem.Id
                                             AND MIFloat_IlliquidAssetsRepayment.DescId = zc_MIFloat_IlliquidAssetsRepayment()

                  LEFT JOIN MovementItemFloat AS MIFloat_PenaltySUN
                                              ON MIFloat_PenaltySUN.MovementItemId = MovementItem.Id
                                             AND MIFloat_PenaltySUN.DescId = zc_MIFloat_PenaltySUN()

                  LEFT JOIN MovementItemFloat AS MIFloat_PenaltyExam
                                              ON MIFloat_PenaltyExam.MovementItemId = MovementItem.Id
                                             AND MIFloat_PenaltyExam.DescId = zc_MIFloat_PenaltyExam()

                  LEFT JOIN MovementItemFloat AS MIFloat_ApplicationAward
                                              ON MIFloat_ApplicationAward.MovementItemId = MovementItem.Id
                                             AND MIFloat_ApplicationAward.DescId = zc_MIFloat_ApplicationAward()

                  LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                              ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                             AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                             ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                            AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isTestingUser
                                                ON MIBoolean_isTestingUser.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isTestingUser.DescId = zc_MIBoolean_isTestingUser()

                  LEFT JOIN tmpAdditionalExpenses AS AdditionalExpenses
                                                  ON AdditionalExpenses.UnitID = Object_Unit.ID

                  LEFT JOIN tmpTestingUser AS TestingUser 
                                           ON TestingUser.ID = MovementItem.ObjectId   

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
            UNION ALL
            SELECT tmpAdditionalExpenses.ID           AS Id
                 , Null::Integer                      AS UserID
                 , tmpAdditionalExpenses.SummaTotal   AS AmountAccrued

                 , Null::TFloat                       AS HolidaysHospital
                 , Null::TFloat                       AS Marketing
                 , Null::TFloat                       AS MarketingRepayment
                 , Null::TFloat                       AS Director
                 , Null::TFloat                       AS IlliquidAssets
                 , Null::TFloat                       AS IlliquidAssetsRepayment
                 , Null::TFloat                       AS PenaltySUN
                 , Null::TFloat                       AS PenaltyExam
                 , Null::TFloat                       AS ApplicationAward
                 , Null::TFloat                       AS AmountCard
                 , tmpAdditionalExpenses.SummaTotal   AS AmountHand

                 , Null::Integer                      AS MemberCode
                 , 'Дополнительные расходы'::TVarChar AS MemberName
                 , Null::TVarChar                     AS PositionName
                 , False                              AS isManagerPharmacy
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , NULL::TVarChar                     AS TestingStatus
                 , NULL::TDateTime                    AS TestingDate
                 , NULL::Integer                      AS TestingAttempts
                 
                 , tmpAdditionalExpenses.isIssuedBy   AS isIssuedBy
                 , tmpAdditionalExpenses.DateIssuedBy AS DateIssuedBy

                 , tmpAdditionalExpenses.isErased     AS isErased
                 , zc_Color_Black()                   AS Color_Calc
                 , zc_Color_White()                   AS Color_Testing
            FROM  tmpAdditionalExpenses

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAdditionalExpenses.UnitID
            ;
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH
                tmpPersonal_View AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Personal_View.IsErased) AS Ord
                                          , Object_User.Id                      AS UserID
                                          , Object_Personal_View.MemberId       AS MemberId
                                          , Object_Personal_View.PositionName   AS PositionName
                                          , Object_Personal_View.UnitId         AS UnitId
                                     FROM Object AS Object_User

                                          INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                          INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                                     WHERE Object_User.DescId = zc_Object_User())
              , tmpAdditionalExpenses AS (SELECT MovementItem.Id                                          AS ID
                                               , MovementItem.ObjectId                                    AS UnitID
                                               , MovementItem.Amount                                      AS SummaTotal
                                               , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                                               , MIDate_IssuedBy.ValueData                                AS DateIssuedBy

                                               , MovementItem.isErased                                    AS isErased
                                          FROM  MovementItem

                                                LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                                              ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                                                             AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                                                LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                                                           ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                                                          AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                                          WHERE MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId = zc_MI_Sign()
                                            AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                            AND MovementItem.Amount <> 0)
              , tmpTestingUser AS (SELECT * FROM gpReport_TestingUser ((SELECT Movement.OperDate FROM Movement WHERE  Movement.Id = inMovementId), inSession))

            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , MovementItem.Amount                AS AmountAccrued

                 , MIFloat_HolidaysHospital.ValueData AS HolidaysHospital
                 , MIFloat_Marketing.ValueData        AS Marketing
                 , CASE WHEN COALESCE(MIFloat_Marketing.ValueData, 0) > 0 THEN 0
                        WHEN COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0) > 0
                        THEN - MIFloat_Marketing.ValueData ELSE MIFloat_MarketingRepayment.ValueData END::TFloat      AS MarketingRepayment
                 , MIFloat_Director.ValueData         AS Director
                 , MIFloat_IlliquidAssets.ValueData   AS IlliquidAssets
                 , CASE WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) > 0 THEN 0
                        WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0) > 0
                        THEN - MIFloat_IlliquidAssets.ValueData ELSE MIFloat_IlliquidAssetsRepayment.ValueData END::TFloat      AS IlliquidAssetsRepayment
                 , MIFloat_PenaltySUN.ValueData       AS PenaltySUN
                 , MIFloat_PenaltyExam.ValueData      AS PenaltyExam
                 , MIFloat_ApplicationAward.ValueData AS ApplicationAward
                 , MIF_AmountCard.ValueData           AS AmountCard
                 , (MovementItem.Amount +
                    COALESCE (MIFloat_HolidaysHospital.ValueData, 0) +
                    CASE WHEN COALESCE(MIFloat_Marketing.ValueData, 0) > 0 THEN COALESCE(MIFloat_Marketing.ValueData, 0)
                         WHEN COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0) > 0
                         THEN 0 ELSE COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0)  END +
                    COALESCE (MIFloat_Director.ValueData, 0) +
                    CASE WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) > 0 THEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0)
                         WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0) > 0
                         THEN 0 ELSE COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0)  END +
                    COALESCE (MIFloat_PenaltyExam.ValueData, 0) +
                    COALESCE (MIFloat_ApplicationAward.ValueData, 0) +
                    COALESCE (MIFloat_PenaltySUN.ValueData, 0) -
                    COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand

                 , Object_Member.ObjectCode           AS MemberCode
                 , COALESCE (ObjectString_NameUkr.ValueData, Object_Member.ValueData) AS MemberName
                 , Object_Position.ValueData          AS PositionName
                 , COALESCE (ObjectBoolean_ManagerPharmacy.ValueData, False)  AS isManagerPharmacy
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , CASE WHEN MIBoolean_isTestingUser.ValueData IS NULL 
                        THEN TestingUser.Status      
                        ELSE CASE WHEN MIBoolean_isTestingUser.ValueData = TRUE THEN 'Сдан' ELSE 'Не сдан' END END::TVarChar AS TestingStatus
                 , date_trunc('day', TestingUser.DateTimeTest)::TDateTime   AS TestingDate
                 , TestingUser.Attempts                                     AS TestingAttempts
                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                 , MIDate_IssuedBy.ValueData                                AS DateIssuedBy

                 , MovementItem.isErased              AS isErased
                 , zc_Color_Black()                   AS Color_Calc
                 ,  CASE WHEN MIBoolean_isTestingUser.ValueData IS NULL 
                        THEN zc_Color_White() ELSE zc_Color_Yelow() END     AS Color_Testing
            FROM  MovementItem

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId
                  LEFT JOIN ObjectString AS ObjectString_NameUkr
                                         ON ObjectString_NameUkr.ObjectId = Object_Member.Id
                                        AND ObjectString_NameUkr.DescId = zc_ObjectString_Member_NameUkr()

                  LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                       ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                      AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                  LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

                  LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                       ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                      AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

                  LEFT JOIN tmpPersonal_View AS Personal_View
                                             ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId
                                            AND COALESCE (Personal_View.UserID, MovementItem.ObjectId) =  MovementItem.ObjectId
                                            AND Personal_View.Ord = 1

                  LEFT JOIN ObjectBoolean AS ObjectBoolean_ManagerPharmacy
                                          ON ObjectBoolean_ManagerPharmacy.ObjectId = ObjectLink_User_Member.ChildObjectId
                                         AND ObjectBoolean_ManagerPharmacy.DescId = zc_ObjectBoolean_Member_ManagerPharmacy()


                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId, Personal_View.UnitID)

                  LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                              ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                             AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

                  LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                              ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                             AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

                  LEFT JOIN MovementItemFloat AS MIFloat_MarketingRepayment
                                              ON MIFloat_MarketingRepayment.MovementItemId = MovementItem.Id
                                             AND MIFloat_MarketingRepayment.DescId = zc_MIFloat_MarketingRepayment()

                  LEFT JOIN MovementItemFloat AS MIFloat_Director
                                              ON MIFloat_Director.MovementItemId = MovementItem.Id
                                             AND MIFloat_Director.DescId = zc_MIFloat_Director()

                  LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssets
                                              ON MIFloat_IlliquidAssets.MovementItemId = MovementItem.Id
                                             AND MIFloat_IlliquidAssets.DescId = zc_MIFloat_SummaIlliquidAssets()

                  LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssetsRepayment
                                              ON MIFloat_IlliquidAssetsRepayment.MovementItemId = MovementItem.Id
                                             AND MIFloat_IlliquidAssetsRepayment.DescId = zc_MIFloat_IlliquidAssetsRepayment()

                  LEFT JOIN MovementItemFloat AS MIFloat_PenaltySUN
                                              ON MIFloat_PenaltySUN.MovementItemId = MovementItem.Id
                                             AND MIFloat_PenaltySUN.DescId = zc_MIFloat_PenaltySUN()

                  LEFT JOIN MovementItemFloat AS MIFloat_PenaltyExam
                                              ON MIFloat_PenaltyExam.MovementItemId = MovementItem.Id
                                             AND MIFloat_PenaltyExam.DescId = zc_MIFloat_PenaltyExam()

                  LEFT JOIN MovementItemFloat AS MIFloat_ApplicationAward
                                              ON MIFloat_ApplicationAward.MovementItemId = MovementItem.Id
                                             AND MIFloat_ApplicationAward.DescId = zc_MIFloat_ApplicationAward()

                  LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                              ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                             AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                             ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                            AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isTestingUser
                                                ON MIBoolean_isTestingUser.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isTestingUser.DescId = zc_MIBoolean_isTestingUser()

                  LEFT JOIN tmpAdditionalExpenses AS AdditionalExpenses
                                                  ON AdditionalExpenses.UnitID = Object_Unit.ID
                                                  
                  LEFT JOIN tmpTestingUser AS TestingUser 
                                           ON TestingUser.ID = MovementItem.ObjectId   

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
            UNION ALL
            SELECT tmpAdditionalExpenses.ID           AS Id
                 , Null::Integer                      AS UserID
                 , tmpAdditionalExpenses.SummaTotal   AS AmountAccrued

                 , Null::TFloat                       AS HolidaysHospital
                 , Null::TFloat                       AS Marketing
                 , Null::TFloat                       AS MarketingRepayment                 
                 , Null::TFloat                       AS Director
                 , Null::TFloat                       AS IlliquidAssets
                 , Null::TFloat                       AS IlliquidAssetsRepayment
                 , Null::TFloat                       AS PenaltySUN
                 , Null::TFloat                       AS PenaltyExam
                 , Null::TFloat                       AS ApplicationAward
                 , Null::TFloat                       AS AmountCard
                 , tmpAdditionalExpenses.SummaTotal   AS AmountHand

                 , Null::Integer                      AS MemberCode
                 , 'Дополнительные расходы'::TVarChar AS MemberName
                 , Null::TVarChar                     AS PositionName
                 , False                              AS isManagerPharmacy
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , NULL::TVarChar                     AS TestingStatus
                 , NULL::TDateTime                    AS TestingDate
                 , NULL::Integer                      AS TestingAttempts

                 , tmpAdditionalExpenses.isIssuedBy   AS isIssuedBy
                 , tmpAdditionalExpenses.DateIssuedBy AS DateIssuedBy

                 , tmpAdditionalExpenses.isErased     AS isErased
                 , zc_Color_Black()                   AS Color_Calc
                 , zc_Color_White()                   AS Color_Testing
            FROM  tmpAdditionalExpenses

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAdditionalExpenses.UnitID
            ;

     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.09.20                                                        *
 11.01.20                                                        *
 24.10.19                                                        *
 21.08.19                                                        *
*/
-- select * from gpSelect_MovementItem_Wages(inMovementId := 15869587   , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');

select * from gpSelect_MovementItem_Wages(inMovementId := 27991034 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');
