-- Function: lpInsertFind_Object_PartionGoods - PartionDate + PartionCell - ������ + ��������� + ������� ���������

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inOperDate              TDateTime , -- *���� ������
    IN inGoodsKindId_complete  Integer   , -- ����������� ��������, �.�. ����� ��������� ������������ � ������ ����
    IN inPartionCellId         Integer     --
)
RETURNS Integer
AS
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

     -- ������
     --inPartionCellId:= 0;


     IF inPartionCellId > 0
     THEN
         -- ������� �� ��-���: ������ �������� ������ + PartionCell
         vbPartionGoodsId:= (SELECT Object.Id
                             FROM Object
                                  INNER JOIN ObjectLink AS ObjectLink_PartionCell
                                                        ON ObjectLink_PartionCell.ObjectId      = Object.Id
                                                       AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                                                       AND ObjectLink_PartionCell.ChildObjectId = inPartionCellId
                             WHERE Object.ValueData = vbOperDate_str
                               AND Object.DescId = zc_Object_PartionGoods()
                            );
     ELSE
         -- ������� �� ��-���: ������ �������� ������ + ������ PartionCell
         vbPartionGoodsId:= (SELECT Object.Id
                             FROM Object
                                  INNER JOIN ObjectLink AS ObjectLink_PartionCell
                                                        ON ObjectLink_PartionCell.ObjectId      = Object.Id
                                                       AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                                                       AND ObjectLink_PartionCell.ChildObjectId IS NULL
                             WHERE Object.ValueData = vbOperDate_str
                               AND Object.DescId = zc_Object_PartionGoods()
                            );
     END IF;

     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ��������� <������ �������� ������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbOperDate_str);

         -- ��������� <PartionCell>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_PartionCell(), vbPartionGoodsId, CASE WHEN inPartionCellId > 0 THEN inPartionCellId ELSE NULL END);

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

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.24                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2024', inPartionCellId:= 5);
