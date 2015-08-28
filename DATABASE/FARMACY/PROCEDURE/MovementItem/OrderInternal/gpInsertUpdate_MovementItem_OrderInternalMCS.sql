-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternalMCS(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternalMCS(
    IN inUnitId              Integer   , -- Подразделение
    IN inNeedCreate          Boolean   , -- Нужна ли обработка
   OUT outOrderExists        Boolean   , -- Заявка существует
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
    IF inNeedCreate = True  --Если в интерфейсе поставили галку на подразделении
    THEN -- то перезаливаем заявку на разницу между остатком и НТЗ
        vbUserId := inSession;
        vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
        vbOperDate := CURRENT_DATE;
        --Ищем заявку на сегодня, незакрытую, созданую автоматом
        SELECT Movement.Id INTO vbMovementId
        FROM Movement
            JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        WHERE 
            Movement.StatusId = zc_Enum_Status_UnComplete() 
            AND 
            Movement.DescId = zc_Movement_OrderInternal() 
            AND 
            Movement.OperDate = vbOperDate 
            AND 
            MovementLinkObject_Unit.ObjectId = inUnitId
        ORDER BY
            Movement.Id
        LIMIT 1;

        IF COALESCE(vbMovementId, 0) = 0 THEN --Если такой нет - создаем
            vbMovementId := gpInsertUpdate_Movement_OrderInternal(0, '', vbOperDate, inUnitId, 0, inSession);
        END IF;
        --Очищаем содержимое заявки
        DELETE FROM MovementItemFloat
        WHERE 
            MovementItemId in (
                                SELECT Id from MovementItem
                                Where MovementItem.MovementId = vbMovementId
                              )
            AND
            DescId = zc_MIFloat_AmountSecond();
        --заливаем согласно разници между остатком и НТЗ
        PERFORM
            lpInsertUpdate_MovementItemFloat(inDescId         := zc_MIFloat_AmountSecond()
                                            ,inMovementItemId := lpInsertUpdate_MovementItem_OrderInternal(ioId         := COALESCE(MovementItemSaved.Id,0)
                                                                                                          ,inMovementId := vbMovementId
                                                                                                          ,inGoodsId    := Object_Price.GoodsId
                                                                                                          ,inAmount     := COALESCE(MovementItemSaved.Amount,0)
                                                                                                          ,inAmountManual:= NULL
                                                                                                          ,inPrice      := Object_Price.Price
                                                                                                          ,inUserId     := vbUserId)
                                           ,inValueData       := floor(Object_Price.MCSValue - SUM(COALESCE(Container.Amount,0)))::TFloat),
            lpInsertUpdate_MovementItemFloat(inDescId         := zc_MIFloat_AmountManual()
                                            ,inMovementItemId := lpInsertUpdate_MovementItem_OrderInternal(ioId         := COALESCE(MovementItemSaved.Id,0)
                                                                                                          ,inMovementId := vbMovementId
                                                                                                          ,inGoodsId    := Object_Price.GoodsId
                                                                                                          ,inAmount     := COALESCE(MovementItemSaved.Amount,0)
                                                                                                          ,inAmountManual:= NULL
                                                                                                          ,inPrice      := Object_Price.Price
                                                                                                          ,inUserId     := vbUserId)
                                           ,inValueData       := (CEIL((COALESCE(MovementItemSaved.Amount,0) + floor(Object_Price.MCSValue - SUM(COALESCE(Container.Amount,0)))::TFloat)) / COALESCE(Object_Goods_View.MinimumLot, 1)) * COALESCE(Object_Goods_View.MinimumLot, 1))
        from Object_Price_View AS Object_Price
            LEFT OUTER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                ON ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                               AND ContainerLinkObject_Unit.ObjectId = Object_Price.UnitId
            LEFT OUTER JOIN Container ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                     AND Container.ObjectId = Object_Price.GoodsId
                                     AND Container.DescId = zc_Container_Count() 
                                     AND Container.Amount > 0
            LEFT OUTER JOIN MovementItem AS MovementItemSaved
                                         ON MovementItemSaved.MovementId = vbMovementId
                                        AND MovementItemSaved.ObjectId = Object_Price.GoodsId
            LEFT OUTER JOIN Object_Goods_View ON Container.ObjectId = Object_Goods_View.Id                            
        WHERE
            Object_Price.MCSValue > 0
            AND
            Object_Price.UnitId = inUnitId
        GROUP BY
            Object_Price.UnitId,
            Object_Price.GoodsId,
            Object_Price.MCSValue,
            Object_Price.Price,
            MovementItemSaved.Id,
            MovementItemSaved.Amount,
            Object_Price.MCSValue,
            Object_Goods_View.MinimumLot
        HAVING
            floor(Object_Price.MCSValue - SUM(COALESCE(Container.Amount,0)))::TFloat > 0;
        
    END IF;
    IF EXISTS(  SELECT Movement.Id
                FROM Movement
                    JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                WHERE 
                    Movement.StatusId = zc_Enum_Status_UnComplete() 
                    AND 
                    Movement.DescId = zc_Movement_OrderInternal() 
                    AND 
                    Movement.OperDate = vbOperDate 
                    AND 
                    MovementLinkObject_Unit.ObjectId = inUnitId
             )
    THEN
        outOrderExists := True;
    ELSE
        outOrderExists := False;
    END IF;        
      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 31.07.15                                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternalMCS (inUnitId := 183292, inNeedCreate:= True, inSession:= '3')
