-- Function: gpInsert_Pretension_ReturnOut()

DROP FUNCTION IF EXISTS gpInsert_Pretension_ReturnOut(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Pretension_ReturnOut(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisDeferred Boolean;
   DECLARE vbMovementIncome Integer;
   DECLARE vbReturnOutId Integer;
BEGIN

   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   -- параметры документа
   SELECT
       Movement.StatusId,
       COALESCE (MovementBoolean_Deferred.ValueData, FALSE), 
       MLMovement_Income.MovementChildId
   INTO
       vbStatusId,
       vbisDeferred,
       vbMovementIncome
   FROM Movement
       LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                 ON MovementBoolean_Deferred.MovementId = Movement.Id
                                AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
       LEFT JOIN MovementLinkMovement AS MLMovement_Income
                                      ON MLMovement_Income.MovementId = Movement.Id
                                     AND MLMovement_Income.DescId = zc_MovementLinkMovement_Income()
   WHERE Movement.Id = inMovementId;
   
   -- Создаем проведенных документов
   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
   THEN
       RAISE EXCEPTION 'Ошибка.Формирование возврата в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);   
   END IF;
   
   IF COALESCE (vbisDeferred, False) = True
   THEN
       RAISE EXCEPTION 'Ошибка.Отмените отложку претензии.';   
   END IF;
   
   IF NOT EXISTS(SELECT 1
                 FROM MovementItem AS MI
                   
                      INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                     ON MIBoolean_Checked.MovementItemId = MI.Id
                                                    AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                    AND MIBoolean_Checked.ValueData = True

                      INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                   ON MIFloat_MovementItemId.MovementItemId = MI.Id
                                                  AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                                    
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                       ON MILinkObject_ReasonDifferences.MovementItemId = MI.Id
                                                      AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()

                      LEFT JOIN ObjectBoolean AS PriceSite_Deficit
                                              ON PriceSite_Deficit.ObjectId = MILinkObject_ReasonDifferences.ObjectId
                                             AND PriceSite_Deficit.DescId = zc_ObjectBoolean_ReasonDifferences_Deficit()
                                                               
                      LEFT JOIN ObjectBoolean AS PriceSite_Surplus
                                              ON PriceSite_Surplus.ObjectId = MILinkObject_ReasonDifferences.ObjectId
                                             AND PriceSite_Surplus.DescId = zc_ObjectBoolean_ReasonDifferences_Surplus()

                  WHERE MI.MovementId = inMovementId
                    AND MI.DescId = zc_MI_Master()
                    AND (MI.Amount < 0 AND COALESCE (PriceSite_Deficit.ValueData, FALSE) = TRUE OR
                         MI.Amount > 0 AND COALESCE (PriceSite_Deficit.ValueData, FALSE) = FALSE AND COALESCE (PriceSite_Surplus.ValueData, FALSE) = FALSE)
                    AND MI.isErased = FALSE)
   THEN
     RAISE EXCEPTION 'Нет данных для создания возврата.';    
   END IF;   
   
   IF EXISTS(SELECT 1
             FROM MovementLinkMovement 
             WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Pretension()
               AND MovementLinkMovement.MovementChildId = inMovementId)
   THEN
     RAISE EXCEPTION 'Возврат поставщику по претензии уже создан.';       
   END IF;

   SELECT lpInsertUpdate_Movement_ReturnOut(0
                                          , CAST (NEXTVAL ('movement_ReturnOut_seq') AS TVarChar)
                                          , Current_Date   
                                          , NULL::TVarChar
                                          , Movement_Income.PriceWithVAT
                                          , Movement_Income.ToId
                                          , Movement_Income.FromId
                                          , Movement_Income.NDSKindId
                                          , vbMovementIncome
                                          , NULL
                                          , NULL
                                          , NULL
                                          , NULL :: TVarChar
                                          , vbUserId)
   INTO vbReturnOutId
   FROM  Movement_Income_View AS Movement_Income 
   WHERE Movement_Income.Id = vbMovementIncome;
   
   -- сохранили <Претензия>
   PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Pretension(), vbReturnOutId, inMovementId);
   
   PERFORM lpInsertUpdate_MovementItem_ReturnOut (0
                                                , vbReturnOutId
                                                , MI.ObjectId
                                                , Abs(MI.Amount) :: TFloat
                                                , COALESCE (MIFloat_Price.ValueData, 0)
                                                , MIFloat_MovementItemId.ValueData :: Integer
                                                , vbUserId
                                                )  
   FROM MovementItem AS MI
                   
        INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                       ON MIBoolean_Checked.MovementItemId = MI.Id
                                      AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                      AND MIBoolean_Checked.ValueData = True

        INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                     ON MIFloat_MovementItemId.MovementItemId = MI.Id
                                    AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                                    
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MIFloat_MovementItemId.ValueData :: Integer
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                         ON MILinkObject_ReasonDifferences.MovementItemId = MI.Id
                                        AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()

        LEFT JOIN ObjectBoolean AS PriceSite_Deficit
                                ON PriceSite_Deficit.ObjectId = MILinkObject_ReasonDifferences.ObjectId
                               AND PriceSite_Deficit.DescId = zc_ObjectBoolean_ReasonDifferences_Deficit()
                                                               
        LEFT JOIN ObjectBoolean AS PriceSite_Surplus
                                ON PriceSite_Surplus.ObjectId = MILinkObject_ReasonDifferences.ObjectId
                               AND PriceSite_Surplus.DescId = zc_ObjectBoolean_ReasonDifferences_Surplus()
                                   
    WHERE MI.MovementId = inMovementId
      AND MI.DescId = zc_MI_Master()
      AND (MI.Amount < 0 AND COALESCE (PriceSite_Deficit.ValueData, FALSE) = TRUE OR
           MI.Amount > 0 AND COALESCE (PriceSite_Deficit.ValueData, FALSE) = FALSE AND COALESCE (PriceSite_Surplus.ValueData, FALSE) = FALSE)
      AND MI.isErased = FALSE;
                       
   -- !!!ВРЕМЕННО для ТЕСТА!!!
   IF inSession = zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%>', inMovementId, vbMovementIncome, inSession;
   END IF;   

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.12.21                                                       *
*/

-- select * from gpInsert_Pretension_ReturnOut(inMovementId := 26087688 ,  inSession := '3');