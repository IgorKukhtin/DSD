-- Function: gpUpdate_MovementItem_TestingUser()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_TestingUser(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_TestingUser(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inTestingUser         Integer   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbUserWagesId Integer;
   DECLARE vbPosition Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (inId, 0) = 0
    THEN
        RAISE EXCEPTION '������. �� ���������� ID ������ ��������.';
    END IF;

    IF NOT EXISTS(SELECT 1 FROM MovementItem
                  WHERE MovementItem.ID = inId
                    AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION '������. ��������� ����������� �������� ��������� ������ �����������..';
    END IF;

    -- �������� vbMovementId
    SELECT MovementItem.MovementId, MovementItem.ObjectID, COALESCE (ObjectLink_Member_Position.ChildObjectId, 0)
    INTO vbMovementId, vbUserWagesId, vbPosition
    FROM MovementItem
         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                              ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                             AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
         LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                              ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                             AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
    WHERE MovementItem.ID = inId
      AND MovementItem.DescId = zc_MI_Master();

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������. ��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF vbPosition <> 1672498
    THEN
        RAISE EXCEPTION '������. ��������� ����������� �������� ��������� ������ �����������.';
    END IF;

    IF inTestingUser = 0
    THEN
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isTestingUser(), inId, False);
    ELSEIF  inTestingUser = 1
    THEN
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isTestingUser(), inId, True);
    ELSEIF  inTestingUser = 2
    THEN
      IF EXISTS(SELECT * FROM MovementItemBoolean WHERE MovementItemBoolean.MovementItemID = inId AND MovementItemBoolean.DescId = zc_MIBoolean_isTestingUser())
      THEN
        DELETE FROM MovementItemBoolean WHERE MovementItemBoolean.MovementItemID = inId AND MovementItemBoolean.DescId = zc_MIBoolean_isTestingUser();
      END IF;
    ELSE
      RAISE EXCEPTION '������. ����������� ��� ��������.';
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.01.20                                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_TestingUser (, inSession:= '2')
