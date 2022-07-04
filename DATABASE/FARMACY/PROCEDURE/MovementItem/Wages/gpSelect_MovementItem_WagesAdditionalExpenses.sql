-- Function: gpSelect_MovementItem_WagesAdditionalExpenses()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WagesAdditionalExpenses (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WagesAdditionalExpenses(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , SummaCleaning TFloat, SummaSP TFloat, SummaOther TFloat, SummaValidationResults TFloat, SummaIntentionalPeresort TFloat
             , SummaSUN1 TFloat, SummaOrderConfirmation TFloat, SummaIC TFloat, SummaFine TFloat
             , SummaTechnicalRediscount TFloat, SummaMoneyBox TFloat, SummaFullCharge TFloat, SummaFullChargeFact TFloat, SummaMoneyBoxUsed TFloat, SummaMoneyBoxResidual TFloat
             , SummaTotal TFloat
             , isIssuedBy Boolean, MIDateIssuedBy TDateTime
             , Comment TVarChar
             , isErased Boolean
             , Color_Calc Integer
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStartDate   TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    SELECT Movement.OperDate
    INTO vbStartDate
    FROM Movement
    WHERE Movement.ID = inMovementId;

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
                tmpPersonal AS (SELECT
                                       Object_Personal.Id                 AS PersonalId
                                     , ObjectLink_User_Member.ObjectId    AS UserID
                                     , Object_Personal.isErased           AS isErased
                                FROM Object AS Object_Personal

                                     INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                          ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                         AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                                     INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                         ON ObjectLink_User_Member.ChildObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                                         AND ObjectLink_User_Member.ObjectId  NOT IN (SELECT MovementItem.ObjectId FROM  MovementItem  WHERE MovementItem.MovementId = inMovementId)

                                WHERE Object_Personal.DescId = zc_Object_Personal()
                                  AND Object_Personal.isErased = FALSE),
                tmpTechnicalRediscount AS (SELECT MovementLinkObject_Unit.ObjectId                              AS UnitId
                                                , SUM(COALESCE (MovementFloat_SummaManual.ValueData,
                                                                MovementFloat_TotalDiffSumm.ValueData))::TFloat AS SummWages
                                           FROM Movement

                                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                                LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                                                          ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                                                         AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
                                                LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                                                          ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                                                         AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()
                                                                         
                                                LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiffSumm
                                                                              ON MovementFloat_TotalDiffSumm.MovementId = Movement.Id
                                                                             AND MovementFloat_TotalDiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()
                                                LEFT OUTER JOIN MovementFloat AS MovementFloat_SummaManual
                                                                              ON MovementFloat_SummaManual.MovementId = Movement.Id
                                                                             AND MovementFloat_SummaManual.DescId = zc_MovementFloat_SummaManual()

                                           WHERE Movement.OperDate BETWEEN date_trunc('month', vbStartDate) AND date_trunc('month', vbStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                             AND Movement.DescId = zc_Movement_TechnicalRediscount()
                                             AND Movement.StatusId = zc_Enum_Status_Complete()
                                             AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = False
                                             AND COALESCE (MovementBoolean_Adjustment.ValueData, False) = False
                                           GROUP BY MovementLinkObject_Unit.ObjectId),
                tmpFullCharge AS (SELECT MovementLinkObject_Unit.ObjectId                              AS UnitId
                                       , SUM(-1.0 * MovementFloat_TotalSummFrom.ValueData)::TFloat            AS SummWages
                                  FROM Movement

                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()

                                       INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                    AND MovementLinkObject_To.ObjectId = 11299914 

                                       LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                 ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                                         
                                       LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                                               ON MovementFloat_TotalSummFrom.MovementId =  Movement.Id
                                                              AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()
 
                                  WHERE Movement.OperDate >= date_trunc('month', vbStartDate) AND vbStartDate = '01.03.2020'
                                    AND Movement.DescId = zc_Movement_Send()
                                    AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    AND COALESCE (MovementBoolean_Deferred.ValueData, False) = True
                                  GROUP BY MovementLinkObject_Unit.ObjectId),
                tmpFoundPositionsSUN AS (SELECT T1.UnitId
                                              , SUM(T1.SummaFine)::TFloat   AS SummaFine
                                         FROM gpReport_FoundPositionsSUN (date_trunc('month', vbStartDate), 
                                                                          date_trunc('month', vbStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', 
                                                                          inSession) AS T1
                                         GROUP BY T1.UnitId)

            SELECT 0                                  AS Id
                 , Object_Unit.Id                     AS UserID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName

                 , NULL::TFloat                       AS SummaCleaning
                 , NULL::TFloat                       AS SummaSP
                 , NULL::TFloat                       AS SummaOther
                 , NULL::TFloat                       AS SummaValidationResults
                 , NULL::TFloat                       AS SummaIntentionalPeresort
                 , NULL::TFloat                       AS SummaSUN1
                 , NULL::TFloat                       AS SummaOrderConfirmation
                 , NULL::TFloat                       AS SummaIC
                 , NULL::TFloat                       AS SummaFine 
                 , NULL::TFloat                       AS SummaTechnicalRediscount
                 , NULL::TFloat                       AS SummaMoneyBox
                 , NULL::TFloat                       AS SummaFullCharge
                 , NULL::TFloat                       AS SummaFullChargeFact
                 , NULL::TFloat                       AS SummaMoneyBoxUsed
                 , NULL::TFloat                       AS SummaTotal
                 , NULL::TFloat                       AS SummaMoneyBoxResidual

                 , False                              AS isIssuedBy
                 , NULL::TDateTime                    AS DateIssuedBy
                 , NULL::TVarChar                     AS Comment

                 , Object_Unit.isErased               AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM Object AS Object_Unit
                 INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                                       ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                      AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                                      AND COALESCE(ObjectLink_Unit_Parent.ChildObjectId, 0) <> 0
            WHERE Object_Unit.DescId = zc_Object_Unit()
              AND (inIsErased = True OR Object_Unit.isErased = False)
              AND Object_Unit.ID NOT IN (SELECT MovementItem.ObjectId
                                         FROM  MovementItem
                                         WHERE MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId = zc_MI_Sign())
            UNION ALL
            SELECT MovementItem.Id                       AS Id
                 , MovementItem.ObjectId                 AS UnitID
                 , Object_Unit.ObjectCode                AS UnitCode
                 , Object_Unit.ValueData                 AS UnitName

                 , MIFloat_SummaCleaning.ValueData       AS SummaCleaning
                 , MIFloat_SummaSP.ValueData             AS SummaSP
                 , MIFloat_SummaOther.ValueData          AS SummaOther
                 , MIFloat_ValidationResults.ValueData   AS SummaValidationResults
                 , MIFloat_IntentionalPeresort.ValueData AS SummaIntentionalPeresort
                 , MIFloat_SummaSUN1.ValueData           AS SummaSUN1
                 , MIFloat_SummaOrderConfirmation.ValueData AS SummaOrderConfirmation
                 , MIFloat_SummaIC.ValueData                AS SummaIC
                 , FoundPositionsSUN.SummaFine              AS SummaFine
--                 , tmpTechnicalRediscount.SummWages    AS SummaTechnicalRediscount
                 , MIFloat_SummaTechnicalRediscount.ValueData         AS SummaTechnicalRediscount
                 , CASE WHEN COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) > 0 THEN 
                   COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) END::TFloat AS SummaMoneyBox
                 , COALESCE(tmpFullCharge.SummWages, COALESCE(MIFloat_SummaFullCharge.ValueData, 0) + 
                                                     COALESCE(MIFloat_SummaFullChargeMonth.ValueData, 0))::TFloat               AS SummaFullCharge
                 , MIFloat_SummaFullChargeFact.ValueData                                                                        AS SummaFullChargeFact
                 , MIFloat_SummaMoneyBoxUsed.ValueData AS SummaMoneyBoxUsed
                 , CASE WHEN COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) > 0 THEN 
                   COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) - COALESCE(MIFloat_SummaMoneyBoxUsed.ValueData, 0) END::TFloat AS SummaMoneyBoxResidual

                 , MovementItem.Amount                 AS SummaTotal

                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                 , MIDate_IssuedBy.ValueData            AS DateIssuedBy
                 , MIS_Comment.ValueData                AS Comment

                 , MovementItem.isErased               AS isErased
                 , zc_Color_Black()                    AS Color_Calc
            FROM  MovementItem


                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaning
                                              ON MIFloat_SummaCleaning.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaCleaning.DescId = zc_MIFloat_SummaCleaning()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaSP
                                              ON MIFloat_SummaSP.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaSP.DescId = zc_MIFloat_SummaSP()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaOther
                                              ON MIFloat_SummaOther.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaOther.DescId = zc_MIFloat_SummaOther()

                  LEFT JOIN MovementItemFloat AS MIFloat_ValidationResults
                                              ON MIFloat_ValidationResults.MovementItemId = MovementItem.Id
                                             AND MIFloat_ValidationResults.DescId = zc_MIFloat_ValidationResults()

                  LEFT JOIN MovementItemFloat AS MIFloat_IntentionalPeresort
                                              ON MIFloat_IntentionalPeresort.MovementItemId = MovementItem.Id
                                             AND MIFloat_IntentionalPeresort.DescId = zc_MIFloat_IntentionalPeresort()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaSUN1
                                              ON MIFloat_SummaSUN1.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaSUN1.DescId = zc_MIFloat_SummaSUN1()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaOrderConfirmation
                                              ON MIFloat_SummaOrderConfirmation.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaOrderConfirmation.DescId = zc_MIFloat_SummaOrderConfirmation()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaTechnicalRediscount
                                              ON MIFloat_SummaTechnicalRediscount.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaTechnicalRediscount.DescId = zc_MIFloat_SummaTechnicalRediscount()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaMoneyBox
                                              ON MIFloat_SummaMoneyBox.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaMoneyBox.DescId = zc_MIFloat_SummaMoneyBox()
                  LEFT JOIN MovementItemFloat AS MIFloat_SummaMoneyBoxMonth
                                              ON MIFloat_SummaMoneyBoxMonth.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaMoneyBoxMonth.DescId = zc_MIFloat_SummaMoneyBoxMonth()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaFullCharge
                                              ON MIFloat_SummaFullCharge.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaFullCharge.DescId = zc_MIFloat_SummaFullCharge()
                  LEFT JOIN MovementItemFloat AS MIFloat_SummaFullChargeMonth
                                              ON MIFloat_SummaFullChargeMonth.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaFullChargeMonth.DescId = zc_MIFloat_SummaFullChargeMonth()
                  LEFT JOIN MovementItemFloat AS MIFloat_SummaFullChargeFact
                                              ON MIFloat_SummaFullChargeFact.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaFullChargeFact.DescId = zc_MIFloat_SummaFullChargeFact()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaMoneyBoxUsed
                                              ON MIFloat_SummaMoneyBoxUsed.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaMoneyBoxUsed.DescId = zc_MIFloat_SummaMoneyBoxUsed()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaIC
                                              ON MIFloat_SummaIC.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaIC.DescId = zc_MIFloat_SummaIC()

--                  LEFT JOIN tmpTechnicalRediscount ON tmpTechnicalRediscount.UnitID = MovementItem.ObjectId
                  LEFT JOIN tmpFullCharge ON tmpFullCharge.UnitID = MovementItem.ObjectId
                  
                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                             ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                            AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                  LEFT JOIN MovementItemString AS MIS_Comment
                                               ON MIS_Comment.MovementItemId = MovementItem.Id
                                              AND MIS_Comment.DescId = zc_MIString_Comment()

                  LEFT JOIN tmpFoundPositionsSUN AS FoundPositionsSUN
                                                 ON FoundPositionsSUN.UnitID = MovementItem.ObjectId

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Sign()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
            ORDER BY 4;
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH
                tmpTechnicalRediscount AS (SELECT MovementLinkObject_Unit.ObjectId                              AS UnitId
                                                , SUM(COALESCE (MovementFloat_SummaManual.ValueData,
                                                                MovementFloat_TotalDiffSumm.ValueData))::TFloat AS SummWages
                                           FROM Movement

                                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                                LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                                                          ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                                                         AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
                                                LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                                                          ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                                                         AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()
                                                                         
                                                LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiffSumm
                                                                              ON MovementFloat_TotalDiffSumm.MovementId = Movement.Id
                                                                             AND MovementFloat_TotalDiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()
                                                LEFT OUTER JOIN MovementFloat AS MovementFloat_SummaManual
                                                                              ON MovementFloat_SummaManual.MovementId = Movement.Id
                                                                             AND MovementFloat_SummaManual.DescId = zc_MovementFloat_SummaManual()

                                           WHERE Movement.OperDate BETWEEN date_trunc('month', vbStartDate) AND date_trunc('month', vbStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                             AND Movement.DescId = zc_Movement_TechnicalRediscount()
                                             AND Movement.StatusId = zc_Enum_Status_Complete()
                                             AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = False
                                             AND COALESCE (MovementBoolean_Adjustment.ValueData, False) = False
                                           GROUP BY MovementLinkObject_Unit.ObjectId),
                tmpFullCharge AS (SELECT MovementLinkObject_Unit.ObjectId                              AS UnitId
                                       , SUM(-1.0 * MovementFloat_TotalSummFrom.ValueData)::TFloat     AS SummWages
                                  FROM Movement

                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()

                                       INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                    AND MovementLinkObject_To.ObjectId = 11299914 

                                       LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                 ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                                         
                                       LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                                               ON MovementFloat_TotalSummFrom.MovementId =  Movement.Id
                                                              AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()
 
                                  WHERE Movement.OperDate >= date_trunc('month', vbStartDate) AND vbStartDate = '01.03.2020'
                                    AND Movement.DescId = zc_Movement_Send()
                                    AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    AND COALESCE (MovementBoolean_Deferred.ValueData, False) = True
                                  GROUP BY MovementLinkObject_Unit.ObjectId),
                tmpFoundPositionsSUN AS (SELECT T1.UnitId
                                              , SUM(T1.SummaFine)::TFloat   AS SummaFine
                                         FROM gpReport_FoundPositionsSUN (date_trunc('month', vbStartDate), 
                                                                          date_trunc('month', vbStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', 
                                                                          inSession) AS T1
                                         GROUP BY T1.UnitId)
                                           
            SELECT MovementItem.Id                     AS Id
                 , MovementItem.ObjectId               AS UnitID
                 , Object_Unit.ObjectCode              AS UnitCode
                 , Object_Unit.ValueData               AS UnitName

                 , MIFloat_SummaCleaning.ValueData     AS SummaCleaning
                 , MIFloat_SummaSP.ValueData           AS SummaSP
                 , MIFloat_SummaOther.ValueData        AS SummaOther
                 , MIFloat_ValidationResults.ValueData AS SummaValidationResults
                 , MIFloat_IntentionalPeresort.ValueData AS SummaIntentionalPeresort
                 , MIFloat_SummaSUN1.ValueData         AS SummaSUN1
                 , MIFloat_SummaOrderConfirmation.ValueData AS SummaOrderConfirmation
                 , MIFloat_SummaIC.ValueData    AS SummaIC
                 , FoundPositionsSUN.SummaFine         AS SummaFine
                 , tmpTechnicalRediscount.SummWages    AS SummaTechnicalRediscount
--                 , MIFloat_SummaTechnicalRediscount.ValueData         AS SummaTechnicalRediscount
                 , CASE WHEN COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) > 0 THEN 
                   COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) END::TFloat AS SummaMoneyBox
                 , COALESCE(tmpFullCharge.SummWages, COALESCE(MIFloat_SummaFullCharge.ValueData, 0) + 
                                                     COALESCE(MIFloat_SummaFullChargeMonth.ValueData, 0))::TFloat               AS SummaFullCharge
                 , MIFloat_SummaFullChargeFact.ValueData                                                                        AS SummaFullChargeFact
                 , MIFloat_SummaMoneyBoxUsed.ValueData AS SummaMoneyBoxUsed
                 , CASE WHEN COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) > 0 THEN 
                   COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) - COALESCE(MIFloat_SummaMoneyBoxUsed.ValueData, 0) END::TFloat AS SummaMoneyBoxResidual

                 , MovementItem.Amount                 AS SummaTotal

                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                 , MIDate_IssuedBy.ValueData           AS DateIssuedBy
                 , MIS_Comment.ValueData               AS Comment

                 , MovementItem.isErased               AS isErased
                 , zc_Color_Black()                    AS Color_Calc
            FROM  MovementItem


                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaning
                                              ON MIFloat_SummaCleaning.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaCleaning.DescId = zc_MIFloat_SummaCleaning()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaSP
                                              ON MIFloat_SummaSP.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaSP.DescId = zc_MIFloat_SummaSP()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaOther
                                              ON MIFloat_SummaOther.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaOther.DescId = zc_MIFloat_SummaOther()

                  LEFT JOIN MovementItemFloat AS MIFloat_ValidationResults
                                              ON MIFloat_ValidationResults.MovementItemId = MovementItem.Id
                                             AND MIFloat_ValidationResults.DescId = zc_MIFloat_ValidationResults()

                  LEFT JOIN MovementItemFloat AS MIFloat_IntentionalPeresort
                                              ON MIFloat_IntentionalPeresort.MovementItemId = MovementItem.Id
                                             AND MIFloat_IntentionalPeresort.DescId = zc_MIFloat_IntentionalPeresort()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaSUN1
                                              ON MIFloat_SummaSUN1.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaSUN1.DescId = zc_MIFloat_SummaSUN1()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaOrderConfirmation
                                              ON MIFloat_SummaOrderConfirmation.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaOrderConfirmation.DescId = zc_MIFloat_SummaOrderConfirmation()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaTechnicalRediscount
                                              ON MIFloat_SummaTechnicalRediscount.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaTechnicalRediscount.DescId = zc_MIFloat_SummaTechnicalRediscount()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaMoneyBox
                                              ON MIFloat_SummaMoneyBox.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaMoneyBox.DescId = zc_MIFloat_SummaMoneyBox()
                  LEFT JOIN MovementItemFloat AS MIFloat_SummaMoneyBoxMonth
                                              ON MIFloat_SummaMoneyBoxMonth.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaMoneyBoxMonth.DescId = zc_MIFloat_SummaMoneyBoxMonth()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaFullCharge
                                              ON MIFloat_SummaFullCharge.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaFullCharge.DescId = zc_MIFloat_SummaFullCharge()
                  LEFT JOIN MovementItemFloat AS MIFloat_SummaFullChargeMonth
                                              ON MIFloat_SummaFullChargeMonth.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaFullChargeMonth.DescId = zc_MIFloat_SummaFullChargeMonth()
                  LEFT JOIN MovementItemFloat AS MIFloat_SummaFullChargeFact
                                              ON MIFloat_SummaFullChargeFact.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaFullChargeFact.DescId = zc_MIFloat_SummaFullChargeFact()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaMoneyBoxUsed
                                              ON MIFloat_SummaMoneyBoxUsed.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaMoneyBoxUsed.DescId = zc_MIFloat_SummaMoneyBoxUsed()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaIC
                                              ON MIFloat_SummaIC.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaIC.DescId = zc_MIFloat_SummaIC()

                  LEFT JOIN tmpTechnicalRediscount ON tmpTechnicalRediscount.UnitID = MovementItem.ObjectId

                  LEFT JOIN tmpFullCharge ON tmpFullCharge.UnitID = MovementItem.ObjectId

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                             ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                            AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                  LEFT JOIN MovementItemString AS MIS_Comment
                                               ON MIS_Comment.MovementItemId = MovementItem.Id
                                              AND MIS_Comment.DescId = zc_MIString_Comment()
                                              
                  LEFT JOIN tmpFoundPositionsSUN AS FoundPositionsSUN
                                                 ON FoundPositionsSUN.UnitID = MovementItem.ObjectId

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Sign()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
            ORDER BY Object_Unit.ValueData;

     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.11.20                                                        *
 21.03.20                                                        *
 02.10.19                                                        *
 01.09.19                                                        *
*/
-- select * from gpSelect_MovementItem_WagesAdditionalExpenses(inMovementId := 17449644  , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');

select * from gpSelect_MovementItem_WagesAdditionalExpenses(inMovementId := 19723487 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');