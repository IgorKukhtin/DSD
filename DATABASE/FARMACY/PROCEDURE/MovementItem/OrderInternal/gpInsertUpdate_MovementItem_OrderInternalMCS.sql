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
                                SELECT MovementItem.Id 
                                FROM MovementItem
                                    INNER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                 ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond() 
                                WHERE 
                                    MovementItem.MovementId = vbMovementId
                              )
            AND
            DescId = zc_MIFloat_AmountManual();
        
        
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
                                           ,inValueData       := floor(Object_Price.MCSValue - SUM(COALESCE(Container.Amount,0)) - COALESCE(Income.Amount_Income,0))::TFloat)
        from Object_Price_View AS Object_Price
            -- LEFT OUTER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                -- ON ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                               -- AND ContainerLinkObject_Unit.ObjectId = Object_Price.UnitId
            LEFT OUTER JOIN Container ON Container.WhereObjectId = Object_Price.UnitId
                                     AND Container.ObjectId = Object_Price.GoodsId
                                     AND Container.DescId = zc_Container_Count() 
                                     AND Container.Amount > 0
            LEFT OUTER JOIN (
                                SELECT 
                                    T1.Id,
                                    T1.Amount, 
                                    T1.ObjectId  
                                FROM (
                                        SELECT MovementItem.Id,
                                            MovementItem.Amount,
                                            MovementItem.ObjectId,
                                            ROW_NUMBER() OVER(PARTITION BY MovementItem.ObjectId Order By MovementItem.Id) as Ord
                                        FROM
                                            MovementItem
                                        WHERE
                                            MovementItem.MovementId = vbMovementId
                                      ) AS T1
                                WHERE
                                    T1.Ord = 1
                            )AS MovementItemSaved
                             ON MovementItemSaved.ObjectId = Object_Price.GoodsId
            LEFT OUTER JOIN Object_Goods_View ON Object_Price.GoodsId = Object_Goods_View.Id                            
            LEFT OUTER JOIN (
                                SELECT
                                    MovementItem_Income.ObjectId    as GoodsId 
                                   ,SUM(MovementItem_Income.Amount) as Amount_Income
                                FROM
                                    Movement AS Movement_Income
                                    INNER JOIN MovementItem AS MovementItem_Income
                                                            ON Movement_Income.Id = MovementItem_Income.MovementId
                                                           AND MovementItem_Income.DescId = zc_MI_Master()
                                                           AND MovementItem_Income.isErased = FALSE
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON Movement_Income.Id = MovementLinkObject_To.MovementId
                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                 AND MovementLinkObject_To.ObjectId = inUnitId
                                    INNER JOIN MovementDate AS MovementDate_Branch
                                                            ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                           AND MovementDate_Branch.DescId = zc_MovementDate_Branch() 
                                WHERE
                                    Movement_Income.DescId = zc_Movement_Income()
                                    AND
                                    Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                                    AND
                                    MovementDate_Branch.ValueData >= CURRENT_DATE
                                GROUP BY
                                    MovementItem_Income.ObjectId
                                HAVING
                                    SUM(MovementItem_Income.Amount) > 0
                             ) AS Income
                               ON Object_Price.GoodsId = Income.GoodsId
        WHERE
            Object_Price.MCSValue > 0
            AND
            Object_Price.MCSIsClose = False 
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
            Object_Goods_View.MinimumLot,
            Income.Amount_Income
        HAVING
            floor(Object_Price.MCSValue - SUM(COALESCE(Container.Amount,0)) - COALESCE(Income.Amount_Income,0)) > 0;
        --Пересчитываем ручное количество для строк с авторасчетом
        PERFORM
            lpInsertUpdate_MovementItemFloat(inDescId         := zc_MIFloat_AmountManual()
                                            ,inMovementItemId := MovementItemSaved.Id
                                            ,inValueData      := (CEIL((MovementItemSaved.Amount + COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(Object_Goods.MinimumLot, 1)) * COALESCE(Object_Goods.MinimumLot, 1))
                                            )
        FROM
            MovementItem AS MovementItemSaved
            INNER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                         ON MIFloat_AmountSecond.MovementItemId = MovementItemSaved.Id
                                                                AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond() 
            INNER JOIN Object_Goods_View AS Object_Goods
                                         ON Object_Goods.Id = MovementItemSaved.ObjectId
        WHERE
            MovementItemSaved.MovementId = vbMovementId;
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
 29.08.15                                                                        * ObjectPrice.MCSIsClose = False
 31.07.15                                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternalMCS (inUnitId := 183292, inNeedCreate:= True, inSession:= '3')
