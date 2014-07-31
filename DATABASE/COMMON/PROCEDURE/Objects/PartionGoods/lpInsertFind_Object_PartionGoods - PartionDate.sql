-- Function: lpInsertFind_Object_PartionGoods (TDateTime)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inOperDate  TDateTime -- ���� ������
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

     -- ������� �� ��-���: ������ �������� ������ + ��� �������������(��� ����)
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object
                              INNER JOIN ObjectLink AS ObjectLink_Unit
                                                    ON ObjectLink_Unit.ObjectId = Object.Id
                                                   AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                         WHERE Object.ValueData = vbOperDate_str
                           AND Object.DescId = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId IS NULL
                        );

     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ��������� <������ �������� ������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbOperDate_str);

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
ALTER FUNCTION lpInsertFind_Object_PartionGoods (TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.07.14                                        * add zc_ObjectLink_PartionGoods_Unit
 20.07.13                                        * vbOperDate_str
 19.07.13         * rename zc_ObjectDate_            
 12.07.13                                        * �������� �� 2 ����-��
 02.07.13                                        * ������� Find, ����� ���� ���� Insert
 02.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2013');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= NULL);