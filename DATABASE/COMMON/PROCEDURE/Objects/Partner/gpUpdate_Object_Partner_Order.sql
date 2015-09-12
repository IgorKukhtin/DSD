-- Function: gpUpdate_Object_Partner_Order()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Order (Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Order (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Order (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Order (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Order(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
    IN inContractId          Integer   ,    -- 
    IN inRouteId             Integer   ,    -- 
    IN inRouteSortingId      Integer   ,    -- 
    IN inMemberId            Integer   ,    -- 
    IN inMemberId1           Integer   ,    --
    IN inMemberId2           Integer   ,    --
    IN inMemberId3           Integer   ,    --
    IN inMemberId4           Integer   ,    --
    IN inMemberId5           Integer   ,    --
    IN inMemberId6           Integer   ,    --
    IN inMemberId7           Integer   ,    --
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

   IF EXISTS (SELECT InfoMoneyId FROM Object_Contract_View WHERE ContractId = inContractId AND InfoMoneyId = zc_Enum_InfoMoney_30201()) -- ������ + ������ ����� + ������ �����
   THEN
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route30201(), ioId, inRouteId_30201);
   ELSE
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Route(), ioId, inRouteId);
   END IF;

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_MemberTake(), ioId, inMemberId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_MemberTake1(), ioId, inMemberId1);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_MemberTake2(), ioId, inMemberId2);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_MemberTake3(), ioId, inMemberId3);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_MemberTake4(), ioId, inMemberId4);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_MemberTake5(), ioId, inMemberId5);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_MemberTake6(), ioId, inMemberId6);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_MemberTake7(), ioId, inMemberId7);
 
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
 12.09.15         * add inMemberId1...7
 26.06.15                                        * add inRouteId_30201
 11.03.15                                        *
 19.10.14                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_Order()
