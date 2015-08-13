-- Function: lfCheck_Movement_ChildStatus (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS lfCheck_Movement_ChildStatus (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lfCheck_Movement_ChildStatus(
    IN inMovementId  Integer ,
    IN inNewStatusId Integer ,
    IN inComment     TVarChar
)
  RETURNS void
AS
$BODY$
  DECLARE vbMovementId Integer;
  DECLARE vbOperDate   TDateTime;
  DECLARE vbInvNumber  TVarChar;
  DECLARE vbItemName   TVarChar;
BEGIN

     -- проверка при изменении <Master> на Удален - если <Child> Проведен, то <Ошибка>
     IF inNewStatusId = zc_Enum_Status_Erased()
     THEN
         --
         IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete() AND Movement.DescId NOT IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction(), zc_Movement_TransportGoods(), zc_Movement_QualityDoc()))
         THEN
             -- находим параметры <Child> документа
             SELECT Movement.Id, Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                    INTO vbMovementId, vbOperDate, vbInvNumber, vbItemName
             FROM (SELECT MAX (Movement.Id) AS MovementId
                   FROM Movement
                   WHERE Movement.ParentId = inMovementId
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                     AND Movement.DescId NOT IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction(), zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
                  ) AS tmpMovement
                  LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
                  LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
             --
             RAISE EXCEPTION 'Ошибка.Невозможно % документ т.к. проведен <Подчиненный> документ <%> № <%> от <%> .... (%).', inComment, vbItemName, vbInvNumber, DATE (vbOperDate), vbMovementId;
         END IF;
         --
         IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id IN (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_Child())
                                                       AND Movement.StatusId = zc_Enum_Status_Complete())
         THEN
             -- находим параметры <Child> документа
             SELECT Movement.Id, Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                    INTO vbMovementId, vbOperDate, vbInvNumber, vbItemName
             FROM (SELECT MAX (Movement.Id) AS MovementId
                   FROM Movement
                   WHERE Movement.Id IN (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_Child())
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                  ) AS tmpMovement
                  LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
                  LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
             --
             RAISE EXCEPTION 'Ошибка.Невозможно % документ т.к. проведен документ <%> № <%> от <%> ..... (%)(%).', inComment, vbItemName, vbInvNumber, DATE (vbOperDate), vbMovementId, inMovementId;
         END IF;
         --
         IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id IN (SELECT MovementId FROM MovementLinkMovement WHERE MovementChildId = inMovementId AND DescId = zc_MovementLinkMovement_Child())
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                                       AND Movement.DescId NOT IN (zc_Movement_QualityDoc())
                   )
         THEN
             -- находим параметры <Child> документа
             SELECT Movement.Id, Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                    INTO vbMovementId, vbOperDate, vbInvNumber, vbItemName
             FROM (SELECT MAX (Movement.Id) AS MovementId
                   FROM Movement
                   WHERE Movement.Id IN (SELECT MovementId FROM MovementLinkMovement WHERE MovementChildId = inMovementId AND DescId = zc_MovementLinkMovement_Child())
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                  ) AS tmpMovement
                  LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
                  LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
             --
             RAISE EXCEPTION 'Ошибка.Невозможно % документ т.к. проведен документ <%> № <%> от <%> ....... (%)(%).', inComment, vbItemName, vbInvNumber, DATE (vbOperDate), vbMovementId, inMovementId;
         END IF;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfCheck_Movement_ChildStatus (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.04.14                                        * add zc_MovementLinkMovement_Child
 12.10.13                                        *
*/

-- тест
-- SELECT * FROM lfCheck_Movement_ChildStatus (0, 0, 'test')
