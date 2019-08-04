-- Function: gpUpdate_GoodsSearchRemainsSetPrice()

DROP FUNCTION IF EXISTS gpUpdate_GoodsSearchRemainsSetPrice (integer, integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_GoodsSearchRemainsSetPrice(
    IN inID             integer,     -- �����
    IN inUnitID         integer,     -- �������������
    IN inPriceOut       TFloat,      -- ����
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
                  WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
    THEN
      RAISE EXCEPTION '������. ��������� ���������� ��� ���������.';
    END IF;

    IF COALESCE (inID, 0) = 0
    THEN
        RAISE EXCEPTION '������. �� ������ �����';
    END IF;

    IF COALESCE (inPriceOut, 0) <= 0
    THEN
        RAISE EXCEPTION '������. ���� ������ ���� ������ ����';
    END IF;

    PERFORM lpInsertUpdate_Object_Price(inGoodsId := inId,
                                        inUnitId  := inUnitID,
                                        inPrice   := ROUND (inPriceOut, 2),
                                        inDate    := CURRENT_DATE::TDateTime,
                                        inUserId  := vbUserId);
    


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.07.19                                                       *
*/

-- ����
-- select * from gpUpdate_GoodsSearchRemainsSetPrice(inCodeSearch := '33460' , inGoodsSearch := '' , inID := 11649081 , inPriceOut := 111.33 ,  inSession := '3');
