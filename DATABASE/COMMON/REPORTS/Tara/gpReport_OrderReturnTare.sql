-- Function: gpReport_OrderReturnTare()

DROP FUNCTION IF EXISTS gpReport_OrderReturnTare (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderReturnTare(
    IN inStartDate      TDateTime, -- дата начала периода
    IN inEndDate        TDateTime, -- дата окончания периода
    IN inisDetail       Boolean  , --
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE(MovementId Integer, OperDate TDateTime, InvNumber TVarChar, MovementDescName TVarChar  --путевой
            , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
            , GoodsId            Integer   -- ИД товара
            , GoodsCode          Integer   -- Код Товара
            , GoodsName          TVarChar  -- Товар
            , GoodsGroupName     TVarChar  -- Наименование группы товара
            , GoodsGroupNameFull TVarChar
            , Amount_sale   TFloat
            , Amount_order  TFloat
            , Amount_return TFloat
            , Amount_fact   TFloat
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
    
    WITH
         -- оборотная тара
         tmpGoods AS (WITH
                       tmpInfoMoneyDestination_20500 AS (SELECT Object_InfoMoney_View.*
                                                         FROM Object_InfoMoney_View
                                                         WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500()
                                                         )
                      SELECT ObjectLink.ObjectId AS GoodsId
                      FROM ObjectLink
                      WHERE ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney()
                        AND ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpInfoMoneyDestination_20500.InfoMoneyId FROM tmpInfoMoneyDestination_20500)
                     )
      -- данные продаж из реестра         
    , tmpSale AS(WITH
                 -- документы реестра
                 tmpMovementReestr AS (SELECT Movement.*
                                       FROM Movement
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId = zc_Movement_Reestr()
                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                      )
                 -- строчная часть реестра
               , tmpMI_Reestr AS (SELECT MovementItem.*
                                  FROM tmpMovementReestr AS Movement
                                       LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                 )
                 -- док продаж
               , tmpMF AS (SELECT MovementFloat.ValueData  :: Integer AS MovementItemId_reestr
                                , MovementFloat.MovementId            AS MovementId_Sale
                           FROM MovementFloat
                           WHERE MovementFloat.DescId = zc_MovementFloat_MovementItemId()
                             AND MovementFloat.ValueData IN (SELECT DISTINCT tmpMI_Reestr.Id :: TFloat FROM tmpMI_Reestr)
                          )
               , tmpMI_MovementItemId AS (SELECT DISTINCT
                                                 MovementFloat_MovementItemId.MovementId_Sale
                                               , MovementFloat_MovementItemId.MovementItemId_reestr
                                          FROM tmpMI_Reestr
                                               INNER JOIN tmpMF AS MovementFloat_MovementItemId
                                                                ON MovementFloat_MovementItemId.MovementItemId_reestr = tmpMI_Reestr.Id
                                         )
                 -- строки док. продаж только оборотной тары
               , tmpMI_Sale AS (SELECT MovementItem.*
                                FROM tmpGoods
                                     INNER JOIN MovementItem ON tmpGoods.GoodsId = MovementItem.ObjectId
                                                            AND MovementItem.MovementId IN (SELECT DISTINCT tmpMI_MovementItemId.MovementId_Sale FROM tmpMI_MovementItemId)
                                                            AND MovementItem.DescId = zc_MI_Master()
                                                            AND MovementItem.isErased = FALSE
                                     INNER JOIN Movement ON Movement.Id     = MovementItem.MovementId
                                                        AND Movement.DescId = zc_Movement_Sale()
                               )
                 -- собираем все данные продаж из реестра
                 SELECT COALESCE (MovementLinkMovement_Transport.MovementChildId, tmpMI_Reestr.MovementId) AS MovementId_Transport
                      , MovementLinkObject_To.ObjectId AS PartnerId 
                      , tmpMI_Sale.ObjectId            AS GoodsId
                      , SUM (tmpMI_Sale.Amount)        AS Amount
                 FROM tmpMI_Reestr
                      INNER JOIN tmpMI_MovementItemId ON tmpMI_MovementItemId.MovementItemId_reestr = tmpMI_Reestr.Id
                      INNER JOIN tmpMI_Sale ON tmpMI_Sale.MovementId = tmpMI_MovementItemId.MovementId_Sale
                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                     ON MovementLinkMovement_Transport.MovementId = tmpMI_Reestr.MovementId
                                                    AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport() 
  
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = tmpMI_MovementItemId.MovementId_Sale
                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                 GROUP BY COALESCE (MovementLinkMovement_Transport.MovementChildId, tmpMI_Reestr.MovementId)
                        , MovementLinkObject_To.ObjectId
                        , tmpMI_Sale.ObjectId
                )
      -- данные заявок на возврат
    , tmpOrderReturnTare AS (WITH -- находим сколько заявок сформировано
                                  tmpMovementOrderReturnTare AS (SELECT Movement.*
                                                                 FROM Movement
                                                                 WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                                   AND Movement.DescId = zc_Movement_OrderReturnTare()
                                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                 )
                                  -- путевые
                                , tmpMovementLinkMovement AS (SELECT MovementLinkMovement.*
                                                              FROM MovementLinkMovement
                                                              WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport()
                                                                AND MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovementOrderReturnTare.Id FROM tmpMovementOrderReturnTare)
                                                              )
                                  -- строки заявок
                                , tmpMI AS (SELECT MovementItem.*
                                            FROM MovementItem
                                            WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementOrderReturnTare.Id FROM tmpMovementOrderReturnTare)
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = FALSE
                                           )
                                , tmpMILO_Partner AS (SELECT MovementItemLinkObject.*
                                                      FROM MovementItemLinkObject
                                                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                         AND MovementItemLinkObject.DescId = zc_MILinkObject_Partner()
                                                     )
                             -- собираем все данные заявок на возврат
                             SELECT tmpMI.MovementId            AS MovementId_order
                                  , MovementLinkMovement_Transport.MovementChildId AS MovementId_Transport
                                  , MILinkObject_Partner.ObjectId AS PartnerId
                                  , tmpMI.ObjectId         AS GoodsId
                                  , SUM (tmpMI.Amount)     AS Amount
                             FROM tmpMI
                                  LEFT JOIN tmpMovementLinkMovement AS MovementLinkMovement_Transport
                                                                    ON MovementLinkMovement_Transport.MovementId = tmpMI.MovementId  
                                  LEFT JOIN tmpMILO_Partner AS MILinkObject_Partner
                                                            ON MILinkObject_Partner.MovementItemId = tmpMI.Id 
                             GROUP BY MovementLinkMovement_Transport.MovementChildId
                                    , MILinkObject_Partner.ObjectId
                                    , tmpMI.ObjectId
							        , tmpMI.MovementId
                            )                  
      -- Данные из док. возврата 
    , tmpReturn AS (WITH
                    tmpMIReturnIn AS (SELECT MovementLinkMovement_OrderReturnTare.MovementChildId AS MovementId_order
                                             , MovementLinkMovement_OrderReturnTare.MovementId      AS MovementId_Return
                                             , MovementLinkObject_From.ObjectId AS PartnerId
                                             , MovementItem.ObjectId            AS GoodsId
                                             , SUM (MovementItem.Amount)        AS Amount
                                      FROM MovementLinkMovement AS MovementLinkMovement_OrderReturnTare  
                                           INNER JOIN Movement ON Movement.Id = MovementLinkMovement_OrderReturnTare.MovementId
                                                              AND Movement.DescId = zc_Movement_ReturnIn() 
                                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
           
                                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                  AND MovementItem.DescId = zc_MI_Master()
                                                                  AND MovementItem.isErased = FALSE
                                           INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
           
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
           
                                      WHERE MovementLinkMovement_OrderReturnTare.MovementChildId IN (SELECT DISTINCT tmpOrderReturnTare.MovementId_order FROM tmpOrderReturnTare)
                                        AND MovementLinkMovement_OrderReturnTare.DescId = zc_MovementLinkMovement_OrderReturnTare()
           
                                      GROUP BY MovementLinkMovement_OrderReturnTare.MovementChildId
                                             , MovementLinkMovement_OrderReturnTare.MovementId
                                             , MovementLinkObject_From.ObjectId
                                             , MovementItem.ObjectId
                                     ) 

                  , tmpMI_ReestrRet AS (SELECT DISTINCT MovementFloat_MovementItemId.MovementId AS MovementId_Return
                                             , MovementFloat_MovementItemId.ValueData ::integer AS MovementItemId_reestr
                                        FROM MovementFloat AS MovementFloat_MovementItemId
                                        WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                          AND MovementFloat_MovementItemId.MovementId IN (SELECT DISTINCT tmpMIReturnIn.MovementId_Return FROM tmpMIReturnIn)
                                        )

                    -- путевые
                  , tmpMLM_ret AS (SELECT MovementLinkMovement_Transport.MovementChildId AS MovementId_Transport
                                        , tmpMI_ReestrRet.MovementId_Return
                                   FROM tmpMI_ReestrRet
                                       INNER JOIN MovementItem ON MovementItem.Id = tmpMI_ReestrRet.MovementItemId_reestr
                                                              AND MovementItem.isErased = FALSE
                                       --путевой из реестра
                                       LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                                      ON MovementLinkMovement_Transport.MovementId = MovementItem.MovementId
                                                                     AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport() 
                                   WHERE MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                                     AND MovementLinkMovement_Transport.MovementId IN (SELECT DISTINCT tmpOrderReturnTare.MovementId_order FROM tmpOrderReturnTare)
                                   )
                    --собираем все данные по возвтратам
                    SELECT tmpMLM_ret.MovementId_Transport
                         , tmpMIReturnIn.PartnerId
                         , tmpMIReturnIn.GoodsId
                         , SUM (tmpMIReturnIn.Amount) AS Amount
                    FROM tmpMIReturnIn
                         LEFT JOIN tmpMLM_ret ON tmpMLM_ret.MovementId_Return = tmpMIReturnIn.MovementId_Return   
                    GROUP BY tmpMLM_ret.MovementId_Transport
                           , tmpMIReturnIn.PartnerId
                           , tmpMIReturnIn.GoodsId
                    )

     -- ФАКТ из док. возврата -- для информации итого возвраты тары
   , tmpReturn_fact AS (SELECT MovementItem.ObjectId            AS GoodsId
                             , MovementLinkObject_From.ObjectId AS PartnerId
                             , SUM (MovementItem.Amount)        AS Amount
                        FROM Movement  
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                             INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_ReturnIn()
                          AND inisDetail = FALSE 
                        GROUP BY MovementItem.ObjectId
                               , MovementLinkObject_From.ObjectId
                               , Movement.ParentId
                        )

     -- объединяем все 3 выборки ключ TransportId + PartnerId  + GoodsId  
   , tmpData AS (SELECT CASE WHEN inisDetail = TRUE THEN tmp.MovementId_Transport ELSE 0 END MovementId_Transport
                      , tmp.PartnerId
                      , tmp.GoodsId
                      , SUM (tmp.Amount_sale)   AS Amount_sale
                      , SUM (tmp.Amount_order)  AS Amount_order
                      , SUM (tmp.Amount_return) AS Amount_return
                      , SUM (tmp.Amount_fact)   AS Amount_fact
                 FROM (
                       SELECT tmp.MovementId_Transport
                            , tmp.PartnerId
                            , tmp.GoodsId
                            , tmp.Amount AS Amount_sale
                            , 0          AS Amount_order
                            , 0          AS Amount_return 
                            , 0          AS Amount_fact
                       FROM tmpSale AS tmp
                      UNION ALL
                       SELECT tmp.MovementId_Transport
                            , tmp.PartnerId
                            , tmp.GoodsId
                            , 0          AS Amount_sale
                            , tmp.Amount AS Amount_order
                            , 0          AS Amount_return
                            , 0          AS Amount_fact
                       FROM tmpOrderReturnTare AS tmp
                      UNION ALL
                       SELECT tmp.MovementId_Transport
                            , tmp.PartnerId
                            , tmp.GoodsId
                            , 0          AS Amount_sale
                            , 0          AS Amount_order
                            , tmp.Amount AS Amount_return
                            , 0          AS Amount_fact
                       FROM tmpReturn AS tmp       
                      UNION ALL
                       SELECT 0 AS MovementId_Transport
                            , tmp.PartnerId
                            , tmp.GoodsId
                            , 0          AS Amount_sale
                            , 0          AS Amount_order
                            , 0          AS Amount_return
                            , tmp.Amount AS Amount_fact
                       FROM tmpReturn_fact AS tmp

                       ) AS tmp
                 GROUP BY CASE WHEN inisDetail = TRUE THEN tmp.MovementId_Transport ELSE 0 END
                        , tmp.PartnerId
                        , tmp.GoodsId
                )                                          

           --
           SELECT Movement.Id                           AS MovementId
                , Movement.OperDate        ::TDateTime  AS OperDate
                , Movement.InvNumber       ::TVarChar   AS InvNumber
                , MovementDesc.ItemName    ::TVarChar   AS MovementDescName
                , Object_Partner.Id                     AS PartnerId
                , Object_Partner.ObjectCode             AS PartnerCode
                , Object_Partner.ValueData   ::TVarChar AS PartnerName

                , Object_Goods.Id              AS GoodsId         --ИД товара
                , Object_Goods.ObjectCode      AS GoodsCode       --Код Товара
                , Object_Goods.ValueData       AS GoodsName       --Товар
                , Object_GoodsGroup.ValueData  AS GoodsGroupName  --Наименование группы товара
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

                , tmpData.Amount_sale   ::TFloat AS Amount_sale
                , tmpData.Amount_order  ::TFloat AS Amount_order
                , tmpData.Amount_return ::TFloat AS Amount_return
                , tmpData.Amount_fact   ::TFloat AS Amount_fact
           FROM tmpData 
                LEFT JOIN Movement ON Movement.Id = tmpData.MovementId_Transport
                LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.22         *
 10.01.22         *
*/

-- тест
-- SELECT * FROM gpReport_OrderReturnTare (inStartDate := '01.04.2022'::TDatetime,inEndDate:='01.04.2022'::TDatetime, inisDetail:= false, inSession:='5'::TVarChar);
