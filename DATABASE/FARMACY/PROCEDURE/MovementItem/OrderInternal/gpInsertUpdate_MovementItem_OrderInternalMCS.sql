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



        -- заливаем согласно разници между остатком и НТЗ
        PERFORM lpInsertUpdate_MovementItemFloat(inDescId         := zc_MIFloat_AmountSecond()
                                                ,inMovementItemId := lpInsertUpdate_MovementItem_OrderInternal(ioId         := tmp.MovementItemId
                                                                                                              ,inMovementId := vbMovementId
                                                                                                              ,inGoodsId    := tmp.GoodsId
                                                                                                              ,inAmount     := tmp.Amount
                                                                                                              ,inAmountManual:= NULL
                                                                                                              ,inPrice      := tmp.Price
                                                                                                              ,inUserId     := vbUserId)
                                                ,inValueData       := tmp.ValueData
                                                )
        FROM (WITH Object_Price AS (SELECT ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                                         , Price_Goods.ChildObjectId               AS GoodsId
                                         , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                                         , MCS_Value.ValueData                     AS MCSValue 
                                    FROM ObjectLink        AS ObjectLink_Price_Unit
                                         LEFT JOIN ObjectBoolean      AS MCS_isClose
                                                 ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                                         LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                         INNER JOIN Object AS Object_Goods ON Object_Goods.Id = Price_Goods.ChildObjectId
                                                                          AND Object_Goods.isErased = False
                                         LEFT JOIN ObjectFloat AS Price_Value
                                                ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                         LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                                    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                      AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                                      AND COALESCE(MCS_isClose.ValueData,False) = False
                                      AND COALESCE(MCS_Value.ValueData,0) > 0
                                   )

            , MovementItemSaved AS (SELECT T1.Id,
                                           T1.Amount, 
                                           T1.ObjectId  
                                    FROM (SELECT MovementItem.Id,
                                                 MovementItem.Amount,
                                                 MovementItem.ObjectId,
                                                 ROW_NUMBER() OVER(PARTITION BY MovementItem.ObjectId Order By MovementItem.Id) as Ord
                                          FROM MovementItem
                                          WHERE MovementItem.MovementId = vbMovementId
                                            AND MovementItem.isErased = FALSE
                                         ) AS T1
                                    WHERE T1.Ord = 1
                                   )
                      , Income AS (SELECT MovementItem_Income.ObjectId    as GoodsId 
                                        , SUM (MovementItem_Income.Amount) as Amount_Income
                                   FROM Movement AS Movement_Income
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
                                                               -- AND MovementDate_Branch.ValueData >= CURRENT_DATE
                                                               AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '7 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                                WHERE Movement_Income.DescId = zc_Movement_Income()
                                  AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                                GROUP BY MovementItem_Income.ObjectId
                                HAVING SUM (MovementItem_Income.Amount) > 0
                             )
            , tmpMI_Send AS (SELECT MovementItem.ObjectId     AS GoodsId 
                                  , SUM (MovementItem.Amount) AS Amount
                             FROM Movement
                                    INNER JOIN MovementItem AS MovementItem
                                                            ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                                 AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                 AND MovementLinkObject_To.ObjectId   = inUnitId
                                    -- закомментил - пусть будут все перемещения, не только Авто
                                    /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                               ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                              AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                              AND MovementBoolean_isAuto.ValueData  = TRUE*/
                                    /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                              ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                             AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                             WHERE Movement.DescId = zc_Movement_Send()
                                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                  --AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                                  -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                                  AND Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                             GROUP BY MovementItem.ObjectId
                            )
   , tmpMI_OrderExternal AS (SELECT MI_OrderExternal.ObjectId                AS GoodsId
                                  , SUM (MI_OrderExternal.Amount) ::TFloat   AS Amount 
                             FROM Movement AS Movement_OrderExternal
                                  INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                             ON MovementBoolean_Deferred.MovementId = Movement_OrderExternal.Id
                                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                            AND MovementBoolean_Deferred.ValueData = TRUE
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                               AND MovementLinkObject_Unit.ObjectId = inUnitId
                                  INNER JOIN MovementItem AS MI_OrderExternal
                                                          ON MI_OrderExternal.MovementId = Movement_OrderExternal.Id
                                                         AND MI_OrderExternal.DescId = zc_MI_Master()
                                                         AND MI_OrderExternal.isErased = FALSE
                       
                             WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                               AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete()
                             GROUP BY MI_OrderExternal.ObjectId 
                             HAVING SUM (MI_OrderExternal.Amount) <> 0 
                            )
              -- Результат
              SELECT COALESCE(MovementItemSaved.Id,0) AS MovementItemId
                   , Object_Price.GoodsId
                   , COALESCE (MovementItemSaved.Amount, 0) AS Amount
                   , Object_Price.Price AS Price
                   , CASE WHEN Object_Price.MCSValue >= 0.1 AND Object_Price.MCSValue < 10 AND 1 >= CEIL (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                               THEN CEIL (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                          WHEN Object_Price.MCSValue >= 10 AND 1 >= CEIL (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                               THEN ROUND  (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                          ELSE FLOOR (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                     END :: TFloat AS ValueData
              FROM Object_Price
            -- LEFT OUTER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                -- ON ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                               -- AND ContainerLinkObject_Unit.ObjectId = Object_Price.UnitId
            LEFT OUTER JOIN Container ON Container.WhereObjectId = Object_Price.UnitId
                                     AND Container.ObjectId = Object_Price.GoodsId
                                     AND Container.DescId = zc_Container_Count() 
                                     AND Container.Amount <> 0

            LEFT OUTER JOIN MovementItemSaved ON MovementItemSaved.ObjectId = Object_Price.GoodsId

            INNER JOIN Object_Goods_View ON Object_Price.GoodsId = Object_Goods_View.Id    
                                        AND Object_Goods_View.IsClose = FALSE                          

            LEFT OUTER JOIN Income ON Income.GoodsId = Object_Price.GoodsId

            LEFT OUTER JOIN tmpMI_Send ON tmpMI_Send.GoodsId = Object_Price.GoodsId

            LEFT OUTER JOIN tmpMI_OrderExternal ON tmpMI_OrderExternal.GoodsId = Object_Price.GoodsId
        GROUP BY
            Object_Price.UnitId,
            Object_Price.GoodsId,
            Object_Price.MCSValue,
            Object_Price.Price,
            MovementItemSaved.Id,
            MovementItemSaved.Amount,
            Object_Price.MCSValue,
            Object_Goods_View.MinimumLot,
            tmpMI_Send.Amount,
            Income.Amount_Income,
            tmpMI_OrderExternal.Amount
        HAVING CASE WHEN Object_Price.MCSValue >= 0.1 AND Object_Price.MCSValue < 10 AND 1 >= CEIL (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                         THEN CEIL  (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                    WHEN Object_Price.MCSValue >= 10 AND 1 >= CEIL (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                         THEN ROUND  (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0)- COALESCE (tmpMI_OrderExternal.Amount,0))
                    ELSE FLOOR (Object_Price.MCSValue - SUM (COALESCE (Container.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
               END > 0
       ) AS tmp;


-- RAISE EXCEPTION 'ok' ;


        -- Пересчитываем ручное количество для строк с авторасчетом
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
 12.06.17         *
 27.12.16         * add tmpMI_OrderExternal.Amount
 15.03.16         * add Object_Goods_View.IsClose = FALSE  
 02.02.16                                        * add MovementItem_Income.isErased = FALSE
 29.08.15                                                                        * ObjectPrice.MCSIsClose = False
 31.07.15                                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternalMCS (inUnitId := 183292, inNeedCreate:= True, inSession:= '3')
