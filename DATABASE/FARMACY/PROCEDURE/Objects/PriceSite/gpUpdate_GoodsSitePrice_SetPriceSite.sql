-- Function: gpUpdate_GoodsSearchRemainsSetPrice()

DROP FUNCTION IF EXISTS gpUpdate_GoodsSitePrice_SetPriceSite (integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_GoodsSitePrice_SetPriceSite(
    IN inID             integer,     -- �����
    IN inPriceSite      TFloat,      -- ����
    IN inSession        TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRemainsDate TDateTime;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- ��� ����������
    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                  WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
    THEN
      RAISE EXCEPTION '������. ��������� ���������� ��� ���������.';
    END IF;

    IF COALESCE (inID, 0) = 0
    THEN
        RAISE EXCEPTION '������. �� ������ �����';
    END IF;

    IF COALESCE (inPriceSite, 0) <= 0
    THEN
        RAISE EXCEPTION '������. ���� ������ ���� ������ ����';
    END IF;
    
    IF NOT EXISTS(SELECT * FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId AND Object_Goods_Retail.RetailId = 4)
    THEN
        RAISE EXCEPTION '������. ������������� ����� ������ ����� ���� "�� �����"';
    END IF;

    IF EXISTS(SELECT tmp.GoodsId
              FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
              WHERE tmp.GoodsId = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId AND Object_Goods_Retail.RetailId = 4))
    THEN
        RAISE EXCEPTION '������. ������������� ����� ��� ������� ������.';
    END IF;

    PERFORM lpInsertUpdate_Object_PriceSite(inGoodsId := inId,
                                            inPrice   := ROUND (inPriceSite, 2),
                                            inDate    := CURRENT_DATE::TDateTime,
                                            inUserId  := vbUserId);
    


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.06.21                                                       *
*/

-- ����
-- select * from gpUpdate_GoodsSitePrice_SetPriceSite(inCodeSearch := '33460' , inGoodsSearch := '' , inID := 11649081 , inPriceOut := 111.33 ,  inSession := '3');