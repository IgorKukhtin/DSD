-- Function: gpSelect_Movement_Reprice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Reprice (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Reprice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , TotalSumm TFloat
             , UnitId Integer
             , UnitName TVarChar
             , GUID TVarChar
             , InsertName TVarChar, InsertDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


    RETURN QUERY
     WITH  tmpUnit AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )

    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat AS TotalSumm
      , MovementLinkObject_Unit.ObjectId                      AS UnitId
      , Object_Unit.ValueData                                 AS UnitName
      , MovementString_GUID.ValueData                         AS GUID

      , Object_Insert.ValueData              AS InsertName
      , ObjectDate_Protocol_Insert.ValueData AS InsertDate
    FROM Movement 
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
        LEFT OUTER JOIN MovementString AS MovementString_GUID
                                       ON MovementString_GUID.MovementId = Movement.Id
                                      AND MovementString_GUID.DescId = zc_MovementString_Comment()

        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                             ON ObjectDate_Protocol_Insert.ObjectId = Movement.Id
                            AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Movement.Id
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId  

    WHERE Movement.DescId = zc_Movement_Reprice()
      AND DATE_TRUNC ('DAY', Movement.OperDate) BETWEEN inStartDate AND inEndDate
    ORDER BY Movement.InvNumber;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Reprice (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 02.03.16         * без вьюхи + св-ва протокола
 27.11.15                                                                        *
*/

--select * from gpSelect_Movement_Reprice(inStartDate := ('27.02.2016')::TDateTime , inEndDate := ('31.12.2016')::TDateTime ,  inSession := '3');