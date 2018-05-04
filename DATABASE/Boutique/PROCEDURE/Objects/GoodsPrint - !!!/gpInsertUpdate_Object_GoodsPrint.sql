-- Function: gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPrint(
 INOUT ioOrd               Integer,      -- � �/� ������ GoodsPrint
 INOUT ioUserId            Integer,      -- ������������ ������ GoodsPrint
    IN inUnitId            Integer,      --
    IN inPartionId         Integer,      --
    IN inGoodsId           Integer,      --
    IN inGoodsSizeId       Integer,      --
    IN inAmount            TFloat,       --
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserName         TVarChar,     -- 
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPrint());


   -- ���������
   SELECT tmp.ioOrd, tmp.outUserName, tmp.outGoodsPrintName
          INTO ioOrd, outUserName, outGoodsPrintName
   FROM lpInsertUpdate_Object_GoodsPrint (ioOrd       := ioOrd
                                        , ioUserId    := ioUserId
                                        , inUnitId    := inUnitId
                                        , inPartionId := inPartionId
                                        , inAmount    := inAmount
                                        , inIsReprice := FALSE      -- ����� ����������
                                        , inUserId    := vbUserId
                                         ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 02.05.18         *
 06.03.18                                        *
 17.08.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsPrint (ioOrd:= 0, ioUserId:= 0, inUnitId:= 4198, inPartionId:= 0, inGoodsId:= 0, inGoodsSizeId :=0, inAmount:= 5, inSession := zfCalc_UserAdmin());
