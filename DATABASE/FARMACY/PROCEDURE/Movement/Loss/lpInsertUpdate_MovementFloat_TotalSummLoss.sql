-- Function: lpInsertUpdate_MovementFloat_TotalSummLossAfterComplete (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummLossAfterComplete (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummLossAfterComplete(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalSummLoss     TFloat;
  
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    IF NOT EXISTS(Select 1 from Movement Where Id = inMovementId AND StatusId = zc_Enum_Status_Complete())
    THEN
        vbTotalSummLoss := 0;
    ELSE
        SELECT
            SUM(CASE WHEN MovementItemContainer.Amount <> 0 
                                    THEN -MovementItemContainer.Amount * COALESCE(NULLIF(MIFloat_PriceIn.ValueData, 0) , MIFloat_Income_Price.ValueData) END)
        INTO
            vbTotalSummLoss
        FROM 
            MovementItemContainer 
            LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                ON CLI_MI.containerid = MovementItemContainer.ContainerId
                                               AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

            -- элемент прихода
            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

            LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                              ON MIFloat_Income_Price.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id) 
                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_PriceWithVAT()

            LEFT JOIN MovementItemFloat AS MIFloat_PriceIn
                                        ON MIFloat_PriceIn.MovementItemId = MovementItemContainer.MovementItemId
                                       AND MIFloat_PriceIn.DescId = zc_MIFloat_PriceIn()          
                                             
        WHERE MovementItemContainer.MovementId = inMovementId
          AND MovementItemContainer.DescId = zc_MIContainer_Count();
    END IF; 

    -- Сохранили свойство <Итого Сумма приход>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummLoss);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummLossAfterComplete (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий О.В.
 17.02.20                                                                       * 
 20.07.15                                                         * 
*/


SELECT * FROM lpInsertUpdate_MovementFloat_TotalSummLossAfterComplete(34124891)