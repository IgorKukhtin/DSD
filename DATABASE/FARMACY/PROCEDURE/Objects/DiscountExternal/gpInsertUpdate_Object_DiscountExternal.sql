-- Function: gpInsertUpdate_Object_DiscountExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternal (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountExternal(
 INOUT ioId                            Integer   , -- ���� �������
    IN inCode                          Integer   , -- ��� ������� 
    IN inName                          TVarChar  , -- ��������
    IN inURL                           TVarChar  , --
    IN inService                       TVarChar  , -- 
    IN inPort                          TVarChar  , -- 
    IN inisGoodsForProject             Boolean   , -- ����� ������ ��� ������� (���������� �����)
    IN inisOneSupplier                 Boolean   , -- � ��� ����� ������ ����������
    IN inisTwoPackages                 Boolean   , -- 2 �������� �� ����� �� ������� �� ������ �������
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountExternal());
   vbUserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_DiscountExternal());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountExternal(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_DiscountExternal_URL(), ioId, inURL);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_DiscountExternal_Service(), ioId, inService);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_DiscountExternal_Port(), ioId, inPort);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_DiscountExternal_GoodsForProject(), ioId, inisGoodsForProject);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_DiscountExternal_OneSupplier(), ioId, inisOneSupplier);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_DiscountExternal_TwoPackages(), ioId, inisTwoPackages);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DiscountExternal (ioId:=0, inCode:=0, inValue:='����', inDiscountExternalKindId:=0, inSession:='2')
-- Function: gpGet_Object_DiscountExternal_Unit()