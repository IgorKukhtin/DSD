-- Function: gpGet_Onject_BarCodeBox_ValueData (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Onject_BarCodeBox_ValueData (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Onject_BarCodeBox_ValueData(
    IN inId             Integer  , -- ������ �� ����
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (BarCode TFloat--, AmountPrint TFloat
              ) AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);
   
   --��������. ���� ������� �������� � ���������
   IF (SELECT POSITION ('-' IN Object.ValueData) FROM Object WHERE Object.Id = inId) > 0
   THEN
        RAISE EXCEPTION '������.��������� �������� �������� �������.';
   END IF;
   
   RETURN QUERY
  SELECT (zfConvert_StringToFloat(Object.ValueData) + 1) ::TFloat AS BarCode
  FROM Object
  WHERE Object.Id = inId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.08.20         *
*/

-- ����
--SELECT * FROM gpGet_Onject_BarCodeBox_ValueData (3654036 ,'2'::TVarChar)