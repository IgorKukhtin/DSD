-- Function: gpSelect_SendWayName()

DROP FUNCTION IF EXISTS gpSelect_SendWayName (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SendWayName(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);
  
  -- Результат
  RETURN QUERY
  WITH tmpMovement AS (SELECT Movement.id
                            , COALESCE (Object_ProvinceCity_From.ValueData, Object_Area_From.ValueData, '')||' - '||
                              COALESCE (Object_ProvinceCity_To.ValueData, Object_Area_To.ValueData, '') AS WayName
                       FROM Movement

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Area_From
                                                 ON ObjectLink_Unit_Area_From.DescId = zc_ObjectLink_Unit_Area()
                                                AND ObjectLink_Unit_Area_From.ObjectId = MovementLinkObject_From.ObjectId
                            LEFT JOIN Object AS Object_Area_From
                                             ON Object_Area_From.Id = ObjectLink_Unit_Area_From.ChildObjectId
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity_From
                                                 ON ObjectLink_Unit_ProvinceCity_From.DescId = zc_ObjectLink_Unit_ProvinceCity()
                                                AND ObjectLink_Unit_ProvinceCity_From.ObjectId = MovementLinkObject_From.ObjectId
                            LEFT JOIN Object AS Object_ProvinceCity_From
                                             ON Object_ProvinceCity_From.Id = ObjectLink_Unit_ProvinceCity_From.ChildObjectId
                                            AND Object_ProvinceCity_From.ValueData ILIKE 'г.%'

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Area_To
                                                 ON ObjectLink_Unit_Area_To.DescId = zc_ObjectLink_Unit_Area()
                                                AND ObjectLink_Unit_Area_To.ObjectId = MovementLinkObject_To.ObjectId
                            LEFT JOIN Object AS Object_Area_To
                                             ON Object_Area_To.Id = ObjectLink_Unit_Area_To.ChildObjectId
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity_To
                                                 ON ObjectLink_Unit_ProvinceCity_To.DescId = zc_ObjectLink_Unit_ProvinceCity()
                                                AND ObjectLink_Unit_ProvinceCity_To.ObjectId = MovementLinkObject_To.ObjectId
                            LEFT JOIN Object AS Object_ProvinceCity_To
                                             ON Object_ProvinceCity_To.Id = ObjectLink_Unit_ProvinceCity_To.ChildObjectId
                                            AND Object_ProvinceCity_To.ValueData ILIKE 'г.%'
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.DescId = zc_Movement_Send()
                         AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         AND COALESCE (Object_ProvinceCity_From.Id, Object_Area_From.Id, 0) <> COALESCE (Object_ProvinceCity_To.Id, Object_Area_To.Id, 0)
                         AND COALESCE (Object_ProvinceCity_From.Id, Object_Area_From.Id, 0) <> 0 
                         AND COALESCE (Object_ProvinceCity_To.Id, Object_Area_To.Id, 0) <> 0
                       ),
       tmpDate AS (SELECT DISTINCT REPLACE(tmpMovement.WayName, 'г. ', '')  AS WayName
                   FROM tmpMovement)
                     
                     
    SELECT (ROW_NUMBER() OVER (ORDER BY tmpDate.WayName))::Integer AS Id
         , tmpDate.WayName::TVarChar  AS Name
    FROM tmpDate;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
    
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.04.22                                                       *
*/

-- тест
-- 
select * from gpSelect_SendWayName(inStartDate := ('01.03.2022')::TDateTime , inEndDate := ('30.04.2022')::TDateTime ,  inSession := '3');    
                      