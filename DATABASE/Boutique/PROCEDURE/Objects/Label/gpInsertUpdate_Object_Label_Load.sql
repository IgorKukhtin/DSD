-- �������� ��� �������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label_Load (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Label_Load(
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
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());
   vbUserId:= lpGetUserBySession (inSession);


   -- ����� � Object.ValueData
   vbId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND Object.isErased = FALSE AND TRIM (Object.ValueData) = TRIM (inName));


   -- ���� ����� ���������� ��������
   IF COALESCE (vbId,0) <> 0 AND TRIM (inName_UKR) <> ''
   THEN
       -- ��������� ��������
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Label_UKR(), vbId, inName_UKR);

       -- ��������� ��������
       PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
09.06.20          *
*/

-- ����
--