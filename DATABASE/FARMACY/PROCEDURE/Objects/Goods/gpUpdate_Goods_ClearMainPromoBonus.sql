 -- Function: gpUpdate_Goods_ClearMainPromoBonus()

DROP FUNCTION IF EXISTS gpUpdate_Goods_ClearMainPromoBonus (TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_ClearMainPromoBonus(
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    
    /*UPDATE Object_Goods_Main SET PromoBonus = Null, PriceSip = Null
    WHERE Object_Goods_Main.PromoBonus IS NOT NULL
       OR Object_Goods_Main.PriceSip IS NOT NULL;*/

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.10.23                                                       *
*/

-- ����
-- select * from gpUpdate_Goods_ClearMainPromoBonus(inSession := '3');