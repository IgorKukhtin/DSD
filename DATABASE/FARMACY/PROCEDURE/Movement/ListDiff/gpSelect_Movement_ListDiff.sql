-- Function: gpSelect_Movement_ListDiff()

DROP FUNCTION IF EXISTS gpSelect_Movement_ListDiff (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ListDiff(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , JuridicalName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , Count_free  TFloat
             , Count_Order TFloat
             , Summa_free  TFloat
             , Summa_inf   TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ListDiff());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId      AS UnitId
                             , ObjectLink_Unit_Juridical.ChildObjectId AS JuridicalId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )

        , tmpMovement AS (SELECT Movement.*
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                               , tmpUnit.JuridicalId
                          FROM tmpStatus
                               INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.DescId = zc_Movement_ListDiff() 
                                                  AND Movement.StatusId = tmpStatus.StatusId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                          )

        , tmpData_MI AS (SELECT MovementItem.MovementId
                              , SUM (CASE WHEN COALESCE (MIFloat_OrderId.ValueData, 0) = 0  THEN MovementItem.Amount ELSE 0 END) AS Count_free
                              , SUM (CASE WHEN COALESCE (MIFloat_OrderId.ValueData, 0) <> 0 THEN MovementItem.Amount ELSE 0 END) AS Count_Order
                              , SUM (MI_Float_Price.ValueData * 
                                     CASE WHEN COALESCE (MIFloat_OrderId.ValueData, 0) = 0  THEN MovementItem.Amount ELSE 0 END) AS Summa_free
                              , SUM (MI_Float_Price.ValueData * 
                                     CASE WHEN MILO_DiffKind.ObjectId = 9572752 THEN MovementItem.Amount ELSE 0 END) AS Summa_inf
                         FROM tmpMovement
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_OrderId
                                                          ON MIFloat_OrderId.MovementItemId = MovementItem.Id
                                                         AND MIFloat_OrderId.DescId         = zc_MIFloat_MovementId()
                              LEFT JOIN MovementItemFloat AS MI_Float_Price
                                                          ON MI_Float_Price.MovementItemId = MovementItem.Id
                                                         AND MI_Float_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemLinkObject AS MILO_DiffKind
                                                               ON MILO_DiffKind.MovementItemId = MovementItem.Id
                                                              AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()
                         GROUP BY MovementItem.MovementId
                         )
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName
           , Object_Juridical.ValueData         AS JuridicalName

           , MovementFloat_TotalCount.ValueData AS TotalCount
           , MovementFloat_TotalSumm.ValueData  AS TotalSumm
           
           , tmpData_MI.Count_free  :: TFloat
           , tmpData_MI.Count_Order :: TFloat
           , tmpData_MI.Summa_free  :: TFloat
           , tmpData_MI.Summa_inf   :: TFloat

       FROM tmpMovement AS Movement

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement.JuridicalId
            
            LEFT JOIN tmpData_MI ON tmpData_MI.MovementId = Movement.Id
            
            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ListDiff (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '3')