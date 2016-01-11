-- Function: gpInsertUpdate_SheetWorkTime_FromTransport()

DROP FUNCTION IF EXISTS gpInsertUpdate_SheetWorkTime_FromTransport(INTEGER, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_SheetWorkTime_FromTransport(
    IN inUnitId              Integer   , -- �������������
    IN inOperDate            TDateTime , -- ���� ��������� �����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbStartDate TDateTime;
          vbEndDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     vbStartDate := date_trunc('month', inOperDate)                            ;    -- ������ ����� ������
     vbEndDate := vbStartDate + interval '1 month' - interval '1 microseconds' ;    -- ��������� ����� ������


    PERFORM                          
           gpInsertUpdate_MovementItem_SheetWorkTime(
              inMemberId        := View_PersonalDriver.MemberId        , -- ���� ���. ����
              inPositionId      := View_PersonalDriver.PositionId      , -- ���������
              inPositionLevelId := View_PersonalDriver.PositionLevelId , -- ������
              inUnitId          := inUnitId                            , -- �������������
              inPersonalGroupId := View_PersonalDriver.PersonalGroupId , -- ����������� ����������
              inOperDate        := Movement.OperDate                   , -- ���� ��������� �����
              ioValue           := SUM (CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat))::TVarChar                    , -- ����
              ioTypeId          := zc_Enum_WorkTimeKind_Work()         , 
              inSession         := inSession)    -- ������ ������������
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId =  Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
            JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
       WHERE Movement.DescId = zc_Movement_Transport()
         AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate 
         AND Movement.StatusId = zc_enum_status_complete() 
         AND View_PersonalDriver.unitid = inUnitId
       GROUP BY  
             Movement.OperDate
           , View_PersonalDriver.memberid     
           , View_PersonalDriver.positionid
           , View_PersonalDriver.positionlevelid
           , View_PersonalDriver.personalgroupid;

    PERFORM                          
           gpInsertUpdate_MovementItem_SheetWorkTime(
              inMemberId        := View_PersonalDriver.MemberId        , -- ���� ���. ����
              inPositionId      := View_PersonalDriver.PositionId      , -- ���������
              inPositionLevelId := View_PersonalDriver.PositionLevelId , -- ������
              inUnitId          := inUnitId                            , -- �������������
              inPersonalGroupId := View_PersonalDriver.PersonalGroupId , -- ����������� ����������
              inOperDate        := Movement.OperDate                   , -- ���� ��������� �����
              ioValue           := SUM(CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat))::TVarChar                    , -- ����
              ioTypeId          := zc_Enum_WorkTimeKind_Work()         , 
              inSession         := inSession)    -- ������ ������������
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId =  Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
            JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriverMore()
            JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
       WHERE Movement.DescId = zc_Movement_Transport()
         AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate 
         AND Movement.StatusId = zc_enum_status_complete() 
         AND View_PersonalDriver.unitid = inUnitId
       GROUP BY  
             Movement.OperDate
           , View_PersonalDriver.memberid     
           , View_PersonalDriver.positionid
           , View_PersonalDriver.positionlevelid
           , View_PersonalDriver.personalgroupid;


    PERFORM                          
           gpInsertUpdate_MovementItem_SheetWorkTime(
              inMemberId        := View_PersonalDriver.MemberId        , -- ���� ���. ����
              inPositionId      := View_PersonalDriver.PositionId      , -- ���������
              inPositionLevelId := View_PersonalDriver.PositionLevelId , -- ������
              inUnitId          := inUnitId                            , -- �������������
              inPersonalGroupId := View_PersonalDriver.PersonalGroupId , -- ����������� ����������
              inOperDate        := Movement.OperDate                   , -- ���� ��������� �����
              ioValue           := SUM(CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat))::TVarChar                    , -- ����
              ioTypeId          := zc_Enum_WorkTimeKind_Work()         , 
              inSession         := inSession)    -- ������ ������������
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId =  Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
            JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_Personal()
            JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
       WHERE Movement.DescId = zc_Movement_Transport()
         AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate 
         AND Movement.StatusId = zc_enum_status_complete() 
         AND View_PersonalDriver.unitid = inUnitId
       GROUP BY  
             Movement.OperDate
           , View_PersonalDriver.memberid     
           , View_PersonalDriver.positionid
           , View_PersonalDriver.positionlevelid
           , View_PersonalDriver.personalgroupid;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.02.14                         * Replace inPersonalId <> inMemberId

*/

-- ����
-- SELECT * FROM gpInsertUpdate_SheetWorkTime_FromTransport (, inSession:= '2')
