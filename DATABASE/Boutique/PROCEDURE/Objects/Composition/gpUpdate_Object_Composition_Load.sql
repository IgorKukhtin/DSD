-- �8������ ��� �������

DROP FUNCTION IF EXISTS gpUpdate_Object_Composition_Load (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Composition_Load(
    IN inName         TVarChar,      -- �������� ������� <�������� ��� �������>
    IN inName_UKR     TVarChar,      -- �������� ������� <�������� ��� �������> ���
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Composition());
   vbUserId:= lpGetUserBySession (inSession);


   -- ����� � Object.ValueData
   vbId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Composition() AND Object.isErased = FALSE AND TRIM (Object.ValueData) = TRIM (inName));


   -- ���� ����� ���������� ��������
   IF COALESCE (vbId,0) <> 0 AND TRIM (inName_UKR) <> ''
   THEN
       -- ��������� ��������
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Composition_UKR(), vbId, inName_UKR);

       -- ��������� ��������
       PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
25.06.20          *
*/

-- ����
--