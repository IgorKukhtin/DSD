-- Function: lfCheck_Movement_ParentStatus (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS lfCheck_Movement_ParentStatus (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lfCheck_Movement_ParentStatus(
    IN inMovementId  Integer ,
    IN inNewStatusId Integer ,
    IN inComment     TVarChar
)
  RETURNS void
AS
$BODY$
  DECLARE vbMovementId Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbItemName  TVarChar;
BEGIN

     -- проверка при изменении <Child> на Проведен/Распроведен - если <Master> Удален, то <Ошибка>
     IF inNewStatusId <> zc_Enum_Status_Erased()
     THEN
         IF EXISTS (SELECT Movement.Id
                    FROM Movement
                         JOIN Movement AS Movement_Parent
                                       ON Movement_Parent.Id       = Movement.ParentId
                                      AND Movement_Parent.StatusId = zc_Enum_Status_Erased()
                                      AND Movement_Parent.DescId   <> zc_Movement_WeighingPartner()
                    WHERE Movement.Id = inMovementId
                      AND Movement.DescId NOT IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction(), zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
                   )
         THEN
             -- находим параметры <Master> документа
             SELECT Movement.Id, Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                    INTO vbMovementId, vbOperDate, vbInvNumber, vbItemName
             FROM (SELECT MAX (Movement_Parent.Id) AS MovementId_Parent
                   FROM Movement
                        JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
                                                        AND Movement_Parent.StatusId = zc_Enum_Status_Erased()
                   WHERE Movement.Id = inMovementId
                     AND Movement.DescId NOT IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction(), zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
                  ) AS tmpMovement
                  LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId_Parent
                  LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
             --
             RAISE EXCEPTION 'Ошибка.Невозможно % документ т.к. удален <Главный> документ <%> № <%> от <%> ... (%).', inComment, vbItemName, vbInvNumber, DATE (vbOperDate), vbMovementId;
         END IF;
     END IF;

     -- проверка при изменении <Child> на Удален - если <Master> Проведен, то <Ошибка>
     IF inNewStatusId = zc_Enum_Status_Erased()
     THEN
         IF EXISTS (SELECT Movement.Id
                    FROM Movement
                         JOIN Movement AS Movement_Parent
                                       ON Movement_Parent.Id = Movement.ParentId
                                      AND Movement_Parent.StatusId = zc_Enum_Status_Complete()
                                      AND Movement_Parent.DescId   <> zc_Movement_WeighingPartner()
                    WHERE Movement.Id = inMovementId
                      AND Movement.DescId NOT IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction(), zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
                   )
         THEN
             -- находим параметры <Master> документа
             SELECT Movement.Id, Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                    INTO vbMovementId, vbOperDate, vbInvNumber, vbItemName
             FROM (SELECT MAX (Movement_Parent.Id) AS MovementId_Parent
                   FROM Movement
                        JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
                                                        AND Movement_Parent.StatusId = zc_Enum_Status_Complete()
                   WHERE Movement.Id = inMovementId
                     AND Movement.DescId NOT IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction(), zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
                  ) AS tmpMovement
                  LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId_Parent
                  LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
             --
             RAISE EXCEPTION 'Ошибка.Невозможно % документ т.к. проведен <Главный> документ <%> № <%> от <%> ... (%).', inComment, vbItemName, vbInvNumber, DATE (vbOperDate), vbMovementId;
         END IF;
         --
         IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id IN (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_Master())
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                                       AND Movement.DescId <> zc_Movement_WeighingPartner())
         THEN
             -- находим параметры <Child> документа
             SELECT Movement.Id, Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                    INTO vbMovementId, vbOperDate, vbInvNumber, vbItemName
             FROM (SELECT MAX (Movement.Id) AS MovementId
                   FROM Movement
                   WHERE Movement.Id IN (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_Master())
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                  ) AS tmpMovement
                  LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
                  LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
             --
             RAISE EXCEPTION 'Ошибка.Невозможно % документ т.к. проведен документ <%> № <%> от <%> ... (%)(%).', inComment, vbItemName, vbInvNumber, DATE (vbOperDate), vbMovementId, inMovementId;
         END IF;
         --
         IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id IN (SELECT MovementId FROM MovementLinkMovement WHERE MovementChildId = inMovementId AND DescId = zc_MovementLinkMovement_Master())
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                                       AND Movement.DescId <> zc_Movement_WeighingPartner())
         THEN
             -- находим параметры <Child> документа
             SELECT Movement.Id, Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                    INTO vbMovementId, vbOperDate, vbInvNumber, vbItemName
             FROM (SELECT MAX (Movement.Id) AS MovementId
                   FROM Movement
                   WHERE Movement.Id IN (SELECT MovementId FROM MovementLinkMovement WHERE MovementChildId = inMovementId AND DescId = zc_MovementLinkMovement_Master())
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                  ) AS tmpMovement
                  LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
                  LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
             --
             RAISE EXCEPTION 'Ошибка.Невозможно % документ т.к. проведен документ <%> № <%> от <%> ... (%)(%).', inComment, vbItemName, vbInvNumber, DATE (vbOperDate), vbMovementId, inMovementId;
         END IF;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfCheck_Movement_ParentStatus (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.04.14                                        * add zc_MovementLinkMovement_Master
 12.10.13                                        *
*/

-- тест
-- SELECT * FROM lfCheck_Movement_ParentStatus (0, 'изменение')
