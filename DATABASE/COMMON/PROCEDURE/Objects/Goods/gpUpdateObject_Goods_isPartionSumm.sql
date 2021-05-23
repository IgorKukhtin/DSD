-- Function: gpUpdateObject_Goods_isPartionSumm()

DROP FUNCTION IF EXISTS gpUpdateObject_Goods_isPartionSumm (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Goods_isPartionSumm(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inisPartionSumm       Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_Goods_Partion());
     vbUserId:= lpGetUserBySession (inSession);


     -- �������� �������
     inisPartionSumm:= NOT inisPartionSumm;

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_PartionSumm(), inId, inisPartionSumm);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.07.16         *
*/


-- ����
-- SELECT * FROM gpUpdateObject_Goods_isPartionSumm (ioId:= 275079, inisVAT:= 'False', inSession:= '2')
