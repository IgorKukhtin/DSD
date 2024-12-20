-- Function: gpReport_OrderClient)

DROP FUNCTION IF EXISTS gpReport_OrderClient_byBoat (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderClient_byBoat (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderClient_byBoat (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderClient_byBoat (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderClient_byBoat (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderClient_byBoat (TDateTime, TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderClient_byBoat (
    IN inStartDate              TDateTime ,
    IN inEndDate                TDateTime ,
    IN inMovementId_OrderClient Integer,
    IN inObjectId               Integer   ,
    IN inIsDetail               Boolean   , -- ���������� �� ������
    IN inIsOnlyChild            Boolean   , -- ������ �hild ��� ������ Detail
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS TABLE  (MovementId Integer
              , InvNumber Integer
              , OperDate TDateTime

              , ProductId Integer
              , ProductName TVarChar
              , CIN         TVarChar

              , ObjectId Integer
              , ObjectCode Integer
              , ObjectName TVarChar
              , Article TVarChar
              , Article_all TVarChar
              , GoodsGroupName TVarChar
              , GoodsGroupNameFull TVarChar
              , MeasureName TVarChar
              , ProdColorName TVarChar
              , GoodsName_basis TVarChar
              , GoodsCode Integer, GoodsName TVarChar, Article_goods TVarChar
              , ReceiptLevelName TVarChar
              , Comment_goods TVarChar
              , Comment_Object TVarChar

              , MonthRemains Integer
              , ColorText    Integer
              , Remains      TFloat
              , AmountIn     TFloat
              , Comment_mov  TVarChar

              , Amount     TFloat
              , Amount1    TFloat
              , Amount2    TFloat
              , Amount3    TFloat
              , Amount4    TFloat
              , Amount5    TFloat
              , Amount6    TFloat
              , Amount7    TFloat
              , Amount8    TFloat
              , Amount9    TFloat
              , Amount10   TFloat
              , Amount11   TFloat
              , Amount12   TFloat

              , MonthName1    TVarChar
              , MonthName2    TVarChar
              , MonthName3    TVarChar
              , MonthName4    TVarChar
              , MonthName5    TVarChar
              , MonthName6    TVarChar
              , MonthName7    TVarChar
              , MonthName8    TVarChar
              , MonthName9    TVarChar
              , MonthName10   TVarChar
              , MonthName11   TVarChar
              , MonthName12   TVarChar
)
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbMonth Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Goods());
     vbUserId:= lpGetUserBySession (inSession);

     --
     vbMonth := (EXTRACT (MONTH FROM inStartDate) -1);

    RETURN QUERY
    WITH
         -- ������ �� ������ � zc_ObjectDate_Product_DateBegin �� ������ OR �����
         tmpMovement AS (SELECT DISTINCT
                                ObjectDate.ObjectId  AS ProductId
                              , ObjectDate.ValueData AS DateBegin
                              , zfCalc_MonthName (ObjectDate.ValueData) AS MonthName
                              , CASE WHEN EXTRACT (MONTH FROM ObjectDate.ValueData) - vbMonth > 0
                                          THEN EXTRACT (MONTH FROM ObjectDate.ValueData) - vbMonth
                                     ELSE EXTRACT (MONTH FROM ObjectDate.ValueData) - vbMonth + 12
                                END AS MonthBegin
                              , Movement_OrderClient.Id
                              , Movement_OrderClient.OperDate
                              , Movement_OrderClient.InvNumber
                              , Movement_OrderClient.StatusId
                         FROM ObjectDate
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Product
                                                             ON MovementLinkObject_Product.ObjectId = ObjectDate.ObjectId
                                                            AND MovementLinkObject_Product.DescId   = zc_MovementLinkObject_Product() 
                               INNER JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id       = MovementLinkObject_Product.MovementId
                                                                          AND Movement_OrderClient.DescId   = zc_Movement_OrderClient() 
                         WHERE ObjectDate.DescId = zc_ObjectDate_Product_DateBegin()
                           AND ((ObjectDate.ValueData >=inStartDate AND ObjectDate.ValueData <=inEndDate AND COALESCE (inMovementId_OrderClient, 0) = 0)
                                OR MovementLinkObject_Product.MovementId = inMovementId_OrderClient
                               )
                        )
    --
  , tmpMI_Detail AS (SELECT Movement.ProductId
                          , Movement.MonthName
                          , Movement.MonthBegin
                          , Movement.OperDate
                          , Movement.InvNumber
                          , Movement.Id AS MovementId
                          -- ���������
                          , MILinkObject_Partner.ObjectId             AS PartnerId

                            -- ����� ���� ���������� = zc_MI_Child.ObjectId, ������ ��������
                          , CASE WHEN inIsOnlyChild = TRUE THEN MovementItem.ObjectId ELSE COALESCE (MILinkObject_Goods.ObjectId, 0) END  AS GoodsId
                          , COALESCE (MILinkObject_Goods_basis.ObjectId, 0) AS GoodsId_basis
                            -- ������������� / ������/������
                          , CASE WHEN inIsOnlyChild = TRUE THEN 0 ELSE MovementItem.ObjectId END AS ObjectId
                            --  �����
                          --, MILinkObject_ProdOptions.ObjectId         AS ProdOptionsId
                            -- ������ Boat Structure
                          --, MILinkObject_ColorPattern.ObjectId        AS ColorPatternId
                            --  Boat Structure
                          --, MILinkObject_ProdColorPattern.ObjectId    AS ProdColorPatternId
                            --
                          , MILinkObject_ReceiptLevel.ObjectId        AS ReceiptLevelId
                            -- ���������� ��� ������ ����
                          , zfCalc_Value_ForCount (MovementItem.Amount, MIFloat_ForCount.ValueData) AS Amount
                            -- ���������� ����� ����������
                          , MIFloat_AmountPartner.ValueData           AS AmountPartner
                     FROM tmpMovement AS Movement
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId = CASE WHEN inIsOnlyChild = TRUE THEN zc_MI_Child() ELSE zc_MI_Detail() END
                                                 AND MovementItem.isErased = FALSE
                                                 AND (MovementItem.ObjectId = inObjectId OR inObjectId = 0)

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                           ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                           ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                           ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                          /*LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                           ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                           ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                           ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                          */
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                           ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                          LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                      ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                     WHERE Movement.StatusId = zc_Enum_Status_Complete()
                    )

     -- ������������� ������ ����
   , tmpItem_Detail AS (-- ������� 1 - �������� ������ "�����������" ����
                        SELECT tmpItem_Detail.GoodsId_basis AS GoodsId
                             , tmpItem_Detail.ObjectId
                             , tmpItem_Detail.PartnerId
                             , tmpItem_Detail.Amount
                             , tmpItem_Detail.AmountPartner
                             , tmpItem_Detail.GoodsId_basis
                             , tmpItem_Detail.ReceiptLevelId
                             --, tmpItem_Detail.ProdColorPatternId
                             , tmpItem_Detail.ProductId
                             , tmpItem_Detail.MovementId
                             , tmpItem_Detail.InvNumber
                             , tmpItem_Detail.OperDate
                             , tmpItem_Detail.MonthName
                             , tmpItem_Detail.MonthBegin
                        FROM tmpMI_Detail AS tmpItem_Detail
                        WHERE tmpItem_Detail.GoodsId_basis > 0
                           AND inIsOnlyChild = FALSE
                       UNION ALL
                        -- ������� 2 - �������� ���� � ����������� "�����������" ����
                        SELECT DISTINCT
                               tmpItem_Detail.GoodsId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN tmpItem_Detail.GoodsId_basis ELSE tmpItem_Detail.ObjectId END AS ObjectId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.PartnerId     END AS PartnerId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 1 ELSE tmpItem_Detail.Amount        END AS Amount
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.AmountPartner END AS AmountPartner
                             , 0 AS GoodsId_basis
                             , 0 AS ReceiptLevelId
                             --, CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.ProdColorPatternId END AS ProdColorPatternId
                             , tmpItem_Detail.ProductId
                             , tmpItem_Detail.MovementId
                             , tmpItem_Detail.InvNumber
                             , tmpItem_Detail.OperDate
                             , tmpItem_Detail.MonthName
                             , tmpItem_Detail.MonthBegin
                        FROM tmpMI_Detail AS tmpItem_Detail
                       )

  , tmpMI_group AS (SELECT  CASE WHEN inIsDetail = TRUE THEN tmp.ProductId  ELSE 0    END AS ProductId
                          , CASE WHEN inIsDetail = TRUE THEN tmp.MovementId ELSE 0    END AS MovementId
                          , CASE WHEN inIsDetail = TRUE THEN tmp.InvNumber  ELSE ''   END AS InvNumber
                          , CASE WHEN inIsDetail = TRUE THEN tmp.OperDate   ELSE NULL END AS OperDate
                          , tmp.ObjectId -- �������������
                          , CASE WHEN inIsDetail = TRUE THEN tmp.GoodsId_basis ELSE 0 END AS GoodsId_basis
                          , CASE WHEN inIsDetail = TRUE THEN tmp.GoodsId ELSE 0 END AS GoodsId
                          , CASE WHEN inIsDetail = TRUE THEN tmp.ReceiptLevelId ELSE 0 END AS ReceiptLevelId
                          , SUM (COALESCE (tmp.Amount,0)) AS Amount
                          , SUM (CASE WHEN tmp.MonthBegin = 1 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount1
                          , SUM (CASE WHEN tmp.MonthBegin = 2 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount2
                          , SUM (CASE WHEN tmp.MonthBegin = 3 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount3
                          , SUM (CASE WHEN tmp.MonthBegin = 4 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount4
                          , SUM (CASE WHEN tmp.MonthBegin = 5 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount5
                          , SUM (CASE WHEN tmp.MonthBegin = 6 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount6
                          , SUM (CASE WHEN tmp.MonthBegin = 7 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount7
                          , SUM (CASE WHEN tmp.MonthBegin = 8 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount8
                          , SUM (CASE WHEN tmp.MonthBegin = 9 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount9
                          , SUM (CASE WHEN tmp.MonthBegin = 10 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount10
                          , SUM (CASE WHEN tmp.MonthBegin = 11 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount11
                          , SUM (CASE WHEN tmp.MonthBegin = 12 THEN COALESCE (tmp.Amount,0) ELSE 0 END) AS Amount12
                          , ROW_Number() OVER (PARTITION BY tmp.ObjectId) AS Ord
                          , ROW_Number() OVER (PARTITION BY CASE WHEN inIsDetail = TRUE THEN tmp.MovementId ELSE 0 END, tmp.ObjectId) AS Ord2 --

                    FROM tmpItem_Detail AS tmp
                    GROUP BY CASE WHEN inIsDetail = TRUE THEN tmp.ProductId ELSE 0 END
                           , CASE WHEN inIsDetail = TRUE THEN tmp.MovementId ELSE 0 END
                           , CASE WHEN inIsDetail = TRUE THEN tmp.InvNumber  ELSE '' END
                           , CASE WHEN inIsDetail = TRUE THEN tmp.OperDate  ELSE NULL END
                           , tmp.ObjectId
                           , CASE WHEN inIsDetail = TRUE THEN tmp.ReceiptLevelId ELSE 0 END
                           , CASE WHEN inIsDetail = TRUE THEN tmp.GoodsId_basis ELSE 0 END
                           , CASE WHEN inIsDetail = TRUE THEN tmp.GoodsId ELSE 0 END
                    )

    -- ������ �� ������������
  , tmpMIF_MovementId AS (SELECT MIFloat_MovementId.MovementItemId
                               , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                          FROM MovementItemFloat AS MIFloat_MovementId
                          WHERE MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpMovement.Id :: TFloat FROM tmpMovement)
                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                            AND inIsOnlyChild = FALSE
                         )
  , tmpSend_ProductionUnion AS (SELECT CASE WHEN inIsDetail = TRUE THEN MIFloat_MovementId.MovementId_OrderClient ELSE 0 END AS MovementId_OrderClient
                                     , MovementItem.ObjectId
                                     , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                                     , CASE WHEN inIsDetail = TRUE THEN COALESCE (MovementString_Comment.ValueData, '') ELSE '' END AS Comment
                                FROM tmpMIF_MovementId AS MIFloat_MovementId
                                     INNER JOIN MovementItem ON MovementItem.Id = MIFloat_MovementId.MovementItemId
                                                            AND MovementItem.DescId = zc_MI_Master()
                                                            AND MovementItem.isErased = FALSE
                                     INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                        AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion())
                                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                                     LEFT JOIN MovementString AS MovementString_Comment
                                                              ON MovementString_Comment.MovementId = Movement.Id
                                                             AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                                GROUP BY CASE WHEN inIsDetail = TRUE THEN MIFloat_MovementId.MovementId_OrderClient ELSE 0 END
                                       , MovementItem.ObjectId
                                       , CASE WHEN inIsDetail = TRUE THEN COALESCE (MovementString_Comment.ValueData, '') ELSE '' END
                               )


    -- ��������� - �������������
  , tmpGoodsParams AS (SELECT tmpGoods.ObjectId
                            , Object_Goods.ObjectCode            AS ObjectCode
                            , Object_Goods.ValueData             AS ObjectName
                            , ObjectString_Article.ValueData     AS Article
                            , Object_GoodsGroup.Id               AS GoodsGroupId
                            , Object_GoodsGroup.ValueData        AS GoodsGroupName
                            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                            , Object_Measure.Id                  AS MeasureId
                            , Object_Measure.ValueData           AS MeasureName
                            , Object_GoodsTag.Id                 AS GoodsTagId
                            , Object_GoodsTag.ValueData          AS GoodsTagName
                            , Object_GoodsType.Id                AS GoodsTypeId
                            , Object_GoodsType.ValueData         AS GoodsTypeName
                            , Object_GoodsSize.Id                AS GoodsSizeId
                            , Object_GoodsSize.ValueData         AS GoodsSizeName
                            , Object_ProdColor.Id                AS ProdColorId
                            , Object_ProdColor.ValueData         AS ProdColorName
                            , Object_Engine.Id                   AS EngineId
                            , Object_Engine.ValueData            AS EngineName
                            , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice  -- ���� ��. ��� ���
                       FROM (SELECT DISTINCT tmpMI_group.ObjectId FROM tmpMI_group
                            UNION
                             SELECT DISTINCT tmpSend_ProductionUnion.ObjectId FROM tmpSend_ProductionUnion
                            ) AS tmpGoods
                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.ObjectId
                           LEFT JOIN ObjectString AS ObjectString_Article
                                                  ON ObjectString_Article.ObjectId = tmpGoods.ObjectId
                                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

                           LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                  ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.ObjectId
                                                 AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = tmpGoods.ObjectId
                                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                ON ObjectLink_Goods_TaxKind.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                                ON ObjectLink_Goods_GoodsType.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
                           LEFT JOIN Object AS Object_GoodsType ON Object_GoodsType.Id = ObjectLink_Goods_GoodsType.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                                ON ObjectLink_Goods_GoodsSize.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
                           LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                ON ObjectLink_Goods_ProdColor.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                           LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Engine
                                                ON ObjectLink_Goods_Engine.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_Engine.DescId = zc_ObjectLink_Goods_Engine()
                           LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Goods_Engine.ChildObjectId
                      )
     --������� �������
   , tmpRemains AS (SELECT Container.ObjectId
                         , SUM (COALESCE(Container.Amount,0)) AS Amount
                    FROM Container
                    WHERE Container.DescId = zc_Container_Count()
                      AND Container.Amount <> 0
                      AND Container.ObjectId IN (SELECT DISTINCT tmpGoodsParams.ObjectId FROM tmpGoodsParams)
                      AND (Container.ObjectId = inObjectId OR inObjectId = 0)
                    GROUP BY Container.ObjectId
                    HAVING SUM (COALESCE(Container.Amount,0)) <> 0
                   )
  , tmpGroupDetail1 AS (SELECT tmp.ObjectId
                             , tmp.MonthBegin
                             , SUM (COALESCE (tmp.Amount,0)) AS Amount
                        FROM tmpItem_Detail AS tmp
                        GROUP BY tmp.ObjectId
                               , tmp.MonthBegin
                       )

  , tmpGroupDetail2 AS (SELECT t1.ObjectId, t1.MonthBegin, SUM (t2.Amount) AS AmountTotal
                        FROM tmpGroupDetail1 As t1
                             LEFT JOIN tmpGroupDetail1 AS t2
                                                       ON t2.ObjectId = t1.ObjectId
                                                      AND t2.MonthBegin <= t1.MonthBegin
                        GROUP BY t1.ObjectId, t1.MonthBegin, t1.Amount
                       )
  , tmpRemainsMonth AS (SELECT DISTINCT tmpGroupDetail2.ObjectId
                             , MAX (tmpGroupDetail2.MonthBegin) OVER (PARTITION BY tmpGroupDetail2.ObjectId )  AS MonthBegin
                             , MAX (tmpGroupDetail2.AmountTotal) OVER (PARTITION BY tmpGroupDetail2.ObjectId ) AS AmountTotal
                        from tmpGroupDetail2
                            LEFT JOIN  tmpRemains ON tmpRemains.ObjectId = tmpGroupDetail2.ObjectId
                        WHERE COALESCE (tmpRemains.Amount,0) - COALESCE (tmpGroupDetail2.AmountTotal,0)>= 0
                       )
      -- ���������
      SELECT COALESCE (tmp.MovementId, tmpMovement.Id) ::Integer
           , zfConvert_StringToNumber (COALESCE (tmp.InvNumber, tmpMovement.InvNumber))  ::Integer
           , COALESCE (tmp.OperDate, tmpMovement.OperDate)    ::TDateTime
           , Object_Product.Id                   AS ProductId
           , Object_Product.ValueData ::TVarChar AS ProductName
           , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) ::TVarChar AS CIN
           , tmpGoodsParams.ObjectId
           , tmpGoodsParams.ObjectCode
           , tmpGoodsParams.ObjectName  ::TVarChar
           , tmpGoodsParams.Article     ::TVarChar
           , zfCalc_Article_all (tmpGoodsParams.Article) ::TVarChar AS Article_all
           , tmpGoodsParams.GoodsGroupName        ::TVarChar
           , tmpGoodsParams.GoodsGroupNameFull    ::TVarChar
           , tmpGoodsParams.MeasureName           ::TVarChar
           , tmpGoodsParams.ProdColorName         ::TVarChar

           , Object_Goods_basis.ValueData         ::TVarChar AS GoodsName_basis
           , Object_Goods.ObjectCode              ::Integer  AS GoodsCode
           , Object_Goods.ValueData               ::TVarChar AS GoodsName
           , ObjectString_Article_Goods.ValueData       ::TVarChar AS Article_goods
           , Object_ReceiptLevel.ValueData        ::TVarChar AS ReceiptLevelName
           , ObjectString_Goods_Comment.ValueData ::TVarChar AS Comment_goods
           , ObjectString_Object_Comment.ValueData ::TVarChar AS Comment_Object

           , CASE WHEN COALESCE (tmpRemains.Amount,0) - COALESCE (tmp.Amount) > 0 AND inIsDetail = FALSE THEN 12
                  WHEN COALESCE (tmpRemains.Amount,0) - COALESCE (tmpRemainsMonth.AmountTotal) > 0 AND inIsDetail = True THEN 12
                 ELSE tmpRemainsMonth.MonthBegin END :: Integer AS MonthRemains

           , CASE WHEN COALESCE (tmpRemains.Amount,0) - COALESCE (tmp.Amount) < 0 AND inIsDetail = FALSE THEN zc_Color_Pink()
                 ELSE zc_Color_White()
             END :: Integer AS ColorText

           , tmpRemains.Amount               ::TFloat   AS Remains
           , tmpSend_ProductionUnion.Amount  ::TFloat   AS AmountIn
           , tmpSend_ProductionUnion.Comment ::TVarChar AS Comment_mov

           , tmp.Amount    :: TFloat
           , tmp.Amount1   :: TFloat
           , tmp.Amount2   :: TFloat
           , tmp.Amount3   :: TFloat
           , tmp.Amount4   :: TFloat
           , tmp.Amount5   :: TFloat
           , tmp.Amount6   :: TFloat
           , tmp.Amount7   :: TFloat
           , tmp.Amount8   :: TFloat
           , tmp.Amount9   :: TFloat
           , tmp.Amount10  :: TFloat
           , tmp.Amount11  :: TFloat
           , tmp.Amount12  :: TFloat

           , zfCalc_MonthName (inStartDate)                      ::TVarChar AS MonthName1
           , zfCalc_MonthName (inStartDate+ INTERVAL '1 MONTH')  ::TVarChar AS MonthName2
           , zfCalc_MonthName (inStartDate+ INTERVAL '2 MONTH')  ::TVarChar AS MonthName3
           , zfCalc_MonthName (inStartDate+ INTERVAL '3 MONTH')  ::TVarChar AS MonthName4
           , zfCalc_MonthName (inStartDate+ INTERVAL '4 MONTH')  ::TVarChar AS MonthName5
           , zfCalc_MonthName (inStartDate+ INTERVAL '5 MONTH')  ::TVarChar AS MonthName6
           , zfCalc_MonthName (inStartDate+ INTERVAL '6 MONTH')  ::TVarChar AS MonthName7
           , zfCalc_MonthName (inStartDate+ INTERVAL '7 MONTH')  ::TVarChar AS MonthName8
           , zfCalc_MonthName (inStartDate+ INTERVAL '8 MONTH')  ::TVarChar AS MonthName9
           , zfCalc_MonthName (inStartDate+ INTERVAL '9 MONTH')  ::TVarChar AS MonthName10
           , zfCalc_MonthName (inStartDate+ INTERVAL '10 MONTH') ::TVarChar AS MonthName11
           , zfCalc_MonthName (inStartDate+ INTERVAL '11 MONTH') ::TVarChar AS MonthName12

      FROM tmpMI_group AS tmp
           FULL JOIN tmpSend_ProductionUnion ON tmpSend_ProductionUnion.MovementId_OrderClient = tmp.MovementId
                                            AND tmpSend_ProductionUnion.ObjectId = tmp.ObjectId
                                            AND tmp.Ord2 = 1

           LEFT JOIN tmpMovement ON tmpMovement.Id = tmpSend_ProductionUnion.MovementId_OrderClient AND inIsDetail = TRUE

           LEFT JOIN tmpGoodsParams ON tmpGoodsParams.ObjectId = COALESCE (tmp.ObjectId, tmpSend_ProductionUnion.ObjectId)
           LEFT JOIN Object AS Object_Product ON Object_Product.Id = COALESCE (tmp.ProductId, tmpMovement.ProductId)
           LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = tmp.GoodsId_basis
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
           LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = tmp.ReceiptLevelId

           LEFT JOIN ObjectString AS ObjectString_CIN
                                  ON ObjectString_CIN.ObjectId = Object_Product.Id
                                 AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

           LEFT JOIN ObjectString AS ObjectString_Object_Comment
                                  ON ObjectString_Object_Comment.ObjectId = COALESCE (tmp.ObjectId, tmpSend_ProductionUnion.ObjectId)
                                 AND ObjectString_Object_Comment.DescId   = zc_ObjectString_Goods_Comment()

           LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                  ON ObjectString_Goods_Comment.ObjectId = tmp.GoodsId
                                 AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()

           LEFT JOIN ObjectString AS ObjectString_Article_Goods
                                  ON ObjectString_Article_Goods.ObjectId = tmp.GoodsId
                                 AND ObjectString_Article_Goods.DescId = zc_ObjectString_Article()

           LEFT JOIN tmpRemains ON (tmpRemains.ObjectId = tmp.ObjectId AND tmp.Ord = 1 AND inIsDetail = TRUE) OR (tmpRemains.ObjectId = tmp.ObjectId AND inIsDetail = FALSE)
           LEFT JOIN tmpRemainsMonth ON (tmpRemainsMonth.ObjectId = tmp.ObjectId AND tmp.Ord = 1 AND inIsDetail = TRUE) OR (tmpRemainsMonth.ObjectId = tmp.ObjectId AND inIsDetail = FALSE)

     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.05.23         *
*/

-- ����
-- SELECT * FROM gpReport_OrderClient_byBoat(inStartDate := ('01.01.2020')::TDateTime , inEndDate := ('03.05.2023')::TDateTime , inObjectId := 0, inIsDetail := False ,inSession := '5');
-- SELECT * FROM gpReport_OrderClient_byBoat(inStartDate := ('01.01.2020')::TDateTime , inEndDate := ('03.05.2023')::TDateTime , inMovementId_OrderClient:=0 , inObjectId := 252790, inIsDetail := true, inIsOnlyChild:= FALSE ,inSession := '5')
-- SELECT * FROM gpReport_OrderClient_byBoat(inStartDate := ('01.01.2023')::TDateTime , inEndDate := ('31.12.2023')::TDateTime , inMovementId_OrderClient := 706 , inObjectId := 0 , inIsDetail := 'True' , inIsOnlyChild := 'False' ,  inSession := '5');
