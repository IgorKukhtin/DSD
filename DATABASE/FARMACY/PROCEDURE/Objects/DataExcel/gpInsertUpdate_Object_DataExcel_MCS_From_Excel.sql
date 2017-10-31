-- Function: gpInsertUpdate_Object_DataExcel_MCS_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DataExcel_MCS_From_Excel (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DataExcel_MCS_From_Excel(
    IN inUnitId     Integer, -- ID �������������
    IN inGoodsCode  Integer, -- Code �����
    IN inMCSValue   TFloat,  -- ����������� �������� �����
    IN inSession    TVarChar -- ������ ������������
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId      Integer;
    DECLARE vbObjectId    Integer;
    DECLARE vbGoodsId     Integer;
BEGIN
    vbUserId := lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    vbGoodsId := 0;
    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� �������������';
    END IF;
    
    --�������� ����� �� ����
    SELECT Object_Goods.Id
           INTO vbGoodsId 
    FROM ObjectLink AS ObjectLink_Goods_Object
         INNER JOIN Object AS Object_Goods 
                           ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 
                          AND Object_Goods.ObjectCode = inGoodsCode
    WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId;
                             
    --���������, � ���� �� ����� ����� � ����
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION '������. � ���� ������ �� ������ ����� � ����� <%>', inGoodsCode;
    END IF;
    
    IF inMCSValue is not null AND (inMCSValue < 0)
    THEN
        RAISE EXCEPTION '������.����������� �������� ����� <%> �� ����� ���� ������ ����.', inMCSValue;
    END IF;

    PERFORM lpInsertUpdate_Object_DataExcel(inId       := COALESCE ((SELECT Object_DataExcel.Id 
                                                                     FROM Object AS Object_DataExcel
                                                                          INNER JOIN ObjectLink AS ObjectLink_Insert
                                                                                                ON ObjectLink_Insert.ObjectId = Object_DataExcel.Id
                                                                                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                                                                                               AND ObjectLink_Insert.ChildObjectId = vbUserId
                                                                     WHERE Object_DataExcel.DescId = zc_Object_DataExcel()
                                                                       AND Object_DataExcel.ObjectCode = 1
                                                                       AND Object_DataExcel.ValueData LIKE '%'||inUnitId||';'||vbGoodsId||'%')
                                                                   , 0)  ::Integer
                                          , inCode     := 1
                                          , inName     := (inUnitId||';'||vbGoodsId||';'||inMCSValue) :: TVarChar 
                                          , inUserId   := vbUserId
                                            )
    ;
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 30.10.17         *
*/

-- ����
-- select * from gpInsertUpdate_Object_DataExcel_MCS_From_Excel(inUnitId := 183292 , inGoodsCode := 10660 , inMCSValue := 1 ,  inSession := '3');
