-- Function: gpSelect_MI_PromoGoods_Detail()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoGoods_Detail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoGoods_Detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Id                  Integer --идентификатор 
      , ParentId            Integer --Главный элемент документа (товары)
      , MovementId          Integer --ИД документа <Акция>
      , GoodsId             Integer --ИД объекта <товар>
      , GoodsCode           Integer --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , MeasureName         TVarChar --Единица измерения
      , TradeMarkName       TVarChar --Торговая марка
      , GoodsWeight         TFloat -- вес товара
      , GoodsKindId            Integer --ИД обьекта <Вид товара>
      , GoodsKindName          TVarChar --Наименование обьекта <Вид товара>
      , GoodsKindCompleteId    Integer --ИД обьекта <Вид товара (примечание)>
      , GoodsKindCompleteName  TVarChar --Наименование обьекта <Вид товара(примечание)>
      , GoodsKindName_List     TVarChar --Наименование обьекта <Вид товара (справочно)>
      , Amount              TFloat -- Кол-во реализация (факт)
      , AmountIn            TFloat -- Кол-во возврат (факт)  
      , AmountWeight        TFloat
      , AmountInWeight      TFloat
      , AmountReal          TFloat -- Объем продаж в аналогичный период, кг (итого
      , AmountRetIn         TFloat -- Кол-во возврат в аналогичный период, кг
      , AmountRealWeight    TFloat -- Объем продаж в аналогичный период, кг (итого
      , AmountRetInWeight   TFloat -- Кол-во возврат в аналогичный период, кг
      , OperDate            TDateTime  -- месяц
      , DateStart_pr        TDateTime 
      , DateEnd_pr          TDateTime 
      , AmountDays          Integer
      , isErased            Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStartSale TDateTime;
    DECLARE vbEndSale TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    --из мастера
    CREATE TEMP TABLE _tmpPromoPartner (PartnerId Integer) ON COMMIT DROP;
    INSERT INTO _tmpPromoPartner (PartnerId)
            SELECT MI_PromoPartner.ObjectId        AS PartnerId   --ИД объекта <партнер>
            FROM Movement AS Movement_PromoPartner
                 INNER JOIN MovementItem AS MI_PromoPartner
                                         ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                        AND MI_PromoPartner.DescId = zc_MI_Master()
                                        AND MI_PromoPartner.IsErased = FALSE
            WHERE Movement_PromoPartner.ParentId = inMovementId
              AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner();

    CREATE TEMP TABLE _tmpGoodsKind_inf (GoodsId Integer, ValueData TVarChar) ON COMMIT DROP;
    INSERT INTO _tmpGoodsKind_inf (GoodsId, ValueData)
            SELECT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                 , STRING_AGG (DISTINCT ObjectString_GoodsKind.ValueData :: TVarChar, ',') AS ValueData
            FROM _tmpPromoPartner
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                      ON ObjectLink_GoodsListSale_Partner.ChildObjectId = _tmpPromoPartner.PartnerId
                                     AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()

                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                      ON ObjectLink_GoodsListSale_Goods.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                     AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                 INNER JOIN (SELECT MovementItem.ObjectId
                             FROM MovementItem
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.isErased = FALSE) AS MI_Master ON MI_Master.ObjectId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                 INNER JOIN ObjectString AS ObjectString_GoodsKind
                                         ON ObjectString_GoodsKind.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                        AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
                                        AND ObjectString_GoodsKind.ValueData <> ''
            GROUP BY ObjectLink_GoodsListSale_Goods.ChildObjectId;

    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList)
            SELECT DISTINCT _tmpGoodsKind_inf.ValueData AS WordList
            FROM _tmpGoodsKind_inf;

    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);


    RETURN QUERY
        WITH 
        tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, STRING_AGG (DISTINCT Object.ValueData :: TVarChar, ',')  AS GoodsKindName_list
                         FROM _tmpWord_Split_to
                              LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                         GROUP BY _tmpWord_Split_to.WordList
                         )
      , tmpGoodsKind_list AS (SELECT _tmpGoodsKind_inf.GoodsId
                                   , STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName_List :: TVarChar, ',')  AS GoodsKindName_List
                              FROM _tmpGoodsKind_inf
                                   LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = _tmpGoodsKind_inf.ValueData
                              GROUP BY _tmpGoodsKind_inf.GoodsId
                             )

      , tmpMI_Detail AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId = zc_MI_Detail()
                            AND MovementItem.isErased = FALSE
                         )

      , tmpMIFloat AS (SELECT MovementItemFloat.*
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                         AND MovementItemFloat.DescId IN (zc_MIFloat_AmountIn()
                                                        , zc_MIFloat_AmountReal()
                                                        , zc_MIFloat_AmountRetIn()
                                                        )
                       )
                             
      , tmpMIDate AS (SELECT MovementItemDate.*
                      FROM MovementItemDate
                      WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                        AND MovementItemDate.DescId IN (zc_MIDate_OperDate()
                                                       )
                      )

      , tmpDateList AS (WITH
                     tmpMov AS (SELECT MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала расч. продаж до акции
                                     , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания расч. продаж до акции
                                     , MovementDate_StartSale.ValueData            AS StartSale          --Дата начала отгрузки по акционной цене
                                     , MovementDate_EndSale.ValueData              AS EndSale            --Дата окончания отгрузки по акционной цене
                                     , EXTRACT (DAY from MovementDate_OperDateEnd.ValueData - MovementDate_OperDateStart.ValueData)  AS TotalDays_OperDate
                               FROM Movement     
                                    LEFT JOIN MovementDate AS MovementDate_StartSale
                                                           ON MovementDate_StartSale.MovementId = Movement.Id
                                                          AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                    LEFT JOIN MovementDate AS MovementDate_EndSale
                                                           ON MovementDate_EndSale.MovementId = Movement.Id
                                                          AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                    LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                                           ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                          AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                                    LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                                           ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                          AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

                               WHERE Movement.Id = inMovementId --29054915  --
                            )
                   , tmpDate_list AS (SELECT DATE_TRUNC ('MONTH', tmp.OperDate) AS Month_Period
                                           , SUM (tmp.Count) AS Days
                                           , ROW_NUMBER() OVER (ORDER BY DATE_TRUNC ('MONTH', tmp.OperDate)) AS Ord
                                      FROM (SELECT GENERATE_SERIES (tmpMov.StartSale, tmpMov.EndSale, '1 day' :: INTERVAL) AS OperDate, 1 AS Count
                                            FROM tmpMov
                                            ) AS tmp
                                      GROUP BY DATE_TRUNC ('MONTH', tmp.OperDate) 
                                      )
                   , tmpDate AS (SELECT t1.Month_Period
                                   , t1.Days
                                   , t1.Ord
                                   , SUM (COALESCE (t2.Days,0))  AS Days_total
                              FROM tmpDate_list AS t1
                                   LEFT JOIN tmpDate_list AS t2 ON t2.ord > t1.ord 
                              GROUP BY t1.Month_Period
                                     , t1.Days
                                     , t1.Ord
                              ORDER BY t1.ord
                              )
                    
                    SELECT tmpDate.Month_Period
                         , CASE WHEN tmpMov.TotalDays_OperDate - tmpDate.Days_total >= 0
                                THEN CASE WHEN tmpMov.OperDateStart < (tmpMov.OperDateEnd - (tmpDate.Days + tmpDate.Days_total ||'Day')::Interval + INTERVAL '1 Day' )::TDateTime AND tmpDate.Ord <> 1
                                          THEN tmpMov.OperDateEnd - (tmpDate.Days+tmpDate.Days_total ||'Day')::Interval + INTERVAL '1 Day'
                                          ELSE tmpMov.OperDateStart
                                     END
                                ELSE NULL
                           END AS DateStart_pr
                         , CASE WHEN tmpMov.TotalDays_OperDate - tmpDate.Days_total >= 0
                                THEN tmpMov.OperDateEnd - (tmpDate.Days_total ||'Day')::Interval
                                ELSE NULL
                           END  AS DateEnd_pr
                         --, tmpMov.TotalDays_OperDate -  tmpDate.Days_total
                    FROM tmpDate
                      LEFT JOIN tmpMov ON 1= 1
                    )


        SELECT MovementItem.Id                        AS Id                  --идентификатор 
             , MovementItem.ParentId                  AS ParentId            --
             , MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
             , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
             , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
             , Object_Measure.ValueData               AS Measure             --Единица измерения
             , Object_TradeMark.ValueData             AS TradeMark           --Торговая марка
             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- Вес  
             
             --информационно из мастера
             , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId                 --ИД обьекта <Вид товара>
             , Object_GoodsKind.ValueData             AS GoodsKindName               --Наименование обьекта <Вид товара>
             , Object_GoodsKindComplete.Id            AS GoodsKindCompleteId         --ИД Вид товара(Примечание)
             , Object_GoodsKindComplete.ValueData     AS GoodsKindCompleteName       --Наименование обьекта <Вид товара(Примечание)>
             , tmpGoodsKind_list.GoodsKindName_List ::TVarChar                       -- Наименование обьекта <Вид товара (справочно)>

             , MovementItem.Amount          ::TFloat     AS Amount
             , MIFloat_AmountIn.ValueData   ::TFloat     AS AmountIn
             , (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END)         ::TFloat AS AmountWeight
             , (MIFloat_AmountIn.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END)  ::TFloat AS AmountInWeight
             
             , MIFloat_AmountReal.ValueData ::TFloat     AS AmountReal
             , MIFloat_AmountRetIn.ValueData::TFloat     AS AmountRetIn
             , (MIFloat_AmountReal.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) ::TFloat     AS AmountRealWeight
             , (MIFloat_AmountRetIn.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END)::TFloat     AS AmountRetInWeight
             , MIDate_OperDate.ValueData    ::TDateTime  AS OperDate
             , tmpDateList.DateStart_pr     ::TDateTime
             , tmpDateList.DateEnd_pr       ::TDateTime
             , (EXTRACT (DAY from tmpDateList.DateEnd_pr - tmpDateList.DateStart_pr)+1) ::Integer AS AmountDays
             
             , MovementItem.isErased                     AS isErased
        FROM tmpMI_Detail AS MovementItem
             LEFT JOIN tmpMIFloat AS MIFloat_AmountIn
                                  ON MIFloat_AmountIn.MovementItemId = MovementItem.Id 
                                 AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
             LEFT JOIN tmpMIFloat AS MIFloat_AmountReal
                                  ON MIFloat_AmountReal.MovementItemId = MovementItem.Id 
                                 AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
             LEFT JOIN tmpMIFloat AS MIFloat_AmountRetIn
                                  ON MIFloat_AmountRetIn.MovementItemId = MovementItem.Id 
                                 AND MIFloat_AmountRetIn.DescId = zc_MIFloat_AmountRetIn()

             LEFT JOIN tmpMIDate AS MIDate_OperDate
                                 ON MIDate_OperDate.MovementItemId = MovementItem.Id 
                                AND MIDate_OperDate.DescId = zc_MIDate_OperDate() 

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                                             
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                              
             LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                         ON ObjectFloat_Goods_Weight.ObjectId = MovementItem.ObjectId
                                        AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.ParentId
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                              ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.ParentId
                                             AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId


             LEFT JOIN tmpDateList ON tmpDateList.Month_Period = MIDate_OperDate.ValueData
             
             LEFT JOIN tmpGoodsKind_list ON tmpGoodsKind_list.GoodsId = MovementItem.ObjectId

        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.24         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_PromoGoods_Detail (29423567, zfCalc_UserAdmin());
