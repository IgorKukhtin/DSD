-- Function: gpUpdate_Object_GoodsGroupProperty_ColorReport()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsGroupProperty_ColorReport(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsGroupProperty_ColorReport(
    IN inId                  Integer   ,     -- ���� ������� <> 
    IN inColorReport         TFloat    ,     -- ���� ������ � "����� �� ��������"
    IN inSession             TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroupProperty());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��������� �������� <���� ������ � "����� �� ��������">
   IF COALESCE (inColorReport,0) <> 0
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsGroupProperty_ColorReport(), inId, inColorReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsGroupProperty_ColorReport(), inId, Null);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.01.24         * 
*/

-- ����
--