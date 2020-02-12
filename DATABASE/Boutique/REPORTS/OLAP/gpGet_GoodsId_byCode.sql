-- Function: gpGet_GoodsId_byCode()

DROP FUNCTION IF EXISTS gpGet_GoodsId_byCode (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_GoodsId_byCode (
 INOUT ioGoodsCode           Integer  , -- 
   OUT outGoodsId            Integer  , -- 
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN

     -- ���������� ����� �� ����
     outGoodsId := COALESCE ( (SELECT Object.Id FROM Object WHERE Object.ObjectCode = ioGoodsCode AND Object.DescId = zc_Object_Goods()),0) ;
     --��������
     IF COALESCE (outGoodsId, 0) = 0
     THEN
         ioGoodsCode := 0;
         --RAISE EXCEPTION '������.����� � ����� <%> �� ������.', ioGoodsCode; 
     END IF;        
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.20         *
*/

-- ����
-- SELECT * FROM gpGet_GoodsId_byCode (ioGoodsCode:= 102330, inSession:= '5'); -- test