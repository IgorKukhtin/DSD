-- Function: gpGet_MovementItem_WagesUser()

DROP FUNCTION IF EXISTS gpGet_MovementItem_WagesUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_WagesUser(
    IN inOperDate    TDateTime      , -- ключ Документа
    IN inSession     TVarChar         -- сессия пользователя
)
RETURNS TABLE (Id Integer, UserID Integer, AmountAccrued TFloat
             , HolidaysHospital TFloat, Marketing TFloat, Director TFloat, IlliquidAssets TFloat, PenaltySUN TFloat
             , AmountCard TFloat, AmountHand TFloat
             , MemberCode Integer, MemberName TVarChar, PositionName TVarChar
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , OperDate TDateTime
             , Result TFloat, Attempts Integer, Status TVarChar, DateTimeTest TDateTime
             , SummaCleaning TFloat, SummaSP TFloat, SummaOther TFloat, SummaValidationResults TFloat, SummaIntentionalPeresort TFloat, SummaSUN1 TFloat, SummaFine TFloat 
             , SummaTechnicalRediscount TFloat, SummaMoneyBox TFloat, SummaFullCharge TFloat, SummaMoneyBoxUsed TFloat
             , SummaTotal TFloat
             , PasswordEHels TVarChar
              )
AS
$BODY$
    DECLARE vbUserId        Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbUnitKey TVarChar;
    DECLARE vbMovementId    Integer;
    DECLARE vbMovementMaxId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    inOperDate := date_trunc('month', inOperDate);
    
    IF vbUserId = 3
    THEN
      vbUserId  := 4085760;
    END IF;

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_Wages())
    THEN
      SELECT MIN(Movement.ID), MAX(Movement.ID)
      INTO vbMovementId, vbMovementMaxId  
      FROM Movement 
      WHERE Movement.OperDate = inOperDate 
        AND Movement.DescId = zc_Movement_Wages();
    ELSE 
       RAISE EXCEPTION 'Не найден расчет з.п. за %', zfCalc_MonthYearName(inOperDate);
    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem 
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.ObjectId = vbUserId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE)
    THEN
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
              ,  tmpResult AS (SELECT MovementItem.Amount                                            AS Result
                                    , MovementItemFloat.ValueData::Integer                           AS Attempts
                                    , MovementItemDate.ValueData                                     AS DateTimeTest
                               FROM Movement

                                    LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                                            AND MovementFloat.DescId = zc_MovementFloat_TestingUser_Question()
                                    LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId = zc_MI_Master()

                                    LEFT JOIN MovementItemDate ON MovementItemDate.MovementItemId = MovementItem.Id
                                                               AND MovementItemDate.DescId = zc_MIDate_TestingUser()

                                    LEFT JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                                AND MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()

                               WHERE Movement.DescId = zc_Movement_TestingUser()
                                 AND Movement.OperDate = inOperDate
                                 AND MovementItem.ObjectId = vbUserId) 
              , tmpTechnicalRediscount AS (SELECT MovementLinkObject_Unit.ObjectId                              AS UnitId
                                                , SUM(COALESCE (MovementFloat_SummaManual.ValueData,
                                                                MovementFloat_TotalDiffSumm.ValueData))::TFloat AS SummWages
                                           FROM Movement

                                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                            AND MovementLinkObject_Unit.ObjectId  = vbUnitId

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

                                           WHERE Movement.OperDate BETWEEN date_trunc('month', inOperDate) AND date_trunc('month', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                             AND Movement.DescId = zc_Movement_TechnicalRediscount()
                                             AND Movement.StatusId = zc_Enum_Status_Complete()
                                             AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = False
                                             AND COALESCE (MovementBoolean_Adjustment.ValueData, False) = False
                                           GROUP BY MovementLinkObject_Unit.ObjectId)
              , tmpFullCharge AS (SELECT MovementLinkObject_Unit.ObjectId                              AS UnitId
                                       , SUM(-1.0 * MovementFloat_TotalSummFrom.ValueData)::TFloat     AS SummWages
                                  FROM Movement

                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()
                                                                    AND MovementLinkObject_Unit.ObjectId  = vbUnitId

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
 
                                  WHERE Movement.OperDate >= date_trunc('month', inOperDate) AND inOperDate = '01.03.2020'
                                    AND Movement.DescId = zc_Movement_Send()
                                    AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    AND COALESCE (MovementBoolean_Deferred.ValueData, False) = True
                                  GROUP BY MovementLinkObject_Unit.ObjectId)
              , tmpAdditionalExpenses AS (SELECT MIFloat_SummaCleaning.ValueData     AS SummaCleaning
                                               , MIFloat_SummaSP.ValueData           AS SummaSP
                                               , MIFloat_SummaOther.ValueData        AS SummaOther
                                               , MIFloat_ValidationResults.ValueData AS SummaValidationResults
                                               , MIFloat_IntentionalPeresort.ValueData AS SummaIntentionalPeresort
                                               , MIFloat_SummaSUN1.ValueData         AS SummaSUN1 
                                               , tmpTechnicalRediscount.SummWages    AS SummaTechnicalRediscount
                              --                 , MIFloat_SummaTechnicalRediscount.ValueData         AS SummaTechnicalRediscount
                                               , CASE WHEN COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) > 0 THEN 
                                                 COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) + COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) END::TFloat AS SummaMoneyBox
                                               , COALESCE(tmpFullCharge.SummWages, COALESCE(MIFloat_SummaFullCharge.ValueData, 0) + 
                                                                                   COALESCE(MIFloat_SummaFullChargeMonth.ValueData, 0))::TFloat               AS SummaFullCharge
                                               , MIFloat_SummaMoneyBoxUsed.ValueData AS SummaMoneyBoxUsed
                                               , MovementItem.Amount                 AS SummaTotal
                                         FROM  MovementItem

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
                                                                           
                                                LEFT JOIN tmpTechnicalRediscount ON tmpTechnicalRediscount.UnitID = vbUnitId

                                                LEFT JOIN tmpFullCharge ON tmpFullCharge.UnitID = vbUnitId

                                         WHERE MovementItem.MovementId = vbMovementId
                                           AND MovementItem.ObjectId = vbUnitId
                                           AND MovementItem.DescId = zc_MI_Sign()
                                           AND MovementItem.isErased = FALSE)
              , tmpFoundPositionsSUN AS (SELECT T1.UnitId
                                              , SUM(T1.SummaFine)::TFloat   AS SummaFine
                                         FROM gpReport_FoundPositionsSUN (date_trunc('month', inOperDate), 
                                                                          date_trunc('month', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', 
                                                                          inSession) AS T1
                                         GROUP BY T1.UnitId)

            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , MIAmount.Amount                    AS AmountAccrued
                 
                 , MIFloat_HolidaysHospital.ValueData AS HolidaysHospital
                 , MIFloat_Marketing.ValueData        AS Marketing
                 , MIFloat_Director.ValueData         AS Director
                 , MIFloat_IlliquidAssets.ValueData   AS IlliquidAssets
                 , MIFloat_PenaltySUN.ValueData       AS PenaltySUN
                 , MIF_AmountCard.ValueData           AS AmountCard
                 , (MIAmount.Amount +
                    COALESCE (MIFloat_HolidaysHospital.ValueData, 0) +
                    COALESCE (MIFloat_Marketing.ValueData, 0) +
                    COALESCE (MIFloat_Director.ValueData, 0) +
                    COALESCE (MIFloat_IlliquidAssets.ValueData, 0) +
                    COALESCE (MIFloat_PenaltySUN.ValueData, 0) -
                    COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand


                 , Object_Member.ObjectCode           AS MemberCode
                 , Object_Member.ValueData            AS MemberName
                 , Personal_View.PositionName         AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , inOperDate::TDateTime              AS OperDate
                 , tmpResult.Result                             AS Result
                 , tmpResult.Attempts                           AS Attempts
                 , CASE WHEN COALESCE (tmpResult.Attempts, 0) = 0
                   THEN NULL ELSE
                   CASE WHEN tmpResult.Result >= 85
                   THEN 'Сдан' ELSE 'Не сдан' END END::TVarChar AS Status
                 , tmpResult.DateTimeTest                       AS DateTimeTest
                 , tmpAdditionalExpenses.SummaCleaning          AS SummaCleaning
                 , tmpAdditionalExpenses.SummaSP                AS SummaSP
                 , tmpAdditionalExpenses.SummaOther             AS SummaOther
                 , tmpAdditionalExpenses.SummaValidationResults AS SummaValidationResults
                 , tmpAdditionalExpenses.SummaIntentionalPeresort AS SummaIntentionalPeresort
                 , tmpAdditionalExpenses.SummaSUN1              AS SummaSUN1
                 , FoundPositionsSUN.SummaFine                  AS SummaFine
                 , tmpAdditionalExpenses.SummaTechnicalRediscount AS SummaTechnicalRediscount
                 , tmpAdditionalExpenses.SummaMoneyBox          AS SummaMoneyBox
                 , tmpAdditionalExpenses.SummaFullCharge        AS SummaFullCharge
                 , tmpAdditionalExpenses.SummaMoneyBoxUsed      AS SummaMoneyBoxUsed
                 , tmpAdditionalExpenses.SummaTotal             AS SummaTotal
                 , ObjectString_PasswordEHels.ValueData          AS UserPassword
            FROM  MovementItem
            
                  LEFT JOIN MovementItem AS MIAmount
                                         ON MIAmount.MovementId = vbMovementMaxId
                                        AND MIAmount.ObjectId = vbUserId
                                        AND MIAmount.DescId = zc_MI_Master()
                                        AND MIAmount.isErased = FALSE

                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

                  LEFT JOIN tmpPersonal_View AS Personal_View
                                             ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId
                                            AND COALESCE (Personal_View.UserID, MovementItem.ObjectId) =  MovementItem.ObjectId
                                            AND Personal_View.Ord = 1

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Personal_View.UnitID

                  LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                              ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                             AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

                  LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                              ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                             AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

                  LEFT JOIN MovementItemFloat AS MIFloat_Director
                                              ON MIFloat_Director.MovementItemId = MovementItem.Id
                                             AND MIFloat_Director.DescId = zc_MIFloat_Director()

                  LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssets
                                              ON MIFloat_IlliquidAssets.MovementItemId = MovementItem.Id
                                             AND MIFloat_IlliquidAssets.DescId = zc_MIFloat_SummaIlliquidAssets()

                  LEFT JOIN MovementItemFloat AS MIFloat_PenaltySUN
                                              ON MIFloat_PenaltySUN.MovementItemId = MovementItem.Id
                                             AND MIFloat_PenaltySUN.DescId = zc_MIFloat_PenaltySUN()

                  LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                              ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                             AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()
                                             
                  LEFT JOIN tmpResult ON 1 = 1
                  
                  LEFT JOIN tmpAdditionalExpenses ON 1 = 1

                  LEFT JOIN ObjectString AS ObjectString_PasswordEHels
                         ON ObjectString_PasswordEHels.DescId = zc_ObjectString_User_Helsi_PasswordEHels() 
                        AND ObjectString_PasswordEHels.ObjectId = vbUserId

                  LEFT JOIN tmpFoundPositionsSUN AS FoundPositionsSUN
                                                 ON FoundPositionsSUN.UnitID = vbUnitId

            WHERE MovementItem.MovementId = vbMovementId
              AND MovementItem.ObjectId = vbUserId
              AND MovementItem.DescId = zc_MI_Master()
              AND MovementItem.isErased = FALSE;
    ELSE 
       RAISE EXCEPTION 'Не найден по вам расчет з.п. за %', zfCalc_MonthYearName(inOperDate);
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.08.19                                                        *
*/
-- select * from gpGet_MovementItem_WagesUser(inOperDate := ('01.03.2020')::TDateTime ,  inSession := '3');

