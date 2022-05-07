-- Function: gpUpdate_MovementItem_PriceAverage()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_PriceAverage (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_PriceAverage(
    IN inMovementId  Integer      , -- ключ Документа
    IN inOperDate    TDateTime    , -- ключ Документа
    IN inDay         Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    PERFORM lpInsertUpdate_MovementItem_CompetitorMarkups (ioId                  := MovementItem.Id       -- Ключ объекта <Элемент документа>
                                                         , inMovementId          := inMovementId          -- ключ Документа
                                                         , inGoodsID             := MovementItem.ObjectId -- товар
                                                         , inPrice               := tmpPrice.Price        -- Средняя цена
                                                         , inUserId              := vbUserId              -- пользователь
                                                          )
    FROM MovementItem
    
         INNER JOIN (SELECT AnalysisContainerItem.GoodsId
                          , (SUM(AnalysisContainerItem.AmountCheckSum) / SUM(AnalysisContainerItem.AmountCheck))::TFloat AS Price
                     FROM AnalysisContainerItem
                     WHERE AnalysisContainerItem.OperDate >= inOperDate - (inDay::tvarchar||' DAY')::INTERVAL 
                       AND AnalysisContainerItem.OperDate < inOperDate + INTERVAL '1 DAY'
                     GROUP BY AnalysisContainerItem.GoodsId
                     HAVING SUM(AnalysisContainerItem.AmountCheck) > 0) AS tmpPrice
                                                                        ON tmpPrice.GoodsId = MovementItem.ObjectId  

         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()

    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = False
      AND tmpPrice.Price <> COALESCE (MIFloat_Price.ValueData, 0)
      AND COALESCE (tmpPrice.Price, 0) > 0;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.05.22                                                        *
*/
-- 
select * from gpUpdate_MovementItem_PriceAverage(inMovementId := 27717912, inOperDate := '07.05.2022', inDay := 10, inSession := '3');