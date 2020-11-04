-- Function: gpInsertUpdate_MovementItem_Payment()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Payment(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inIncomeId            Integer   , -- Ключ документа <приходная накладная>
 INOUT ioBankAccountId       Integer   , -- Ключ обьекта <Расчетный счет>
   OUT outBankAccountName    TVarChar  , -- название обьекта <Расчетный счет>
   OUT outBankName           TVarChar  , -- Наименование банка
    IN inIncome_PaySumm      TFloat    , -- Сумма остатка по накладной
 INOUT ioSummaPay            TFloat    , -- Сумма платежа
    IN inSummaCorrBonus      TFloat    , -- Сумма Корректировки долга по бонусу
    IN inSummaCorrReturnOut  TFloat    , -- Сумма Корректировки долга по возвратам
    IN inSummaCorrOther      TFloat    , -- Сумма Корректировки долга по прочим причинам
    IN inSummaCorrPartialPay     TFloat    , -- Сумма оплаты частями
 INOUT ioNeedPay             Boolean   , -- Нужно платить
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyId Integer;
   DECLARE vbOldSummaPay TFloat;
   DECLARE vbSummaCorrPartialPay TFloat;
   DECLARE vbJuridicalId Integer;
   DECLARE vbFromId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Payment());
    vbUserId := inSession;
    --проверили расчетный счет
    SELECT Object_BankAccount.Id
          ,Object_BankAccount.Name
          ,Object_BankAccount.BankName
          ,Object_BankAccount.CurrencyId
           INTO ioBankAccountId
               ,outBankAccountName
               ,outBankName
               ,vbCurrencyId
    FROM Object_BankAccount_View AS Object_BankAccount
    WHERE (Object_BankAccount.Id = COALESCE (ioBankAccountId, 0)
        OR COALESCE(ioBankAccountId,0) = 0
          )
        AND JuridicalId = (Select Movement_Payment_View.JuridicalId from Movement_Payment_View Where Movement_Payment_View.Id = inMovementId)
        AND isErased = FALSE
     ;


    IF COALESCE(ioBankAccountId) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Для юрлица <%> не создано ни одного расчетного счета',(Select Movement_Payment_View.JuridicalName from Movement_Payment_View Where Movement_Payment_View.Id = inMovementId);
    END IF;
    --расчитали сумму остатка по платежу
    SELECT
        MovementItem.Amount
    INTO
        vbOldSummaPay
    FROM
        MovementItem
    WHERE
        MovementItem.Id = ioId;

    IF COALESCE(inSummaCorrPartialPay, 0) <> 0
    THEN

      SELECT MLO_From.ObjectId
      INTO vbFromId
      FROM MovementLinkObject AS MLO_From
      WHERE MLO_From.MovementId = inIncomeId
        AND MLO_From.DescId = zc_MovementLinkObject_From();

      SELECT MLO_Juridical.ObjectId
      INTO vbJuridicalId
      FROM MovementLinkObject AS MLO_Juridical
      WHERE MLO_Juridical.MovementId = inMovementId
        AND MLO_Juridical.DescId = zc_MovementLinkObject_Juridical();

      SELECT Container.Amount
      INTO vbSummaCorrPartialPay
      FROM ContainerLinkObject AS CLO_JuridicalBasis
           INNER JOIN Container ON Container.Id =  CLO_JuridicalBasis.ContainerId
                               AND Container.DescId = zc_Container_SummIncomeMovementPayment()
                               AND Container.Amount <> 0
           LEFT JOIN ContainerLinkObject AS CLO_Juridical
                                         ON CLO_Juridical.ContainerId = Container.Id
                                        AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
      WHERE CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
        AND CLO_JuridicalBasis.ObjectId = vbJuridicalId
        AND Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_PartialSale()
        AND CLO_Juridical.ObjectId = vbFromId;


      vbSummaCorrPartialPay := vbSummaCorrPartialPay - COALESCE ((
        SELECT SUM (COALESCE (MIFloat_CorrPartialSale.ValueData, 0))
        FROM MovementItem
             INNER JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                            ON MIBoolean_NeedPay.MovementItemId = MovementItem.Id
                                           AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
                                           AND MIBoolean_NeedPay.ValueData = TRUE

             INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                          ON MIFloat_MovementId.MovementItemid = MovementItem.Id
                                         AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
             LEFT JOIN MovementLinkObject AS Movement_From
                                          ON Movement_From.MovementId = MIFloat_MovementId.ValueData :: Integer
                                         AND Movement_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

             LEFT JOIN MovementItemFloat AS MIFloat_CorrPartialSale
                                         ON MIFloat_CorrPartialSale.MovementItemId = MovementItem.Id
                                        AND MIFloat_CorrPartialSale.DescId = zc_MIFloat_CorrPartialPay()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId = zc_MI_Master()
           AND MovementItem.IsErased = FALSE
           AND MovementItem.Id <> COALESCE (ioId, 0)
           AND Movement_From.ObjectId = vbFromId), 0);

      IF COALESCE (vbSummaCorrPartialPay, 0) <= 0
      THEN
          RAISE EXCEPTION 'Ошибка! Не найдена изменение долга по приходам поставщика с типом <Частичная продажа>.';
      END IF;

      IF inSummaCorrPartialPay > vbSummaCorrPartialPay
      THEN
          RAISE EXCEPTION 'Ошибка! Общая сумма платежа частями больше остатка для оплаты частями..';
      END IF;

      IF inSummaCorrPartialPay > COALESCE(inIncome_PaySumm,0)-COALESCE(inSummaCorrBonus,0)-COALESCE(inSummaCorrReturnOut,0)-COALESCE(inSummaCorrOther,0)
      THEN
          RAISE EXCEPTION 'Ошибка! Общая сумма платежа не должна превышать долг по накладной.';
      END IF;

      ioSummaPay := inSummaCorrPartialPay;
    ELSE
      ioSummaPay := COALESCE(inIncome_PaySumm,0)-COALESCE(inSummaCorrBonus,0)-COALESCE(inSummaCorrReturnOut,0)-COALESCE(inSummaCorrOther,0);
      IF ioSummaPay < 0
      THEN
          RAISE EXCEPTION 'Ошибка! Общая сумма платежа не должна превышать долг по накладной.';
      END IF;
    END IF;

    IF COALESCE(ioID,0) = 0
    THEN
        ioNeedPay := TRUE;
    END IF;

    -- сохранили
    ioId := lpInsertUpdate_MovementItem_Payment (ioId                   := ioId
                                               , inMovementId           := inMovementId
                                               , inIncomeId             := inIncomeId
                                               , inBankAccountId        := ioBankAccountId
                                               , inCurrencyId           := vbCurrencyId
                                               , inSummaPay             := ioSummaPay
                                               , inSummaCorrBonus       := inSummaCorrBonus
                                               , inSummaCorrReturnOut   := inSummaCorrReturnOut
                                               , inSummaCorrOther       := inSummaCorrOther
                                               , inSummaCorrPartialPay  := inSummaCorrPartialPay
                                               , inNeedPay              := ioNeedPay
                                               , inUserId               := vbUserId
                                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 13.10.15                                                                         *
*/
