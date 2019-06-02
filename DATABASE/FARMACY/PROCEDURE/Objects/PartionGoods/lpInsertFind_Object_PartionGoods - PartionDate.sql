-- Function: lpInsertFind_Object_PartionGoods - PartionDate

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, TDateTime);
DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, TDateTime, TFloat, TFloat);
DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, TDateTime, Integer, TFloat, TFloat);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inMovementId       Integer,   --
    IN inOperDate         TDateTime, -- ���� "���� ��������" - ExpirationDate
    IN inGoodsId          Integer,   --
    IN inChangePercentMin TFloat,    -- % ������(���� ������ ������)
    IN inChangePercent    TFloat     -- % ������(���� �� 1 ��� �� 6 ���)
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionGoodsId      Integer;
   DECLARE vbPartionGoodsId_find Integer;
   DECLARE vbOperDate_str        TVarChar;
BEGIN
     -- ������ ��������
     IF COALESCE (inOperDate, zc_DateEnd()) = zc_DateEnd()
     THEN
         vbOperDate_str:= '';
         inOperDate:= NULL;
     ELSE
         -- ����������� � �������
         vbOperDate_str:= COALESCE (TO_CHAR (inOperDate, 'DD.MM.YYYY'), '');
     END IF;


     -- ������� �� ��-���: ������ �������� ������ + ��� ������(������� ���������)
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object
                              INNER JOIN ObjectLink AS ObjectLink_Goods
                                                    ON ObjectLink_Goods.ObjectId      = Object.Id
                                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                   AND ObjectLink_Goods.ChildObjectId = inGoodsId
                              LEFT JOIN ObjectFloat AS ObjectFloat_ValueMin
                                                    ON ObjectFloat_ValueMin.ObjectId  = Object.Id
                                                   AND ObjectFloat_ValueMin.DescId    = zc_ObjectFloat_PartionGoods_ValueMin()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                    ON ObjectFloat_Value.ObjectId  = Object.Id
                                                   AND ObjectFloat_Value.DescId    = zc_ObjectFloat_PartionGoods_Value()
                         WHERE Object.ObjectCode = inMovementId
                           AND Object.ValueData  = vbOperDate_str
                           AND Object.DescId     = zc_Object_PartionGoods()
                           AND COALESCE (ObjectFloat_ValueMin.ValueData, 0) = inChangePercentMin
                           AND COALESCE (ObjectFloat_Value.ValueData, 0)    = inChangePercent
                        );

     -- �������� ��� � inGoodsId + inMovementId - ���� ��� ����� ����, inChangePercentMin + inChangePercent ������ ���������������
     /*vbPartionGoodsId_find:= (SELECT Object.Id
                              FROM Object
                                   INNER JOIN ObjectLink AS ObjectLink_Goods
                                                         ON ObjectLink_Goods.ObjectId      = Object.Id
                                                        AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                        AND ObjectLink_Goods.ChildObjectId = inGoodsId
                              WHERE Object.ObjectCode = inMovementId
                                AND Object.DescId     = zc_Object_PartionGoods()
                             );
     -- ��������
     IF vbPartionGoodsId_find > 0 AND COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������. ��� ������ <%> � ������� = � <%> �� <%> � ���� �������� = <%> ������� ������ ������ ���� = <%> � <%>. (%)(%)(%)(%)(%)'
                        , lfGet_Object_ValueData (inGoodsId)
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                        , zfConvert_DateToString ((SELECT Movement.OperDate  FROM Movement WHERE Movement.Id = inMovementId))
                        , zfConvert_DateToString ((SELECT OD.ValueData FROM ObjectDate AS OD WHERE OD.ObjectId = vbPartionGoodsId_find AND OD.DescId = zc_ObjectDate_PartionGoods_Value()))
                        , COALESCE((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = vbPartionGoodsId_find AND OFl.DescId = zc_ObjectFloat_PartionGoods_ValueMin()), 0)
                        , COALESCE((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = vbPartionGoodsId_find AND OFl.DescId = zc_ObjectFloat_PartionGoods_Value()), 0)
                        , inGoodsId, inMovementId, inChangePercentMin, inChangePercent, vbOperDate_str
                        ;
         
     END IF;*/


     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ���� ����� �� "��������" ����������, ����� ����� UPDATE
         IF vbPartionGoodsId_find > 0 THEN vbPartionGoodsId:= vbPartionGoodsId_find; END IF;
         
         -- ��������� <������ �������� ������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), inMovementId, vbOperDate_str);

         -- ��������� <�����>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, inGoodsId);

         -- ���������
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, inOperDate);

         -- ��������� - % ������(���� ������ ������)
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_ValueMin(), vbPartionGoodsId, inChangePercentMin);

         -- ��������� - % ������(���� �� 1 ��� �� 6 ���)
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Value(), vbPartionGoodsId, inChangePercent);

     END IF;

     -- ���������� ��������
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.04.19                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inMovementId:= 1, inOperDate:= NULL);
