 -- Function: gpSelect_GoodsOnUnitRemains_SummaSale()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_SummaSale (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_SummaSale(
    IN inUnitId            Integer  ,  -- �������������
    IN inRemainsDate       TDateTime,  -- ���� �������
    IN inSession           TVarChar,   -- ������ ������������
   OUT outSummaSale        TFloat      -- ������� � ����� �������
)
RETURNS TFloat
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

    CREATE TEMP TABLE tmpContainerCount (ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO tmpContainerCount(ContainerId, GoodsId, Amount)
                                SELECT Container.Id                AS ContainerId
                                     , Container.ObjectId          AS GoodsId
                                     , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                FROM Container
                                    --INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId = Container.Id
                                                                   AND MIContainer.OperDate >= inRemainsDate
                                WHERE Container.DescId = zc_Container_count()
                                  AND Container.WhereObjectId = inUnitId
                                GROUP BY Container.Id
                                     , Container.Amount
                                     , Container.ObjectId
                                HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0;

      --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE tmpContainerCount;

    -- ���������
        WITH
             tmpData AS (SELECT tmpContainerCount.GoodsId
                              , SUM (tmpContainerCount.Amount)                  AS Amount
                         FROM tmpContainerCount
                         GROUP BY tmpContainerCount.GoodsId
                         HAVING SUM (tmpContainerCount.Amount) <> 0
                        )
           , Object_Price AS (SELECT Object_Price.Id       AS Id
                                   , Object_Price.GoodsId  AS GoodsId
                              FROM Object_Price_View AS Object_Price
                              WHERE Object_Price.UnitId = inUnitId
                             )



        -- ���������
        SELECT SUM(tmpData.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) AS SummaSale
        INTO outSummaSale
        FROM tmpData

            LEFT OUTER JOIN Object_Price ON Object_Price.GoodsId = tmpData.GoodsId

            -- �������� �������� ���� � ��� �� ������� �������� �� ���� �� ������
            LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                    ON ObjectHistory_Price.ObjectId = Object_Price.Id
                                   AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                   AND inRemainsDate >= ObjectHistory_Price.StartDate AND inRemainsDate < ObjectHistory_Price.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                         ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()

         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 29.08.18                                                                     *
*/

-- ����
--
-- select * from gpSelect_GoodsOnUnitRemains_SummaSale(inUnitId := 375626 , inRemainsDate := ('29.08.2019')::TDateTime,  inSession := '3');