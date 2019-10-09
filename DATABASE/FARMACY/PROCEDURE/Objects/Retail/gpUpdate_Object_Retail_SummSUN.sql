-- Function: gpUpdate_Object_Retail_SummSUN()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_SummSUN (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_SummSUN(
    IN inId                    Integer   ,     -- ���� ������� <�������� ����> 
    IN inSummSUN               TFloat    ,     --
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_SummSUN());

   -- ��������� ��-�� <�����, ��� ������� ���������� ���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Retail_SummSUN(), inId, inSummSUN);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.19         *
*/

-- ����
--