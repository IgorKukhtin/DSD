-- Function: gpSelect_KilledCodeRecovery()

DROP FUNCTION IF EXISTS gpSelect_KilledCodeRecovery (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_KilledCodeRecovery(
    IN inRangeOfDays      Integer  ,  -- �������� ����
    IN inPercePharmaciesd TFloat   ,  -- % �����
    IN inSalesThreshold   TFloat   ,  -- ����� ������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (
                UnitName TVarChar
              , GoodsCode Integer
              , GoodsName TVarChar
              , MCSIsCloseDateChange TDateTime
              , CountUnit Integer
              , CountSelling Integer
              , CountUnitAll Integer
              , GoodsCount Integer
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitCount Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    CREATE TEMP TABLE tmpUnitCheck ON COMMIT DROP AS
     (
     WITH tmpGoods AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , Object_Unit.valuedata             AS UnitName
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , Object_Goods.objectcode           AS GoodsCode
                            , Object_Goods.valuedata            AS GoodsName
                            , MCS_Value.ValueData               AS MCSValue
                            , MCS_isClose.ValueData             AS isClose
                            , MCSIsClose_DateChange.valuedata   AS MCSIsCloseDateChange
                       FROM ObjectLink AS OL_Price_Unit

                            INNER JOIN ObjectBoolean AS MCS_isClose
                                                     ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                    AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                    AND MCS_isClose.ValueData = TRUE
                            LEFT JOIN ObjectDate AS MCSIsClose_DateChange
                                                 ON MCSIsClose_DateChange.ObjectId = OL_Price_Unit.ObjectId
                                                AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()

                            LEFT JOIN ObjectLink AS OL_Price_Goods
                                                 ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN Object AS Object_Unit
                                             ON Object_Unit.Id       = OL_Price_Unit.ChildObjectId
                            LEFT JOIN Object AS Object_Goods
                                             ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                            

                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = OL_Price_Unit.ChildObjectId
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Juridical_Retail.childobjectid = 4
                         AND Object_Unit.ValueData not ILIKE '%�����%'
                         AND Object_Unit.isErased = False
                         AND Object_Goods.isErased = FALSE),

          tmpUnitCheckAll AS (SELECT ACI.UnitId                    AS UnitId
                              FROM AnalysisContainerItem AS ACI
                              WHERE ACI.OperDate < CURRENT_DATE - ((inRangeOfDays)::TVarChar||' DAY')::INTERVAL
                                AND ACI.OperDate >= CURRENT_DATE - ((inRangeOfDays + 10)::TVarChar||' DAY')::INTERVAL

                         GROUP BY ACI.UnitId
                        )
                        
          SELECT tmpUnitCheckAll.UnitId                    AS UnitId
                           FROM tmpUnitCheckAll
                           
                                INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                      ON ObjectLink_Unit_Juridical.ObjectId = tmpUnitCheckAll.UnitId
                                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.childobjectid = 4
                                INNER JOIN Object AS Object_Unit
                                                  ON Object_Unit.Id       = tmpUnitCheckAll.UnitId 
                                                 AND Object_Unit.ValueData not ILIKE '%�����%'
                                                 AND Object_Unit.isErased = False
          );
                                
     vbUnitCount := (SELECT Count(*) as UnitCount FROM tmpUnitCheck);

    -- ���������
    RETURN QUERY
     WITH tmpGoods AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , Object_Unit.valuedata             AS UnitName
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , Object_Goods.objectcode           AS GoodsCode
                            , Object_Goods.valuedata            AS GoodsName
                            , MCS_Value.ValueData               AS MCSValue
                            , MCS_isClose.ValueData             AS isClose
                            , MCSIsClose_DateChange.valuedata   AS MCSIsCloseDateChange
                       FROM ObjectLink AS OL_Price_Unit

                            INNER JOIN ObjectBoolean AS MCS_isClose
                                                     ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                    AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                    AND MCS_isClose.ValueData = TRUE
                            LEFT JOIN ObjectDate AS MCSIsClose_DateChange
                                                 ON MCSIsClose_DateChange.ObjectId = OL_Price_Unit.ObjectId
                                                AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()

                            LEFT JOIN ObjectLink AS OL_Price_Goods
                                                 ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN Object AS Object_Unit
                                             ON Object_Unit.Id       = OL_Price_Unit.ChildObjectId
                            LEFT JOIN Object AS Object_Goods
                                             ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                            

                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = OL_Price_Unit.ChildObjectId
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Juridical_Retail.childobjectid = 4
                         AND Object_Unit.ValueData not ILIKE '%�����%'
                         AND Object_Unit.isErased = False
                         AND Object_Goods.isErased = FALSE),

          tmpGoodsUnitCount AS (SELECT tmpGoods.GoodsId
                                     , COUNT(*)           AS CountUnit
                                FROM tmpGoods
                                GROUP BY tmpGoods.GoodsId
                                HAVING COUNT(*) <= FLOOR(vbUnitCount - vbUnitCount * inPercePharmaciesd / 100)
                                ),
                                
                                
          tmpSelling AS (SELECT ACI.GoodsId                   AS GoodsId
                              , ACI.UnitId                    AS UnitId
                              , SUM(ACI.AmountCheck)          AS AmountCheck
                         FROM AnalysisContainerItem AS ACI
                              
                              LEFT JOIN tmpGoods ON tmpGoods.GoodsId = ACI.GoodsId
                                                AND tmpGoods.UnitId = ACI.UnitId
                                                
                         WHERE ACI.OperDate >= CASE WHEN tmpGoods.MCSIsCloseDateChange IS NULL
                                                      OR tmpGoods.MCSIsCloseDateChange < CURRENT_DATE - ((inRangeOfDays + 1)::TVarChar||' DAY')::INTERVAL 
                                                    THEN CURRENT_DATE - ((inRangeOfDays + 1)::TVarChar||' DAY')::INTERVAL
                                                    ELSE tmpGoods.MCSIsCloseDateChange END

                         GROUP BY ACI.GoodsId
                                , ACI.UnitId
                        ),
           tmpSellingCount AS (SELECT tmpSelling.GoodsId
                                    , COUNT(*)           AS CountSelling
                               FROM tmpSelling
                                    INNER JOIN tmpGoodsUnitCount ON tmpGoodsUnitCount.GoodsId = tmpSelling.GoodsId
                                    INNER JOIN tmpUnitCheck ON tmpUnitCheck.UnitId = tmpSelling.UnitId
                               WHERE tmpSelling.AmountCheck >= inSalesThreshold
                               GROUP BY tmpSelling.GoodsId
                               ),
           tmpDate AS (SELECT tmpGoods.UnitName
                            , tmpGoods.GoodsId
                            , tmpGoods.GoodsCode
                            , tmpGoods.GoodsName
                            , tmpGoods.MCSIsCloseDateChange
                            , tmpGoodsUnitCount.CountUnit::Integer     AS CountUnit
                            , tmpSellingCount.CountSelling::Integer    AS CountSelling
                       FROM tmpGoods

                            INNER JOIN tmpGoodsUnitCount ON tmpGoodsUnitCount.GoodsId = tmpGoods.GoodsId

                            INNER JOIN tmpSellingCount ON tmpSellingCount.GoodsId = tmpGoods.GoodsId
                                                      AND tmpSellingCount.CountSelling >= CEIL((vbUnitCount - tmpGoodsUnitCount.CountUnit) * inPercePharmaciesd / 100)),
           tmpGoodsCount AS (SELECT Count(DISTINCT tmpDate.GoodsId) as GoodsCount FROM tmpDate)

    SELECT tmpDate.UnitName
         , tmpDate.GoodsCode
         , tmpDate.GoodsName
         , tmpDate.MCSIsCloseDateChange
         , tmpDate.CountUnit
         , tmpDate.CountSelling
         , vbUnitCount
         , tmpGoodsCount.GoodsCount::Integer
    FROM tmpDate

         INNER JOIN tmpGoodsCount ON 1 = 1

    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.04.21                                                       *
*/

-- ����

SELECT * FROM gpSelect_KilledCodeRecovery(200, 60, 1, '3')