 -- Function: gpSelect_MovementItem_GoodsSP_1303()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_GoodsSP_1303 (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_GoodsSP_1303(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , GoodsNameUkr  TVarChar
             , MorionCode    Integer
             , NDS           TFloat
             , PriceOptSP    TFloat
             , PriceOOC      TFloat
             , PriceSale     TFloat
             , PriceOptSPRegistry TFloat
             , PriceSaleRegistry TFloat
             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbDateEnd TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP_1303());
    vbUserId:= lpGetUserBySession (inSession);


    -- ��������� �� ���������
    SELECT OperDate INTO vbOperDate FROM Movement WHERE Movement.Id = inMovementId;
    
    SELECT MIN(Movement.OperDate)  AS OperDate
    INTO vbDateEnd
    FROM Movement 
    WHERE Movement.DescId = zc_Movement_GoodsSP_1303()
      AND Movement.StatusId <> zc_Enum_Status_Erased()
      AND Movement.OperDate > vbOperDate;    

    IF inShowAll THEN
    
    RETURN QUERY
    WITH 
        tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
      , tmpGoodsSPRegistry_1303 AS (SELECT MovementItem.ObjectId         AS GoodsId
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

                                    WHERE Movement.DescId = zc_Movement_GoodsSPRegistry_1303()
                                      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                   )


        SELECT COALESCE (MovementItem.Id, 0)                         AS Id
             , tmpGoodsMain.Id                                       AS GoodsId
             , tmpGoodsMain.ObjectCode                               AS GoodsCode
             , tmpGoodsMain.Name                                     AS GoodsName
             , tmpGoodsMain.NameUkr                                  AS GoodsNameUkr
             , tmpGoodsMain.MorionCode                               AS MorionCode
             , ObjectFloat_NDSKind_NDS.ValueData                     AS NDS

             , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
             , ROUND(MIFloat_PriceOptSP.ValueData * 
               (100.0 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100.0 * 1.1, 2)::TFloat AS PriceOOC
             
             , MovementItem.Amount                                   AS PriceSale
             , tmpGoodsSPRegistry_1303.PriceOptSP                    AS PriceOptSPRegistry 
             , tmpGoodsSPRegistry_1303.PriceSale                     AS PriceSaleRegistry 

             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM Object_Goods_Main AS tmpGoodsMain
        
             LEFT JOIN MovementItem ON MovementItem.ObjectId = tmpGoodsMain.Id
                                   AND MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                                    
             LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                         ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()

             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = tmpGoodsMain.NDSKindId
                                  
             LEFT JOIN tmpGoodsSPRegistry_1303 ON tmpGoodsSPRegistry_1303.GoodsId = tmpGoodsMain.Id
                                              AND tmpGoodsSPRegistry_1303.Ord = 1 
            ;

    ELSE
    
    RETURN QUERY
    WITH
    -- �������� ������� �� ������� ���.�������
    tmpSaleAll AS (SELECT Movement_Sale.Id
                   FROM Movement AS Movement_Sale

                        INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                      ON MovementLinkObject_SPKind.MovementId = Movement_Sale.Id
                                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                     AND MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303()


                   WHERE Movement_Sale.DescId in (zc_Movement_Sale(), zc_Movement_Check())
                     AND Movement_Sale.OperDate >= vbOperDate AND Movement_Sale.OperDate < COALESCE(vbDateEnd, CURRENT_DATE) + INTERVAL '1 DAY'
                     AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                  )

      -- �������� ������� �� ������� ���.�������
      ,  tmpMI_Sale AS (SELECT DISTINCT Object_Goods.GoodsMainId     AS GoodsId
                        FROM tmpSaleAll AS Movement_Sale
                             INNER JOIN MovementItem AS MI_Sale
                                                     ON MI_Sale.MovementId = Movement_Sale.Id
                                                    AND MI_Sale.DescId = zc_MI_Master()
                                                    AND MI_Sale.isErased = FALSE
                                                    AND MI_Sale.Amount > 0
                             LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MI_Sale.ObjectId
                       )
      ,  tmpMI AS (SELECT MovementItem.Id                                       AS Id
                        , MovementItem.ObjectId                                 AS GoodsId
                        , MovementItem.Amount                                   AS Amount
                        , MovementItem.isErased                                 AS isErased
                   FROM MovementItem
                   WHERE MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.MovementId = inMovementId
                     AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                  )
      , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
      , tmpGoodsSPRegistry_1303 AS (SELECT MovementItem.ObjectId         AS GoodsId
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

                                    WHERE Movement.DescId = zc_Movement_GoodsSPRegistry_1303()
                                      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                   )

        SELECT MovementItem.Id                                       AS Id
             , COALESCE(MovementItem.GoodsId, tmpMI_Sale.GoodsId)    AS GoodsId
             , Object_Goods.ObjectCode                    ::Integer  AS GoodsCode
             , Object_Goods.Name                                     AS GoodsName
             , Object_Goods.NameUkr                                  AS GoodsNameUkr
             , Object_Goods.MorionCode                               AS MorionCode
             , ObjectFloat_NDSKind_NDS.ValueData                     AS NDS

             , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
             , ROUND(MIFloat_PriceOptSP.ValueData * 
               (100.0 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100.0 * 1.1, 2)::TFloat AS PriceOOC
             , MovementItem.Amount                                   AS PriceSale
             , tmpGoodsSPRegistry_1303.PriceOptSP                    AS PriceOptSPRegistry 
             , tmpGoodsSPRegistry_1303.PriceSale                     AS PriceSaleRegistry 

             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM tmpMI AS MovementItem
        
             FULL JOIN tmpMI_Sale ON tmpMI_Sale.GoodsId = MovementItem.GoodsId
        
        
             LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem.GoodsId, tmpMI_Sale.GoodsId) 
            
             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

             LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                         ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()

             LEFT JOIN tmpGoodsSPRegistry_1303 ON tmpGoodsSPRegistry_1303.GoodsId = MovementItem.GoodsId
                                              AND tmpGoodsSPRegistry_1303.Ord = 1 
         ;
    END IF;            

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

select * from gpSelect_MovementItem_GoodsSP_1303(inMovementId := 27423073 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
