-- Function: gpUpdate_Object_Partner_Params()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Params (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

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
    IN inBasisCode           Integer   ,    -- ��� ����
    IN inPrepareDayCount     TFloat    ,    -- 
    IN inDocumentDayCount    TFloat    ,    -- 
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbRouteId Integer;
   DECLARE vbRouteId_30201 Integer;
   DECLARE vbRouteSortingId Integer;
   DECLARE vbMemberId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbPersonalTradeId Integer;
   DECLARE vbPersonalMerchId Integer;
   DECLARE vbUnitId Integer;  
   DECLARE vbPrepareDayCount TFloat;
   DECLARE vbDocumentDayCount TFloat;
   DECLARE vbBasisCode Integer;
BEGIN

   --������ �����
   vbRouteId         := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_Route()) ::Integer;
   vbRouteId_30201   := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_Route30201()) ::Integer;
   vbRouteSortingId  := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_RouteSorting()) ::Integer;
   vbMemberId        := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_MemberTake()) ::Integer;
   vbPersonalId      := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_Personal()) ::Integer;
   vbPersonalTradeId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_PersonalTrade()) ::Integer;
   vbPersonalMerchId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_PersonalMerch()) ::Integer;
   vbUnitId          := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Partner_Unit()) ::Integer; 
   vbPrepareDayCount := (SELECT ObjectFloat.ValueData    FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()) ::TFloat;
   vbDocumentDayCount:= (SELECT ObjectFloat.ValueData    FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()) ::TFloat;
   --
   vbBasisCode       := (SELECT ObjectFloat.ValueData    FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_ObjectCode_Basis()) ::Integer;

   IF COALESCE (vbRouteId,0) <> COALESCE (inRouteId,0)
   OR COALESCE (vbRouteId_30201,0) <> COALESCE (inRouteId_30201,0)
   OR COALESCE (vbRouteSortingId,0) <> COALESCE (inRouteSortingId,0)
   OR COALESCE (vbMemberId,0) <> COALESCE (inMemberId,0)
   OR COALESCE (vbPersonalId,0) <> COALESCE (inPersonalId,0)
   OR COALESCE (vbPersonalTradeId,0) <> COALESCE (inPersonalTradeId,0)
   OR COALESCE (vbPersonalMerchId,0) <> COALESCE (inPersonalMerchId,0)
   OR COALESCE (vbPrepareDayCount,0) <> COALESCE (inPrepareDayCount,0)
   OR COALESCE (vbDocumentDayCount,0)<> COALESCE (inDocumentDayCount,0)
   OR COALESCE (vbUnitId,0)          <> COALESCE (inUnitId,0)
   THEN
   
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


   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Unit(), ioId, inUnitId);


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

   END IF;
   END IF; 
   END IF;
   
      --
   IF vbBasisCode <> inBasisCode
   THEN
        -- �������� ���� ������������ �� ����� ���������
        vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectCode_Basis());
   
        -- ��������� ��������
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ObjectCode_Basis(), ioId, inBasisCode);   
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
