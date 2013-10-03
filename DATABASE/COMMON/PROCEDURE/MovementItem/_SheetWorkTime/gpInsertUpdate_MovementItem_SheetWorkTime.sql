-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTime(
 INOUT ioPersonalId          Integer   , -- Ключ Сотрудник
    IN inPositionId          Integer   , -- Должность
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inStartDate           TDateTime , -- начальная дата

    IN inAmount_1            TFloat    , -- Количество часов факт
    IN inWorkTimeKindId_1    Integer   , -- Типы рабочего времени

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_1 Integer;
   DECLARE vbMovementItemId_1 Integer;
   DECLARE vbEndDate_calc TDateTime;
BEGIN
	 -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_SheetWorkTime());
     vbUserId := inSession;
	
	vbEndDate_calc:= (SELECT DATEADD(MONTH, 1, DATEADD(DAY,1-DAY(inStartDate), inStartDate))-1);                          -- последнее число месяца
	

	SELECT tmpMovement_1.MovementId, tmpMovement_2.MovementItemId
	  INTO vbMovementId_1, vbMovementItemId_1
 
 	FROM (select Movement.Id AS MovementId 
	      FROM Movement 
	          JOIN MovementLinkObject AS MovementLinkObject_Unit ON MovementLinkObject_Unit.MovementItemId = MovementItem.Id
			        					                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()                
			        					                        AND MovementLinkObject_Unit.ObjectId  = inUnitId
          where Movement.DescId = zc_Movement_SheetWorkTime()  
		    AND Movement.inOperDate = inStartDate
		  ) AS tmpMovement_1
		 
		 LEFT JOIN 
		          (SELECT MovementItem.Id AS MovementItemId
		           FROM Movement
		                JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
							                                                       AND MovementItem.ObjectId = ioPersonalId
	                                     
					    JOIN MovementItemLinkObject AS MILinkObject_Personal ON MILinkObject_PersonalGroup.MovementItemId = MovementItem.Id
					                                                        AND MILinkObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
					                                                        AND MILinkObject_PersonalGroup.ObjectId  = inPersonalGroupId
				                                              
					    JOIN MovementItemLinkObject AS MILinkObject_PersonalGroup ON MILinkObject_PersonalGroup.MovementItemId = MovementItem.Id
					                                                             AND MILinkObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
					                                                             AND MILinkObject_PersonalGroup.ObjectId  = inPersonalGroupId
				     
					    JOIN MovementItemLinkObject AS MILinkObject_Position ON MILinkObject_Position.MovementItemId = MovementItem.Id
					                                                        AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
					                                                        AND MILinkObject_Position.ObjectId  = inPositionId
	     
		           where Movement.DescId = zc_Movement_SheetWorkTime()  
		             AND Movement.inOperDate = inStartDate
		             
		           ) AS tmpMovement_2 ON tmpMovement_2.MovementId = tmpMovement_1.MovementId
		  

 

     -- сохранили <Элемент документа>
     --ioId := lpInsertUpdate_MovementItem (vbMovementItemId_1, zc_MI_Master(), ioPersonalId, vbMovementId_1, inAmount_1, NULL);
     -- сохранили связь с <Типы рабочего времени>
     --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_WorkTimeKind(), vbMovementItemId_1, inWorkTimeKindId_1);

     PERFORM lpInsertUpdate_MovementItem_SheetWorkTime (InMovementItemId:= vbMovementItemId_1, inOperDate = inStartDate, inMovementId:= vbMovementId_1
                                                      , inPersonalId:= ioPersonalId, inPositionId:= inPositionId, inPersonalGroupId=inPersonalGroupId, inUnitId=inUnitId
                                                      , inAmount:= inAmount_1, inWorkTimeKindId:= inWorkTimeKindId_1);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.10.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SheetWorkTime (, inSession:= '2')
