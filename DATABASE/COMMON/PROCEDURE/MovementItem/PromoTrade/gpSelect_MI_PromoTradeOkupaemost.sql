-- Function: gpSelect_MI_PromoTradeOkupaemost()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoTradeOkupaemost (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoTradeOkupaemost(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (
        NUM      Integer 
      , GroupNum Integer
      , Num_text TVarChar
      , Id                  Integer  --�������������
      , GoodsId             Integer  --�� ������� <�����>
      , GoodsCode           Integer  --��� �������  <�����>
      , GoodsName           TVarChar --������������ ������� <�����>
      , GoodsKindId         Integer  --�� ������� <��� ������>
      , GoodsKindName       TVarChar --������������ ������� <��� ������> 
      , MeasureName         TVarChar --������� ���������      
      
      , PromoTax          TFloat
      , PricePromo        TFloat
      --, PricePromo_new    TFloat
      , ChangePercent     TFloat
      --, PriceWithVAT      TFloat     --���� ���� (���.), � ������ ���
      , AmountPlan        TFloat     --��������� �������������� ����� ������ � ��. ���.
      , AmountPlan_weight TFloat     --��������� �������������� ����� ������, ��
      , SummPromo         TFloat     --��������� �������������� ����� ������, ���
      , Summ_pos          TFloat     --��������� ����� �������, ��� 
      , PriceIn           TFloat     --���-��, ��� 
      , PriceIn_calc      TFloat     --���-��, ���  (������)
      , ChangePrice       TFloat     --������� (����������), ���
      , ChangePrice_all   TFloat     --������� (���), ���
      , Marga1            TFloat     --����� 1, ��� 
      , Marga2            TFloat     --����� 2, ���
      , Due_Pass_year1    TFloat     --��������� ������1 � ���, ���
      , Due_Pass_year2    TFloat     --��������� ������2 � ���, ���
      , MarketSumm_dop    TFloat     --��� ���������, ���.
      , Summ_bonus        TFloat     --�������� �����, ���.
      , PersentOnCredit   TFloat     --% �� �������, ���
      , TotalCost         TFloat     --����� ������, ��� 
      , Profit1           TFloat     --�������1, ��� ���
      , Profit2           TFloat     --�������2, ��� ���
      , PaybackPeriod1    TFloat     --������ �����������1, ���.
      , PaybackPeriod2    TFloat     --������ �����������2, ���.
)
AS
$BODY$
    DECLARE vbUserId Integer;
            vbPriceListId Integer;
            vbPriceWithVAT Boolean;
            vbVATPercent   TFloat;
    DECLARE vbMovementId_PromoTradeCondition Integer;
            vbChangePercent TFloat;
            vbChangePercent_new  TFloat;
            
            
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoTradeGoods());
    vbUserId:= lpGetUserBySession (inSession);

    vbPriceListId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PriceList());

    SELECT ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
         , ObjectFloat_VATPercent.ValueData     AS VATPercent
  INTO vbPriceWithVAT, vbVATPercent
    FROM Object AS Object_PriceList
         LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                 ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
         LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                               ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                              AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
    WHERE Object_PriceList.DescId = zc_Object_PriceList()
      AND Object_PriceList.Id = vbPriceListId;

    vbMovementId_PromoTradeCondition := (SELECT Movement.Id
                                         FROM Movement
                                         WHERE Movement.DescId = zc_Movement_PromoTradeCondition()
                                           AND Movement.ParentId =  inMovementId
                                         );

    vbChangePercent := (SELECT MovementFloat.ValueData
                        FROM MovementFloat 
                        WHERE MovementFloat.MovementId = inMovementId
                          AND MovementFloat.DescId = zc_MovementFloat_ChangePercent()
                        );
    --"������ �������� �����"
    vbChangePercent_new := (SELECT MovementFloat.ValueData
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId = vbMovementId_PromoTradeCondition
                              AND MovementFloat.DescId = zc_MovementFloat_ChangePercent_new()
                            );
                     
    RETURN QUERY
    WITH
    tmpMIFloat_Condition AS (SELECT *
                             FROM MovementFloat
                             WHERE MovementFloat.MovementId = vbMovementId_PromoTradeCondition
                             ) 
  , tmpParam_Condition AS (SELECT MovementFloat_DelayDay.ValueData        AS DelayDay
                                , MovementFloat_RetroBonus.ValueData      AS RetroBonus
                                , MovementFloat_RetroBonus_new.ValueData  AS RetroBonus_new
                                , MovementFloat_Market.ValueData          AS Market
                                , MovementFloat_Market_new.ValueData      AS Market_new
                                , MovementFloat_ReturnIn.ValueData        AS ReturnIn
                                , MovementFloat_ReturnIn_new.ValueData    AS ReturnIn_new
                                , MovementFloat_Logist.ValueData          AS Logist
                                , MovementFloat_Logist_new.ValueData      AS Logist_new
                                , MovementFloat_Report.ValueData          AS Report
                                , MovementFloat_Report_new.ValueData      AS Report_new
                                , MovementFloat_MarketSumm.ValueData      AS MarketSumm
                                , MovementFloat_MarketSumm_new.ValueData  AS MarketSumm_new
                           FROM Movement
                                LEFT JOIN MovementFloat AS MovementFloat_DelayDay
                                                        ON MovementFloat_DelayDay.MovementId = inMovementId
                                                       AND MovementFloat_DelayDay.DescId = zc_MovementFloat_DelayDay() 
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_RetroBonus 
                                                               ON MovementFloat_RetroBonus.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_RetroBonus.DescId = zc_MovementFloat_RetroBonus()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_RetroBonus_new 
                                                               ON MovementFloat_RetroBonus_new.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_RetroBonus_new.DescId = zc_MovementFloat_RetroBonus_new()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_Market 
                                                               ON MovementFloat_Market.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_Market.DescId = zc_MovementFloat_Market()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_Market_new 
                                                               ON MovementFloat_Market_new.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_Market_new.DescId = zc_MovementFloat_Market_new()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_ReturnIn
                                                               ON MovementFloat_ReturnIn.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_ReturnIn.DescId = zc_MovementFloat_ReturnIn()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_ReturnIn_new
                                                               ON MovementFloat_ReturnIn_new.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_ReturnIn_new.DescId = zc_MovementFloat_ReturnIn_new()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_Report
                                                               ON MovementFloat_Report.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_Report.DescId = zc_MovementFloat_Report()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_Report_new
                                                               ON MovementFloat_Report_new.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_Report_new.DescId = zc_MovementFloat_Report_new()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_Logist
                                                               ON MovementFloat_Logist.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_Logist.DescId = zc_MovementFloat_Logist()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_Logist_new
                                                               ON MovementFloat_Logist_new.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_Logist_new.DescId = zc_MovementFloat_Logist_new()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_MarketSumm 
                                                               ON MovementFloat_MarketSumm.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_MarketSumm.DescId = zc_MovementFloat_MarketSumm()
                                LEFT JOIN tmpMIFloat_Condition AS MovementFloat_MarketSumm_new 
                                                               ON MovementFloat_MarketSumm_new.MovementId = vbMovementId_PromoTradeCondition
                                                              AND MovementFloat_MarketSumm_new.DescId = zc_MovementFloat_MarketSumm_new()
                           WHERE Movement.Id = vbMovementId_PromoTradeCondition
                          )             

  , tmpMI AS (SELECT MovementItem.*
                   , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
              FROM MovementItem 
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.isErased = FALSE
              )

  , tmpMIFloat AS (SELECT MovementItemFloat.* 
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_PromoTax()
                                                    , zc_MIFloat_AmountPlan()
                                                    , zc_MIFloat_Summ()
                                                    , zc_MIFloat_ChangePercent()
                                                    , zc_MIFloat_PricePromo()
                                                    , zc_MIFloat_PricePromo_new() 
                                                    , zc_MIFloat_PriceIn1() 
                                                    , zc_MIFloat_PriceIn1_Calc()
                                                    , zc_MIFloat_ChangePrice()
                                                     )
                   )       
  , tmpData AS (
                SELECT MovementItem.Id
                     , MovementItem.ObjectId            AS GoodsId
                     , Object_Goods.ObjectCode::Integer AS GoodsCode
                     , Object_Goods.ValueData           AS GoodsName
                     , Object_Measure.Id                AS MeasureId
                     , Object_Measure.ValueData         AS MeasureName 
                     , Object_GoodsKind.Id              AS GoodsKindId     
                     , Object_GoodsKind.ValueData       AS GoodsKindName
                     
                     , MIFloat_AmountPlan.ValueData      ::TFloat AS AmountPlan
                     , (MIFloat_AmountPlan.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) ::TFloat AS AmountPlan_weight
                     , (MIFloat_AmountPlan.ValueData * COALESCE (MIFloat_PromoTax.ValueData,0))                                                                                       ::TFloat AS AmountPlan_calc
                     , (MIFloat_AmountPlan.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END * COALESCE (MIFloat_PromoTax.ValueData,0)) ::TFloat AS AmountPlan_weight_calc
                     , MIFloat_Summ.ValueData            ::TFloat AS Summ
                     , MIFloat_PromoTax.ValueData        ::TFloat AS PromoTax
                                         
                     -- ������ ���� � ��� �� �������
                     --, (MovementItem.PriceWithVAT - (1- COALESCE (MIFloat_ChangePercent.ValueData,100) / 100)) ::TFloat AS PriceWithVAT
                     , MIFloat_ChangePercent.ValueData AS ChangePercent
                     , MIFloat_PricePromo.ValueData      ::TFloat AS PricePromo
                     , MIFloat_PricePromo_new.ValueData  ::TFloat AS PricePromo_new
                     
                     , MIFloat_PriceIn1.ValueData        ::TFloat AS PriceIn
                     , MIFloat_PriceIn1_Calc.ValueData   ::TFloat AS PriceIn_calc
                     , MIFloat_ChangePrice.ValueData     ::TFloat AS ChangePrice            
                     
                     , ROW_NUMBER() OVER (ORDER BY MovementItem.Id Desc) AS Ord        -- ��� ������ ������ ������ 
                     
                     , tmpParam_Condition.*
                FROM tmpMI AS MovementItem
                     LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                          ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                         AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                     LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                     LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                           ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                          AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
 
                     LEFT JOIN tmpMIFloat AS MIFloat_Summ
                                          ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                         AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                     LEFT JOIN tmpMIFloat AS MIFloat_AmountPlan
                                          ON MIFloat_AmountPlan.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountPlan.DescId = zc_MIFloat_AmountPlan()
                     LEFT JOIN tmpMIFloat AS MIFloat_PromoTax
                                          ON MIFloat_PromoTax.MovementItemId = MovementItem.Id
                                         AND MIFloat_PromoTax.DescId = zc_MIFloat_PromoTax()

                     LEFT JOIN tmpMIFloat AS MIFloat_PricePromo
                                          ON MIFloat_PricePromo.MovementItemId = MovementItem.Id
                                         AND MIFloat_PricePromo.DescId = zc_MIFloat_PricePromo()
                     LEFT JOIN tmpMIFloat AS MIFloat_PricePromo_new
                                          ON MIFloat_PricePromo_new.MovementItemId = MovementItem.Id
                                         AND MIFloat_PricePromo_new.DescId = zc_MIFloat_PricePromo_new()
                                        
                     LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                     LEFT JOIN tmpMIFloat AS MIFloat_PriceIn1
                                          ON MIFloat_PriceIn1.MovementItemId = MovementItem.Id
                                         AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()
                     LEFT JOIN tmpMIFloat AS MIFloat_PriceIn1_Calc
                                          ON MIFloat_PriceIn1_Calc.MovementItemId = MovementItem.Id
                                         AND MIFloat_PriceIn1_Calc.DescId = zc_MIFloat_PriceIn1_Calc()

                     LEFT JOIN tmpMIFloat AS MIFloat_ChangePrice
                                          ON MIFloat_ChangePrice.MovementItemId = MovementItem.Id
                                         AND MIFloat_ChangePrice.DescId = zc_MIFloat_ChangePrice()

                     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MovementItem.GoodsKindId
                     
                     LEFT JOIN tmpParam_Condition ON 1 = 1
               )

  , tmpRes AS (--������� �������
               SELECT 1 AS Num
                    , '' ::TVarChar AS Num_text
                    , tmpData.Id
                    , tmpData.GoodsId
                    , tmpData.GoodsCode
                    , tmpData.GoodsName
                    , tmpData.GoodsKindId
                    , tmpData.GoodsKindName
                    , tmpData.MeasureId
                    , tmpData.MeasureName
                    , tmpData.PromoTax
                    , tmpData.PricePromo
                    , tmpData.ChangePercent                                                                             
                    , (COALESCE (tmpData.AmountPlan,0) - COALESCE (tmpData.AmountPlan_calc,0))      ::TFloat AS AmountPlan  --��������� �������������� ����� ������ � ��. ���.
                    , (COALESCE (tmpData.AmountPlan_weight,0) - COALESCE (tmpData.AmountPlan_weight_calc,0)) AS AmountPlan_weight          --��������� �������������� ����� ������, ��
                    , ((COALESCE (tmpData.AmountPlan,0) - COALESCE (tmpData.AmountPlan_calc,0))                        
                       * tmpData.PricePromo)  ::TFloat AS SummPromo                                                    --��������� �������������� ����� ������, ���
                    , CASE WHEN COALESCE (tmpData.AmountPlan,0) <> 0 
                           THEN (tmpData.Summ /tmpData.AmountPlan * (COALESCE (tmpData.AmountPlan,0) - COALESCE (tmpData.AmountPlan_calc,0)))
                           ELSE 0
                      END ::TFloat AS Summ_pos                                                                         --��������� ����� �������, ���
                    , tmpData.PriceIn      ::TFloat   AS PriceIn                                                       --���-��, ���
                    , tmpData.PriceIn_calc ::TFloat   AS PriceIn_calc                                                  --���-��, ���
                    , tmpData.ChangePrice ::TFloat                                                                     --������� (����������), ���
                    , (COALESCE (tmpData.RetroBonus,0) 
                     + COALESCE (tmpData.Market,0) 
                     + COALESCE (tmpData.ReturnIn,0) 
                     + COALESCE (tmpData.Logist,0) 
                     + COALESCE (tmpData.Report,0)) AS Sum1_Condition   -- "�������� �������": "����� �����" + "������������� ������" + "����������� ���������" + "������������� �����" + "������"
                    , tmpData.DelayDay
                    , tmpData.MarketSumm
               FROM tmpData
             UNION ALL     
               --������� ������� (�����)
               SELECT 2 AS Num
                    , 'A����' ::TVarChar AS Num_text
                    , tmpData.Id
                    , tmpData.GoodsId
                    , tmpData.GoodsCode
                    , tmpData.GoodsName
                    , tmpData.GoodsKindId
                    , tmpData.GoodsKindName
                    , tmpData.MeasureId
                    , tmpData.MeasureName
                    , tmpData.PromoTax 
                    , tmpData.PricePromo
                    , tmpData.ChangePercent
                    , COALESCE (tmpData.AmountPlan_calc,0) ::TFloat AS AmountPlan                                      --��������� �������������� ����� ������ � ��. ���.
                    , tmpData.AmountPlan_weight_calc       ::TFloat AS AmountPlan_weight                               --��������� �������������� ����� ������, ��
                    , (COALESCE (tmpData.AmountPlan_calc,0)                        
                       * tmpData.PricePromo)  ::TFloat AS SummPromo                                                    --��������� �������������� ����� ������, ���
                    , CASE WHEN COALESCE (tmpData.AmountPlan,0) <> 0 
                           THEN tmpData.Summ /tmpData.AmountPlan * COALESCE (tmpData.AmountPlan_calc,0)
                           ELSE 0
                      END ::TFloat AS Summ_pos                                                                          --��������� ����� �������, ���
                    , tmpData.PriceIn      ::TFloat   AS PriceIn                                                       --���-��, ���
                    , tmpData.PriceIn_calc ::TFloat   AS PriceIn_calc                                                  --���-��, ���
                    , tmpData.ChangePrice ::TFloat                                                                     --������� (����������), ���
                    , (COALESCE (tmpData.RetroBonus,0) 
                     + COALESCE (tmpData.Market,0) 
                     + COALESCE (tmpData.ReturnIn,0) 
                     + COALESCE (tmpData.Logist,0) 
                     + COALESCE (tmpData.Report,0)) AS Sum1_Condition     -- "�������� �������": "����� �����" + "������������� ������" + "����������� ���������" + "������������� �����" + "������"
                    , tmpData.DelayDay
                    , tmpData.MarketSumm
               FROM tmpData
               WHERE COALESCE (tmpData.PromoTax,0) <> 0
            UNION ALL
               --����� �������
               SELECT 3 AS Num
                    , '' ::TVarChar AS Num_text
                    , tmpData.Id
                    , tmpData.GoodsId
                    , tmpData.GoodsCode
                    , tmpData.GoodsName
                    , tmpData.GoodsKindId
                    , tmpData.GoodsKindName
                    , tmpData.MeasureId
                    , tmpData.MeasureName
                    , tmpData.PromoTax
                    , tmpData.PricePromo_new
                    , tmpData.ChangePercent                                                                             
                    , (COALESCE (tmpData.AmountPlan,0) - COALESCE (tmpData.AmountPlan_calc,0))      ::TFloat AS AmountPlan  --��������� �������������� ����� ������ � ��. ���.
                    , (COALESCE (tmpData.AmountPlan_weight,0) - COALESCE (tmpData.AmountPlan_weight_calc,0)) AS AmountPlan_weight          --��������� �������������� ����� ������, ��
                    , ((COALESCE (tmpData.AmountPlan,0) - COALESCE (tmpData.AmountPlan_calc,0))                        
                       * tmpData.PricePromo_new)  ::TFloat AS SummPromo                                                --��������� �������������� ����� ������, ���
                    , CASE WHEN COALESCE (tmpData.AmountPlan,0) <> 0 
                           THEN (tmpData.Summ /tmpData.AmountPlan * (COALESCE (tmpData.AmountPlan,0) - COALESCE (tmpData.AmountPlan_calc,0)))
                           ELSE 0
                      END ::TFloat AS Summ_pos                                                                         --��������� ����� �������, ���
                    , tmpData.PriceIn      ::TFloat   AS PriceIn                                                       --���-��, ���
                    , tmpData.PriceIn_calc ::TFloat   AS PriceIn_calc                                                  --���-��, ���
                    , tmpData.ChangePrice ::TFloat                                                                     --������� (����������), ��� 
                    , (COALESCE (tmpData.RetroBonus_new,0) 
                     + COALESCE (tmpData.Market_new,0) 
                     + COALESCE (tmpData.ReturnIn_new,0) 
                     + COALESCE (tmpData.Logist_new,0) 
                     + COALESCE (tmpData.Report_new,0)) AS Sum1_Condition     -- "�������� �������": "����� �����" + "������������� ������" + "����������� ���������" + "������������� �����" + "������"  
                    , tmpData.DelayDay
                    , tmpData.MarketSumm
               FROM tmpData
            UNION ALL
               --����� ������� (�����) 
               SELECT 4 AS Num
                    , 'A����' ::TVarChar AS Num_text
                    , tmpData.Id
                    , tmpData.GoodsId
                    , tmpData.GoodsCode
                    , tmpData.GoodsName
                    , tmpData.GoodsKindId
                    , tmpData.GoodsKindName
                    , tmpData.MeasureId
                    , tmpData.MeasureName
                    , tmpData.PromoTax 
                    , tmpData.PricePromo_new
                    , tmpData.ChangePercent
                    , COALESCE (tmpData.AmountPlan_calc,0) ::TFloat AS AmountPlan                                      --��������� �������������� ����� ������ � ��. ���.
                    , tmpData.AmountPlan_weight_calc       ::TFloat AS AmountPlan_weight                               --��������� �������������� ����� ������, ��
                    , (COALESCE (tmpData.AmountPlan_calc,0)                        
                       * tmpData.PricePromo_new)  ::TFloat AS SummPromo                                                --��������� �������������� ����� ������, ���
                    , CASE WHEN COALESCE (tmpData.AmountPlan,0) <> 0 
                           THEN tmpData.Summ /tmpData.AmountPlan * COALESCE (tmpData.AmountPlan_calc,0)
                           ELSE 0
                      END ::TFloat AS Summ_pos                                                                         --��������� ����� �������, ���
                    , tmpData.PriceIn      ::TFloat   AS PriceIn                                                       --���-��, ���
                    , tmpData.PriceIn_calc ::TFloat   AS PriceIn_calc                                                  --���-��, ���
                    , tmpData.ChangePrice ::TFloat                                                                     --������� (����������), ���
                    , (COALESCE (tmpData.RetroBonus_new,0) 
                     + COALESCE (tmpData.Market_new,0) 
                     + COALESCE (tmpData.ReturnIn_new,0) 
                     + COALESCE (tmpData.Logist_new,0) 
                     + COALESCE (tmpData.Report_new,0)) AS Sum1_Condition     -- "�������� �������": "����� �����" + "������������� ������" + "����������� ���������" + "������������� �����" + "������" 
                    , tmpData.DelayDay
                    , tmpData.MarketSumm
               FROM tmpData
               WHERE COALESCE (tmpData.PromoTax,0) <> 0 
               UNION ALL
               --������ ������
               SELECT 5 AS Num
                    , '' ::TVarChar AS Num_text
                    , tmpData.Id
                    , 0             AS GoodsId
                    , 0             AS GoodsCode
                    , '' ::TVarChar AS GoodsName
                    , 0             AS GoodsKindId
                    , '' ::TVarChar AS GoodsKindName
                    , 0             AS MeasureId
                    , '' ::TVarChar AS MeasureName
                    , 0             AS PromoTax 
                    , 0             AS PricePromo_new
                    , 0 AS ChangePercent
                    , 0  ::TFloat AS AmountPlan
                    , 0  ::TFloat AS AmountPlan_weight
                    , 0  ::TFloat AS SummPromo 
                    , 0  ::TFloat AS Summ_pos
                    , 0  ::TFloat AS PriceIn
                    , 0  ::TFloat AS PriceIn_calc
                    , 0  ::TFloat AS ChangePrice
                    , 0  ::TFloat AS Sum1_Condition 
                    , 0  ::TFloat AS DelayDay
                    , 0  ::TFloat AS MarketSumm
               FROM tmpData
               WHERE tmpData.Ord <> 1
               )
    --
    , tmpResult AS (WITH
                    tmpData AS (SELECT tmpData.NUM
                             , CASE WHEN tmpData.NUM IN (1, 2) THEN 1
                                    WHEN tmpData.NUM IN (3, 4) THEN 2 
                                    ELSE 3 
                               END AS GroupNum
                             , tmpData.Num_text
                             , tmpData.Id
                             , tmpData.GoodsId
                             , tmpData.GoodsCode  ::Integer
                             , tmpData.GoodsName
                             , tmpData.GoodsKindId
                             , tmpData.GoodsKindName
                             , tmpData.MeasureName
                             , tmpData.PromoTax          ::TFloat
                             , tmpData.PricePromo        ::TFloat
                             , tmpData.ChangePercent     ::TFloat
                             , tmpData.AmountPlan        ::TFloat                              --��������� �������������� ����� ������ � ��. ���.
                             , tmpData.AmountPlan_weight ::TFloat                              --��������� �������������� ����� ������, ��
                             , tmpData.SummPromo         ::TFloat                              --��������� �������������� ����� ������, ���
                             , tmpData.Summ_pos          ::TFloat                              --��������� ����� �������, ��� 
                             , tmpData.PriceIn           ::TFloat                              --���-��, ���
                             , tmpData.PriceIn_calc      ::TFloat                              --���-��, ��� (������)
                             , tmpData.ChangePrice       ::TFloat                              --������� (����������), ��� 
                             , (tmpData.ChangePrice / 0.6) ::TFloat  AS ChangePrice_all        --������� (���), ��� 
                             , ( COALESCE (tmpData.PricePromo,0) - COALESCE (tmpData.PriceIn,0) - COALESCE ((tmpData.ChangePrice / 0.6), 0) ) ::TFloat AS Marga1     --����� 1, ��� 
                             , ( COALESCE (tmpData.PricePromo,0) - COALESCE (tmpData.PriceIn,0) - COALESCE (tmpData.ChangePrice,0) )          ::TFloat AS Marga2     --����� 2, ���   
                
                             , (( COALESCE (tmpData.PricePromo,0) - COALESCE (tmpData.PriceIn,0) - COALESCE ((tmpData.ChangePrice / 0.6), 0) )
                                * tmpData.AmountPlan)    ::TFloat AS Due_Pass_year1                                                                                  --��������� ������1 � ���, ���
                
                             , (( COALESCE (tmpData.PricePromo,0) - COALESCE (tmpData.PriceIn,0) - COALESCE (tmpData.ChangePrice, 0) )
                                * tmpData.AmountPlan)    ::TFloat AS Due_Pass_year2                                                                                  --��������� ������2 � ���, ���
                             , tmpData.Sum1_Condition    ::TFloat
                             , tmpData.DelayDay          ::TFloat
                             , tmpData.MarketSumm        ::TFloat
                        FROM tmpRes AS tmpData
                        ) 
                     SELECT tmpData.*
                          , ( (COALESCE (tmpData.Summ_pos,0) + COALESCE (tmpData.MarketSumm_dop,0) + COALESCE (tmpData.Summ_bonus,0) ) 
                             + CAST ( (COALESCE (tmpData.Summ_pos,0) + COALESCE (tmpData.MarketSumm_dop,0) + COALESCE (tmpData.Summ_bonus,0) )/100 AS NUMERIC (16,4) )  * tmpData.PersentOnCredit )
                                  ::TFloat AS TotalCost                                                                      --����� ������, ��� 
                     FROM (   
                      SELECT tmpData.*
                         , CASE WHEN tmpData.NUM NOT IN (2,4) THEN 0
                                ELSE CASE WHEN COALESCE (tmpData.Due_Pass_year1,0) <> 0 THEN tmpData.MarketSumm * tmpRes2.Due_Pass_year1 / tmpData.Due_Pass_year1 ELSE 0 END
                           END ::TFloat AS MarketSumm_dop                                                                                        -- ��� ���������, ���.
            
                         , (COALESCE (tmpData.SummPromo,0) * COALESCE (tmpData.Sum1_Condition,0) * 12)  ::TFloat  AS Summ_bonus                  --�������� �����, ���. 
                             
                             
                         , ( (COALESCE (tmpData.SummPromo,0) / 100 * 18.5) / 365 * COALESCE(tmpData.DelayDay) * 12)  ::TFloat AS PersentOnCredit --% �� �������, ���

                      FROM tmpData
                         --
                         LEFT JOIN tmpData AS tmpRes2 ON tmpRes2.Id = tmpData.Id
                                                     AND tmpRes2.NUM = tmpData.NUM - 1                         
                      ) AS tmpData
                     )


        SELECT CASE WHEN tmpData.NUM = 5 THEN 0 ELSE tmpData.NUM END AS NUM
             , tmpData.GroupNum
             , tmpData.Num_text ::TVarChar
             , CASE WHEN tmpData.NUM = 5 THEN 0 ELSE tmpData.Id END AS Id
             , tmpData.GoodsId
             , tmpData.GoodsCode  ::Integer
             , tmpData.GoodsName
             , tmpData.GoodsKindId
             , tmpData.GoodsKindName
             , tmpData.MeasureName
             , tmpData.PromoTax          ::TFloat
             , tmpData.PricePromo        ::TFloat
             , tmpData.ChangePercent     ::TFloat
             , tmpData.AmountPlan        ::TFloat                              --��������� �������������� ����� ������ � ��. ���.
             , tmpData.AmountPlan_weight ::TFloat                              --��������� �������������� ����� ������, ��
             , tmpData.SummPromo         ::TFloat                              --��������� �������������� ����� ������, ���
             , tmpData.Summ_pos          ::TFloat                              --��������� ����� �������, ��� 
             , tmpData.PriceIn           ::TFloat                              --���-��, ���
             , tmpData.PriceIn_calc      ::TFloat                              --���-��, ���  (������)
             , tmpData.ChangePrice       ::TFloat                              --������� (����������), ��� 
             , tmpData.ChangePrice_all   ::TFloat                              --������� (���), ��� 
             , tmpData.Marga1            ::TFloat                              --����� 1, ��� 
             , tmpData.Marga2            ::TFloat                              --����� 2, ���  
             , tmpData.Due_Pass_year1    ::TFloat                              --��������� ������1 � ���, ���
             , tmpData.Due_Pass_year2    ::TFloat                              --��������� ������2 � ���, ���
             , tmpData.MarketSumm_dop    ::TFloat                              --��� ���������, ���.
             , tmpData.Summ_bonus        ::TFloat                              --�������� �����, ���. 
             , tmpData.PersentOnCredit   ::TFloat                              --% �� �������, ���
             , tmpData.TotalCost         ::TFloat                              --����� ������, ���

             , (COALESCE (tmpData.Due_Pass_year1,0)
              - COALESCE (tmpData.TotalCost,0)) ::TFloat AS Profit1            --�������1, ��� ���
     
             , (COALESCE (tmpData.Due_Pass_year2,0)
              - COALESCE (tmpData.TotalCost,0)) ::TFloat AS Profit2            --�������2, ��� ���
     
             , CASE WHEN COALESCE (tmpData.Due_Pass_year1,0) <> 0
                    THEN (COALESCE (tmpData.TotalCost,0)/ COALESCE (tmpData.Due_Pass_year1,0) *12)
                    ELSE 0
               END                       ::TFloat AS PaybackPeriod1            --������ �����������1, ���.
             , CASE WHEN COALESCE (tmpData.Due_Pass_year1,0) <> 0
                    THEN (COALESCE (tmpData.TotalCost,0)/ COALESCE (tmpData.Due_Pass_year1,0) *12)
                    ELSE 0
               END                       ::TFloat AS PaybackPeriod2            --������ �����������2, ���.

        FROM tmpResult AS tmpData 
        ORDER BY tmpData.Id
               , tmpData.NUM
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.07.25         *
*/
-- ����
--SELECT * FROM gpSelect_MI_PromoTradeOkupaemost (5083159 , zfCalc_UserAdmin());
-- select * from gpSelect_MI_PromoTradeOkupaemost(inMovementId := 31603021  , inSession := '9457');