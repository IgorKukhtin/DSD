-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnOut (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnOut(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , isErased Boolean
             , AmountInIncome TFloat
             , Remains TFloat
             , WarningColor Integer
             , ExpirationDate TDateTime
             , PartionGoods TVarChar
             , MakerName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementIncomeId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    
    --����� �������
    SELECT 
        Movement.ParentId 
    INTO
        vbMovementIncomeId
    FROM 
        Movement
    WHERE 
        Movement.Id = inMovementId;

    --���������    
    IF inShowAll THEN

        RETURN QUERY
            WITH 
                Income AS ( --������� �� �������
                            SELECT
                                MovementItem_Income.Id          AS Id
                               ,MovementItem_Income.GoodsId     AS GoodsId
                               ,MovementItem_Income.GoodsCode   AS GoodsCode
                               ,MovementItem_Income.GoodsName   AS GoodsName
                               ,MovementItem_Income.Price       AS Price
                               ,MovementItem_Income.Amount      AS AmountInIncome 
                               ,Container.Amount                AS AmountRemains
                            FROM 
                                MovementItem_Income_View AS MovementItem_Income
                                LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.MovementItemId = MovementItem_Income.Id
                                                                     AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                LEFT OUTER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                         AND Container.DescId = zc_Container_Count() 
                            WHERE 
                                MovementItem_Income.MovementId = vbMovementIncomeId
                                AND
                                MovementItem_Income.isErased = FALSE
                          ),
                ReturnOut AS (
                                SELECT
                                    Movement_ReturnOut.StatusId
                                   ,MI_ReturnOut.Id
                                   ,MI_ReturnOut.ParentId
                                   ,MI_ReturnOut.GoodsId
                                   ,MI_ReturnOut.GoodsCode
                                   ,MI_ReturnOut.GoodsName
                                   ,MI_ReturnOut.Amount
                                   ,MI_ReturnOut.Price
                                   ,MI_ReturnOut.AmountSumm
                                   ,MI_ReturnOut.isErased
                                FROM
                                    Movement AS Movement_ReturnOut
                                    INNER JOIN MovementItem_ReturnOut_View AS MI_ReturnOut
                                                                           ON MI_ReturnOut.MovementId = Movement_ReturnOut.Id
                                                                          AND (MI_ReturnOut.isErased = FALSE OR inIsErased = TRUE)
                                WHERE
                                    Movement_ReturnOut.Id = inMovementId
                                    
                             )

            SELECT
                MovementItem_ReturnOut.Id
              , MovementItem_Income.Id                                                    AS ParentId
              , COALESCE(MovementItem_ReturnOut.GoodsId, MovementItem_Income.GoodsId)     AS GoodsId
              , COALESCE(MovementItem_ReturnOut.GoodsCode, MovementItem_Income.GoodsCode) AS GoodsCode
              , COALESCE(MovementItem_ReturnOut.GoodsName, MovementItem_Income.GoodsName) AS GoodsName
              , MovementItem_ReturnOut.Amount                                             AS Amount
              , COALESCE(MovementItem_ReturnOut.Price, MovementItem_Income.Price)         AS Price
              , MovementItem_ReturnOut.AmountSumm                                         AS AmountSumm
              , MovementItem_ReturnOut.isErased                                           AS isErased
              , MovementItem_Income.AmountInIncome                                        AS AmountInIncome
              , (COALESCE(MovementItem_Income.AmountRemains,0)
                  + CASE WHEN MovementItem_ReturnOut.StatusId = zc_Enum_Status_Complete()
                      THEN MovementItem_ReturnOut.Amount
                    ELSE 0
                    END)::TFloat                                                          AS Remains
              , CASE 
                  WHEN MovementItem_ReturnOut.Amount > COALESCE(MovementItem_Income.AmountInIncome,0) or
                       MovementItem_ReturnOut.Amount > COALESCE(MovementItem_Income.AmountRemains,0)
                    THEN zc_Color_Warning_Red()
                END                                                                       AS WarningColor
             , MIDate_ExpirationDate.ValueData            AS ExpirationDate
             , MIString_PartionGoods.ValueData            AS PartionGoods
             , ObjectString_Goods_Maker.ValueData         AS MakerName
        FROM Income AS MovementItem_Income
            FULL JOIN ReturnOut AS MovementItem_ReturnOut 
                                ON MovementItem_ReturnOut.ParentId = MovementItem_Income.Id
                                            LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                       ON MIDate_ExpirationDate.MovementItemId = MovementItem_Income.Id
                                      AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MovementItem_Income.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()  
                                        
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem_Income.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                  ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId 
                                 AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker() ;

    ELSE
        RETURN QUERY
            WITH 
                Income AS ( --������� �� �������
                            SELECT
                                MovementItem_Income.Id          AS Id
                               ,MovementItem_Income.GoodsId     AS GoodsId
                               ,MovementItem_Income.GoodsCode   AS GoodsCode
                               ,MovementItem_Income.GoodsName   AS GoodsName
                               ,MovementItem_Income.Amount      AS AmountInIncome 
                               ,Container.Amount                AS AmountRemains
                            FROM 
                                MovementItem_Income_View AS MovementItem_Income
                                LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.MovementItemId = MovementItem_Income.Id
                                                                     AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                LEFT OUTER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                         AND Container.DescId = zc_Container_Count() 
                            WHERE 
                                MovementItem_Income.MovementId = vbMovementIncomeId
                                AND
                                MovementItem_Income.isErased = FALSE
                          ),
                ReturnOut AS (
                                SELECT
                                    Movement_ReturnOut.StatusId
                                   ,MI_ReturnOut.Id
                                   ,MI_ReturnOut.ParentId
                                   ,MI_ReturnOut.GoodsId
                                   ,MI_ReturnOut.GoodsCode
                                   ,MI_ReturnOut.GoodsName
                                   ,MI_ReturnOut.Amount
                                   ,MI_ReturnOut.Price
                                   ,MI_ReturnOut.AmountSumm
                                   ,MI_ReturnOut.isErased
                                FROM
                                    Movement AS Movement_ReturnOut
                                    INNER JOIN MovementItem_ReturnOut_View AS MI_ReturnOut
                                                                           ON MI_ReturnOut.MovementId = Movement_ReturnOut.Id
                                                                          AND (MI_ReturnOut.isErased = FALSE OR inIsErased = TRUE)
                                WHERE
                                    Movement_ReturnOut.Id = inMovementId
                                    
                             )
            SELECT
                MovementItem.Id
              , MovementItem.ParentId  
              , MovementItem.GoodsId
              , MovementItem.GoodsCode
              , MovementItem.GoodsName
              , MovementItem.Amount
              , MovementItem.Price
              , MovementItem.AmountSumm
              , MovementItem.isErased
              , MovementItem_Income.AmountInIncome
              , (COALESCE(MovementItem_Income.AmountRemains,0)
                  + CASE WHEN MovementItem.StatusId = zc_Enum_Status_Complete()
                      THEN MovementItem.Amount
                    ELSE 0
                    END)::TFloat AS Remains
              , CASE 
                  WHEN MovementItem.Amount > COALESCE(MovementItem_Income.AmountInIncome,0) or
                       MovementItem.Amount > COALESCE(MovementItem_Income.AmountRemains,0)
                    THEN zc_Color_Warning_Red()
                END AS WarningColor
             , MIDate_ExpirationDate.ValueData            AS ExpirationDate
             , MIString_PartionGoods.ValueData            AS PartionGoods
             , ObjectString_Goods_Maker.ValueData         AS MakerName
        FROM 
            ReturnOut AS MovementItem
            LEFT OUTER JOIN Income AS MovementItem_Income
                                   ON MovementItem.ParentId = MovementItem_Income.Id

            LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                       ON MIDate_ExpirationDate.MovementItemId = MovementItem_Income.Id
                                      AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MovementItem_Income.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()  
                                        
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem_Income.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                  ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId 
                                 AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()   
            

;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_ReturnOut (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.04.16         *
 10.02.15                         *
 
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
--select * from gpSelect_MovementItem_ReturnOut(inMovementId := 885245 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');