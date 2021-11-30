-- Function: gpUpdate_AccommodationLincGoods_IsErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_AccommodationLincGoods_IsErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_AccommodationLincGoods_IsErased(
    IN inUnitId                Integer   ,  -- ���� ������� <�������������> 
    IN inGoodsId               Integer   ,  -- ���� ������� <�����> 
    IN inSession               TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- ��� �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inUnitId, 0) = 0 OR  COALESCE (inGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION '�� �������� ���������� ��� �������������';
    END IF;
    
      -- ������� ����� � <������������> ���� ����
    IF EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = inUnitId
                                                      AND GoodsId = inGoodsId)
    THEN
      UPDATE AccommodationLincGoods SET UserUpdateId = vbUserId, DateUpdate = CURRENT_TIMESTAMP, isErased = NOT isErased
      WHERE UnitId = inUnitId
        AND GoodsId = inGoodsId;

      -- ��������� ��������
      PERFORM gpInsert_AccommodationLincGoodsLog(inUnitID           := AccommodationLincGoods.UnitId
                                               , inGoodsId          := AccommodationLincGoods.GoodsId
                                               , inAccommodationId  := AccommodationLincGoods.AccommodationID
                                               , inisErased         := AccommodationLincGoods.isErased
                                               , inSession          := inSession)
      FROM AccommodationLincGoods
      WHERE AccommodationLincGoods.UnitId = inUnitId
        AND AccommodationLincGoods.GoodsId = inGoodsId;    
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_AccommodationLincGoods_IsErased (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 19.04.21                                                      * 
*/