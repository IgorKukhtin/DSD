-- Function: lpInsertUpdate_Object_PhotoMobile (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PhotoMobile (Integer, Integer, TVarChar, TBlob, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PhotoMobile(
 INOUT ioId	             Integer   ,    -- ���� ������� <> 
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� �������
    IN inPhotoData           TBlob     ,
    IN inUserId              Integer        -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer;
BEGIN
   
     -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PhotoMobile(), inCode, TRIM (inName));

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBlob( zc_ObjectBlob_PhotoMobile_Data(), ioId, inPhotoData);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.04.17         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_PhotoMobile()
