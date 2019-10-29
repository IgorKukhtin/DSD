-- Function: gpInsertUpdate_Object_Route(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Route (Integer, Integer, TVarChar, TDateTime, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Route (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Route(
 INOUT ioId             Integer   , -- ���� ������� <�������>
    IN inCode           Integer   , -- �������� <��� ��������>
    IN inName           TVarChar  , -- �������� <������������ ��������>
    IN inStartRunPlan   TDateTime , -- ����� ������ ����
    IN inHoursPlan      TFloat    , -- ����� � ���� - ����
    IN inMinutePlan     TFloat    , -- ����� � ���� - ������
    IN inRateSumma      TFloat    , -- ����� ����������������
    IN inRatePrice      TFloat    , -- ������ ���/�� (������������)
    IN inTimePrice      TFloat    , -- ������ ���/� (����������������)
    IN inRateSummaAdd   TFloat    , -- ����� ������� (������������)
    IN inRateSummaExp   TFloat    , -- ����� ��������������� �����������
    IN inUnitId         Integer   , -- ������ �� �������������
    IN inBranchId       Integer   , -- ������ �� ������
    IN inRouteKindId    Integer   , -- ������ �� ���� ���������
    IN inFreightId      Integer   , -- ������ �� �������� �����
    IN inRouteGroupId   Integer   , -- ������ �� ������ ��������
    IN inIsNotPayForWeight Boolean   , -- ��� ������ �������� �� ���
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Route());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Route());

   -- �������� ������������ ��� �������� <������������ ��������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Route(), inName);
   -- �������� ������������ ��� �������� <��� ��������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Route(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId:= ioId, inDescId:= zc_Object_Route(), inObjectCode:= vbCode_calc, inValueData:= inName
                                , inAccessKeyId:= (SELECT Object_Branch.AccessKeyId FROM Object AS Object_Branch WHERE Object_Branch.Id = inBranchId));

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_Unit(), ioId, inUnitId);

   -- ��������� ����� � <��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_Branch(), ioId, inBranchId);

   -- ��������� ����� � <���� ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_RouteKind(), ioId, inRouteKindId);
   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_Freight(), ioId, inFreightId);
  
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_RouteGroup(), ioId, inRouteGroupId);   

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_RateSumma(), ioId, inRateSumma);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_RatePrice(), ioId, inRatePrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_TimePrice(), ioId, inTimePrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_RateSummaAdd(), ioId, inRateSummaAdd);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_RateSummaExp(), ioId, inRateSummaExp);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Route_StartRunPlan(), ioId, inStartRunPlan);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Route_EndRunPlan(), ioId, (inStartRunPlan + (inHoursPlan||' hour '||inMinutePlan||' minute') :: INTERVAL) );

   -- ��������� �������� <��� ������ �������� �� ���>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Route_NotPayForWeight(), ioId, inIsNotPayForWeight);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.10.19         *
 06.04.19         *
 29.01.19         * add RateSummaExp
 24.10.17         * add RateSummaAdd
 24.05.16         * add TimePrice
 17.04.16         *
 20.04.15         * RouteGroup                
 13.12.13         * add inBranchId              
 08.12.13                                        * add inAccessKeyId
 09.10.13                                        * �������� ����� ���
 24.09.13         * add Unit, RouteKind, Freight
 03.06.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Route()
