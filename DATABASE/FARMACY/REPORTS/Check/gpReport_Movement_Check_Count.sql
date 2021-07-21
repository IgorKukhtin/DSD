-- Function:  gpReport_Check_Count()

DROP FUNCTION IF EXISTS gpReport_Check_Count (TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_Count(
    IN inStartDate      TDateTime,  -- Дата начала
    IN inEndDate        TDateTime,  -- Дата окончания
    IN inStartTime      TDateTime,  -- время начала
    IN inEndTime        TDateTime,  -- время окончания
    IN inMinSumma       TFloat,     -- cчитать чеки от суммы,сумма чека больше либо равно N
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               UnitCode   Integer,  
               UnitName   TVarChar,
               JuridicalName TVarChar,
               RetailName    TVarChar,
               Address    TVarChar,
               Count      TFloat,
               SummaSale  TFloat
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbDatEndPromo TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbRetailId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
    WITH
    tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId        AS UnitId
                     , ObjectLink_Juridical_Retail.ObjectId      AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND (ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId OR vbRetailId = 0)
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                )
             
  , tmpContainer AS (SELECT MIContainer.OperDate               AS OperDate
                          , MIContainer.OperDate        ::Time AS OperTime
                          , MIContainer.WhereObjectId_analyzer AS UnitId
                          , tmpUnit.JuridicalId                AS JuridicalId
                          , tmpUnit.RetailId                   AS RetailId
                          , MIContainer.MovementId             AS MovementId
                          --, SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                          , SUM (zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * COALESCE (MIContainer.Price,0)
                                                 , COALESCE (MB_RoundingDown.ValueData, False)
                                                 , COALESCE (MB_RoundingTo10.ValueData, False)
                                                 , COALESCE (MB_RoundingTo50.ValueData, False))) AS SummaSale
                     FROM MovementItemContainer AS MIContainer
                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer

                          LEFT JOIN MovementItem ON MovementItem.ID =  MIContainer.MovementItemId

                               LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                                         ON MB_RoundingTo10.MovementId = MIContainer.MovementId
                                                        AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                               LEFT JOIN MovementBoolean AS MB_RoundingDown
                                                         ON MB_RoundingDown.MovementId = MIContainer.MovementID
                                                        AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()  
                               LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                                         ON MB_RoundingTo50.MovementId = MIContainer.MovementID
                                                        AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                       AND MIContainer.MovementDescId = zc_Movement_Check()
                       AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                     GROUP BY MIContainer.MovementId
                            , MIContainer.OperDate
                            , MIContainer.WhereObjectId_analyzer
                            , tmpUnit.JuridicalId
                            , tmpUnit.RetailId
                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) >= inMinSumma
                     )

    -- выбираем чеки из нужного промежутка времени
  , tmpData AS (SELECT tmpContainer.UnitId                      AS UnitId
                     , tmpContainer.JuridicalId                 AS JuridicalId
                     , tmpContainer.RetailId                    AS RetailId
                     , COUNT (DISTINCT tmpContainer.MovementId) AS Count
                     , SUM (tmpContainer.SummaSale)             AS SummaSale
                FROM tmpContainer
                WHERE (tmpContainer.OperTime >= inStartTime ::Time OR inStartTime ::Time  = '00:00:00')
                  AND (tmpContainer.OperTime <= inEndTime ::Time OR inEndTime ::Time  = '00:00:00')
                GROUP BY tmpContainer.UnitId
                       , tmpContainer.JuridicalId
                       , tmpContainer.RetailId
                )

        -- результат
      SELECT Object_Unit.ObjectCode                         AS UnitCode
           , Object_Unit.ValueData                          AS UnitName
           , Object_Juridical.ValueData                     AS JuridicalName
           , Object_Retail.ValueData                        AS RetailName
           , ObjectString_Unit_Address.ValueData ::TVarChar AS Address
           , tmpData.Count      :: TFloat
           , tmpData.SummaSale  :: TFloat
        FROM tmpData
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpData.RetailId
             
             LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                    ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                   AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
        ORDER BY Object_Retail.ValueData
               , Object_Juridical.ValueData
               , Object_Unit.ValueData
;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.07.20         *
*/

-- тест
-- SELECT * FROM gpReport_Check_Count(inStartDate := ('21.07.2020')::TDateTime , inEndDate := ('29.07.2020')::TDateTime , inStartTime := ('01.07.2020 09:16')::TDateTime , inEndTime := ('01.07.2020 16:22')::TDateTime, inMinSumma := 4000, inSession := '3');