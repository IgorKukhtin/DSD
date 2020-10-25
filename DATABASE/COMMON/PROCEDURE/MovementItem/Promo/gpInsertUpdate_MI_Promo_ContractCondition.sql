-- Function: gpInsertUpdate_MI_Promo_ContractCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Promo_ContractCondition (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Promo_ContractCondition(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContractCondition TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());

RETURN;

     -- рассчитываем бонус сети
     vbContractCondition := (SELECT MAX (tmp.Value) AS ContractCondition
                             FROM (SELECT MovementLinkObject_Contract.ObjectId            AS ContractId
                                        , SUM ( COALESCE (ObjectFloat_Value.ValueData,0)) AS Value
                                   FROM Movement AS Movement_Promo
                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                     ON MovementLinkObject_Contract.MovementId = Movement_Promo.Id
                                                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
  
                                       LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                            ON ObjectLink_ContractCondition_Contract.ChildObjectId = MovementLinkObject_Contract.ObjectId
                                                           AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                       INNER JOIN Object AS Object_ContractCondition 
                                                         ON Object_ContractCondition.Id = ObjectLink_ContractCondition_Contract.ObjectId
                                                        AND Object_ContractCondition.isErased = FALSE
  
                                       LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                            ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                                                           AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
                                       INNER JOIN Object AS Object_BonusKind
                                                         ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId
                                                        AND Object_BonusKind.Id = 81959   ---Бонус
                               
                                       INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                                              ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id 
                                                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               
                                   WHERE Movement_Promo.DescId = zc_Movement_PromoPartner()
                                     AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
                                     AND Movement_Promo.ParentId = inMovementId  ---Ссылка на основной документ <Акции> (zc_Movement_Promo)
                                   GROUP BY MovementLinkObject_Contract.ObjectId
                                   ) AS tmp
                             );
     -- 
     IF COALESCE (vbContractCondition,0) <> 0
     THEN
        -- сохраняем 
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractCondition(), MovementItem.Id, vbContractCondition)
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
       ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.09.20         *
*/

-- тест
--