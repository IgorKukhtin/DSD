 -- Function: gpReport_SalesOfTermDrugs()

DROP FUNCTION IF EXISTS gpReport_SalesOfTermDrugs (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SalesOfTermDrugs(
    IN inStartDate        TDateTime,
    IN inEndDate          TDateTime,
    IN inDaysBeforeDelay  Integer  ,  -- ���������� ���� �� ��������� ����� ��������
    IN inUnitId           Integer  ,  -- �������������
    IN inJuridicalId      Integer  ,  -- ��.����
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (JuridicalId  Integer, JuridicalName  TVarChar
             , UnitId Integer, UnitName TVarChar

             , Amount TFloat, Summa TFloat, AverageSale TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- ����������� �� �������� ��������� �����������
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- ���������
    RETURN QUERY
    WITH tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                , MovementItemContainer.OperDate
                                , MovementItemContainer.Price
                                , MovementItemContainer.ObjectId_Analyzer       AS GoodsId
                                , MovementItemContainer.WhereObjectId_Analyzer  AS UnitId
                                , -1.0 * MovementItemContainer.Amount           AS Amount
                           FROM MovementItemContainer
                           WHERE MovementItemContainer.DescId = zc_MIContainer_CountPartionDate()
                             AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                             AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                             AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                             AND (MovementItemContainer.WhereObjectId_Analyzer = inUnitId OR COALESCE(inUnitId, 0) = 0)),
         tmpExpirationDate AS (SELECT tmpMIContainer.*
                                    , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())                      AS ExpirationDate
                                    , extract('DAY' from COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()) - 
                                                         tmpMIContainer.OperDate)                                       AS DaysBeforeDelay
                               FROM tmpMIContainer                            

                                    LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = tmpMIContainer.ContainerId
                                                                 AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                                 
                                    LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                         ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                        AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                    LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                         ON ObjectLink_Unit_Juridical.ObjectId = tmpMIContainer.UnitId
                                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                               WHERE ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR COALESCE ( inJuridicalId, 0) = 0 OR COALESCE(inUnitId, 0) <> 0
                              )
                             
                             
  SELECT Object_Juridical.Id                                   AS JuridicalId
       , Object_Juridical.ValueData                            AS JuridicalName
       , Object_Unit.Id                                        AS UnitId
       , Object_Unit.ValueData                                 AS UnitName
       , SUM(tmpExpirationDate.Amount)::TFloat                                               AS Amount
       , SUM(Round(tmpExpirationDate.Amount * tmpExpirationDate.Price, 2))::TFloat           AS Summs
       , Round(SUM(Round(tmpExpirationDate.Amount * tmpExpirationDate.Price, 2)) / 
               SUM(tmpExpirationDate.Amount), 2)::TFloat                                     AS AverageSale
  FROM tmpExpirationDate  
  
       INNER JOIN Object AS Object_Unit ON Object_Unit.ID = tmpExpirationDate.UnitId
       
       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                            ON ObjectLink_Unit_Juridical.ObjectId = tmpExpirationDate.UnitId
                           AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
       
  WHERE tmpExpirationDate.DaysBeforeDelay <= inDaysBeforeDelay                            
  GROUP BY Object_Juridical.Id
         , Object_Juridical.ValueData
         , Object_Unit.Id
         , Object_Unit.ValueData;
END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 03.02.21                                                                     *
*/

-- ����
--
-- 
select * from gpReport_SalesOfTermDrugs(inStartDate := ('01.01.2021')::TDateTime, inEndDate := ('31.01.2021')::TDateTime, inDaysBeforeDelay := 90, inUnitId := 183292 , inJuridicalId := 0 ,  inSession := '3');         