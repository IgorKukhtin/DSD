-- Function: gpInsertUpdate_Object_ReasonDifferences()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReasonDifferences(Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReasonDifferences(
 INOUT ioId                      Integer   ,   	-- ���� ������� <������� �����������>
 INOUT ioCode                    Integer   ,    -- ��� ������� <������� �����������>
    IN inName                    TVarChar  ,    -- �������� ������� <������� �����������>
    IN inisDeficit               Boolean   ,    -- ���������
    IN inisSurplus           Boolean   ,    -- ����������
    IN inSession                 TVarChar       -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;

   -- �������� - �����������/��������� ��������� �������� ������
   IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
   THEN
      RAISE EXCEPTION '������.�������� <������� �����������> ��� ���������.';
   END IF;


   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_ReasonDifferences());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReasonDifferences(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReasonDifferences(), ioCode);

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReasonDifferences(), ioCode, inName, NULL);

   -- ��������� ��-�� < ���������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReasonDifferences_Deficit(), ioId, inisDeficit);
   -- ��������� ��-�� < ����������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReasonDifferences_Surplus(), ioId, inisSurplus);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ReasonDifferences(Integer, Integer, TVarChar, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 27.06.14                                                          * 
 
*/