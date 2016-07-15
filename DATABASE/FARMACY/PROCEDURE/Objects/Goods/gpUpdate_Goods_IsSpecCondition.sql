-- Function: gpUpdate_Object_Goods_IsSpecCondition()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSpecCondition(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_IsSpecCondition(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inisSpecCondition     Boolean   ,    -- ����� ��� ���� ��������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsSpecCondition Boolean;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

    -- �������� ����������� �������� ��-��
    vbIsSpecCondition:= COALESCE ((SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.DescId = zc_ObjectBoolean_Goods_SpecCondition() AND ObjectBoolean.ObjectId = inId), FALSE);


    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SpecCondition(), inId, inisSpecCondition);


   IF COALESCE (inIsSpecCondition, FALSE) <> vbIsSpecCondition
   THEN
       -- ��������� �������� <���� ����.>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);
       -- ��������� �������� <������������ (����.)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inId, inUserId);
   END If;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Goods_isSpecCondition(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 18.02.16         *

*/