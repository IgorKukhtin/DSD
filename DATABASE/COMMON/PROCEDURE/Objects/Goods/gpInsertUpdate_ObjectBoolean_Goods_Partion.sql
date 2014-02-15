-- Function: gpInsertUpdate_ObjectBoolean_Goods_Partion

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectBoolean_Goods_Partion (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectBoolean_Goods_Partion(
    IN inId             Integer   , -- ���� ������� <�����>
    IN inPartionCount   Boolean   , -- ������ ���������� � ����� ���������
    IN inPartionSumm    Boolean   , -- ������ ���������� � ����� �������������
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_Goods_Partion());
   vbUserId := inSession;
   
   -- ��������� �������� <������ ���������� � ����� ���������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_PartionCount(), inId, inPartionCount);
   -- ��������� �������� <������ ���������� � ����� �������������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_PartionSumm(), inId, inPartionSumm);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_ObjectBoolean_Goods_Partion (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.13                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_ObjectBoolean_Goods_Partion (inId:=1000, inPartionCount:= TRUE, inPartionSumm:= TRUE, inSession:= '2')
