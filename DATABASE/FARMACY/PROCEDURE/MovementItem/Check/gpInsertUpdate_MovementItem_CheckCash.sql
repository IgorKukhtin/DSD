 -- Function: gpInsertUpdate_MovementItem_CheckCash()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_CheckCash (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_CheckCash(
 INOUT ioId                  Integer   , -- Ключ объекта <строка документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
   OUT outPriceSale          TFloat    , -- Цена без скидки
   OUT outSummChangePercent  TFloat    , -- SummChangePercent
   OUT outSumm               TFloat    , -- Сумма
   OUT outSummSale           TFloat    , -- Сумма без скидки
   OUT outIsSp               Boolean   , --
   OUT outColor_calc         integer   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceSale TFloat;
   DECLARE vbChangePercent TFloat;
   DECLARE vbSummChangePercent TFloat;
   DECLARE vbUnitId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    --определяем признак участвует в соц.проекте, по шапке док.
    outIsSp:= COALESCE (
             (SELECT CASE WHEN COALESCE(MovementString_InvNumberSP.ValueData,'') <> '' OR
                                COALESCE(MovementString_MedicSP.ValueData,'') <> '' OR
                                COALESCE(MovementString_MemberSP.ValueData,'') <> '' OR
                               -- COALESCE(MovementDate_OperDateSP.ValueData,Null) <> Null OR
                                COALESCE(MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 THEN True
                           ELSE FALSE
                      END
              FROM Movement
                          LEFT JOIN MovementString AS MovementString_InvNumberSP
                                 ON MovementString_InvNumberSP.MovementId = Movement.Id
                                AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                          LEFT JOIN MovementString AS MovementString_MedicSP
                                 ON MovementString_MedicSP.MovementId = Movement.Id
                                AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                          LEFT JOIN MovementString AS MovementString_MemberSP
                                 ON MovementString_MemberSP.MovementId = Movement.Id
                                AND MovementString_MemberSP.DescId = zc_MovementString_MemberSP()
                          LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                 ON MovementDate_OperDateSP.MovementId = Movement.Id
                                AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                  ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                 AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Sale())
              , False)  :: Boolean ;

    -- проверку на 1 товар вдокументе добавили в проведение
    -- если  признак участвует в соц.проекте = TRUE . то в док. должна быть 1 строка
    IF outIsSp = TRUE
    THEN
         IF (SELECT COUNT(*) FROM MovementItem
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.Id <> ioId
               AND MovementItem.IsErased = FALSE
               AND MovementItem.Amount > 0) >= 1
            THEN
                 RAISE EXCEPTION 'Ошибка.В документе может быть только 1 препарат.';
            END IF;
    END IF;

    -- Находим элемент по документу и товару
    IF COALESCE (ioId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = ioId)
    THEN
        IF COALESCE (inPrice, 0) = 0
        THEN
            -- задваивает, зараза, поэтому на этот случай - ТАК
            ioId:= (SELECT MovementItem.Id
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND COALESCE (MIFloat_Price.ValueData, 0) = inPrice
                   );
        ELSE
            ioId:= (SELECT MovementItem.Id
                    FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                     AND MIFloat_Price.ValueData = inPrice
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                   );
        END IF;
        -- если не нашли позицию с нужной ценой, ищем любую другую позицию
        IF COALESCE(ioID, 0) = 0
        THEN
            ioId:= (SELECT MovementItem.Id
                    FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                     -- отложенные чеки с измененной ценой дублируются
                                                     -- AND MIFloat_Price.ValueData = inPrice
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                    LIMIT 1
                   );
        END IF;

    END IF;

    IF inAmount < 0
    THEN
        RAISE EXCEPTION 'Количество должно быть положительным или равно нолю.';
    END IF;      

     -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    IF vbIsInsert
    THEN
      -- сохранили свойство <Цена>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

      vbChangePercent := 0;
      vbSummChangePercent := 0;

      -- !!!замена!!!
      IF COALESCE (vbChangePercent, 0) = 0
      THEN
        vbPriceSale:= inPrice;
      ELSE
        vbPriceSale:= Round(inPrice * (100.0 - vbChangePercent) / 100.0, 2);
      END IF;
      -- сохранили свойство <Цена без скидки>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, vbPriceSale);

      -- сохранили свойство <% Скидки>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, vbChangePercent);

      -- сохранили свойство <Сумма Скидки>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, CASE WHEN inAmount = 0 THEN 0 ELSE vbSummChangePercent END);

      -- сохранили свойство <UID строки продажи>
      -- PERFORM lpInsertUpdate_MovementItemString (zc_MIString_UID(), ioId, inList_UID);

    END IF;

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

     -- определяется подразделение
     SELECT MovementLinkObject_Unit.ObjectId
     INTO vbUnitId
     FROM MovementLinkObject AS MovementLinkObject_Unit
     WHERE MovementLinkObject_Unit.MovementId = inMovementId
       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

    -- Получили данные по строчке
    SELECT
      MovementItem_Check.PriceSale,
      MovementItem_Check.SummChangePercent,
      MovementItem_Check.AmountSumm,
      (MovementItem_Check.PriceSale * MovementItem_Check.Amount)::TFloat,
      CASE WHEN COALESCE((SELECT SUM(Container.Amount)
                              FROM Container
                              WHERE Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.ObjectId = inGoodsId
                                AND Container.Amount <> 0), 0) < inAmount 
        THEN zc_Color_Red() ELSE zc_Color_White() END  AS Color_calc
    INTO
      outPriceSale,
      outSummChangePercent,
      outSumm,
      outSummSale,
      outColor_calc
    FROM MovementItem_Check_View AS MovementItem_Check
    WHERE MovementItem_Check.Id =  ioId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_CheckCash (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Шаблий О.В.
 06.10.18       *
*/