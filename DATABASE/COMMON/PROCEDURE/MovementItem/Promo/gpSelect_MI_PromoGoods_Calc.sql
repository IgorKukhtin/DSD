-- Function: gpSelect_MI_PromoGoods_Calc()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoGoods_Calc (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoGoods_Calc(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (NUM Integer , GroupNum Integer --
      , Id                      Integer --�������������
      , GoodsId                 Integer --�� ������� <�����>
      , GoodsCode               Integer --��� �������  <�����>
      , GoodsName               TVarChar --������������ ������� <�����>
      
      , GoodsKindName           TVarChar --������������ ������� <��� ������>
      , GoodsKindCompleteName   TVarChar --������������ ������� <��� ������(����������)>

      , PriceIn                 TFloat --���-�� ����, ���/��
      , AmountRetIn             TFloat --���-�� ������� ���/��
      , ContractCondition       TFloat --����� ���� ���/��
      , AmountPlanMax           TFloat --�������� ������������ ������ ������ �� ��������� ������ (� ��)
      , SummaPlanMax            TFloat --�������� ������������ ������ ������ �� ��������� ������ (� ��)
      , Price                   TFloat --���� � ������
      , PriceWithVAT            TFloat --���� �������� � ������ ���, � ������ ������, ���
      , PromoCondition          TFloat --
      , SummaProfit             TFloat --�������
      
      , Color_PriceIn           Integer
      , Color_RetIn             Integer
      , Color_ContractCond      Integer
      , Color_AmountPlanMax     Integer
      , Color_SummaPlanMax      Integer
      , Color_Price             Integer
      , Color_PriceWithVAT      Integer
      , Color_PromoCond         Integer
      , Color_SummaProfit       Integer
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH
    ---- �������� (% ������ / % �����������)
    tmpMIChild AS (SELECT MovementItem.Amount        -- �������� (% ������ / % �����������)
                   FROM  MovementItem
                   WHERE MovementItem.MovementId = inMovementId 
                     AND MovementItem.DescId = zc_MI_Child()
                     AND MovementItem.isErased = FALSE
                  )
    -- ��� ������
  , tmpData AS (SELECT MovementItem.Id                        AS Id                     --�������������
                     , MovementItem.ObjectId                  AS GoodsId                --�� ������� <�����>
                     , Object_Goods.ObjectCode::Integer       AS GoodsCode              --��� �������  <�����>
                     , Object_Goods.ValueData                 AS GoodsName              --������������ ������� <�����>
                     , Object_GoodsKind.ValueData             AS GoodsKindName          --������������ ������� <��� ������>
                     , Object_GoodsKindComplete.ValueData     AS GoodsKindCompleteName  --������������ ������� <��� ������(����������)>
                            
                     , MovementItem.Amount                    AS Amount                 --% ������ �� �����
                     
                     , MIFloat_PriceIn1.ValueData             AS PriceIn1               --���-�� - 1 ����, ���/��
                     , MIFloat_PriceIn2.ValueData             AS PriceIn2               --���-�� - 2 ����, ���/��
                     , MIFloat_Price.ValueData                AS Price                  --���� � ������
                     , MIFloat_PriceWithVAT.ValueData         AS PriceWithVAT           --���� �������� � ������ ���, � ������ ������, ���
               
                     , MIFloat_AmountPlanMax.ValueData        AS AmountPlanMax          --�������� ������������ ������ ������ �� ��������� ������ (� ��)
                     , (MIFloat_AmountPlanMax.ValueData * MIFloat_PriceWithVAT.ValueData)
                                                              AS SummaPlanMax           --����� ����� ������
                     , MIFloat_AmountRetIn.ValueData          AS AmountRetIn            --���-�� ������� (����)
                     , CAST (CASE WHEN COALESCE (MIFloat_AmountReal.ValueData, 0) <> 0 
                            THEN MIFloat_AmountRetIn.ValueData * 100 / MIFloat_AmountReal.ValueData
                            ELSE 0 
                       END AS NUMERIC (16,2))                 AS RetIn_Percent          -- % ��������

                     , MIFloat_ContractCondition.ValueData    AS ContractCondition      -- ����� ����, %
                     , tmpMIChild.Amount                      AS PromoCondition         -- % �������������� ������

                FROM MovementItem
                     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                     LEFT JOIN MovementItemFloat AS MIFloat_PriceIn1
                                                 ON MIFloat_PriceIn1.MovementItemId = MovementItem.Id
                                                AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()
                     LEFT JOIN MovementItemFloat AS MIFloat_PriceIn2
                                                 ON MIFloat_PriceIn2.MovementItemId = MovementItem.Id
                                                AND MIFloat_PriceIn2.DescId = zc_MIFloat_PriceIn2()
             
                     LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                 ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                                AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                                   
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountReal
                                                 ON MIFloat_AmountReal.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountRetIn
                                                 ON MIFloat_AmountRetIn.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountRetIn.DescId = zc_MIFloat_AmountRetIn()
                                                
                      LEFT JOIN MovementItemFloat AS MIFloat_ContractCondition
                                                 ON MIFloat_ContractCondition.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContractCondition.DescId = zc_MIFloat_ContractCondition()

                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                  ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                                   
                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()

                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
        
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                      ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                     LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId

                     LEFT JOIN tmpMIChild ON 1=1 
                     
                WHERE MovementItem.MovementId = inMovementId 
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                )
 
  , tmpData_All AS (SELECT 1                         AS NUM
                         , tmpData.Id                  --�������������
                         , tmpData.GoodsId             --�� ������� <�����>
                         , tmpData.GoodsCode           --��� �������  <�����>
                         , tmpData.GoodsName           --������������ ������� <�����>
                         , tmpData.GoodsKindName
                         , tmpData.GoodsKindCompleteName
                   
                         , 0                         AS PriceIn  
                         , tmpData.RetIn_Percent     AS AmountRetIn           
                         , tmpData.ContractCondition AS ContractCondition   -- ����� ����
                         , 0                         AS AmountPlanMax
                         , 0                         AS SummaPlanMax
                         , 0                         AS Price
                         , tmpData.Amount            AS PriceWithVAT
                         , tmpData.PromoCondition    AS PromoCondition      --  ����������� �� ���.�����, ���/��
                         , 0                         AS SummaProfit              -- �������
                               
                         , zc_Color_White()          AS Color_PriceIn
                         , 16764159                  AS Color_RetIn
                         , 11658012                  AS Color_ContractCond
                         , zc_Color_White()          AS Color_AmountPlanMax
                         , zc_Color_White()          AS Color_SummaPlanMax
                         , zc_Color_White()          AS Color_Price 
                         , 11658012                  AS Color_PriceWithVAT
                         , 11658012                  AS Color_PromoCond
                         , zc_Color_White()          AS Color_SummaProfit
                    FROM tmpData
                         
                  UNION
                    SELECT 2                           AS NUM
                         , tmpData.Id                      --�������������
                         , tmpData.GoodsId                 --�� ������� <�����>
                         , tmpData.GoodsCode               --��� �������  <�����>
                         , tmpData.GoodsName               --������������ ������� <�����>
                         , tmpData.GoodsKindName
                         , tmpData.GoodsKindCompleteName

                         , tmpData.PriceIn1            AS PriceIn  
                         , CAST (COALESCE (CASE WHEN tmpData.AmountPlanMax <> 0 THEN (tmpData.SummaPlanMax * tmpData.RetIn_Percent /100) / tmpData.AmountPlanMax ELSE 0 END, 0) AS NUMERIC (16,2)) AS AmountRetIn           
                         , CAST (COALESCE (CASE WHEN tmpData.AmountPlanMax <> 0 THEN (tmpData.SummaPlanMax * tmpData.ContractCondition /100) / tmpData.AmountPlanMax ELSE 0 END, 0)  AS NUMERIC (16,2)) AS ContractCondition   -- ����� ����
                         , tmpData.AmountPlanMax       AS AmountPlanMax
                         , tmpData.SummaPlanMax
                         , tmpData.Price  
                         , tmpData.PriceWithVAT
                         , tmpData.PriceWithVAT * tmpData.PromoCondition / 100  AS PromoCondition         --  ����������� �� ���.�����, ���/��
                         , tmpData.SummaPlanMax - (COALESCE (tmpData.PriceIn1, 0) 
                                                 + CAST (COALESCE (CASE WHEN tmpData.AmountPlanMax <> 0 THEN (tmpData.SummaPlanMax * tmpData.RetIn_Percent /100) / tmpData.AmountPlanMax ELSE 0 END, 0) AS NUMERIC (16,2))
                                                 + CAST (COALESCE (CASE WHEN tmpData.AmountPlanMax <> 0 THEN (tmpData.SummaPlanMax * tmpData.ContractCondition /100) / tmpData.AmountPlanMax ELSE 0 END, 0) AS NUMERIC (16,2))
                                                  ) 
                                                  * tmpData.AmountPlanMax    AS SummaProfit               -- �������

                         , 11658012                    AS Color_PriceIn
                         , zc_Color_White()            AS Color_RetIn
                         , zc_Color_White()            AS Color_ContractCond
                         , 11658012                    AS Color_AmountPlanMax
                         , zc_Color_White()            AS Color_SummaPlanMax
                         , 11658012                    AS Color_Price 
                         , zc_Color_White()            AS Color_PriceWithVAT
                         , zc_Color_White()            AS Color_PromoCond
                         , zc_Color_Yelow()            AS Color_SummaProfit
                    FROM tmpData
                         LEFT JOIN tmpMIChild ON 1=1
                  UNION
                    SELECT 3                         AS NUM
                         , tmpData.Id                  --�������������
                         , tmpData.GoodsId             --�� ������� <�����>
                         , tmpData.GoodsCode           --��� �������  <�����>
                         , tmpData.GoodsName           --������������ ������� <�����>
                         , tmpData.GoodsKindName
                         , tmpData.GoodsKindCompleteName

                         , 0                         AS PriceIn  
                         , tmpData.RetIn_Percent     AS AmountRetIn           
                         , tmpData.ContractCondition AS ContractCondition
                         , 0                         AS AmountPlanMax
                         , 0                         AS SummaPlanMax
                         , 0                         AS Price
                         , tmpData.Amount            AS PriceWithVAT
                         , tmpData.PromoCondition    AS PromoCondition 
                         , 0                         AS SummaProfit    
                                                  
                         , zc_Color_White()          AS Color_PriceIn 
                         , 16764159                  AS Color_RetIn
                         , 11658012                  AS Color_ContractCond
                         , zc_Color_White()          AS Color_AmountPlanMax
                         , zc_Color_White()          AS Color_SummaPlanMax
                         , zc_Color_White()          AS Color_Price 
                         , 11658012                  AS Color_PriceWithVAT
                         , 11658012                  AS Color_PromoCond
                         , zc_Color_White()          AS Color_SummaProfit
                    FROM tmpData
                  UNION
                    SELECT 4                           AS NUM
                         , tmpData.Id                      --�������������
                         , tmpData.GoodsId                 --�� ������� <�����>
                         , tmpData.GoodsCode               --��� �������  <�����>
                         , tmpData.GoodsName               --������������ ������� <�����>
                         , tmpData.GoodsKindName
                         , tmpData.GoodsKindCompleteName

                         , tmpData.PriceIn2            AS PriceIn  
                         , CAST (COALESCE (CASE WHEN tmpData.AmountPlanMax <> 0 THEN (tmpData.SummaPlanMax * tmpData.RetIn_Percent /100) / tmpData.AmountPlanMax ELSE 0 END, 0) AS NUMERIC (16,2)) AS AmountRetIn           
                         , CAST (COALESCE (CASE WHEN tmpData.AmountPlanMax <> 0 THEN (tmpData.SummaPlanMax * tmpData.ContractCondition /100) / tmpData.AmountPlanMax ELSE 0 END, 0) AS NUMERIC (16,2)) AS ContractCondition
                         , tmpData.AmountPlanMax       AS AmountPlanMax
                         , tmpData.SummaPlanMax        AS SummaPlanMax
                         , tmpData.Price               AS Price
                         , tmpData.PriceWithVAT        AS PriceWithVAT
                         , tmpData.PriceWithVAT * tmpData.PromoCondition / 100  AS PromoCondition         --  ����������� �� ���.�����, ���/��
                         , tmpData.SummaPlanMax - (COALESCE (tmpData.PriceIn2, 0) 
                                                 + CAST (COALESCE (CASE WHEN tmpData.AmountPlanMax <> 0 THEN (tmpData.SummaPlanMax * tmpData.RetIn_Percent /100) / tmpData.AmountPlanMax ELSE 0 END, 0) AS NUMERIC (16,2))
                                                 + CAST (COALESCE (CASE WHEN tmpData.AmountPlanMax <> 0 THEN (tmpData.SummaPlanMax * tmpData.ContractCondition /100) / tmpData.AmountPlanMax ELSE 0 END, 0) AS NUMERIC (16,2))
                                                 ) 
                                                 * tmpData.AmountPlanMax    AS SummaProfit               -- �������
                         
                         , 11658012                    AS Color_PriceIn
                         , zc_Color_White()            AS Color_RetIn
                         , zc_Color_White()            AS Color_ContractCond
                         , 11658012                    AS Color_AmountPlanMax
                         , zc_Color_White()            AS Color_SummaPlanMax
                         , 11658012                    AS Color_Price 
                         , zc_Color_White()            AS Color_PriceWithVAT
                         , zc_Color_White()            AS Color_PromoCond
                         , zc_Color_Yelow()            AS Color_SummaProfit
                    FROM tmpData
                  UNION
                    --����� �������� ��������� ������ ������
                    SELECT 5                AS NUM
                         , tmpData.Id       --�������������
                         , 0                --�� ������� <�����>
                         , 0                          --��� �������  <�����>
                         , ''                         --������������ ������� <�����>
                         , ''
                         , ''
                         , 0                AS PriceIn  
                         , 0                AS AmountRetIn           
                         , 0                AS ContractCondition   -- ����� ����
                         , 0                AS AmountPlanMax
                         , 0                AS SummaPlanMax
                         , 0                AS Price   
                         , 0                AS PriceWithVAT
                         , 0                AS PromoCondition         --  ����������� �� ���.�����, ���/��
                         , 0                AS SummaProfit                 -- �������
                         , zc_Color_White() AS Color_PriceIn
                         , zc_Color_White() AS Color_RetIn
                         , zc_Color_White() AS Color_ContractCond
                         , zc_Color_White() AS Color_AmountPlanMax
                         , zc_Color_White() AS Color_SummaPlanMax
                         , zc_Color_White() AS Color_Price 
                         , zc_Color_White() AS Color_PriceWithVAT
                         , zc_Color_White() AS Color_PromoCond
                         , zc_Color_White() AS Color_SummaProfit
                    FROM tmpData
                   )   
                   
    -- ���������
    SELECT CASE WHEN tmpData_All.NUM = 5 THEN 0 ELSE tmpData_All.NUM END AS NUM
         , CASE WHEN tmpData_All.NUM IN (1, 2) THEN 1
                WHEN tmpData_All.NUM IN (3, 4) THEN 2 
                ELSE 3 
           END AS GroupNum
         , CASE WHEN tmpData_All.NUM = 5 THEN 0 ELSE tmpData_All.Id END  
         , tmpData_All.GoodsId                             
         , tmpData_All.GoodsCode                           
         , tmpData_All.GoodsName               ::TVarChar  
         , tmpData_All.GoodsKindName           ::TVarChar
         , tmpData_All.GoodsKindCompleteName   ::TVarChar

         , tmpData_All.PriceIn                 :: TFloat
         , tmpData_All.AmountRetIn             :: TFloat       
         , tmpData_All.ContractCondition       :: TFloat  
         , tmpData_All.AmountPlanMax           :: TFloat
         , tmpData_All.SummaPlanMax            :: TFloat
         , tmpData_All.Price                   :: TFloat
         , tmpData_All.PriceWithVAT            :: TFloat
         , tmpData_All.PromoCondition          :: TFloat      
         , tmpData_All.SummaProfit             :: TFloat
         
         , tmpData_All.Color_PriceIn
         , tmpData_All.Color_RetIn
         , tmpData_All.Color_ContractCond
         , tmpData_All.Color_AmountPlanMax
         , tmpData_All.Color_SummaPlanMax
         , tmpData_All.Color_Price 
         , tmpData_All.Color_PriceWithVAT
         , tmpData_All.Color_PromoCond
         , tmpData_All.Color_SummaProfit
    FROM tmpData_All
    ORDER BY  tmpData_All.Id, tmpData_All.NUM 
   ;
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 30.11.17         *
 03.08.17         *
*/

-- ����
-- SELECT * FROM gpSelect_MI_PromoGoods_Calc (5083159 , False, '5');
