-- Function: gpUpdateObject_Goods_isPartionCount()

DROP FUNCTION IF EXISTS gpUpdateObject_Goods_isPartionCount (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Goods_isPartionCount(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inisPartionCount      Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_Goods_Partion());
     vbUserId := inSession;

     -- �������� �������
     inisPartionCount:= NOT inisPartionCount;

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_PartionCount(), inId, inisPartionCount);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.07.16         *
*/


-- ����
-- SELECT * FROM gpUpdateObject_Goods_isPartionCount (ioId:= 275079, inisVAT:= 'False', inSession:= '2')
