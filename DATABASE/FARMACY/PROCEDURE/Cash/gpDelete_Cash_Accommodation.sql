-- Function: gpDelete_Cash_Accommodation()

DROP FUNCTION IF EXISTS gpDelete_Cash_Accommodation (Integer, TVarChar);



CREATE OR REPLACE FUNCTION gpDelete_Cash_Accommodation(
    IN inGoodsId               Integer   ,  -- ���� ������� <�����> 
    IN inSession               TVarChar     -- ������ ������������
)
  RETURNS Void 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        RAISE EXCEPTION '�� ���������� �������������';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    
    IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '�� �������� ����������';
    END IF;
    
      -- ������� ����� � <������������> ���� ����
    IF EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = vbUnitId
                                                      AND GoodsId = inGoodsId)
    THEN
      UPDATE AccommodationLincGoods SET UserUpdateId = vbUserId, DateUpdate = CURRENT_TIMESTAMP, isErased = True
      WHERE UnitId = vbUnitId
        AND GoodsId = inGoodsId;

      -- ��������� ��������
      PERFORM gpInsert_AccommodationLincGoodsLog(inUnitID           := AccommodationLincGoods.UnitId
                                               , inGoodsId          := AccommodationLincGoods.GoodsId
                                               , inAccommodationId  := AccommodationLincGoods.AccommodationID
                                               , inisErased         := AccommodationLincGoods.isErased
                                               , inSession          := inSession)
      FROM AccommodationLincGoods
      WHERE AccommodationLincGoods.UnitId = vbUnitId
        AND AccommodationLincGoods.GoodsId = inGoodsId;    

    END IF;
          
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������ �.�.
 27.08.18         *
*/