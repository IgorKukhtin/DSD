-- Function: lpInsertFind_Object_PartionGoods - PartionDate - NEW - ������ + ��������� + ������� ��������� + ��/�� � ����

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inOperDate              TDateTime, -- *���� ������
    IN inGoodsKindId_complete  Integer    -- *��� �������� ��(��) ����������� �� ����� ��� �� ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate_str   TVarChar;
BEGIN
     -- ������ ��������
     IF inOperDate = zc_DateEnd()
     THEN
         vbOperDate_str:= '';
         inOperDate:= NULL;
     ELSE
         -- ����������� � �������
         vbOperDate_str:= COALESCE (TO_CHAR (inOperDate, 'DD.MM.YYYY'), '');
     END IF;

     -- ������ ���� NULL
     inGoodsKindId_complete:=  CASE WHEN inGoodsKindId_complete <> 0 THEN inGoodsKindId_complete ELSE zc_GoodsKind_Basis() END;

     -- ������� �� ��-���: ������ �������� ������ + ��� ������(������� ���������)
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object
                              INNER JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                    ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                   AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                                   AND ObjectLink_GoodsKindComplete.ChildObjectId = inGoodsKindId_complete
                         WHERE Object.ValueData = vbOperDate_str
                           AND Object.DescId = zc_Object_PartionGoods()
                        );

     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ��������� <������ �������� ������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbOperDate_str);

         -- ��������� <��� ������(������� ���������)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_GoodsKindComplete(), vbPartionGoodsId, inGoodsKindId_complete);

         IF vbOperDate_str <> ''
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
ALTER FUNCTION lpInsertFind_Object_PartionGoods (TDateTime, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.15                                        * add inGoodsKindId_complete
 03.08.14                                        * add !!!��� ���� ������ ����� ����������� ������!!!
 26.07.14                                        * add zc_ObjectLink_PartionGoods_Unit
 20.07.13                                        * vbOperDate_str
 19.07.13         * rename zc_ObjectDate_            
 12.07.13                                        * �������� �� 2 ����-��
 02.07.13                                        * ������� Find, ����� ���� ���� Insert
 02.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2013', inGoodsKindId_complete:= zc_GoodsKind_Basis());
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= NULL, inGoodsKindId_complete:= zc_GoodsKind_Basis());