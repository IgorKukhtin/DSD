-- Function: gpUpdate_Object_Partner_Order()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Order (Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Order (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Order(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
    IN inRouteId             Integer   ,    -- 
    IN inRouteSortingId      Integer   ,    -- 
    IN inMemberId            Integer   ,    -- 
    IN inPrepareDayCount     TFloat    ,    -- �� ������� ���� ����������� �����
    IN inDocumentDayCount    TFloat    ,    -- ����� ������� ���� ����������� �������������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Order());

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Route(), ioId, inRouteId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_MemberTake(), ioId, inMemberId);
 
   -- ��������� �������� <�� ������� ���� ����������� �����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_PrepareDayCount(), ioId, inPrepareDayCount);
   -- ��������� �������� <����� ������� ���� ����������� �������������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_DocumentDayCount(), ioId, inDocumentDayCount);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.03.15                                        *
 19.10.14                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_Order()
