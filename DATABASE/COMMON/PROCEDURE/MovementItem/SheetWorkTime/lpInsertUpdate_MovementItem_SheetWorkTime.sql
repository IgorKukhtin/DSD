-- Function: lpInsertUpdate_MovementItem_SheetWorkTime ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SheetWorkTime (Integer, Integer, Integer, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, Integer, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_SheetWorkTime(
    IN inMovementItemId      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inMemberId            Integer   , -- �������
    IN inPositionId          Integer   , -- ���������
    IN inPositionLevelId     Integer   , -- ������
    IN inPersonalGroupId     Integer   , -- ����������� ����������
    IN inStorageLineId       Integer   , -- ����� �����-��
    IN inAmount              TFloat    , -- ���������� ����� ����
    IN inWorkTimeKindId      Integer     -- ���� �������� �������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUnitId Integer;
BEGIN

     -- ��� "������������" + �������� ������ - ��������� ����������� ���� - ������������ �� ��������� �� zc_ObjectFloat_StaffList_HoursDay - ���� ��������
     IF COALESCE (inWorkTimeKindId,0) IN (zc_Enum_WorkTimeKind_Trip(), zc_Enum_WorkTimeKind_RemoteAccess())
     THEN
         -- ���� �� ������s ���� �� ���� � �����������
         IF COALESCE (inAmount,0) = 0
         THEN
             --������������� �� ����� ���������
             vbUnitId := (SELECT MovementLinkObject_Unit.ObjectId
                          FROM MovementLinkObject AS MovementLinkObject_Unit
                          WHERE MovementLinkObject_Unit.MovementId = inMovementId
                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                          );
             -- ���������� ����
             inAmount := (WITH
                          tmpStaffList AS (SELECT ObjectLink_StaffList_Unit.ChildObjectId AS UnitId
                                                , ObjectLink_StaffList_Position.ChildObjectId AS PositionId
                                                , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) AS HoursDay
                                           FROM OBJECT AS Object_StaffList
                                                 INNER JOIN ObjectLink AS ObjectLink_StaffList_Position
                                                                       ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                                                      AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
    
                                                 LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                                                      ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                                                     AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit() 
                                                 LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                                                       ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                                                                      AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
                                            WHERE Object_StaffList.DescId = zc_Object_StaffList()
                                              AND Object_StaffList.isErased = False
                                            GROUP BY ObjectLink_StaffList_Unit.ChildObjectId
                                                   , ObjectLink_StaffList_Position.ChildObjectId
                                            HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
                                          )
                          SELECT COALESCE ( (SELECT tmpStaffList.HoursDay
                                             FROM tmpStaffList
                                             WHERE tmpStaffList.UnitId = vbUnitId
                                               AND tmpStaffList.PositionId = inPositionId)
                                           , (SELECT MAX (tmpStaffList.HoursDay)
                                             FROM tmpStaffList
                                             WHERE tmpStaffList.PositionId = inPositionId)
                                           )
                          );
             --���� ���� �� ������� �� ���������
             IF COALESCE (inAmount,0) = 0
             THEN
                 RAISE EXCEPTION '������.��� <%> ��� ����� �����', lfGet_Object_ValueData_sh(inWorkTimeKindId);
             END IF;
         END IF;
         
     END IF;

     -- ��������� <������� ���������>
     inMovementItemId := lpInsertUpdate_MovementItem (inMovementItemId, zc_MI_Master(), inMemberId, inMovementId, COALESCE (inAmount,0), NULL);

     -- ��������� ����� � <����������� �����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalGroup(), InMovementItemId, inPersonalGroupId);
     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), InMovementItemId, inPositionId);
     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), InMovementItemId, inPositionLevelId);
     -- ��������� ����� � <���� �������� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_WorkTimeKind(), InMovementItemId, inWorkTimeKindId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StorageLine(), InMovementItemId, inStorageLineId);

     RETURN inMovementItemId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.08.21         *
 25.05.17         * add StorageLine
 07.01.14                         * Replace inPersonalId <> inMemberId
 25.11.13                         *
 03.10.13         *

*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_SheetWorkTime (InMovementItemId:= 0, inMovementId:= 10, inPersonalId:= 1, inAmount:= 0, inSession:= '2')


/*

 
WITH 

tmpStaffList AS (SELECT ObjectLink_StaffList_Unit.ChildObjectId AS UnitId
                      , ObjectLink_StaffList_Position.ChildObjectId AS PositionId
                      , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) AS HoursDay
                 FROM OBJECT AS Object_StaffList
                       INNER JOIN ObjectLink AS ObjectLink_StaffList_Position
                                             ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                            AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()

                       LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                            ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                           AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit() 
                       LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                             ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                                            AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
                  WHERE Object_StaffList.DescId = zc_Object_StaffList()
                    AND Object_StaffList.isErased = False
                  GROUP BY ObjectLink_StaffList_Unit.ChildObjectId
                         , ObjectLink_StaffList_Position.ChildObjectId
                  HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
                  )

SELECT Movement.operDate
             , MI_SheetWorkTime.Amount
            
, Object_Unit.ValueData AS UnitName
, Object_Member.*
, COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) AS HoursDay
,tmpStaffList.HoursDay, tmpStaffList2.HoursDay AS HoursDay2
, MI_SheetWorkTime.Id
, MI_SheetWorkTime.ObjectId
, MI_SheetWorkTime.MovementId
, lpInsertUpdate_MovementItem (MI_SheetWorkTime.Id, zc_MI_Master(), MI_SheetWorkTime.ObjectId, MI_SheetWorkTime.MovementId, COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0), NULL)
        FROM Movement

             JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
--MovementLinkObject_Unit.ObjectId = inUnitId
             JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id

             INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                              ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                             AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                             AND MIObject_WorkTimeKind.ObjectId IN (zc_Enum_WorkTimeKind_Trip(), zc_Enum_WorkTimeKind_RemoteAccess())
             LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                              ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                             AND MIObject_Position.DescId = zc_MILinkObject_Position()
  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
LEFT JOIN Object AS Object_Member ON Object_Member.Id = MIObject_Position.ObjectId

LEFT JOIN tmpStaffList ON tmpStaffList.UnitId = MovementLinkObject_Unit.ObjectId
                                         AND tmpStaffList.PositionId = MIObject_Position.ObjectId
LEFT JOIN (SELECT tmpStaffList.PositionId, MAX (tmpStaffList.HoursDay) AS HoursDay FROM tmpStaffList GROUP BY tmpStaffList.PositionId
           ) AS tmpStaffList2 ON tmpStaffList2.PositionId = MIObject_Position.ObjectId

        WHERE Movement.operDate between '01.04.2021' AND '31.07.2021'-- tmpOperDate.OperDate
                          AND Movement.DescId = zc_Movement_SheetWorkTime()
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
and COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) <> 0





*/
