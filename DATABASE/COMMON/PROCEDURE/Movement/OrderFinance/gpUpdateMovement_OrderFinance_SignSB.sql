-- Function: gpUpdateMovement_OrderFinance_SignSB()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_SignSB (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_SignSB(
    IN inMovementId      Integer   , -- Ключ объекта <Документ>
    IN inIsSignSB        Boolean   ,
   OUT outIsSignSB       Boolean   ,
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession);
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_OrderFinance_SignSB());

     IF NOT EXISTS (SELECT 1
                    FROM Movement
                        -- временно - Відділ забезбечення - 1
                        INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                      ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                     AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                        INNER JOIN ObjectBoolean  AS ObjectBoolean_SB
                                                  ON ObjectBoolean_SB.ObjectId = MovementLinkObject_OrderFinance.ObjectId
                                                 AND ObjectBoolean_SB.DescId = zc_ObjectBoolean_OrderFinance_SB()
                                                 AND COALESCE (ObjectBoolean_SB.ValueData, FALSE) = TRUE     --только те виды планировани, что нужно согласовывать СБ

                    WHERE Movement.DescId = zc_Movement_OrderFinance()
                      AND Movement.Id = inMovementId
                    )
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не требует <Виза СБ>.';
     END IF;


     -- сохранили свойство  <Виза СБ>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SignSB(), inMovementId, inIsSignSB);

     IF inIsSignSB = TRUE
     THEN
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), inMovementId, CURRENT_TIMESTAMP);

         -- сохранили <Итого>
         PERFORM lpInsertUpdate_MovementItem (tmpMI.Id, zc_MI_Master(), tmpMI.ObjectId, tmpMI.MovementId, tmpMI.Amount_sum, tmpMI.ParentId)
                 -- пн.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_1(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 1 THEN tmpMI.Amount_sum ELSE 0 END)
                 -- вт.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_2(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 2 THEN tmpMI.Amount_sum ELSE 0 END)
                 -- ср.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_3(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 3 THEN tmpMI.Amount_sum ELSE 0 END)
                 -- чт.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_4(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 4 THEN tmpMI.Amount_sum ELSE 0 END)
                 -- пт.
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_5(), tmpMI.Id, CASE WHEN EXTRACT (DOW FROM tmpMI.OperDate_amount) = 5 THEN tmpMI.Amount_sum ELSE 0 END)

         FROM (WITH tmpMI_child AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount_sum
                                    FROM MovementItem
                                          INNER JOIN MovementItemBoolean AS MIBoolean_Sign
                                                                         ON MIBoolean_Sign.MovementItemId = MovementItem.Id
                                                                        AND MIBoolean_Sign.DescId         = zc_MIBoolean_Sign()
                                                                        AND MIBoolean_Sign.ValueData      = TRUE
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Child()
                                      AND MovementItem.isErased   = FALSE
                                    GROUP BY MovementItem.ParentId
                                   )
               SELECT MovementItem.*
                    , COALESCE (tmpMI_child.Amount_sum, 0) AS Amount_sum
                    , MovementItemDate_Amount.ValueData AS OperDate_amount
               FROM MovementItem
                    LEFT JOIN tmpMI_child ON tmpMI_child.ParentId = MovementItem.Id
                    LEFT JOIN MovementItemDate AS MovementItemDate_Amount
                                               ON MovementItemDate_Amount.MovementItemId = MovementItem.Id
                                              AND MovementItemDate_Amount.DescId         = zc_MIDate_Amount()

               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.iseRased   = FALSE
              ) AS tmpMI
          ;

     ELSE
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), inMovementId, NULL ::TDateTime);

         -- сохранили <Итого>
         PERFORM lpInsertUpdate_MovementItem (tmpMI.Id, zc_MI_Master(), tmpMI.ObjectId, tmpMI.MovementId, tmpMI.Amount_child, tmpMI.ParentId)
         FROM (WITH tmpMI_child AS (SELECT MovementItem.ParentId, SUM (MovementItem.Amount) AS Amount
                                    FROM MovementItem
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Child()
                                      AND MovementItem.isErased   = FALSE
                                    GROUP BY MovementItem.ParentId
                                   )
               SELECT MovementItem.*
                    , COALESCE (tmpMI_child.Amount, 0) AS Amount_child
               FROM MovementItem
                    LEFT JOIN tmpMI_child ON tmpMI_child.ParentId = MovementItem.Id
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
              ) AS tmpMI
          ;

     END IF;

     outIsSignSB := inIsSignSB;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.26         *
*/

-- тест
--