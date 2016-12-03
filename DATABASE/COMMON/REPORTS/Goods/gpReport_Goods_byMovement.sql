-- FunctiON: gpReport_Goods_byMovement ()

DROP FUNCTION IF EXISTS gpReport_Goods_byMovement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Goods_byMovement (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inUnitId              Integer   , --
    IN inUnitGroupId         Integer   ,
    IN inGoodsGroupGPId      Integer   ,
    IN inGoodsGroupId        Integer   ,
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor  
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE vbCountDays TFloat;
BEGIN
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица - 
         CREATE TEMP TABLE _tmpGoods (GroupNum Integer, GoodsId Integer, MeasureId Integer, Weight TFloat, GoodsPlatformId Integer, TradeMarkId Integer, GoodsTagId Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpData (GroupNum Integer, GoodsId Integer,  SaleAmount TFloat, SaleAmountPartner TFloat, ReturnAmount TFloat, ReturnAmountPartner TFloat, SaleAmountDay TFloat, SaleAmountPartnerDay TFloat, ReturnAmountDay TFloat, ReturnAmountPartnerDay TFloat, GoodsPlatformId Integer, TradeMarkId Integer, GoodsTagId Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpDay  (GroupNum Integer, SaleAmount TFloat, SaleAmountPartner TFloat, ReturnAmount TFloat, ReturnAmountPartner TFloat) ON COMMIT DROP;
     END IF;
    
     vbCountDays := (SELECT EXTRACT (DAY  FROM (inEndDate - inStartDate)) +1 )   ::TFloat ;
     
     IF COALESCE (inUnitGroupId,0) <> 0 
     THEN
         INSERT INTO _tmpUnit (UnitId)
           SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect;
     END IF;


    -- Ограничения по товару ()
    IF inGoodsGroupGPId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GroupNum, GoodsId, MeasureId, Weight, GoodsPlatformId, TradeMarkId, GoodsTagId)
          WITH tmpGoods AS(
           SELECT 1 AS GroupNum, lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupGPId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          UNION
           SELECT 2, lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                           )
               SELECT tmpGoods.GroupNum
                    , tmpGoods.GoodsId
                    , tmpGoods.MeasureId
                    , tmpGoods.Weight
                    , ObjectLink_Goods_GoodsPlatform.ChildObjectId AS GoodsPlatformName
                    , ObjectLink_Goods_TradeMark.ChildObjectId     AS TradeMarkId
                    , ObjectLink_Goods_GoodsTag.ChildObjectId      AS GoodsTagId
               FROM tmpGoods
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                         ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmpGoods.GoodsId 
                                        AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                         ON ObjectLink_Goods_TradeMark.ObjectId = tmpGoods.GoodsId
                                        AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                         ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                        AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                    ;
    END IF;
    
    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpGoods;
    ANALYZE _tmpUnit;

   --INSERT INTO _tmpData (GroupNum, GoodsId, GoodsPlatformId, TradeMarkId, GoodsTagId, SaleAmount, SaleAmountPartner, ReturnAmount, ReturnAmountPartner)
    WITH
        tmpMovSale AS (SELECT zc_Movement_Sale() AS MovementDescId   -- = zc_Movement_SendOnPrice() AND MovementLinkObject_From.ObjectId = 8459 /* "Склад Реализации" */) THEN zc_Movement_Sale()
                            , Movement.Id  AS MovementId
                            , MovementDate_OperDatePartner.ValueData  AS OperDate
                       FROM MovementDate AS MovementDate_OperDatePartner
                            INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId 
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                   AND Movement.DescId  IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())

                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   AND MovementLinkObject_From.ObjectId = inUnitId                    -- Склад Реализации
                       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                       )

      , tmpMovRet AS (SELECT zc_Movement_ReturnIn() AS MovementDescId-- = zc_Movement_SendOnPrice() AND MovementLinkObject_From.ObjectId = 8459) THEN zc_Movement_Sale()
                           , Movement.Id  AS MovementId
                           , MovementDate_OperDatePartner.ValueData  AS OperDate
                      FROM MovementDate AS MovementDate_OperDatePartner
                           INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId 
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND Movement.DescId  IN (zc_Movement_ReturnIn(), zc_Movement_SendOnPrice())

                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                           INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_To.ObjectId   -- ограничили складами возврата

                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                      )

      , tmpMI_Sale AS (SELECT MovementItem.ObjectId AS GoodsId
                            , SUM (COALESCE (MovementItem.Amount, 0))  AS Amount
                            , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0)) AS AmountPartner

                            , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END)  AS DayAmount
                            , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS DayAmountPartner
                       FROM tmpMovSale AS tmp 
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId 

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                  ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                       GROUP BY MovementItem.ObjectId
                       )

      , tmpMI_Ret AS (SELECT MovementItem.ObjectId AS GoodsId
                           , SUM (COALESCE (MovementItem.Amount, 0))  AS Amount
                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0)) AS AmountPartner

                           , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END)  AS DayAmount
                           , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS DayAmountPartner
                      FROM tmpMovRet AS tmp 
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId 

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                  ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      GROUP BY MovementItem.ObjectId
                      )

    --  INSERT INTO _tmpData (GoodsId, SaleAmount, SaleAmountPartner, ReturnAmount, ReturnAmountPartner)
-- CAST (tmpMIContainer_group.CountSale * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountSale_Weight
    ,     tmpData  AS (SELECT tmp.GoodsId
                            , SUM (tmp.SaleAmount)           AS SaleAmount
                            , SUM (tmp.SaleAmountPartner)    AS SaleAmountPartner
                            , SUM (tmp.ReturnAmount)         AS ReturnAmount
                            , SUM (tmp.ReturnAmountPartner)  AS ReturnAmountPartner

                            , SUM (tmp.SaleAmountDay)           AS SaleAmountDay
                            , SUM (tmp.SaleAmountPartnerDay)    AS SaleAmountPartnerDay
                            , SUM (tmp.ReturnAmountDay)         AS ReturnAmountDay
                            , SUM (tmp.ReturnAmountPartnerDay)  AS ReturnAmountPartnerDay
                       FROM (SELECT tmp.GoodsId
                                  , tmp.Amount              AS SaleAmount
                                  , tmp.AmountPartner       AS SaleAmountPartner
                                  , tmp.DayAmount           AS SaleAmountDay
                                  , tmp.DayAmountPartner    AS SaleAmountPartnerDay
                                  , 0 AS ReturnAmount
                                  , 0 AS ReturnAmountPartner
                                  , 0 AS ReturnAmountDay
                                  , 0 AS ReturnAmountPartnerDay
                             FROM tmpMI_Sale AS tmp
                           UNION
                             SELECT tmp.GoodsId
                                  , 0 AS SaleAmount
                                  , 0 AS SaleAmountPartner
                                  , 0 AS SaleAmountDay
                                  , 0 AS SaleAmountPartnerDay
                                  , tmp.Amount           AS ReturnAmount
                                  , tmp.AmountPartner    AS ReturnAmountPartner
                                  , tmp.DayAmount        AS ReturnAmountDay
                                  , tmp.DayAmountPartner AS ReturnAmountPartnerDay
                             FROM tmpMI_Ret AS tmp
                             ) AS tmp
                       GROUP BY tmp.GoodsId
                      )  
                      -- данные основные
          INSERT INTO _tmpData (GroupNum, GoodsId, GoodsPlatformId, TradeMarkId, GoodsTagId, SaleAmount, SaleAmountPartner, ReturnAmount, ReturnAmountPartner, SaleAmountDay, SaleAmountPartnerDay, ReturnAmountDay, ReturnAmountPartnerDay)
                      SELECT _tmpGoods.GroupNum
                            , tmp.GoodsId
                            , _tmpGoods.GoodsPlatformId
                            , _tmpGoods.TradeMarkId
                            , _tmpGoods.GoodsTagId
                            , CAST (tmp.SaleAmount          * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END   AS TFloat)   AS SaleAmount
                            , CAST (tmp.SaleAmountPartner   * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END   AS TFloat)   AS SaleAmountPartner
                            , CAST (tmp.ReturnAmount        * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END   AS TFloat)   AS ReturnAmount
                            , CAST (tmp.ReturnAmountPartner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END   AS TFloat)   AS ReturnAmountPartner

                            , CAST (tmp.SaleAmountDay          * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END   AS TFloat)   AS SaleAmountDay
                            , CAST (tmp.SaleAmountPartnerDay   * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END   AS TFloat)   AS SaleAmountPartnerDay
                            , CAST (tmp.ReturnAmountDay        * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END   AS TFloat)   AS ReturnAmountDay
                            , CAST (tmp.ReturnAmountPartnerDay * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END   AS TFloat)   AS ReturnAmountPartnerDay
                       FROM tmpData AS tmp
                            LEFT JOIN _tmpGoods  ON _tmpGoods.GoodsId = tmp.GoodsId
                       --     LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = _tmpGoods.GoodsPlatformId
                       --     LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = _tmpGoods.TradeMarkId
                       --     LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = _tmpGoods.GoodsTagId
                       ;
          
    ANALYZE _tmpData;

    OPEN Cursor1 FOR

    WITH
    tmpData AS (SELECT _tmpData.*
                FROM _tmpData 
                WHERE _tmpData.GroupNum = 1
                )

    SELECT '    Итого продано колбасы'        :: TVarChar AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
  UNION ALL
    (SELECT Object_GoodsPlatform.ValueData    :: TVarChar AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
         LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = tmpData.GoodsPlatformId
    GROUP BY Object_GoodsPlatform.ValueData
    ORDER BY Object_GoodsPlatform.ValueData
    )
  UNION ALL
     SELECT 'за сутки Алан'             :: TVarChar AS GroupName
         , SUM (tmpData.SaleAmountDay)           :: TFloat   AS SaleAmount
         , SUM (tmpData.SaleAmountPartnerDay)    :: TFloat   AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmountDay)         :: TFloat   AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartnerDay)  :: TFloat   AS ReturnAmountPartner
         , SUM (tmpData.SaleAmountDay - tmpData.ReturnAmountDay)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartnerDay - tmpData.ReturnAmountPartnerDay) :: TFloat AS AmountPartner
    FROM tmpData
    WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
  UNION ALL
    (SELECT 'сред. Кг/сутки Алан'             :: TVarChar AS GroupName
         , (SUM (tmpData.SaleAmount)/vbCountDays)           :: TFloat   AS SaleAmount
         , (SUM (tmpData.SaleAmountPartner)/vbCountDays)    :: TFloat   AS SaleAmountPartner 
         , (SUM (tmpData.ReturnAmount)/vbCountDays)         :: TFloat   AS ReturnAmount
         , (SUM (tmpData.ReturnAmountPartner)/vbCountDays)  :: TFloat   AS ReturnAmountPartner
         , (SUM (tmpData.SaleAmount - tmpData.ReturnAmount)/vbCountDays)               :: TFloat AS Amount
         , (SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner)/vbCountDays) :: TFloat AS AmountPartner
    FROM tmpData
         LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
    WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
    )
--
  UNION ALL
    SELECT '    В разрезе торговых марок'    :: TVarChar AS GroupName
         , vbCountDays    :: TFloat AS SaleAmount
         , NULL    :: TFloat AS SaleAmountPartner 
         , NULL    :: TFloat AS ReturnAmount
         , NULL    :: TFloat AS ReturnAmountPartner
         , NULL    :: TFloat AS Amount
         , NULL    :: TFloat AS AmountPartner
  UNION ALL
    (SELECT Object_TradeMark.ValueData        :: TVarChar AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
         LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
    WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
    GROUP BY Object_TradeMark.ValueData
    ORDER BY Object_TradeMark.ValueData
    )
--
  UNION ALL
    SELECT '    В разрезе групп товаров'    :: TVarChar AS GroupName
         , NULL    :: TFloat AS SaleAmount
         , NULL    :: TFloat AS SaleAmountPartner 
         , NULL    :: TFloat AS ReturnAmount
         , NULL    :: TFloat AS ReturnAmountPartner
         , NULL    :: TFloat AS Amount
         , NULL    :: TFloat AS AmountPartner
  UNION ALL
    SELECT Object_GoodsTag.ValueData          :: TVarChar AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
         LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = tmpData.GoodsTagId
    WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
    GROUP BY Object_GoodsTag.ValueData
    ;
    
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
    WITH
    tmpData AS (SELECT _tmpData.*
                FROM _tmpData 
                WHERE _tmpData.GroupNum = 2
                )

    SELECT '    Итого продано колбасы'        :: TVarChar AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
  UNION ALL
    (SELECT Object_GoodsPlatform.ValueData    :: TVarChar AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
         LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = tmpData.GoodsPlatformId
    GROUP BY Object_GoodsPlatform.ValueData
    ORDER BY Object_GoodsPlatform.ValueData
    )
  UNION ALL
    SELECT '    В разрезе торговых марок'    :: TVarChar AS GroupName
         , NULL    :: TFloat AS SaleAmount
         , NULL    :: TFloat AS SaleAmountPartner 
         , NULL    :: TFloat AS ReturnAmount
         , NULL    :: TFloat AS ReturnAmountPartner
         , NULL    :: TFloat AS Amount
         , NULL    :: TFloat AS AmountPartner
  UNION ALL
    (SELECT Object_TradeMark.ValueData        :: TVarChar AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
         LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
   -- WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
    GROUP BY Object_TradeMark.ValueData
    ORDER BY Object_TradeMark.ValueData
    )
  UNION ALL
    SELECT '    В разрезе групп товаров'    :: TVarChar AS GroupName
         , NULL    :: TFloat AS SaleAmount
         , NULL    :: TFloat AS SaleAmountPartner 
         , NULL    :: TFloat AS ReturnAmount
         , NULL    :: TFloat AS ReturnAmountPartner
         , NULL    :: TFloat AS Amount
         , NULL    :: TFloat AS AmountPartner
  UNION ALL
    SELECT Object_GoodsTag.ValueData          :: TVarChar AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
         LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = tmpData.GoodsTagId
    --WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
    GROUP BY Object_GoodsTag.ValueData
    ;

  RETURN NEXT Cursor2;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.12.16         *
*/

--select * from gpReport_Goods_byMovement(inStartDate := ('01.01.2014')::TDateTime , inEndDate := ('31.01.2014 23:59:00')::TDateTime ,  inSession := '5');