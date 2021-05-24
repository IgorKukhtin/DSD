-- Function: gpSelect_BarCodeBox_onlyPrint (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_BarCodeBox_onlyPrint (Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_BarCodeBox_onlyPrint (Integer,Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_BarCodeBox_onlyPrint(
    IN inId             Integer  , -- ������ �� ����
    IN inBarCode1       Integer  , -- 
    IN inAmount         Integer  , --  ���-�� ���������� ��� ������
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (BarCode TVarChar--, AmountPrint TFloat
              ) AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbBarCode2    Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_BarCodeBox());
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);
   
   vbBarCode2 := (inBarCode1 + inAmount - 1) :: Integer;
   
   RETURN QUERY
  SELECT (REPEAT ('0', 5 - LENGTH (tmp.Num :: TVarChar) ) || tmp.Num) :: TVarChar AS BarCode
  FROM (SELECT GENERATE_SERIES (inBarCode1, vbBarCode2) as Num) as tmp;
  
  -- ��������� <������>
  PERFORM lpInsertUpdate_Object (inId, zc_Object_BarCodeBox(), Object.ObjectCode, vbBarCode2 :: TVarChar)
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
--SELECT * FROM gpSelect_BarCodeBox_onlyPrint (1,10,'2'::TVarChar)