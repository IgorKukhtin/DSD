-- Function:  gpReport_Check_Count()

DROP FUNCTION IF EXISTS gpReport_Check_Count (TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_Count(
    IN inStartDate      TDateTime,  -- ���� ������
    IN inEndDate        TDateTime,  -- ���� ���������
    IN inStartTime      TDateTime,  -- ����� ������
    IN inEndTime        TDateTime,  -- ����� ���������
    IN inMinSumma       TFloat,     -- c������ ���� �� �����,����� ���� ������ ���� ����� N
    IN inSession        TVarChar    -- ������ ������������
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
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������������ <�������� ����>
    vbRetailId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    -- ���������
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
                          , SUM (CASE WHEN COALESCE (MB_RoundingDown.ValueData, False) = True
                                           THEN TRUNC(COALESCE (MovementItem.Amount, 0) * COALESCE (MIContainer.Price,0), 1)::TFloat
                                           ELSE CASE WHEN COALESCE (MB_RoundingTo10.ValueData, False) = True
                                           THEN (((COALESCE (MovementItem.Amount, 0)) * COALESCE (MIContainer.Price,0))::NUMERIC (16, 1))::TFloat
                                           ELSE (((COALESCE (MovementItem.Amount, 0)) * COALESCE (MIContainer.Price,0))::NUMERIC (16, 2))::TFloat END END *
                                           COALESCE (-1 * MIContainer.Amount, 0) / COALESCE (MovementItem.Amount, 0)) AS SummaSale
                     FROM MovementItemContainer AS MIContainer
                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer

                          LEFT JOIN MovementItem ON MovementItem.ID =  MIContainer.MovementItemId

                               LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                                         ON MB_RoundingTo10.MovementId = MIContainer.MovementId
                                                        AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                               LEFT JOIN MovementBoolean AS MB_RoundingDown
                                                         ON MB_RoundingDown.MovementId = MIContainer.MovementID
                                                        AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()  

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

    -- �������� ���� �� ������� ���������� �������
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

        -- ���������
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.07.20         *
*/

-- ����
-- SELECT * FROM gpReport_Check_Count(inStartDate := ('21.07.2020')::TDateTime , inEndDate := ('29.07.2020')::TDateTime , inStartTime := ('01.07.2020 09:16')::TDateTime , inEndTime := ('01.07.2020 16:22')::TDateTime, inMinSumma := 4000, inSession := '3');
