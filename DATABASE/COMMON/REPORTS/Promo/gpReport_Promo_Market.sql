

DROP FUNCTION IF EXISTS gpReport_Promo_Market(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Boolean,   --�������� ������ �����
    Boolean,   --�������� ������ �������
    Integer,   --�������������
    Integer,   --��.����
    TVarChar   --������ ������������
);
CREATE OR REPLACE FUNCTION gpReport_Promo_Market(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inIsPromo        Boolean,   --�������� ������ �����
    IN inIsTender       Boolean,   --�������� ������ �������
    IN inUnitId         Integer,   --�������������
    IN inJuridicalId    Integer,   --��.����
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
      MovementId           Integer   --�� ��������� �����
    , OperDate             TDateTime -- * ������ �������� � ����
    , InvNumber            TVarChar   --� ��������� �����
    , StatusCode Integer, StatusName TVarChar
    , UnitName            TVarChar  --�����
    , DateStartSale       TDateTime       --���� ������ �������� �� ��������� ����
    , DateFinalSale       TDateTime       --���� ��������� �������� �� ��������� ����
    , DateStartPromo      TDateTime       --���� ������ �����
    , DateFinalPromo      TDateTime       --���� ��������� �����
    , MonthPromo          TDateTime       --����� �����
    , PromoKindName        TVarChar    --������� ������� � �����
    , PromoStateKindName   TVarChar    --��������� �����
    ,RetailName           TBlob     --����, � ������� �������� �����
    ,JuridicalName_str    TBlob     --��.����
    ,GoodsName            TVarChar  --�������
    ,GoodsCode            Integer   --��� �������
    ,MeasureName          TVarChar  --������� ���������
    ,TradeMarkName        TVarChar  --�������� �����
    ,GoodsKindName             TVarChar  --��� ��������
    ,AmountOut_fact            TFloat    --���-�� ���������� (����)
    ,AmountOutWeight_fact      TFloat    --���-�� ���������� (����) ���
    ,AmountIn_fact             TFloat    --���-�� ������� (����)
    ,AmountInWeight_fact       TFloat    --���-�� ������� (����) ���

    , SummOut_diff TFloat  -- summa ������� ��� (�� ������ � �����) * �� �������
    , SummIn_diff TFloat   -- summa ������� ��� (�� ������ � �����) * �� �������
    , Summ_diff TFloat     -- summa ������� ��� (�� ������ � �����) * �� (�������-�������)
--, Price_pl TFloat
--, Price    TFloat
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

/*
����� ������ ������� �������� �� StartSale + EndSale 
     + ������� �� ��� ����� � ������ � ������� zc_MovementLinkObject_PromoKind = � ���� �������������� �������,
������ ������ ��� ������ � ��������� � ����� ������ �� OperDatePartner ������� ���-�� �� *(���� �� ������ �� ���� ���� - ���� � ����)
*/
    -- ���������
    RETURN QUERY
     WITH 
        -- 1) ����� ��� ����� � ������� ������ �������� � .. �� ...  ������� �������� � ������ �����
          tmpMovement AS (SELECT Movement_Promo.*
                               , MovementDate_StartSale.ValueData            AS StartSale          --���� ������ �������� �� ��������� ����
                               , MovementDate_EndSale.ValueData              AS EndSale            --���� ��������� �������� �� ��������� ����
                               , MovementLinkObject_Unit.ObjectId            AS UnitId
                               , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- ����� (��/���)
                               , MovementLinkObject_PromoKind.ObjectId       AS PromoKindId        --��� �����
                          FROM Movement AS Movement_Promo
                             INNER JOIN MovementLinkObject AS MovementLinkObject_PromoKind
                                                           ON MovementLinkObject_PromoKind.MovementId = Movement_Promo.Id
                                                          AND MovementLinkObject_PromoKind.DescId = zc_MovementLinkObject_PromoKind()
                                                          AND MovementLinkObject_PromoKind.ObjectId = zc_Enum_PromoKind_Budget()

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Promo.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                             LEFT JOIN MovementDate AS MovementDate_StartSale
                                                    ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                             LEFT JOIN MovementDate AS MovementDate_EndSale
                                                    ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                             LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                                       ON MovementBoolean_Promo.MovementId = Movement_Promo.Id
                                                      AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()
                             
                          WHERE Movement_Promo.DescId = zc_Movement_Promo()
                           AND (MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                           OR
                                 inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                                )
                           AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                           AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                           AND (  (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = TRUE AND inIsPromo = TRUE)
                               OR (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = FALSE AND inIsTender = TRUE)
                               OR (inIsPromo = FALSE AND inIsTender = FALSE)
                               )
                            )

        , tmpMovement_Promo AS (SELECT
                                Movement_Promo.Id                                                 --�������������
                              , Movement_Promo.OperDate
                              , Movement_Promo.InvNumber                                          --�������������
                              , Movement_Promo.UnitId
                              , Object_Unit.ValueData                       AS UnitName           --�������������
                              , Object_PromoKind.ValueData                  AS PromoKindName      --������� ������� � �����
                              , Object_PromoStateKind.Id                    AS PromoStateKindId        --��������� �����
                              , Object_PromoStateKind.ValueData             AS PromoStateKindName      --��������� �����
                              , MovementDate_StartPromo.ValueData           AS StartPromo         --���� ������ �����
                              , MovementDate_EndPromo.ValueData             AS EndPromo           --���� ��������� �����
                              , Movement_Promo.StartSale                    AS StartSale          --���� ������ �������� �� ��������� ����
                              , Movement_Promo.EndSale                      AS EndSale            --���� ��������� �������� �� ��������� ����
                              , DATE_TRUNC ('MONTH', MovementDate_Month.ValueData) :: TDateTime AS MonthPromo         -- ����� �����
                              , COALESCE (Movement_Promo.isPromo, FALSE)   :: Boolean AS isPromo  -- ����� (��/���)
                              , Object_Status.ObjectCode                    AS StatusCode         --
                              , Object_Status.ValueData                     AS StatusName         --
                         FROM tmpMovement AS Movement_Promo
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Promo.StatusId
                             LEFT JOIN MovementDate AS MovementDate_StartPromo
                                                    ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                                                   AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                             LEFT JOIN MovementDate AS MovementDate_EndPromo
                                                    ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                                                   AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                             LEFT JOIN MovementDate AS MovementDate_Month
                                                    ON MovementDate_Month.MovementId = Movement_Promo.Id
                                                   AND MovementDate_Month.DescId = zc_MovementDate_Month()
                             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Promo.UnitId
                             LEFT JOIN Object AS Object_PromoKind ON Object_PromoKind.Id = Movement_Promo.PromoKindId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                                          ON MovementLinkObject_PromoStateKind.MovementId = Movement_Promo.Id
                                                         AND MovementLinkObject_PromoStateKind.DescId = zc_MovementLinkObject_PromoStateKind()
                             LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementLinkObject_PromoStateKind.ObjectId
                        )

        -- �������� ��� ��� ������� � �������� �� ���. �����
        , tmpMovementSale_1 AS (SELECT Movement.Id
                                     , Movement.OperDate
                                     , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                                     , Movement.Invnumber
                                     , Movement.DescId
                                     , MovementItem.Id AS MovementItemId
                                     , MovementItem.ObjectId            AS GoodsId
                                     , MIFloat_PromoMovement.ValueData ::Integer AS MovementId_promo
                                     , MovementItem.Amount
                                FROM MovementItemFloat AS MIFloat_PromoMovement
                                     INNER JOIN MovementItem ON MovementItem.Id = MIFloat_PromoMovement.MovementItemId
                                                            AND MovementItem.isErased = FALSE
                                     INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                                        AND Movement.DescId IN ( zc_Movement_Sale(), zc_Movement_ReturnIn())
                                     INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                             ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                            AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                WHERE MIFloat_PromoMovement.ValueData IN (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo)
                                  AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                              )
        
        , tmpMovementSale_2 AS (SELECT Movement.*
                                     , MovementLinkObject_Contract.ObjectId AS ContractId
                                     , MovementLinkObject_Partner.ObjectId  AS PartnerId
                                FROM tmpMovementSale_1 AS Movement
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Partner.DescId = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END          
                                )

        , tmpPriceListAll AS (SELECT Movement.ContractId
                                   , Movement.PartnerId
                                   , Movement.OperDate
                                   , tmp.PriceListId
                              FROM (SELECT DISTINCT tmp.OperDate, tmp.OperDatePartner, tmp.ContractId, tmp.PartnerId  FROM tmpMovementSale_2 AS tmp) AS Movement
                                  LEFT JOIN lfGet_Object_Partner_PriceList_onDate (inContractId     := Movement.ContractId
                                                                                 , inPartnerId      := Movement.PartnerId
                                                                                 , inMovementDescId := zc_Movement_Sale() -- !!!�� ������!!!
                                                                                 , inOperDate_order := Movement.OperDate
                                                                                 , inOperDatePartner:= NULL
                                                                                 , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                                                                 , inIsPrior        := FALSE -- !!!�������� ����� �� �����!!!
                                                                                 , inOperDatePartner_order:= Movement.OperDatePartner
                                                                                  ) AS tmp ON 1=1

                              )

        , tmpMovementSale AS (SELECT Movement.*
                                   , tmpPriceListAll.PriceListId
                              FROM tmpMovementSale_2 AS Movement
                                   LEFT JOIN tmpPriceListAll ON tmpPriceListAll.OperDate = Movement.OperDate
                                                            AND tmpPriceListAll.ContractId = Movement.ContractId
                                                            AND tmpPriceListAll.PartnerId = Movement.PartnerId
                              )

          -- ���� �� ������
        , tmpPriceList AS (SELECT tmp.PriceListId
                                , tmp.OperDate
                                , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                                , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                                , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                           FROM (SELECT DISTINCT tmpMovementSale.PriceListId, tmpMovementSale.OperDate FROM tmpMovementSale) AS tmp
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                     ON ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                                    AND ObjectLink_PriceListItem_PriceList.ChildObjectId = tmp.PriceListId
                                                    
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                     ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                     ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()
                    
                                LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                        ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                       AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                       AND tmp.OperDate >= ObjectHistory_PriceListItem.StartDate AND tmp.OperDate < ObjectHistory_PriceListItem.EndDate
                                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                             ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                            AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                           WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
                           )


        , tmpMI_GoodsKind AS (SELECT *
                              FROM MovementItemLinkObject 
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovementSale.MovementItemId FROM tmpMovementSale)
                                AND MovementItemLinkObject.DescId         = zc_MILinkObject_GoodsKind()
                              )

        , tmpMovementItemFloat AS (SELECT *
                                   FROM MovementItemFloat 
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovementSale.MovementItemId FROM tmpMovementSale)
                                     AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner()
                                                                    , zc_MIFloat_Price())
                                   )

        , tmpDataFact AS (SELECT Movement.MovementId_promo
                               , Movement.GoodsId
                               , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                               , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                          
                               , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale()  THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)          :: TFloat AS AmountOut
                               , SUM ( CASE WHEN Movement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END ) :: TFloat AS AmountOutWeight
                  
                               , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)       :: TFloat AS AmountIn
                               , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END )  :: TFloat AS AmountInWeight
                                      
                               , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale()  THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END 
                                      * (COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0) - COALESCE (MIFloat_Price.ValueData,0) ) )          :: TFloat AS SummOut
                               , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                      * (COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0) - COALESCE (MIFloat_Price.ValueData,0) ) )          :: TFloat AS SummIn
--, COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0) AS Price_pl
--, COALESCE (MIFloat_Price.ValueData,0) AS Price
                          FROM tmpMovementSale AS Movement
                  
                               LEFT JOIN tmpMI_GoodsKind AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                   
                               LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner
                                                              ON MIFloat_AmountPartner.MovementItemId = Movement.MovementItemId
                                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                               LEFT JOIN tmpMovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = Movement.MovementItemId
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                    ON ObjectLink_Goods_Measure.ObjectId = Movement.GoodsId
                                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                   
                               LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                                           ON ObjectFloat_Goods_Weight.ObjectId = Movement.GoodsId
                                                          AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                               LEFT JOIN tmpPriceList ON tmpPriceList.PriceListId = Movement.PriceListId
                                                     AND tmpPriceList.OperDate = Movement.OperDate
                                                     AND tmpPriceList.GoodsId = Movement.GoodsId
                                                     AND COALESCE (tmpPriceList.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                               LEFT JOIN tmpPriceList AS tmpPriceListAll
                                                      ON tmpPriceListAll.PriceListId = Movement.PriceListId
                                                     AND tmpPriceListAll.OperDate = Movement.OperDate
                                                     AND tmpPriceListAll.GoodsId = Movement.GoodsId
                                                     AND COALESCE (tmpPriceListAll.GoodsKindId,0) = 0
                          GROUP BY Movement.MovementId_promo
                                 , Movement.GoodsId
                                 , MILinkObject_GoodsKind.ObjectId
                                 , ObjectLink_Goods_Measure.ChildObjectId
--, COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0)
--, COALESCE (MIFloat_Price.ValueData,0)                         
                          )
                        
        --
        SELECT
            Movement_Promo.Id                --�� ��������� �����
          , Movement_Promo.OperDate :: TDateTime AS OperDate
          , Movement_Promo.InvNumber          --� ��������� �����
          , Movement_Promo.StatusCode         --
          , Movement_Promo.StatusName         --

          , Movement_Promo.UnitName           --�����
          , Movement_Promo.StartSale    AS DateStartSale      --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale      AS DateFinalSale      --���� ��������� �������� �� ��������� ����
          , Movement_Promo.StartPromo   AS DateStartPromo      --���� ������ �����
          , Movement_Promo.EndPromo     AS DateFinalPromo      --���� ��������� �����
          , Movement_Promo.MonthPromo         --����� �����
          , Movement_Promo.PromoKindName      --������� ������� � �����
          , Movement_Promo.PromoStateKindName      --��������� �����
          ------------------------
          , COALESCE ((SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
                       FROM
                          Movement AS Movement_PromoPartner
                          /*INNER JOIN MovementLinkObject AS MLO_Partner
                                                        ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                                       AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MLO_Partner.ObjectId*/
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
              ) )::TBlob AS RetailName
            --------------------------------------
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

          , Object_Goods.ValueData       AS GoodsName
          , Object_Goods.ObjectCode      AS GoodsCode
          , Object_Measure.ValueData     AS MeasureName
          , Object_TradeMark.ValueData   AS TradeMarkName
          , Object_GoodsKind.ValueData   AS GoodsKindName

          , tmpDataFact.AmountOut          ::TFloat AS AmountOut_fact      --���-�� ���������� (����)
          , tmpDataFact.AmountOutWeight    ::TFloat AS AmountOutWeight_fact--���-�� ���������� (����) ���
          , tmpDataFact.AmountIn           ::TFloat AS AmountIn_fact       --���-�� ������� (����)
          , tmpDataFact.AmountInWeight     ::TFloat AS AmountInWeight_fact --���-�� ������� (����) ���
          
          , tmpDataFact.SummOut ::TFloat AS SummOut_diff
          , tmpDataFact.SummIn  ::TFloat AS SummIn_diff
          , (COALESCE (tmpDataFact.SummOut,0) - COALESCE (tmpDataFact.SummIn,0)) ::TFloat AS Summ_diff

--, tmpDataFact.Price_pl ::TFloat
--, tmpDataFact.Price    ::TFloat
        FROM tmpDataFact 
            LEFT JOIN tmpMovement_Promo AS Movement_Promo
                                        ON Movement_Promo.Id = tmpDataFact.MovementId_promo
            
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpDataFact.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpDataFact.GoodsKindId
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpDataFact.MeasureId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = tmpDataFact.GoodsId
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.10.21         *
*/

-- ����
--  SELECT * FROM gpReport_Promo_Market(inStartDate := ('01.08.2021')::TDateTime , inEndDate := ('05.08.2021')::TDateTime , inIsPromo := 'False'::Boolean , inIsTender := 'False' ::Boolean, inUnitId := 0 ,  inJuridicalId:=0, inSession := '5'::TVarchar) -- where invnumber = 6862