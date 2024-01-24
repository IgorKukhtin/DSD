-- Function: gpReport_Wages_Average()

DROP FUNCTION IF EXISTS gpReport_Wages_Average (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Wages_Average(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MemberName TVarChar, PositionName TVarChar, UnitName TVarChar
             , Amount TFloat  
             , CountMonth Integer
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitId Integer;
BEGIN

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
        WITH tmpMovement AS (SELECT Movement.Id                              AS ID
                                  , Movement.InvNumber                       AS InvNumber
                                  , Movement.OperDate                        AS OperDate

                                FROM Movement
                                WHERE Movement.OperDate BETWEEN date_trunc('month', inStartDate) AND date_trunc('month', inEndDate)
                                  AND Movement.StatusId <> zc_Enum_Status_Erased() 
                                  AND Movement.DescId = zc_Movement_Wages()),
             tmpMI AS (SELECT Movement.OperDate
                            , MovementItem.Id                    AS Id
                            , MovementItem.ObjectId                         AS UserID
                            , MovementItem.Amount                           AS AmountAccrued
                            , ObjectLink_User_Member.ChildObjectId          AS MemberId 
                            , MILinkObject_Unit.ObjectID                    AS UnitID
                            , ObjectLink_Member_Position.ChildObjectId      AS PositionId

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
                               COALESCE (MIFloat_PenaltySUN.ValueData, 0))::TFloat AS Amount
 
                       FROM tmpMovement AS Movement
                        
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                 ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                            LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()

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

                      ),
             tmpSUM AS (SELECT tmpMI.MemberId 
                             , Round(SUM(tmpMI.Amount)/count(*), 2)::TFloat AS Amount
                             , count(*)::Integer                            AS CountMonth
                        FROM tmpMI
                         
                        GROUP BY tmpMI.MemberId),
             tmpUninit AS (SELECT tmpMI.MemberId 
                                , tmpMI.PositionId
                                , tmpMI.UnitId 
                                , ROW_NUMBER() OVER (PARTITION BY tmpMI.MemberId ORDER BY tmpMI.OperDate DESC) AS Ord
                           FROM tmpMI
                           )
                                              
     SELECT Object_Member.ValueData        AS MemberName
          , Object_Position.ValueData      AS PositionName
          , Object_Unit.ValueData          AS UnitName
          
          , tmpSUM.Amount
          , tmpSUM.CountMonth
     
     FROM tmpSUM

          LEFT JOIN tmpUninit ON tmpUninit.MemberId = tmpSUM.MemberId
                             AND tmpUninit.Ord = 1     

          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpSUM.MemberId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpUninit.PositionId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUninit.UnitID
          
     WHERE tmpSUM.Amount > 0

     ORDER BY Object_Member.ValueData
            , Object_Position.ValueData
            , Object_Unit.ValueData

                               
          
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Wages (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.01.24                                                        *
*/

-- тест
-- 

select * from gpReport_Wages_Average(inStartDate := ('01.07.2023')::TDateTime , inEndDate := ('31.12.2023')::TDateTime ,  inSession := '3');

