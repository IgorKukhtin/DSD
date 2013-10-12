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
  DECLARE vbOperDate  TDateTime;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbItemName  TVarChar;
BEGIN

     -- проверка при изменении <Master> на Удален - если <Child> Проведен, то <Ошибка>
     IF inNewStatusId = zc_Enum_Status_Erased()
     THEN
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- находим параметры <Child> документа
         SELECT Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                INTO vbOperDate, vbInvNumber, vbItemName
         FROM (SELECT MAX (Movement.Id) AS MovementId
               FROM Movement
               WHERE Movement.ParentId = inMovementId
                 AND Movement.StatusId = zc_Enum_Status_Complete()
              ) AS tmpMovement
              LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
              LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
         --
         RAISE EXCEPTION 'Ошибка.Невозможно % документ т.к. проведен <Подчиненный> документ <%> № <%> от <%> .', inComment, vbItemName, vbInvNumber, vbOperDate;
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
 12.10.13                                        *
*/

-- тест
-- SELECT * FROM lfCheck_Movement_ChildStatus (0, 0, 'test')
