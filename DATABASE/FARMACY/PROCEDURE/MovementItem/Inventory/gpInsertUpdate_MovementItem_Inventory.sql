-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inGoodsId             Integer   , -- Товары
 INOUT ioAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inComment             TVarChar  , -- Комментарий
   OUT outSumm               TFloat    , -- Сумма
   OUT outRemains            TFloat    , -- Остаток на дату документа
   OUT outDeficit            TFloat    , -- недостача
   OUT outDeficitSumm        TFloat    , -- сумма недостачи
   OUT outProficit           TFloat    , -- излишек
   OUT outProficitSumm       TFloat    , -- сумма излишка
   OUT outDiff               TFloat    , -- разница
   OUT outDiffSumm           TFloat    , -- сумма разницы
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
	
    --определяем подразделение и дату документа, ИД строки
    SELECT 
        Movement.OperDate
       ,MLO_Unit.ObjectId
       ,MovementItem.Id
    INTO
        vbOperDate
       ,vbUnitId
       ,ioId
    FROM
        Movement
        INNER JOIN MovementLinkObject AS MLO_Unit
                                      ON MLO_Unit.MovementId = Movement.Id
                                     AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT OUTER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.ObjectId = inGoodsId
    WHERE
        Movement.Id = inMovementId;
    -- Находим остаток товара на дату
    SELECT 
        COALESCE(SUM(DD.Amount),0)::TFloat
    INTO
        outRemains
    FROM(
            SELECT
                Container.Id
               ,Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0) as  Amount
            FROM
                Container
                Inner Join ContainerLinkObject AS CLO_Unit
                                               ON CLO_Unit.ContainerId = Container.Id
                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                              AND CLO_Unit.ObjectId = vbUnitId
                LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                     AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                     AND DATE_TRUNC('day', MovementItemContainer.OperDate) > DATE_TRUNC('day', vbOperDate)
            WHERE
                Container.DescId = zc_Container_Count()
                AND
                Container.ObjectId = inGoodsId
            Group By
                Container.Id
               ,Container.Amount
        ) AS DD;
        
    -- Расчитываем сумму по строке
	outSumm := (ioAmount * inPrice)::TFloat;
    
    IF COALESCE(outRemains,0) > COALESCE(ioAmount,0)
    THEN
        outDeficit := COALESCE(outRemains,0) - COALESCE(ioAmount,0); -- недостача
        outDeficitSumm := (COALESCE(outRemains,0) - COALESCE(ioAmount,0))*inPrice::TFloat;
    END IF;
    IF COALESCE(outRemains,0) < COALESCE(ioAmount,0)
    THEN
        outProficit := COALESCE(ioAmount,0) - COALESCE(outRemains,0); -- Излишек
        outProficitSumm := ((COALESCE(ioAmount,0) - COALESCE(outRemains,0))*inPrice)::TFloat;
    END IF;
    outDiff := COALESCE(ioAmount,0) - COALESCE(outRemains,0); --разница
    outDiffSumm := ((COALESCE(ioAmount,0) - COALESCE(outRemains,0))*inPrice)::TFloat;    -- сумма разницы
    
    -- сохранили
    ioId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE(ioId,0)
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := inGoodsId
                                                , inAmount             := ioAmount
                                                , inPrice              := inPrice
                                                , inSumm               := outSumm
                                                , inComment            := inComment
                                                , inUserId             := vbUserId) AS tmp;
    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
  11.07.15                                                                    *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 0, inGoodsId:= 1, ioAmount:= 0, inSession:= '2')
