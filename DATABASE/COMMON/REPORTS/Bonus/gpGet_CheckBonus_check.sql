-- Function: gpGet_CheckBonus_check()

DROP FUNCTION IF EXISTS gpGet_CheckBonus_check (Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_CheckBonus_check(
    IN inisDetail          Boolean   , -- �����������  ������� ������ ���, ����� ��������, Goods_Business, GoodsTag, GoodsGroupAnalyst
    IN inisGoods           Boolean   , -- ������� ����� + ��� ������
    IN inGoodsGroup        TVarChar  ,
   OUT outRez              TVarChar  ,
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
BEGIN

  IF COALESCE (inisDetail, FALSE) = TRUE OR COALESCE (inisGoods, FALSE) = TRUE OR COALESCE (inGoodsGroup,'') <> ''
  THEN
    RAISE EXCEPTION '������. ������ ��������� �������� ���������� ��������. �������� �����������.';
  END IF;
  outRez := 'Ok';

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.10.21         *
*/

-- ����
--