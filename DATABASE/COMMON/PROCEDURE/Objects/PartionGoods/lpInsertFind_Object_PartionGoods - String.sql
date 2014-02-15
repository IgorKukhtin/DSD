-- Function: lpInsertFind_Object_PartionGoods (TVarChar)

-- DROP FUNCTION lpInsertFind_Object_PartionGoods (TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inValue  TVarChar -- ������ �������� ������
)
RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate       TDateTime;
   DECLARE vbPartnerId      Integer;
   DECLARE vbGoodsId        Integer;
   DECLARE vbValue          TVarChar;
BEGIN
   
     -- ������������ NULL
     vbValue:= COALESCE (inValue, '');

     -- ������� 
     vbPartionGoodsId:= (SELECT Id FROM Object WHERE ValueData = vbValue AND DescId = zc_Object_PartionGoods());

     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ��������� <������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbValue);
         -- ���������
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, vbOperDate);
         -- ���������
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Partner(), vbPartionGoodsId, vbPartnerId);
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, vbGoodsId);
     END IF;

     -- ���������� ��������
     RETURN (vbPartionGoodsId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.13                                        * vbOperDate
 19.07.13         *  rename zc_ObjectDate_              
 12.07.13                                        * �������� �� 2 ����-��
 02.07.13                                        * ������� Find, ����� ���� ���� Insert
 02.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= 'Test_PartionGoods');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= NULL);