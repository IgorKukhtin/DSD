-- Function: gpSelect_Object_UnitAutoSUA()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitAutoSUA (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitAutoSUA(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar,  JuridicalName TVarChar

             , DateAuto TDateTime
             , Latitude TVarChar, Longitude TVarChar, ORD Integer
             , OperDateFinalSUA TDateTime, Calculation TDateTime, CountFinalSUA Integer
             , FinalSUAProtocolId Integer, AssortmentName1 TVarChar, AssortmentName2 TVarChar, AssortmentName3 TVarChar
             
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
       , tmpMaxData AS (SELECT Max(ObjectDate_AutoSUA.ValueData) + ((1 - date_part('DOW', Max(ObjectDate_AutoSUA.ValueData))::Integer)::TVarChar||' DAY')::INTERVAL AS MaxDateAuto 
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
       , tmpMovement AS (SELECT Movement.Id                          AS Id
                              , Movement.InvNumber                   AS InvNumber
                              , Movement.OperDate                    AS OperDate
                         FROM Movement
                         WHERE Movement.DescId = zc_Movement_FinalSUA()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         )
       , tmpCalculation AS (SELECT MILinkObject_Unit.ObjectId                           AS UnitId
                                 , Max(Movement.OperDate)::TDateTime                    AS OperDate
                                 , Max(MovementDate_Calculation.ValueData)::TDateTime   AS Calculation
                                 , COUNT(DISTINCT Movement.Id)::Integer                 AS CountFinalSUA
                             FROM tmpMovement AS Movement

                                  LEFT JOIN MovementDate AS MovementDate_Calculation
                                                         ON MovementDate_Calculation.MovementId = Movement.Id
                                                        AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation()
                                                        
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.isErased = False 

                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                             GROUP BY MILinkObject_Unit.ObjectId)
       , tmpFinalSUAProtocol AS (SELECT Max(Object_FinalSUAProtocol.Id)                         AS Id
                                      , tmpUnit.Id                                              AS UnitId
                                 FROM Object AS Object_FinalSUAProtocol
                            
                                      INNER JOIN ObjectDate AS ObjectDate_OperDate
                                                            ON ObjectDate_OperDate.ObjectId = Object_FinalSUAProtocol.Id
                                                           AND ObjectDate_OperDate.DescId = zc_ObjectDate_FinalSUAProtocol_OperDate()

                                      INNER JOIN ObjectBlob AS ObjectBlob_Recipient
                                                            ON ObjectBlob_Recipient.ObjectId = Object_FinalSUAProtocol.Id
                                                           AND ObjectBlob_Recipient.DescId = zc_objectBlob_FinalSUAProtocol_Recipient()

                                      INNER JOIN (SELECT T1.Id, T1.Code, T1.Name FROM gpSelect_Object_Unit (True, inSession) AS T1) AS tmpUnit
                                                                      ON ','||ObjectBlob_Recipient.ValueData||',' LIKE '%,'||tmpUnit.Id::TVarChar||',%'
                                                                      
                                      INNER JOIN tmpCalculation ON tmpCalculation.UnitId = tmpUnit.Id 
                                                               AND ObjectDate_OperDate.ValueData <= tmpCalculation.Calculation
                                                                        
                                WHERE Object_FinalSUAProtocol.DescId = zc_Object_FinalSUAProtocol()
                                  AND Object_FinalSUAProtocol.isErased = False
                                GROUP BY tmpUnit.Id 
                                )
       , tmpAssortment AS (SELECT Object_FinalSUAProtocol.Id     AS Id
                                , tmpUnit.Code                   AS AssortmentCode
                                , tmpUnit.Name                   AS AssortmentName
                                , ROW_NUMBER() OVER (PARTITION BY Object_FinalSUAProtocol.Id ORDER BY tmpUnit.Name) AS Ord 
                           FROM Object AS Object_FinalSUAProtocol
                            
                                INNER JOIN ObjectBlob AS ObjectBlob_Recipient
                                                      ON ObjectBlob_Recipient.ObjectId = Object_FinalSUAProtocol.Id
                                                     AND ObjectBlob_Recipient.DescId = zc_objectBlob_FinalSUAProtocol_Assortment()

                                INNER JOIN (SELECT T1.Id, T1.Code, T1.Name FROM gpSelect_Object_Unit (True, inSession) AS T1) AS tmpUnit
                                                     ON ','||ObjectBlob_Recipient.ValueData||',' LIKE '%,'||tmpUnit.Id::TVarChar||',%'
                                  
                           WHERE Object_FinalSUAProtocol.DescId = zc_Object_FinalSUAProtocol()
                             AND Object_FinalSUAProtocol.isErased = False)
                              
    SELECT tmpUnit.UnitId
         , tmpUnit.UnitName
         , tmpUnit.JuridicalName
         , COALESCE(ObjectDate_AutoSUA.ValueData, tmpUnitData.DateAuto)::TDateTime  AS DateAuto 
         , ObjectString_Latitude.ValueData                                          AS Latitude 
         , ObjectString_Longitude.ValueData                                         AS Longitude
         , tmpUnit.ORD::Integer                                                     AS ORD
         , tmpCalculation.OperDate                                                  AS OperDateFinalSUA
         , tmpCalculation.Calculation                                               AS Calculation
         , tmpCalculation.CountFinalSUA                                             AS CountFinalSUA
         , tmpFinalSUAProtocol.ID                                                   AS FinalSUAProtocolId 
         , Assortment1.AssortmentName                                               AS AssortmentName1
         , Assortment2.AssortmentName                                               AS AssortmentName2
         , Assortment3.AssortmentName                                               AS AssortmentName3
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
         
         LEFT JOIN tmpCalculation ON tmpCalculation.UnitId = tmpUnit.UnitId 
         
         LEFT JOIN tmpFinalSUAProtocol ON tmpFinalSUAProtocol.UnitId = tmpUnit.UnitId 
         
         LEFT JOIN tmpAssortment AS Assortment1
                                 ON Assortment1.Id = tmpFinalSUAProtocol.Id 
                                AND Assortment1.Ord = 1 
         LEFT JOIN tmpAssortment AS Assortment2
                                 ON Assortment2.Id = tmpFinalSUAProtocol.Id 
                                AND Assortment2.Ord = 2
         LEFT JOIN tmpAssortment AS Assortment3
                                 ON Assortment3.Id = tmpFinalSUAProtocol.Id 
                                AND Assortment3.Ord = 3
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

select * from gpSelect_Object_UnitAutoSUA( inSession := '3');