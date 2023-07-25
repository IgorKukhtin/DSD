-- Function: lfCheck_Movement_Parent (Integer, TVarChar)

DROP FUNCTION IF EXISTS lfCheck_Movement_Parent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lfCheck_Movement_Parent(
    IN inMovementId Integer ,
    IN inComment   TVarChar
)
  RETURNS void
AS
$BODY$
  DECLARE vbOperDate  TDateTime;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbItemName  TVarChar;
BEGIN

     -- проверка - связанные документы Изменять нельзя
     IF EXISTS (SELECT 1
                FROM Movement
                     JOIN Movement AS Movement_parent ON Movement_parent.Id     = Movement.ParentId
                                                     AND Movement_parent.DescId <> zc_Movement_WeighingPartner()
                WHERE Movement.Id = inMovementId AND Movement.ParentId IS NOT NULL
               )
     THEN
         -- находим параметры "главного" документа
         SELECT Movement.OperDate, Movement.InvNumber, MovementDesc.ItemName
                INTO vbOperDate, vbInvNumber, vbItemName
         FROM (SELECT MAX (Movement_Parent.Id) AS MovementId_Parent
               FROM Movement
                    JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
               WHERE Movement.Id = inMovementId
              ) AS tmpMovement
              LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId_Parent
              LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;
         --
         RAISE EXCEPTION 'Ошибка.Невозможно % документа т.к. он связан с <%> № <%> от <%>.', inComment, vbItemName, vbInvNumber, vbOperDate;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM lfCheck_Movement_Parent (0, 'изменение')
