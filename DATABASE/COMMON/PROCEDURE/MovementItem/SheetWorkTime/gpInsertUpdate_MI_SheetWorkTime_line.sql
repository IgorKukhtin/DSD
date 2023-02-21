-- Function: gpInsertUpdate_MI_SheetWorkTime_line()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SheetWorkTime_line(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar, TVarChar, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SheetWorkTime_line(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SheetWorkTime_line(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           , Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SheetWorkTime_line(
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
 INOUT ioShortName_16         TVarChar  ,
 INOUT ioShortName_17         TVarChar  ,
 INOUT ioShortName_18         TVarChar  ,
 INOUT ioShortName_19         TVarChar  ,
 INOUT ioShortName_20         TVarChar  ,
 INOUT ioShortName_21         TVarChar  ,
 INOUT ioShortName_22         TVarChar  ,
 INOUT ioShortName_23         TVarChar  ,
 INOUT ioShortName_24         TVarChar  ,
 INOUT ioShortName_25         TVarChar  ,
 INOUT ioShortName_26         TVarChar  ,
 INOUT ioShortName_27         TVarChar  ,
 INOUT ioShortName_28         TVarChar  ,
 INOUT ioShortName_29         TVarChar  ,
 INOUT ioShortName_30         TVarChar  ,
 INOUT ioShortName_31         TVarChar  ,
 
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
 INOUT ioShortName_16_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_17_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_18_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_19_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_20_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_21_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_22_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_23_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_24_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_25_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_26_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_27_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_28_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_29_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_30_old     TVarChar  , -- прошлое значение
 INOUT ioShortName_31_old     TVarChar  , -- прошлое значение
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
 INOUT ioWorkTimeKindId_16      Integer   ,
 INOUT ioWorkTimeKindId_17      Integer   ,
 INOUT ioWorkTimeKindId_18      Integer   ,
 INOUT ioWorkTimeKindId_19      Integer   ,
 INOUT ioWorkTimeKindId_20      Integer   ,
 INOUT ioWorkTimeKindId_21      Integer   ,
 INOUT ioWorkTimeKindId_22      Integer   ,
 INOUT ioWorkTimeKindId_23      Integer   ,
 INOUT ioWorkTimeKindId_24      Integer   ,
 INOUT ioWorkTimeKindId_25      Integer   ,
 INOUT ioWorkTimeKindId_26      Integer   ,
 INOUT ioWorkTimeKindId_27      Integer   ,
 INOUT ioWorkTimeKindId_28      Integer   ,
 INOUT ioWorkTimeKindId_29      Integer   ,
 INOUT ioWorkTimeKindId_30      Integer   ,
 INOUT ioWorkTimeKindId_31      Integer   ,
 
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
 INOUT ioWorkTimeKindId_16_old  Integer   ,
 INOUT ioWorkTimeKindId_17_old  Integer   ,
 INOUT ioWorkTimeKindId_18_old  Integer   ,
 INOUT ioWorkTimeKindId_19_old  Integer   ,
 INOUT ioWorkTimeKindId_20_old  Integer   ,
 INOUT ioWorkTimeKindId_21_old  Integer   ,
 INOUT ioWorkTimeKindId_22_old  Integer   ,
 INOUT ioWorkTimeKindId_23_old  Integer   ,
 INOUT ioWorkTimeKindId_24_old  Integer   ,
 INOUT ioWorkTimeKindId_25_old  Integer   ,
 INOUT ioWorkTimeKindId_26_old  Integer   ,
 INOUT ioWorkTimeKindId_27_old  Integer   ,
 INOUT ioWorkTimeKindId_28_old  Integer   ,
 INOUT ioWorkTimeKindId_29_old  Integer   ,
 INOUT ioWorkTimeKindId_30_old  Integer   ,
 INOUT ioWorkTimeKindId_31_old  Integer   ,
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
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_1 ::TVarChar, ioWorkTimeKindId_3, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_2,'') <> COALESCE (ioShortName_2_old,'') OR COALESCE (ioWorkTimeKindId_2,0) <> COALESCE (ioWorkTimeKindId_2_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_2, ioWorkTimeKindId_2
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_2 ::TVarChar, ioWorkTimeKindId_2, inIsPersonalGroup, inSession) AS tmp;
    END IF;   

    IF COALESCE (ioShortName_3,'') <> COALESCE (ioShortName_3_old,'') OR COALESCE (ioWorkTimeKindId_3,0) <> COALESCE (ioWorkTimeKindId_3_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_3, ioWorkTimeKindId_3
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_3 ::TVarChar, ioWorkTimeKindId_3, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_4,'') <> COALESCE (ioShortName_4_old,'') OR COALESCE (ioWorkTimeKindId_4,0) <> COALESCE (ioWorkTimeKindId_4_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_4, ioWorkTimeKindId_4
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_4 ::TVarChar, ioWorkTimeKindId_4, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_5,'') <> COALESCE (ioShortName_5_old,'') OR COALESCE (ioWorkTimeKindId_5,0) <> COALESCE (ioWorkTimeKindId_5_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_5, ioWorkTimeKindId_5
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_5 ::TVarChar, ioWorkTimeKindId_5, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_6,'') <> COALESCE (ioShortName_6_old,'') OR COALESCE (ioWorkTimeKindId_6,0) <> COALESCE (ioWorkTimeKindId_6_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_6, ioWorkTimeKindId_6
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_6 ::TVarChar, ioWorkTimeKindId_6, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_7,'') <> COALESCE (ioShortName_7_old,'') OR COALESCE (ioWorkTimeKindId_7,0) <> COALESCE (ioWorkTimeKindId_7_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_7, ioWorkTimeKindId_7
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_7 ::TVarChar, ioWorkTimeKindId_7, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_8,'') <> COALESCE (ioShortName_8_old,'') OR COALESCE (ioWorkTimeKindId_8,0) <> COALESCE (ioWorkTimeKindId_8_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_8, ioWorkTimeKindId_8
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_8 ::TVarChar, ioWorkTimeKindId_8, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_9,'') <> COALESCE (ioShortName_9_old,'') OR COALESCE (ioWorkTimeKindId_9,0) <> COALESCE (ioWorkTimeKindId_9_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_9, ioWorkTimeKindId_9
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_9 ::TVarChar, ioWorkTimeKindId_9, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_10,'') <> COALESCE (ioShortName_10_old,'') OR COALESCE (ioWorkTimeKindId_10,0) <> COALESCE (ioWorkTimeKindId_10_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_10, ioWorkTimeKindId_10
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_10 ::TVarChar, ioWorkTimeKindId_10, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_11,'') <> COALESCE (ioShortName_11_old,'') OR COALESCE (ioWorkTimeKindId_11,0) <> COALESCE (ioWorkTimeKindId_11_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_11, ioWorkTimeKindId_11
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_11 ::TVarChar, ioWorkTimeKindId_11, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_12,'') <> COALESCE (ioShortName_12_old,'') OR COALESCE (ioWorkTimeKindId_12,0) <> COALESCE (ioWorkTimeKindId_12_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_12, ioWorkTimeKindId_12
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_12 ::TVarChar, ioWorkTimeKindId_12, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_13,'') <> COALESCE (ioShortName_13_old,'') OR COALESCE (ioWorkTimeKindId_13,0) <> COALESCE (ioWorkTimeKindId_13_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_13, ioWorkTimeKindId_13
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_13 ::TVarChar, ioWorkTimeKindId_13, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_14,'') <> COALESCE (ioShortName_14_old,'') OR COALESCE (ioWorkTimeKindId_14,0) <> COALESCE (ioWorkTimeKindId_14_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_14, ioWorkTimeKindId_14
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_14 ::TVarChar, ioWorkTimeKindId_14, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_15,'') <> COALESCE (ioShortName_15_old,'') OR COALESCE (ioWorkTimeKindId_15,0) <> COALESCE (ioWorkTimeKindId_15_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_15, ioWorkTimeKindId_15
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_15 ::TVarChar, ioWorkTimeKindId_15, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_16,'') <> COALESCE (ioShortName_16_old,'') OR COALESCE (ioWorkTimeKindId_16,0) <> COALESCE (ioWorkTimeKindId_16_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_16, ioWorkTimeKindId_16
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_16 ::TVarChar, ioWorkTimeKindId_16, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_17,'') <> COALESCE (ioShortName_17_old,'') OR COALESCE (ioWorkTimeKindId_17,0) <> COALESCE (ioWorkTimeKindId_17_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_17, ioWorkTimeKindId_17
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_17 ::TVarChar, ioWorkTimeKindId_17, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_18,'') <> COALESCE (ioShortName_18_old,'') OR COALESCE (ioWorkTimeKindId_18,0) <> COALESCE (ioWorkTimeKindId_18_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_18, ioWorkTimeKindId_18
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_18 ::TVarChar, ioWorkTimeKindId_18, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_19,'') <> COALESCE (ioShortName_19_old,'') OR COALESCE (ioWorkTimeKindId_19,0) <> COALESCE (ioWorkTimeKindId_19_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_19, ioWorkTimeKindId_19
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_19 ::TVarChar, ioWorkTimeKindId_19, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_20,'') <> COALESCE (ioShortName_20_old,'') OR COALESCE (ioWorkTimeKindId_20,0) <> COALESCE (ioWorkTimeKindId_20_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_20, ioWorkTimeKindId_20
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_20 ::TVarChar, ioWorkTimeKindId_20, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_21,'') <> COALESCE (ioShortName_21_old,'') OR COALESCE (ioWorkTimeKindId_21,0) <> COALESCE (ioWorkTimeKindId_21_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_21, ioWorkTimeKindId_21
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_21 ::TVarChar, ioWorkTimeKindId_21, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_22,'') <> COALESCE (ioShortName_22_old,'') OR COALESCE (ioWorkTimeKindId_22,0) <> COALESCE (ioWorkTimeKindId_22_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_22, ioWorkTimeKindId_22
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_22 ::TVarChar, ioWorkTimeKindId_22, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_23,'') <> COALESCE (ioShortName_23_old,'') OR COALESCE (ioWorkTimeKindId_23,0) <> COALESCE (ioWorkTimeKindId_23_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_23, ioWorkTimeKindId_23
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_23 ::TVarChar, ioWorkTimeKindId_23, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_24,'') <> COALESCE (ioShortName_24_old,'') OR COALESCE (ioWorkTimeKindId_24,0) <> COALESCE (ioWorkTimeKindId_24_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_24, ioWorkTimeKindId_24
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_24 ::TVarChar, ioWorkTimeKindId_24, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_25,'') <> COALESCE (ioShortName_25_old,'') OR COALESCE (ioWorkTimeKindId_25,0) <> COALESCE (ioWorkTimeKindId_25_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_25, ioWorkTimeKindId_25
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_25 ::TVarChar, ioWorkTimeKindId_25, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_26,'') <> COALESCE (ioShortName_26_old,'') OR COALESCE (ioWorkTimeKindId_26,0) <> COALESCE (ioWorkTimeKindId_26_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_26, ioWorkTimeKindId_26
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_26 ::TVarChar, ioWorkTimeKindId_26, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_27,'') <> COALESCE (ioShortName_27_old,'') OR COALESCE (ioWorkTimeKindId_27,0) <> COALESCE (ioWorkTimeKindId_27_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_27, ioWorkTimeKindId_27
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_27 ::TVarChar, ioWorkTimeKindId_27, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_28,'') <> COALESCE (ioShortName_28_old,'') OR COALESCE (ioWorkTimeKindId_28,0) <> COALESCE (ioWorkTimeKindId_28_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_28, ioWorkTimeKindId_28
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_28 ::TVarChar, ioWorkTimeKindId_28, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_29,'') <> COALESCE (ioShortName_29_old,'') OR COALESCE (ioWorkTimeKindId_29,0) <> COALESCE (ioWorkTimeKindId_29_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_29, ioWorkTimeKindId_29
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_29 ::TVarChar, ioWorkTimeKindId_29, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_30,'') <> COALESCE (ioShortName_30_old,'') OR COALESCE (ioWorkTimeKindId_30,0) <> COALESCE (ioWorkTimeKindId_30_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_30, ioWorkTimeKindId_30
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_30 ::TVarChar, ioWorkTimeKindId_30, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_31,'') <> COALESCE (ioShortName_31_old,'') OR COALESCE (ioWorkTimeKindId_31,0) <> COALESCE (ioWorkTimeKindId_31_old,0)
    THEN 
       -- сохранили
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_31, ioWorkTimeKindId_31
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionI, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_31 ::TVarChar, ioWorkTimeKindId_31, inIsPersonalGroup, inSession) AS tmp;
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
    ioShortName_16_old := ioShortName_16;
    ioShortName_17_old := ioShortName_17;
    ioShortName_18_old := ioShortName_18;
    ioShortName_19_old := ioShortName_19;
    ioShortName_20_old := ioShortName_20;
    ioShortName_21_old := ioShortName_21;
    ioShortName_22_old := ioShortName_22;
    ioShortName_23_old := ioShortName_23;
    ioShortName_24_old := ioShortName_24;
    ioShortName_25_old := ioShortName_25;
    ioShortName_26_old := ioShortName_26;
    ioShortName_27_old := ioShortName_27;
    ioShortName_28_old := ioShortName_28;
    ioShortName_29_old := ioShortName_29;
    ioShortName_30_old := ioShortName_30;
    ioShortName_31_old := ioShortName_31;
    
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
    ioWorkTimeKindId_16_old := ioWorkTimeKindId_16;
    ioWorkTimeKindId_17_old := ioWorkTimeKindId_17;
    ioWorkTimeKindId_18_old := ioWorkTimeKindId_18;
    ioWorkTimeKindId_19_old := ioWorkTimeKindId_19;
    ioWorkTimeKindId_20_old := ioWorkTimeKindId_20;
    ioWorkTimeKindId_21_old := ioWorkTimeKindId_21;
    ioWorkTimeKindId_22_old := ioWorkTimeKindId_22;
    ioWorkTimeKindId_23_old := ioWorkTimeKindId_23;
    ioWorkTimeKindId_24_old := ioWorkTimeKindId_24;
    ioWorkTimeKindId_25_old := ioWorkTimeKindId_25;
    ioWorkTimeKindId_26_old := ioWorkTimeKindId_26;
    ioWorkTimeKindId_27_old := ioWorkTimeKindId_27;
    ioWorkTimeKindId_28_old := ioWorkTimeKindId_28;
    ioWorkTimeKindId_29_old := ioWorkTimeKindId_29;
    ioWorkTimeKindId_30_old := ioWorkTimeKindId_30;
    ioWorkTimeKindId_31_old := ioWorkTimeKindId_31;

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