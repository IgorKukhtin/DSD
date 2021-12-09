-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Pretension(Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Pretension(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- ссылка на родителя
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inReasonDifferencesId Integer   , -- причину разногласия
    IN inAmountIncome        TFloat    , -- Количество приход
    IN inAmountManual        TFloat    , -- Факт. кол-во
    IN inPrice               TFloat    , -- Цена
    IN inCheckedName         TVarChar  , -- Состояние
   OUT outSumm               TFloat    , -- Сумма по притензии
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
   DECLARE vbisChecked Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     --vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Pretension());
     
     vbisChecked := 'Актуальна' = inCheckedName;
     
     IF COALESCE(inAmount, 0) > 0
     THEN

        --Номер прихода
       SELECT Movement.ParentId 
       INTO vbMovementIncomeId
       FROM Movement
       WHERE Movement.Id = inMovementId;

       SELECT SUM(MI_Pretension.Amount)::TFloat AS Amount
       INTO vbAmountOther
       FROM Movement AS Movement_Pretension
            INNER JOIN MovementItem AS MI_Pretension
                                    ON MI_Pretension.MovementId = Movement_Pretension.Id
                                   AND MI_Pretension.isErased   = FALSE
                                   AND MI_Pretension.DescId     = zc_MI_Master()
       WHERE Movement_Pretension.Id <> inMovementId
         AND Movement_Pretension.ParentId = vbMovementIncomeId
         AND Movement_Pretension.StatusId <> zc_Enum_Status_Erased()
         AND Movement_Pretension.DescId = zc_Movement_Pretension()
         AND MI_Pretension.ParentId = inParentId;

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
     
     outSumm := (inAmount * inPrice)::TFloat;
     
     ioId := lpInsertUpdate_MovementItem_Pretension(ioId, inMovementId, inParentId, inGoodsId, inAmount, inReasonDifferencesId, inAmountIncome, inAmountManual, vbisChecked, vbUserId);

    SELECT
        Container.Amount
       ,CASE 
          WHEN inAmount > COALESCE(MovementItem.Amount,0) or
               inAmount > COALESCE(Container.Amount,0)
            THEN zc_Color_Warning_Red()
        END       
    INTO
        outRemains
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
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_Pretension (inMovementId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.12.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')