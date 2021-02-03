-- Function: lfGet_Object_PartionGoods_InvNumber (Integer) - ������ ����������� �����: ���� ����������� ����� �� ���������� � ��� ����������� �� ��

DROP FUNCTION IF EXISTS lfGet_Object_PartionGoods_InvNumber (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_PartionGoods_InvNumber (
 inGoodsId   Integer     -- 
)
  RETURNS TVarChar
AS
$BODY$
DECLARE
  vbInvNumber Integer;
BEGIN

     IF EXISTS (SELECT GoodsId FROM Object_Goods_View WHERE GoodsId = inGoodsId AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300()) -- ����
     THEN
         vbInvNumber:= (SELECT MAX (zfConvert_StringToNumber (tmpObject.InvNumber)) AS InvNumber
                        FROM (SELECT Object.ValueData AS InvNumber
                             FROM ObjectLink AS ObjectLink_Unit
                                  INNER JOIN Object ON Object.Id = ObjectLink_Unit.ObjectId
                             WHERE ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                            ) AS tmpObject
                       );
         --
         vbInvNumber:= COALESCE (vbInvNumber, 0) + 1;

     ELSE
         vbInvNumber:= '0';
     END IF;

     --
     RETURN (vbInvNumber :: TVarChar);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_Object_PartionGoods_InvNumber (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.07.14                                        *                            
*/

-- ����
-- SELECT * FROM lfGet_Object_PartionGoods_InvNumber (0)
