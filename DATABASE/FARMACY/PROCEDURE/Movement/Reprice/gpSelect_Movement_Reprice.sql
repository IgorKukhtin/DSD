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
             , ChangePercent TFloat
             , UnitId Integer, UnitName TVarChar
             , AreaName TVarChar, JuridicalName TVarChar, ProvinceCityName TVarChar
             , UnitForwardingId Integer, UnitForwardingName TVarChar
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
     WITH  tmpUnit AS  (SELECT ObjectLink_Unit_Juridical.ObjectId         AS UnitId
                             , ObjectLink_Unit_Juridical.ChildObjectId    AS JuridicalId
                             , ObjectLink_Unit_ProvinceCity.ChildObjectId AS ProvinceCityId
                             , ObjectLink_Unit_Area.ChildObjectId         AS AreaId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                ON ObjectLink_Unit_Area.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                               AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                                ON ObjectLink_Unit_ProvinceCity.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                               AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )

    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)    ::TFloat AS TotalSumm
      , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat AS ChangePercent
      
      , MovementLinkObject_Unit.ObjectId                      AS UnitId
      , Object_Unit.ValueData                                 AS UnitName
      , Object_Area.ValueData                                 AS AreaName
      , Object_Juridical.ValueData                            AS JuridicalName
      , Object_ProvinceCity.ValueData                         AS ProvinceCityName

      , Object_UnitForwarding.Id                              AS UnitForwardingId
      , Object_UnitForwarding.ValueData                       AS UnitForwardingName

      , MovementString_GUID.ValueData                         AS GUID

      , Object_Insert.ValueData                               AS InsertName
      , MovementDate_Insert.ValueData                         AS InsertDate
      
    FROM Movement 
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId = Movement.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                               
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpUnit.JuridicalId
        LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = tmpUnit.ProvinceCityId
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = tmpUnit.AreaId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                     ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                    AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
        LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

        LEFT OUTER JOIN MovementString AS MovementString_GUID
                                       ON MovementString_GUID.MovementId = Movement.Id
                                      AND MovementString_GUID.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
        
    WHERE Movement.DescId = zc_Movement_Reprice()
      AND Movement.OperDate BETWEEN inStartDate AND inEndDate
    ORDER BY Movement.InvNumber;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Reprice (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 12.03.18         *
 01.11.17         *
 21.02.16         * UnitForwarding
 02.03.16         * без вьюхи + св-ва протокола
 27.11.15                                                                        *
*/

--select * from gpSelect_Movement_Reprice(inStartDate := ('27.02.2016')::TDateTime , inEndDate := ('13.03.2016')::TDateTime ,  inSession := '3');