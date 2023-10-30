-- Function: gpUpdate_GoodsJson_isClose()

DROP FUNCTION IF EXISTS gpUpdate_GoodsJson_isClose(TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_GoodsJson_isClose(
    IN inJSON        TBlob      , -- json     
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  /*IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
    RAISE EXCEPTION '�������� �������� ��������� ������ ��������������.';
  END IF;*/
  
  IF COALESCE (inJSON, '') = '' OR COALESCE (inJSON, '') = '[]'
  THEN
    RAISE EXCEPTION '��� ������ ��� ���������.';
  END IF;
        
  /*IF inSession <> '3'
  THEN
    RAISE EXCEPTION '� ����������.';
  END IF;*/
  
  -- �� JSON � �������
  CREATE TEMP TABLE tblJSON
  (
     id           Integer,
     isclose      Boolean
  ) ON COMMIT DROP;

  INSERT INTO tblJSON
  SELECT *
  FROM json_populate_recordset(null::tblJSON, replace(replace(replace(inJSON, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
    
  -- raise notice 'Value 05: %', (select Count(*) from tblJSON);  

   -- !!!��� �������� �������������!!! �� "�����" Retail.Id
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Close(), Object_Goods_Retail.Id, NOT tblJSON.isclose)
   FROM tblJSON
   
        INNER JOIN Object_Goods_Retail AS tmpGoods ON tmpGoods.Id = tblJSON.Id
        INNER JOIN Object_Goods_Main   ON Object_Goods_Main.Id = tmpGoods.GoodsMainId
        INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id
   
   ;

   
   -- ��������� � ������� �������
   UPDATE Object_Goods_Main SET isClose = tmpGoods.isclose, DateUpdateClose = CURRENT_TIMESTAMP
   FROM (SELECT tmpGoods.GoodsMainId
              , NOT tblJSON.isclose    AS isclose
         FROM tblJSON
              INNER JOIN Object_Goods_Retail AS tmpGoods ON tmpGoods.Id = tblJSON.Id) AS tmpGoods
   WHERE Object_Goods_Main.ID = tmpGoods.GoodsMainId
     AND Object_Goods_Main.isClose <> tmpGoods.isclose;  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (tblJSON.Id, vbUserId)
   FROM tblJSON;
  
  --RAISE EXCEPTION '���������.';  
  

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.05.22                                                       *
*/

-- ���� 
  
select * from gpUpdate_GoodsJson_isClose(inJSON := '[{"id":22943088,"isclose":"True"},{"id":22943117,"isclose":"True"},{"id":22956967,"isclose":"False"},{"id":22962735,"isclose":"False"},{"id":22964244,"isclose":"True"},{"id":22986731,"isclose":"True"},{"id":23101618,"isclose":"True"},{"id":23107533,"isclose":"False"},{"id":23107561,"isclose":"False"},{"id":23112671,"isclose":"False"},{"id":23127062,"isclose":"True"}]' ,  inSession := '3');
