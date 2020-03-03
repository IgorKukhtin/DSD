-- Function: gpSelect_Movement_Inventory()

DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Inventory(
    IN inStartDate   TDateTime , --С даты
    IN inEndDate     TDateTime , --По дату
    IN inIsErased    Boolean ,   --Так же удаленные
    IN inSession     TVarChar    --сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , DeficitSumm TFloat, ProficitSumm TFloat, Diff TFloat, DiffSumm TFloat
             , UnitId Integer, UnitName TVarChar, FullInvent Boolean
             , Diff_calc TFloat, DeficitSumm_calc TFloat, ProficitSumm_calc TFloat, DiffSumm_calc TFloat
             , Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);
     
     
     IF vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (308121)) -- Кассир аптеки
     THEN 
       vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
       IF vbUnitKey = '' THEN
          vbUnitKey := '0';
       END IF;   
       vbUnitId := vbUnitKey::Integer;
       
        IF COALESCE((SELECT ObjectBoolean_Unit_TechnicalRediscount.ValueData
                     FROM ObjectBoolean AS ObjectBoolean_Unit_TechnicalRediscount
                     WHERE ObjectBoolean_Unit_TechnicalRediscount.ObjectId = vbUnitId
                       AND ObjectBoolean_Unit_TechnicalRediscount.DescId = zc_ObjectBoolean_Unit_TechnicalRediscount()), False) = TRUE
        THEN
            RAISE EXCEPTION 'Ошибка. Не Доступно!';
        END IF;       
     ELSE
       vbUnitId := 0;
     END IF;
     
       -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical() 
                          AND  (vbUnitId = 0 OR ObjectLink_Unit_Juridical.ObjectId = vbUnitId)
                        )

        , tmpMovement_calc AS (SELECT Movement.Id
                                    , SUM (MovementItemContainer.Amount) AS Diff
                                    , SUM (CASE WHEN MovementItemContainer.Amount < 0 THEN -1 * MovementItemContainer.Amount * COALESCE (MovementItemFloat.ValueData, 0) ELSE 0 END) AS DeficitSumm
                                    , SUM (CASE WHEN MovementItemContainer.Amount > 0 THEN  1 * MovementItemContainer.Amount * COALESCE (MovementItemFloat.ValueData, 0) ELSE 0 END) AS ProficitSumm
                               FROM Movement
                                    INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                    AND MovementItemContainer.DescId     = zc_MIContainer_Count()
                                    LEFT JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItemContainer.MovementItemId
                                                               AND MovementItemFloat.DescId         = zc_MIFloat_Price()
                               WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                                 AND Movement.DescId = zc_Movement_Inventory()
                               GROUP BY Movement.Id
                              )
       -- Результат
       SELECT
             Movement.Id                                          AS Id
           , Movement.InvNumber                                   AS InvNumber
           , Movement.OperDate                                    AS OperDate
           , Object_Status.ObjectCode                             AS StatusCode
           , Object_Status.ValueData                              AS StatusName
           , MovementFloat_DeficitSumm.ValueData                  AS DeficitSumm
           , MovementFloat_ProficitSumm.ValueData                 AS ProficitSumm
           , MovementFloat_Diff.ValueData                         AS Diff
           , MovementFloat_DiffSumm.ValueData                     AS DiffSumm
           , Object_Unit.Id                                       AS UnitId
           , Object_Unit.ValueData                                AS UnitName
           , COALESCE(MovementBoolean_FullInvent.ValueData,False) AS FullInvent

           , tmpMovement_calc.Diff         :: TFloat AS Diff_calc
           , tmpMovement_calc.DeficitSumm  :: TFloat AS DeficitSumm_calc
           , tmpMovement_calc.ProficitSumm :: TFloat AS ProficitSumm_calc
           , (tmpMovement_calc.ProficitSumm - tmpMovement_calc.DeficitSumm) :: TFloat AS DiffSumm_calc
           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment

       FROM (SELECT Movement.Id
                  , MovementLinkObject_Unit.ObjectId AS UnitId
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                               AND Movement.DescId = zc_Movement_Inventory() AND Movement.StatusId = tmpStatus.StatusId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                  INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
            ) AS tmpMovement
            LEFT JOIN tmpMovement_calc ON tmpMovement_calc.Id = tmpMovement.Id
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId
            
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

/*            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
*/
            LEFT OUTER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                            ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                           AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()

            LEFT OUTER JOIN MovementFloat AS MovementFloat_DeficitSumm
                                          ON MovementFloat_DeficitSumm.MovementId = Movement.Id
                                         AND MovementFloat_DeficitSumm.DescId = zc_MovementFloat_TotalDeficitSumm()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_ProficitSumm
                                          ON MovementFloat_ProficitSumm.MovementId = Movement.Id
                                         AND MovementFloat_ProficitSumm.DescId = zc_MovementFloat_TotalProficitSumm()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_Diff
                                          ON MovementFloat_Diff.MovementId = Movement.Id
                                         AND MovementFloat_Diff.DescId = zc_MovementFloat_TotalDiff()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_DiffSumm
                                          ON MovementFloat_DiffSumm.MovementId = Movement.Id
                                         AND MovementFloat_DiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Inventory (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Воробкало А.А.   Шаблий О.В.
 19.12.19                                                                                      * + Comment
 04.05.16         *
 16.09.15                                                                       * + FullInvent
 11.07.15                                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Inventory (inStartDate:= '01.12.2019', inEndDate:= '31.12.2019', inIsErased:= FALSE, inSession:= '2')

