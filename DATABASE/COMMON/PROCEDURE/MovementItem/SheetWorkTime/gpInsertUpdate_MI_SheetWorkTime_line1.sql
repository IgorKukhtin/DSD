-- Function: gpInsertUpdate_MI_SheetWorkTime_line()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SheetWorkTime_line1(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           , Integer, Integer, Integer, Integer, Integer
                                                           
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           , Integer, Integer, Integer, Integer, Integer
                                                           , Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SheetWorkTime_line1(
    IN inMemberId            Integer   , -- Ключ физ. лицо
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inStorageLineId       Integer   , -- линия произ-ва
    IN inOperDate            TDateTime , -- дата
 
 INOUT ioShortName_1         TVarChar  , -- 
 INOUT ioShortName_2         TVarChar  ,
 INOUT ioShortName_3         TVarChar  ,
 INOUT ioShortName_4         TVarChar  ,
 INOUT ioShortName_5         TVarChar  ,
 INOUT ioShortName_6         TVarChar  ,
 INOUT ioShortName_7         TVarChar  ,
 INOUT ioShortName_8         TVarChar  ,
 INOUT ioShortName_9         TVarChar  ,
 INOUT ioShortName_10         TVarChar  ,
 INOUT ioShortName_11         TVarChar  ,
 INOUT ioShortName_12         TVarChar  ,
 INOUT ioShortName_13         TVarChar  ,
 INOUT ioShortName_14         TVarChar  ,
 INOUT ioShortName_15         TVarChar  ,
 
 INOUT ioShortName_1_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_2_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_3_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_4_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_5_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_6_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_7_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_8_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_9_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_10_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_11_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_12_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_13_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_14_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_15_old     TVarChar  , -- прошлое значение
 --
 INOUT ioWorkTimeKindId_1      Integer   ,  
 INOUT ioWorkTimeKindId_2     Integer   ,
 INOUT ioWorkTimeKindId_3      Integer   ,
 INOUT ioWorkTimeKindId_4      Integer   ,
 INOUT ioWorkTimeKindId_5      Integer   ,
 INOUT ioWorkTimeKindId_6      Integer   ,
 INOUT ioWorkTimeKindId_7      Integer   ,
 INOUT ioWorkTimeKindId_8      Integer   ,
 INOUT ioWorkTimeKindId_9      Integer   ,
 INOUT ioWorkTimeKindId_10      Integer   ,
 INOUT ioWorkTimeKindId_11      Integer   ,
 INOUT ioWorkTimeKindId_12      Integer   ,
 INOUT ioWorkTimeKindId_13      Integer   ,
 INOUT ioWorkTimeKindId_14      Integer   ,
 INOUT ioWorkTimeKindId_15      Integer   ,
 
 INOUT ioWorkTimeKindId_1_old  Integer   ,
 INOUT ioWorkTimeKindId_2_old  Integer   ,
 INOUT ioWorkTimeKindId_3_old  Integer   ,
 INOUT ioWorkTimeKindId_4_old  Integer   ,
 INOUT ioWorkTimeKindId_5_old  Integer   ,
 INOUT ioWorkTimeKindId_6_old  Integer   ,
 INOUT ioWorkTimeKindId_7_old  Integer   ,
 INOUT ioWorkTimeKindId_8_old  Integer   ,
 INOUT ioWorkTimeKindId_9_old  Integer   ,
 INOUT ioWorkTimeKindId_10_old  Integer   ,
 INOUT ioWorkTimeKindId_11_old  Integer   ,
 INOUT ioWorkTimeKindId_12_old  Integer   ,
 INOUT ioWorkTimeKindId_13_old  Integer   ,
 INOUT ioWorkTimeKindId_14_old  Integer   ,
 INOUT ioWorkTimeKindId_15_old  Integer   ,
 
    IN inIsPersonalGroup     Boolean   , -- вызов из док. список бригад
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());

    inOperDate := DATE_TRUNC ('MONTH', inOperDate);  --первое число месяца

    IF COALESCE (ioShortName_1,'') <> COALESCE (ioShortName_1_old,'') OR COALESCE (ioWorkTimeKindId_1,0) <> COALESCE (ioWorkTimeKindId_1_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_1, ioWorkTimeKindId_1
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_1 ::TVarChar, ioWorkTimeKindId_3, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_2,'') <> COALESCE (ioShortName_2_old,'') OR COALESCE (ioWorkTimeKindId_2,0) <> COALESCE (ioWorkTimeKindId_2_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_2, ioWorkTimeKindId_2
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_2 ::TVarChar, ioWorkTimeKindId_2, inIsPersonalGroup, inSession) AS tmp;
    END IF;   

    IF COALESCE (ioShortName_3,'') <> COALESCE (ioShortName_3_old,'') OR COALESCE (ioWorkTimeKindId_3,0) <> COALESCE (ioWorkTimeKindId_3_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_3, ioWorkTimeKindId_3
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_3 ::TVarChar, ioWorkTimeKindId_3, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_4,'') <> COALESCE (ioShortName_4_old,'') OR COALESCE (ioWorkTimeKindId_4,0) <> COALESCE (ioWorkTimeKindId_4_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_4, ioWorkTimeKindId_4
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_4 ::TVarChar, ioWorkTimeKindId_4, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_5,'') <> COALESCE (ioShortName_5_old,'') OR COALESCE (ioWorkTimeKindId_5,0) <> COALESCE (ioWorkTimeKindId_5_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_5, ioWorkTimeKindId_5
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_5 ::TVarChar, ioWorkTimeKindId_5, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_6,'') <> COALESCE (ioShortName_6_old,'') OR COALESCE (ioWorkTimeKindId_6,0) <> COALESCE (ioWorkTimeKindId_6_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_6, ioWorkTimeKindId_6
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_6 ::TVarChar, ioWorkTimeKindId_6, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_7,'') <> COALESCE (ioShortName_7_old,'') OR COALESCE (ioWorkTimeKindId_7,0) <> COALESCE (ioWorkTimeKindId_7_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_7, ioWorkTimeKindId_7
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_7 ::TVarChar, ioWorkTimeKindId_7, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_8,'') <> COALESCE (ioShortName_8_old,'') OR COALESCE (ioWorkTimeKindId_8,0) <> COALESCE (ioWorkTimeKindId_8_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_8, ioWorkTimeKindId_8
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_8 ::TVarChar, ioWorkTimeKindId_8, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_9,'') <> COALESCE (ioShortName_9_old,'') OR COALESCE (ioWorkTimeKindId_9,0) <> COALESCE (ioWorkTimeKindId_9_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_9, ioWorkTimeKindId_9
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_9 ::TVarChar, ioWorkTimeKindId_9, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_10,'') <> COALESCE (ioShortName_10_old,'') OR COALESCE (ioWorkTimeKindId_10,0) <> COALESCE (ioWorkTimeKindId_10_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_10, ioWorkTimeKindId_10
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_10 ::TVarChar, ioWorkTimeKindId_10, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_11,'') <> COALESCE (ioShortName_11_old,'') OR COALESCE (ioWorkTimeKindId_11,0) <> COALESCE (ioWorkTimeKindId_11_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_11, ioWorkTimeKindId_11
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_11 ::TVarChar, ioWorkTimeKindId_11, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_12,'') <> COALESCE (ioShortName_12_old,'') OR COALESCE (ioWorkTimeKindId_12,0) <> COALESCE (ioWorkTimeKindId_12_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_12, ioWorkTimeKindId_12
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_12 ::TVarChar, ioWorkTimeKindId_12, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_13,'') <> COALESCE (ioShortName_13_old,'') OR COALESCE (ioWorkTimeKindId_13,0) <> COALESCE (ioWorkTimeKindId_13_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_13, ioWorkTimeKindId_13
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_13 ::TVarChar, ioWorkTimeKindId_13, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_14,'') <> COALESCE (ioShortName_14_old,'') OR COALESCE (ioWorkTimeKindId_14,0) <> COALESCE (ioWorkTimeKindId_14_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_14, ioWorkTimeKindId_14
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_14 ::TVarChar, ioWorkTimeKindId_14, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_15,'') <> COALESCE (ioShortName_15_old,'') OR COALESCE (ioWorkTimeKindId_15,0) <> COALESCE (ioWorkTimeKindId_15_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_15, ioWorkTimeKindId_15
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_15 ::TVarChar, ioWorkTimeKindId_15, inIsPersonalGroup, inSession) AS tmp;
    END IF;

 


    ioShortName_1_old  := ioShortName_1;
    ioShortName_2_old  := ioShortName_2;
    ioShortName_3_old  := ioShortName_3;
    ioShortName_4_old  := ioShortName_4;
    ioShortName_5_old  := ioShortName_5;
    ioShortName_6_old  := ioShortName_6;
    ioShortName_7_old  := ioShortName_7;
    ioShortName_8_old  := ioShortName_8;
    ioShortName_9_old  := ioShortName_9;
    ioShortName_10_old := ioShortName_10;
    ioShortName_11_old := ioShortName_11;
    ioShortName_12_old := ioShortName_12;
    ioShortName_13_old := ioShortName_13;
    ioShortName_14_old := ioShortName_14;
    ioShortName_15_old := ioShortName_15;
    
    ioWorkTimeKindId_1_old  := ioWorkTimeKindId_1;
    ioWorkTimeKindId_2_old  := ioWorkTimeKindId_2;
    ioWorkTimeKindId_3_old  := ioWorkTimeKindId_3;
    ioWorkTimeKindId_4_old  := ioWorkTimeKindId_4;
    ioWorkTimeKindId_5_old  := ioWorkTimeKindId_5;
    ioWorkTimeKindId_6_old  := ioWorkTimeKindId_6;
    ioWorkTimeKindId_7_old  := ioWorkTimeKindId_7;
    ioWorkTimeKindId_8_old  := ioWorkTimeKindId_8;
    ioWorkTimeKindId_9_old  := ioWorkTimeKindId_9;
    ioWorkTimeKindId_10_old := ioWorkTimeKindId_10;
    ioWorkTimeKindId_11_old := ioWorkTimeKindId_11;
    ioWorkTimeKindId_12_old := ioWorkTimeKindId_12;
    ioWorkTimeKindId_13_old := ioWorkTimeKindId_13;
    ioWorkTimeKindId_14_old := ioWorkTimeKindId_14;
    ioWorkTimeKindId_15_old := ioWorkTimeKindId_15;
 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.23         * 
*/

-- тест
--