-- Function: gpUpdate_Object_Goods_CountReceipt()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_CountReceipt (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_CountReceipt(
    IN inId                  Integer   , -- ���� ������� <�����>
    IN inCountReceipt        TFloat    , -- ����� ������ 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountReceipt(), inId, inCountReceipt);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.04.20         *
*/


-- ����
--