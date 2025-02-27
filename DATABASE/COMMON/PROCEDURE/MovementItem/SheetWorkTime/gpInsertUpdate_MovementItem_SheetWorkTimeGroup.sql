-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTimeGroup (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTimeGroup (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTimeGroup (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTimeGroup(
    IN inMemberId            Integer   , -- ���� ���. ����
    IN inPositionId          Integer   , -- ���������
    IN inPositionLevelId     Integer   , -- ������
    IN inUnitId              Integer   , -- �������������
    IN inPersonalGroupId     Integer   , -- ����������� ����������
    IN inStorageLineId       Integer   , -- ����� �����-��
    IN inOldMemberId         Integer   , -- ���� ���. ����
    IN inOldPositionId       Integer   , -- ���������
    IN inOldPositionLevelId  Integer   , -- ������
    IN inOldPersonalGroupId  Integer   , -- ����������� ����������
    IN inOldStorageLineId    Integer   , -- ����� �����-��
    IN inOperDate            TDateTime , -- ���� ��������� �����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbMICount   Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);


    -- ������ ����� ������
    vbStartDate := DATE_TRUNC ('MONTH', inOperDate);
    -- ��������� ����� ������
    vbEndDate := vbStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY';


    -- ��������
    IF NOT EXISTS (SELECT 1
                   FROM Object_Personal_View
                   WHERE Object_Personal_View.UnitId     = inUnitId
                     AND Object_Personal_View.MemberId   = inMemberId
                     AND Object_Personal_View.PositionId = inPositionId
                     AND Object_Personal_View.isErased   = FALSE
                  )
     AND vbUserId <> 5
    THEN
        RAISE EXCEPTION '������.� ����������� ����������� <%> <%>  <%> �� ������.'
                      , lfGet_Object_ValueData_sh (inMemberId)
                      , lfGet_Object_ValueData_sh (inPositionId)
                      , lfGet_Object_ValueData_sh (inUnitId)
                        ;
    END IF;

    -- ��������
    IF NOT EXISTS (SELECT 1
                   FROM Object_Personal_View
                   WHERE Object_Personal_View.DateIn     <= vbEndDate
                     AND Object_Personal_View.DateOut    >= vbEndDate
                     AND Object_Personal_View.UnitId     = inUnitId
                     AND Object_Personal_View.MemberId   = inMemberId
                     AND Object_Personal_View.PositionId = inPositionId
                  )
     AND vbUserId <> 5
    THEN
        RAISE EXCEPTION '������. ��������� <%> <%>  <%> ������ � <%>.���� � ������ ������.'
                      , lfGet_Object_ValueData_sh (inMemberId)
                      , lfGet_Object_ValueData_sh (inPositionId)
                      , lfGet_Object_ValueData_sh (inUnitId)
                      , (SELECT zfConvert_DateToString (MAX (Object_Personal_View.DateOut))
                         FROM Object_Personal_View
                         WHERE Object_Personal_View.DateOut    <= vbEndDate
                           AND Object_Personal_View.UnitId     = inUnitId
                           AND Object_Personal_View.MemberId   = inMemberId
                           AND Object_Personal_View.PositionId = inPositionId
                        )
                        ;
    END IF;

    -- ������� ��������� ��� ��� � ������ �������
    SELECT COUNT(*)
           INTO vbMICount
    FROM MovementItem AS MI_SheetWorkTime
            INNER JOIN Movement AS Movement_SheetWorkTime
                                ON Movement_SheetWorkTime.Id = MI_SheetWorkTime.MovementId 
                               AND Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() 
                               AND Movement_SheetWorkTime.OperDate >= vbStartDate AND Movement_SheetWorkTime.OperDate <= vbEndDate

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit 
                                          ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                         AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                         AND MovementLinkObject_Unit.ObjectId = inUnitId 

            LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                             ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                            AND MIObject_Position.DescId = zc_MILinkObject_Position() 

            LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                             ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                            AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 

            LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                             ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                            AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 

            LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                   ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id 
                                                  AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine() 

       WHERE MI_SheetWorkTime.ObjectId = inMemberId
         AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
         AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
         AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
         AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
       ;

    -- ��������
    IF vbMICount > 0
    THEN
        RAISE EXCEPTION '��������� � ������ ����������� ��� ���� � ������.';
    END IF;


    -- ��� ������ �� ����� ���������� + ...
    CREATE TEMP TABLE _tmpMI (MovementItemId Integer) ON COMMIT DROP;
    -- 
    INSERT INTO _tmpMI (MovementItemId)
                         SELECT MI_SheetWorkTime.Id 
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  = inUnitId
                              INNER JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                                          AND MI_SheetWorkTime.ObjectId  = inOldMemberId
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position()
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                                     ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine() 
                         WHERE Movement.OperDate >= vbStartDate AND Movement.OperDate <= vbEndDate
                           AND Movement.DescId = zc_Movement_SheetWorkTime()
                           AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inOldPositionId, 0)
                           AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inOldPositionLevelId, 0)
                           AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inOldPersonalGroupId, 0)
                           AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                        ;

    IF inOldMemberId = 0 OR NOT EXISTS (SELECT 1 FROM _tmpMI)
    THEN
        -- ��� ������ ���������� ������ ���������
        PERFORM gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inStorageLineId, inOperDate
                                                         , '0', NULL, 0, FALSE, inSession
                                                         ); -- zc_Enum_WorkTimeKind_Work()
    ELSE
       -- ��������� ���� ����������

       -- ��� ����.
       UPDATE MovementItem SET ObjectId = inMemberId WHERE Id IN (SELECT MovementItemId FROM _tmpMI);
       -- ��� ���������
       PERFORM -- ��������� ����� � <����������� �����������>
               lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalGroup(), MovementItemId, inPersonalGroupId)
               -- ��������� ����� � <����������>
             , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), MovementItemId, inPositionId)
               -- ��������� ����� � <������>
             , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), MovementItemId, inPositionLevelId)
               -- ��������� ����� � <����� ��-��>
             , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StorageLine(), MovementItemId, inStorageLineId)
        FROM _tmpMI;     

        -- ��������� ��������
        PERFORM lpInsert_MovementItemProtocol (_tmpMI.MovementItemId, vbUserId, FALSE) FROM _tmpMI;

     END IF;                   

if vbUserId = 5 AND 1=1
then
    RAISE EXCEPTION 'Admin.<%> <%> <%> <%> <%> <%>'
                      , zfConvert_DateToString (inOperDate)
                      , inUnitId
                      , inMemberId
                      , inPositionId
                      , zfConvert_DateToString (vbStartDate)
                      , zfConvert_DateToString (vbEndDate)
                       ;
end if;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.17         * add StorageLine
 10.01.14                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SheetWorkTimeGroup (, inSession:= '2')
