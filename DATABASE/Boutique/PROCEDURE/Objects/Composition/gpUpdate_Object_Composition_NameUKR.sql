--

DROP FUNCTION IF EXISTS gpUpdate_Object_Composition_NameUKR (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Composition_NameUKR(
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
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Composition());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Composition_UKR(), inId, inName_UKR);

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