-- Function: lpInsertFind_Object_PartionGoods - PartionString - ����������

-- DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inValue        TVarChar  , -- *������ �������� ������
    IN inOperDate     TDateTime , -- 
    IN inInfoMoneyId  Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionGoodsId Integer;

   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
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
                       ', inOperDate  := '||CASE WHEN inOperDate IS NULL THEN 'NULL' ELSE ''''||zfConvert_DateToString(inOperDate)::TEXT||'''' END||
                       ', inInfoMoneyId   := '||CASE WHEN NULLIF(inInfoMoneyId, 0) IS NULL THEN 'NULL' ELSE inInfoMoneyId::TEXT END||
                       ') AS ID') AS 
                         q(Id Integer);  

           IF COALESCE (vbPartionGoodsId, 0) = 0
           THEN
             RAISE EXCEPTION '������ ��������� ������ � ��������� �������';
           END IF;
             
         END IF;

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