-- Function: gpSelect_Movement_Loss()

DROP FUNCTION IF EXISTS gpSelect_Movement_Loss (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Loss(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , UnitId Integer, UnitName TVarChar
             , JuridicalName TVarChar
             , ArticleLossId Integer, ArticleLossName TVarChar
             , TotalSumm TFloat
             , TotalSummPrice TFloat
             , Comment TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Loss());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        -- , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        -- , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         -- UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              -- )
        , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )
        , tmpMovement AS (SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                            AND Movement.DescId = zc_Movement_Loss()
                                            AND Movement.StatusId = tmpStatus.StatusId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                               --JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                         )

        , CurrPRICE AS (SELECT Price_Goods.ChildObjectId              AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId    AS UnitId
                             , ROUND(Price_Value.ValueData,2)::TFloat AS Price 
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                  ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                        WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId IN (SELECT DISTINCT tmpMovement.UnitId FROM tmpMovement)
                       )
        , tmpSumm AS (SELECT MovementItem.MovementId
                           , SUM (MovementItem.Amount*COALESCE(MIFloat_Price.ValueData, CurrPRICE.Price))::TFloat AS SummPrice
                      FROM tmpMovement
                           JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE
                       
                           LEFT JOIN CurrPRICE ON CurrPRICE.GoodsId = MovementItem.ObjectId
                                              AND CurrPRICE.UnitId = tmpMovement.UnitId
                                              
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()          
                      WHERE MovementItem.isErased = FALSE
                        AND MovementItem.DescId = zc_MI_Master()
                       -- AND MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                      GROUP BY MovementItem.MovementId
                      )

       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , MovementFloat_TotalCount.ValueData AS TotalCount
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName
           , Object_Juridical.ValueData         AS JuridicalName
           , Object_ArticleLoss.Id              AS ArticleLossId
           , Object_ArticleLoss.ValueData       AS ArticleLossName
           , MovementFloat_TotalSumm.ValueData  AS TotalSumm
           , tmpSumm.SummPrice     :: TFloat    AS TotalSummPrice
           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment

       FROM tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.Id
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

/*            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
*/
            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId
            
            LEFT JOIN tmpSumm ON tmpSumm.MovementId = tmpMovement.Id

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = tmpMovement.UnitId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Loss (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.  Шаблий О.В.
 24.07.19                                                                                     *
 23.07.19         *
 04.05.16         *
 20.07.15                                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Loss (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '3')