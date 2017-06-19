-- Function: gpUpdate_Object_Partner_Params()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Params(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
    IN inRouteId             Integer   ,    -- 
    IN inRouteId_30201       Integer   ,    -- 
    IN inRouteSortingId      Integer   ,    -- 
    IN inMemberId            Integer   ,    -- 
    IN inPersonalId          Integer   ,    -- ��������� (�����������)
    IN inPersonalTradeId     Integer   ,    -- ��������� (��������)
    IN inPersonalMerchId     Integer   ,    -- ��������� (������������)
    IN inUnitId              Integer   ,    -- 
    IN inPrepareDayCount     TFloat    ,    -- 
    IN inDocumentDayCount    TFloat    ,    -- 
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Params());


   -- �������� �����������
   IF vbUserId = 715123 -- ������� �.�.
   THEN
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   ELSE


   -- ��������� ����� � <��������� (�����������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), ioId, inPersonalId);
   -- ��������� ����� � <��������� (��������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), ioId, inPersonalTradeId);
   -- ��������� ����� � <��������� (������������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalMerch(), ioId, inPersonalMerchId);


   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (106597 )) -- �������� �����
   THEN
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route30201(), ioId, inRouteId_30201);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), ioId, inMemberId);

        -- ��������� �������� <�� ������� ���� ����������� �����>
        PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_PrepareDayCount(), ioId, inPrepareDayCount);
        -- ��������� �������� <����� ������� ���� ����������� �������������>
        PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_DocumentDayCount(), ioId, inDocumentDayCount);

        -- ��������� ����� � <>
        PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Unit(), ioId, inUnitId);

   END IF;
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.06.17         * add inPersonalMerchId
 26.06.15                                        * add inRouteId_30201
 22.06.15                                        * all
 16.03.15                                        * all
 27.10.14                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_Params()
