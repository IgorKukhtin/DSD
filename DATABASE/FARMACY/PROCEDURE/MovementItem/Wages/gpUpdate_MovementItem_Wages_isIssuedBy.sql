-- Function: gpUpdate_MovementItem_Wages_isIssuedBy()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Wages_isIssuedBy(INTEGER, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Wages_isIssuedBy(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inisIssuedBy          Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (inId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �������� �� ��������.';
    END IF;

     -- ��������� �������� <�� �����>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), inId, NOT inisIssuedBy);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.08.19                                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_Wages_isIssuedBy (, inSession:= '2')

