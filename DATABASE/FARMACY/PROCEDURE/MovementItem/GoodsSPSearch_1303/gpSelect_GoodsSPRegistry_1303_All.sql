 -- Function: gpSelect_GoodsSPRegistry_1303_All()

DROP FUNCTION IF EXISTS gpSelect_GoodsSPRegistry_1303_All (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSPRegistry_1303_All(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (GoodsId        Integer
             , GoodsMainId    Integer
             , NDS            TFloat
             , PriceOptSP     TFloat
             , PriceSale      TFloat
             , MovementItemId Integer
             , isOrder408     Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;  
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP_1303());
    vbUserId:= lpGetUserBySession (inSession);

    -- ���� ������������
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

    RETURN QUERY
    WITH
        tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
      , tmpGoodsSPRegistry_1303 AS (SELECT MovementItem.Id               AS MovementItemId
                                         , MovementItem.ObjectId         AS GoodsId
                                         , COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat       AS NDS
                                         , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
                                         , ROUND(MIFloat_PriceOptSP.ValueData  *  1.1 * 1.1 * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2)::TFloat AS PriceSale

                                                                          -- � �/� - �� ������ ������
                                         , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, MIDate_OrderDateSP.ValueData DESC) AS Ord
                                    FROM Movement
                                         INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                                 ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                                AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                                AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                                         INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                                 ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                                AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                                AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

                                         LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                               AND MovementItem.isErased   = FALSE
                                                               AND COALESCE (MovementItem.ObjectId, 0) <> 0

                                         LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                                     ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                                         LEFT JOIN MovementItemFloat AS MIFloat_OrderNumberSP
                                                                     ON MIFloat_OrderNumberSP.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_OrderNumberSP.DescId = zc_MIFloat_OrderNumberSP()  
                                         LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                                    ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                                   AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()

                                         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
                                         LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                              ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

                                    WHERE Movement.DescId = zc_Movement_GoodsSPSearch_1303()
                                      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                      AND COALESCE (MovementItem.ObjectId, 0) <> 0
                                   )
       , tmpGoodsSPRegistry_408 AS (               
                                    SELECT MovementItem.Id               AS MovementItemId
                                         , MovementItem.ObjectId         AS GoodsId
                                         , COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat       AS NDS
                                         , MIFloat_PriceOptSP.ValueData                                 AS PriceOptSP
                                         , ROUND(MIFloat_PriceOptSP.ValueData  *  1.1 * 1.1 * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2)::TFloat AS PriceSale

                                                                          -- � �/� - �� ������ ������
                                         , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, MIDate_OrderDateSP.ValueData DESC) AS Ord
                                    FROM Movement
                                         INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                                 ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                                AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                                AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                                         INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                                 ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                                AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                                AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

                                         LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                               AND MovementItem.isErased   = FALSE
                                                               AND COALESCE (MovementItem.ObjectId, 0) <> 0

                                         LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                                     ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                                         LEFT JOIN MovementItemFloat AS MIFloat_OrderNumberSP
                                                                     ON MIFloat_OrderNumberSP.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_OrderNumberSP.DescId = zc_MIFloat_OrderNumberSP()  
                                         LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                                    ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                                   AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()

                                         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
                                         LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                              ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

                                    WHERE Movement.DescId = zc_Movement_GoodsSP408_1303()
                                      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                      AND COALESCE (MovementItem.ObjectId, 0) <> 0
                                      AND COALESCE (MIFloat_PriceOptSP.ValueData, 0) > 0
                                   )

        SELECT Object_Goods_Retail.Id                          AS GoodsId
             , Object_Goods.Id                                 AS GoodsMainId  

             , COALESCE(tmpGoodsSPRegistry_1303.NDS, tmpGoodsSPRegistry_408.NDS)                         AS NDS
             , COALESCE(tmpGoodsSPRegistry_1303.PriceOptSP, tmpGoodsSPRegistry_408.PriceOptSP)           AS PriceOptSP
             , COALESCE(tmpGoodsSPRegistry_1303.PriceSale, tmpGoodsSPRegistry_408.PriceSale)             AS PriceSale

             , COALESCE(tmpGoodsSPRegistry_1303.MovementItemId, tmpGoodsSPRegistry_408.MovementItemId)   AS MovementItemId
             , COALESCE(tmpGoodsSPRegistry_1303.MovementItemId, 0) = 0                                   AS isOrder408

        FROM tmpGoodsSPRegistry_1303
        
             FULL JOIN tmpGoodsSPRegistry_408 ON tmpGoodsSPRegistry_408.GoodsId = tmpGoodsSPRegistry_1303.GoodsId
                                             AND tmpGoodsSPRegistry_408.Ord = 1 

             LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = COALESCE(tmpGoodsSPRegistry_1303.GoodsId, tmpGoodsSPRegistry_408.GoodsId)
             LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods.Id
                                                                 AND Object_Goods_Retail.RetailId = vbObjectId
                                              
        WHERE COALESCE(tmpGoodsSPRegistry_1303.Ord, 1) = 1
          AND COALESCE (Object_Goods_Retail.Id, 0) <> 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.04.22                                                       *
*/

--����
-- 
select * from gpSelect_GoodsSPRegistry_1303_All(inSession := '3');