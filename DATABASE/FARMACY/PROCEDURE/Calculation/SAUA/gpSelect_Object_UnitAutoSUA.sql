-- Function: gpSelect_Object_UnitAutoSUA()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitAutoSUA (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitAutoSUA(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar,  JuridicalName TVarChar

             , DateAuto TDateTime
             , Latitude TVarChar, Longitude TVarChar, ORD Integer
             
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbLatitude Float;
  DECLARE vbLongitude Float;
  DECLARE vbOperDate TDateTime;

  DECLARE vbUnit1Id Integer;
  DECLARE vbUnit2Id Integer;
  DECLARE vbUnit3Id Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_FinalSUA());
    vbUserId := inSession;
    
    vbOperDate := CURRENT_DATE + ((8 - date_part('DOW', CURRENT_DATE)::Integer)::TVarChar||' DAY')::INTERVAL;
  
    RETURN QUERY    
    WITH tmpUnit AS (SELECT Object_Unit.Id                AS UnitId
                          , Object_Unit.ValueData         AS UnitName
                          , Object_Juridical.ValueData    AS JuridicalName
                          , ROW_NUMBER()OVER(ORDER BY Object_Juridical.ValueData, Object_Unit.ValueData) as ORD
                     FROM ObjectBoolean AS ObjectBoolean_Unit_SUA

                          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectBoolean_Unit_SUA.ObjectId

                          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                                   
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                               AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                     WHERE ObjectBoolean_Unit_SUA.DescId = zc_ObjectBoolean_Unit_SUA()
                       AND ObjectBoolean_Unit_SUA.ValueData = True
                     ORDER BY Object_Juridical.ValueData
                            , Object_Unit.ValueData
                     )
       , tmpMaxData AS (SELECT Max(ObjectDate_AutoSUA.ValueData)                       AS MaxDateAuto 
                        FROM tmpUnit
                             INNER JOIN ObjectDate AS ObjectDate_AutoSUA
                                                   ON ObjectDate_AutoSUA.ObjectId = tmpUnit.UnitId
                                                  AND ObjectDate_AutoSUA.DescId = zc_ObjectDate_Unit_AutoSUA()
                        WHERE ObjectDate_AutoSUA.ValueData IS NOT NULL)
       , tmpUnitDataInterim AS (SELECT tmpUnit.UnitId
                                     , tmpMaxData.MaxDateAuto 
                                     , ROW_NUMBER()OVER(ORDER BY tmpUnit.ORD) AS ORD
                               FROM tmpUnit
                                    INNER JOIN tmpMaxData ON 1 = 1
                                    LEFT JOIN ObjectDate AS ObjectDate_AutoSUA
                                                         ON ObjectDate_AutoSUA.ObjectId = tmpUnit.UnitId
                                                        AND ObjectDate_AutoSUA.DescId = zc_ObjectDate_Unit_AutoSUA()
                               WHERE ObjectDate_AutoSUA.ValueData is NULL)
       , tmpUnitData AS (SELECT tmpUnitDataInterim.UnitId
                              , tmpUnitDataInterim.MaxDateAuto + ((7 * tmpUnitDataInterim.Ord)::tvarchar||' DAY')::INTERVAL   AS DateAuto
                        FROM tmpUnitDataInterim)
                              
    SELECT tmpUnit.UnitId
         , tmpUnit.UnitName
         , tmpUnit.JuridicalName
         , COALESCE(ObjectDate_AutoSUA.ValueData, tmpUnitData.DateAuto)::TDateTime  AS DateAuto 
         , ObjectString_Latitude.ValueData                                          AS Latitude 
         , ObjectString_Longitude.ValueData                                         AS Longitude
         , tmpUnit.ORD::Integer                                                     AS ORD
    FROM tmpUnit
         LEFT JOIN ObjectString AS ObjectString_Latitude
                                ON ObjectString_Latitude.ObjectId = tmpUnit.UnitId
                               AND ObjectString_Latitude.DescId = zc_ObjectString_Unit_Latitude()
         LEFT JOIN ObjectString AS ObjectString_Longitude
                                ON ObjectString_Longitude.ObjectId = tmpUnit.UnitId
                               AND ObjectString_Longitude.DescId = zc_ObjectString_Unit_Longitude()
         LEFT JOIN ObjectDate AS ObjectDate_AutoSUA
                              ON ObjectDate_AutoSUA.ObjectId = tmpUnit.UnitId
                             AND ObjectDate_AutoSUA.DescId = zc_ObjectDate_Unit_AutoSUA()
         LEFT JOIN tmpUnitData ON tmpUnitData.UnitId = tmpUnit.UnitId
    ORDER BY tmpUnit.ORD;
             

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.05.21                                                       *
 */

-- тест
--
 SELECT * FROM gpSelect_Object_UnitAutoSUA (inSession:= '3')    