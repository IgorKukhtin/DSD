-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена Усред. закуп.
    IN inPriceUnitFrom       TFloat    , -- Цена отправителя
 INOUT ioPriceUnitTo         TFloat    , -- Цена получателя
   OUT outSumma              TFloat    , -- Сумма
   OUT outSummaUnitTo        TFloat    , -- Сумма в ценах получателя
    IN inAmountManual        TFloat    , -- Кол-во ручное
    IN inAmountStorage       TFloat    , -- Факт кол-во точки-отправителя
   OUT outAmountDiff         TFloat    , -- Загружаемое кол-во  минус  Факт кол-во точки-получателя
   OUT outAmountStorageDiff  TFloat    , -- Загружаемое кол-во  минус  Факт кол-во точки-отправителя
    IN inReasonDifferencesId Integer   , -- Причина разногласия
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;

   DECLARE vbAmount        TFloat;
   DECLARE vbAmountManual  TFloat;
   DECLARE vbAmountStorage TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;

    --определяем подразделение получателя
    SELECT MovementLinkObject_To.ObjectId AS UnitId
           INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_To
    WHERE MovementLinkObject_To.MovementId = inMovementId
      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();

    -- Получаем предыдущее значение количеств
    SELECT
           SUM (MovementItem.Amount)                         AS Amount
         , SUM (COALESCE(MIFloat_AmountManual.ValueData,0))  AS AmountManual
         , SUM (COALESCE(MIFloat_AmountStorage.ValueData,0)) AS AmountStorage
    INTO vbAmount, vbAmountManual, vbAmountStorage
    FROM MovementItem
               LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                           ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
               LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                           ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()
    WHERE MovementItem.Id = ioId;


    -- Для роли "Безнал" отключаем проверки
    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_Cashless())
    THEN
      -- Для роли "Кассир аптеки"
      IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
      THEN
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;

        IF COALESCE (vbUserUnitId, 0) = 0
        THEN
          RAISE EXCEPTION 'Ошибка. Не найдено подразделение сотрудника.';
        END IF;

        --определяем подразделение отправителя
        SELECT MovementLinkObject_From.ObjectId AS vbFromId
               INTO vbFromId
        FROM MovementLinkObject AS MovementLinkObject_From
        WHERE MovementLinkObject_From.MovementId = inMovementId
          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();

        IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN
          RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);
        END IF;

        IF COALESCE (vbFromId, 0) = COALESCE (vbUserUnitId, 0)
        THEN
          IF COALESCE (vbAmountManual, 0) <> COALESCE (inAmountManual, 0)
          THEN
            RAISE EXCEPTION 'Ошибка. Изменять <Факт кол-во точки-получателя> вам запрещено.';
          END IF;
        END IF;

        IF COALESCE (vbUnitId, 0) = COALESCE (vbUserUnitId, 0)
        THEN
          IF COALESCE (vbAmount, 0) <> COALESCE (inAmount, 0) OR
           COALESCE (vbAmountStorage, 0) <> COALESCE (vbAmountStorage, 0)
          THEN
            RAISE EXCEPTION 'Ошибка. Изменять <Кол-во, загружаемое в точку-получатель> и <Факт кол-во точки-отправителя> вам запрещено.';
          END IF;
        END IF;

        IF EXISTS(SELECT 1 FROM MovementBoolean
                  WHERE MovementBoolean.MovementId = inMovementId
                    AND MovementBoolean.DescId = zc_MovementBoolean_isAuto()
                    AND MovementBoolean.ValueData = TRUE)
        THEN

          IF COALESCE (ioId, 0) = 0 OR EXISTS(SELECT 1 FROM MovementItem
                                              WHERE MovementItem.ID = ioId
                                                AND MovementItem.Amount < inAmount)
          THEN
            RAISE EXCEPTION 'Ошибка. Увеличивать количество в автоматически сформированных перемещениях вам запрещено.';
          END IF;
        END IF;

      END IF;

      -- Для менеджеров
      IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
      THEN

        IF COALESCE (vbAmountManual, 0) <> COALESCE (inAmountManual, 0) OR
         COALESCE (vbAmountStorage, 0) <> COALESCE (inAmountStorage, 0)
        THEN
          RAISE EXCEPTION 'Ошибка. Изменять <Факт кол-во точки-получателя> и <Факт кол-во точки-отправителя> вам запрещено.';
        END IF;
      END IF;
    END IF;

    --если цена получателя = 0 заменяем ее на цену отвравителя и записываем в прайс
    IF COALESCE (ioPriceUnitTo, 0) = 0 AND COALESCE (inPriceUnitFrom, 0) <> 0
    THEN
        ioPriceUnitTo := inPriceUnitFrom;

        --переоценить товар
        PERFORM lpInsertUpdate_Object_Price(inGoodsId := inGoodsId,
                                            inUnitId  := vbUnitId,
                                            inPrice   := ioPriceUnitTo,
                                            inDate    := CURRENT_DATE::TDateTime,
                                            inUserId  := vbUserId);
    END IF;

    --Посчитали сумму
    outSumma := ROUND(inAmount * inPrice, 2);
    outAmountDiff := COALESCE (inAmountManual,0) - COALESCE (inAmount,0);
    outAmountStorageDiff := COALESCE (inAmountStorage,0) - COALESCE (inAmount,0);

    outSummaUnitTo := ROUND(inAmount * ioPriceUnitTo, 2);


    IF outAmountDiff = 0
    THEN
        inReasonDifferencesId := 0;
    END IF;

     -- сохранили
    ioId := lpInsertUpdate_MovementItem_Send (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inAmountManual       := inAmountManual
                                            , inAmountStorage      := inAmountStorage
                                            , inReasonDifferencesId:= inReasonDifferencesId
                                            , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 01.04.19                                                                      *
 05.02.19         * add inAmountStorage
 19.12.18                                                                      *
 07.09.17         *
 28.06.16         *
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')