-- Function: gpGet_Object_GoodsPrint_Null (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsPrint_Null (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsPrint_Null(
   OUT outOrd              Integer,      -- � �/� ������ GoodsPrint
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserId           Integer,      -- ������������ ������ GoodsPrint
   OUT outUserName         TVarChar,     --
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   outUserId:= lpGetUserBySession (inSession);

   -- ���������
   outOrd           := 0 ;
   outGoodsPrintName:= '';
   outUserName      := lfGet_Object_ValueData_sh (outUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
27.04.18          *
*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsPrint_Null (inSession:= zfCalc_UserAdmin());
