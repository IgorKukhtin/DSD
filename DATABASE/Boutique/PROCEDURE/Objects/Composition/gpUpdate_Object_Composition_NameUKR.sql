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

/*
 SELECT * 
 , lpInsertUpdate_ObjectString (zc_ObjectString_Composition_UKR(), Object.Id, 
--  zfCalc_Text_replace(ObjectString.ValueData, '��', '���')
--  zfCalc_Text_replace(ObjectString.ValueData, '����', '����')
--  zfCalc_Text_replace(ObjectString.ValueData, '�', '�')
''

 )

FROM Object 
     join ObjectString on ObjectString.ObjectId = Object.Id
                      and ObjectString.DescId = zc_ObjectString_Composition_UKR()

where Object.descId = zc_Object_Composition()
-- and ObjectString.ValueData  like '%�%' 
and ObjectString.ValueData  = Object.ValueData
*/
-- ����
--