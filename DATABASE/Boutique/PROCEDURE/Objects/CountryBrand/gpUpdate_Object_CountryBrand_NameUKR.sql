--

DROP FUNCTION IF EXISTS gpUpdate_Object_CountryBrand_NameUKR (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CountryBrand_NameUKR(
    IN inId           Integer,       -- ���� ������� <��������>    
    IN inName_UKR     TVarChar,      -- �������� ������� <��������> ���
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CountryBrand());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CountryBrand_UKR(), inId, inName_UKR);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.08.20          *
*/

-- ����
--