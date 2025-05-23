-- Function: gpDelete_ObjectBoolean_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpDelete_ObjectBoolean_Goods_IsUpload(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_ObjectBoolean_Goods_IsUpload(
    IN inObjectId            Integer   ,    -- ��� ����������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
    IF COALESCE(inObjectId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� ����������';
    END IF;
    DELETE FROM ObjectBoolean
    WHERE
        DescId = zc_ObjectBoolean_Goods_IsUpload()
        AND
        ObjectId IN (
            Select DISTINCT 
                ObjectLink_Goods_Object.ObjectId
            FROM
                ObjectLink AS ObjectLink_Goods_Object
            WHERE
                ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                AND
                ObjectLink_Goods_Object.ChildObjectId = inObjectId);
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_ObjectBoolean_Goods_IsUpload(Integer, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 23.11.15                                                         *
*/