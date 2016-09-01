-- Function: lpInsertFind_Object_PartionGoods - PartionDate - ������ + ��������� + ������� ��������� + ��/�� � ����

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inOperDate  TDateTime -- *���� ������
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

     -- ������� �� ��-���: ������ �������� ������ + ��� ������(������� ���������)
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object
                              INNER JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                    ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                   AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                                   AND ObjectLink_GoodsKindComplete.ChildObjectId = zc_GoodsKind_Basis()
                         WHERE Object.ValueData = vbOperDate_str
                           AND Object.DescId = zc_Object_PartionGoods()
                        );

     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ��������� <������ �������� ������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbOperDate_str);

         -- ��������� <��� ������(������� ���������)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_GoodsKindComplete(), vbPartionGoodsId, zc_GoodsKind_Basis());

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
 03.08.14                                        * add !!!��� ���� ������ ����� ����������� ������!!!
 26.07.14                                        * add zc_ObjectLink_PartionGoods_Unit
 20.07.13                                        * vbOperDate_str
 19.07.13         * rename zc_ObjectDate_            
 12.07.13                                        * �������� �� 2 ����-��
 02.07.13                                        * ������� Find, ����� ���� ���� Insert
 02.07.13         *
*/

/*
-- !!!������!!!
-- SELECT Movement.Id
SELECT Movement.DescId, Object_From.ValueData, Object_From.Id, Object_To.ValueData, Object_To.Id, min (MovementItem.ObjectId) , max (MovementItem.ObjectId)
-- SELECT  min (Movement.StatusId), max (Movement.StatusId)
FROM MovementItemContainer
 join Movement on Movement.Id = MovementId 
and Movement.DescId = 6
            LEFT JOIN MovementItem on MovementItem.Id = MovementItemId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
-- and 1=0
where ContainerId in (SELECT ContainerId FROM ContainerLinkObject where ObjectId in (
                         SELECT Object .Id
                         FROM Object 
                              LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = Object.Id
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                         WHERE Object.ValueData = ''
                           AND Object.DescId = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId IS NULL
                           and Object.Id <> 80132
)
)
-- where  Object_From.Id = 8423 and MovementItem.ObjectId = 
group by Movement.DescId, Object_From.ValueData, Object_From.Id, Object_To.ValueData, Object_To.Id
-- group by Movement.Id;
*/
-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2013');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= NULL);