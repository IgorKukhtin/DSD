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
BEGIN
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица - 
         CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpData (GoodsId Integer,  SaleAmount TFloat, SaleAmountPartner TFloat, ReturnAmount TFloat, ReturnAmountPartner TFloat) ON COMMIT DROP;
     END IF;

     IF COALESCE (inUnitGroupId,0) <> 0 
     THEN
         INSERT INTO _tmpUnit (UnitId)
           SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect;
     END IF;


    -- Ограничения по товару ()
    IF inGoodsGroupGPId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GoodsId, MeasureId, Weight)
           SELECT lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupGPId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          UNION
           SELECT lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          ;
    END IF;
    
    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpGoods;
    ANALYZE _tmpUnit;

    WITH
        tmpMovSale AS (SELECT zc_Movement_Sale() AS MovementDescId   -- = zc_Movement_SendOnPrice() AND MovementLinkObject_From.ObjectId = 8459 /* "Склад Реализации" */) THEN zc_Movement_Sale()
                            , Movement.Id  AS MovementId
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

      , tmpMovRet AS (SELECT zc_Movement_ReturnIn() AS MovementDescId-- = zc_Movement_SendOnPrice() AND MovementLinkObject_From.ObjectId = 8459 /* "Склад Реализации" */) THEN zc_Movement_Sale()
                           , Movement.Id  AS MovementId
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

      INSERT INTO _tmpData (GoodsId, SaleAmount, SaleAmountPartner, ReturnAmount, ReturnAmountPartner)
                       SELECT tmp.GoodsId
                            , SUM (tmp.SaleAmount)           AS SaleAmount
                            , SUM (tmp.SaleAmountPartner)    AS SaleAmountPartner
                            , SUM (tmp.ReturnAmount)         AS ReturnAmount
                            , SUM (tmp.ReturnAmountPartner ) AS ReturnAmountPartner
                       FROM (SELECT tmp.GoodsId
                                  , tmp.Amount AS SaleAmount
                                  , tmp.AmountPartner AS SaleAmountPartner
                                  , 0 AS ReturnAmount
                                  , 0 AS ReturnAmountPartner
                             FROM tmpMI_Sale AS tmp
                           UNION
                             SELECT tmp.GoodsId
                                  , 0 AS SaleAmount
                                  , 0 AS SaleAmountPartner
                                  , tmp.Amount        AS ReturnAmount
                                  , tmp.AmountPartner AS ReturnAmountPartner
                             FROM tmpMI_Ret AS tmp
                             ) AS tmp
                       GROUP BY tmp.GoodsId
                       ;

    OPEN Cursor1 FOR

    WITH
    tmpData AS (SELECT _tmpDat.*
                     , _tmpGoods.MeasureId
                     , _tmpGoods.Weight 
                FROM _tmpGoods
                     JOIN  _tmpData ON _tmpData.GoodsId = _tmpGoods.GoodsId
                WHERE _tmpGoods.InfoMoneyId <> zc_Enum_InfoMoney_30102()  -- не тушенка
                )

    SELECT 'Итого продано колбасы'            :: TFloat AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
  UNION ALL
   SELECT Object_GoodsPlatform.ValueData      :: TFloat AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                               ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmpData.GoodsId 
                             AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
          LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

    ;

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
   WITH
    tmpData AS (SELECT _tmpDat.*
                     , _tmpGoods.MeasureId
                     , _tmpGoods.Weight 
                FROM _tmpGoods
                     JOIN  _tmpData ON _tmpData.GoodsId = _tmpGoods.GoodsId
                WHERE _tmpGoods.InfoMoneyId <> zc_Enum_InfoMoney_30102()  -- не тушенка
                )
    SELECT 'Итого продано колбасы'            :: TFloat AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
  UNION ALL
   SELECT Object_GoodsPlatform.ValueData      :: TFloat AS GroupName
         , SUM (tmpData.SaleAmount)           :: TFloat AS SaleAmount
         , SUM (tmpData.SaleAmountPartner)    :: TFloat AS SaleAmountPartner 
         , SUM (tmpData.ReturnAmount)         :: TFloat AS ReturnAmount
         , SUM (tmpData.ReturnAmountPartner)  :: TFloat AS ReturnAmountPartner
         , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
         , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
    FROM tmpData
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                               ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id 
                             AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
          LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

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