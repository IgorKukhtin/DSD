-- Function: gpInsert_AccommodationLincGoodsLog()

DROP FUNCTION IF EXISTS gpInsert_AccommodationLincGoodsLog (Integer, Integer, Integer, Boolean, TVarChar);



CREATE OR REPLACE FUNCTION gpInsert_AccommodationLincGoodsLog(
    IN inUnitID                Integer   ,  -- ���� ������� <������> 
    IN inGoodsId               Integer   ,  -- ���� ������� <�����> 
    IN inAccommodationId       Integer   ,  -- ���� ������� <�����> 
    IN inisErased              Boolean   ,  -- �������
    IN inSession               TVarChar     -- ������ ������������
)
  RETURNS VOID 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);
    
        -- ��������� ��������
    INSERT INTO AccommodationLincGoodsLog (OperDate, UserId, UnitId, GoodsId, AccommodationId, isErased)
    VALUES (CURRENT_TIMESTAMP, vbUserId, inUnitID, inGoodsId, inAccommodationId, inisErased);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.11.21                                                       *
*/