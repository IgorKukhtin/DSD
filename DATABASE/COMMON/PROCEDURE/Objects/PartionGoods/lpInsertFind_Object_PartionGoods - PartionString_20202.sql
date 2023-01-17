-- Function: lpInsertFind_Object_PartionGoods - PartionString - ����������

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inValue        TVarChar  , -- *������ �������� ������
    IN inOperDate     TDateTime , -- 
    IN inInfoMoneyId  Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
BEGIN
     -- ������ ��������
     inValue:= COALESCE (TRIM (inValue), '');

     -- ��������
     IF COALESCE (inInfoMoneyId, 0) <> zc_Enum_InfoMoney_20202()
     THEN
         RAISE EXCEPTION '������.�� ��������� ����� <%>.', lfGet_Object_ValueData_sh (zc_Enum_InfoMoney_20202());
     END IF;

     -- ��������
     IF inValue = ''
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������>.';
     END IF;


     -- ������� �� ��-���: ������ �������� ������ + ��� �������������(��� ����)
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object 
                              LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = Object.Id
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                   ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                  AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                         WHERE Object.ValueData = inValue
                           AND Object.DescId = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId              IS NULL -- �.�. ������ ��� ����� ��-��
                           AND ObjectLink_GoodsKindComplete.ObjectId IS NULL -- �.�. ������ ��� ����� ��-��
                        );

     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ��������� <������ �������� ������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inValue);

         IF inOperDate > zc_DateStart()
         THEN
             -- ��������� <���� ������>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, inOperDate);
         END IF;

     END IF;

     -- ���������� ��������
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.01.21                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= 'Test_PartionGoods');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= NULL);