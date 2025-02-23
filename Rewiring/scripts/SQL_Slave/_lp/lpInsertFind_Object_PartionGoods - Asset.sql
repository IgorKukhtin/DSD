-- Function: lpInsertFind_Object_PartionGoods - Asset

-- DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inMovementId     Integer   , -- *������ - ��������
    IN inGoodsId        Integer   , -- *�������� �������� ��� �����
    IN inUnitId         Integer   , -- *������������� �������������
    IN inStorageId      Integer   , -- *����� ��������
    IN inInvNumber      TVarChar    -- *����������� �����
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
BEGIN

     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������ - ��������>.';
     END IF;
     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <�������� �������� ��� �����>.';
     END IF;

     -- ������ ��������
     IF COALESCE (inInvNumber, '') = ''
     THEN
         inInvNumber:= '0';
     END IF;

     -- ������� <���� ����� � ������������>
     vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId AND DescId = zc_Movement_EntryAsset());


     IF inMovementId > 0
     THEN 
             -- ������� �� ��-���:
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM Object
                                      INNER JOIN ObjectLink AS ObjectLink_Goods
                                                            ON ObjectLink_Goods.ObjectId      = Object.Id
                                                           AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                           AND ObjectLink_Goods.ChildObjectId = inGoodsId
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId = Object.Id
                                                           AND ObjectLink_Unit.DescId   = zc_ObjectLink_PartionGoods_Unit()
                                                           AND COALESCE (ObjectLink_Unit.ChildObjectId, 0) = COALESCE (inUnitId, 0)
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId = Object.Id
                                                           AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
                                                           AND COALESCE (ObjectLink_Storage.ChildObjectId, 0) = COALESCE (inStorageId, 0)
                                 WHERE Object.ObjectCode = inMovementId
                                   AND Object.ValueData  = inInvNumber
                                   AND Object.DescId     = zc_Object_PartionGoods()
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
                       '  inMovementId   := '||CASE WHEN NULLIF(inMovementId, 0) IS NULL THEN 'NULL' ELSE inMovementId::TEXT END||
                       ', inGoodsId   := '||CASE WHEN NULLIF(inGoodsId, 0) IS NULL THEN 'NULL' ELSE inGoodsId::TEXT END||
                       ', inUnitId   := '||CASE WHEN NULLIF(inUnitId, 0) IS NULL THEN 'NULL' ELSE inUnitId::TEXT END||
                       ', inStorageId   := '||CASE WHEN NULLIF(inStorageId, 0) IS NULL THEN 'NULL' ELSE inStorageId::TEXT END||
                       ', inInvNumber  := '||CASE WHEN inInvNumber IS NULL THEN 'NULL' ELSE ''''||inInvNumber::TEXT||'''' END||
                       ') AS ID') AS 
                         q(Id Integer);  

           IF COALESCE (vbPartionGoodsId, 0) = 0
           THEN
             RAISE EXCEPTION '������ ��������� ������ � ��������� �������';
           END IF;
             
         END IF;

         -- ��������� <������ - ��������> + <����������� �����>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), inMovementId, inInvNumber);
         -- ��������� <�������� ��������> ��� <�����>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, inGoodsId);

         -- ��������� <������������� �������������>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Unit(), vbPartionGoodsId, CASE WHEN inUnitId = 0 THEN NULL ELSE inUnitId END);
         -- ��������� <����� ��������>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Storage(), vbPartionGoodsId, CASE WHEN inStorageId = 0 THEN NULL ELSE inStorageId END);

         -- ��������� <���� ����� � ������������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, vbOperDate);

     END IF;

     -- ���������� ��������
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.08.16                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods ();