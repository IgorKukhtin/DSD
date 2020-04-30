 -- Function: gpUpdate_MovementItem_Check_NDSKindId()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Check_NDSKindId (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Check_NDSKindId(
    IN inId                  Integer   , -- ���� ������� <������ ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inNDSKindId           Integer   , --  ��� ���
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF inSession::Integer NOT IN (3, 375661, 4183126, 8001630, 9560329, 8051421, 14080152 )
    THEN
      RAISE EXCEPTION '��������� <��� ���> ��� ���������.';
    END IF;

    SELECT 
      StatusId
    INTO
      vbStatusId
    FROM Movement 
    WHERE Id = inMovementId;
            
    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.��������� ������������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ��������� ������� �� ���������
    IF COALESCE (inId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId)
    THEN
        RAISE EXCEPTION '�� ������ ������� �� ��������e';
    END IF;

    -- ������� ������� �� ��������� � ������
    IF COALESCE (inMovementId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId)
    THEN
        RAISE EXCEPTION '�� ����� �������� ��� ������������ �����';
    END IF;

    -- ��������� <������� ���������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_NDSKind(), inId, inNDSKindId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_Check_NDSKindId (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.04.20                                                       *
*/

