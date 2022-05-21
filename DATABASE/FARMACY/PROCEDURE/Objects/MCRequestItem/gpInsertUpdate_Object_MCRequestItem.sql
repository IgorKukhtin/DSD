-- Function: gpInsertUpdate_Object_MCRequestItem(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MCRequestItem (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MCRequestItem(
 INOUT ioId               Integer,       -- ���� ������� <��������� ��������� �������>
    IN inMCRequestId      Integer, 
    IN inMinPrice         TFloat, 
    IN inMarginPercent    TFloat, 
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS INTEGER AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean; 
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   vbUserId := inSession;

   IF COALESCE(inMCRequestId, 0) = 0 THEN
      RAISE EXCEPTION '���������� ���������� "������ �� ��������� ��������� �������"';
   END IF;

   -- ���������� <������� ����� ��� �������������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   IF COALESCE(ioId, 0) = 0 
   THEN
      -- ��������� <������>
      ioId := lpInsertUpdate_Object (0, zc_Object_MCRequestItem(), 0, '');
   END IF;

   -- ��������� ����� � <���������� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MCRequestItem_MCRequest(), ioId, inMCRequestId);

   -- ��������� �������� <����������� ����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MCRequestItem_MinPrice(), ioId, inMinPrice);
   -- ��������� �������� <% �������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MCRequestItem_MarginPercent(), ioId, inMarginPercent);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MCRequestItem (Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.17         *
 09.04.15                          *
*/

-- ����
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MCRequestItem(0, 2,'��','2'); ROLLBACK