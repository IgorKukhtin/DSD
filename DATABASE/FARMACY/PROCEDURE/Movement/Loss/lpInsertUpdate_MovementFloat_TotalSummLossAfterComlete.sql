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
            SUM(-MovementItemContainer.Amount * MIFloat_Income_Price.ValueData)
        INTO
            vbTotalSummLoss
        FROM 
            MovementItemContainer 
            LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                                ON CLI_MI.containerid = MovementItemContainer.ContainerId
                                               AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
            LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                                  ON MIFloat_Income_Price.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                 AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
        WHERE MovementItemContainer.MovementId = inMovementId
          AND MovementItemContainer.DescId = zc_MIContainer_Count();
    END IF; 

    -- Сохранили свойство <Итого Сумма приход>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummLoss);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummLossAfterComplete (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 20.07.15                                                         * 
*/
