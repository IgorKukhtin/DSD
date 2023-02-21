-- Function: gpInsertUpdate_MI_SheetWorkTime_line()


DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SheetWorkTime_line2(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           
                                                           , Integer, Integer, Integer, Integer, Integer
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           
                                                           , Integer, Integer, Integer, Integer, Integer
                                                           , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           , Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SheetWorkTime_line2(
    IN inMemberId            Integer   , -- ���� ���. ����
    IN inPositionId          Integer   , -- ���������
    IN inPositionLevelId     Integer   , -- ������
    IN inUnitId              Integer   , -- �������������
    IN inPersonalGroupId     Integer   , -- ����������� ����������
    IN inStorageLineId       Integer   , -- ����� �����-��
    IN inOperDate            TDateTime , -- ����
 
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
 
 INOUT ioShortName_16_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_17_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_18_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_19_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_20_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_21_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_22_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_23_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_24_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_25_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_26_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_27_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_28_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_29_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_30_old     TVarChar  , -- ������� ��������
 INOUT ioShortName_31_old     TVarChar  , -- ������� ��������
 --
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
    IN inIsPersonalGroup     Boolean   , -- ����� �� ���. ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());

    inOperDate := DATE_TRUNC ('MONTH', inOperDate);  --������ ����� ������


    IF COALESCE (ioShortName_16,'') <> COALESCE (ioShortName_16_old,'') OR COALESCE (ioWorkTimeKindId_16,0) <> COALESCE (ioWorkTimeKindId_16_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_16, ioWorkTimeKindId_16
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_16 ::TVarChar, ioWorkTimeKindId_16, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_17,'') <> COALESCE (ioShortName_17_old,'') OR COALESCE (ioWorkTimeKindId_17,0) <> COALESCE (ioWorkTimeKindId_17_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_17, ioWorkTimeKindId_17
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_17 ::TVarChar, ioWorkTimeKindId_17, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_18,'') <> COALESCE (ioShortName_18_old,'') OR COALESCE (ioWorkTimeKindId_18,0) <> COALESCE (ioWorkTimeKindId_18_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_18, ioWorkTimeKindId_18
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_18 ::TVarChar, ioWorkTimeKindId_18, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_19,'') <> COALESCE (ioShortName_19_old,'') OR COALESCE (ioWorkTimeKindId_19,0) <> COALESCE (ioWorkTimeKindId_19_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_19, ioWorkTimeKindId_19
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_19 ::TVarChar, ioWorkTimeKindId_19, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_20,'') <> COALESCE (ioShortName_20_old,'') OR COALESCE (ioWorkTimeKindId_20,0) <> COALESCE (ioWorkTimeKindId_20_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_20, ioWorkTimeKindId_20
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_20 ::TVarChar, ioWorkTimeKindId_20, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_21,'') <> COALESCE (ioShortName_21_old,'') OR COALESCE (ioWorkTimeKindId_21,0) <> COALESCE (ioWorkTimeKindId_21_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_21, ioWorkTimeKindId_21
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_21 ::TVarChar, ioWorkTimeKindId_21, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_22,'') <> COALESCE (ioShortName_22_old,'') OR COALESCE (ioWorkTimeKindId_22,0) <> COALESCE (ioWorkTimeKindId_22_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_22, ioWorkTimeKindId_22
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_22 ::TVarChar, ioWorkTimeKindId_22, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_23,'') <> COALESCE (ioShortName_23_old,'') OR COALESCE (ioWorkTimeKindId_23,0) <> COALESCE (ioWorkTimeKindId_23_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_23, ioWorkTimeKindId_23
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_23 ::TVarChar, ioWorkTimeKindId_23, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_24,'') <> COALESCE (ioShortName_24_old,'') OR COALESCE (ioWorkTimeKindId_24,0) <> COALESCE (ioWorkTimeKindId_24_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_24, ioWorkTimeKindId_24
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_24 ::TVarChar, ioWorkTimeKindId_24, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_25,'') <> COALESCE (ioShortName_25_old,'') OR COALESCE (ioWorkTimeKindId_25,0) <> COALESCE (ioWorkTimeKindId_25_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_25, ioWorkTimeKindId_25
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_25 ::TVarChar, ioWorkTimeKindId_25, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_26,'') <> COALESCE (ioShortName_26_old,'') OR COALESCE (ioWorkTimeKindId_26,0) <> COALESCE (ioWorkTimeKindId_26_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_26, ioWorkTimeKindId_26
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_26 ::TVarChar, ioWorkTimeKindId_26, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_27,'') <> COALESCE (ioShortName_27_old,'') OR COALESCE (ioWorkTimeKindId_27,0) <> COALESCE (ioWorkTimeKindId_27_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_27, ioWorkTimeKindId_27
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_27 ::TVarChar, ioWorkTimeKindId_27, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_28,'') <> COALESCE (ioShortName_28_old,'') OR COALESCE (ioWorkTimeKindId_28,0) <> COALESCE (ioWorkTimeKindId_28_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_28, ioWorkTimeKindId_28
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_28 ::TVarChar, ioWorkTimeKindId_28, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_29,'') <> COALESCE (ioShortName_29_old,'') OR COALESCE (ioWorkTimeKindId_29,0) <> COALESCE (ioWorkTimeKindId_29_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_29, ioWorkTimeKindId_29
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_29 ::TVarChar, ioWorkTimeKindId_29, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_30,'') <> COALESCE (ioShortName_30_old,'') OR COALESCE (ioWorkTimeKindId_30,0) <> COALESCE (ioWorkTimeKindId_30_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_30, ioWorkTimeKindId_30
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_30 ::TVarChar, ioWorkTimeKindId_30, inIsPersonalGroup, inSession) AS tmp;
    END IF;

    IF COALESCE (ioShortName_31,'') <> COALESCE (ioShortName_31_old,'') OR COALESCE (ioWorkTimeKindId_31,0) <> COALESCE (ioWorkTimeKindId_31_old,0)
    THEN 
       -- ���������
       SELECT tmp.ioValue, tmp.ioTypeId INTO ioShortName_31, ioWorkTimeKindId_31
       FROM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate, ioShortName_31 ::TVarChar, ioWorkTimeKindId_31, inIsPersonalGroup, inSession) AS tmp;
    END IF;


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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.02.23         * 
*/

-- ����
--