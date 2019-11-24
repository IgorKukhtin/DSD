-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnOut(Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inParentId            Integer   , -- ссылка на родителя
   OUT outSumm               TFloat    , -- Сумма
   OUT outAmountInIncome     TFloat    , -- кол-во в приходе
   OUT outRemains            TFloat    , -- Остаток по приходу
   OUT outWarningColor       Integer   , -- Выделение крассным, если кол-во > остатка 
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementIncomeId Integer;
   DECLARE vbAmountIncome TFloat;
   DECLARE vbAmountOther TFloat;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     --vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnOut());
     
     IF COALESCE(inAmount, 0) > 0
     THEN

        --Номер прихода
       SELECT Movement.ParentId 
       INTO vbMovementIncomeId
       FROM Movement
       WHERE Movement.Id = inMovementId;

       SELECT SUM(MI_ReturnOut.Amount)::TFloat AS Amount
       INTO vbAmountOther
       FROM Movement AS Movement_ReturnOut
            INNER JOIN MovementItem AS MI_ReturnOut
                                    ON MI_ReturnOut.MovementId = Movement_ReturnOut.Id
                                   AND MI_ReturnOut.isErased   = FALSE
                                   AND MI_ReturnOut.DescId     = zc_MI_Master()
       WHERE Movement_ReturnOut.Id <> inMovementId
         AND Movement_ReturnOut.ParentId = vbMovementIncomeId
         AND Movement_ReturnOut.StatusId <> zc_Enum_Status_Erased()
         AND Movement_ReturnOut.DescId = zc_Movement_ReturnOut()
         AND MI_ReturnOut.ParentId = inParentId;

       SELECT MovementItem.Amount
       INTO vbAmountIncome
       FROM MovementItem 
       WHERE MovementItem.Id = inParentId;
                 
       IF inAmount > (COALESCE(vbAmountIncome, 0) - COALESCE(vbAmountOther, 0)) 
       THEN
         RAISE EXCEPTION 'Ошибка.Вы возвращаете <%> в приходе <%> в других возвратах <%> можно вернуть не более <%>.', 
           inAmount, COALESCE(vbAmountIncome, 0), COALESCE(vbAmountOther, 0), COALESCE(vbAmountIncome, 0) - COALESCE(vbAmountOther, 0);             
       END IF;
     END IF;
     
     outSumm := (inAmount*inPrice)::TFloat;
     
     ioId := lpInsertUpdate_MovementItem_ReturnOut(ioId, inMovementId, inGoodsId, inAmount, inPrice, inParentId, vbUserId);

    SELECT
        MovementItem.Amount
       ,Container.Amount
       ,CASE 
          WHEN inAmount > COALESCE(MovementItem.Amount,0) or
               inAmount > COALESCE(Container.Amount,0)
            THEN zc_Color_Warning_Red()
        END       
    INTO
        outAmountInIncome
       ,outRemains
       ,outWarningColor
    FROM 
        MovementItem
        LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.MovementItemId = MovementItem.Id
                                             AND MovementItemContainer.DescId = zc_MIContainer_Count()
        LEFT OUTER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                 AND Container.DescId = zc_Container_Count() 
    WHERE 
        MovementItem.Id = inParentId;
     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.02.15                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
