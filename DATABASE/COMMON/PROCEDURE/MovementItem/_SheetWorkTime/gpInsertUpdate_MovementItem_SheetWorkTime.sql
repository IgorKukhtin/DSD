-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTime(
 INOUT ioPersonalId          Integer   , -- Ключ Сотрудник
    IN inPositionId          Integer   , -- Должность
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inStartDate           TDateTime , -- начальная дата

    -- Количество часов факт
    IN inAmount_1 TFloat, IN inAmount_2 TFloat, IN inAmount_3 TFloat, IN inAmount_4 TFloat, IN inAmount_5 TFloat
  , IN inAmount_6 TFloat, IN inAmount_7 TFloat, IN inAmount_8 TFloat, IN inAmount_9 TFloat, IN inAmount_10 TFloat
  , IN inAmount_11 TFloat, IN inAmount_12 TFloat, IN inAmount_13 TFloat, IN inAmount_14 TFloat, IN inAmount_15 TFloat,
  , IN inAmount_16 TFloat, IN inAmount_17 TFloat, IN inAmount_18 TFloat, IN inAmount_19 TFloat, IN inAmount_20 TFloat
  , IN inAmount_21 TFloat, IN inAmount_22 TFloat, IN inAmount_23 TFloat, IN inAmount_24 TFloat, IN inAmount_25 TFloat
  , IN inAmount_26 TFloat, IN inAmount_27 TFloat, IN inAmount_28 TFloat, IN inAmount_29 TFloat, IN inAmount_30 TFloat
  , IN inAmount_31 TFloat             

  -- Типы рабочего времени
  , IN inWorkTimeKindId_1 Integer, IN inWorkTimeKindId_2 Integer, IN inWorkTimeKindId_3 Integer, IN inWorkTimeKindId_4 Integer, IN inWorkTimeKindId_5 Integer
  , IN inWorkTimeKindId_6 Integer, IN inWorkTimeKindId_7 Integer, IN inWorkTimeKindId_8 Integer, IN inWorkTimeKindId_9 Integer, IN inWorkTimeKindId_10 Integer
  , IN inWorkTimeKindId_11 Integer, IN inWorkTimeKindId_12 Integer, IN inWorkTimeKindId_13 Integer, IN inWorkTimeKindId_14 Integer, IN inWorkTimeKindId_15 Integer,
  , IN inWorkTimeKindId_16 Integer, IN inWorkTimeKindId_17 Integer, IN inWorkTimeKindId_18 Integer, IN inWorkTimeKindId_19 Integer, IN inWorkTimeKindId_20 Integer
  , IN inWorkTimeKindId_21 Integer, IN inWorkTimeKindId_22 Integer, IN inWorkTimeKindId_23 Integer, IN inWorkTimeKindId_24 Integer, IN inWorkTimeKindId_25 Integer
  , IN inWorkTimeKindId_26 Integer, IN inWorkTimeKindId_27 Integer, IN inWorkTimeKindId_28 Integer, IN inWorkTimeKindId_29 Integer, IN inWorkTimeKindId_30 Integer
  , IN inWorkTimeKindId_31 Intege

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_1 Integer;
   DECLARE vbMovementItemId_1 Integer;
   DECLARE vbStartDate_calc, vbEndDate_calc TDateTime;
   DECLARE vbMovementId_1 Integer, vbMovementId_2 Integer, vbMovementId_3 Integer, vbMovementId_4 Integer, vbMovementId_5 Integer
             , vbMovementId_6 Integer, vbMovementId_7 Integer, vbMovementId_8 Integer, vbMovementId_9 Integer, vbMovementId_10 Integer
             , vbMovementId_11 Integer, vbMovementId_12 Integer, vbMovementId_13 Integer, vbMovementId_14 Integer, vbMovementId_15 Integer,
             , vbMovementId_16 Integer, vbMovementId_17 Integer, vbMovementId_18 Integer, vbMovementId_19 Integer, vbMovementId_20 Integer
             , vbMovementId_21 Integer, vbMovementId_22 Integer, vbMovementId_23 Integer, vbMovementId_24 Integer, vbMovementId_25 Integer
             , vbMovementId_26 Integer, vbMovementId_27 Integer, vbMovementId_28 Integer, vbMovementId_29 Integer, vbMovementId_30 Integer
             , vbMovementId_31 Integer;
   DECLARE vbMovementItemId_1 Integer, vbMovementItemId_2 Integer, vbMovementItemId_3 Integer, vbMovementItemId_4 Integer, vbMovementItemId_5 Integer
             , vbMovementItemId_6 Integer, vbMovementItemId_7 Integer, vbMovementItemId_8 Integer, vbMovementItemId_9 Integer, vbMovementItemId_10 Integer
             , vbMovementItemId_11 Integer, vbMovementItemId_12 Integer, vbMovementItemId_13 Integer, vbMovementItemId_14 Integer, vbMovementItemId_15 Integer,
             , vbMovementItemId_16 Integer, vbMovementItemId_17 Integer, vbMovementItemId_18 Integer, vbMovementItemId_19 Integer, vbMovementItemId_20 Integer
             , vbMovementItemId_21 Integer, vbMovementItemId_22 Integer, vbMovementItemId_23 Integer, vbMovementItemId_24 Integer, vbMovementItemId_25 Integer
             , vbMovementItemId_26 Integer, vbMovementItemId_27 Integer, vbMovementItemId_28 Integer, vbMovementItemId_29 Integer, vbMovementItemId_30 Integer
             , vbMovementItemId_31 Integer;


BEGIN
	-- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_SheetWorkTime());
    vbUserId := inSession;
     
	vbStartDate_calc:= (SELECT DATEADD(d, 1-DAY(inStartDate), CAST(FLOOR(CAST(inStartDate AS MONEY)) AS DATETIME)));      -- первое число месяца
	vbEndDate_calc:= (SELECT DATEADD(MONTH, 1, DATEADD(DAY,1-DAY(inStartDate), inStartDate))-1);                          -- последнее число месяца
	

	SELECT tmpMovement_1.MovementId, tmpMovement_2.MovementItemId
	
	  INTO     vbMovementId_1, vbMovementId_2, vbMovementId_3, vbMovementId_4, vbMovementId_5 
             , vbMovementId_6, vbMovementId_7, vbMovementId_8, vbMovementId_9, vbMovementId_10 
             , vbMovementId_11, vbMovementId_12, vbMovementId_13, vbMovementId_14, vbMovementId_15,
             , vbMovementId_16, vbMovementId_17, vbMovementId_18, vbMovementId_19, vbMovementId_20 
             , vbMovementId_21, vbMovementId_22, vbMovementId_23, vbMovementId_24, vbMovementId_25 
             , vbMovementId_26, vbMovementId_27, vbMovementId_28, vbMovementId_29, vbMovementId_30 
             , vbMovementId_31 
             
             , vbMovementItemId_1, vbMovementItemId_2, vbMovementItemId_3, vbMovementItemId_4, vbMovementItemId_5 
             , vbMovementItemId_6, vbMovementItemId_7, vbMovementItemId_8, vbMovementItemId_9, vbMovementItemId_10 
             , vbMovementItemId_11, vbMovementItemId_12, vbMovementItemId_13, vbMovementItemId_14, vbMovementItemId_15,
             , vbMovementItemId_16, vbMovementItemId_17, vbMovementItemId_18, vbMovementItemId_19, vbMovementItemId_20 
             , vbMovementItemId_21, vbMovementItemId_22, vbMovementItemId_23, vbMovementItemId_24, vbMovementItemId_25 
             , vbMovementItemId_26, vbMovementItemId_27, vbMovementItemId_28, vbMovementItemId_29, vbMovementItemId_30 
             , vbMovementItemId_31 



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
