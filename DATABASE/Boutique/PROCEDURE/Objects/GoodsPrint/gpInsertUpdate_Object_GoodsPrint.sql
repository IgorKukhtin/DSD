-- Function: gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, TVarChar)
/*
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsItem(
 INOUT ioId           Integer,       -- ���� ������� <������ � ���������>            
    IN inGoodsId      Integer,       -- ���� ������� <������>             
    IN inGoodsSizeId  Integer,       -- ���� ������� <������ ������>
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� ���� �� ��� ����� �����
   vbId:= (SELECT Object_GoodsItem.Id 
           FROM Object_GoodsItem 
           WHERE Object_GoodsItem.GoodsId = inGoodsId 
             AND Object_GoodsItem.GoodsSizeId = inGoodsSizeId 
             AND Object_GoodsItem.Id <> COALESCE (ioId, 0)
           );
   IF COALESCE (vbId, 0) <> 0 THEN ioId := vbId; END IF; 
   
   IF COALESCE (ioId, 0) = 0 THEN
      -- �������� ����� ������� ����������� � ������� �������� <���� �������>
      INSERT INTO Object_GoodsItem (GoodsId, GoodsSizeId)
                  VALUES (inGoodsId, inGoodsSizeId) RETURNING Id INTO ioId;
   ELSE
       -- �������� ������� ����������� �� �������� <���� �������>
       UPDATE Object_GoodsItem SET GoodsId = inGoodsId, GoodsSizeId = inGoodsSizeId WHERE Id = ioId ;

       -- ���� ����� ������� �� ��� ������
       IF NOT FOUND THEN
          -- �������� ����� ������� ����������� �� ��������� <���� �������>
          INSERT INTO Object_GoodsItem (Id, GoodsId, GoodsSizeId)
                     VALUES (ioId, inGoodsId, inGoodsSizeId);
       END IF; -- if NOT FOUND

   END IF; -- if COALESCE (ioId, 0) = 0  


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
11.04.17          *
10.03.17                                                          *
*/

-- ����
-- 
*/