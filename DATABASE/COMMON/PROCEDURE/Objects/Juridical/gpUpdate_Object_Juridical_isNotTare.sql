-- Function: gpUpdate_Object_Juridical_isNotTare()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_isNotTare (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_isNotTare(
    IN inId                  Integer   ,  -- ���� ������� <> 
    IN inisNotTare           Boolean   , 
   OUT outisNotTare          Boolean   , 
    IN inSession             TVarChar     -- ������ ������������
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_NotTare());

   outisNotTare:= NOT inisNotTare;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isNotTare(), inId, outisNotTare);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.01.22         *
*/

-- ����
--