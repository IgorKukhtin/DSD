-- Function: gpSelect_MI_PromoGoods_Calc_all()

--���������� gpSelect_MI_PromoGoods_Calc ������ ��� ��� ����� �������  !!!!!!

DROP FUNCTION IF EXISTS gpSelect_MI_PromoGoods_Calc_all (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoGoods_Calc_all(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inIsTaxPromo  Boolean      , -- �����
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (NUM Integer , GroupNum Integer --
      , Id                      Integer --�������������
      , GoodsId                 Integer --�� ������� <�����>
      , GoodsCode               Integer --��� �������  <�����>
      , GoodsName               TVarChar --������������ ������� <�����>
      
      , GoodsKindName           TVarChar --������������ ������� <��� ������>
      , GoodsKindCompleteName   TVarChar --������������ ������� <��� ������(����������)>
      , MeasureName             TVarChar -- ��.���

      , PriceIn                 TFloat --���-�� ����, ���/��
      , ChangePrice             TFloat --���-�� �������, ���/��
      --, AmountRetIn             TFloat --���-�� ������� ���/��
      , ContractCondition       TFloat --TVarChar --����� ���� ���/��
      , TaxRetIn                TFloat --TVarChar --
      , TaxPromo                TFloat --TVarChar --
      , TaxPromo_Condition      TFloat --TVarChar --
      , AmountSale              TFloat --�������� ������������ ������ ������ �� ��������� ������ (��)
      , AmountSaleWeight        TFloat -- ���
      , SummaSale               TFloat --�������� ������������ ������ ������ �� ��������� ������ 
      , Price                   TFloat --���� � ������ �� ��
      , PriceWithVAT            TFloat --���� �������� � ������ ���, � ������ ������, ��� �� ��
      , Price_sh                TFloat --���� � ������ �� ��
      , PriceWithVAT_sh         TFloat --���� �������� � ������ ���, � ������ ������, ��� �� ��
      , PromoCondition          TFloat --
      , SummaProfit             TFloat --�������
      , SummaProfit_Condition   TFloat --
      --, SummaDiscount           TFloat -- ������
      , test1   TFloat --
      
      
      , Color_PriceIn           Integer
      , Color_RetIn             Integer
      , Color_ContractCond      Integer
      , Color_AmountSale        Integer
      , Color_SummaSale         Integer
      , Color_Price             Integer
      , Color_PriceWithVAT      Integer
      , Color_PromoCond         Integer
      , Color_SummaProfit       Integer
      , Text                    TVarChar
      , Repository              Integer
)
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbTaxPromo Boolean;
    DECLARE vbVAT TFloat;
    DECLARE vbPriceList Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);
    
    vbTaxPromo := (SELECT MovementBoolean.ValueData FROM MovementBoolean 
                   WHERE MovementBoolean.MovementId = inMovementId
                     AND MovementBoolean.DescId = zc_MovementBoolean_TaxPromo()
                   ) :: Boolean;
    

    --������ ���������
    SELECT COALESCE(Movement_Promo.PriceListId,zc_PriceList_Basis())
    INTO vbPriceList
    FROM Movement_Promo_View AS Movement_Promo
    WHERE Movement_Promo.Id = inMovementId;
    --�������� �������� "� ���" � "�������� ���"
    SELECT PriceList.VATPercent
    INTO vbVAT
    FROM gpGet_Object_PriceList (vbPriceList,inSession) as PriceList;

/*  IF inIsTaxPromo <> vbTaxPromo
    THEN
        RETURN;
    END IF;
*/
    RETURN QUERY
    WITH
    ---- �������� (% ������ / % �����������)
    tmpMIChild AS (SELECT SUM (MovementItem.Amount) AS Amount        -- �������� (% ������ / % �����������)
                   FROM  MovementItem
                   WHERE MovementItem.MovementId = inMovementId 
                     AND MovementItem.DescId = zc_MI_Child()
                     AND MovementItem.isErased = FALSE
                  )
    -- ��� ������
  , tmpData_Full AS (SELECT MovementItem.Id                        AS Id                     --�������������
                          , MovementItem.ObjectId                  AS GoodsId                --�� ������� <�����>
                          , Object_Goods.ObjectCode::Integer       AS GoodsCode              --��� �������  <�����>
                          , Object_Goods.ValueData                 AS GoodsName              --������������ ������� <�����>
                          , Object_GoodsKind.ValueData             AS GoodsKindName          --������������ ������� <��� ������>
                          , Object_GoodsKindComplete.ValueData     AS GoodsKindCompleteName  --������������ ������� <��� ������(����������)>
                                 
                          , MovementItem.Amount                    AS Amount                 --% ������ �� �����
                          
                          , MIFloat_PriceIn1.ValueData             AS PriceIn1               --���-�� - 1 ����, ���/��
                          , MIFloat_PriceIn2.ValueData             AS PriceIn2               --���-�� - 2 ����, ���/��
                          , MIFloat_ChangePrice.ValueData          AS ChangePrice            --
                          --, (MIFloat_Price.ValueData)                AS Price                  --���� � ������
                            -- ���� � ������ c ���
                          , ROUND (MIFloat_Price.ValueData * ((100+vbVAT)/100)  / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END, 2) :: TFloat AS Price
                          
                          , (MIFloat_PriceWithVAT.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END) :: TFloat AS PriceWithVAT           --���� �������� � ������ ���, � ������ ������, ���
                    
                          , SUM (MIFloat_AmountPlanMax.ValueData) OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0))  AS AmountSale          --�������� ������������ ������ ������ �� ��������� ������ (� ��)

                          , SUM (CASE WHEN COALESCE (vbTaxPromo,FALSE) = TRUE
                                      THEN (MIFloat_AmountPlanMax.ValueData * MIFloat_PriceWithVAT.ValueData) / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                      ELSE MIFloat_AmountPlanMax.ValueData * ROUND (MIFloat_Price.ValueData * ((100+vbVAT)/100) / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END, 2)
                                 END)
                                 OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0))  AS SummaSale                            --����� ����� ������
     
                          , MIFloat_ContractCondition.ValueData    AS ContractCondition      -- ����� ����, %
                          , MIFloat_TaxRetIn.ValueData             AS TaxRetIn               -- % �������
                          --, MIFloat_TaxPromo.ValueData             AS TaxPromo               -- % c�����
                          , MovementItem.Amount                    AS TaxPromo               -- % c����� �� �������
                          , tmpMIChild.Amount                      AS PromoCondition         -- % �������������� ������
                          
                          , (MIFloat_PriceWithVAT.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END * COALESCE (MIFloat_TaxRetIn.ValueData,0) /100) AS AmountRetIn 
                          
                          , ROW_NUMBER() OVER (/*PARTITION BY MovementItem.Id*/ ORDER BY MovementItem.Id Desc) AS Ord        -- ��� ������ ������ ������
                           /* �������� ����� 1 ���, ���� ���� zc_MI_Master.ObjectId ��������� - �� �� ����� ����*/
                          , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ORDER BY MovementItem.Id)    AS Ord_goods  -- ��� ������ ������ 1 ��� ������
     
                     FROM MovementItem
                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
     
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceIn1
                                                      ON MIFloat_PriceIn1.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceIn2
                                                      ON MIFloat_PriceIn2.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceIn2.DescId = zc_MIFloat_PriceIn2()
                          LEFT JOIN MovementItemFloat AS MIFloat_ChangePrice
                                                      ON MIFloat_ChangePrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ChangePrice.DescId = zc_MIFloat_ChangePrice()
                                                     
                  
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                      ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()  ---zc_MIFloat_PriceWithOutVAT() ---
                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                                                     
                                        
                          LEFT JOIN MovementItemFloat AS MIFloat_ContractCondition
                                                      ON MIFloat_ContractCondition.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ContractCondition.DescId = zc_MIFloat_ContractCondition()
                          LEFT JOIN MovementItemFloat AS MIFloat_TaxRetIn
                                                      ON MIFloat_TaxRetIn.MovementItemId = MovementItem.Id
                                                     AND MIFloat_TaxRetIn.DescId = zc_MIFloat_TaxRetIn()
                          LEFT JOIN MovementItemFloat AS MIFloat_TaxPromo
                                                      ON MIFloat_TaxPromo.MovementItemId = MovementItem.Id
                                                     AND MIFloat_TaxPromo.DescId = zc_MIFloat_TaxPromo()
     
                           /*LEFT JOIN MovementItemFloat AS MIFloat_AmountSale
                                                       ON MIFloat_AmountSale.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSale.DescId = zc_MIFloat_AmountSale()*/
                                        
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
     
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                      ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

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
 
  , tmpData AS (SELECT tmpData_Full.Id                     --�������������
                     , tmpData_Full.GoodsId                --�� ������� <�����>
                     , tmpData_Full.GoodsCode              --��� �������  <�����>
                     , tmpData_Full.GoodsName              --������������ ������� <�����>
                     , tmpData_Full.GoodsKindName          --������������ ������� <��� ������>
                     , tmpData_Full.GoodsKindCompleteName  --������������ ������� <��� ������(����������)>
                     , tmpData_Full.Amount                 --% ������ �� �����
                     , tmpData_Full.PriceIn1               --���-�� - 1 ����, ���/��
                     , tmpData_Full.PriceIn2               --���-�� - 2 ����, ���/��
                     , tmpData_Full.ChangePrice
                          
                     , tmpData_Full.AmountSale             --�������� ������������ ������ ������ �� ��������� ������ (� ��)
                     , tmpData_Full.SummaSale              --����� ����� ������

                     , tmpData_Full.ContractCondition      -- ����� ����, %
                     , tmpData_Full.TaxRetIn               -- % �������
                     , tmpData_Full.TaxPromo               -- % c����� �� �������
                     , tmpData_Full.PromoCondition         -- % �������������� ������
                     
                     , tmpData_Full.AmountRetIn 
                     , tmpData_Full.Ord        -- ��� ������ ������ ������
                      /* �������� ����� 1 ���, ���� ���� zc_MI_Master.ObjectId ��������� - �� �� ����� ����*/
                     , tmpData_Full.Ord_goods  -- ��� ������ ������ 1 ��� ������
                          
                       --��� �� ������������� ���� �� ��
                     , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectFloat_Goods_Weight.ValueData,0) <> 0 THEN tmpData_Full.Price/ ObjectFloat_Goods_Weight.ValueData ELSE tmpData_Full.Price END::TFloat AS Price
                     , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectFloat_Goods_Weight.ValueData,0) <> 0 THEN tmpData_Full.PriceWithVAT/ ObjectFloat_Goods_Weight.ValueData ELSE tmpData_Full.PriceWithVAT END::TFloat AS PriceWithVAT
                     --���� �� ��
                     , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpData_Full.Price ELSE 0 END::TFloat AS Price_sh
                     , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpData_Full.PriceWithVAT ELSE 0 END::TFloat AS PriceWithVAT_sh

                FROM tmpData_Full
                     LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                          ON ObjectLink_Goods_Measure.ObjectId = tmpData_Full.GoodsId
                                         AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                     LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                                 ON ObjectFloat_Goods_Weight.ObjectId = tmpData_Full.GoodsId
                                                AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()
 ---!!!!!!--!!!!!---  WHERE tmpData_Full.Ord_goods = 1
                )

  , tmpData_All AS (SELECT 1                         AS NUM
                         , tmpData.Id                  --�������������
                         , tmpData.GoodsId             --�� ������� <�����>
                         , tmpData.GoodsCode           --��� �������  <�����>
                         , tmpData.GoodsName           --������������ ������� <�����>
                         , tmpData.GoodsKindName
                         , tmpData.GoodsKindCompleteName

                         , 0                         AS PriceIn  
                         , 0                         AS ChangePrice
                         --, tmpData.RetIn_Percent     AS AmountRetIn           
                         /*, (CAST (tmpData.ContractCondition AS NUMERIC (16,2)) ||' %') ::TVarChar AS ContractCondition
                         , (CAST (tmpData.TaxRetIn          AS NUMERIC (16,2)) ||' %') ::TVarChar AS TaxRetIn
                         , (CAST (tmpData.TaxPromo          AS NUMERIC (16,2)) ||' %') ::TVarChar AS TaxPromo
                         , (CAST (tmpData.PromoCondition    AS NUMERIC (16,2)) ||' %') ::TVarChar AS TaxPromo_Condition
                         */
                         , CAST (tmpData.ContractCondition AS NUMERIC (16,2))  AS ContractCondition
                         , CAST (tmpData.TaxRetIn          AS NUMERIC (16,2))  AS TaxRetIn
                         , CAST (tmpData.TaxPromo          AS NUMERIC (16,2))  AS TaxPromo
                         , CAST (tmpData.PromoCondition    AS NUMERIC (16,2))  AS TaxPromo_Condition
                         , 0                         AS AmountSale
                         , 0                         AS SummaSale
                         , 0                         AS Price
                         , 0                         AS PriceWithVAT
                         , 0                         AS Price_sh
                         , 0                         AS PriceWithVAT_sh
                         , tmpData.PromoCondition    AS PromoCondition 
                         , 0                         AS SummaProfit
                         , 0                         AS SummaProfit_Condition  

                         , zc_Color_White()          AS Color_PriceIn
                         , zc_Color_Yelow()          AS Color_RetIn          --16764159
                         , zc_Color_Yelow()          AS Color_ContractCond   --11658012
                         , zc_Color_White()          AS Color_AmountSale
                         , zc_Color_White()          AS Color_SummaSale
                         , zc_Color_White()          AS Color_Price 
                         , zc_Color_White()          AS Color_PriceWithVAT   --11658012
                         , zc_Color_White()          AS Color_PromoCond      --11658012
                         , zc_Color_White()          AS Color_SummaProfit
                         , '�����������'             AS Text
                         , 1                         AS Repository
                    FROM tmpData
                  UNION
                    SELECT 2                           AS NUM
                         , tmpData.Id                      --�������������
                         , tmpData.GoodsId                 --�� ������� <�����>
                         , tmpData.GoodsCode               --��� �������  <�����>
                         , tmpData.GoodsName               --������������ ������� <�����>
                         , tmpData.GoodsKindName
                         , tmpData.GoodsKindCompleteName

                         , COALESCE (tmpData.PriceIn2,0)        AS PriceIn  
                         , tmpData.ChangePrice

                         --, CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN (tmpData.SummaSale * tmpData.RetIn_Percent /100) / tmpData.AmountSale ELSE 0 END, 0) AS NUMERIC (16,2)) AS AmountRetIn           
                         /*, (CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.ContractCondition /100 / tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2))) ::TVarChar AS ContractCondition   -- ����� ����
                         , (CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.TaxRetIn /100 / tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2)))          ::TVarChar AS TaxRetIn
                         , (CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.Price * (100-tmpData.TaxPromo) /100 ELSE 0 END, 0)  AS NUMERIC (16,2)))                             ::TVarChar AS TaxPromo
                         , (CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.PromoCondition /100/ tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2)))     ::TVarChar AS TaxPromo_Condition
                         */
                         , CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.ContractCondition /100 / tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2))  AS ContractCondition   -- ����� ����
                         , CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.TaxRetIn /100 / tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2))           AS TaxRetIn
                         , CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.Price * (100-tmpData.TaxPromo) /100 ELSE 0 END, 0)  AS NUMERIC (16,2))                              AS TaxPromo
                         , CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.PromoCondition /100/ tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2))      AS TaxPromo_Condition

                         , tmpData.AmountSale       AS AmountSale
                         , tmpData.SummaSale
                         , tmpData.Price               AS Price
                         , tmpData.PriceWithVAT        AS PriceWithVAT
                         , tmpData.Price_sh            AS Price_sh
                         , tmpData.PriceWithVAT_sh     AS PriceWithVAT_sh
                         , tmpData.PriceWithVAT * tmpData.PromoCondition / 100  AS PromoCondition         --  ����������� �� ���.�����, ���/��
                         , tmpData.SummaSale
                                               - (
                                                   COALESCE (tmpData.PriceIn2, 0) 
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.TaxRetIn /100 / tmpData.AmountSale ELSE 0 END, 0)
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.ContractCondition /100 / tmpData.AmountSale ELSE 0 END, 0)
                                                 ) 
                                                  * tmpData.AmountSale    AS SummaProfit               -- �������

                         , tmpData.SummaSale - (COALESCE (tmpData.PriceIn2, 0) 
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN (tmpData.SummaSale * tmpData.TaxRetIn /100) / tmpData.AmountSale ELSE 0 END, 0)
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN (tmpData.SummaSale * tmpData.ContractCondition /100) / tmpData.AmountSale ELSE 0 END, 0)
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN (tmpData.SummaSale * tmpData.PromoCondition /100) / tmpData.AmountSale ELSE 0 END, 0)
                                                 ) 
                                                 * tmpData.AmountSale    AS SummaProfit_Condition     -- ������� (�������� �����������)
                         
                         , zc_Color_Yelow()            AS Color_PriceIn      --11658012
                         , zc_Color_White()            AS Color_RetIn
                         , zc_Color_White()            AS Color_ContractCond
                         , zc_Color_White()            AS Color_AmountSale   --11658012
                         , zc_Color_White()            AS Color_SummaSale
                         , 11658012                    AS Color_Price
                         , zc_Color_White()            AS Color_PriceWithVAT
                         , zc_Color_White()            AS Color_PromoCond
                         , 16764159                    AS Color_SummaProfit
                         
                         , '�����������'               AS Text
                         , 2                         AS Repository
                    FROM tmpData
                  UNION
                    SELECT 3                         AS NUM
                         , tmpData.Id                  --�������������
                         , tmpData.GoodsId             --�� ������� <�����>
                         , tmpData.GoodsCode           --��� �������  <�����>
                         , tmpData.GoodsName           --������������ ������� <�����>
                         , tmpData.GoodsKindName
                         , tmpData.GoodsKindCompleteName
                   
                         , 0                         AS PriceIn  
                         , 0                         AS ChangePrice
                         --, tmpData.RetIn_Percent     AS AmountRetIn           
                         /*, (CAST (tmpData.ContractCondition AS NUMERIC (16,2))  ||' %') ::TVarChar AS ContractCondition   -- ����� ����
                         , (CAST (tmpData.TaxRetIn          AS NUMERIC (16,2))  ||' %') ::TVarChar AS TaxRetIn
                         , (CAST (tmpData.TaxPromo          AS NUMERIC (16,2))  ||' %') ::TVarChar AS TaxPromo
                         , (CAST (tmpData.PromoCondition    AS NUMERIC (16,2))  ||' %') ::TVarChar AS TaxPromo_Condition
                         */
                         , CAST (tmpData.ContractCondition AS NUMERIC (16,2))  AS ContractCondition   -- ����� ����
                         , CAST (tmpData.TaxRetIn          AS NUMERIC (16,2))  AS TaxRetIn
                         , CAST (tmpData.TaxPromo          AS NUMERIC (16,2))  AS TaxPromo
                         , CAST (tmpData.PromoCondition    AS NUMERIC (16,2))  AS TaxPromo_Condition

                         , 0                         AS AmountSale
                         , 0                         AS SummaSale
                         , 0                         AS Price
                         , 0                         AS PriceWithVAT
                         , 0                         AS Price_sh
                         , 0                         AS PriceWithVAT_sh
                         , tmpData.PromoCondition    AS PromoCondition      --  ����������� �� ���.�����, ���/��

                         , 0                         AS SummaProfit              -- �������
                         , 0                         AS SummaProfit_Condition

                               
                         , zc_Color_White()          AS Color_PriceIn
                         , zc_Color_Yelow()          AS Color_RetIn
                         , zc_Color_Yelow()          AS Color_ContractCond   ---11658012
                         , zc_Color_White()          AS Color_AmountSale
                         , zc_Color_White()          AS Color_SummaSale
                         , zc_Color_White()          AS Color_Price 
                         , zc_Color_White()          AS Color_PriceWithVAT   --11658012
                         , zc_Color_White()          AS Color_PromoCond      --11658012
                         , zc_Color_White()          AS Color_SummaProfit
                         , '��������'                AS Text
                         , 1                         AS Repository
                    FROM tmpData
                  UNION
                    SELECT 4                           AS NUM
                         , tmpData.Id                      --�������������
                         , tmpData.GoodsId                 --�� ������� <�����>
                         , tmpData.GoodsCode               --��� �������  <�����>
                         , tmpData.GoodsName               --������������ ������� <�����>
                         , tmpData.GoodsKindName
                         , tmpData.GoodsKindCompleteName

                         , COALESCE (tmpData.PriceIn1,0)  AS PriceIn  
                         , tmpData.ChangePrice
                         --, CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN (tmpData.SummaSale * tmpData.RetIn_Percent /100) / tmpData.AmountSale ELSE 0 END, 0) AS NUMERIC (16,2)) AS AmountRetIn           
                         /*, (CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.ContractCondition /100 / tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2))) ::TVarChar AS ContractCondition   -- ����� ����
                         , (CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.TaxRetIn /100 / tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2)))          ::TVarChar AS TaxRetIn   -- 
                         , (CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.Price * (100-tmpData.TaxPromo) /100 ELSE 0 END, 0)  AS NUMERIC (16,2)))                             ::TVarChar AS TaxPromo   -- 
                         , (CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.PromoCondition /100/ tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2)))     ::TVarChar AS TaxPromo_Condition   -- 
                         */
                         , CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.ContractCondition /100 / tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2))  AS ContractCondition   -- ����� ����
                         , CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.TaxRetIn /100 / tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2))           AS TaxRetIn   -- 
                         , CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.Price * (100-tmpData.TaxPromo) /100 ELSE 0 END, 0)  AS NUMERIC (16,2))                              AS TaxPromo   -- 
                         , CAST (COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.PromoCondition /100/ tmpData.AmountSale ELSE 0 END, 0)  AS NUMERIC (16,2))      AS TaxPromo_Condition   -- 
                         
                         , tmpData.AmountSale       AS AmountSale
                         , tmpData.SummaSale
                         , tmpData.Price  
                         , tmpData.PriceWithVAT
                         , tmpData.Price_sh
                         , tmpData.PriceWithVAT_sh
                         , tmpData.PriceWithVAT * tmpData.PromoCondition / 100  AS PromoCondition         --  ����������� �� ���.�����, ���/��
                         , tmpData.SummaSale
                                               - (
                                                   COALESCE (tmpData.PriceIn1, 0) 
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.TaxRetIn /100 / tmpData.AmountSale ELSE 0 END, 0)
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.ContractCondition /100 / tmpData.AmountSale ELSE 0 END, 0)
                                                 ) 
                                                  * tmpData.AmountSale    AS SummaProfit               -- �������

                         , tmpData.SummaSale - (COALESCE (tmpData.PriceIn1, 0) 
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.TaxRetIn /100 / tmpData.AmountSale ELSE 0 END, 0)
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.ContractCondition /100 / tmpData.AmountSale ELSE 0 END, 0)
                                                 + COALESCE (CASE WHEN tmpData.AmountSale <> 0 THEN tmpData.SummaSale * tmpData.PromoCondition /100/ tmpData.AmountSale ELSE 0 END, 0)
                                                 ) 
                                                 * tmpData.AmountSale    AS SummaProfit_Condition     -- ������� (�������� �����������)

                         , zc_Color_Yelow()            AS Color_PriceIn      --11658012
                         , zc_Color_White()            AS Color_RetIn
                         , zc_Color_White()            AS Color_ContractCond
                         , zc_Color_White()            AS Color_AmountSale   --11658012
                         , zc_Color_White()            AS Color_SummaSale
                         , 11658012                    AS Color_Price
                         , zc_Color_White()            AS Color_PriceWithVAT
                         , zc_Color_White()            AS Color_PromoCond
                         , 16764159                    AS Color_SummaProfit
                         
                         , '��������'                AS Text
                         , 2                         AS Repository
                    FROM tmpData
                         LEFT JOIN tmpMIChild ON 1=1
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
                         , 0                AS ChangePrice
                         --, 0                AS AmountRetIn           
                         , 0                AS ContractCondition   -- ����� ����
                         , 0                AS TaxRetIn   -- ����� ����
                         , 0                AS TaxPromo   -- ����� ����
                         , 0                AS TaxPromo_Condition
                         , 0                AS AmountSale
                         , 0                AS SummaSale
                         , 0                AS Price   
                         , 0                AS PriceWithVAT
                         , 0                AS Price_sh
                         , 0                AS PriceWithVAT_sh
                         , 0                AS PromoCondition         --  ����������� �� ���.�����, ���/��
                         , 0                AS SummaProfit                 -- �������
                         , 0                AS SummaProfit_Condition

                         , zc_Color_White() AS Color_PriceIn
                         , zc_Color_White() AS Color_RetIn
                         , zc_Color_White() AS Color_ContractCond
                         , zc_Color_White() AS Color_AmountSale
                         , zc_Color_White() AS Color_SummaSale
                         , zc_Color_White() AS Color_Price 
                         , zc_Color_White() AS Color_PriceWithVAT
                         , zc_Color_White() AS Color_PromoCond
                         , zc_Color_White() AS Color_SummaProfit
                         , ''               AS Text
                         , 2                AS Repository
                    FROM tmpData
                    WHERE tmpData.Ord <> 1
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
         , Object_Measure.ValueData            ::TVarChar AS MeasureName             --������� ���������

         , tmpData_All.PriceIn                 :: TFloat
         , tmpData_All.ChangePrice             :: TFloat
        -- , tmpData_All.AmountRetIn             :: TFloat
         , tmpData_All.ContractCondition       :: TFloat --TVarChar
         , tmpData_All.TaxRetIn                :: TFloat --TVarChar
         , tmpData_All.TaxPromo                :: TFloat --TVarChar
         , tmpData_All.TaxPromo_Condition      :: TFloat --TVarChar
         , tmpData_All.AmountSale              :: TFloat
         , (tmpData_All.AmountSale
            * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountSaleWeight    -- ���
         , tmpData_All.SummaSale               :: TFloat
         --  �� ��
         , tmpData_All.Price                   :: TFloat
         , tmpData_All.PriceWithVAT            :: TFloat
         --���� �� ��
         , tmpData_All.Price_sh                   :: TFloat
         , tmpData_All.PriceWithVAT_sh            :: TFloat
         , tmpData_All.PromoCondition          :: TFloat
         , tmpData_All.SummaProfit             :: TFloat
         , tmpData_All.SummaProfit_Condition   :: TFloat
         , 0 :: TFloat AS test1
         
        -- , (tmpData_All.Price * (100-tmpData_All.TaxPromo)/100)  :: TFloat AS SummaDiscount               -- ������
         
         , tmpData_All.Color_PriceIn           
         , tmpData_All.Color_RetIn
         , tmpData_All.Color_ContractCond
         , tmpData_All.Color_AmountSale
         , tmpData_All.Color_SummaSale
         , tmpData_All.Color_Price 
         , tmpData_All.Color_PriceWithVAT
         , tmpData_All.Color_PromoCond
         , tmpData_All.Color_SummaProfit
         , tmpData_All.Text                    ::TVarChar
         , tmpData_All.Repository  ::Integer
    FROM tmpData_All
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                              ON ObjectLink_Goods_Measure.ObjectId = tmpData_All.GoodsId
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
         LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

         LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                     ON ObjectFloat_Goods_Weight.ObjectId = tmpData_All.GoodsId
                                    AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()
    WHERE inIsTaxPromo = vbTaxPromo OR vbTaxPromo IS NULL
    ORDER BY  tmpData_All.Id, tmpData_All.NUM 
   ;
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 04.08.23
 21.04.20         *
 30.11.17         *
 03.08.17         *
*/

-- ����
--select * from gpSelect_MI_PromoGoods_Calc_all(25214379  , 'False' ,  'true' , '5');


/*
WITH
    ---- �������� (% ������ / % �����������)
    tmpMIChild AS (SELECT SUM (MovementItem.Amount) AS Amount        -- �������� (% ������ / % �����������)
                   FROM  MovementItem
                   WHERE MovementItem.MovementId = 25571458 
                     AND MovementItem.DescId = zc_MI_Child()
                     AND MovementItem.isErased = FALSE
                  )
    -- ��� ������
  , tmpData_Full AS (SELECT MovementItem.Id                        AS Id                     --�������������
                          , MovementItem.ObjectId                  AS GoodsId                --�� ������� <�����>
                          , Object_Goods.ObjectCode::Integer       AS GoodsCode              --��� �������  <�����>
                          , Object_Goods.ValueData                 AS GoodsName              --������������ ������� <�����>
                          , Object_GoodsKind.ValueData             AS GoodsKindName          --������������ ������� <��� ������>
                          , Object_GoodsKindComplete.ValueData     AS GoodsKindCompleteName  --������������ ������� <��� ������(����������)>
                                 
                          , MovementItem.Amount                    AS Amount                 --% ������ �� �����
                          
                          , MIFloat_PriceIn1.ValueData             AS PriceIn1               --���-�� - 1 ����, ���/��
                          , MIFloat_PriceIn2.ValueData             AS PriceIn2               --���-�� - 2 ����, ���/��
                          , MIFloat_ChangePrice.ValueData          AS ChangePrice            --
                          --, (MIFloat_Price.ValueData)                AS Price                  --���� � ������
                            -- ���� � ������ c ���
                          --, ROUND (MIFloat_Price.ValueData * ((100+vbVAT)/100)  / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END, 2) :: TFloat AS Price
                          
                          , (MIFloat_PriceWithVAT.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END) :: TFloat AS PriceWithVAT           --���� �������� � ������ ���, � ������ ������, ���
                    
                          , SUM (MIFloat_AmountPlanMax.ValueData) OVER (PARTITION BY MovementItem.ObjectId)  AS AmountSale          --�������� ������������ ������ ������ �� ��������� ������ (� ��)

                         
                          , MIFloat_ContractCondition.ValueData    AS ContractCondition      -- ����� ����, %
                          , MIFloat_TaxRetIn.ValueData             AS TaxRetIn               -- % �������
                          --, MIFloat_TaxPromo.ValueData             AS TaxPromo               -- % c�����
                          , MovementItem.Amount                    AS TaxPromo               -- % c����� �� �������
                          , tmpMIChild.Amount                      AS PromoCondition         -- % �������������� ������
                          
                          , (MIFloat_PriceWithVAT.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END * COALESCE (MIFloat_TaxRetIn.ValueData,0) /100) AS AmountRetIn 
                          
                          , ROW_NUMBER() OVER (/*PARTITION BY MovementItem.Id*/ ORDER BY MovementItem.Id Desc) AS Ord        -- ��� ������ ������ ������
                           /* �������� ����� 1 ���, ���� ���� zc_MI_Master.ObjectId ��������� - �� �� ����� ����*/
                          , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ORDER BY MovementItem.Id)    AS Ord_goods  -- ��� ������ ������ 1 ��� ������
     
                     FROM MovementItem
                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
     
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceIn1
                                                      ON MIFloat_PriceIn1.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceIn2
                                                      ON MIFloat_PriceIn2.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceIn2.DescId = zc_MIFloat_PriceIn2()
                          LEFT JOIN MovementItemFloat AS MIFloat_ChangePrice
                                                      ON MIFloat_ChangePrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ChangePrice.DescId = zc_MIFloat_ChangePrice()
                                                     
                  
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                      ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()  ---zc_MIFloat_PriceWithOutVAT() ---
                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                                                     
                                        
                          LEFT JOIN MovementItemFloat AS MIFloat_ContractCondition
                                                      ON MIFloat_ContractCondition.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ContractCondition.DescId = zc_MIFloat_ContractCondition()
                          LEFT JOIN MovementItemFloat AS MIFloat_TaxRetIn
                                                      ON MIFloat_TaxRetIn.MovementItemId = MovementItem.Id
                                                     AND MIFloat_TaxRetIn.DescId = zc_MIFloat_TaxRetIn()
                          LEFT JOIN MovementItemFloat AS MIFloat_TaxPromo
                                                      ON MIFloat_TaxPromo.MovementItemId = MovementItem.Id
                                                     AND MIFloat_TaxPromo.DescId = zc_MIFloat_TaxPromo()
     
                           /*LEFT JOIN MovementItemFloat AS MIFloat_AmountSale
                                                       ON MIFloat_AmountSale.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSale.DescId = zc_MIFloat_AmountSale()*/
                                        
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
     
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                      ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
             
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                           ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                          LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId
     
                          LEFT JOIN tmpMIChild ON 1=0 
                          
                     WHERE MovementItem.MovementId = 25571458 
                       AND MovementItem.DescId = zc_MI_Master()
                       AND MovementItem.isErased = FALSE
and MovementItem.Id in (261953989,261966484, 261966484)
                     
)

select * from tmpData_Full

*/