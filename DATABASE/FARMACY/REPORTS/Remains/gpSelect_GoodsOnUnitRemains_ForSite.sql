-- Function: gpSelect_GoodsOnUnitRemains_ForSite

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForSite (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForSite(
    IN inUnitId           Integer  ,  -- �������������
    IN inRemainsDate      TDateTime,  -- ���� �������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupName TVarChar
             , OperAmount TFloat, Price TFloat, NDSKindName TVarChar
             , OperSum TFloat, PriceOut TFloat, SumOut TFloat
             , MinExpirationDate TDateTime)
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
        WITH containerCount AS (SELECT 
                                    container.Id
                                  , container.Amount
                                  ,CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE
                                               THEN MIFloat_Price.ValueData / (1 + ObjectFloat_NDSKind_NDS.ValueData/100)
                                               ELSE MIFloat_Price.ValueData
                                            END::TFloat AS PriceWithOutVAT
                                    -- !!!�������� �����������, ����� ������ ����� �������!!!!
                                  , ObjectLink_Child_NB.ChildObjectId AS ObjectID
                                  , container.ObjectID AS ObjectID_retail
                                FROM 
                                    container
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                        ON CLI_MI.ContainerId = container.Id
                                                                       AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    LEFT OUTER JOIN MovementItem AS MI_Income
                                                                 ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                              ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                                             AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                 ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                                AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                          ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                         AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                                                         
                                    -- !!!�������� �����������, ����� ������ ����� �������!!!!
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = container.ObjectID
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                               AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_NB ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                                                                AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_NB.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!NeBoley!!!
                                WHERE 
                                    container.Amount <> 0
                                    AND
                                    container.descid = zc_container_count()
                                    AND
                                    Container.WhereObjectId = inUnitId)

        SELECT Object_Goods_View.Id                         as Id
             , Object_Goods_View.GoodsCodeInt ::Integer     as GoodsCode
             , Object_Goods_View.GoodsName                  as GoodsName
             , Object_Goods_View.GoodsGroupName             AS GoodsGroupName

             , DD.OperAmount::TFloat                        as OperAmount
             , CASE WHEN DD.OperAmount <> 0 
                 THEN (DD.OperSum / DD.OperAmount)
               END::TFloat                                  as Price
             , Object_Goods_View.NDSKindName                AS NDSKindName  
             , DD.OperSum::TFloat                           as OperSum
             , Object_Price.Price                           as PriceOut
             , (DD.OperAmount * Object_Price.Price)::TFloat as SumOut
             , SelectMinPrice_AllGoods.MinExpirationDate    AS MinExpirationDate
        FROM(
            SELECT 
                SUM(DD.OperAmount) AS OperAmount, 
                SUM(DD.OperSum) AS OperSum, 
                ObjectId, ObjectID_retail
            FROM(
                SELECT 
                    SUM(DD.OperAmount) AS OperAmount, 
                    SUM(DD.OperAmount*PriceWithOutVAT) AS OperSum,
                    ObjectID, ObjectID_retail
                FROM(
                    SELECT 
                        containerCount.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                      , containerCount.PriceWithOutVAT  
                      , containerCount.ObjectID, ObjectID_retail
                    FROM containerCount
                        LEFT JOIN MovementItemContainer AS MIContainer 
                                                        ON MIContainer.ContainerId = containerCount.Id
                                                       AND MIContainer.OperDate > inRemainsDate
                    GROUP BY containerCount.Id, containerCount.ObjectID, ObjectID_retail, containerCount.Amount, containerCount.PriceWithOutVAT
                    ) AS DD
                GROUP BY DD.ObjectID, ObjectID_retail
                /* UNION ALL
                SELECT 
                    0 AS OperAmount, 
                    SUM(DD.OperAmount) AS OperSumm, 
                    ObjectID 
                FROM(
                    SELECT 
                        container.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                      , container.Id
                      , containerCount.ObjectID 
                    FROM Container 
                        JOIN containerCount ON Container.parentid = containerCount.Id
                        LEFT JOIN MovementItemContainer AS MIContainer 
                                                        ON MIContainer.ContainerId = container.Id
                                                       AND MIContainer.OperDate > inRemainsDate
                    GROUP BY container.Id, containerCount.ObjectID, container.Amount
                    ) AS DD
                GROUP BY DD.ObjectID*/
                ) AS DD
            GROUP BY DD.ObjectID, ObjectID_retail
            HAVING (SUM(DD.OperAmount) <> 0)-- OR (SUM(DD.OperSum) <> 0)
            ) AS DD
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = DD.ObjectId

            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON Object_Price.GoodsId = DD.ObjectID_retail -- DD.ObjectId
                                             AND Object_Price.UnitId  = inUnitId

            LEFT JOIN lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                                inObjectId := vbObjectId, 
                                                inUserId := vbUserId) AS SelectMinPrice_AllGoods
                                                                      ON SelectMinPrice_AllGoods.GoodsId = Object_Goods_View.Id
                                                  
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_ForSite (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.01.16         *
 02.06.15                        *

*/

-- ����
-- select * from gpSelect_GoodsOnUnitRemains_ForSite(inUnitId := 377613 , inRemainsDate := ('16.09.2015')::TDateTime ,  inSession := '3');
-- select * from gpSelect_GoodsOnUnitRemains_ForSite(inUnitId := 2144918  , inRemainsDate := ('01.06.2016')::TDateTime ,  inSession := '3'); -- !!!��������!!!
