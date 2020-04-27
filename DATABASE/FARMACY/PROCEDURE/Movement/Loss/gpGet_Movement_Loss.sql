-- Function: gpGet_Movement_Loss()

DROP FUNCTION IF EXISTS gpGet_Movement_Loss (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Loss(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , UnitId Integer, UnitName TVarChar
             , ArticleLossId Integer, ArticleLossName TVarChar
             , Comment TVarChar
             , RetailFund TFloat, SummaFund TFloat, SummaFundAvailable TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Loss());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                         AS OperDate  --inOperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CAST (0 AS TFloat)                               AS TotalCount
             , 0                     				            AS UnitId
             , CAST ('' AS TVarChar) 				            AS UnitName
             , 0                     				            AS ArticleLossId
             , CAST ('' AS TVarChar) 				            AS ArticleLossName
             , CAST ('' AS TVarChar) 		                    AS Comment
             , CAST (NULL AS TFloat)                            AS RetailFund
             , CAST (NULL AS TFloat)                            AS SummaFund
             , CAST (0 AS TFloat)                               AS SummaFundAvailable
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_Unit.Id                                     AS FromId
           , Object_Unit.ValueData                              AS FromName
           , Object_ArticleLoss.Id                              AS ArticleLossId
           , Object_ArticleLoss.ValueData                       AS ArticleLossName
           , COALESCE (MovementString_Comment.ValueData,'')     ::TVarChar AS Comment
           , NULLIF(COALESCE(ObjectFloat_Retail_Fund.ValueData , 0) -
             COALESCE(ObjectFloat_Retail_FundUsed.ValueData, 0), 0)::TFloat       AS RetailFund
           , NULLIF(MovementFloat_SummaFund.ValueData, 0)::TFloat               AS SummaFund
           , (COALESCE(ObjectFloat_Retail_Fund.ValueData , 0) -
             COALESCE(ObjectFloat_Retail_FundUsed.ValueData, 0) +                
             COALESCE(MovementFloat_SummaFund.ValueData, 0))::TFloat            AS SummaFundAvailable
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_SummaFund
                                    ON MovementFloat_SummaFund.MovementId =  Movement.Id
                                   AND MovementFloat_SummaFund.DescId = zc_MovementFloat_SummaFund()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

            LEFT JOIN ObjectFloat AS ObjectFloat_Retail_Fund
                                  ON ObjectFloat_Retail_Fund.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                 AND ObjectFloat_Retail_Fund.DescId = zc_ObjectFloat_Retail_Fund()

            LEFT JOIN ObjectFloat AS ObjectFloat_Retail_FundUsed
                                  ON ObjectFloat_Retail_FundUsed.ObjectId = Object_Unit.Id
                                 AND ObjectFloat_Retail_FundUsed.DescId = zc_ObjectFloat_Retail_FundUsed()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Loss();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Loss (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.  Шаблий О.В.
 25.07.19                                                                                     *
 20.07.15                                                                         *
 */

-- тест
-- SELECT * FROM gpGet_Movement_Loss (inMovementId:= 1, inOperDate:= '20150720', inSession:= '3')

select * from gpGet_Movement_Loss(inMovementId := 18420172 , inOperDate := ('23.04.2020')::TDateTime ,  inSession := '3');