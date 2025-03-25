-- Function: gpInsertUpdate_Object_Unit

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                      Integer   , -- ���� ������� <�������������>
    IN inCode                    Integer   , -- ��� ������� <�������������>
    IN inName                    TVarChar  , -- �������� ������� <�������������>
    IN inisPartionDate           Boolean   , -- ������ ���� � �����
    IN inisPartionGoodsKind      Boolean   , -- ������ �� ���� ��������
    IN inisCountCount            Boolean   , -- ���� �������
    IN inisPartionGP             Boolean   , -- ������ ��� �� � �������
    IN inisAvance                Boolean   , -- ���������� ����� �������.
    IN inParentId                Integer   , -- ������ �� �������������
    IN inBranchId                Integer   , -- ������ �� ������
    IN inBusinessId              Integer   , -- ������ �� ������
    IN inJuridicalId             Integer   , -- ������ �� ����������� ����
    IN inContractId              Integer   , -- ������ �� �������
    IN inAccountDirectionId      Integer   , -- ������ �� ��������� �������������� ������
    IN inProfitLossDirectionId   Integer   , -- ������ �� ��������� ������ ������ ���
    IN inRouteId                 Integer   , -- �������
    IN inRouteSortingId          Integer   , -- ���������� ���������
    IN inAreaId                  Integer   , -- ������
    IN inCityId                  Integer   , -- �����
    IN inPersonalHeadId          Integer   , -- ������������ �������������
    IN inFounderId               Integer   , --
    IN inDepartmentId            Integer   , -- �����������
    IN inDepartment_twoId        Integer   , -- ����������� 2-�� ������
    IN inSheetWorkTimeId         Integer   , -- ����� ������ (������ ������ �.��.)
    IN inAddress                 TVarChar  , -- �����
    IN inAddressEDIN             TVarChar  , -- ����� ��� EDIN
    IN inComment                 TVarChar  , -- ����������
    IN inGLN                     TVarChar  ,
    IN inKATOTTG                 TVarChar  ,
    IN inSession                 TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
   DECLARE vbOldValue_Address TVarChar;
   DECLARE vbAddress TVarChar;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Unit());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!

/*
   -- ��������
   IF inPersonalSheetWorkTimeId > 0
   THEN --
        RAISE EXCEPTION '������.��� ���� ��������� <��������� (������ � ������ �.�������)>.';
   END IF;
*/

   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Unit(), vbCode_calc);

   -- �������� ���� � ������
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_Unit_Parent(), inParentId);

   -- ��������� ������� �������� ������
   vbOldValue_Address := (SELECT COALESCE(ObjectString_Unit_Address.ValueData,'') AS Address
                          FROM ObjectString AS ObjectString_Unit_Address
                          WHERE ObjectString_Unit_Address.ObjectId = ioId --8426  -- inUnitId
                            AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address());

   -- ���������
   vbOldId:= ioId;
   -- ���������
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent() AND ObjectId = ioId);

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- ��������� �������� <������ ���� � �����>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PartionDate(), ioId, inisPartionDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PartionGoodsKind(), ioId, inisPartionGoodsKind);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_CountCount(), ioId, inisCountCount);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PartionGP(), ioId, inisPartionGP);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_Avance(), ioId, inisAvance);

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Parent(), ioId, inParentId);
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Branch(), ioId, inBranchId);
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Business(), ioId, inBusinessId);
   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);

   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Contract(), ioId, inContractId);

   -- ��������� ����� � <��������� �������������� ������ - �����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_AccountDirection(), ioId, inAccountDirectionId);
   -- ��������� ����� � <��������� ������ ������ � �������� � ������� - �����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_ProfitLossDirection(), ioId, inProfitLossDirectionId);

   -- ��������� ����� � <��������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Unit_Route(), ioId, inRouteId);
   -- ��������� ����� � <���������� ���������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Unit_RouteSorting(), ioId, inRouteSortingId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Area(), ioId, inAreaId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_City(), ioId, inCityId);
   -- ��������� ����� � <��������� (������ � ������ �.�������)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_PersonalHead(), ioId, inPersonalHeadId);
   -- ��������� ����� � <����� ������ (������ ������ �.��.)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_SheetWorkTime(), ioId, inSheetWorkTimeId);

   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Founder(), ioId, inFounderId);
   -- ��������� ����� � <�����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Department(), ioId, inDepartmentId);
   -- ��������� ����� � <����������� 2 ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Department_two(), ioId, inDepartment_twoId);
   
   -- ��������� <����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Comment(), ioId, inComment);
   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_GLN(), ioId, inGLN);
   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_KATOTTG(), ioId, inKATOTTG);
   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_AddressEDIN(), ioId, inAddressEDIN);

   -- ���� ��������� �������������
   IF vbOldId <> ioId THEN
      -- ���������� �������� ����\����� � ����
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;

   -- ����� ������ inParentId ���� ������
   IF COALESCE (inParentId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), inParentId, FALSE);
   END IF;

   IF COALESCE (vbOldParentId, 0) <> 0 THEN
      PERFORM lpUpdate_isLeaf (vbOldParentId, zc_ObjectLink_Unit_Parent());
   END IF;

   vbAddress := COALESCE (inAddress, '') ;

   IF vbAddress = '' THEN
     vbAddress := (SELECT COALESCE(ObjectString_Unit_Address.ValueData,'') as Address
                   FROM lfSelect_Object_UnitParent_byUnit (ioId) AS tmpUnitList
                        INNER JOIN ObjectString AS ObjectString_Unit_Address
                                ON ObjectString_Unit_Address.ObjectId = tmpUnitList.UnitId
                               AND ObjectString_Unit_Address.DescId   = zc_ObjectString_Unit_Address()
                               AND COALESCE(ObjectString_Unit_Address.ValueData,'') <>''
                   ORDER BY tmpUnitList.Level
                   LIMIT 1);
   END IF;


   -- ��������� �������� <�����>
   -- ���������� � ������������� � ���� Child ����� �����, � ������� ��� ����� �� ��� ������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Address(), tmpUnitList.UnitId, vbAddress)
   FROM lfSelect_Object_Unit_byGroup (ioId) AS tmpUnitList
         LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                ON ObjectString_Unit_Address.ObjectId = tmpUnitList.UnitId
                               AND ObjectString_Unit_Address.DescId   = zc_ObjectString_Unit_Address()
   WHERE (COALESCE(ObjectString_Unit_Address.ValueData,'') = vbOldValue_Address OR COALESCE(ObjectString_Unit_Address.ValueData,'') = '');


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.03.25         * inDepartment_twoId
 28.10.24         * inDepartmentId
 11.07.23         * inAddressEDIN
 28.06.23         *
 11.05.23         *
 14.03.23         * inisAvance
 03.10.22         * inisPartionGP
 27.07.22         * inisCountCount
 15.12.21         * add PersonalHead
                    dell PersonalSheetWorkTime
 04.10.21         * add inComment
 06.03.17         * add PartionGoodsKind
 16.11.16         * add inSheetWorkTimeId
 24.11.15         * add PersonalSheetWorkTime
 19.07.15         * add area
 03.07.15         * add ObjectLink_Unit_Route, ObjectLink_Unit_RouteSorting
 15.04.15         * add Contract
 08.12.13                                        * add inAccessKeyId
 20.07.13                                        * add inPartionDate
 16.06.13                                        * COALESCE (MAX (ObjectCode), 0)
 14.06.13          *
 13.05.13                                        * rem lpCheckUnique_Object_ValueData
 04.03.13          * vbCode_calc
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Unit ()
