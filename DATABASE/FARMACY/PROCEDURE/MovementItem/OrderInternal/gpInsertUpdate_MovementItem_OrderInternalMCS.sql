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
            JOIN MovementBoolean AS MovementBoolean_isAuto
                                 ON MovementBoolean_isAuto.MovementId = Movement.Id 
                                AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                    
        WHERE 
            Movement.StatusId = zc_Enum_Status_UnComplete() 
            AND 
            Movement.DescId = zc_Movement_OrderInternal() 
            AND 
            Movement.OperDate = vbOperDate 
            AND 
            MovementLinkObject_Unit.ObjectId = inUnitId
            AND
            MovementBoolean_isAuto.ValueData = True
        ORDER BY
            Movement.Id
        LIMIT 1;

        IF COALESCE(vbMovementId, 0) = 0 THEN --Если такой нет - создаем
            vbMovementId := gpInsertUpdate_Movement_OrderInternal(0, '', vbOperDate, inUnitId, 0, inSession);
            PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, True);
        END IF;
        --Очищаем содержимое заявки
        PERFORM lpDelete_MovementItem(Id, inSession)
        FROM MovementItem
        WHERE MovementItem.MovementId = vbMovementId;
        --заливаем согласно разници между остатком и НТЗ
        PERFORM 
          lpInsertUpdate_MovementItem_OrderInternal(0 
                                                   ,vbMovementId
                                                   ,Object_Price.GoodsId
                                                   ,CEIL(Object_Price.MCSValue - (SUM(COALESCE(Container.Amount,0)) + COALESCE(Income.Amount_Income,0)))::TFloat
                                                   ,Object_Price.Price
                                                   ,vbUserId)
        from Object_Price_View AS Object_Price
            LEFT OUTER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                ON ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                               AND ContainerLinkObject_Unit.ObjectId = Object_Price.UnitId
            LEFT OUTER JOIN Container ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                     AND Container.ObjectId = Object_Price.GoodsId
                                     AND Container.DescId = zc_Container_Count() 
                                     AND Container.Amount > 0
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
                                    Movement_Income.StatusId = (Select Id from Object Where DescId = zc_Object_Status() AND ObjectCode = zc_Enum_StatusCode_UnComplete())
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
            Object_Price.UnitId = inUnitId
        GROUP BY
            Object_Price.UnitId,
            Object_Price.GoodsId,
            Object_Price.MCSValue,
            Object_Price.Price,
            Income.Amount_Income
        HAVING
            (CEIL(Object_Price.MCSValue - (SUM(COALESCE(Container.Amount,0)) + COALESCE(Income.Amount_Income,0)))>0);
        --Записываем признак авторасчета в содержимое
        PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_Calculated(),Id,True)
        FROM MovementItem
        WHERE MovementId = vbMovementId;
        
    END IF;
    IF EXISTS(  SELECT Movement.Id
                FROM Movement
                    JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                    JOIN MovementBoolean AS MovementBoolean_isAuto
                                         ON MovementBoolean_isAuto.MovementId = Movement.Id 
                                        AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                            
                WHERE 
                    Movement.StatusId = zc_Enum_Status_UnComplete() 
                    AND 
                    Movement.DescId = zc_Movement_OrderInternal() 
                    AND 
                    Movement.OperDate = vbOperDate 
                    AND 
                    MovementLinkObject_Unit.ObjectId = inUnitId
                    AND
                    MovementBoolean_isAuto.ValueData = True
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
