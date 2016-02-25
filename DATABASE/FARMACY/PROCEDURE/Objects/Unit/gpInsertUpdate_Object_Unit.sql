-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TFloat, Boolean, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������������>
    IN inCode                    Integer   ,    -- ��� ������� <�������������>
    IN inName                    TVarChar  ,    -- �������� ������� <�������������>
    IN inTaxService              TFloat    ,    -- % �� �������
    IN inisRepriceAuto           Boolean   ,    -- ��������� � ��������������
    IN inParentId                Integer   ,    -- ������ �� �������������
    IN inJuridicalId             Integer   ,    -- ������ �� ����������� ����
    IN inMarginCategoryId        Integer   ,    -- ������ �� ��������� �������
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Unit());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Unit(), vbCode_calc);

   -- �������� ���� � ������
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_Unit_Parent(), inParentId);

   -- ���������
   vbOldId:= ioId;
   -- ���������
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent() AND ObjectId = ioId);

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Parent(), ioId, inParentId);

   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);

   -- ��������� ����� � <��������� �������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_MarginCategory(), ioId, inMarginCategoryId);

   -- % �������������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_TaxService(), ioId, inTaxService);
   
   -- ��������� � ��������������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_RepriceAuto(), ioId, inisRepriceAuto);

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

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.02.16         * 
 14.02.16         * 
 27.06.14         * 
 25.06.13                          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Unit ()                            
