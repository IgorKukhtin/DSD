-- Function: gpSetErased_Movement_ContractGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ContractGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ContractGoods(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_last Integer;
   DECLARE vbMovementId_next Integer;
   DECLARE vbContractId Integer;
   DECLARE vbOperDate_next TDateTime;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ContractGoods());

      --предыдущее состояние. дата
      SELECT Movement.OperDate
           , MovementLinkObject_Contract.ObjectId AS ContractId
    INTO vbOperDate, vbContractId
      FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
      WHERE Movement.Id = inMovementId;

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);
     
     --меняем дату окончения у предыдущего
     --находим предыдущий документ,ему устанавливаем дату окончания EndBeginDate  = inOperDate-1 день
     vbMovementId_last:= (SELECT tmp.Id
                          FROM (SELECT Movement.Id
                                     , Movement.OperDate
                                     , MAX (Movement.OperDate) OVER () AS OperDate_last
                                FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                 AND MovementLinkObject_Contract.ObjectId = vbContractId
                                WHERE Movement.DescId = zc_Movement_ContractGoods()
                                   AND Movement.OperDate < vbOperDate
                                   AND Movement.StatusId <> zc_Enum_Status_Erased()  --zc_Enum_Status_Complete()
                                   AND Movement.Id <> inMovementId
                                ) AS tmp
                          WHERE tmp.OperDate = tmp.OperDate_last
                          );
     
     -- нужно в документе до этого  изменить дату окончания 
     --пробуем найти следующий док.
     SELECT tmp.Id
          , tmp.OperDate
   INTO vbMovementId_next, vbOperDate_next
     FROM (SELECT Movement.Id
                , Movement.OperDate
                , MIN (Movement.OperDate) OVER () AS OperDate_last
           FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                            AND MovementLinkObject_Contract.ObjectId = vbContractId
           WHERE Movement.DescId = zc_Movement_ContractGoods()
              AND Movement.OperDate > vbOperDate
              AND Movement.StatusId <> zc_Enum_Status_Erased()--zc_Enum_Status_Complete()
              AND Movement.Id <> inMovementId
           ) AS tmp
     WHERE tmp.OperDate = tmp.OperDate_last;

     IF COALESCE (vbMovementId_last,0) <> 0
     THEN
         -- сохранили свойство <Дата окончания> предыдущего документа
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), vbMovementId_last, CASE WHEN COALESCE (vbMovementId_next,0) <> 0 THEN (vbOperDate_next- interval '1 day') ELSE zc_DateEnd() END ::TDateTime);
     END IF;
         

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.06.21         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_ContractGoods (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
