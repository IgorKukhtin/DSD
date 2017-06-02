	-- Function: gpSelect_MI_OrderIncomeSnab()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderIncomeSnab (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderIncomeSnab(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer
             , GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsName_Partner TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , Price          TFloat
             , AmountSumm     TFloat
             , Amount         TFloat
             , AmountRemains  TFloat
             , AmountRemainsEnd   TFloat
             , BalanceStart TFloat
             , BalanceEnd   TFloat
             , AmountIncome   TFloat
             , AmountForecast TFloat
             , AmountIn       TFloat
             , AmountOut      TFloat
             , AmountOrder    TFloat
             , CountOnDay     TFloat
             , RemainsDays    TFloat
             , PlanOrder      TFloat
             , RemainsDaysWithOrder TFloat
             , CountDays      Integer
             , ReserveDays    Integer
             , Color_RemainsDays Integer

             , Comment        TVarChar
             , isClose        Boolean
             , isErased       Boolean
              )
AS
$BODY$
   DECLARE vbUserId           Integer;
   DECLARE Cursor1            refcursor;

   DECLARE vbJuridicalId_From Integer;
   DECLARE vbCountDays        Integer; -- период ПРОГНОЗА = 4 недели
   DECLARE vbReserveDays      Integer; -- на сколько дней считаем План. Заказ на месяц
   DECLARE vbEndDate          TDateTime;
   DECLARE vbStartDate        TDateTime;

   DECLARE vbGoodsPropertyId       Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderIncome());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяем поставщика из документа
     vbJuridicalId_From := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Juridical());

     -- определяем из документа
     SELECT  COALESCE (MovementDate_OperDateStart.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate))  AS StartDate
           , COALESCE (MovementDate_OperDateEnd.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') AS vbEndDate
           , COALESCE (MovementFloat_DayCount.ValueData, 30) :: Integer AS ReserveDays
           , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
           , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)       AS GoodsPropertyId_basis
             INTO vbStartDate, vbEndDate, vbReserveDays, vbGoodsPropertyId, vbGoodsPropertyId_basis
     FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
            LEFT JOIN MovementFloat AS MovementFloat_DayCount
                                    ON MovementFloat_DayCount.MovementId = Movement.Id
                                   AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     WHERE Movement.Id     = inMovementId
       AND Movement.DescId = zc_Movement_OrderIncome();


     -- период ПРОГНОЗА = 4 недели
     vbCountDays := (SELECT DATE_PART('DAY', (vbEndDate - vbStartDate )) + 1);



     IF inShowAll THEN

     RETURN QUERY
     WITH tmpObject_GoodsPropertyValue AS
                 (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                       , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId  AS GoodsId
                       , Object_GoodsPropertyValue.ValueData                AS Name
                  FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                        ) AS tmpGoodsProperty
                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                               ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                              AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                       LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                              ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                             AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                  )
     , tmpObject_GoodsPropertyValue_basis AS
                  (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                        , Object_GoodsPropertyValue.ValueData  AS Name
                   FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
                         ) AS tmpGoodsProperty
                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                               ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                              AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                       INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                              ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                             AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                   )

  ,  tmpGoodsListIncome AS (SELECT DISTINCT ObjectLink_GoodsListIncome_Goods.ChildObjectId AS GoodsId
                            FROM Object AS Object_GoodsListIncome
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Juridical
                                         ON ObjectLink_GoodsListIncome_Juridical.ObjectId = Object_GoodsListIncome.Id
                                        AND ObjectLink_GoodsListIncome_Juridical.DescId = zc_ObjectLink_GoodsListIncome_Juridical()
                                        AND ObjectLink_GoodsListIncome_Juridical.ChildObjectId = vbJuridicalId_From
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                         ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                                        AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
                            WHERE Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome()
                              AND Object_GoodsListIncome.isErased =False
                           )

           , tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                  , MovementItem.ObjectId                         AS MeasureId
                                  , MILinkObject_Goods.ObjectId                   AS GoodsId
                                  , COALESCE(MIFloat_Price.ValueData,0) :: TFloat AS Price
                                  , MovementItem.Amount                           AS Amount
                                  , MIString_Comment.ValueData                    AS Comment
                                  , MovementItem.isErased
                                  , COALESCE (MIFloat_AmountRemains.ValueData, 0)         AS AmountRemains
                                  , COALESCE (MIFloat_AmountRemains.ValueData, 0) + COALESCE (MIFloat_AmountIncome.ValueData, 0) + COALESCE (MIFloat_AmountIn.ValueData, 0)
                                  - COALESCE (MIFloat_AmountForecast.ValueData, 0) - COALESCE (MIFloat_AmountOut.ValueData, 0)  AS AmountRemainsEnd
                                  , COALESCE (MIFloat_AmountIncome.ValueData, 0)          AS AmountIncome
                                  , COALESCE (MIFloat_AmountForecast.ValueData, 0)        AS AmountForecast
                                  , COALESCE (MIFloat_AmountIn.ValueData, 0)              AS AmountIn
                                  , COALESCE (MIFloat_AmountOut.ValueData, 0)             AS AmountOut
                                  , COALESCE (MIFloat_AmountOrder.ValueData, 0)           AS AmountOrder
                                  , COALESCE (MIFloat_BalanceStart.ValueData, 0)          AS BalanceStart
                                  , COALESCE (MIFloat_BalanceEnd.ValueData, 0)            AS BalanceEnd
                                  , COALESCE (MIBoolean_Close.ValueData, False)           AS isClose
                             FROM (SELECT false AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                         ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                         ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountRemains.DescId = zc_MIFloat_Remains()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountIncome
                                         ON MIFloat_AmountIncome.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountIncome.DescId = zc_MIFloat_Income()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                         ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountIn
                                         ON MIFloat_AmountIn.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                         ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                         ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()

                                  LEFT JOIN MovementItemFloat AS MIFloat_BalanceStart
                                         ON MIFloat_BalanceStart.MovementItemId = MovementItem.Id
                                        AND MIFloat_BalanceStart.DescId = zc_MIFloat_BalanceStart()
                                  LEFT JOIN MovementItemFloat AS MIFloat_BalanceEnd
                                         ON MIFloat_BalanceEnd.MovementItemId = MovementItem.Id
                                        AND MIFloat_BalanceEnd.DescId = zc_MIFloat_BalanceEnd()

                                  LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                         ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                        AND MIBoolean_Close.DescId = zc_MIBoolean_Close()
                            )

        SELECT 0                          AS Id
             , 0                          AS LineNum
             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , Object_Goods.Id            AS GoodsId
             , Object_Goods.ObjectCode    AS GoodsCode
             , Object_Goods.ValueData     AS GoodsName
          , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name
                   WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                   ELSE ''
              END) :: TVarChar AS GoodsName_Partner
             , Object_Measure.Id          AS MeasureId
             , Object_Measure.ValueData   AS MeasureName
             , CAST (NULL AS TFloat)      AS Price
             , CAST (NULL AS TFloat)      AS AmountSumm
             , CAST (NULL AS TFloat)      AS Amount
             , CAST (NULL AS TFloat)      AS AmountRemains
             , CAST (NULL AS TFloat)      AS AmountRemainsEnd
             , CAST (NULL AS TFloat)      AS BalanceStart
             , CAST (NULL AS TFloat)      AS BalanceEnd
             , CAST (NULL AS TFloat)      AS AmountIncome
             , CAST (NULL AS TFloat)      AS AmountForecast
             , CAST (NULL AS TFloat)      AS AmountIn
             , CAST (NULL AS TFloat)      AS AmountOut
             , CAST (NULL AS TFloat)      AS AmountOrder

             , CAST (NULL AS TFloat)      AS CountOnDay
             , CAST (NULL AS TFloat)      AS RemainsDays
             , CAST (NULL AS TFloat)      AS PlanOrder
             , CAST (NULL AS TFloat)      AS RemainsDaysWithOrder

               -- период ПРОГНОЗА = 4 недели
             , vbCountDays
               -- на сколько дней считаем План. Заказ на месяц
             , vbReserveDays

             , zc_Color_Black() :: Integer AS Color_RemainsDays

             , CAST (NULL AS TVarChar)    AS Comment
             , FALSE                      AS isClose
             , FALSE                      AS isErased
        FROM tmpGoodsListIncome AS tmpGoods
             LEFT JOIN tmpMI_Goods AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()


            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = Object_Goods.Id
                                                  AND tmpObject_GoodsPropertyValue.Name <> ''
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = Object_Goods.Id

        WHERE tmpMI.GoodsId IS NULL

      UNION ALL
        SELECT tmpMI.MovementItemId    AS Id
             , (ROW_NUMBER() OVER (ORDER BY tmpMI.MovementItemId))::Integer AS LineNum
             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , tmpMI.GoodsId
             , Object_Goods.ObjectCode    AS GoodsCode
             , Object_Goods.ValueData     AS GoodsName
          , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name
                   WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                   ELSE ''
              END) :: TVarChar AS GoodsName_Partner

             , Object_Measure.Id          AS MeasureId
             , Object_Measure.ValueData   AS MeasureName
             , tmpMI.Price          ::TFloat
             , (tmpMI.Price * tmpMI.Amount)  ::TFloat AS AmountSumm
             , tmpMI.Amount
             , tmpMI.AmountRemains  ::TFloat
             , tmpMI.AmountRemainsEnd ::TFloat
             , tmpMI.BalanceStart   ::TFloat
             , tmpMI.BalanceEnd     ::TFloat
             , tmpMI.AmountIncome   ::TFloat
             , tmpMI.AmountForecast ::TFloat
             , tmpMI.AmountIn       ::TFloat
             , tmpMI.AmountOut      ::TFloat

               -- Заказ в пути
             , (COALESCE (tmpMI.AmountOrder,0) + COALESCE (tmpMI.Amount,0))  ::TFloat AS AmountOrder

               -- Заказ в пути
             , (CASE WHEN vbCountDays <> 0 THEN tmpMI.AmountForecast/vbCountDays ELSE 0 END)  :: TFloat AS CountOnDay

               -- Средний расход в день
             , CASE WHEN tmpMI.AmountForecast <=0 AND tmpMI.AmountRemainsEnd <> 0 THEN 365
                    WHEN tmpMI.AmountRemainsEnd <> 0 AND (tmpMI.AmountForecast/vbCountDays) <> 0
                    THEN tmpMI.AmountRemainsEnd / (tmpMI.AmountForecast/vbCountDays)
                    ELSE 0
               END :: TFloat AS RemainsDays

               -- План. Заказ на месяц
             , CASE WHEN tmpMI.AmountForecast > 0 AND tmpMI.AmountRemainsEnd <> 0
                     AND tmpMI.AmountRemainsEnd <> 0 AND tmpMI.AmountRemainsEnd < (tmpMI.AmountForecast/vbCountDays) * vbReserveDays
                    THEN (tmpMI.AmountForecast/vbCountDays) * vbReserveDays - tmpMI.AmountRemainsEnd
                    ELSE 0
               END :: TFloat AS PlanOrder

               -- Кол-во дней остатка с учетом заказа
             , CASE WHEN tmpMI.AmountForecast <= 0 AND tmpMI.AmountRemainsEnd <> 0
                    THEN 365
                    WHEN (tmpMI.AmountForecast/vbCountDays) <> 0
                    THEN (COALESCE(tmpMI.AmountRemainsEnd,0) + COALESCE(tmpMI.AmountIncome,0) + COALESCE (tmpMI.Amount,0))/ (tmpMI.AmountForecast/vbCountDays)
                    ELSE 0
               END  :: TFloat AS RemainsDaysWithOrder

               -- период ПРОГНОЗА = 4 недели
             , vbCountDays
               -- на сколько дней считаем План. Заказ на месяц
             , vbReserveDays
  
  
             , CASE WHEN COALESCE (tmpMI.AmountOrder,0) > 0 OR tmpMI.Amount > 0 THEN 25088  -- зеленый
                    ELSE
                    CASE WHEN tmpMI.AmountForecast <= 0 AND tmpMI.AmountRemainsEnd <> 0
                              THEN zc_Color_Black()
                         WHEN COALESCE (tmpMI.AmountForecast, 0) <= 0 AND COALESCE (tmpMI.AmountRemainsEnd, 0) = 0
                              THEN zc_Color_Black()
                         WHEN 29.9 < (CASE WHEN tmpMI.AmountRemainsEnd <> 0 AND (tmpMI.AmountForecast/vbCountDays) <> 0
                                                THEN COALESCE(tmpMI.AmountRemainsEnd,0) / (tmpMI.AmountForecast/vbCountDays)
                                           ELSE 0
                                      END)
                              THEN zc_Color_Black()
                         ELSE zc_Color_Red()
                    END
               END :: Integer AS Color_RemainsDays

             , tmpMI.Comment
             , tmpMI.isClose
             , tmpMI.isErased
             
        FROM tmpMI_Goods AS tmpMI
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpMI.MeasureId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()


            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.Name <> ''
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
;

     ELSE

     RETURN QUERY
     WITH tmpObject_GoodsPropertyValue AS
                 (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                       , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId  AS GoodsId
                       , Object_GoodsPropertyValue.ValueData                AS Name
                  FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                        ) AS tmpGoodsProperty
                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                               ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                              AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                       LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                              ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                             AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                  )
     , tmpObject_GoodsPropertyValue_basis AS
                  (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                        , Object_GoodsPropertyValue.ValueData  AS Name
                   FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
                         ) AS tmpGoodsProperty
                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                               ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                              AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                       INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                              ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                             AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                   )

  ,          tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                  , MovementItem.ObjectId                         AS MeasureId
                                  , MILinkObject_Goods.ObjectId                   AS GoodsId
                                  , MovementItem.Amount                           AS Amount
                                  , COALESCE(MIFloat_Price.ValueData,0) :: TFloat AS Price
                                  , MIString_Comment.ValueData                    AS Comment
                                  , MovementItem.isErased
                                  , COALESCE (MIFloat_AmountRemains.ValueData, 0)         AS AmountRemains
                                  , COALESCE (MIFloat_AmountRemains.ValueData, 0) + COALESCE (MIFloat_AmountIncome.ValueData, 0) + COALESCE (MIFloat_AmountIn.ValueData, 0)
                                  - COALESCE (MIFloat_AmountForecast.ValueData, 0) - COALESCE (MIFloat_AmountOut.ValueData, 0)  AS AmountRemainsEnd
                                  , COALESCE (MIFloat_AmountIncome.ValueData, 0)          AS AmountIncome
                                  , COALESCE (MIFloat_AmountForecast.ValueData, 0)        AS AmountForecast
                                  , COALESCE (MIFloat_AmountIn.ValueData, 0)              AS AmountIn
                                  , COALESCE (MIFloat_AmountOut.ValueData, 0)             AS AmountOut
                                  , COALESCE (MIFloat_AmountOrder.ValueData, 0)           AS AmountOrder
                                  , COALESCE (MIFloat_BalanceStart.ValueData, 0)          AS BalanceStart
                                  , COALESCE (MIFloat_BalanceEnd.ValueData, 0)            AS BalanceEnd
                                  , COALESCE (MIBoolean_Close.ValueData, False)           AS isClose
                             FROM (SELECT false AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

                                  LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                         ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountRemains.DescId = zc_MIFloat_Remains()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountIncome
                                         ON MIFloat_AmountIncome.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountIncome.DescId = zc_MIFloat_Income()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                         ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountIn
                                         ON MIFloat_AmountIn.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                         ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                         ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()

                                  LEFT JOIN MovementItemFloat AS MIFloat_BalanceStart
                                         ON MIFloat_BalanceStart.MovementItemId = MovementItem.Id
                                        AND MIFloat_BalanceStart.DescId = zc_MIFloat_BalanceStart()
                                  LEFT JOIN MovementItemFloat AS MIFloat_BalanceEnd
                                         ON MIFloat_BalanceEnd.MovementItemId = MovementItem.Id
                                        AND MIFloat_BalanceEnd.DescId = zc_MIFloat_BalanceEnd()

                                  LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                         ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                        AND MIBoolean_Close.DescId = zc_MIBoolean_Close()
                            )
        -- Результат
        SELECT tmpMI.MovementItemId       AS Id
             , (ROW_NUMBER() OVER (ORDER BY tmpMI.MovementItemId))::Integer AS LineNum
             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , tmpMI.GoodsId
             , Object_Goods.ObjectCode    AS GoodsCode
             , Object_Goods.ValueData     AS GoodsName
          , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name
                   WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                   ELSE ''
              END) :: TVarChar AS GoodsName_Partner

             , Object_Measure.Id          AS MeasureId
             , Object_Measure.ValueData   AS MeasureName
             , tmpMI.Price            ::TFloat
             , (tmpMI.Price * tmpMI.Amount)  ::TFloat AS AmountSumm
             , tmpMI.Amount
             , tmpMI.AmountRemains    ::TFloat
             , tmpMI.AmountRemainsEnd ::TFloat
             , tmpMI.BalanceStart     ::TFloat
             , tmpMI.BalanceEnd       ::TFloat
             , tmpMI.AmountIncome     ::TFloat
             , tmpMI.AmountForecast   ::TFloat
             , tmpMI.AmountIn         ::TFloat
             , tmpMI.AmountOut        ::TFloat
             , (COALESCE (tmpMI.AmountOrder,0) + COALESCE (tmpMI.Amount,0))      ::TFloat   AS AmountOrder

             , (CASE WHEN vbCountDays <> 0 THEN tmpMI.AmountForecast/vbCountDays ELSE 0 END)  :: TFloat AS CountOnDay
             , CASE WHEN tmpMI.AmountForecast <=0 AND tmpMI.AmountRemainsEnd <> 0 THEN 365
                    WHEN tmpMI.AmountRemainsEnd <> 0 AND (tmpMI.AmountForecast/vbCountDays) <> 0
                    THEN COALESCE(tmpMI.AmountRemainsEnd,0) / (tmpMI.AmountForecast/vbCountDays)
                    ELSE 0
               END :: TFloat AS RemainsDays

             , CASE WHEN tmpMI.AmountForecast > 0 AND tmpMI.AmountRemainsEnd <> 0
                     AND tmpMI.AmountRemainsEnd <> 0 AND tmpMI.AmountRemainsEnd < (tmpMI.AmountForecast/vbCountDays) * vbReserveDays
                    THEN (tmpMI.AmountForecast/vbCountDays) * vbReserveDays - tmpMI.AmountRemainsEnd
                    ELSE 0
               END :: TFloat AS PlanOrder

             , CASE WHEN tmpMI.AmountForecast <= 0 AND tmpMI.AmountRemainsEnd <> 0
                    THEN 365
                    WHEN (tmpMI.AmountForecast/vbCountDays) <> 0
                    THEN (COALESCE(tmpMI.AmountRemainsEnd,0) + COALESCE(tmpMI.AmountOrder,0) + COALESCE (tmpMI.Amount,0))/ (tmpMI.AmountForecast/vbCountDays)
                    ELSE 0
               END  :: TFloat AS RemainsDaysWithOrder

               -- период ПРОГНОЗА = 4 недели
             , vbCountDays
               -- на сколько дней считаем План. Заказ на месяц
             , vbReserveDays

             , CASE WHEN COALESCE(tmpMI.AmountOrder,0) > 0 THEN 25088  -- зеленый
                    ELSE
                    CASE WHEN tmpMI.AmountForecast <= 0 AND tmpMI.AmountRemainsEnd <> 0
                         THEN zc_Color_Black()
                         WHEN COALESCE (tmpMI.AmountForecast, 0) <= 0 AND COALESCE (tmpMI.AmountRemainsEnd, 0) = 0
                         THEN zc_Color_Black()
                         WHEN (CASE WHEN tmpMI.AmountRemainsEnd <> 0 AND (tmpMI.AmountForecast/vbCountDays) <> 0
                               THEN COALESCE(tmpMI.AmountRemainsEnd,0) / (tmpMI.AmountForecast/vbCountDays)
                               ELSE 0 END) > (vbReserveDays - 0.1)
                         THEN zc_Color_Black()
                         ELSE zc_Color_Red()
                    END
                END :: Integer AS Color_RemainsDays

             , tmpMI.Comment
             , tmpMI.isClose
             , tmpMI.isErased
        FROM tmpMI_Goods AS tmpMI
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpMI.MeasureId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.Name <> ''
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
        ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.17         *
 16.05.17         *
 03.05.17         *
 14.04.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderIncomeSnab (0, FALSE, FALSE, zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_MI_OrderIncomeSnab (inMovementId:= 5812842, inShowAll:= 'False', inIsErased:= 'False', inSession:= '5');
