-- Function: gpComplete_Movement_Transport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_Transport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Transport(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
 
  DECLARE vbId Integer; 
  DECLARE vbRouteId Integer;
  DECLARE vbRateSumma TFloat;
  DECLARE vbRatePrice TFloat;
  DECLARE vbTimePrice TFloat;
  DECLARE vbHours TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Transport());
     -- Проверка закрытия периодов
     -- PERFORM lpCheckPeriodClose(vbUserId, inMovementId);

     -- сохраняем свойства командировочные и дальнобойные
     -- получаем маршрут
     SELECT MovementItem.Id AS Id
          , MovementItem.ObjectId AS RouteId
        INTO vbId, vbRouteId
     FROM  MovementItem 
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
     LIMIT 1;
     
     IF COALESCE(vbId, 0) <> 0 
     THEN
          -- данные из маршрута сумма командировочных. Ставка грн/ч (комманд.), сумма дальнобойные
          SELECT COALESCE (ObjectFloat_RateSumma.ValueData, 0) AS RateSumma
               , COALESCE (ObjectFloat_RatePrice.ValueData, 0) AS RatePrice
               , COALESCE (ObjectFloat_TimePrice.ValueData, 0) AS TimePrice
              INTO vbRateSumma, vbRatePrice, vbTimePrice
          FROM Object AS Object_Route
             LEFT JOIN ObjectFloat AS ObjectFloat_RateSumma
                                   ON ObjectFloat_RateSumma.ObjectId = Object_Route.Id
                                  AND ObjectFloat_RateSumma.DescId = zc_ObjectFloat_Route_RateSumma()
             LEFT JOIN ObjectFloat AS ObjectFloat_RatePrice
                                   ON ObjectFloat_RatePrice.ObjectId = Object_Route.Id
                                  AND ObjectFloat_RatePrice.DescId = zc_ObjectFloat_Route_RatePrice()
             LEFT JOIN ObjectFloat AS ObjectFloat_TimePrice
                                   ON ObjectFloat_TimePrice.ObjectId = Object_Route.Id
                                  AND ObjectFloat_TimePrice.DescId = zc_ObjectFloat_Route_TimePrice()
          WHERE  Object_Route.Id = vbRouteId
             AND Object_Route.DescId = zc_Object_Route();
             
          IF COALESCE (vbTimePrice, 0) <> 0
          THEN
              vbHours := (SELECT CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat) AS Hours_All
                          FROM MovementFloat AS MovementFloat_HoursWork
                              LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                                      ON MovementFloat_HoursAdd.MovementId = MovementFloat_HoursWork.MovementId
                                                     AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
                          WHERE MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
                            AND MovementFloat_HoursWork.MovementId = inMovementId);
              IF COALESCE (vbHours, 0) <> 0
                 THEN
                     vbRateSumma := COALESCE (vbHours, 0) * vbTimePrice;
              END IF;
          END IF;
     
          -- пересохранили свойство <командировочные>
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSumma(), vbId, vbRateSumma);  
          -- сохранили свойство <дальнобойные>
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RatePrice(), vbId, vbRatePrice); 
     END IF;     
          
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Transport_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_Transport (inMovementId := inMovementId
                                          , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.17         * сохранение командировочные, дальнобойные
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 25.02.13                        * lpCheckPeriodClose                
 03.11.13                                        * add RouteId_ProfitLoss
 02.11.13                                        * add BranchId_ProfitLoss, UnitId_Route, BranchId_Route
 26.10.13                                        * add CREATE TEMP TABLE...
 12.10.13                                        * del lpComplete_Movement_Income
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Transport (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
