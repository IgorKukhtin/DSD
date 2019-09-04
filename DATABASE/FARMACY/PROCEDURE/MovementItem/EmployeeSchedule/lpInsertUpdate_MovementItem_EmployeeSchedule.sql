-- Function: lpInsertUpdate_MovementItem_EmployeeSchedule()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_EmployeeSchedule (Integer, Integer, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_EmployeeSchedule(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonId            Integer   , -- ���������
    IN inComingValueDay      TVarChar  , -- ������� �� ������ �� ����
    IN inComingValueDayUser  TVarChar  , -- ������� �� ������ �� ����
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitID Integer;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonId, inMovementId, 0, NULL);

    -- ��������� <������� �� ����>
    IF inComingValueDay <> ''
    THEN
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComingValueDay(), ioId, inComingValueDay);
    END IF;

    -- ��������� <������� �� ����>
    IF inComingValueDayUser <> ''
    THEN
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComingValueDayUser(), ioId, inComingValueDayUser);
    END IF;
    
    IF EXISTS(SELECT * FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId = ioId
                                                     AND MovementItemLinkObject.DescId = zc_MILinkObject_Unit()) 
    THEN
      SELECT COALESCE (ValueData, 0) 
      INTO vbUnitID
      FROM MovementItemLinkObject 
      WHERE MovementItemLinkObject.MovementItemId = ioId
        AND MovementItemLinkObject.DescId = zc_MILinkObject_Unit();
    ELSE
       vbUnitID := 0;
    END IF;
       
    IF (vbIsInsert = TRUE OR COALESCE(vbUnitID, 0) = 0) AND 
       EXISTS(SELECT COALESCE (ObjectLink_Member_Unit.ChildObjectId, 0)
              FROM ObjectLink AS ObjectLink_User_Member

                   INNER JOIN ObjectLink AS ObjectLink_Member_Unit
                                         ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                        AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

              WHERE ObjectLink_User_Member.ObjectId = inPersonId
                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member())
    THEN
       SELECT COALESCE (ObjectLink_Member_Unit.ChildObjectId, 0)
       INTO vbUnitID
       FROM ObjectLink AS ObjectLink_User_Member

            INNER JOIN ObjectLink AS ObjectLink_Member_Unit
                                  ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                 AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

       WHERE ObjectLink_User_Member.ObjectId = inPersonId
         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member();

       -- ��������� ����� � <��������������>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, vbUnitID);    
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.19                                                        *
 13.03.19                                                        *
 09.12.18                                                        *
*/