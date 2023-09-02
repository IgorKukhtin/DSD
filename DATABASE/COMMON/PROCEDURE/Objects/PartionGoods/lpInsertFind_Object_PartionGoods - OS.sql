-- Function: lpInsertFind_Object_PartionGoods - InvNumber - ��: ���� + ...

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TDateTime, TFloat);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inUnitId_Partion Integer   , -- *�������������(��� ����)
    IN inGoodsId        Integer   , -- *�����
    IN inStorageId      Integer   , -- *����� ��������
    IN inPartionModelId Integer   , -- ������
    IN inInvNumber      TVarChar  , -- *����������� �����
    IN inPartNumber     TVarChar  , -- *�������� �����(� �� ��� ��������)
    IN inOperDate       TDateTime , -- *���� �����������
    IN inPrice          TFloat      -- ����
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
BEGIN
     -- � ���� ������ ������ �� �����
   /*IF inOperDate < '01.05.2017' OR (COALESCE (inUnitId_Partion, 0) = 0 AND COALESCE (inGoodsId, 0) = 0)
     THEN
         -- RETURN (80132); -- !!!������ ������!!!
         RETURN (0);
     END IF;*/


     -- RAISE EXCEPTION '������.���� �� �����������.';

     -- ��������
     /*IF COALESCE (TRIM (inInvNumber), '') = ''
     THEN
         RAISE EXCEPTION '������.� ������ �� ��������� <����������� �����>.';
     END IF;*/
     -- ��������
     IF COALESCE (TRIM (inInvNumber), '') = '' AND COALESCE (TRIM (inPartNumber), '') = '' 
     THEN
         RAISE EXCEPTION '������.� ������ �� ���������� <����������� �����> ��� <�������� �����>.������ ���� ������� ���� �� ���� ��������.';
     END IF;

     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.� ������ �� ��������� <�����>.';
     END IF;
     -- ��������
     IF COALESCE (inStorageId, 0) = 0
     THEN
         RAISE EXCEPTION '������.� ������ �� ���������� <����� ��������>.';
     END IF;

     -- �������� - ���� ���
     IF COALESCE (inUnitId_Partion, 0) = 0 AND 1=0
     THEN
         RAISE EXCEPTION '������.� ������ �� ���������� <���������������>.';
     END IF;
     -- �������� - ���� �����
     IF (inOperDate IS NULL OR inOperDate IN (zc_DateStart(), zc_DateEnd())) AND inUnitId_Partion > 0
     THEN
         RAISE EXCEPTION '������.� ������ ��� <%> �� ���������� <���� �����������>.', lfGet_Object_ValueData (inGoodsId);
     END IF;

     -- ������ ��������
     IF COALESCE (TRIM (inInvNumber), '') = ''
     THEN
         inInvNumber:= '0';
     END IF;


     -- ������ �������� - !!!�������� ����� 1 ������ � ����� - ��������� ����!!!
     inOperDate:= DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';


     IF COALESCE (inStorageId, 0) = 0
     THEN
         -- ���� ���� ����������� �����
         IF inInvNumber <> '0'
         THEN
             -- ������� �� ��-���: ����� + ���� ����������� + ����������� ����� + ����� ����� + ����� ��������=NULL
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM ObjectLink AS ObjectLink_Goods
                                      INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                           AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                           AND ObjectDate.ValueData = inOperDate
                                      -- �� ����������� �����
                                      INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                       AND Object.ValueData = inInvNumber
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                           AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                           AND ObjectLink_Storage.ChildObjectId IS NULL
                                 WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                );

         ELSE
             -- ������� �� ��-���: ����� + ���� ����������� + �������� ����� + ����� ����� + ����� ��������=NULL
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM ObjectLink AS ObjectLink_Goods
                                      -- �� �������� �����(� �� ��� ��������)
                                      INNER JOIN ObjectString ON ObjectString.ObjectId  = ObjectLink_Goods.ObjectId
                                                             AND ObjectString.DescId    = zc_ObjectString_PartionGoods_PartNumber()
                                                             AND ObjectString.ValueData = inPartNumber
                                      INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                           AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                           AND ObjectDate.ValueData = inOperDate
                                      -- ����������� �����
                                      INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                       -- ��� �������� ����������� �����
                                                       -- AND Object.ValueData = inInvNumber
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                           AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                           AND ObjectLink_Storage.ChildObjectId IS NULL
                                 WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                );
         END IF;

     ELSE
         -- ���� ���� ����������� �����
         IF inInvNumber <> '0'
         THEN
             -- ������� �� ��-���: ����� + ���� ����������� + ����������� ����� + ����� ����� + ����� ��������
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM ObjectLink AS ObjectLink_Goods
                                      INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                           AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                         --AND ObjectDate.ValueData = inOperDate
                                      -- �� ����������� �����
                                      INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                       AND Object.ValueData = inInvNumber
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                         --AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                           AND ObjectLink_Storage.ChildObjectId = inStorageId
                                 WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                   AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()
                                   AND (ObjectLink_Unit.ChildObjectId = inUnitId_Partion OR (COALESCE (inUnitId_Partion, 0) = 0 AND ObjectLink_Unit.ChildObjectId IS NULL))
                                   AND (ObjectDate.ValueData          = inOperDate       OR (COALESCE (inUnitId_Partion, 0) = 0 AND ObjectDate.ValueData IS NULL))
                                );
         ELSE
             -- ������� �� ��-���: ����� + ���� ����������� + �������� ����� + ����� ����� + ����� ��������
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM ObjectLink AS ObjectLink_Goods
                                      -- �� �������� �����(� �� ��� ��������)
                                      INNER JOIN ObjectString ON ObjectString.ObjectId  = ObjectLink_Goods.ObjectId
                                                             AND ObjectString.DescId    = zc_ObjectString_PartionGoods_PartNumber()
                                                             AND ObjectString.ValueData = inPartNumber
                                      INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                           AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                         --AND ObjectDate.ValueData = inOperDate
                                      -- ����������� �����
                                      INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                       -- ��� �������� ����������� �����
                                                       -- AND Object.ValueData = inInvNumber
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                         --AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                           AND ObjectLink_Storage.ChildObjectId = inStorageId
                                 WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                   AND (ObjectLink_Unit.ChildObjectId = inUnitId_Partion OR (COALESCE (inUnitId_Partion, 0) = 0 AND ObjectLink_Unit.ChildObjectId IS NULL))
                                   AND (ObjectDate.ValueData          = inOperDate       OR (COALESCE (inUnitId_Partion, 0) = 0 AND ObjectDate.ValueData IS NULL))
                                );
         END IF;
     END IF;

     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ��������� <����������� �����>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inInvNumber);

         -- ��������� <�������������(��� ����)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Unit(), vbPartionGoodsId, CASE WHEN inUnitId_Partion > 0 THEN inUnitId_Partion ELSE NULL END);
         -- ��������� <�����>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, inGoodsId);
         -- ��������� <����� ��������>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Storage(), vbPartionGoodsId, CASE WHEN inStorageId > 0 THEN inStorageId ELSE NULL END);

         -- ��������� <�������� �����(� �� ��� ��������)>
         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PartionGoods_PartNumber(), vbPartionGoodsId
                                            , CASE WHEN TRIM (inPartNumber) <> ''
                                                        THEN TRIM (inPartNumber)
                                                   ELSE COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbPartionGoodsId AND OS.DescId = zc_ObjectString_PartionGoods_PartNumber()), '')
                                              END
                                            );
         -- ��������� <������ (������ �����)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_PartionModel(), vbPartionGoodsId, inPartionModelId);

         -- ��������� <���� �����������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, CASE WHEN inUnitId_Partion > 0 THEN inOperDate ELSE NULL END);
         -- ��������� <����>
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Price(), vbPartionGoodsId, COALESCE (inPrice, 0));

     ELSEIF TRIM (inPartNumber) <> ''
     THEN
         -- ��������� <�������� �����(� �� ��� ��������)>
         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PartionGoods_PartNumber(), vbPartionGoodsId, TRIM (inPartNumber));
     
         -- ��������� <������ (������ �����)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_PartionModel(), vbPartionGoodsId, inPartionModelId);

     ELSEIF inPartionModelId > 0
     THEN
         -- ��������� <������ (������ �����)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_PartionModel(), vbPartionGoodsId, inPartionModelId);

     END IF;

     -- ���������� ��������
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.07.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods ();
