--
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result_Month (TDateTime, TDateTime, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo_Result_Month (
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inIsPromo        Boolean,   --�������� ������ �����
    IN inIsTender       Boolean,   --�������� ������ �������
    IN inIsGoodsKind    Boolean,   -- ������������ �� ���� ������
    IN inUnitId         Integer,   --������������� 
    IN inRetailId       Integer,   --������������� 
    IN inMovementId     Integer,   --�������� �����
    IN inJuridicalId    Integer,   --�� ����
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     MovementId           Integer   --�� ��������� �����
    ,InvNumber            Integer   --� ��������� �����
    ,OperDate             TDateTime --
    ,UnitName             TVarChar  --�����
    ,PersonalTradeName    TVarChar  --������������� ������������� ������������� ������
    ,PersonalName         TVarChar  --������������� ������������� �������������� ������	
    ,DateStartSale        TDateTime --���� �������� �� ��������� �����
    ,DeteFinalSale        TDateTime --���� �������� �� ��������� �����
    ,DateStartPromo       TDateTime --���� ���������� �����
    ,DateFinalPromo       TDateTime --���� ���������� �����
    ,MonthPromo           TDateTime --����� �����
    ,CheckDate            TDateTime --���� ������������
    ,RetailName           TBlob     --����, � ������� �������� �����
    ,AreaName             TBlob     --������
    ,JuridicalName_str    TBlob     --��.����
    ,GoodsName            TVarChar  --�������
    ,GoodsCode            Integer   --��� �������
    ,GoodsId              Integer
    ,MeasureName          TVarChar  --������� ���������
    ,TradeMarkName        TVarChar  --�������� �����
    ,GoodsGroupNameFull   TVarChar -- ������ ������
    ,GoodsKindName          TVarChar --������������ ������� <��� ������>
    ,GoodsKindCompleteName  TVarChar --������������ ������� <��� ������(����������)>
    
    ,GoodsWeight          TFloat    --���
    ,AmountPlanMin        TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMinWeight  TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMax        TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMaxWeight  TFloat    --����������� ����� ������ � ��������� ������, ��
    
    ,AmountReal           TFloat    --����� ������ � ����������� ������, ��
    ,AmountRealWeight     TFloat    --����� ������ � ����������� ������, �� ���
    ,AmountOut_promo            TFloat    --���-�� ���������� (����)
    ,AmountOutWeight_promo      TFloat    --���-�� ���������� (����) ���
    ,AmountIn_promo             TFloat    --���-�� ������� (����)
    ,AmountInWeight_promo       TFloat    --���-�� ������� (����) ���             
    ,AmountOut            TFloat    --���-�� ���������� (����)
    ,AmountOutWeight      TFloat    --���-�� ���������� (����) ���
    ,AmountIn             TFloat    --���-�� ������� (����)
    ,AmountInWeight       TFloat    --���-�� ������� (����) ���

    ,AmountSale           TFloat    --������� �� ���� ������ �������� �� ��������� ���� �� ������� ��������
    ,AmountSaleWeight     TFloat    --������� �� ���� ������ �������� �� ��������� ���� �� ������� ��������, � ��
    ,PersentResult        TFloat    --���������, % ((������� � ���.������/������� � ����� ���.-1)*100)
    ,Discount             TBlob     --������, %
    ,Discount_Condition   TBlob     --�����������, %
    ,MainDiscount         TFloat    --����� ������ ��� ����������, %  (�������� �������)
    ,PriceWithVAT         TFloat    --����������� ��������� ���� � ������ ���, ���
    ,Price                TFloat    -- * ���� ������������ � ���, ���
    ,CostPromo            TFloat    -- * ��������� �������
    ,PriceSale            TFloat    -- * ���� �� �����/������ ��� ����������
    ,PriceIn1             TFloat    --������������� ����,  �� ��
    ,Profit_Virt          TFloat    --����������� �������������� ������� �� ���������� ������
    ,SummReal             TFloat    --�� (���) �� ��������� ������ �� ���� ������������
    ,SummPromo            TFloat    --�� (���) ��������� ������ �� ��������� �����
    ,ContractCondition    TFloat    -- ����� ����, %
    ,Profit               TFloat    --
    ,AdvertisingName      TBlob     -- * �������.���������
    ,Comment              TVarChar  --����������
    ,CommentMain          TVarChar  --  
    , Month_Partner       TDateTime --����� ������� / ��������
     -- ������� �� ����������� ������
    , AmountReal_calc        TFloat
    , AmountRealWeight_calc  TFloat
    -- ������� �� ����������� ������
    , AmountRetIn_calc       TFloat
    , AmountRetInWeight_calc TFloat
 
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- ���������
    RETURN QUERY
    WITH 
    --��� ����������  ������� � �������� �� ������
    tmpMovementAll AS (SELECT MovementDate_OperDatePartner.MovementId AS Id
                            , DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)::TDateTime)  AS Month_Partner
                            , Movement.DescId
                       FROM MovementDate AS MovementDate_OperDatePartner
                            JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                         AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                    )
   --��� ����� ��  ����������� ������� � ��������   ����� 
  , tmpMLM_Promo AS (SELECT MovementLinkMovement.*
                     FROM MovementLinkMovement
                     WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovementAll.Id FROM tmpMovementAll)
                       AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Promo())
                       AND (MovementLinkMovement.MovementChildId = inMovementId OR inMovementId = 0)    --���� �� ���������� ����� 
                       AND COALESCE (MovementLinkMovement.MovementChildId,0) <> 0
                      )

  , tmpMLO AS (SELECT MovementLinkObject.*
               FROM MovementLinkObject
               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM_Promo.MovementId FROM tmpMLM_Promo)
                 AND MovementLinkObject.DescId IN (zc_MovementLinkObject_To(), zc_MovementLinkObject_From())
               )
                                   
  , tmpJuridical AS (SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                          , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                     FROM ObjectLink AS ObjectLink_Partner_Juridical
                     WHERE ObjectLink_Partner_Juridical.ObjectId IN (SELECT DISTINCT tmpMLO.ObjectId FROM tmpMLO)
                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                     )
    --������� � ������� ����������� ������� ��. ����������                                                                      
  , tmpMovement AS (SELECT tmpMovementAll.Id
                         , tmpMovementAll.Month_Partner
                         , tmpMovementAll.DescId
                         , tmpMLM_Promo.MovementChildId AS MovementId_promo
                    FROM tmpMovementAll
                        INNER JOIN tmpMLM_Promo ON tmpMLM_Promo.MovementId = tmpMovementAll.Id
                        
                        LEFT JOIN tmpMLO AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = tmpMovementAll.Id
                                        AND MovementLinkObject_Partner.DescId = CASE WHEN tmpMovementAll.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END

                        LEFT JOIN tmpJuridical ON tmpJuridical.PartnerId = MovementLinkObject_Partner.ObjectId

                        LEFT JOIN tmpMLO AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = tmpMovementAll.Id
                                        AND MovementLinkObject_Unit.DescId = CASE WHEN tmpMovementAll.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END

                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = tmpJuridical.JuridicalId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                    WHERE (tmpJuridical.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                      AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                      AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inJuridicalId = 0)
                    )

  , tmpMIAll AS (SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErASed = FALSE
                 )
  , tmpMIFloat_PromoMovement AS (SELECT MovementItemFloat.MovementItemId
                                      , MovementItemFloat.ValueData ::Integer AS MovementId_promo
                                 FROM MovementItemFloat
                                 WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIAll.Id FROM tmpMIAll) 
                                   AND MovementItemFloat.DescId = zc_MIFloat_PromoMovementId()
                                 ) 
  , tmpMIFloat_AmountPartner AS (SELECT MovementItemFloat.* 
                                 FROM MovementItemFloat
                                 WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIFloat_PromoMovement.MovementItemId FROM tmpMIFloat_PromoMovement) 
                                   AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                                 )   
  , tmpMILinkObject_GoodsKind AS (SELECT MovementItemLinkObject.* 
                                  FROM MovementItemLinkObject
                                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIFloat_PromoMovement.MovementItemId FROM tmpMIFloat_PromoMovement) 
                                    AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                 ) 
    --������ �� ������ � ���������
  , tmpMI_SaleReturn AS (SELECT MIFloat_PromoMovement.MovementId_promo
                              , Movement.Month_Partner
                              , MovementItem.ObjectId                          AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId,0)   AS GoodsKindId
                              , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData,0) ELSE 0 END)     AS AmountOut    --�������
                              , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData,0) ELSE 0 END) AS AmountIn     --�������
                         FROM tmpMovement AS Movement
                               INNER JOIN tmpMIAll AS MovementItem ON MovementItem.MovementId = Movement.Id
           
                               INNER JOIN tmpMIFloat_PromoMovement AS MIFloat_PromoMovement
                                                                   ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                               LEFT JOIN tmpMIFloat_AmountPartner AS MIFloat_AmountPartner
                                                                  ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
           
                               LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                         GROUP BY MIFloat_PromoMovement.MovementId_promo
                                , Movement.Month_Partner
                                , MovementItem.ObjectId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                         )

  , tmpMovement_Promo AS (SELECT DISTINCT Movement_Promo.*
                               , ObjectFloat_VATPercent.ValueData     AS VATPercent
                          FROM Movement_Promo_View AS Movement_Promo 
                               LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                                     ON ObjectFloat_VATPercent.ObjectId = Movement_Promo.PriceListId
                                                    AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
                          WHERE Movement_Promo.Id IN (SELECT DISTINCT tmpMI_SaleReturn.MovementId_promo FROM tmpMI_SaleReturn)
                            AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                            AND (  (Movement_Promo.isPromo = TRUE AND inIsPromo = TRUE) 
                                OR (COALESCE (Movement_Promo.isPromo, FALSE) = FALSE AND inIsTender = TRUE)
                                OR (inIsPromo = FALSE AND inIsTender = FALSE)
                                )
                          )

    --������ �� ������� ���. �����           
  , tmpMI_1 AS (SELECT MI_PromoGoods.*
                FROM (SELECT DISTINCT tmpMIFloat_PromoMovement.MovementId_promo AS Id FROM tmpMIFloat_PromoMovement) AS Movement_Promo
                   LEFT JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                          ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                         AND MI_PromoGoods.IsErASed = FALSE 
               ) 

  , tmpMIFloat_PriceIn1 AS (
                            SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_1.Id FROM tmpMI_1)
                              AND MovementItemFloat.DescId = zc_MIFloat_PriceIn1()
                           )

  , tmpObjectString_Goods_GroupNameFull AS (SELECT ObjectString.*
                            FROM ObjectString
                            WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpMI_1.GoodsId FROM tmpMI_1)
                              AND ObjectString.DescId = zc_ObjectString_Goods_GroupNameFull()
                           )
  , tmpMI AS (SELECT 
                     MI_PromoGoods.MovementId          --�� ��������� <�����>
                   , MI_PromoGoods.GoodsId             --�� �������  <�����>
                   , MI_PromoGoods.GoodsCode           --��� �������  <�����>
                   , MI_PromoGoods.GoodsName           --������������ ������� <�����>
                   , MI_PromoGoods.Measure             --������� ���������
                   , MI_PromoGoods.MeasureId             --������� ���������
                   , MI_PromoGoods.TradeMark           --�������� �����

                   , MI_PromoGoods.Price               --���� � ������
                   , MI_PromoGoods.PriceWithVAT        --���� �������� � ������ ���, � ������ ������, ���
                   , MI_PromoGoods.PriceSale           --���� �� �����

                   , MI_PromoGoods.GoodsWeight -- ���
                   , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindId,0) ELSE 0 END AS GoodsKindId
                   , STRING_AGG (MI_PromoGoods.GoodsKindName, '; ')         ::TVarChar AS GoodsKindName       --������������ ������� <��� ������>
                   , STRING_AGG (MI_PromoGoods.GoodsKindCompleteName, '; ') ::TVarChar AS GoodsKindCompleteName   

                   , AVG (MI_PromoGoods.Amount) AS Amount              --% ������ �� �����             
                   , SUM (MI_PromoGoods.AmountReal) AS AmountReal          --����� ������ � ����������� ������, ��
                   , SUM (MI_PromoGoods.AmountRealWeight) AS AmountRealWeight    --����� ������ � ����������� ������, �� ���
             
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMin,0))       AS AmountPlanMin       --������� ������������ ������ ������ �� ��������� ������ (� ��)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMinWeight,0)) AS AmountPlanMinWeight --������� ������������ ������ ������ �� ��������� ������ (� ��) ���
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMax,0))       AS AmountPlanMax       --�������� ������������ ������ ������ �� ��������� ������ (� ��)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMaxWeight,0)) AS AmountPlanMaxWeight --�������� ������������ ������ ������ �� ��������� ������ (� ��) ���
                    --������������ ��� ��������
                   , SUM (COALESCE (MI_PromoGoods.AmountOut,0))        AS AmountOut_promo         --���-�� ���������� (����)
                   , SUM (COALESCE (MI_PromoGoods.AmountOutWeight,0))  AS AmountOutWeight_promo   --���-�� ���������� (����) ���
                   , SUM (COALESCE (MI_PromoGoods.AmountIn,0))         AS AmountIn_promo          --���-�� ������� (����)
                   , SUM (COALESCE (MI_PromoGoods.AmountInWeight,0))   AS AmountInWeight_promo    --���-�� ������� (����) ���
                   /*
                   , SUM (COALESCE (MI_PromoGoods.AmountOut, 0) - COALESCE (MI_PromoGoods.AmountIn, 0))            :: TFloat  AS AmountSale       -- ������� - ������� 
                   , SUM(COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) :: TFloat  AS AmountSaleWeight -- ������� - ������� 
                   */
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut,0))       AS AmountOut
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut,0)
                          * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END)  AS AmountOutWeight   --���-�� ���������� (����) ���
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountIn,0))         AS AmountIn          --���-�� ������� (����)
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountIn,0)
                          * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END)   AS AmountInWeight    --���-�� ������� (����) ���
             
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut, 0) - COALESCE (tmpMI_SaleReturn.AmountIn, 0))            :: TFloat  AS AmountSale       -- ������� - ������� 
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut, 0) * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END
                        - COALESCE (tmpMI_SaleReturn.AmountIn, 0) * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END  
                         ) :: TFloat  AS AmountSaleWeight -- ������� - �������   
                   , tmpMI_SaleReturn.Month_Partner                                                                ::TDateTime AS Month_Partner
                   ----
                   
                   
                   , SUM(COALESCE (MI_PromoGoods.Price, 0) - COALESCE (MI_PromoGoods.PriceWithVAT,0))              :: TFloat  AS Price_Diff
                   
                   , AVG (COALESCE (MI_PromoGoods.MainDiscount,0))                                                 ::TFloat   AS MainDiscount
                   , MAX (MIFloat_PriceIn1.ValueData)                                                              ::TFloat   AS PriceIn1               --������������� ����,  �� ��
                   , MAX (MI_PromoGoods.ContractCondition)                                                         ::TFloat   AS ContractCondition      -- ����� ����, %
                   , ObjectString_Goods_GoodsGroupFull.ValueData                                                              AS GoodsGroupNameFull
                   
              FROM tmpMI_SaleReturn
                   --���������� ������ ������ ��������� �� ������ � ���� ������� �������� � ������ �� ���� ����������.
                   LEFT JOIN tmpMI_1 AS MI_PromoGoods ON MI_PromoGoods.MovementId = tmpMI_SaleReturn.MovementId_promo
                                                     AND MI_PromoGoods.GoodsId = tmpMI_SaleReturn.GoodsId
                                                     AND (COALESCE (tmpMI_SaleReturn.GoodsKindId,0) =  COALESCE (MI_PromoGoods.GoodsKindId,0)
                                                          OR COALESCE (MI_PromoGoods.GoodsKindId,0) = 0)                                      -- COALESCE (MI_PromoGoods.GoodsKindCompleteId,0)

                   LEFT JOIN tmpMIFloat_PriceIn1 AS MIFloat_PriceIn1
                                                 ON MIFloat_PriceIn1.MovementItemId = MI_PromoGoods.Id
                                                AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()

                   LEFT JOIN tmpObjectString_Goods_GroupNameFull AS ObjectString_Goods_GoodsGroupFull
                                          ON ObjectString_Goods_GoodsGroupFull.ObjectId = MI_PromoGoods.GoodsId
                                         AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
              GROUP BY MI_PromoGoods.MovementId
                     , MI_PromoGoods.GoodsId
                     , MI_PromoGoods.GoodsCode
                     , MI_PromoGoods.GoodsName
                     , MI_PromoGoods.Measure
                     , MI_PromoGoods.MeasureId
                     , MI_PromoGoods.TradeMark
                     , MI_PromoGoods.Price
                     , MI_PromoGoods.PriceWithVAT
                     , MI_PromoGoods.PriceSale
                     , MI_PromoGoods.GoodsWeight 
                     , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindId,0) ELSE 0 END
                     , CASE WHEN inIsGoodsKind = FALSE THEN MI_PromoGoods.GoodsKindName ELSE '' END
                     , CASE WHEN inIsGoodsKind = FALSE THEN MI_PromoGoods.GoodsKindCompleteName ELSE '' END 
                     , ObjectString_Goods_GoodsGroupFull.ValueData
                     , tmpMI_SaleReturn.Month_Partner
              )
   --����������� �� ���. �����, ��� �������� ������/���������
  , _tmpPartner_new AS (SELECT tmpMovement.Id AS MovementId, tmp.PartnerId, tmp.ContractId 
                        FROM tmpMovement_Promo AS tmpMovement
                          LEFT JOIN lpSelect_Movement_PromoPartner_Detail (inMovementId:= tmpMovement.Id) AS tmp ON 1=1 
                        --WHERE tmpMovement.Id = 29516976
                        )   
  
   --���� ��������, �� ������� ����� ������� �������
  , tmpPeriod AS (SELECT  MIN (tmpMovement.OperDateStart) AS OperDateStart, MAX (tmpMovement.OperDateEnd) AS OperDateEnd
                  FROM tmpMovement_Promo AS tmpMovement
                  )
   --���.�������
  , tmpMovement_sale AS (SELECT Movement.Id           AS MovementId
                              , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                              , MLO_To.ObjectId       AS PartnerId
                              , MLO_Contract.ObjectId AS ContractId
                         FROM tmpPeriod
                              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.ValueData BETWEEN tmpPeriod.OperDateStart AND tmpPeriod.OperDateEnd
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                              INNER JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = MovementDate_OperDatePartner.MovementId
                                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
                              INNER JOIN _tmpPartner_new ON _tmpPartner_new.PartnerId = MLO_To.ObjectId 
                              INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                 AND Movement.DescId = zc_Movement_Sale()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              --LEFT JOIN MovementLinkObject AS MLO_From
                              --                             ON MLO_From.MovementId = MLO_To.MovementId
                              --                            AND MLO_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN MovementLinkObject AS MLO_Contract
                                                           ON MLO_Contract.MovementId = MLO_To.MovementId
                                                          AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()
                         WHERE (MLO_Contract.ObjectId = _tmpPartner_new.ContractId OR _tmpPartner_new.ContractId = 0)
                         )
  -- ���.��������
  , tmpMovement_ReturnIn AS (SELECT Movement.Id           AS MovementId
                                  , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                                  , MLO_From.ObjectId     AS PartnerId
                                  , MLO_Contract.ObjectId AS ContractId
                             FROM tmpPeriod
                               INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                       ON MovementDate_OperDatePartner.ValueData BETWEEN tmpPeriod.OperDateStart AND tmpPeriod.OperDateEnd
                                                      AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                               INNER JOIN MovementLinkObject AS MLO_From
                                                             ON MLO_From.MovementId = MovementDate_OperDatePartner.MovementId
                                                            AND MLO_From.DescId = zc_MovementLinkObject_From()
                               INNER JOIN _tmpPartner_new ON _tmpPartner_new.PartnerId = MLO_From.ObjectId
                               INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                  AND Movement.DescId = zc_Movement_ReturnIn()
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               --LEFT JOIN MovementLinkObject AS MLO_To
                               --                             ON MLO_To.MovementId = MLO_From.MovementId
                               --                            AND MLO_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN MovementLinkObject AS MLO_Contract
                                                            ON MLO_Contract.MovementId = MLO_From.MovementId
                                                           AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()
                             WHERE (MLO_Contract.ObjectId = _tmpPartner_new.ContractId OR _tmpPartner_new.ContractId = 0)
                            )
   /*                     



  , tmpMI_promo_all AS (SELECT MI_PromoGoods.Id AS MovementItemId
                             , MI_PromoGoods.GoodsId
                             , CASE WHEN MI_PromoGoods.GoodsKindId > 0 THEN MI_PromoGoods.GoodsKindId ELSE COALESCE (MI_PromoGoods.GoodsKindCompleteId, 0) END AS GoodsKindId
                           --, COALESCE (MI_PromoGoods.GoodsKindCompleteId, 0) AS GoodsKindId -- GoodsKindCompleteId
                           --, 0 AS GoodsKindId
                             , MI_PromoGoods.isErased
                        FROM MovementItem_PromoGoods_View AS MI_PromoGoods
                        WHERE MI_PromoGoods.MovementId  IN ( 29786084 ,29787104 )
                       )
      , tmpMI_promo AS (SELECT -- �.�. ���� ����������� "��� ���� GoodsKindId" - ������� � ����, ����� ��������� ������������
                               MAX (COALESCE (tmpMI_promo_all_find.MovementItemId, tmpMI_promo_all.MovementItemId)) AS MovementItemId
                             , tmpMI_promo_all.GoodsId
                             , COALESCE (tmpMI_promo_all_find.GoodsKindId, tmpMI_promo_all.GoodsKindId) AS GoodsKindId
                        FROM tmpMI_promo_all
                             LEFT JOIN tmpMI_promo_all AS tmpMI_promo_all_find ON tmpMI_promo_all_find.GoodsId     = tmpMI_promo_all.GoodsId
                                                                              AND tmpMI_promo_all_find.GoodsKindId = 0
                                                                              AND tmpMI_promo_all_find.isErased    = FALSE
                        WHERE tmpMI_promo_all.isErased = FALSE
                          -- AND (tmpMI_promo_all.GoodsKindId = 0 OR tmpMI_promo_all_find.GoodsId IS NULL) -- �.�. ���� ����������� "��� ���� GoodsKindId" - ���� �������� � GoodsKindId <> 0, ����� ��������� ������������
                        GROUP BY tmpMI_promo_all.GoodsId
                               , COALESCE (tmpMI_promo_all_find.GoodsKindId, tmpMI_promo_all.GoodsKindId)
                       )
                       */
   --������ �� ��������
  , tmpMI_sale AS (WITH
                   tmpMI AS (SELECT MovementItem.*
                             FROM MovementItem
                             WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_sale.MovementId FROM tmpMovement_sale)
                                               AND MovementItem.DescId = zc_MI_Master()
                                               AND MovementItem.isErased = FALSE
                             )
                 , tmpMILO AS (SELECT *
                              FROM MovementItemLinkObject
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                              )
                 , tmpMIFloat AS (SELECT *
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                              )                         
                   SELECT tmpMovement_sale.OperDatePartner
                        , tmpMovement_sale.PartnerId
                        , tmpMovement_sale.ContractId
                        , MovementItem.ObjectId AS GoodsId
                        , COALESCE (MILinkObject_GoodsKind.ObjectId,0)        AS GoodsKindId
                        , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                   FROM tmpMovement_sale
                        INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = tmpMovement_sale.MovementId
                                               
                        LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                        --INNER JOIN tmpMI_1 AS tmpMI_promo ON tmpMI_promo.GoodsId = MovementItem.ObjectId
                        --                                AND (tmpMI_promo.GoodsKindId = MILinkObject_GoodsKind.ObjectId OR tmpMI_promo.GoodsKindId = 0)
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                             ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                            AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   GROUP BY tmpMovement_sale.OperDatePartner
                          , tmpMovement_sale.PartnerId
                          , tmpMovement_sale.ContractId
                          , MovementItem.ObjectId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                   )
   --������ �� ���������
  , tmpMI_ReturnIn AS (WITH
                       tmpMI AS (SELECT MovementItem.*
                                 FROM MovementItem
                                 WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_ReturnIn.MovementId FROM tmpMovement_ReturnIn)
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                                 )
                     , tmpMILO AS (SELECT *
                                  FROM MovementItemLinkObject
                                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                    AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                  )
                     , tmpMIFloat AS (SELECT *
                                  FROM MovementItemFloat
                                  WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                    AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                                  ) 
                       SELECT tmpMovement_ReturnIn.OperDatePartner
                            , tmpMovement_ReturnIn.PartnerId
                            , tmpMovement_ReturnIn.ContractId
                            , MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId,0) AS GoodsKindId  
                            , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                       FROM tmpMovement_ReturnIn
                            INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = tmpMovement_ReturnIn.MovementId
 
                            LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                            --INNER JOIN tmpMI_1 AS tmpMI_promo ON tmpMI_promo.GoodsId      = MovementItem.ObjectId
                            --                                AND (tmpMI_promo.GoodsKindId = MILinkObject_GoodsKind.ObjectId OR tmpMI_promo.GoodsKindId = 0)
                            LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                       GROUP BY tmpMovement_ReturnIn.OperDatePartner
                              , tmpMovement_ReturnIn.PartnerId
                              , tmpMovement_ReturnIn.ContractId
                              , MovementItem.ObjectId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                       )
   -- ������ ������ + ���������, �������������� �� ������ � ��������
  , tmpSaleReturn AS (WITH
                      tmpUnion AS (SELECT tmp.OperDatePartner
                                        , tmp.PartnerId
                                        , tmp.ContractId
                                        , tmp.GoodsId
                                        , tmp.GoodsKindId  
                                        , tmp.AmountPartner  AS AmountReal
                                        , 0 AS AmountRetIn
                                   FROM tmpMI_sale AS tmp 
                                  UNION All
                                   SELECT  tmp.OperDatePartner
                                         , tmp.PartnerId
                                         , tmp.ContractId
                                         , tmp.GoodsId
                                         , tmp.GoodsKindId  
                                         , 0  AS AmountReal
                                         , tmp.AmountPartner AS AmountRetIn
                                   FROM tmpMI_ReturnIn AS tmp
                                  )
                      --���=�������� �� ��� ����� + ����� + ���  + ������ �� �������
                      SELECT tmpMovement.Id  AS MovementId_promo 
                           , DATE_TRUNC ('MONTH', tmpUnion.OperDatePartner) AS Month_Partner
                           , tmpUnion.GoodsId
                           , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (tmpUnion.GoodsKindId,0) ELSE 0 END AS GoodsKindId        --���� ��� ������������� �� ������ -  ������� ����� ���� ��� ������� ������ �� ������
                           , SUM (COALESCE (tmpUnion.AmountReal,0))  AS AmountReal
                           , SUM (COALESCE (tmpUnion.AmountRetIn,0)) AS AmountRetIn
                           , SUM (COALESCE (tmpUnion.AmountReal,0)
                                 /* * CASE WHEN tmpMI.MeasureId = zc_Measure_Sh() THEN tmpMI.GoodsWeight ELSE 1 END*/) AS AmountRealWeight
                           , SUM (COALESCE (tmpUnion.AmountRetIn,0)
                                 /* * CASE WHEN tmpMI.MeasureId = zc_Measure_Sh() THEN tmpMI.GoodsWeight ELSE 1 END*/) AS AmountRetInWeight
                           
                      FROM tmpMovement_Promo AS tmpMovement
                          LEFT JOIN _tmpPartner_new ON _tmpPartner_new.MovementId = tmpMovement.Id
                          LEFT JOIN tmpUnion ON tmpUnion.OperDatePartner BETWEEN tmpMovement.OperDateStart AND tmpMovement.OperDateEnd
                                            AND tmpUnion.PartnerId =  _tmpPartner_new.PartnerId
                                            AND (tmpUnion.ContractId =  _tmpPartner_new.ContractId OR _tmpPartner_new.ContractId = 0)
                         /* LEFT JOIN tmpMI_1 AS tmpMI 
                                            ON tmpMI.MovementId = tmpMovement.Id
                                           AND tmpMI.GoodsId = tmpUnion.GoodsId
                                           AND (COALESCE (tmpMI.GoodsKindId,0) = COALESCE (tmpUnion.GoodsKindId,0) OR COALESCE (tmpMI.GoodsKindId,0) = 0) 
                         */
                      GROUP BY tmpMovement.Id 
                             , DATE_TRUNC ('MONTH', tmpUnion.OperDatePartner)
                             , tmpUnion.GoodsId 
                             , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (tmpUnion.GoodsKindId,0) ELSE 0 END
                      HAVING SUM (COALESCE (tmpUnion.AmountReal,0)) <> 0
                          OR SUM (COALESCE (tmpUnion.AmountRetIn,0)) <> 0
                     )

                   
        SELECT
            Movement_Promo.Id                --�� ��������� �����
          , Movement_Promo.InvNumber          -- * � ��������� �����
          , Movement_Promo.OperDate
          , Movement_Promo.UnitName           --�����
          , Movement_Promo.PersonalTradeName  --������������� ������������� ������������� ������
          , Movement_Promo.PersonalName       --* ������������� ������������� �������������� ������	
          , Movement_Promo.StartSale          --*���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --*���� ��������� �������� �� ��������� ����
          , Movement_Promo.StartPromo         --*���� ������ �����
          , Movement_Promo.EndPromo           --*���� ��������� �����
          , Movement_Promo.MonthPromo         --* ����� �����
          , Movement_Promo.CheckDate          -- ���� ������������

          , COALESCE ((SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
                       FROM Movement AS Movement_PromoPartner
                          INNER JOIN MovementItem AS MI_PromoPartner
                                                  ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                 AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                 AND MI_PromoPartner.IsErased   = FALSE
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                                              AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                          
                          LEFT OUTER JOIN MovementString AS MovementString_Retail
                                                         ON MovementString_Retail.MovementId = Movement_PromoPartner.Id
                                                        AND MovementString_Retail.DescId = zc_MovementString_Retail()
                                                        AND MovementString_Retail.ValueData <> ''
                                      
                       WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                         AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                         AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                      )
                    , (SELECT STRING_AGG (DISTINCT Object.ValueData,'; ')
                       FROM
                          Movement AS Movement_PromoPartner
                          INNER JOIN MovementLinkObject AS MLO_Partner
                                                        ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                                       AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                          INNER JOIN Object ON Object.Id = MLO_Partner.ObjectId
                       WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                         AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                         AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                        ))                                                       :: TBlob AS RetailName    -- * �������� ����
            --------------------------------------
          , (SELECT STRING_AGG (DISTINCT Object_Area.ValueData,'; ')
             FROM
                Movement AS Movement_PromoPartner
                INNER JOIN MovementItem AS MI_PromoPartner
                                        ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                       AND MI_PromoPartner.DescId     = zc_MI_Master()
                                       AND MI_PromoPartner.IsErased   = FALSE
                INNER JOIN ObjectLink AS ObjectLink_Partner_Area
                                      ON ObjectLink_Partner_Area.ObjectId = MI_PromoPartner.ObjectId
                                     AND ObjectLink_Partner_Area.DescId   = zc_ObjectLink_Partner_Area()
                INNER JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
                
             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            )                                                                    :: TBlob AS AreaName      -- * ������

          , (SELECT STRING_AGG ( tmp.JuridicalName,'; ')
             FROM (SELECT DISTINCT Object_Juridical.ValueData AS JuridicalName
                        , CASE WHEN Object_Juridical.Id = inJuridicalId THEN 1 else 99 END AS ord
                   FROM
                      Movement AS Movement_PromoPartner

                      INNER JOIN MovementItem AS MI_PromoPartner
                                              ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                             AND MI_PromoPartner.DescId     = zc_MI_Master()
                                             AND MI_PromoPartner.IsErased   = FALSE
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                      LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                   WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                     AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                     AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                   ORDER BY CASE WHEN Object_Juridical.Id = inJuridicalId THEN 1 else 99 END 
                   ) AS tmp
            ) ::TBlob AS JuridicalName_str

          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.GoodsId
          , MI_PromoGoods.Measure
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.GoodsGroupNameFull
          , MI_PromoGoods.GoodsKindName
          , MI_PromoGoods.GoodsKindCompleteName
          
          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight
          
          , MI_PromoGoods.AmountPlanMin       :: TFloat --������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMinWeight  :: TFloat--������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountPlanMax        :: TFloat--�������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMaxWeight  :: TFloat--�������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          
          , MI_PromoGoods.AmountReal          :: TFloat --����� ������ � ����������� ������, ��
          , MI_PromoGoods.AmountRealWeight    :: TFloat --����� ������ � ����������� ������, �� ���
          -- 4 �������� �� ���. ����� ��� ��������
          , MI_PromoGoods.AmountOut_promo            :: TFloat--���-�� ���������� (����)
          , MI_PromoGoods.AmountOutWeight_promo      :: TFloat--���-�� ���������� (����) ���
          , MI_PromoGoods.AmountIn_promo             :: TFloat--���-�� ������� (����)
          , MI_PromoGoods.AmountInWeight_promo       :: TFloat--���-�� ������� (����) ���

          , MI_PromoGoods.AmountOut            :: TFloat--���-�� ���������� (����)
          , MI_PromoGoods.AmountOutWeight      :: TFloat--���-�� ���������� (����) ���
          , MI_PromoGoods.AmountIn             :: TFloat--���-�� ������� (����)
          , MI_PromoGoods.AmountInWeight       :: TFloat--���-�� ������� (����) ���
          , MI_PromoGoods.AmountSale          :: TFloat -- ������� - ������� 
          , MI_PromoGoods.AmountSaleWeight    :: TFloat -- ������� - ������� 
          
          , CAST (CASE WHEN COALESCE (MI_PromoGoods.AmountRealWeight, 0) = 0 AND MI_PromoGoods.AmountSaleWeight > 0
                            THEN 100
                       WHEN COALESCE (MI_PromoGoods.AmountRealWeight, 0) <> 0
                            THEN (MI_PromoGoods.AmountSaleWeight / MI_PromoGoods.AmountRealWeight - 1) *100
                       WHEN MI_PromoGoods.AmountSaleWeight < 0
                            THEN -100
                       ELSE 0
                  END AS NUMERIC (16, 0))     :: TFloat AS PersentResult
          
           -- ������
          , (CASE WHEN MI_PromoGoods.Amount <> 0
                       THEN zfConvert_FloatToString (MI_PromoGoods.Amount)
             END) :: TBlob   AS Discount

          -- �����������
          , (SELECT STRING_AGG (zfConvert_FloatToString (MovementItem_PromoCondition.Amount)
                                 ||' - ' || MovementItem_PromoCondition.ConditionPromoName
                                        , '; ' ) 
             FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition
             WHERE MovementItem_PromoCondition.MovementId = Movement_Promo.Id
               AND MovementItem_PromoCondition.IsErased   = FALSE
               AND MovementItem_PromoCondition.Amount     <> 0
              ) :: TBlob   AS Discount_Condition
                 
          , MI_PromoGoods.MainDiscount        :: TFloat AS MainDiscount
                 
          , MI_PromoGoods.PriceWithVAT        :: TFloat
          , ROUND (MI_PromoGoods.Price * ((100 + Movement_Promo.VATPercent)/100), 2) :: TFloat    AS Price       --- , MI_PromoGoods.Price               :: TFloat
          , Movement_Promo.CostPromo          :: TFloat
          , MI_PromoGoods.PriceSale           :: TFloat

          , MI_PromoGoods.PriceIn1            --������������� ����,  �� ��
          , (MI_PromoGoods.Price_Diff * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))    :: TFloat AS Profit_Virt
          , (MI_PromoGoods.Price * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.AmountReal, 0) ELSE COALESCE (MI_PromoGoods.AmountRealWeight, 0) END)         :: TFloat AS SummReal
          , (MI_PromoGoods.PriceWithVAT * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.AmountSale, 0) ELSE COALESCE (MI_PromoGoods.AmountSaleWeight, 0) END ) :: TFloat AS SummPromo
          , MI_PromoGoods.ContractCondition                                              :: TFloat AS ContractCondition      -- ����� ����, %
          
          , CASE WHEN COALESCE (MI_PromoGoods.PriceIn1, 0) <> 0 AND COALESCE (MI_PromoGoods.AmountSaleWeight, 0) <> 0
                 THEN (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))
                    - (COALESCE (MI_PromoGoods.PriceIn1, 0) 
                       + 0
                       + (( (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))  * 0 /*ContractCondition*/ ) / COALESCE (MI_PromoGoods.AmountSaleWeight, 0))
                       ) * COALESCE (MI_PromoGoods.AmountSaleWeight, 0) 
                 ELSE 0
            END                               :: TFloat    AS Profit


          , (SELECT STRING_AGG (Movement_PromoAdvertising.AdvertisingName,'; ')
                 FROM (SELECT DISTINCT Movement_PromoAdvertising_View.AdvertisingName
                       FROM Movement_PromoAdvertising_View
                       WHERE Movement_PromoAdvertising_View.ParentId = Movement_Promo.Id
                         AND COALESCE (Movement_PromoAdvertising_View.AdvertisingName,'') <> ''
                         AND Movement_PromoAdvertising_View.isErASed = FALSE
                      ) AS Movement_PromoAdvertising
            )                                 :: TBlob     AS AdvertisingName

          , ''                                :: TVarChar  AS Comment                -- ����������
          , ''                                :: TVarChar  AS CommentMain            -- ����������    
          
          , COALESCE (MI_PromoGoods.Month_Partner, tmpSaleReturn.Month_Partner) ::TDateTime AS Month_Partner --����� ������� / �������� - �� ���� ���������� / ����������� ������
          -- ������� �� ����������� ������
          , COALESCE (tmpSaleReturn.AmountReal,0)       ::TFloat AS AmountReal_calc
          , COALESCE (tmpSaleReturn.AmountRealWeight,0) ::TFloat AS AmountRealWeight_calc
          -- ������� �� ����������� ������
          , COALESCE (tmpSaleReturn.AmountRetIn,0)      ::TFloat AS AmountRetIn_calc
          , COALESCE (tmpSaleReturn.AmountRetInWeight,0)::TFloat AS AmountRetInWeight_calc
        FROM tmpMovement_Promo AS Movement_Promo
            -- LEFT JOIN tmpVAT ON tmpVAT.PriceListId = Movement_Promo.PriceListId
             LEFT JOIN tmpMI AS MI_PromoGoods ON MI_PromoGoods.MovementId = Movement_Promo.Id 
             LEFT JOIN tmpSaleReturn ON tmpSaleReturn.MovementId_promo = Movement_Promo.Id
                                    AND tmpSaleReturn.GoodsId = MI_PromoGoods.GoodsId
                                    AND COALESCE (tmpSaleReturn.GoodsKindId,0) = COALESCE (MI_PromoGoods.GoodsKindId,0)
                                    --AND (tmpSaleReturn.Month_Partner = MI_PromoGoods.Month_Partner OR MI_PromoGoods.Month_Partner IS NULL)
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.11.24         *
*/

-- ����
-- SELECT * FROM gpSelect_Report_Promo_Result_Month (inStartDate:= '21.09.2017', inEndDate:= '21.09.2017', inIsPromo:= TRUE, inIsTender:= FALSE, inIsGoodsKind:= true, inUnitId:= 0, inRetailId:= 0, inMovementId:= 0, inJuridicalId:= 0, inSession:= zfCalc_UserAdmin());
--SELECT * FROM gpSelect_Report_Promo_Result_Month (inStartDate:= '21.09.2024', inEndDate:= '21.09.2024', inIsPromo:= TRUE, inIsTender:= FALSE, inIsGoodsKind:= true, inUnitId:= 0, inRetailId:= 0, inMovementId:= 0, inJuridicalId:= 0, inSession:= zfCalc_UserAdmin());
