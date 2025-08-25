-- Function: gpInsertUpdate_MovementItem_StaffList()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_StaffList (Integer, Integer, Integer,Integer, Integer, Integer,Integer, Integer,  Integer,  TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_StaffList(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , -- 
    IN inStaffPaidKindId       Integer   , -- 
    IN inStaffHoursDayId       Integer   , -- 
    IN inStaffHoursId          Integer   , -- 
    IN inStaffHoursLengthId    Integer   , -- 
    IN inPersonalId            Integer   , -- 
    IN inAmount                TFloat    , --
    IN inAmountReport          TFloat    , --
    IN inStaffCount_1          TFloat    , --
    IN inStaffCount_2          TFloat    , --
    IN inStaffCount_3          TFloat    , --
    IN inStaffCount_4          TFloat    , --
    IN inStaffCount_5          TFloat    , --
    IN inStaffCount_6          TFloat    , --
    IN inStaffCount_7          TFloat    , --
    IN inStaffCount_Invent     TFloat    , --
    IN inStaff_Price           TFloat    , --
    IN inStaff_Summ_MK         TFloat    , --
    IN inStaff_Summ_real       TFloat    , --
    IN inStaff_Summ_add        TFloat    , --
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_StaffList());

     -- сохранили
     ioId := lpInsertUpdate_MovementItem_StaffList (ioId                  := ioId
                                                  , inMovementId          := inMovementId
                                                  , inPositionId          := inPositionId
                                                  , inPositionLevelId     := inPositionLevelId    
                                                  , inStaffPaidKindId     := inStaffPaidKindId    
                                                  , inStaffHoursDayId     := inStaffHoursDayId    
                                                  , inStaffHoursId        := inStaffHoursId       
                                                  , inStaffHoursLengthId  := inStaffHoursLengthId
                                                  , inPersonalId          := inPersonalId         
                                                  , inAmount              := inAmount             
                                                  , inAmountReport        := inAmountReport       
                                                  , inStaffCount_1        := inStaffCount_1       
                                                  , inStaffCount_2        := inStaffCount_2       
                                                  , inStaffCount_3        := inStaffCount_3       
                                                  , inStaffCount_4        := inStaffCount_4       
                                                  , inStaffCount_5        := inStaffCount_5
                                                  , inStaffCount_6        := inStaffCount_6       
                                                  , inStaffCount_7        := inStaffCount_7       
                                                  , inStaffCount_Invent   := inStaffCount_Invent  
                                                  , inStaff_Price         := inStaff_Price        
                                                  , inStaff_Summ_MK       := inStaff_Summ_MK
                                                  , inStaff_Summ_real     := inStaff_Summ_real    
                                                  , inStaff_Summ_add      := inStaff_Summ_add
                                                  , inComment             := inComment
                                                  , inUserId              := vbUserId
                                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.25         *
*/

-- тест
--