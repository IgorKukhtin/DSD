-- Function: gpComplete_Movement_MarginCategory()

DROP FUNCTION IF EXISTS gpComplete_Movement_MarginCategory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_MarginCategory(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbUnitId     Integer;
  DECLARE vbOperDateStart  TDateTime;
  DECLARE vbOperDateEnd    TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession; 
     
     -- получаем данные из шапки документа, 
     SELECT MovementDate_OperDateStart.ValueData   AS OperDateStart
          , MovementDate_OperDateEnd.ValueData     AS OperDateEnd
          , MovementLinkObject_Unit.ObjectId       AS UnitId
        INTO vbOperDateStart, vbOperDateEnd, vbUnitId
     FROM Movement AS Movement_MarginCategory 
 
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId = Movement_MarginCategory.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId = Movement_MarginCategory.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement_MarginCategory.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                                                                     
     WHERE Movement_MarginCategory.Id =  inMovementId
       AND Movement_MarginCategory.DescId = zc_Movement_MarginCategory();

     --проверяем чтоб не проводился док. задним числом
     IF (vbOperDateStart < CURRENT_DATE) OR (vbOperDateEnd < CURRENT_DATE)
     THEN
         RAISE EXCEPTION 'Ошибка. Наценка не может быть изменена задним числом.';
     END IF;

     PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_PercentMarkup(), tmp.PriceId, tmp.MarginPercentNew)       -- сохранили св-во < % наценки >
           , lpInsertUpdate_objectDate(zc_ObjectDate_Price_PercentMarkupDateChange(), tmp.PriceId, CURRENT_DATE)       -- сохранили св-во < Дата изменения >
           , lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_Top(), tmp.PriceId, TRUE)                             -- сохранили свойство <ТОп позиция>
           , lpInsertUpdate_objectDate(zc_ObjectDate_Price_TopDateChange(), tmp.PriceId, CURRENT_DATE)                 -- сохранили дату изменения <ТОп позиция>
     FROM (
           WITH
           --строки чайлда
           tmpMI_Child AS (SELECT MovementItem.ObjectId             AS MarginCategoryItemId
                                , MovementItem.Amount               AS Amount
                                , ObjectFloat_MinPrice.ValueData    AS MinPrice
                                , MovementItem.Amount + COALESCE (MIFloat_Amount.ValueData, 0)  ::TFloat AS PercentNew
                                , ROW_NUMBER() OVER (ORDER BY ObjectFloat_MinPrice.ValueData) as ORD
                           FROM MovementItem                    
                                LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                                            ON MIFloat_Amount.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Amount.DescId = zc_MIFloat_Amount()
                                                        
                                LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                                      ON ObjectFloat_MinPrice.ObjectId = MovementItem.ObjectId
                                                     AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = FALSE
                          )
         , MarginCondition AS (SELECT D1.MarginCategoryItemId
                                    , D1.Amount AS MarginPercent
                                    , D1.PercentNew
                                    , D1.MinPrice
                                    , COALESCE(D2.MinPrice, 1000000) AS MaxPrice 
                               FROM tmpMI_Child AS D1
                                   LEFT OUTER JOIN tmpMI_Child AS D2 ON D1.ORD = D2.ORD-1
                              )
         --строки мастера
         , tmpMI_Master AS (SELECT MovementItem.*
                                 , MIFloat_Price.ValueData AS Price
                            FROM MovementItem 
                                 INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                                ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                                               AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                               AND MIBoolean_Checked.ValueData = TRUE
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                           )
         -- выбираем данные Прайса
         , tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId         AS Id
                             , Price_Goods.ChildObjectId              AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                             INNER JOIN ObjectLink AS Price_Goods
                                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    
                             INNER JOIN (SELECT DISTINCT tmpMI_Master.ObjectId 
                                         FROM tmpMI_Master) AS tmpMI_Master 
                                                            ON tmpMI_Master.ObjectId = Price_Goods.ChildObjectId
                        WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        )
         -- резульат
         SELECT tmpPrice.Id                              AS PriceId
              , tmpMI_Master.ObjectId                    AS GoodsId
              , COALESCE (MarginCondition.PercentNew, 0) AS MarginPercentNew
         FROM tmpMI_Master
              INNER JOIN tmpPrice ON tmpPrice.GoodsId = tmpMI_Master.ObjectId
              LEFT  JOIN MarginCondition ON COALESCE (tmpMI_Master.Price, 0) >= MarginCondition.MinPrice AND COALESCE (tmpMI_Master.Price, 0) < MarginCondition.MaxPrice
              
         ) AS tmp;
     
 
     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_MarginCategory()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.12.17         *
 21.11.17         *

*/

-- тест