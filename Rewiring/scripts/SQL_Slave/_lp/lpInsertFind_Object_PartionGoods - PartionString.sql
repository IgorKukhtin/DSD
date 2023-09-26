-- Function: lpInsertFind_Object_PartionGoods - PartionString - �������� ����� + ������ ����� + "���������"

-- DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inValue  TVarChar -- *������ �������� ������
)
RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate       TDateTime;
   DECLARE vbPartnerId      Integer;
   DECLARE vbGoodsId        Integer;

   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
BEGIN
     -- ������ ��������
     inValue:= COALESCE (TRIM (inValue), '');

     -- ������� �� ��-���: ������ �������� ������ + ��� �������������(��� ����)
     IF inValue = ''
     THEN
     -- !!!��� ���� ������ ����� ����������� ������!!!
     vbPartionGoodsId:= (SELECT Object.Id
                         -- SELECT MIN (Object.Id)
                         FROM Object 
                              LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = Object.Id
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                   ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                  AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                         WHERE Object.ValueData  = inValue
                           AND Object.DescId     = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId              IS NULL -- �.�. ������ ��� ����� ��-��
                           AND ObjectLink_GoodsKindComplete.ObjectId IS NULL -- �.�. ������ ��� ����� ��-��
                        ); -- 80132
     ELSE
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object 
                              LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = Object.Id
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                   ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                  AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                         WHERE Object.ValueData  = inValue
                           AND Object.DescId     = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId              IS NULL -- �.�. ������ ��� ����� ��-��
                           AND ObjectLink_GoodsKindComplete.ObjectId IS NULL -- �.�. ������ ��� ����� ��-��
                        );
     END IF;

     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN

         -- ���� ���� ������������ �� ������� �� �������� ������� ���� ��� �� �������� �.�. ������
         IF _replica.zc_isUserRewiring() = TRUE
         THEN
           -- ���� �� �������� �������
           SELECT Host, DBName, Port, UserName, Password
           INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
           FROM _replica.gpSelect_MasterConnectParams(zfCalc_UserAdmin());  

           SELECT Q.Id
           INTO vbPartionGoodsId
           FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                       'SELECT lpInsertFind_Object_PartionGoods ('||
                       '  inValue  := '||CASE WHEN inValue IS NULL THEN 'NULL' ELSE ''''||inValue::TEXT||'''' END||
                       ') AS ID') AS 
                         q(Id Integer);  

           IF COALESCE (vbPartionGoodsId, 0) = 0
           THEN
             RAISE EXCEPTION '������ ��������� ������ � ��������� �������';
           END IF;
             
         END IF;

         -- ��������� <������ �������� ������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inValue);

         -- ��������� <���� ������>
         vbOperDate:= zfCalc_PartionGoods_OperDate (inValue);
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, vbOperDate);

         -- ��������� <�����������>
         vbPartnerId:= zfCalc_PartionGoods_PartnerCode (inValue);
         IF EXISTS (SELECT 1 FROM Object WHERE Object.ObjectCode = vbPartnerId AND Object.DescId = zc_Object_Partner() HAVING COUNT (*) > 1)
         THEN
             RAISE EXCEPTION '������.� ������ <%> �� ���������� ��� �����������.', inValue;
         END IF;
         IF EXISTS (SELECT 1 FROM Object WHERE Object.ObjectCode = vbPartnerId AND Object.DescId = zc_Object_Partner() HAVING COUNT (*) > 1)
         THEN
             RAISE EXCEPTION '������. ��� ���������� <%> ���������� � ������ ������������.<%>', vbPartnerId, inValue;
         END IF;
         vbPartnerId:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = vbPartnerId AND Object.DescId = zc_Object_Partner());
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Partner(), vbPartionGoodsId, vbPartnerId);

         -- ��������� <�����>
         vbGoodsId:= zfCalc_PartionGoods_GoodsCode (inValue);
         -- ��������
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ObjectCode = vbGoodsId AND Object.DescId = zc_Object_Goods())
         THEN
             RAISE EXCEPTION '������.������������ ������ � ������. <%> %', vbGoodsId, inValue;
         END IF;
         --
         vbGoodsId:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = vbGoodsId AND Object.DescId = zc_Object_Goods());
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, vbGoodsId);
 
     END IF;

     -- ���������� ��������
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.08.14                                        * add !!!��� ���� ������ ����� ����������� ������!!!
 26.07.14                                        * add zc_ObjectLink_PartionGoods_Unit
 20.07.13                                        * vbOperDate
 19.07.13         *  rename zc_ObjectDate_              
 12.07.13                                        * �������� �� 2 ����-��
 02.07.13                                        * ������� Find, ����� ���� ���� Insert
 02.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= 'Test_PartionGoods');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= NULL);