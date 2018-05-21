-- Function: gpGet_ReportGoods_Params()

DROP FUNCTION IF EXISTS gpGet_ReportGoods_Params (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_ReportGoods_Params (
 INOUT ioGoodsCode           Integer  , -- 
   OUT outGoodsId            Integer  , -- 
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN

     -- ���������� ����� �� ����
     outGoodsId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = ioGoodsCode AND Object.DescId = zc_Object_Goods());
     --��������
     IF COALESCE (outGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.����� � ����� <%> �� ������.', ioGoodsCode; 
     END IF;        
      
 --    outPartionId :=(SELECT DISTINCT
 --       FROM Object_PartionGoods 
 --      WHERE Object_PartionGoods.GoodsId = outGoodsId

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.05.18         *
*/

-- ����
-- SELECT * FROM gpGet_ReportGoods_Params (ioGoodsCode:= 102330, inSession:= '5'); -- test