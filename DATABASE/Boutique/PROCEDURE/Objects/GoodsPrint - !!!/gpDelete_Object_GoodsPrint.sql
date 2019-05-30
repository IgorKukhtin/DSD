-- Function: gpDelete_Object_GoodsPrint (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_GoodsPrint (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpDelete_Object_GoodsPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_GoodsPrint(
 INOUT ioOrd               Integer,      -- � �/� ������ GoodsPrint
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserId           Integer,      -- ������������ ������ GoodsPrint
   OUT outUserName         TVarChar,     --
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   outUserId:= lpGetUserBySession (inSession);


   -- !!!������� ������� ������ ���� ������������� ������ ��� �� 7 ����!!!
   DELETE FROM Object_GoodsPrint WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';


   -- ��� ������ ������
   IF COALESCE (ioOrd, 0) = 0
   THEN
       -- ������� ��� �������� ��� ���� ������ ������������
       DELETE FROM Object_GoodsPrint WHERE Object_GoodsPrint.UserId = outUserId AND Object_GoodsPrint.isReprice = FALSE;
   ELSE
       -- ������� ��� �������� ��� 1-�� ������ ������������
       DELETE FROM Object_GoodsPrint
       WHERE Object_GoodsPrint.UserId     = outUserId
         AND Object_GoodsPrint.isReprice  = FALSE
         AND Object_GoodsPrint.InsertDate = (SELECT tmp.InsertDate FROM gpSelect_Object_GoodsPrint_Choice (outUserId, inSession) AS tmp
                                             WHERE tmp.Ord = ioOrd -- !!!������� ������ ������!!!
                                            )
       ;


   END IF;

   -- ���������
   ioOrd            := 0 ;
   outGoodsPrintName:= '';
   outUserName      := lfGet_Object_ValueData_sh (outUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
17.08.17          *
*/

-- ����
-- SELECT * FROM gpDelete_Object_GoodsPrint (ioOrd:= 0, ioUserId:= 0, inSession:= zfCalc_UserAdmin());
