-- Function: gpInsertUpdate_Movement_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_UnnamedEnterprises (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TFloat, TVarChar, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_UnnamedEnterprises(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inUnitId                Integer    , -- От кого (подразделение)
    IN inClientsByBankId       Integer    , -- Кому (покупатель)
    IN inComment               TVarChar   , -- Примечание
    IN inAmountAccount         TFloat     , -- Сумма в счёте
    IN inAccountNumber         TVarChar   , -- Номер счёта
    IN inAmountPayment         TFloat     , -- Сумма оплаты
    IN inDatePayment           TDateTime  , -- Дата оплаты
   OUT outDatePayment          TDateTime  , -- Дата оплаты
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_UnnamedEnterprises());
    vbUserId := inSession;

    IF EXISTS(SELECT 1 FROM MovementLinkMovement
              WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
                AND MovementLinkMovement.MovementId = ioId)
    THEN
      RAISE EXCEPTION 'Ошибка. По безналу предприятия создана продежа <%> от <%>...',
        (SELECT Movement.InvNumber
         FROM MovementLinkMovement
              INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
         WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
           AND MovementLinkMovement.MovementId = ioId),
        (SELECT to_char(Movement.OperDate, 'DD-MM-YYYY')
         FROM MovementLinkMovement
              INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
         WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
           AND MovementLinkMovement.MovementId = ioId);
    END IF;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_UnnamedEnterprises (ioId          := ioId
                                        , inInvNumber       := inInvNumber
                                        , inOperDate        := inOperDate
                                        , inUnitId          := inUnitId
                                        , inClientsByBankId := inClientsByBankId
                                        , inComment         := inComment
                                        , inAmountAccount   := inAmountAccount
                                        , inAccountNumber   := inAccountNumber
                                        , inAmountPayment   := inAmountPayment
                                        , inDatePayment     := inDatePayment
                                        , inUserId          := vbUserId
                                        );
    IF EXISTS(SELECT 1 FROM MovementDate
              WHERE MovementId = ioId
                AND DescId = zc_MovementDate_DatePayment())
    THEN
        SELECT ValueData
        INTO outDatePayment
        FROM MovementDate
        WHERE MovementId = ioId
          AND DescId = zc_MovementDate_DatePayment();
    ELSE
        outDatePayment := Null::TDateTime;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 16.11.18         *
 30.09.18         *
*/