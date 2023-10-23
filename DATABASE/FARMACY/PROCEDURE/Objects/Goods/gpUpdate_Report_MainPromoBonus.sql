 -- Function: gpUpdate_Goods_MainPromoBonus()

DROP FUNCTION IF EXISTS gpUpdate_Report_MainPromoBonus (Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Report_MainPromoBonus(
    IN inGoodsId           Integer  ,  -- �������������
    IN inPromoBonus        TFloat,     -- ����� �����
    
    IN inisPromo           Boolean,    -- 
    IN inPriceSip          TFloat,     -- 
    IN inSumma             TFloat,     -- 
    IN inAmount            TFloat,     -- 
   OUT outSommaBonus       TFloat,     -- ����� ������ 
   OUT outChangePercent    TFloat,     -- ����� �����
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Record
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    PERFORM gpUpdate_Goods_MainPromoBonus(inGoodsId, inPromoBonus, inSession);
    
    outChangePercent := inPromoBonus;
    
    outSommaBonus := CASE WHEN inisPromo = FALSE
                          THEN Null 
                          WHEN COALESCE(inPriceSip, 0) = 0
                          THEN inSumma * inPromoBonus / 100
                          ELSE inPriceSip * inAmount * inPromoBonus / 100 END :: TFloat;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.10.23                                                       *
*/

-- ����
-- select * from gpUpdate_Report_MainPromoBonus(inGoodsId := 1490286 , inPromoBonus := 10 , inisPromo := 'True' , inPriceSip := 0 , inSumma := 18.7036 , inAmount := 1 ,  inSession := '3');