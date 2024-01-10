-- Function: lpInsertUpdate_MovementFloat_TotalSummLoss (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummLoss (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummLoss(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCountLoss     TFloat;
  DECLARE vbTotalSumLoss       TFloat;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbCat_5 TFloat;
  DECLARE vbisCat_5 boolean;
BEGIN

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     --Определили подразделение для розничной цены и дату для остатка
     SELECT 
           MovementLinkObject_Unit.ObjectId
         , Movement_Loss.OperDate 
         , MovementLinkObject_ArticleLoss.ObjectId = 23653195
     INTO 
          vbUnitId
        , vbOperDate
        , vbisCat_5
     FROM Movement AS Movement_Loss
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement_Loss.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                      ON MovementLinkObject_ArticleLoss.MovementId = Movement_Loss.Id
                                     AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
     WHERE Movement_Loss.Id = inMovementId;
    
     SELECT COALESCE(ObjectFloat_CashSettings_Cat_5.ValueData, 0)                                 AS Cat_5
     INTO vbCat_5
     FROM Object AS Object_CashSettings

          LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Cat_5
                                ON ObjectFloat_CashSettings_Cat_5.ObjectId = Object_CashSettings.Id 
                               AND ObjectFloat_CashSettings_Cat_5.DescId = zc_ObjectFloat_CashSettings_Cat_5()

     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;   
    
     WITH
         tmpMovement AS (SELECT Movement.OperDate
                              , MovementItem.ObjectId                                 AS GoodsId
                              , MovementItem.Amount
                              , MovementLinkObject_Unit.ObjectId                      AS UnitId
                              , MIFloat_Price.ValueData                               AS Price
                         FROM Movement
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                              LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.isErased = false
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         WHERE Movement.Id = inMovementId)
         , tmpGoods AS (SELECT DISTINCT Movement.OperDate, Movement.GoodsId
                        FROM tmpMovement AS Movement
                        )
        , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                            , CASE WHEN vbisCat_5 = TRUE
                                   THEN COALESCE (ObjectHistoryFloat_Price.ValueData * (100 - vbCat_5) / 100, 0)
                                   ELSE COALESCE (ObjectHistoryFloat_Price.ValueData, 0) END :: TFloat  AS Price
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN tmpGoods ON 1 = 1
                            INNER JOIN ObjectLink AS Price_Goods
                                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                 AND Price_Goods.ChildObjectId = tmpGoods.GoodsId

                            -- получаем значения цены и НТЗ из истории значений на начало дня
                            LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                    ON ObjectHistory_Price.ObjectId = Price_Goods.ObjectId
                                                   AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                   AND tmpGoods.OperDate >= ObjectHistory_Price.StartDate AND tmpGoods.OperDate < ObjectHistory_Price.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                         ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                       WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = (SELECT DISTINCT tmpMovement.UnitId FROM tmpMovement)
                      )

      SELECT SUM(COALESCE(tmpMovement.Amount,0)) AS Amount
           , SUM(ROUND(COALESCE(tmpMovement.Amount * COALESCE(tmpMovement.Price, tmpPrice.Price),0), 2)) AS Summa
      INTO vbTotalCountLoss, vbTotalSumLoss
      FROM tmpMovement
           INNER JOIN tmpPrice ON tmpPrice.GoodsId = tmpMovement.GoodsId;
          
      -- Сохранили свойство <Итого количество>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountLoss);
      -- Сохранили свойство <Итого сумма>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSale(), inMovementId, vbTotalSumLoss);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummLoss (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 25.04.20                                                         * 
 20.07.15                                                         * 
*/

select * from lpInsertUpdate_MovementFloat_TotalSummLoss (34457829);