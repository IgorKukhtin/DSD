-- Function: gpUpdate_Movement_Check_MemberSp()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_MemberSp (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_MemberSp(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inMemberSpId        Integer   , -- �������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);

    SELECT Movement.StatusId
    INTO vbStatusId
    FROM Movement 
    WHERE Movement.Id = inId;
         
    -- ��������   
    IF COALESCE(inId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;
    -- �������� 
    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.��������� �������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberSp(), inId, inMemberSpId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 11.01.19         *
*/
-- ����
-- select * from gpUpdate_Movement_Check_MemberSp(inId := 7784533 , inMemberSpId := 183294 ,  inSession := '3');