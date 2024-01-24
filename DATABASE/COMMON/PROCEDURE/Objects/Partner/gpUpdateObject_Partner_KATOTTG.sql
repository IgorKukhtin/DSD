-- Function: gpUpdateObject_Partner_KATOTTG()

DROP FUNCTION IF EXISTS gpUpdateObject_Partner_KATOTTG (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_KATOTTG(
    IN inId                  Integer   ,    -- ���� ������� <����������� ����>
    IN inKATOTTG             TVarChar  ,    -- �������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_UnitMobile());
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);
   
   
   IF COALESCE(inId, 0) = 0
   THEN
     RAISE EXCEPTION '������.��� ������� ID ��������.'; 
   END IF;

   IF NOT EXISTS(SELECT 1 
                 FROM Object AS Object_Partner
                 WHERE Object_Partner.Id = inId
                   AND Object_Partner.DescId = zc_Object_Partner())
   THEN
     RAISE EXCEPTION '������.������� ID �� ��������.'; 
   END IF;

   -- ��������� �������� � <�������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_KATOTTG(), inId, inKATOTTG);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.07.23                                                       *
*/

-- ����
-- SELECT * FROM gpUpdateObject_Partner_KATOTTG()