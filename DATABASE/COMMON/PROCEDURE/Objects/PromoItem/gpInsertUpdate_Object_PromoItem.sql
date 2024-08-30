-- Function: gpInsertUpdate_Object_PromoItem(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PromoItem (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PromoItem(
 INOUT ioId             Integer,       -- ���� ������� <>
    IN inCode           Integer,       -- �������� <��� >
    IN inName           TVarChar,      -- �������� <������������ >
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId  Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId  := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PromoItem());
      vbUserId:= lpGetUserBySession (inSession);


   inCode:= lfGet_ObjectCode (inCode, zc_Object_PromoItem());

   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_PromoItem(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PromoItem(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PromoItem(), inCode, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId );

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.24         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PromoItem(1,1,'1','1')