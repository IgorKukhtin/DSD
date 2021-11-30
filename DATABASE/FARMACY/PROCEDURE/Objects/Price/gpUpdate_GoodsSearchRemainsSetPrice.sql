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
   DECLARE vbPrice TFloat;
   DECLARE vbPriceMin TFloat;
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
    
/*    SELECT Price_Value.ValueData
    INTO vbPrice
    FROM ObjectLink AS ObjectLink_Price_Unit
         LEFT JOIN ObjectLink AS Price_Goods
                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
         LEFT JOIN ObjectFloat AS Price_Value
                               ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
    WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
      AND ObjectLink_Price_Unit.ChildObjectId = inUnitId    
      AND Price_Goods.ChildObjectId = inID;

    if inPriceOut < COALESCE(vbPrice,0)
    THEN
      SELECT tmp.PriceSaleMin
      INTO vbPriceMin
      FROM gpGet_GoodsPriceLastIncome(inUnitId := inUnitId , inGoodsId := inID ,  inSession := inSession) as tmp;
          
      IF COALESCE (vbPriceMin, 0) = 0
      THEN
        RAISE EXCEPTION '������. �� ������� ���� ���������� �������.';          
      END IF;

      IF inPriceOut < COALESCE (vbPriceMin, 0)
      THEN
        RAISE EXCEPTION '%', '��������!!!!!!'||Chr(13)||Chr(13)||
                             '���� ��� ������ ����� ��������� ��������, �� ��������� ������'||Chr(13)||
                             '��� ������� �� ������ ������������� �������� - 3%  �� ��������� ��������� ���� �� ��� �����'||Chr(13)||
                             '��� ������� , ������� ��� � ������� �� ������������� ����������  - 4,5% �� ��������� ��������� ���� �� ��� �����'||Chr(13)||Chr(13)||
                             '�� ����� '||zfConvert_FloatToString(vbPriceMin)||' ���. !!!!!!!!!!!!';          
      END IF;
    END IF;*/

    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%> <%>', inSession, inPriceOut, vbPrice, vbPriceMin;
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