DROP FUNCTION IF EXISTS lpComplete_Movement_Invoice (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Invoice(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbObjectId Integer;  
    DECLARE vbMovementId_OrderClient Integer;
    DECLARE vbAmount TFloat;
    DECLARE vbSum_OrderClient TFloat;
    DECLARE vbSum_PrePay TFloat;
BEGIN


    ---проверка чтоб сумма счета соотв. сумме остатка к оплате для вида Документа СЧЕТ
    IF (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_InvoiceKind() AND MLO.MovementId = inMovementId) = zc_Enum_InvoiceKind_Pay()
    THEN
         --док заказа
         SELECT MovementLinkMovement_Invoice.MovementId
              , MovementFloat_Amount.ValueData AS Amount 
       INTO vbMovementId_OrderClient, vbAmount
         FROM  MovementLinkMovement AS MovementLinkMovement_Invoice
              LEFT JOIN MovementFloat AS MovementFloat_Amount
                                      ON MovementFloat_Amount.MovementId = MovementLinkMovement_Invoice.MovementChildId
                                     AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
         WHERE MovementLinkMovement_Invoice.MovementChildId = inMovementId
           AND MovementLinkMovement_Invoice.DescId          = zc_MovementLinkMovement_Invoice()
         ;
         --сумма заказа клиента 
         vbSum_OrderClient := (SELECT tmp.Basis_summ_transport  
                               FROM gpSelect_Object_Product (inMovementId_OrderClient:= vbMovementId_OrderClient, inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inUserId::TVarChar) AS tmp
                               );
         
         vbSum_PrePay :=(SELECT SUM (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END) ::TFloat AS Total_PrePay
                         FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                          ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                         AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                                                         AND MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_PrePay()
                            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount() 
                         WHERE Movement.DescId = zc_Movement_Invoice()
                           AND Movement.ParentId = vbMovementId_OrderClient
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         ); 
         IF COALESCE (vbSum_OrderClient,0) - COALESCE (vbSum_PrePay,0) <> vbAmount
         THEN 
             RAISE EXCEPTION 'Ошибка. Cумма к оплате <%> не соответствует сумме счета <%>.', CAST ((COALESCE (vbSum_OrderClient,0) - COALESCE (vbSum_PrePay,0)) AS NUMERIC (16,2)), CAST (vbAmount AS NUMERIC (16,2));  
         END IF;
         
    END IF;


     -- Параметр из документа
     vbObjectId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Object());

     -- Пересохранили VATPercent
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inMovementId, COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0))
     FROM ObjectLink AS ObjectLink_TaxKind
          LEFT JOIN Object ON Object.Id = ObjectLink_TaxKind.ObjectId
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId 
                               AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
     WHERE ObjectLink_TaxKind.ObjectId = vbObjectId
       AND ObjectLink_TaxKind.DescId   = CASE WHEN Object.DescId = zc_Object_Partner() THEN zc_ObjectLink_Partner_TaxKind() ELSE zc_ObjectLink_Client_TaxKind() END
    ;


    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Invoice()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.21         *
*/