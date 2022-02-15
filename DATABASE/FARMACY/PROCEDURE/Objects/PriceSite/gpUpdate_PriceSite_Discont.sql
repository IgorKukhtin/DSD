-- Function: gpUpdate_PriceSite_Discont()

DROP FUNCTION IF EXISTS gpUpdate_PriceSite_Discont(Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_PriceSite_Discont(
    IN inId              Integer   ,    -- ���� ������� <�����>
    IN inDiscontStart    TDateTime ,    -- ���� ������ ������ �� �����
    IN inDiscontEnd      TDateTime ,    -- ���� ��������� ������ �� �����
    IN inDiscontPercent  TFloat    ,    -- ����� ������ �� �����
    IN inDiscontAmount   TFloat    ,    -- ������� ������ �� �����
    IN inSession         TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PriceSite_DiscontStart(), inId, inDiscontStart);
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PriceSite_DiscontEnd(), inId, inDiscontEnd);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PriceSite_DiscontPercent(), inId, inDiscontPercent);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PriceSite_DiscontAmount(), inId, inDiscontAmount);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.02.22                                                       *  

*/

-- ����
-- SELECT * FROM  gpUpdate_PriceSite_Discont(inId := 17224086 , inDiscontStart := ('15.02.2022')::TDateTime , inDiscontEnd := ('28.02.2022')::TDateTime , inDiscontPercent := 20 , inDiscontAmount := 0 ,  inSession := '3');
