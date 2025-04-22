-- Function: lpInsertUpdate_Movement_Invoice()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Invoice(
 INOUT ioId               Integer  ,  --
    IN inParentId         Integer  ,  --
    IN inInvNumber        TVarChar ,  -- Номер документа
    IN inOperDate         TDateTime,  --
    IN inPlanDate         TDateTime,  -- Плановая дата оплаты по Счету
    IN inVATPercent       TFloat   ,  --
    IN inAmount           TFloat   ,  --
    IN inInvNumberPartner TVarChar ,  -- Номер документа - External Nr
    IN inReceiptNumber    TVarChar ,  -- Официальный номер квитанции - Quittung Nr, формируется только для Amount>0
    IN inComment          TVarChar ,  --
    IN inObjectId         Integer  ,  --
    IN inUnitId           Integer  ,  --
    IN inInfoMoneyId      Integer  ,  --
    IN inPaidKindId       Integer  ,  --
    IN inInvoiceKindId    Integer  ,  
    IN inTaxKindId        Integer  ,  --
    IN inUserId           Integer      -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка - свойство должно быть установлено
     IF COALESCE (inObjectId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Lieferanten / Kunden>.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inInfoMoneyId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено <Название назначения>.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inInvoiceKindId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Тип счета>.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inTaxKindId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Вид НДС>.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF inAmount < 0 AND inInvoiceKindId IN (zc_Enum_InvoiceKind_Pay(), zc_Enum_InvoiceKind_PrePay())
     THEN
        RAISE EXCEPTION 'Ошибка.Для счета <%> заполнено значение <Кредит> = <%>.%Можно установить только значение <Дебет>.'
                      , lfGet_Object_ValueData_sh (inTaxKindId)
                      , zfConvert_FloatToString (-1  * inAmount)
                      , CHR (13)
                       ;
     END IF;

     -- проверка - один счет на лодку
     IF inParentId > 0 AND inInvoiceKindId = zc_Enum_InvoiceKind_Pay()
        AND EXISTS (SELECT 1
                    FROM Movement 
                         INNER JOIN MovementLinkObject AS MLO_InvoiceKind
                                                       ON MLO_InvoiceKind.MovementId = Movement.Id
                                                      AND MLO_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                      AND MLO_InvoiceKind.ObjectId   = inInvoiceKindId
                    WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_Invoice() AND Movement.StatusId <> zc_Enum_Status_Erased()
                      AND Movement.Id <> COALESCE (ioId, 0)
                   )
        AND NOT EXISTS (SELECT 1
                        FROM Movement 
                             INNER JOIN MovementLinkObject AS MLO_InvoiceKind
                                                           ON MLO_InvoiceKind.MovementId = Movement.Id
                                                          AND MLO_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                          AND MLO_InvoiceKind.ObjectId   = zc_Enum_InvoiceKind_Return()
                        WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_Invoice() AND Movement.StatusId = zc_Enum_Status_Complete()
                       )
     THEN
         RAISE EXCEPTION 'Ошибка.Для Заказ клиента № <%> %уже создан счет № <%> от <%>.%Дублирование запрещено.'
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inParentId)
                        , CHR (13)
                        , (SELECT CASE WHEN MS_ReceiptNumber.ValueData <> '' THEN MS_ReceiptNumber.ValueData ELSE '*' || Movement.InvNumber END
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MLO_InvoiceKind
                                                              ON MLO_InvoiceKind.MovementId = Movement.Id
                                                             AND MLO_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                             AND MLO_InvoiceKind.ObjectId   = inInvoiceKindId
                                LEFT JOIN MovementString AS MS_ReceiptNumber ON MS_ReceiptNumber.MovementId = Movement.Id AND MS_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
                           WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_Invoice() AND Movement.StatusId <> zc_Enum_Status_Erased()
                             AND Movement.Id <> COALESCE (ioId, 0)
                           LIMIT 1
                          )
                        , (SELECT zfConvert_DateToString (Movement.OperDate)
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MLO_InvoiceKind
                                                              ON MLO_InvoiceKind.MovementId = Movement.Id
                                                             AND MLO_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                             AND MLO_InvoiceKind.ObjectId   = inInvoiceKindId
                           WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_Invoice() AND Movement.StatusId <> zc_Enum_Status_Erased()
                             AND Movement.Id <> COALESCE (ioId, 0)
                           LIMIT 1
                          )
                        , CHR (13)
                         ;
     END IF;


     -- Проверка
     IF COALESCE (inVATPercent, 0) <> COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                 FROM ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 WHERE ObjectFloat_TaxKind_Value.ObjectId = inTaxKindId
                                                   AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()
                                                ), 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Значение % НДС = <%> в документе Счет % не соответствует значению у клиента Вид НДС = <%> и % НДС  = <%>.'
                       , '%'
                       , zfConvert_FloatToString (inVATPercent)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inTaxKindId)
                       , '%'
                       , zfConvert_FloatToString (COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                             FROM ObjectFloat AS ObjectFloat_TaxKind_Value
                                                             WHERE ObjectFloat_TaxKind_Value.ObjectId = inTaxKindId
                                                               AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()
                                                            ), 0))
                        ;
     END IF;


    -- inReceiptNumber формируется только для Amount > 0
    IF (COALESCE (inAmount, 0) < 0
    AND inInvoiceKindId NOT IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Pay(), zc_Enum_InvoiceKind_Return(), zc_Enum_InvoiceKind_ReturnPay())
       )
    OR inInvoiceKindId = zc_Enum_InvoiceKind_Proforma()
    OR (COALESCE (inParentId, 0) = 0 AND COALESCE (inAmount, 0) < 0)

    THEN
        inReceiptNumber := NULL;
    ELSE
        -- если такой номер уже найден, т.е. параллельно добавили
        IF TRIM (inReceiptNumber) IN ('', '0')
         OR EXISTS (SELECT 1
                   FROM MovementString
                        JOIN Movement ON Movement.Id       = MovementString.MovementId
                                     AND Movement.DescId   = zc_Movement_Invoice()
                                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                        INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                      ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                     AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                                                     AND MovementLinkObject_InvoiceKind.ObjectId IN (SELECT tmp.InvoiceKindId
                                                                                                     FROM (SELECT zc_Enum_InvoiceKind_PrePay() AS InvoiceKindId
                                                                                                          UNION 
                                                                                                           SELECT zc_Enum_InvoiceKind_Return() AS InvoiceKindId
                                                                                                           ) AS tmp
                                                                                                     WHERE inInvoiceKindId IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Return())
                                                                                                    UNION 
                                                                                                     SELECT tmp.InvoiceKindId
                                                                                                     FROM (SELECT zc_Enum_InvoiceKind_Pay() AS InvoiceKindId
                                                                                                          UNION 
                                                                                                           SELECT zc_Enum_InvoiceKind_ReturnPay() AS InvoiceKindId
                                                                                                          UNION 
                                                                                                           SELECT zc_Enum_InvoiceKind_Service() AS InvoiceKindId
                                                                                                           ) AS tmp
                                                                                                     WHERE inInvoiceKindId IN (zc_Enum_InvoiceKind_Pay(), zc_Enum_InvoiceKind_ReturnPay(), zc_Enum_InvoiceKind_Service())
                                                                                                    )
                   WHERE MovementString.DescId    = zc_MovementString_ReceiptNumber()
                     AND MovementString.ValueData = TRIM (inReceiptNumber)
                     -- другой документ
                     AND MovementString.MovementId <> ioId
                  )
        THEN
            -- еще раз найдем
            inReceiptNumber:= 1 + COALESCE ((SELECT MAX (zfConvert_StringToNumber (MovementString.ValueData))
                                             FROM MovementString
                                                  JOIN Movement ON Movement.Id       = MovementString.MovementId
                                                               AND Movement.DescId   = zc_Movement_Invoice()
                                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                                                  INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                                                ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                                               AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                                                                               AND MovementLinkObject_InvoiceKind.ObjectId IN (SELECT tmp.InvoiceKindId
                                                                                                                               FROM (SELECT zc_Enum_InvoiceKind_PrePay() AS InvoiceKindId
                                                                                                                                    UNION 
                                                                                                                                     SELECT zc_Enum_InvoiceKind_Return() AS InvoiceKindId
                                                                                                                                     ) AS tmp
                                                                                                                               WHERE inInvoiceKindId IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Return())
                                                                                                                              UNION 
                                                                                                                               SELECT tmp.InvoiceKindId
                                                                                                                               FROM (SELECT zc_Enum_InvoiceKind_Pay() AS InvoiceKindId
                                                                                                                                    UNION 
                                                                                                                                     SELECT zc_Enum_InvoiceKind_ReturnPay() AS InvoiceKindId
                                                                                                                                    UNION 
                                                                                                                                     SELECT zc_Enum_InvoiceKind_Service() AS InvoiceKindId
                                                                                                                                     ) AS tmp
                                                                                                                               WHERE inInvoiceKindId IN (zc_Enum_InvoiceKind_Pay(), zc_Enum_InvoiceKind_ReturnPay(), zc_Enum_InvoiceKind_Service())
                                                                                                                              )
                                             WHERE MovementString.DescId = zc_MovementString_ReceiptNumber()
                                            ), 0);
            -- !!!проверка уникальности!!! - потом добавить

        END IF;

    END IF;


    -- RAISE EXCEPTION 'Ошибка.%   %.', inReceiptNumber;

     -- проверка - свойство должно быть установлено
     IF zfConvert_StringToNumber (inReceiptNumber) = 0 AND inInvoiceKindId <> zc_Enum_InvoiceKind_Proforma()
        AND inAmount >= 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Invoice No>.';
     END IF;


    -- сначала проверка Parent - обнулить если надо у Заказа
    IF inParentId > 0
    THEN
         -- если меняют на другой документ - Заказ
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.ParentId > 0 AND Movement.ParentId <> inParentId)
         -- или есть Заказ который связан с этим Счетом
         OR (EXISTS (SELECT 1
                     FROM MovementLinkMovement AS MLM
                          JOIN Movement ON Movement.Id = MLM.MovementId AND Movement.DescId = zc_Movement_OrderClient()
                     WHERE MLM.MovementChildId = ioId AND MLM.DescId = zc_MovementLinkMovement_Invoice()
                    )
             -- + тип счета не для связи
             AND inInvoiceKindId <> zc_Enum_InvoiceKind_Pay()
            )
         THEN
             -- Заказ который связан с этим Счетом - Обнуляем связь со Счетом
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), MLM.MovementId, NULL)
             FROM MovementLinkMovement AS MLM
                  JOIN Movement ON Movement.Id = MLM.MovementId AND Movement.DescId = zc_Movement_OrderClient()
             WHERE MLM.MovementChildId = ioId AND MLM.DescId = zc_MovementLinkMovement_Invoice()
            ;
         END IF;

    -- если была связь у Заказа с этим Счетом
    ELSEIF EXISTS (SELECT 1
                   FROM MovementLinkMovement AS MLM
                        JOIN Movement ON Movement.Id = MLM.MovementId AND Movement.DescId = zc_Movement_OrderClient()
                   WHERE MLM.MovementChildId = ioId AND MLM.DescId = zc_MovementLinkMovement_Invoice()
                  )
    THEN
         -- Заказ который связан с этим Счетом - это Заказ - Обнуляем связь со Счетом
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), MLM.MovementId, NULL)
         FROM MovementLinkMovement AS MLM
              JOIN Movement ON Movement.Id = MLM.MovementId AND Movement.DescId = zc_Movement_OrderClient()
         WHERE MLM.MovementChildId = ioId AND MLM.DescId = zc_MovementLinkMovement_Invoice()
        ;
    END IF;


    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, inParentId, 0);

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Object(), ioId, inObjectId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InvoiceKind(), ioId, inInvoiceKindId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_TaxKind(), ioId, inTaxKindId);


    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Plan(), ioId, inPlanDate);

    -- Сохранили свойство <% НДС>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);

    --  External Nr
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
    -- Официальный номер квитанции
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_ReceiptNumber(), ioId, inReceiptNumber);
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


    -- если это InvoiceKind = Счет, тогда ВСЕГДА у Заказа связь ТОЛЬКО с этим Счетом
    IF inParentId > 0 AND inInvoiceKindId = zc_Enum_InvoiceKind_Pay()
    THEN
        -- в док. ParentId - это Заказ или Заказ сохраняеем связь со Счетом
        PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), inParentId, ioId);

    END IF;

    -- !!!протокол через свойства конкретного объекта!!!
    IF vbIsInsert = FALSE
    THEN
        -- сохранили свойство <Дата корректировки>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
        -- сохранили свойство <Пользователь (корректировка)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
    ELSE
        IF vbIsInsert = TRUE
        THEN
            -- сохранили свойство <Дата создания>
            PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
            -- сохранили свойство <Пользователь (создание)>
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
        END IF;
    END IF;


    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.04.24         *
 07.12.23         *
 02.02.21         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Invoice
