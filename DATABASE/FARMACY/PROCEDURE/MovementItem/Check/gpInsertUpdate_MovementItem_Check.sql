-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check(Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
   OUT outMovementItemId     Integer   , -- Ид Строки
   OUT outAmount             TFloat    , -- кол-во в чеке
   OUT outSumm               TFloat    , -- Сумма в чеке
   OUT outRemains            TFloat    , -- Остаток после вставки в чек
   OUT outTotalSummCheck     TFloat    , -- итоговая сумма в чеке
   OUT outNDS                TFloat    , --Ставка НДС
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbRemains TFloat;
   DECLARE vbAmount_Reserve TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := inSession;

    -- Находим элемент по документу и товару
    SELECT Id, Amount INTO outMovementItemId, outAmount 
    FROM MovementItem
    WHERE MovementId = inMovementId 
      AND ObjectId = inGoodsId 
      AND DescId = zc_MI_Master();
     
    --Общее кол-во товара в чеке  
    outAmount := COALESCE(outAmount, 0) + inAmount;
    --на всякий случай срезаем колво в 0 если меньше 0    
    IF outAmount < 0 
    THEN
        outAmount := 0;
    END IF;
    --Общая сумма в чеке
    outSumm := (outAmount*inPrice)::NUMERIC (16, 2);
    
    -- Находим подразделение из документа
    Select ObjectId INTO vbUnitId
    FROM MovementLinkObject
    WHERE MovementId = inMovementId
      AND DescId = zc_MovementLinkObject_Unit();

    --Вытянуть текущий остаток
    SELECT
        SUM(MovementItem_Reserve.Amount)::TFloat INTO vbAmount_Reserve
    FROM
        gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
    WHERE
        MovementItem_Reserve.MovementId <> inMovementId
        AND
        MovementItem_Reserve.GoodsId = inGoodsId;
        
    SELECT (SUM(Container.Amount) - COALESCE(vbAmount_Reserve,0))::TFloat INTO outRemains
    FROM 
        Container
        INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                       ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                      AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                      AND ContainerLinkObject_Unit.ObjectId = vbUnitId
    WHERE
        Container.DescId = zc_Container_Count()
        AND
        Container.ObjectId = inGoodsId
        AND
        Container.Amount <> 0;

    
    IF COALESCE(outRemains,0) < outAmount
    THEN
        RAISE EXCEPTION 'Ошибка. Не хватает количества <%> для продажи <%>',outRemains,outAmount;
    END IF;
    
    outRemains := COALESCE(outRemains,0)-outAmount;
    
    -- сохранили <Элемент документа>
    outMovementItemId := lpInsertUpdate_MovementItem (outMovementItemId, zc_MI_Master(), inGoodsId, inMovementId, outAmount, NULL);

    IF inAmount > 0 THEN
        -- сохранили свойство <Цена>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), outMovementItemId, inPrice);
    END IF;
     
    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);
    
    --Достали итогувую сумму по чеку
    SELECT
        MovementFloat.ValueData
    INTO
        outTotalSummCheck
    FROM
        MovementFloat
    WHERE
        MovementFloat.MovementId = inMovementId
        AND
        MovementFloat.DescId = zc_MovementFloat_TotalSumm();

    --достали ставку НДС для товара
    SELECT ObjectFloat_NDSKind_NDS.ValueData INTO outNDS
    FROM 
        ObjectLink AS ObjectLink_Goods_NDSKind
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
    WHERE ObjectLink_Goods_NDSKind.ObjectId = inGoodsId
      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind();
        
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check(Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 07.08.2015                                                                      *
 26.05.15                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
